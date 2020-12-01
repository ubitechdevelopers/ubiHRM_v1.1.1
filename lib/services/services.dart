import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/model/model.dart';

import '../login_page.dart';



getAllPermission(Employee emp) async{
print("**********GET ALL PERMISSION**********");
  //final prefs = await SharedPreferences.getInstance();
  //String path1 = prefs.getString('path');
  Dio dio = new Dio();
  FormData formData = new FormData.from({
    "employeeid": emp.employeeid,
    "organization": emp.organization,
    "userprofileid": emp.userprofileid,
  });
  print(path + "getAllPermission?employeeid=${emp.employeeid}&organization=${emp.organization}&userprofileid=${emp.userprofileid}");
  Response<String> response = await dio.post(path + "getAllPermission", data: formData);
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
    if(list[i].moduleid==moduleid){
      for (int j = 0; j < list[i].permissionlist.length; j++) {
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

  for (int i = 0; i < list.length; i++) {
    if(list[i].moduleid==moduleid){
      for (int j = 0; j < list[i].permissionlist.length; j++) {
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
  //String path1 = prefs.getString('path');
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Dio dio = new Dio();
  try {
    FormData formData = new FormData.from({
      "employeeid": emp.employeeid,
      "organization": emp.organization
    });
    Response<String> response = await dio.post(path + "getProfileInfo", data: formData);
    print(path + "getProfileInfo?employeeid=${emp.employeeid}&organization=${emp.organization}");
    Map responseJson = json.decode(response.data.toString());

    if(responseJson['Status']=='c') {
      globalcontactusinfomap = responseJson['Contact'];
      globalpersnalinfomap = responseJson['Personal'];
      globalcompanyinfomap = responseJson['Company'];
      globalprofileinfomap = responseJson['ProfilePic'];
      globalogrperminfomap = responseJson['Orgperm'];
      prefs.setString("profilepic", responseJson['ProfilePic']);
      return "true";
    }else if(responseJson['Status']=='b'){
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
  //String path1 = prefs.getString('path');
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Dio dio = new Dio();
  try {
    FormData formData = new FormData.from({
      "employeeid": emp.employeeid,
      "organization": emp.organization
    });

    Response<String> response =
    await dio.post(path + "getfiscalyear", data: formData);

    Map responseJson = json.decode(response.data.toString());
    fiscalyear = responseJson['year'];
  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }
}

getovertime(Employee emp) async{
  final prefs = await SharedPreferences.getInstance();
  //String path1 = prefs.getString('path');
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Dio dio = new Dio();
  try {
    /*FormData formData = new FormData.from({
      "employeeid": emp.employeeid,
      "organization": emp.organization
    });*/

    Response<String> response =
    await dio.post(path + "getovertime?employeeid=$empid&organization=$orgdir");
    print(path + "getovertime?employeeid=$empid&organization=$orgdir");
    Map responseJson = json.decode(response.data.toString());

    overtime = responseJson['otime'];

    undertime = responseJson['utime'];

    if(responseJson['utime']==null){
      undertime ='00:00';
    }
    if(responseJson['otime']==null && responseJson['utime']==null ){
      overtime = '00:00';
    }

  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }

}

getCountAproval() async{
  final prefs = await SharedPreferences.getInstance();
  //String path1 = prefs.getString('path');
  Dio dio = new Dio();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  perLeaveApproval=getModuleUserPermission("124","view");
  perTimeoffApproval=getModuleUserPermission("180","view");
  perSalaryExpenseApproval=getModuleUserPermission("170","view");
  perPayrollExpenseApproval=getModuleUserPermission("473","view");
  print("leave>>>>>>>>>> "+perLeaveApproval);
  print("timeoff>>>>>>>>>> "+perTimeoffApproval);
  print("salary expense>>>>>>>>>>> "+perSalaryExpenseApproval);
  print("payroll expense>>>>>>>>>>> "+perPayrollExpenseApproval);
  int leavecount=0;
  int timeoffcount=0;
  int expensecount=0;
  int payrollexpensecount=0;
  int total=0;

  if(perLeaveApproval=='1') {
    print(path + "getLeaveApprovalCount?empid=" + empid + "&orgid=" + orgdir);
    var response = await dio.post(path + "getLeaveApprovalCount?empid=" + empid + "&orgid=" + orgdir);
    Map responseJson1 = json.decode(response.data.toString());
    prefs.setInt('leavecount', responseJson1['leavecount']);
    leavecount = prefs.getInt('leavecount')??"";
    print(leavecount);
  }
  if(perTimeoffApproval=='1') {
    print(path + "getTimeoffApprovalCount?empid=" + empid + "&orgid=" + orgdir);
    var response = await dio.post(path + "getTimeoffApprovalCount?empid=" + empid + "&orgid=" + orgdir);
    Map responseJson2 = json.decode(response.data.toString());
    prefs.setInt('timeoffcount', responseJson2['timeoffcount']);
    timeoffcount = prefs.getInt('timeoffcount')??"";
    print(timeoffcount);
  }
  if(perSalaryExpenseApproval=='1') {
    print(path + "getSalaryExpenseApprovalCount?empid=" + empid + "&orgid=" + orgdir);
    var response = await dio.post(path + "getSalaryExpenseApprovalCount?empid=" + empid + "&orgid=" + orgdir);
    Map responseJson3 = json.decode(response.data.toString());
    prefs.setInt('expensecount', responseJson3['expensecount']);
    expensecount = prefs.getInt('expensecount')??"";
    print(expensecount);
  }
  if(perPayrollExpenseApproval=='1') {
    print(path + "getPayrollExpenseApprovalCount?empid=" + empid + "&orgid=" + orgdir);
    var response = await dio.post(path + "getPayrollExpenseApprovalCount?empid=" + empid + "&orgid=" + orgdir);
    Map responseJson4 = json.decode(response.data.toString());
    prefs.setInt('payrollexpensecount', responseJson4['payrollexpensecount']);
    payrollexpensecount = prefs.getInt('payrollexpensecount')??"";
    print(payrollexpensecount);
  }

  total = leavecount+timeoffcount+expensecount+payrollexpensecount;
  print(total);
  if(total>=0) {
    prefs.setInt('approvalcount', total);
    return true;
  }

}

getReportingTeam(Employee emp) async{
  final prefs = await SharedPreferences.getInstance();
  //String path1 = prefs.getString('path');
  Dio dio = new Dio();
  try {
    FormData formData = new FormData.from({
      "employeeid": emp.employeeid,
      "organization": emp.organization
    });
    Response<String> response = await dio.post(path + "getReportingTeam", data: formData);
    List responseJson = json.decode(response.data.toString());
  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }
}

Future<List<Team>> getTeamList() async {
  final prefs = await SharedPreferences.getInstance();
  //String path1 = prefs.getString('path');
  Dio dio = new Dio();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";

  print(path + "getReportingTeam?&employeeid=$empid&organization=$orgdir");
  Response<String> response = await dio.post(path + "getReportingTeam?&employeeid=$empid&organization=$orgdir");
  List responseJson = json.decode(response.data.toString());
  print("response.data.toString()");
  print(response.data.toString());
  List<Team> teamlist = createTeamList(responseJson);
  print("teamlist");
  print(teamlist);
  return teamlist;
}

List<Team> createTeamList(List data) {
  List<Team> list = new List();
  List<dynamic> juniorlist = new List();
  List<dynamic> superjuniorlist = new List();
  List<dynamic> ultrasuperjuniorlist = new List();
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
    String ParentId = data[i]["ParentId"];
    juniorlist = data[i]["Junior"];
    print("juniorlist");
    print(juniorlist);
    if(juniorlist!=null) {
      for (int j = 0; j < juniorlist.length; j++) {
        superjuniorlist =  juniorlist[j]["Junior"];
        print("superjuniorlist");
        print(superjuniorlist);
        if(superjuniorlist!=null){
          for (int k = 0; k < superjuniorlist.length; k++) {
            ultrasuperjuniorlist = superjuniorlist[k]["Junior"];
            print( "ultrasuperjuniorlist" );
            print( ultrasuperjuniorlist );
          }
        }
      }
    }
    Team team = new Team(Id: Id, FirstName: FirstName, LastName: LastName, Designation: Designation, DOB: DOB, Nationality: Nationality, BloodGroup: BloodGroup, CompanyEmail: CompanyEmail, ProfilePic: ProfilePic, ParentId:ParentId, juniorlist:juniorlist, superjuniorlist:superjuniorlist, ultrasuperjuniorlist:ultrasuperjuniorlist);
    list.add(team);
  }
  print("list");
  print(list);
  return list;
}


Future<List<Map<String, String>>> getChartDataLeave() async {
  final prefs = await SharedPreferences.getInstance();
  //String path1 = prefs.getString('path');
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Dio dio = new Dio();

  print(path+"getLeaveChartData?refno=$organization&eid=$empid");
  final response = await dio.post(path+"getLeaveChartData?refno=$organization&eid=$empid");

  final data = json.decode(response.data);

  List<Map<String, String>> val = [];

  for (int i = 0; i < data.length; i++) {
    for (int j = 0; j < data['leavesummary']['data'].length; j++) {
      val.add({
        "id": data['leavesummary']['data'][j]['id'].toString(),
        "name": data['leavesummary']['data'][j]['name'].toString(),
        "total": data['leavesummary']['data'][j]['totalleave'].toString(),
        "used": data['leavesummary']['data'][j]['usedleave'].toString(),
        "left": data['leavesummary']['data'][j]['allocatedleftleaves'].toString(),
      });
    }
  }

  return val;
}


Future<List<Map<String, String>>> getChartData() async {
  final prefs = await SharedPreferences.getInstance();
  //String path1 = prefs.getString('path');
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Dio dio = new Dio();

  final response = await dio.post(path+"getLeaveChartData?refno=$organization&eid=$empid");

  final data = json.decode(response.data);

  List<Map<String, String>> val = [
    {

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

  return val;
}


Future<List<Map<String, String>>> getAttsummaryChart() async {
  final prefs = await SharedPreferences.getInstance();
  //String path1 = prefs.getString('path');
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Dio dio = new Dio();
  final response = await dio.post(path+"getAttSummaryChart?eid=$empid&refno=$organization");
  print(path+"getAttSummaryChart?eid=$empid&refno=$organization");
  final data = json.decode(response.data.toString());

  prefs.setString("attmonth", data['att']['month'].toString());

  List<Map<String, String>> val = [
    {
      // "present": data['present'].toString(),
      "present": data['att']['present'] .toString(),
      "absent" : data['att']['absent'].toString(),
      /*"weekoff"  : data['att']['weekoff'].toString(),
      "halfday"  : data['att']['halfday'].toString(),
      "holiday"  : data['att']['holiday'].toString(),*/
      "leave"  : data['att']['leave'].toString(),
      /*"compoff"  : data['att']['compoff'].toString(),
      "workfromhome"  : data['att']['workfromhome'].toString(),
      "unpaidleave"  : data['att']['unpaidleave'].toString(),
      "unpaidhalfday"  : data['att']['unpaidhalfday'].toString(),*/
    }
  ];

  return val;
}

Future<List<Holi>> getHolidays() async {
  final prefs = await SharedPreferences.getInstance();
  //String path1 = prefs.getString('path');
  Dio dio = new Dio();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  /* FormData formData = new FormData.from({
    "employeeid": emp.employeeid,
    "organization": emp.organization
  });*/
  print(path+"getHolidays?&employeeid=$empid&organization=$orgdir");
  Response<String> response = await dio.post(path+"getHolidays?&employeeid=$empid&organization=$orgdir");
  List responseJson = json.decode(response.data.toString());
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


class profileup {

  var dio = new Dio();

  getProfile(String empid) async {
    final prefs = await SharedPreferences.getInstance();
    //String path1 = prefs.getString('path');
    try {
      FormData formData = new FormData.from({
        "uid": empid,
      });
      Response response = await dio.post(
          path + "getProfile",
          data: formData);
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
      //String path1 = prefs.getString('path');

      String empid = prefs.getString('employeeid')??"";
      String organization =prefs.getString('organization')??"";
      Employee emp = new Employee(employeeid: empid, organization: organization);
      Response response = await dio.post(
          path + "updateProfile",
          data: formData);
      if (response.statusCode == 200) {
        Map profileMap = json.decode(response.data);

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
    //final prefs = await SharedPreferences.getInstance();
    //String path_hrm_india1 = prefs.getString('path_hrm_india');
    try{
      File imagei = null;
      imageCache.clear();
      //for gallery
      if(uploadtype==1){
        imagei = await ImagePicker.pickImage(source: ImageSource.gallery);
        print("Gallery");
        print(imagei);
      }
      //for camera
      if(uploadtype==2){
        imagei = await ImagePicker.pickImage(source: ImageSource.camera);
        print("Camera");
        print(imagei);
      }
      //for removing photo
      if(uploadtype==3){
        imagei = null;
        print("remove");
        print(imagei);
      }
      print("Selected image information ****************************");
      print(imagei.toString());
      print(imagei!=null && imagei!='');
      if(imagei!=null && imagei!='') {
        print('hello');
        FormData formData = new FormData.from({
          "uid": empid,
          "refno": orgid,
          "file": new UploadFileInfo(imagei, "sample.png"),
        });
        print(UploadFileInfo(imagei, "sample.png"),);
        print(path_hrm_india+"updateProfilePhoto?uid=$empid&refno=$orgid&file=$imagei");
        Response<String> response1=await dio.post(path_hrm_india+"updateProfilePhoto",data:formData);
        imagei.deleteSync();
        imageCache.clear();
        Map MarkAttMap = json.decode(response1.data);
        if (MarkAttMap["status"]){
          return true;
        } else {
          return false;
        }
      }else if(uploadtype==3 && imagei==null){
        print("uploadtype==3 && imagei==null");
        FormData formData = new FormData.from({
          "uid": empid,
          "refno": orgid,
        });
        print(path_hrm_india+"updateProfilePhoto?uid=$empid&refno=$orgid");
        Response<String> response1=await dio.post(path_hrm_india+"updateProfilePhoto",data:formData);
        Map MarkAttMap = json.decode(response1.data);
        if (MarkAttMap["status"]){
          return true;
        } else {
          return false;
        }
      }/*else{
        return false;
      }*/
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

}


class Choice {
  const Choice({this.title});
  final String title;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Pending'),
  const Choice(title: 'Approved'),
  const Choice(title: 'Rejected'),
];

