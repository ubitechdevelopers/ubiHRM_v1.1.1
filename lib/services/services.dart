import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/model/model.dart';
import 'package:dio/dio.dart';
import 'package:ubihrm/global.dart';
import 'dart:convert';
import 'dart:async';


getAllPermission(Employee emp) async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  FormData formData = new FormData.from({
    "employeeid": emp.employeeid,
    "organization": emp.organization
  });

  Response<String> response =
  await dio.post(path + "getAllPermission", data: formData);
  print(response.toString());
  List responseJson = json.decode(response.data.toString());
  //print("1.  "+responseJson.toString());
  List<Permission> permlist = createPermList(responseJson);
  //print("3. "+permlist.toString());
  globalpermissionlist = permlist;
}

getProfileInfo(Employee emp) async{
  final prefs = await SharedPreferences.getInstance();
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

  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }



}

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
  print(responseJson);
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
  for (int i = 0; i < list.length; i++) {
    //print("permisstion list "+list[i].permissionlist.toString());
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
      "reason": leave.reason
    });

    Response response1 = await dio.post(path_hrm_india+"reqForLeave", data: formData);
    //print(response1.toString());
    if (response1.statusCode == 200) {
      Map leaveMap = json.decode(response1.data);
      //print(leaveMap["status"]);
      return leaveMap["status"].toString();
    }else{
      return "No Connection";
    }

  }catch(e){
    //print(e.toString());
    return "No Connection";
  }
}

Future<List<Leave>> getLeaveSummary(String empid) async{
  Dio dio = new Dio();
  try {
    FormData formData = new FormData.from({
      "uid": empid,
    });
    //Response response = await dio.post("https://sandbox.ubiattendance.com/index.php/services/getInfo", data: formData);
    Response response = await dio.post(
        path_ubiattendance+"getLeaveList",
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
