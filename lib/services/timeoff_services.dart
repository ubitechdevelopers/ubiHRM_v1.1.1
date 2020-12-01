import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/global.dart' as globals;
import 'package:ubihrm/model/model.dart';


class TIMEOFFA {
  String Id;
  String name;
  String Timeoffsts;
  String Reason;
  String ApproverComment;
  String applydate;
  String Fdate;
  String Tdate;
  String StartTimeFrom;
  String StopTimeTo;
  String Psts;
  String HRSts;
  String FromDayType;
  String ToDayType;
  String TimeOfTo;
  String TimeoffId;
  String TimeOffSts;
  String sts;
  String TimeofDate;

  TIMEOFFA({
    this.Id,
    this.name,
    this.Timeoffsts,
    this.Reason,
    this.ApproverComment,
    this.applydate,
    this.Fdate,
    this.Tdate,
    this.StartTimeFrom,
    this.StopTimeTo,
    this.Psts,
    this.HRSts,
    this.FromDayType,
    this.ToDayType,
    this.TimeOfTo,
    this.TimeoffId,
    this.TimeOffSts,
    this.sts,
    this.TimeofDate
  });
}


class MarkStartTimeOff{
  String empid;
  String orgid;
  DateTime time;
  String act;
  String timeoffId;
  String location;
  String latit;
  String longi;

  MarkStartTimeOff(this.empid, this.orgid, this.time, this.act, this.timeoffId, this.location, this.latit, this.longi);

  MarkStartTimeOff.fromMap(Map map){
    empid = map[empid];
    orgid = map[orgid];
    time = map[time];
    act = map[act];
    timeoffId = map[timeoffId];
    location = map[location];
    latit = map[latit];
    longi = map[longi];
  }

  MarkStartTimeOff.fromJson(Map map){
    empid = map[empid];
    orgid = map[orgid];
    time = map[time];
    act = map[act];
    timeoffId = map[timeoffId];
    location = map[location];
    latit = map[latit];
    longi = map[longi];
  }

}


class RequestTimeOffService{
  var dio = new Dio();
  requestTimeOff(TimeOff timeoff) async{
    try {
      FormData formData = new FormData.from({
        "orgid": timeoff.OrgId,
        "uid": timeoff.EmpId,
        "date": timeoff.TimeofDate,
        "stime": timeoff.TimeFrom,
        "etime": timeoff.TimeTo,
        "reason": timeoff.Reason
      });
      print(timeoff.TimeofDate);
      print(path_hrm_india+"reqForTimeOff?orgid=${timeoff.OrgId}&uid=${timeoff.EmpId}&date=${timeoff.TimeofDate}&stime=${timeoff.TimeFrom}&etime=${timeoff.TimeTo}&reason=${timeoff.Reason}");
      Response response1 = await dio.post(path_hrm_india+"reqForTimeOff", data: formData);

      final timeoffMap = response1.data.toString();
      if (timeoffMap.contains("false")) {
        return "false";
      }else if (timeoffMap.contains("1")){
        return "1";
      }else if (timeoffMap.contains("2")){
        return "2";
      }else if (timeoffMap.contains("3")){
        return "3";
      }else if (timeoffMap.contains("4")){
        return "4";
      }else if (timeoffMap.contains("5")){
        return "5";
      }else if (timeoffMap.contains("6")){
        return "6";
      }else if (timeoffMap.contains("7")){
        return "7";
      }else {
        return "true";
      }
    }catch(e){
      print(e.toString());
      return "No Connection";
    }
  }

  withdrawTimeOff(TimeOff timeoff) async{
    try {
      FormData formData = new FormData.from({
        "timeoffid": timeoff.TimeOffId,
        "uid": timeoff.EmpId,
        "orgid": timeoff.OrgId,
        "timeoffsts": timeoff.ApprovalSts
      });
      print(path_hrm_india+"changetimeoffsts?timeoffid=${timeoff.TimeOffId}&uid=${timeoff.EmpId}&orgid=${timeoff.OrgId}&timeoffsts=${timeoff.ApprovalSts}");
      Response response = await dio.post(path_hrm_india+"changetimeoffsts", data: formData);
      if (response.statusCode == 200) {
        final timeoffMap = response.data.toString();
        if (timeoffMap.contains("true")) {
          return "success";
        } else {
          return "failure";
        }
      }else{
        return "No Connection";
      }
    }catch(e){
      print(e.toString());
      return "Poor network connection";
    }
  }
}


