import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/model/model.dart';
import 'package:dio/dio.dart';
import 'package:ubihrm/global.dart';
import 'dart:convert';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/painting.dart';
import 'dart:io';

//import 'package:http/http.dart' as http;



//////////////////// SERVICE TO REQUEST FOR LEAVE /////////////////////

requestLeave(Leave leave) async{
  Dio dio = new Dio();
  try {
    //print(leave.orgid);
    //print(leave.uid);
    //print(leave.leavefrom);
    //print(leave.leaveto);
    //print(leave.leavetypefrom);
    //print(leave.leavetypeto);
    //print(leave.halfdayfromtype);
    //print(leave.halfdaytotype);
    //print(leave.leavetypeid);
    //print(leave.reason);
  //  print(leave.substituteemp);

    FormData formData = new FormData.from({
      "orgid": leave.orgid,
      "uid": leave.uid,
      "leavefrom": leave.leavefrom,
      "leaveto": leave.leaveto,
      "leavetypefrom": leave.leavetypefrom,
      "leavetypeto": leave.leavetypeto,
      "halfdayfromtype": leave.halfdayfromtype,
      "halfdaytotype": leave.halfdaytotype,
      "leavetypeid": leave.leavetypeid,
      "reason": leave.reason,
      "substituteemp": leave.substituteemp
    });

    Response response1 = await dio.post(path_hrm_india+"reqForLeave", data: formData);
  //  print("xxxxxxxxxx"+response1.toString());
  //  print("******************");
  //  print(response1.statusCode);
    // final leaveMap = json.decode(response1.toString());
    final leaveMap = response1.data.toString();
    // print("-------ddddddddd"+leaveMap["status"]);


    // if (response1.statusCode == 200) {
    // print("yyyyyyyyy"+leaveMap);
    //  print("yyyyyyyyy"+response1.toString());
    if (leaveMap.contains("false")) {
      //  print("false--->" + response1.data.toString());
      return "false";
    }
    else if (leaveMap.contains("wrong"))
    {
      return "wrong";
    }
    /*else if (leaveMap.contains("wrong1"))
    {
      return "wrong1";
    }*/
    else if (leaveMap.contains("alreadyApply"))
    {
      return "alreadyApply";
    }
    else {
      // print("true---" + response1.data.toString());
      return "true";
    }
  }
  //}
  catch(e){
    //print(e.toString());
    return "No Connection";
  }
}

Future<List<Leave>> getLeaveSummary() async{
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  try {
    FormData formData = new FormData.from({
      "uid": empid,
    });
    //Response response = await dio.post("https://sandbox.ubiattendance.com/index.php/services/getInfo", data: formData);
    Response response = await dio.post(
        path+"getLeaveList",
        data: formData);
    //print(response.data.toString());
    //print('--------------------getLeaveSummary Called-----------------------');
    List responseJson = json.decode(response.data.toString());
  /*  print("LEAVE LIST");
  //  print(userList);
    print(response.data.toString());
    print("LEAVE LIST");*/
    List<Leave> userList = createLeaveList(responseJson);

    return userList;

  }catch(e){
    //print(e.toString());
  }
}

List<Leave> createLeaveList(List data){
  List<Leave> list = new List();
  for (int i = 0; i < data.length; i++) {
    String LeaveDate = data[i]["date"];
    String LeaveFrom=data[i]["from"];
    String LeaveTo=data[i]["to"];
    String LeaveDays=data[i]["days"];
    String Reason=data[i]["reason"];
    String ApprovalSts=data[i]["status"];
    String ApproverComment=data[i]["comment"];
    String LeaveId=data[i]["leaveid"];
    bool withdrawlsts=data[i]["withdrawlsts"];
//    print(LeaveFrom+"@@@@@@@"+LeaveTo);
    if(LeaveFrom==LeaveTo){
      LeaveTo=" - "+LeaveFrom;
    }
    else{
      LeaveTo=" - "+LeaveTo;
    }
 //    print(LeaveDate);
    Leave leave = new Leave(attendancedate: LeaveDate, leavefrom: LeaveFrom, leaveto: LeaveTo, leavedays: LeaveDays, reason: Reason, approverstatus: ApprovalSts, comment: ApproverComment, leaveid: LeaveId, withdrawlsts: withdrawlsts);
    list.add(leave);
   /* print("LEAVE LIST");
    print(list);
    print("LEAVE LIST");*/
  }
  return list;
}
///////////////////////////
///////////////////////////////// SERVICE TO WIDRAWL LEAVE /////////////////////////////////
//////////////////////////////

