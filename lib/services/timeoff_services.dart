import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/model/model.dart';
import 'package:dio/dio.dart';
import 'package:ubihrm/global.dart';
import 'dart:convert';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/painting.dart';
import 'dart:io';


class RequestTimeOffService{

  var dio = new Dio();

  requestTimeOff(TimeOff timeoff) async{
   // print("abcd");
    try {
   //   print("efgh");
      FormData formData = new FormData.from({
        "orgid": timeoff.OrgId,
        "uid": timeoff.EmpId,
        "date": timeoff.TimeofDate,
        "stime": timeoff.TimeFrom,
        "etime": timeoff.TimeTo,
        "reason": timeoff.Reason
      });
     //print("ORGANIZATIONID"+timeoff.OrgId);
      Response response1 = await dio.post(path_hrm_india+"reqForTimeOff", data: formData);
   //   print("mnop"+response1.toString());
   //   print(response1.toString());

      final timeoffMap = response1.data.toString();
      if (timeoffMap.contains("false")) {
        print("ijkl");
        return "false";
      }else if (timeoffMap.contains("1")){
        //print("mnop");
        return "1";
      }else if (timeoffMap.contains("2")){
        //print("mnop");
        return "2";
      }else if (timeoffMap.contains("3")){
        //print("mnop");
        return "3";
      } else {
        print("mnop");
        return "true";
      }
    }catch(e){
     print(e.toString());
      print("DDDD");
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
      //Response response = await dio.post("https://sandbox.ubiattendance.com/index.php/services/getInfo", data: formData);
      Response response = await dio.post(
          path_ubiattendance+"changetimeoffsts",
          data: formData);
      //print(response.toString());
      final timeoffMap = response.data.toString();
      if (timeoffMap.contains("false")) {
        return "failure";
      } else {
        return "success";
      }
      /*if (response.statusCode == 200) {
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
      print(e.toString());
      return "Poor network connection";
    }
  }


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
    //Response response = await dio.post("https://sandbox.ubiattendance.com/index.php/services/getInfo", data: formData);
    Response response = await dio.post(
        path_ubiattendance+"fetchTimeOffList",
        data: formData);
    //print('--------------------getLeaveSummary Called-----------------------');
    List responseJson = json.decode(response.data.toString());
       print( json.decode(response.data.toString()));

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


    TimeOff timeoff = new TimeOff(TimeofDate: TimeofDate, TimeFrom: TimeFrom, TimeTo: TimeTo, hrs: hrs, Reason: Reason, ApprovalSts: ApprovalSts, ApproverComment: ApproverComment, TimeOffId: TimeOffId, withdrawlsts: withdrawlsts);

    list.add(timeoff);

  }

  return list;
}



class TIMEOFFA {
  String Id;
  String name;
  String Timeoffsts;
  String Reason;
  String applydate;
  String Fdate;
  String Tdate;
  String Psts;
  String HRSts;
  String FromDayType;
  String ToDayType;
  String TimeOfTo;
  String TimeoffId;
  String sts;
  String TimeofDate;

  TIMEOFFA(
      { this.Id,
        this.name,
        this.Timeoffsts,
        this.Reason,
        this.applydate,
        this.Fdate,
        this.Tdate,
        this.Psts,
       this.HRSts, this.FromDayType, this.ToDayType, this.TimeOfTo, this.TimeoffId, this.sts, this.TimeofDate
      });
}

Future<List<TIMEOFFA>> getTimeoffapproval(listType) async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('organization') ?? '';
  String empid =  prefs.getString('employeeid')??"";

  Response<String>response =
  await dio.post(path+"getTimeoffapproval?datafor="+listType+'&empid='+empid+'&orgid='+orgdir);
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
    String applydate = data[i]["ApplyDate"].toString();
    String Fdate = data[i]["FDate"].toString();
    String Tdate = data[i]["TDate"].toString();
    //   print("********************"+data[i]["Pstatus"].toString());

    // String Ldays = data[i]["Ldays"].toString();
    //String FromDayType = data[i]["FromDayType"].toString();
    // String ToDayType = data[i]["ToDayType"].toString();
    // String TimeOfTo = data[i]["TimeOfTo"].toString();
    //String LeaveTypeId = data[i]["LeaveTypeId"].toString();
    //print("********************"+Ldays);
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
      applydate: applydate,
      Fdate: Fdate,
      Tdate: Tdate,
      Psts : Psts,
      //  Ldays: Ldays,
      HRSts: HRSts,
      // FromDayType: FromDayType,
      //ToDayType: ToDayType,TimeOfTo: TimeOfTo,
      // LeaveTypeId :LeaveTypeId
    );
    list.add(tos);
  }
  return list;
}



Future<List<TIMEOFFA>> getTeamTimeoffapproval() async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('organization') ?? '';
  String empid =  prefs.getString('employeeid')??"";
 // print(path+"getTeamTimeoffapproval?&empid="+empid+'&orgid='+orgdir);
  Response<String>response =
  await dio.post(path+"getTeamTimeoffapproval?&empid="+empid+'&orgid='+orgdir);
  final res = json.decode(response.data.toString());


  List<TIMEOFFA> userList1 = createteamtimeoffapporval(res);

  return userList1;
}


List<TIMEOFFA> createteamtimeoffapporval(List data) {

  List<TIMEOFFA> list = new List();
  for (int i = 0; i < data.length; i++) {

    String Id = data[i]["Id"].toString();
    String name = data[i]["name"].toString();
    String Timeoffsts = data[i]["LeaveStatus"].toString();
    String Reason = data[i]["LeaveReason"].toString();
    String applydate = data[i]["ApplyDate"].toString();
    String TimeofDate = data[i]["TimeofDate"].toString();
    String Fdate = data[i]["FDate"].toString();
    String Tdate = data[i]["TDate"].toString();
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
      applydate: applydate,
      Fdate: Fdate,
      Tdate: Tdate,
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
      "timeoffid": timeoffid,
      "comment": comment,
      "sts": sts,
      // "leavests": leave.approverstatus
    });

    Response response = await dio.post(
        path+"approvetimeoffapproval",
        data: formData);
    final timeoffMap = response.data.toString();
    if (timeoffMap.contains("false"))
    {
    //  print("false approve timeoff function--->" + response.data.toString());
      return "false";
    } else {
    //  print("true  approve timeoff function---" + response.data.toString());
      return "true";
    }

  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }
}