class SaveTimerTime {
  Future<String> saveTimeOff(MarkStartTimeOff mk) async {
    try {
      Dio dio = new Dio();
      final prefs = await SharedPreferences.getInstance();
      String orgid = prefs.getString('organization') ?? '';
      String empid = prefs.getString('employeeid')??"";
      String location = globals.globalstreamlocationaddr;
      LocationData _currentLocation = globals.list[globals.list.length - 1];
      String lat = _currentLocation.latitude.toString();
      String long = _currentLocation.longitude.toString();
      FormData formData = new FormData.from({
        "empid": empid,
        "orgid": orgid,
        "time": mk.time,
        "act":  mk.act,
        "timeoffId": mk.timeoffId,
        "location": location,
        "latit": lat,
        "longi": long,
      });
      print("Start Timer");
      print(path + "saveTime?&empid=$empid&orgid=$orgid&timeoffId=${mk.timeoffId}&time=${mk.time}&act=${mk.act}&location=$location&latit=$lat&longi=$long");
      Response response1 = await dio.post(path + "saveTime", data: formData);
      final timeoff = response1.data.toString();
      print("timeoff");
      print(timeoff);
      if (timeoff.contains("true")) {
        return "true";
      } else if(timeoff.contains("unmarked")){
        return "unmarked";
      }else {
        return "false";
      }
    } catch (e) {
      return "false";
    }
  }


  /*Future<bool> saveStartTimeOff(MarkStartTimeOff mk) async {
    try {
      Dio dio = new Dio();
      final prefs = await SharedPreferences.getInstance();
      String orgid = prefs.getString('organization') ?? '';
      String empid = prefs.getString('employeeid')??"";
      String location = globals.globalstreamlocationaddr;
      LocationData _currentLocation = globals.list[globals.list.length - 1];
      String lat = _currentLocation.latitude.toString();
      String long = _currentLocation.longitude.toString();
      FormData formData = new FormData.from({
        "empid": empid,
        "orgid": orgid,
        "time": mk.time,
        "timeoffId": mk.timeoffId,
        "location": location,
        "latit": lat,
        "longi": long,
      });
      print("Start Timer");
      print(path + "saveStartTime?&empid=$empid&orgid=$orgid&timeoffId=${mk.timeoffId}&time=${mk.time}&location=$location&latit=$lat&longi=$long");
      Response response1 = await dio.post(path + "saveStartTime", data: formData);
      final timeoff = response1.data.toString();
      print("timeoff");
      print(timeoff);
      if (timeoff.contains("true")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }


  Future<bool> saveStopTimeOff(MarkStartTimeOff mk) async {
    try {
      Dio dio = new Dio();
      final prefs = await SharedPreferences.getInstance();
      String orgid = prefs.getString('organization') ?? '';
      String empid = prefs.getString('employeeid')??"";
      String location = globals.globalstreamlocationaddr;
      LocationData _currentLocation = globals.list[globals.list.length - 1];
      String lat = _currentLocation.latitude.toString();
      String long = _currentLocation.longitude.toString();
      FormData formData = new FormData.from({
        "empid": empid,
        "orgid": orgid,
        "time": mk.time,
        "timeoffId": mk.timeoffId,
        "location": location,
        "latit": lat,
        "longi": long,
      });
      print("Start Timer");
      print(path + "saveStopTime?&empid=$empid&orgid=$orgid&timeoffId=${mk.timeoffId}&time=${mk.time}&location=$location&latit=$lat&longi=$long");
      Response response1 = await dio.post(path + "saveStopTime", data: formData);
      final timeoff = response1.data.toString();
      print("timeoff");
      print(timeoff);
      if (timeoff.contains("true")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }*/
}


Future<List<TimeOff>> getTimeOffSummary() async{
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  try {
    FormData formData = new FormData.from({
      "uid": empid,
    });
    print(path_ubiattendance+"fetchTimeOffList?uid=$empid");
    Response response = await dio.post(path_ubiattendance+"fetchTimeOffList", data: formData);
    List responseJson = json.decode(response.data.toString());
    print( json.decode(response.data.toString()));
    List<TimeOff> userList = createTimeOffList(responseJson);
    return userList;
  }catch(e){
    print(e.toString());
  }
}