withdrawLeave(Leave leave) async{
  Dio dio = new Dio();
  try {
    FormData formData = new FormData.from({
      "leaveid": leave.leaveid,
      "uid": leave.uid,
      "orgid": leave.orgid,
      "leavests": leave.approverstatus
    });
    //Response response = await dio.post("https://sandbox.ubiattendance.com/index.php/services/getInfo", data: formData);
    Response response = await dio.post(
        path_hrm_india+"changeleavests",
        data: formData);
    //print(response.toString());
    if (response.statusCode == 200) {
      Map leaveMap = json.decode(response.data);
      if(leaveMap["status"]==true){
        return "success";
      }else{
        return "failure";
      }
    }else{
      return "No Connection";
    }
  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }
}



Future<List<Map>> getleavetype(int label) async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  final response = await dio.post(path + "getEmployeeAllLeaveType?orgid=$orgdir&eid=$empid");
  //print("leavetype11----------->");
  // print(response);
  List data = json.decode(response.data.toString());
  print("leavetype----------->");
print(data);
  List<Map> leavetype = createList(data,label);
  return leavetype;
}
List<Map> createList(List data,int label) {
  List<Map> list = new List();
  if(label==1) // with -All- label
    list.add({"Id":"0","Name":"-All-"});
  else
    list.add({"Id":"0","Name":"-Select-"});
  // print("666666666");
  // print(data);
  for (int i = 0; i < data.length; i++) {
    //  if(data[i]["archive"].toString()=='1') {
    // print("kkkkkkk"+data[i]["name"].toString());
    Map tos={"Name":data[i]["name"].toString()  +" ("+data[i]["leftleave"].toString()+" Remaining ) " ,"Id":data[i]["id"].toString()};
    list.add(tos);
    // }
  }
  return list;
}
/////////Substitute Employee dropdowns///////
Future<List<Map>> getsubstitueemp(int label) async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  final response = await dio.post(path + "getEmployeeHierarchy?orgid=$orgdir&eid=$empid");
  //print("leavetype11----------->");
  // print(response);
  List data = json.decode(response.data.toString());
  // print("leavetype----------->");
//  print(data);
  List<Map> substituteemp = createsubstituteempList(data,label);
  return substituteemp;
}
List<Map> createsubstituteempList(List data,int label) {
  List<Map> list = new List();
  if(label==1) // with -All- label
    list.add({"Id":"0","Name":"-All-"});
  else
    list.add({"Id":"0","Name":"-Select-"});
  // print("666666666");
  // print(data);
  for (int i = 0; i < data.length; i++) {
    //  if(data[i]["archive"].toString()=='1') {
    // print("kkkkkkk"+data[i]["name"].toString());
    Map tos={"Name":data[i]["name"].toString(),"Id":data[i]["id"].toString()};
    list.add(tos);

    // }
  }
  return list;
}



class LeaveH {
  String Id;
  String name;
  String Entitle;
  String Used;
  String Left;
  LeaveH(
      { this.Id,
        this.name,
        this.Entitle,
        this.Used,
        this.Left,
      });
}
Future<List<LeaveH>> getleavehistory(LeaveTypeId) async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  final response = await dio.post(path + 'getEmployeeAllLeaveTypeForMail?orgid=$orgdir&empid=$empid&leavetypeid=$LeaveTypeId');
  // print("leavetype22----------->");
  // print(response);
  List data = json.decode(response.data.toString());
  // print("leavetype----------->");
  // print(data);
  List<LeaveH> leavetype = createleavehistory(data);
  return leavetype;
}



