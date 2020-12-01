import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/model/model.dart';


///////////////////////////////////* SERVICE TO REQUEST FOR LEAVE STARTS FROM HERE *//////////////////////////////////////
requestLeave(Leave leave) async{
  Dio dio = new Dio();
  try {
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
      "substituteemp": leave.substituteemp,
      "compoffsts": leave.compoffsts
    });

    Response response1 = await dio.post(path_hrm_india+"reqForLeave", data: formData);
    print('*************REQUEST FOR LEAVE***********');
    print(path_hrm_india+"reqForLeave?orgid=${leave.orgid}&uid=${leave.uid}&leavefrom=${leave.leavefrom}&leaveto=${leave.leaveto}&leavetypefrom=${leave.leavetypefrom}&leavetypeto=${leave.leavetypeto}&halfdayfromtype=${leave.halfdayfromtype}&halfdaytotype=${leave.halfdaytotype}&leavetypeid=${leave.leavetypeid}&reason=${leave.reason}&substituteemp=${leave.substituteemp}&compoffsts=${leave.compoffsts}");
    final leaveMap = response1.data.toString();
    if (leaveMap.contains("false")) {
      return "false";
    } else if (leaveMap.contains("wrong")) {
      return "wrong";
    } else if (leaveMap.contains("You cannot apply more than credited leaves")) {
      return "You cannot apply more than credited leaves";
    } else if (leaveMap.contains("You cannot apply for comp off")) {
      return "You cannot apply for comp off";
    } else if (leaveMap.contains("alreadyApply")) {
      return "alreadyApply";
    } else {
      return "true";
    }
  }
  catch(e){
    print(e.toString());
    return "No Connection";
  }
}
///////////////////////////////////* SERVICE TO REQUEST FOR LEAVE ENDS HERE *//////////////////////////////////////