List<TimeOff> createTimeOffList(List data){
  List<TimeOff> list = new List();
  for (int i = 0; i < data.length; i++) {
    String TimeOffId=data[i]["timeoffid"].toString();
    String TimeofDate = data[i]["date"];
    String TimeFrom=data[i]["from"];
    String TimeTo=data[i]["to"];
    String StartTimeFrom=data[i]["startfrom"];
    String StopTimeTo=data[i]["endto"];
    String TimeOffSts=data[i]["timeoffsts"];
    String hrs=data[i]["hrs"];
    String Reason=data[i]["reason"];
    String ApprovalSts=data[i]["status"];
    String ApproverComment=data[i]["comment"];
    bool withdrawlsts=data[i]["withdrawlsts"];
    bool starticonsts=data[i]["starticonsts"];
    bool stopiconsts=data[i]["stopiconsts"];

    TimeOff timeoff = new TimeOff(TimeofDate: TimeofDate, TimeFrom: TimeFrom, TimeTo: TimeTo, StartTimeFrom: StartTimeFrom, StopTimeTo: StopTimeTo, TimeOffSts: TimeOffSts, hrs: hrs, Reason: Reason, ApprovalSts: ApprovalSts, ApproverComment: ApproverComment, TimeOffId: TimeOffId, withdrawlsts: withdrawlsts, starticonsts: starticonsts, stopiconsts: stopiconsts);

    list.add(timeoff);
  }
  return list;
}


Future<List<TIMEOFFA>> getTimeoffapproval(listType) async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('organization')??"";
  String empid =  prefs.getString('employeeid')??"";
  int hrsts =  prefs.getInt('hrsts')??0;
  int adminsts =  prefs.getInt('adminsts')??0;
  int divhrsts =  prefs.getInt('divhrsts')??0;
  print(path+"getTimeoffapproval?datafor="+listType+'&empid='+empid+'&orgid='+orgdir);
  Response<String>response = await dio.post(path+"getTimeoffapproval?datafor="+listType+'&empid='+empid+'&orgid='+orgdir);
  final res = json.decode(response.data.toString());
  print(res);
  List<TIMEOFFA> userList = createtimeoffapporval(res);
  return userList;
}

List<TIMEOFFA> createtimeoffapporval(List data) {
  List<TIMEOFFA> list = new List();
  for (int i = 0; i < data.length; i++) {
    String Id = data[i]["Id"].toString();
    String name = data[i]["name"].toString();
    String Timeoffsts = data[i]["LeaveStatus"].toString();
    String Reason = data[i]["LeaveReason"].toString();
    String ApproverComment = data[i]["comment"].toString();
    String applydate = data[i]["ApplyDate"].toString();
    String TimeofDate = data[i]["TimeofDate"].toString();
    String Fdate = data[i]["FDate"].toString();
    String Tdate = data[i]["TDate"].toString();
    String StartTimeFrom=data[i]["startfrom"];
    String StopTimeTo=data[i]["endto"];
    String TimeOffSts=data[i]["timeoffsts"];
    String HRSts = data[i]["HRSts"].toString();
    String Psts="";
    if(data[i]["Pstatus"].contains("Pending at")) {
      Psts = data[i]["Pstatus"].toString();
    }

    TIMEOFFA tos = new TIMEOFFA(
      Id: Id,
      name: name,
      Timeoffsts: Timeoffsts,
      Reason: Reason,
      ApproverComment: ApproverComment,
      applydate: applydate,
      TimeofDate:TimeofDate,
      Fdate: Fdate,
      Tdate: Tdate,
      StartTimeFrom: StartTimeFrom,
      StopTimeTo: StopTimeTo,
      TimeOffSts: TimeOffSts,
      Psts : Psts,
      HRSts: HRSts,
    );
    list.add(tos);
  }
  return list;
}