List<LeaveH> createleavehistory(List data) {

  List<LeaveH> list = new List();
  for (int i = 0; i < data.length; i++) {

    String Id = data[i]["id"].toString();
    String name = data[i]["name"].toString();
    String Entitle = data[i]["days"].toString();
    String Used = data[i]["usedleave"].toString();
    String CF = data[i]["carryforward"].toString();
    String Left = data[i]["leftleave"].toString();

  //  print("********************"+Left+"***"+Used+"***"+Entitle);
    LeaveH tos = new LeaveH(
      Id: Id,
      name: name,
      Entitle: Entitle,
      Used: Used,
      Left: Left,
    );
    list.add(tos);
  }
  return list;
}







class LeaveA {
  String Id;
  String name;
  String Leavests;
  String Reason;
  String applydate;
  String Fdate;
  String Tdate;
  String Psts;
  String Ldays;
  String HRSts;
  String FromDayType;
  String ToDayType;
  String TimeOfTo;
  String LeaveTypeId;
  String sts;

  LeaveA(
      { this.Id,
        this.name,
        this.Leavests,
        this.Reason,
        this.applydate,
        this.Fdate,
        this.Tdate,
        this.Psts,
        this.Ldays, this.HRSts, this.FromDayType, this.ToDayType, this.TimeOfTo, this.LeaveTypeId, this.sts});
}


Future<List<LeaveA>> getApprovals(listType) async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";

  Response<String> response =
  await dio.post(path+"getapproval?datafor="+listType+'&empid='+empid+'&orgid='+orgdir);
  final res = json.decode(response.data.toString());
//  print(res);
  // print(path+"getapproval?datafor="+listType+'&empid='+empid+'&orgid='+orgdir);

/*  List responseJson;
  if (listType == 'Approved')
    responseJson = res['Approved'];
  else if (listType == 'Pending')
    responseJson = res['Pending'];
  else if (listType == 'Rejected')
    responseJson = res['Rejected'];*/

  List<LeaveA> userList = createleaveapporval(res);

  return userList;
}

List<LeaveA> createleaveapporval(List data) {

  List<LeaveA> list = new List();
  for (int i = 0; i < data.length; i++) {

    String Id = data[i]["Id"].toString();
    String name = data[i]["name"].toString();
    String Leavests = data[i]["LeaveStatus"].toString();
    String Reason = data[i]["LeaveReason"].toString();
    String applydate = data[i]["ApplyDate"].toString();
    String Fdate = data[i]["FDate"].toString();
    String Tdate = data[i]["TDate"].toString();
    String Ldays = data[i]["Ldays"].toString();
    String FromDayType = data[i]["FromDayType"].toString();
    String ToDayType = data[i]["ToDayType"].toString();
    String TimeOfTo = data[i]["TimeOfTo"].toString();
    String LeaveTypeId = data[i]["LeaveTypeId"].toString();
 //   print("********************"+data[i]["Pstatus"].toString());
    String HRSts = data[i]["HRSts"].toString();
    print(Fdate+"@@@@@@@"+Tdate);
    if(Fdate==Tdate){
      Tdate=" - "+Fdate;
    }
    else{
      Tdate=" - "+Tdate;
    }
    String Psts="";
    if(data[i]["Pstatus"].contains("Pending at")) {
      Psts = data[i]["Pstatus"].toString();
    }

    LeaveA tos = new LeaveA(
        Id: Id,
        name: name,
        Leavests: Leavests,
        Reason: Reason,
        applydate: applydate,
        Fdate: Fdate,
        Tdate: Tdate,
        Psts : Psts,
        Ldays: Ldays,
        HRSts: HRSts,FromDayType: FromDayType,ToDayType: ToDayType,TimeOfTo: TimeOfTo,LeaveTypeId :LeaveTypeId);
    list.add(tos);
  }
  return list;
}


