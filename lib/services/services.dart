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


getAllPermission(Employee emp) async{

  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  FormData formData = new FormData.from({
    "employeeid": emp.employeeid,
    "organization": emp.organization
  });

  Response<String> response =
  await dio.post(path + "getAllPermission", data: formData);
 // print(response.toString());
  List responseJson = json.decode(response.data.toString());
 //print("1.  "+responseJson.toString());
  List<Permission> permlist = createPermList(responseJson);
 //print("3. "+permlist.toString());
  globalpermissionlist = permlist;
}


getProfileInfo(Employee emp) async{
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Dio dio = new Dio();
  try {
    FormData formData = new FormData.from({
      "employeeid": emp.employeeid,
      "organization": emp.organization
    });

    Response<String> response =
    await dio.post(path + "getProfileInfo", data: formData);
    // print(response.toString());
    Map responseJson = json.decode(response.data.toString());
    //print(responseJson);
    globalcontactusinfomap = responseJson['Contact'];
    globalpersnalinfomap = responseJson['Personal'];
    globalcompanyinfomap = responseJson['Company'];
    globalprofileinfomap = responseJson['ProfilePic'];
    //prefs.setString("profilepic", responseJson['ProfilePic']);
   // print("vvvvvvvvvvvvv"+responseJson['ProfilePic']);
  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }



}

/*

getCountAproval() async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
var respons =
  await dio.post(path+"getapprovalCount?datafor=Pending"'&empid='+empid+'&orgid='+orgdir);
 // print("&&&&&&&iiiii");
 // print("-----------------ooo"+respons.data[0].toString());
  List responseJson = json.decode(respons.data.toString());
 // print("&&&&&&&11111"+responseJson.toString());
  //  String Approvalcount =
 // prefs.setInt("attmonth",respons);
   return respons;
  }

*/

getReportingTeam(Employee emp) async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
//print("-------------------->"+emp.employeeid);
 // print(emp.organization);
  try {
    FormData formData = new FormData.from({
      "employeeid": emp.employeeid,
      "organization": emp.organization
    });
  Response<String> response =
  await dio.post(path + "getReportingTeam", data: formData);
 // print("---------> response"+response.toString());
  List responseJson = json.decode(response.data.toString());
 // print(responseJson);
  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }

}

List<Permission> createPermList(List data) {
  List<Permission> list = new List();
  for (int i = 0; i < data.length; i++) {
   // print(i.toString());
    //print(data[i]['module'].toString());
    List<Map<String,String>> permissionlist = new List();
    String moduleid = data[i]["module"];
    String view = data[i]["view"];
    String edit = data[i]["edit"];
    String delete = data[i]["delete"];
    String add = data[i]["add"];
    //print(moduleid +" " +view+" "+edit+" "+delete+" "+add);
    Map<String,String> viewpermission = {'view': view};
    Map<String,String> editpermission = {'edit': edit};
    Map<String,String> deletepermission = {'delete': delete};
    Map<String,String> addpermission = {'add': add};
    permissionlist.add(viewpermission);
    permissionlist.add(editpermission);
    permissionlist.add(deletepermission);
    permissionlist.add(addpermission);
   // print("2. "+permissionlist.toString());
    Permission p = new Permission(moduleid: moduleid,permissionlist: permissionlist);
    list.add(p);
  }
  return list;
}

getModulePermission(String moduleid, String permission_type){
  List<Permission> list = new List();
  list = globalpermissionlist;
  print("********");
  print(globalpermissionlist);
  for (int i = 0; i < list.length; i++) {
    print("permisstion list "+list[i].permissionlist.toString());
    if(list[i].moduleid==moduleid){
      for (int j = 0; j < list[i].permissionlist.length; j++) {
        //print(list[i].permissionlist[j].containsKey(permission_type));
        if(list[i].permissionlist[j].containsKey(permission_type)){
          return list[i].permissionlist[j][permission_type];
        }
      }
    }
  }

  return "0";
}

Future<List<Team>> getTeamList(emp) async {
print("get team list called");
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
//try {
  print("-------------------->"+emp.employeeid);
  FormData formData = new FormData.from({
    "employeeid": emp.employeeid,
    "organization": emp.organization
  });
  Response<String> response =
  await dio.post(path + "getReportingTeam", data: formData);
  List responseJson = json.decode(response.data.toString());
 print("1.---------  "+responseJson.toString());
  List<Team> teamlist = createTeamList(responseJson);
  return teamlist;

}

