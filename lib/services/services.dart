import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/model/model.dart';

import '../login_page.dart';


//import 'package:http/http.dart' as http;


getAllPermission(Employee emp) async{
print("*********GET ALL PERMISSION**********");
  final prefs = await SharedPreferences.getInstance();
  String path1 = prefs.getString('path');
  Dio dio = new Dio();
  FormData formData = new FormData.from({
    "employeeid": emp.employeeid,
    "organization": emp.organization,
    "userprofileid": emp.userprofileid,
  });
  print(path1 + "getAllPermission?employeeid=${emp.employeeid}&organization=${emp.organization}&userprofileid=${emp.userprofileid}");
  Response<String> response = await dio.post(path1 + "getAllPermission", data: formData);
  Map responseJson = json.decode(response.data.toString());
  List<Permission> permlist = createPermList(responseJson['orgperm']);
  List<Permission> permlist1 = createUserPermList(responseJson['userperm']);

  globalpermissionlist = permlist;
  globalpermissionlist1 = permlist1;
  return;
}


List<Permission> createPermList(List data) {
  List<Permission> list = new List();
  for (int i = 0; i < data.length; i++) {

    List<Map<String,String>> permissionlist = new List();
    String moduleid = data[i]["module"];
    String view = data[i]["view"];

    Map<String,String> viewpermission = {'module':moduleid,'view': view};

    permissionlist.add(viewpermission);

    Permission p = new Permission(moduleid: moduleid,permissionlist: permissionlist);
    list.add(p);
  }
  return list;
}