ApproveLeave(Leaveid,comment,sts) async{
  String empid;
  String organization;
  // Employee emp;
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();

  empid = prefs.getString('employeeid')??"";
  organization =prefs.getString('organization')??"";
  //emp = new Employee(employeeid: empid, organization: organization);
  try {
    FormData formData = new FormData.from({
      "eid": empid,
      "orgid": organization,
      "leaveid": Leaveid,
      "comment": comment,
      "sts": sts,
      // "leavests": leave.approverstatus
    });
  /*  print(comment);
    print(Leaveid);
    print(empid);
    print(organization);
    print(sts);*/
    //Response response = await dio.post("https://sandbox.ubiattendance.com/index.php/services/getInfo", data: formData);
//Response response = await dio.post(  path_hrm_india+"ApproveLeave",data: formData);
    Response response = await dio.post(
        path+"Approvedleave",
        data: formData);
    final leaveMap = response.data.toString();
    print("-------------------");
    print(response.toString());
    if (leaveMap.contains("false"))
    {
    print("false approve leave function--->" + response.data.toString());
      return "false";
    } else {
    print("true  approve leave function---" + response.data.toString());
      return "true";
    }
    //print(response.toString());
    /* if (response.statusCode == 200) {
      Map leaveMap = json.decode(response.data);
      if(leaveMap["status"]==true){
        return "success";

      }else{
        return "failure";
      }
    }else{
      return "No Connection";
    }*/
  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }
}

ApproveLeaveByHr(Leaveid,comment,sts,LBD) async{
  String empid;
  String organization;
  print("**********Approve HR function called***");
  print(LBD);
  // Employee emp;
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();

  empid = prefs.getString('employeeid')??"";
  organization =prefs.getString('organization')??"";
  //emp = new Employee(employeeid: empid, organization: organization);
  try {
    FormData formData = new FormData.from({
      "eid": empid,
      "orgid": organization,
      "leaveid": Leaveid,
      "comment": comment,
      "sts": sts,
      "LBD": LBD,
      // "FromDayType": FromDayType,
      //"ToDayType": ToDayType,
      //  "TimeOfTo": TimeOfTo,
      // "leavests": leave.approverstatus
    });
    /*print(comment);
    print(Leaveid);
    print(empid);
    print(organization);
    print(sts);*/
    //Response response = await dio.post("https://sandbox.ubiattendance.com/index.php/services/getInfo", data: formData);
//Response response = await dio.post(  path_hrm_india+"ApproveLeave",data: formData);
    Response response = await dio.post(
        path+"ApprovedleaveBYHr",
        data: formData);
    //print(response.toString());
    final leaveMap = response.data.toString();
    if (leaveMap.contains("false"))
    {
      print("false approve leave hrfunction--->" + response.data.toString());
      return "false";
    }
    else {
      print("true  approve leave hr function---" + response.data.toString());
      return "true";
    }
  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }
}



Future<List<LeaveA>> getTeamApprovals() async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  //print(path+"getteamapproval?empid="+empid+'&orgid='+orgdir);
  Response<String> response =
  await dio.post(path+"getteamapproval?empid="+empid+'&orgid='+orgdir);
  final res = json.decode(response.data.toString());

print(res);
  List<LeaveA> userList1 = createTeamleaveapporval(res);

  return userList1;
}

List<LeaveA> createTeamleaveapporval(List data) {

  List<LeaveA> list = new List();
  for (int i = 0; i < data.length; i++) {

    String Id = data[i]["Id"].toString();
    String name = data[i]["name"].toString();
    String Leavests = data[i]["LeaveStatus"].toString();
    String Reason = data[i]["LeaveReason"].toString();
    String applydate = data[i]["ApplyDate"].toString();
    String Fdate = data[i]["FDate"].toString();
    String Tdate = data[i]["TDate"].toString();
    String Ldays = data[i]["Ldays"].toString();
    String FromDayType = data[i]["FromDayType"].toString();
    String ToDayType = data[i]["ToDayType"].toString();
    String TimeOfTo = data[i]["TimeOfTo"].toString();
    String LeaveTypeId = data[i]["LeaveTypeId"].toString();
    String sts = data[i]["sts"].toString();
      print("********************"+data[i]["Pstatus"].toString());
    String HRSts = data[i]["HRSts"].toString();
 //   print(Fdate+"@@@@@@@"+Tdate);
    if(Fdate==Tdate){
      Tdate=" - "+Fdate;
    }
    else{
      Tdate=" - "+Tdate;
    }
    String Psts="";
    if(data[i]["Pstatus"].contains("Pending at")) {
      Psts = data[i]["Pstatus"].toString();
    }

    LeaveA tos = new LeaveA(
        Id: Id,
        name: name,
        Leavests: Leavests,
        Reason: Reason,
        applydate: applydate,
        Fdate: Fdate,
        Tdate: Tdate,
        Psts : Psts,
        Ldays: Ldays,
        HRSts: HRSts,FromDayType: FromDayType,ToDayType: ToDayType,TimeOfTo: TimeOfTo,LeaveTypeId :LeaveTypeId,sts :sts);
    list.add(tos);

  }
  return list;
}




