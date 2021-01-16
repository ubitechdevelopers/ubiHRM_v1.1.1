import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/global.dart' as globals;
import 'package:http/http.dart' as http;
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
      globallabelinfomap = responseJson['Label'];
      geoFenceOrgPerm=globalogrperminfomap['geofencests'];
      /*orgCreatedDate=globalogrperminfomap['createddate'];
      print("orgCreatedDate");
      print(orgCreatedDate);*/
      grpCompanySts=globalogrperminfomap['groupcompaniessts'];
      print("grpCompanySts");
      print(grpCompanySts);
      mailVerifySts=globalogrperminfomap['mailverifiedsts'];
      print("mailVerifySts");
      print(mailVerifySts);
      showMailVerificationDialog=globalogrperminfomap['mailverificationdialogsts'];
      print("showMailVerificationDialog");
      print(showMailVerificationDialog);
      assignedAreaIds=globalcompanyinfomap['AssignedAreaIds'];
      prefs.setString("assignedAreaIds", responseJson['AssignedAreaIds']);
      fenceAreaSts=globalcompanyinfomap['UserFenceAreaPerm'];
      prefs.setString("fenceAreaSts", responseJson['UserFenceAreaPerm']);
      areaSts= await getAreaStatus();
      print("***************************************************");
      print("geoFenceOrgPerm && fenceAreaSts");
      print((geoFenceOrgPerm=="1" || fenceAreaSts=="1"));
      print("globalcompanyinfomap['AssignedAreaIds']");
      print(globalcompanyinfomap['AssignedAreaIds']);
      print("globalcompanyinfomap['Areas']");
      print(globalcompanyinfomap['Areas']);
      print("globalcompanyinfomap['Areas'][0]['id']");
      print(globalcompanyinfomap['Areas'][0]['id']);
      print("geoFenceOrgPerm");
      print(geoFenceOrgPerm);
      print("fenceAreaSts");
      print(fenceAreaSts);
      print("areaSts");
      print(areaSts);
      print("***************************************************");
      List areas = globalcompanyinfomap['Areas'];
      double calculateDistance(lat1, lon1, lat2, lon2) {
        var p = 0.017453292519943295;
        var c = cos;
        var a = 0.5 - c((lat2 - lat1) * p) / 2 +
            c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
        return 12742 * asin(sqrt(a));
      }
      double totalDistance = 0.0;
      double lat = globals.assign_lat;
      double long = globals.assign_long;
      for (var i = 0; i < areas.length; i++) {
        double user_lat = double.parse(areas[i]['lat']);
        double user_long = double.parse(areas[i]['long']);
        globals.assign_radius = double.parse(areas[i]['radius']);

        double Temp_totalDistance = calculateDistance(user_lat, user_long, lat, long);
        if (i == 0) {
          totalDistance = Temp_totalDistance;
          globals.areaId = int.parse(areas[i]['id']);
          globals.assigned_lat = double.parse(areas[i]['lat']);
          globals.assigned_long = double.parse(areas[i]['long']);
          globals.assign_radius = double.parse(areas[i]['radius']);
        }else {
          if (totalDistance > Temp_totalDistance) {
            totalDistance = Temp_totalDistance;
            globals.areaId = int.parse(areas[i]['id']);
            globals.assigned_lat = double.parse(areas[i]['lat']);
            globals.assigned_long = double.parse(areas[i]['long']);
            globals.assign_radius = double.parse(areas[i]['radius']);
          }
        }
      }
      return "true";
    }else if(responseJson['Status']=='b'){
      prefs.remove('response');
      Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false,
      );
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: new Text("Your plan has expired"),
            );
          });
     /* showDialog(context: context, child:
      new AlertDialog(
        content: new Text("Your plan has expired!"),
      )
      );*/
      return "false2";
    }else if(responseJson['Status']=='a'){
      prefs.remove('response');
      Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false,
      );
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: new Text("Your trial period has expired"),
            );
          });
      /*showDialog(context: context, child:
      new AlertDialog(
        content: new Text("Your trial period has expired!"),
      )
      );*/
      return "false1";
    }
  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }
}