getModulePermission(String moduleid, String permission_type){
  List<Permission> list = new List();
  list = globalpermissionlist;

  for (int i = 0; i < list.length; i++) {
    //  print("permisstion list "+list[i].permissionlist.toString());
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

List<Permission> createUserPermList(List data) {
  List<Permission> list = new List();
  for (int i = 0; i < data.length; i++) {

    List<Map<String,String>> permissionlist = new List();
    String moduleid = data[i]["module"];
    String view = data[i]["view"];

    Map<String,String> viewpermission = {'module':moduleid,'view': view};

    permissionlist.add(viewpermission);

    Permission p = new Permission(moduleid: moduleid,permissionlist: permissionlist);
    list.add(p);
  }
  return list;
}

getModuleUserPermission(String moduleid, String permission_type){
  List<Permission> list = new List();
  list = globalpermissionlist1;
  print("--------<<<<<<<LIST");
  print(list);
  print("dfdghgdf");
  print(globalpermissionlist1);
  print('globalpermissionlist1');
  for (int i = 0; i < list.length; i++) {
    //  print("permisstion list "+list[i].permissionlist.toString());
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


getProfileInfo(Employee emp, BuildContext context) async{
  final prefs = await SharedPreferences.getInstance();
  String path1 = prefs.getString('path');
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Dio dio = new Dio();
  try {
    FormData formData = new FormData.from({
      "employeeid": emp.employeeid,
      "organization": emp.organization
    });
    Response<String> response =
    await dio.post(path1 + "getProfileInfo", data: formData);
    print(path1 + "getProfileInfo?employeeid=${emp.employeeid}&organization=${emp.organization}");
    print(response.toString());
    Map responseJson = json.decode(response.data.toString());
    //print(responseJson['Status']);
    if(responseJson['Status']=='c') {
      //print('vanshika');
      //print(responseJson['Status']);
      globalcontactusinfomap = responseJson['Contact'];
      globalpersnalinfomap = responseJson['Personal'];
      globalcompanyinfomap = responseJson['Company'];
      print("vvvvvvvvvvvvv" + globalcompanyinfomap['Company']);
      globalprofileinfomap = responseJson['ProfilePic'];
      prefs.setString("profilepic", responseJson['ProfilePic']);
      return "true";
      //  print("vvvvvvvvvvvvv"+globalcompanyinfomap['Division']);
    }else if(responseJson['Status']=='b'){
      print("shaifali =============>>>>");
      print(responseJson['response']);
      prefs.remove('response');
      Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false,
      );
      showDialog(context: context, child:
      new AlertDialog(
        content: new Text("Your plan has expired!"),
      )
      );
      return "false2";
    }else if(responseJson['Status']=='a'){
      print("shaifali");
      print(responseJson['response']);
      prefs.remove('response');
      Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false,
      );
      showDialog(context: context, child:
      new AlertDialog(
        content: new Text("Your trial period has expired!"),
      )
      );
      return "false1";
    }
  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }
}

getfiscalyear(Employee emp) async{
  final prefs = await SharedPreferences.getInstance();
  String path1 = prefs.getString('path');
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Dio dio = new Dio();
  try {
    FormData formData = new FormData.from({
      "employeeid": emp.employeeid,
      "organization": emp.organization
    });

    Response<String> response =
    await dio.post(path1 + "getfiscalyear", data: formData);
    // print(response.toString());
    Map responseJson = json.decode(response.data.toString());
    //print(responseJson);
    fiscalyear = responseJson['year'];
    //  print("vvvvvvvvvvvvv"+globalcompanyinfomap['Division']);
  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }
}

getovertime(Employee emp) async{
  final prefs = await SharedPreferences.getInstance();
  String path1 = prefs.getString('path');
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Dio dio = new Dio();
  try {
    /*FormData formData = new FormData.from({
      "employeeid": emp.employeeid,
      "organization": emp.organization
    });*/

    Response<String> response =
    await dio.post(path1 + "getovertime?employeeid=$empid&organization=$orgdir");
    print("result");
    print(path1 + "getovertime?employeeid=$empid&organization=$orgdir");
    Map responseJson = json.decode(response.data.toString());
    print('------------->');
    print(responseJson['utime']);
    print(responseJson['otime']);

    overtime = responseJson['otime'];
    print("OVERTIME---"+overtime.toString());

    undertime = responseJson['utime'];
    print("UNDERTIME---"+undertime.toString());

    if(responseJson['utime']==null){
      undertime ='00:00';
    }
    if(responseJson['otime']==null && responseJson['utime']==null ){
      overtime = '00:00';
    }
    // undertime ='00:00';
    // overtime='';
    //  }

    /* print('**********');
    print(overtime);
    print(undertime);
    print('**********');*/

  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }



}


getCountAproval() async{
  final prefs = await SharedPreferences.getInstance();
  String path1 = prefs.getString('path');
  Dio dio = new Dio();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  // await dio.post(path+"getapprovalCount?datafor=Pending"'&empid='+empid+'&orgid='+orgdir);

  var response =  await dio.post(path1+"getapprovalCount?empid="+empid+"&orgid="+orgdir);
  //print("getapprovalCount");
  //print(path+"getapprovalCount?empid="+empid+"&orgid="+orgdir);
  Map responseJson = json.decode(response.data.toString());
  /* print('AAAAAA');
  print(responseJson['total']);
  print('AAAAAA');*/
  if(responseJson['total']>0) {
    prefs.setInt('approvalcount', responseJson['total']);
    return true;
  }
  else{
    prefs.setInt('approvalcount', responseJson['total']);
    return false;
  }

}


getReportingTeam(Employee emp) async{
  final prefs = await SharedPreferences.getInstance();
  String path1 = prefs.getString('path');
  Dio dio = new Dio();
//print("-------------------->"+emp.employeeid);
  // print(emp.organization);
  try {
    FormData formData = new FormData.from({
      "employeeid": emp.employeeid,
      "organization": emp.organization
    });
    Response<String> response =
    await dio.post(path1 + "getReportingTeam", data: formData);
    // print("---------> response"+response.toString());
    List responseJson = json.decode(response.data.toString());
    // print(responseJson);
  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }

}



Future<List<Team>> getTeamList() async {
//print(emp);
  final prefs = await SharedPreferences.getInstance();
  String path1 = prefs.getString('path');
  Dio dio = new Dio();

  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";

  Response<String> response =
  await dio.post(path1 + "getReportingTeam?&employeeid="+empid+"&organization="+orgdir);
  List responseJson = json.decode(response.data.toString());



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
  String path1 = prefs.getString('path');
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Dio dio = new Dio();
  //print("SOHAN LAL PATEL");
  print(path1+"getLeaveChartData?refno=$organization&eid=$empid");
  final response = await dio.post(
      path1+"getLeaveChartData?refno=$organization&eid=$empid"
  );

  final data = json.decode(response.data);
  //print(response);

  //print(data['leavesummary']['data'][0]['name']);
  List<Map<String, String>> val = [];
  /*  List<Map<String, String>> val = [
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
        ];*/

  for (int i = 0; i < data.length; i++) {
    for (int j = 0; j < data['leavesummary']['data'].length; j++) {
      val.add({
        "id": data['leavesummary']['data'][j]['id'].toString(),
        "name": data['leavesummary']['data'][j]['name'].toString(),
        "total": data['leavesummary']['data'][j]['totalleave'].toString(),
        "used": data['leavesummary']['data'][j]['usedleave'].toString(),
        "left": data['leavesummary']['data'][j]['leftleave'].toString(),
      });
    }
  }
//  print('==========');
  // print(val);
  return val;
}


Future<List<Map<String, String>>> getChartData() async {
  final prefs = await SharedPreferences.getInstance();
  String path1 = prefs.getString('path');
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Dio dio = new Dio();

  final response = await dio.post(
      path1+"getLeaveChartData?refno=$organization&eid=$empid"
  );

  final data = json.decode(response.data);
  //print(response);
  // print(data['leavesummary']['data'][0]['name']);


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
  String path1 = prefs.getString('path');
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Dio dio = new Dio();
  // ?eid=$empid&refno=$organization
  final response = await dio.post(
      path1+"getAttSummaryChart?eid=$empid&refno=$organization"
  );
  print(path1+"getAttSummaryChart?eid=$empid&refno=$organization");
  final data = json.decode(response.data.toString());
//print("fdgdgdfgd"+data.toString());

  prefs.setString("attmonth", data['att']['month'].toString());

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
Future<List<Holi>> getHolidays() async {
  //print("get holiday list called");
  final prefs = await SharedPreferences.getInstance();
  String path1 = prefs.getString('path');
  Dio dio = new Dio();
//try {
  // print("-------------------->"+emp.employeeid);
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  /* FormData formData = new FormData.from({
    "employeeid": emp.employeeid,
    "organization": emp.organization
  });*/
  // print(path + "getHolidays" + empid);
  Response<String> response =
  await dio.post(path1+"getHolidays?&employeeid="+empid+"&organization="+orgdir);
  print(await dio.post(path1+"getHolidays?&employeeid="+empid+"&organization="+orgdir));
  print("1777.---------  "+response.toString());
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
    final prefs = await SharedPreferences.getInstance();
    String path1 = prefs.getString('path');
    //  print('---------------------------------------------------------');
    try {
      FormData formData = new FormData.from({
        "uid": empid,
      }); //print('##############################################################');
      //Response response = await dio.post("https://sandbox.ubiattendance.com/index.php/services/getInfo", data: formData);
      Response response = await dio.post(
          path1 + "getProfile",
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
      String path1 = prefs.getString('path');

      String empid = prefs.getString('employeeid')??"";
      String organization =prefs.getString('organization')??"";
      Employee emp = new Employee(employeeid: empid, organization: organization);


      //Response response = await dio.post("https://sandbox.ubiattendance.com/index.php/services/getInfo", data: formData);
      Response response = await dio.post(
          path1 + "updateProfile",
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

  Future<bool> updateProfilePhoto(int uploadtype, String empid, String orgid) async {
    final prefs = await SharedPreferences.getInstance();
    String path_hrm_india1 = prefs.getString('path_hrm_india');
    try{

      File imagei = null;
      imageCache.clear();
      //for gallery
      if(uploadtype==1){
        imagei = await ImagePicker.pickImage(source: ImageSource.gallery);
      }
      //for camera
      if(uploadtype==2){
        imagei = await ImagePicker.pickImage(source: ImageSource.camera);
      }
      //for removing photo
      if(uploadtype==3){
        imagei = null;
      }
      print("Selected image information ****************************");
      print(imagei.toString());
      if(imagei!=null ) {
        //// sending this base64image string +to rest api
        FormData formData = new FormData.from({
          "uid": empid,
          "refno": orgid,
          "file": new UploadFileInfo(imagei, "sample.png"),
        });
        //print("5");
        Response<String> response1=await dio.post(path_hrm_india1+"updateProfilePhoto",data:formData);

        //imagei.deleteSync();
        imageCache.clear();
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        //print(MarkAttMap["status"].toString());
        if (MarkAttMap["status"])
          return true;
        else
          return false;
      }else if(uploadtype==3 && imagei==null){
        FormData formData = new FormData.from({
          "uid": empid,
          "refno": orgid,
        });
        Response<String> response1=await dio.post(path_hrm_india1+"updateProfilePhoto",data:formData);
        print(response1.toString());
        Map MarkAttMap = json.decode(response1.data);
        //print(MarkAttMap["status"].toString());
        if (MarkAttMap["status"])
          return true;
        else
          return false;
      }else{
        return false;
      }
    } catch (e) {
      print("this is catch.. of updateprofilephoto**************************");
      print(e.toString());
      return false;
    }
  }


/*Future<bool> updateProfilePhoto(int uploadtype, String empid, String orgid) async {
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
        *//*getTempImageDirectory();*//*
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
*/
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

class Choice {
  const Choice({this.title});
  final String title;
//final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Pending'),
  const Choice(title: 'Approved'),
  const Choice(title: 'Rejected'),
  // const Choice(title: 'REJECTED', icon: Icons.directions_boat),

];