/*
class profileup {

  var dio = new Dio();

  getProfile(String empid) async {
    //  print('---------------------------------------------------------');
    try {
      FormData formData = new FormData.from({
        "uid": empid,
      }); //print('##############################################################');
      //Response response = await dio.post("https://sandbox.ubiattendance.com/index.php/services/getInfo", data: formData);
      Response response = await dio.post(
          path + "getProfile",
          data: formData);
      //  print('##############################################################');
      // print(response.toString());
      if (response.statusCode == 200) {
        Map profileMap = json.decode(response.data);
        return profileMap;
      } else {
        return "No Connection";
      }
    } catch (e) {
      //print(e.toString());
      return "Poor network connection";
    }
  }

  updateProfile(Profile profile) async {
    try {
      FormData formData = new FormData.from({
        "uid": profile.uid,
        "refno": profile.orgid,
        "no": profile.mobile,
        "con": profile.countryid
      });


      final prefs = await SharedPreferences.getInstance();


      String empid = prefs.getString('employeeid')??"";
      String organization =prefs.getString('organization')??"";
      Employee emp = new Employee(employeeid: empid, organization: organization);


      //Response response = await dio.post("https://sandbox.ubiattendance.com/index.php/services/getInfo", data: formData);
      Response response = await dio.post(
          path + "updateProfile",
          data: formData);
      //print(response.toString());
      if (response.statusCode == 200) {
        Map profileMap = json.decode(response.data);
        // getProfileInfo(emp);
        //print("**********))))))))");
        //print(profileMap["res"]);
        if (profileMap["res"] == 1) {

          return "success";
        } else {
          return "failure";
        }
      } else {
        return "No Connection";
      }
    } catch (e) {
      //print(e.toString());
      return "Poor network connection";
    }
  }


  Future<bool> updateProfilePhoto(int uploadtype, String empid,
      String orgid) async {
    Dio dio = new Dio();
    try {
      File imagei = null;
      imageCache.clear();
      //for gallery
      if (uploadtype == 1) {
        imagei = await ImagePicker.pickImage(source: ImageSource.gallery);
      }
      //for camera
      if (uploadtype == 2) {
        imagei = await ImagePicker.pickImage(source: ImageSource.camera);
      }
      //for removing photo
      if (uploadtype == 3) {
        imagei = null;
      }
      print("Selected image information ****************************");
      print(imagei.toString());
      if (imagei != null) {
        //// sending this base64image string +to rest api
        FormData formData = new FormData.from({
          "uid": empid,
          "refno": orgid,
          "file": new UploadFileInfo(imagei, "sample.png"),
        });
        //print("5");
        Response<String> response1 = await dio.post(
            path_hrm_india + "updateProfilePhoto", data: formData);

        //imagei.deleteSync();
        imageCache.clear();
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        //print(MarkAttMap["status"].toString());
        if (MarkAttMap["status"])
          return true;
        else
          return false;
      } else if (uploadtype == 3 && imagei == null) {
        FormData formData = new FormData.from({
          "uid": empid,
          "refno": orgid,
        });
        Response<String> response1 = await dio.post(
            path_hrm_india + "updateProfilePhoto", data: formData);
        print("mmmmmmmmmmmmmmmmmm" + response1.toString());
        Map MarkAttMap = json.decode(response1.data);
        //print(MarkAttMap["status"].toString());
        if (MarkAttMap["status"])
          return true;
        else
          return false;
      } else {
        return false;
      }
    } catch (e) {
      print("this is catch.. of updateprofilephoto**************************");
      print(e.toString());
      return false;
    }
  }

} */