List<Team> createTeamList(List data) {
  List<Team> list = new List();
  for (int i = 0; i < data.length; i++) {
    String Id = data[i]["Id"];
    String FirstName = data[i]["FirstName"];
    String LastName = data[i]["LastName"];
    String Designation = data[i]["Designation"];
    String DOB = data[i]["DOB"];
    String Nationality = data[i]["Nationality"];
    String BloodGroup = data[i]["BloodGroup"];
    String CompanyEmail = data[i]["CompanyEmail"];
    String ProfilePic = data[i]["ProfilePic"];

    Team team = new Team(Id: Id, FirstName: FirstName, LastName: LastName, Designation: Designation, DOB: DOB, Nationality: Nationality, BloodGroup: BloodGroup, CompanyEmail: CompanyEmail, ProfilePic: ProfilePic);
    list.add(team);
  }
  return list;
}


//////////////////// SERVICE TO REQUEST FOR LEAVE /////////////////////

/*

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
    print(leave.substituteemp);

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
    print("xxxxxxxxxx"+response1.toString());
    print("******************");
    print(response1.statusCode);
   // final leaveMap = json.decode(response1.toString());
    final leaveMap = response1.data.toString();
   // print("-------ddddddddd"+leaveMap["status"]);


   // if (response1.statusCode == 200) {
   // print("yyyyyyyyy"+leaveMap);
  //  print("yyyyyyyyy"+response1.toString());
      if (leaveMap.contains("false")) {
      //  print("false--->" + response1.data.toString());
        return "false";
      } else {
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
    if(LeaveFrom==LeaveTo){
      LeaveTo=" - "+LeaveFrom;
    }
    else{
      LeaveTo=" - "+LeaveTo;
    }
  //  print(LeaveDate);
    Leave leave = new Leave(attendancedate: LeaveDate, leavefrom: LeaveFrom, leaveto: LeaveTo, leavedays: LeaveDays, reason: Reason, approverstatus: ApprovalSts, comment: ApproverComment, leaveid: LeaveId, withdrawlsts: withdrawlsts);
    list.add(leave);
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

*/


Future<List<Map<String, String>>> getChartDataYes() async {
  final prefs = await SharedPreferences.getInstance();
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Dio dio = new Dio();

  final response = await dio.post(
      path+"getLeaveChartData?refno=$organization&eid=$empid"
      );

  final data = json.decode(response.data);
  //print(response);
  print(data['leavesummary']['data'][0]['name']);


      List<Map<String, String>> val = [
        {

          // "present": data['present'].toString(),
  "totalleaveC": data['leavesummary']['data'][0]['totalleave'].toString(),
  "usedleaveC" : data['leavesummary']['data'][0]['usedleave'].toString(),
  "leftleaveC" : data['leavesummary']['data'][0]['leftleave'].toString(),

   "totalleaveA": data['leavesummary']['data'][1]['totalleave'].toString(),
   "usedleaveA" : data['leavesummary']['data'][1]['usedleave'].toString(),
   "leftleaveA" : data['leavesummary']['data'][1]['leftleave'].toString(),

   "totalleaveL":data['leavesummary']['data'][1]['totalleave'].toString(),
   "usedleaveL": data['leavesummary']['data'][1]['usedleave'].toString(),
   "leftleaveL": data['leavesummary']['data'][1]['leftleave'].toString()


        }
        ];




  // print('==========');
// print(val);
  return val;
}


Future<List<Map<String, String>>> getChartData() async {
  final prefs = await SharedPreferences.getInstance();
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Dio dio = new Dio();

  final response = await dio.post(
      path+"getLeaveChartData?refno=$organization&eid=$empid"
  );

  final data = json.decode(response.data);
  //print(response);
  print(data['leavesummary']['data'][0]['name']);


  List<Map<String, String>> val = [
    {

      // "present": data['present'].toString(),
      "totalleaveC": data['leavesummary']['data'][0]['totalleave'].toString(),
      "usedleaveC" : data['leavesummary']['data'][0]['usedleave'].toString(),
      "leftleaveC" : data['leavesummary']['data'][0]['leftleave'].toString(),

      "totalleaveA": data['leavesummary']['data'][1]['totalleave'].toString(),
      "usedleaveA" : data['leavesummary']['data'][1]['usedleave'].toString(),
      "leftleaveA" : data['leavesummary']['data'][1]['leftleave'].toString(),

      "totalleaveL":data['leavesummary']['data'][1]['totalleave'].toString(),
      "usedleaveL": data['leavesummary']['data'][1]['usedleave'].toString(),
      "leftleaveL": data['leavesummary']['data'][1]['leftleave'].toString()


    }
  ];




  // print('==========');
// print(val);
  return val;
}