updateCounter() async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')?? '';
  print(path + 'updateCounter?&orgid=$orgdir&empid=$empid');
  final response = await http.get(path + 'updateCounter?&orgid=$orgdir&empid=$empid');
  print (response.body.toString());
  return response.body.toString();
}

verification(String orgid, String name, String email) async {
  var url = path_ubiattendance+"mailVerification";
  final response = await http.post(url, body: {
    "orgid":orgid,"email":email,"name":name,});
  print(path_ubiattendance+'mailVerification?&orgid=$orgid&email=$email&name=$name');
  print (response.body.toString());
  return response.body.toString();
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
    print(path + "getfiscalyear?employeeid=${emp.employeeid}&organization=${emp.organization}");
    Response<String> response = await dio.post(path + "getfiscalyear", data: formData);

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

/*getCountAproval() async{
  final prefs = await SharedPreferences.getInstance();
  //String path1 = prefs.getString('path');
  Dio dio = new Dio();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";

  var response =  await dio.post(path+"getapprovalCount?empid="+empid+"&orgid="+orgdir);
  print(path+"getapprovalCount?empid="+empid+"&orgid="+orgdir);
  Map responseJson = json.decode(response.data.toString());

  if(responseJson['total']>0) {
    prefs.setInt('approvalcount', responseJson['total']);
    return true;
  }else{
    prefs.setInt('approvalcount', responseJson['total']);
    return false;
  }

}*/

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
  int leavecount;
  int timeoffcount;
  int expensecount;
  int payrollexpensecount;
  int total;

  if(perLeaveApproval=='1') {
    print(path + "getLeaveApprovalCount?empid=" + empid + "&orgid=" + orgdir);
    final res1 = await http.get(path + "getLeaveApprovalCount?empid=" + empid + "&orgid=" + orgdir);
    //Map responseJson1 = json.decode(response.data.toString());
    /*prefs.setInt('leavecount', responseJson1['leavecount']);
    leavecount = prefs.getInt('leavecount')??"";*/
    leavecount=json.decode(res1.body);
    print(leavecount);
  }else{
    leavecount=0;
  }

  if(perTimeoffApproval=='1') {
    print(path + "getTimeoffApprovalCount?empid=" + empid + "&orgid=" + orgdir);
    final res2 = await http.get(path + "getTimeoffApprovalCount?empid=" + empid + "&orgid=" + orgdir);
    //Map responseJson2 = json.decode(response.data.toString());
    /*prefs.setInt('timeoffcount', responseJson2['timeoffcount']);
    timeoffcount = prefs.getInt('timeoffcount')??"";*/
    timeoffcount=json.decode(res2.body);
    print(timeoffcount);
  }else{
    timeoffcount=0;
  }

  if(perSalaryExpenseApproval=='1') {
    print(path + "getSalaryExpenseApprovalCount?empid=" + empid + "&orgid=" + orgdir);
    final res3 = await http.get(path + "getSalaryExpenseApprovalCount?empid=" + empid + "&orgid=" + orgdir);
    /*Map responseJson3 = json.decode(response.data.toString());
    prefs.setInt('expensecount', responseJson3['expensecount']);
    expensecount = prefs.getInt('expensecount')??"";*/
    expensecount=json.decode(res3.body);
    print(expensecount);
  }else{
    expensecount=0;
  }

  if(perPayrollExpenseApproval=='1') {
    print(path + "getPayrollExpenseApprovalCount?empid=" + empid + "&orgid=" + orgdir);
    final res4 = await http.get(path + "getPayrollExpenseApprovalCount?empid=" + empid + "&orgid=" + orgdir);
    /*Map responseJson4 = json.decode(response.data.toString());
    prefs.setInt('payrollexpensecount', responseJson4['payrollexpensecount']);
    payrollexpensecount = prefs.getInt('payrollexpensecount')??"";*/
    payrollexpensecount=json.decode(res4.body);
    print(payrollexpensecount);
  }else{
    payrollexpensecount=0;
  }

  total = leavecount+timeoffcount+expensecount+payrollexpensecount;
  print(total);
  return total;
  /*if(total>0) {
    //prefs.setInt('approvalcount', total);
    return true;
  } else {
    //prefs.setInt('approvalcount', total);
    return false;
  }*/

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

  List<Team> teamlist = createTeamList(responseJson);
  return teamlist;

}