/*

Future<List<TimeOff>> getTimeOffSummary() async{
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  try {
    FormData formData = new FormData.from({
      "uid": empid,
    });
    //Response response = await dio.post("https://sandbox.ubiattendance.com/index.php/services/getInfo", data: formData);
    Response response = await dio.post(
        path_ubiattendance+"fetchTimeOffList",
        data: formData);
    //print('--------------------getLeaveSummary Called-----------------------');
    List responseJson = json.decode(response.data.toString());
    //   print('---getLeaveSummary Called---' + json.decode(response.data.toString()));

    List<TimeOff> userList = createTimeOffList(responseJson);
    return userList;
  }catch(e){
    //print(e.toString());
  }
}



List<TimeOff> createTimeOffList(List data){

  List<TimeOff> list = new List();
  for (int i = 0; i < data.length; i++) {
    String TimeofDate = data[i]["date"];
    String TimeFrom=data[i]["from"];
    String TimeTo=data[i]["to"];
    String hrs=data[i]["hrs"];
    String Reason=data[i]["reason"];
    String ApprovalSts=data[i]["status"];
    String ApproverComment=data[i]["comment"];
    String TimeOffId=data[i]["timeoffid"].toString();
    bool withdrawlsts=data[i]["withdrawlsts"];

    //  print(LeaveDate);
    TimeOff timeoff = new TimeOff(TimeofDate: TimeofDate, TimeFrom: TimeFrom, TimeTo: TimeTo, hrs: hrs, Reason: Reason, ApprovalSts: ApprovalSts, ApproverComment: ApproverComment, TimeOffId: TimeOffId, withdrawlsts: withdrawlsts);
    list.add(timeoff);

  }
  return list;
}

*/


/*

/////////FOR EMPLOYEE LEAVE REPORT///////////

Future<List<Map>> getEmployeesList(int label) async{
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? "";

  final response = await dio.post(path_hrm_india + 'getReportingTeam?organization=$orgid&employeeid=$empid');
  List data = json.decode(response.data.toString());
  List<Map> depts = createEMpListDD(data,label);
  print(depts);
  return depts;
}
List<Map> createEMpListDD(List data,int label) {
  List<Map> list = new List();
  if(label==1) // with -All- label
    list.add({"Id":"0","Name":"-All-","Code":""});
  else
    list.add({"Id":"0","Name":"-Select-","Code":""});
  for (int i = 0; i < data.length; i++) {
    Map tos;
    if(data[i]["LastName"].toString()!='' && data[i]["LastName"].toString()!=null)
      tos={"Name":data[i]["FirstName"].toString()+" "+data[i]["LastName"].toString(),"Id":data[i]["Id"].toString(),"Code":data[i]["Code"].toString()};
    list.add(tos);
  }
  return list;
}


Future<List<EmpListLeave>> getEmployeeLeaveList(date,emp) async {
  Dio dio = new Dio();
  // String empid;
  if (date == '' || date == null) return null;
  try {
    */
/* print("ABC");
    print(emp);
    print(date);
    print("ABC");*//*



    final prefs = await SharedPreferences.getInstance();
    String orgid = prefs.getString('orgdir') ?? '';
    String empid = prefs.getString('employeeid') ?? "";
    */
/* print("-------->");
    print(empid);
    print(date);
    print("-------->");*//*


    final response = await dio.post(path_hrm_india +
        'getEmployeeLeaveList?fd=$date&orgid=$orgid&empid=$empid&emp=$emp');

    List responseJson = json.decode(response.data.toString());

    List<EmpListLeave> list = createEmployeeLeaveDataList(responseJson);

    return list;
  }catch(e){
    print(e.toString());
  }
}

List<EmpListLeave> createEmployeeLeaveDataList(List data) {
  List<EmpListLeave> list = new List();
  */