Future<List<Map<String, String>>> getAttsummaryChart() async {
  final prefs = await SharedPreferences.getInstance();
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Dio dio = new Dio();
 // ?eid=$empid&refno=$organization
  final response = await dio.post(
      path+"getAttSummaryChart?eid=$empid&refno=$organization"
  );
// print(response.toString());
  final data = json.decode(response.data.toString());
//print("fdgdgdfgd"+data.toString());
 //print(data['att']['month']);
  prefs.setString("attmonth", data['att']['month']);

  List<Map<String, String>> val = [
    {

      // "present": data['present'].toString(),
      "present": data['att']['present'] .toString(),
      "absent" : data['att']['absent'].toString(),
      "leave"  : data['att']['leave'].toString(),


    }
  ];
  // print('==========');
  // print(val);
  return val;
}
////Get Holidays//
Future<List<Holi>> getHolidays(emp) async {
  //print("get holiday list called");
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
//try {
 // print("-------------------->"+emp.employeeid);
  FormData formData = new FormData.from({
    "employeeid": emp.employeeid,
    "organization": emp.organization
  });
  print(path + "getHolidays");
  Response<String> response =
  await dio.post(path+"getHolidays",
      data: formData);
 // print("1777.---------  "+response.toString());
  List responseJson = json.decode(response.data.toString());
 // print("1.---------  "+responseJson.toString());
  List<Holi> holilist = createHolidayList(responseJson);
  return holilist;

}

List<Holi> createHolidayList(List data) {
  List<Holi> list = new List();
  for (int i = 0; i < data.length; i++) {

    String name = data[i]["name"];
    String date = data[i]["date"];
    String message = data[i]["message"];

   Holi holi = new Holi(name: name, date: date, message: message);
    list.add(holi);
  }
  return list;
}


/*

Future<List<Map>> getleavetype(int label) async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  final response = await dio.post(path + "getEmployeeAllLeaveType?orgid=$orgdir&eid=$empid");
  //print("leavetype11----------->");
 // print(response);
  List data = json.decode(response.data.toString());
 // print("leavetype----------->");
//  print(data);
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
      Map tos={"Name":data[i]["name"].toString(),"Id":data[i]["id"].toString()};
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

    print("********************"+Left+"***"+Used+"***"+Entitle);
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

  LeaveA(
      { this.Id,
        this.name,
        this.Leavests,
        this.Reason,
        this.applydate,
        this.Fdate,
        this.Tdate,
        this.Psts,
        this.Ldays, this.HRSts, this.FromDayType, this.ToDayType, this.TimeOfTo, this.LeaveTypeId});
}


Future<List<LeaveA>> getApprovals(listType) async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";

  Response<String> response =
  await dio.post(path+"getapproval?datafor="+listType+'&empid='+empid+'&orgid='+orgdir);
  final res = json.decode(response.data.toString());
  print(res);
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
    //print("********************"+Ldays);
    String HRSts = data[i]["HRSts"].toString();
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
    print(comment);
    print(Leaveid);
    print(empid);
    print(organization);
    print(sts);
    //Response response = await dio.post("https://sandbox.ubiattendance.com/index.php/services/getInfo", data: formData);
//Response response = await dio.post(  path_hrm_india+"ApproveLeave",data: formData);
    Response response = await dio.post(
        path+"Approvedleave",
        data: formData);
    final leaveMap = response.data.toString();
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
    print(comment);
    print(Leaveid);
    print(empid);
    print(organization);
    print(sts);
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
    } else {
      print("true  approve leave hr function---" + response.data.toString());
      return "true";
    }
  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }
}

*/

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

}

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