List<Team> createTeamList(List data) {
  List<Team> list = new List();
  List<dynamic> juniorlist = new List();
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
    Team team = new Team(Id: Id, FirstName: FirstName, LastName: LastName, Designation: Designation, DOB: DOB, Nationality: Nationality, BloodGroup: BloodGroup, CompanyEmail: CompanyEmail, ProfilePic: ProfilePic, ParentId:ParentId, juniorlist:juniorlist);
    list.add(team);
  }

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
  print("response.data.toString()");
  print(response.data.toString());
  List responseJson = json.decode(response.data.toString());
  print("responseJson");
  print(responseJson);
  List<Holi> holilist = createHolidayList(responseJson);
  print("holilist");
  print(holilist);
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

  Future<String> updateProfilePhoto(int uploadtype, String empid, String orgid) async {
    String img="";
    //String path_hrm_india1 = prefs.getString('path_hrm_india');
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
        img=globalcompanyinfomap['ProfilePic'].split('/').last;
        //print("img name form profile info");
        //print(img);
        imagei = null;
      }

      if(imagei!=null ) {
        FormData formData = new FormData.from({
          "uid": empid,
          "refno": orgid,
          "file": new UploadFileInfo(imagei, "sample.png"),
        });
        print(path_hrm_india+"updateProfilePhoto?uid=$empid&refno=$orgid&file=$imagei");
        Response<String> response1=await dio.post(path_hrm_india+"updateProfilePhoto",data:formData);
        imagei.deleteSync();
        imageCache.clear();
        Map MarkAttMap = json.decode(response1.data);
        if (MarkAttMap["status"])
          return "true";
        else
          return "false";
      }else if(uploadtype==3 && imagei==null){
        if(img!="default.png"){
          FormData formData = new FormData.from({
            "uid": empid,
            "refno": orgid,
          });
          print("imagei==null");
          print(imagei==null);
          print(path_hrm_india+"updateProfilePhoto?uid=$empid&refno=$orgid");
          Response<String> response1=await dio.post(path_hrm_india+"updateProfilePhoto",data:formData);
          Map MarkAttMap = json.decode(response1.data);
          if (MarkAttMap["status"])
            return "true";
          else
            return "false";
        }else{
          return "1";
        }
      }else{
        return "false";
      }
    } catch (e) {
      print(e.toString());
      return "false";
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

getAddressFromLati( String Latitude, String Longitude) async{
  try {
    if (assign_lat.compareTo(0.0) != 0&& assign_lat!=null) {
      var addresses = await Geocoder.local.findAddressesFromCoordinates(
          Coordinates(assign_lat, assign_long));
      var first = addresses.first;
      var streamlocationaddr = "${first.addressLine}";
      var city = "${first.locality}";

      globalstreamlocationaddr = streamlocationaddr;
      globalcity = city;
      return streamlocationaddr;
    } else{
      globalstreamlocationaddr="Location not fetched.";

      return globalstreamlocationaddr;
    }

  }catch(e){
    print(e.toString());
    if (assign_lat.compareTo(0.0) != 0&& assign_lat!=null) {
      globalstreamlocationaddr = "$Latitude,$Longitude";
      print("inside iffffffffffffffffffffffffffffffffffffffffffffffsfhjsafhjasfjhffh"+assign_lat.toString());
    }
    else{
      globalstreamlocationaddr="Location not fetched.";
    }

    return globalstreamlocationaddr;
  }
}

Future<String> getAreaStatus() async {
  double lat = globals.assign_lat;
  double long = globals.assign_long;
  double assign_lat = globals.assigned_lat;
  double assign_long = globals.assigned_long;
  double assign_radius = globals.assign_radius;
  print('getareastatusfunctionstart');
  print(lat);
  print(long);
  print(assign_lat);
  print(assign_long);
  print('getareastatusfunctionend');

  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String status = '0';
  if (empid != null && empid != '' && empid != 0) {
    double calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }

    double totalDistance =
    calculateDistance(lat, long, assign_lat, assign_long);
    status = (assign_radius >= totalDistance) ? '1' : '0';
    print("status");
    print(status);
  }
  print(status);
  globals.areaSts=status;
  return status;
}