/*print("XYZ");
    print(data.length);
    print("XYZ");*//*

  for (int i = 0; i < data.length; i++) {
    String days = data[i]["days"];
    String to = data[i]["to"];
    String from = data[i]["from"];
    String name = data[i]["name"];
    String date = data[i]["date"];  //this is leave appy date
    String leavetype = data[i]["leavetype"];
    String breakdown = data[i]["breakdown"];
    EmpListLeave row = new EmpListLeave(
        days: days, to: to, from: from, name: name, date: date, leavetype: leavetype, breakdown: breakdown);
    list.add(row);
  }
  return list;
}

class EmpListLeave {
  String days;
  String to;
  String from;
  String name;
  String date;
  String leavetype;
  String breakdown;

  EmpListLeave({this.days, this.to, this.from, this.name, this.date, this.leavetype, this.breakdown});
}
*/

//////////FOR EMPLOYEE LEAVE REPORT///////////

Future<List<Map>> getEmployeesList(int label) async{
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? "";

  final response = await dio.post(path_hrm_india + 'getReportingTeam?organization=$orgid&employeeid=$empid');
  List data = json.decode(response.data.toString());
  List<Map> depts = createEMpListDD(data,label);
  print(depts);
  return depts;
}
List<Map> createEMpListDD(List data,int label) {
  List<Map> list = new List();
  if(label==1) // with -All- label
    list.add({"Id":"0","Name":"-All-","Code":""});
  else
    list.add({"Id":"0","Name":"-Select-","Code":""});
  for (int i = 0; i < data.length; i++) {
    Map tos;
  //  if(data[i]["LastName"].toString()!='' && data[i]["LastName"].toString()!=null)
  //    tos={"Name":data[i]["FirstName"].toString()+" "+data[i]["LastName"].toString(),"Id":data[i]["Id"].toString(),"Code":data[i]["Code"].toString()};
 //   if(data[i]["LastName"].toString()!='' && data[i]["LastName"].toString()!=null)
      tos={"Name":data[i]["Name"].toString(),"Id":data[i]["Id"].toString(),"Code":data[i]["Code"].toString()};
    list.add(tos);
  print("-----------------"+tos.toString());

  }
  return list;
}


Future<List<EmpListLeave>> getEmployeeLeaveList(date,emp) async {
  Dio dio = new Dio();
  // String empid;
  if (date == '' || date == null) return null;
  try {
    /* print("ABC");
    print(emp);
    print(date);
    print("ABC");*/


    final prefs = await SharedPreferences.getInstance();
    String orgid = prefs.getString('orgdir') ?? '';
    String empid = prefs.getString('employeeid') ?? "";
    /* print("-------->");
    print(empid);
    print(date);
    print("-------->");*/

    final response = await dio.post(path_hrm_india +
        'getEmployeeLeaveList?fd=$date&orgid=$orgid&empid=$empid&emp=$emp');

    List responseJson = json.decode(response.data.toString());

    List<EmpListLeave> list = createEmployeeLeaveDataList(responseJson);

    return list;
  }catch(e){
    print(e.toString());
  }
}

List<EmpListLeave> createEmployeeLeaveDataList(List data) {
  List<EmpListLeave> list = new List();
  /*print("XYZ");
    print(data.length);
    print("XYZ");*/
  for (int i = 0; i < data.length; i++) {
    String days = data[i]["days"];
    String to = data[i]["to"];
    String from = data[i]["from"];
    String name = data[i]["name"];
    String date = data[i]["date"];  //this is leave appy date
    String leavetype = data[i]["leavetype"];
    String breakdown = data[i]["breakdown"];
    EmpListLeave row = new EmpListLeave(
        days: days, to: to, from: from, name: name, date: date, leavetype: leavetype, breakdown: breakdown);
    list.add(row);
  }
  return list;
}

class EmpListLeave {
  String days;
  String to;
  String from;
  String name;
  String date;
  String leavetype;
  String breakdown;

  EmpListLeave({this.days, this.to, this.from, this.name, this.date, this.leavetype, this.breakdown});
}