Future<List<TIMEOFFA>> getTeamTimeoffapproval(empname) async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('organization') ?? '';
  String empid =  prefs.getString('employeeid')??"";
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  print(path+"getTeamTimeoffapproval?&empid=$empid&orgid=$orgdir&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess");
  Response<String>response = await dio.post(path+"getTeamTimeoffapproval?&empid=$empid&orgid=$orgdir&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess");
  final res = json.decode(response.data.toString());
  List<TIMEOFFA> userList1 = createteamtimeoffapporval(res,empname);
  return userList1;
}

List<TIMEOFFA> createteamtimeoffapporval(List data,String empname) {
  List<TIMEOFFA> list = new List();
  if(empname.isNotEmpty)
    for (int i = 0; i < data.length; i++) {
      String Id = data[i]["Id"].toString();
      String name = data[i]["name"].toString();
      String Timeoffsts = data[i]["LeaveStatus"].toString();
      String Reason = data[i]["LeaveReason"].toString();
      String ApproverComment = data[i]["comment"].toString();
      String applydate = data[i]["ApplyDate"].toString();
      String TimeofDate = data[i]["TimeofDate"].toString();
      String Fdate = data[i]["FDate"].toString();
      String Tdate = data[i]["TDate"].toString();
      String StartTimeFrom=data[i]["startfrom"];
      String StopTimeTo=data[i]["endto"];
      String TimeOffSts=data[i]["timeoffsts"];
      String sts = data[i]["sts"].toString();
      String HRSts = data[i]["HRSts"].toString();
      String Psts="";
      if(data[i]["Pstatus"].contains("Pending at")) {
        Psts = data[i]["Pstatus"].toString();
      }

      TIMEOFFA tos = new TIMEOFFA(
        Id: Id,
        name: name,
        Timeoffsts: Timeoffsts,
        Reason: Reason,
        ApproverComment: ApproverComment,
        applydate: applydate,
        Fdate: Fdate,
        Tdate: Tdate,
        StartTimeFrom: StartTimeFrom,
        StopTimeTo: StopTimeTo,
        TimeOffSts: TimeOffSts,
        Psts : Psts,
        HRSts: HRSts,
        sts :sts,
        TimeofDate:TimeofDate,
      );
      if(name.toLowerCase().contains(empname.toLowerCase()))
        list.add(tos);
    }
  else
    for (int i = 0; i < data.length; i++) {
      String Id = data[i]["Id"].toString();
      String name = data[i]["name"].toString();
      String Timeoffsts = data[i]["LeaveStatus"].toString();
      String Reason = data[i]["LeaveReason"].toString();
      String ApproverComment = data[i]["comment"].toString();
      String applydate = data[i]["ApplyDate"].toString();
      String TimeofDate = data[i]["TimeofDate"].toString();
      String Fdate = data[i]["FDate"].toString();
      String Tdate = data[i]["TDate"].toString();
      String StartTimeFrom=data[i]["startfrom"];
      String StopTimeTo=data[i]["endto"];
      String TimeOffSts=data[i]["timeoffsts"];
      String sts = data[i]["sts"].toString();
      String HRSts = data[i]["HRSts"].toString();
      String Psts="";
      if(data[i]["Pstatus"].contains("Pending at")) {
        Psts = data[i]["Pstatus"].toString();
      }

      TIMEOFFA tos = new TIMEOFFA(
        Id: Id,
        name: name,
        Timeoffsts: Timeoffsts,
        Reason: Reason,
        ApproverComment: ApproverComment,
        applydate: applydate,
        Fdate: Fdate,
        Tdate: Tdate,
        StartTimeFrom: StartTimeFrom,
        StopTimeTo: StopTimeTo,
        TimeOffSts: TimeOffSts,
        Psts : Psts,
        HRSts: HRSts,
        sts :sts,
        TimeofDate:TimeofDate,
      );
      list.add(tos);
    }
  return list;
}


ApproveTimeoff(timeoffid,comment,sts) async{
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
      "timeoffid": timeoffid,
      "comment": comment,
      "sts": sts,
    });
    print(path+"approvetimeoffapproval?&eid=$empid&orgid=$organization&timeoffid=$timeoffid&comment=$comment&sts=$sts");
    Response response = await dio.post(path+"approvetimeoffapproval", data: formData);
    final timeoffMap = response.data.toString();
    if (timeoffMap.contains("false")) {
      return "false";
    } else {
      return "true";
    }
  }catch(e){
    return "Poor network connection";
  }
}