///////////////////////////////////////////* SERVICE TO WITHRAW LEAVE STARTS FROM HERE *//////////////////////////////////////////
withdrawLeave(Leave leave) async{
  Dio dio = new Dio();
  try {
    final prefs = await SharedPreferences.getInstance();
    FormData formData = new FormData.from({
      "leaveid": leave.leaveid,
      "uid": leave.uid,
      "orgid": leave.orgid,
      "leavests": leave.approverstatus,
      "compoffsts": leave.compoffsts
    });
    print(path_hrm_india+"changeleavests?leaveid=${leave.leaveid}&uid=${leave.uid}&orgid=${leave.orgid}&leavests=${leave.approverstatus}&compoffsts=${leave.compoffsts}");
    Response response = await dio.post(path_hrm_india+"changeleavests", data: formData);
    if (response.statusCode == 200) {
      final leaveMap = response.data.toString();
      if(leaveMap.contains("true")){
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
///////////////////////////////////////////* SERVICE TO WITHRAW LEAVE ENDS HERE *//////////////////////////////////////////


Future<List<Leave>> getLeaveSummary() async{
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  try {
    FormData formData = new FormData.from({
      "uid": empid,
    });
    Response response = await dio.post(path+"getLeaveList", data: formData);
    print(path+"getLeaveList&uid=$empid");
    List responseJson = json.decode(response.data.toString());
    List<Leave> userList = createLeaveList(responseJson);
    return userList;
  }catch(e){
    print(e.toString());
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
    String leavetype=data[i]["leavetype"];
    String compoffsts=data[i]["compoffsts"];
    bool withdrawlsts=data[i]["withdrawlsts"];
    if(LeaveFrom==LeaveTo){
      LeaveTo=" - "+LeaveFrom;
    } else{
      LeaveTo=" - "+LeaveTo;
    }
    Leave leave = new Leave(attendancedate: LeaveDate, leavefrom: LeaveFrom, leaveto: LeaveTo, leavedays: LeaveDays, reason: Reason, approverstatus: ApprovalSts, comment: ApproverComment, leaveid: LeaveId, leavetype: leavetype, compoffsts:compoffsts, withdrawlsts: withdrawlsts);
    list.add(leave);
  }
  return list;
}


Future<List<Map>> getleavetype(int label) async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  print(path + "getEmployeeAllLeaveType?orgid=$orgdir&eid=$empid");
  final response = await dio.post(path+"getEmployeeAllLeaveType?orgid=$orgdir&eid=$empid");
  List data = json.decode(response.data.toString());
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

  for (int i = 0; i < data.length; i++) {
    Map tos={"Name":data[i]["name"].toString()  +" ("+data[i]["leftleave"].toString()+" Remaining)" ,"Id":data[i]["id"].toString(),"compoffsts":data[i]["compoffsts"].toString()};
    list.add(tos);
  }
  return list;
}


///////////////////////////////////////*Substitute Employee Dropdown////////////////////////////////////////////
Future<List<Map>> getsubstitueemp(int label) async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  String orgdir = prefs.getString('organization') ??"";
  String empid = prefs.getString('employeeid')??"";
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  final response = await dio.post(path + "getEmployeeHierarchy?orgid=$orgdir&eid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess");
  print(path + "getEmployeeHierarchy?orgid=$orgdir&eid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess");
  List data = json.decode(response.data.toString());
  List<Map> substituteemp = createsubstituteempList(data,label);
  return substituteemp;
}

List<Map> createsubstituteempList(List data,int label) {
  List<Map> list = new List();
  if(label==1) // with -All- label
    list.add({"Id":"0","Name":"-All-"});
  else
    list.add({"Id":"0","Name":"-Select-"});

  for (int i = 0; i < data.length; i++) {
    Map tos={"Name":data[i]["name"].toString(),"Id":data[i]["id"].toString()};
    list.add(tos);
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
  List data = json.decode(response.data.toString());
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
  String DivHrSts;
  String FromDayType;
  String ToDayType;
  String TimeOfTo;
  String LeaveTypeId;
  String sts;
  String LeaveType;

  LeaveA({ this.Id,
        this.name,
        this.Leavests,
        this.Reason,
        this.applydate,
        this.Fdate,
        this.Tdate,
        this.Psts,
        this.Ldays,
        this.HRSts,
        this.DivHrSts,
        this.FromDayType,
        this.ToDayType,
        this.TimeOfTo,
        this.LeaveTypeId,
        this.sts,
        this.LeaveType,
      });
}


Future<List<LeaveA>> getApprovals(listType) async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Response<String> response = await dio.post(path+"getapproval?datafor="+listType+'&empid='+empid+'&orgid='+orgdir);
  print(path+"getapproval?datafor="+listType+'&empid='+empid+'&orgid='+orgdir);
  final res = json.decode(response.data.toString());
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
    String LeaveType = data[i]["LeaveType"].toString();
    String HRSts = data[i]["HRSts"].toString();
    String DivHrSts = data[i]["divhrsts"].toString();
    if(Fdate==Tdate){
      Tdate=" - "+Fdate;
    } else{
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
        HRSts: HRSts,
        DivHrSts: DivHrSts,
        FromDayType: FromDayType,
        ToDayType: ToDayType,
        TimeOfTo: TimeOfTo,
        LeaveTypeId :LeaveTypeId,
        LeaveType: LeaveType
    );
    list.add(tos);
  }
  return list;
}


////////////////////////////////////* SERVICE TO APPROVE LEAVE STARTS FROM HERE *///////////////////////////////////////
ApproveLeave(Leaveid,comment,sts) async{
  String empid;
  String organization;
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  empid = prefs.getString('employeeid')??"";
  organization =prefs.getString('organization')??"";
  organization =prefs.getString('organization')??"";
  try {
    FormData formData = new FormData.from({
      "eid": empid,
      "orgid": organization,
      "leaveid": Leaveid,
      "comment": comment,
      "sts": sts,
    });
    print(path+"Approvedleave?&eid=$empid&orgid=$organization&leaveid=$Leaveid&comment=$comment&sts=$sts");
    Response response = await dio.post(path+"Approvedleave", data: formData);
    final leaveMap = response.data.toString();
    if (leaveMap.contains("false")) {
      return "false";
    } else {
      return "true";
    }
  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }
}


ApproveLeaveByHr(Leaveid,comment,sts,LBD) async{
  String empid;
  String organization;
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  empid = prefs.getString('employeeid')??"";
  organization =prefs.getString('organization')??"";
  try {
    FormData formData = new FormData.from({
      "eid": empid,
      "orgid": organization,
      "leaveid": Leaveid,
      "comment": comment,
      "sts": sts,
      "LBD": LBD,
    });

    Response response = await dio.post(path+"ApprovedleaveBYHr", data: formData);
    final leaveMap = response.data.toString();
    if (leaveMap.contains("false")) {
      return "false";
    } else {
      return "true";
    }
  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }
}
////////////////////////////////////* SERVICE TO APPROVE LEAVE ENDS HERE *///////////////////////////////////////


Future<List<LeaveA>> getTeamApprovals(empname) async {
  print("empname354435453456657");
  print(empname);
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('organization') ??"";
  String empid = prefs.getString('employeeid')??"";
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  print(path+"getteamapproval?empid=$empid&orgid=$orgdir&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess");
  Response<String> response=await dio.post(path+"getteamapproval?empid=$empid&orgid=$orgdir&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess");
  final res = json.decode(response.data.toString());
  List<LeaveA> userList1 = createTeamleaveapporval(res,empname);
  return userList1;
}

List<LeaveA> createTeamleaveapporval(List data, String empname) {
  List<LeaveA> list = new List();
  if(empname.isNotEmpty)
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
      String LeaveType = data[i]["LeaveType"].toString();
      String sts = data[i]["sts"].toString();
      String HRSts = data[i]["HRSts"].toString();
      if(Fdate==Tdate){
        Tdate=" - "+Fdate;
      }else{
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
          HRSts: HRSts,
          FromDayType: FromDayType,
          ToDayType: ToDayType,
          TimeOfTo: TimeOfTo,
          LeaveTypeId: LeaveTypeId,
          LeaveType :LeaveType,
          sts :sts);
      if(name.toLowerCase().contains(empname.toLowerCase()))
        list.add(tos);
    }
  else
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
      String LeaveType = data[i]["LeaveType"].toString();
      String sts = data[i]["sts"].toString();
      String HRSts = data[i]["HRSts"].toString();
      if(Fdate==Tdate){
        Tdate=" - "+Fdate;
      }else{
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
          HRSts: HRSts,
          FromDayType: FromDayType,
          ToDayType: ToDayType,
          TimeOfTo: TimeOfTo,
          LeaveTypeId: LeaveTypeId,
          LeaveType :LeaveType,
          sts :sts);
      list.add(tos);
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


Future<List<EmpListLeave>> getEmployeeLeaveList(date,emp) async {
  Dio dio = new Dio();
  if (date == '' || date == null) return null;
  try {
    final prefs = await SharedPreferences.getInstance();
    String orgid = prefs.getString('orgdir') ?? '';
    String empid = prefs.getString('employeeid') ?? '';
    int profiletype = prefs.getInt('profiletype')??0;
    int hrsts =prefs.getInt('hrsts')??0;
    int adminsts =prefs.getInt('adminsts')??0;
    int dataaccess = prefs.getInt('dataaccess')??0;
    int divhrsts = prefs.getInt('divhrsts')??0;
    print(path_hrm_india + 'getEmployeeLeaveList?fd=$date&orgid=$orgid&empid=$empid&emp=$emp&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
    final response = await dio.post(path_hrm_india + 'getEmployeeLeaveList?fd=$date&orgid=$orgid&empid=$empid&emp=$emp&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
    List responseJson = json.decode(response.data.toString());
    List<EmpListLeave> list = createEmployeeLeaveDataList(responseJson);
    return list;
  }catch(e){
    print(e.toString());
  }
}

List<EmpListLeave> createEmployeeLeaveDataList(List data) {
  List<EmpListLeave> list = new List();
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

///////////////////////////////////////*COMP OFF LEAVE SERVICE STARTS FROM HERE*////////////////////////////////////////
class EmpCompOffLeave {
  String id;
  String empname;
  int credited;
  int utilized;
  EmpCompOffLeave({this.id, this.empname, this.credited, this.utilized});
}


Future<List<EmpCompOffLeave>> getCompOffLeave(emp) async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  String orgid = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  int divhrsts = prefs.getInt('divhrsts')??0;
  print(path_hrm_india + "getCompOffLeave?orgid=$orgid&empid=$empid&emp=$emp&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess&divhrsts=$divhrsts");
  final response = await dio.post(path_hrm_india+"getCompOffLeave?orgid=$orgid&empid=$empid&emp=$emp&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess&divhrsts=$divhrsts");
  List data = json.decode(response.data.toString());
  print(data);
  List<EmpCompOffLeave> compoffleavecount = createCompOffList(data);
  return compoffleavecount;
}

List<EmpCompOffLeave> createCompOffList(List data) {
  List<EmpCompOffLeave> list = new List();
  for (int i = 0; i < data.length; i++) {
    String id = data[i]["id"];
    String empname = data[i]["empname"];
    int credited = data[i]["initialbalance"];
    int utilized = data[i]["utilized"];
    EmpCompOffLeave row = new EmpCompOffLeave(
        id: id, empname: empname, credited: credited, utilized: utilized);
    list.add(row);
  }
  return list;
}
///////////////////////////////////////*COMP OFF LEAVE SERVICE ENDS HERE*////////////////////////////////////////