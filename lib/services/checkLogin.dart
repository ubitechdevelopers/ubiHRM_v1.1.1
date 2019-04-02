import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/model/model.dart';
import 'package:ubihrm/global.dart';
import 'dart:convert';
import 'dart:async';
import 'services.dart';

Future<bool> checklogin(UserLogin user) async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  // var empid;
 // var organization;
 // Employee emp;


  FormData formData = new FormData.from({
    "user_name": user.username,
    "user_password": user.password,
    "token": user.token,

  });

  Response<String> response =
  await dio.post(path + "checklogin", data: formData);
  print("login response_______"+response.toString());

  if(response.statusCode==200){
    Map employeeMap = json.decode(response.data);
    if(employeeMap['response']==1){
      prefs.setInt("response", 1);
      prefs.setString("employeeid", employeeMap['employeeid']);
      prefs.setString("organization", employeeMap['organization']);
      prefs.setString("empid", employeeMap['employeeid']);
      prefs.setString("orgdir", employeeMap['organization']);
      prefs.setString('fname',employeeMap['fname']);
      prefs.setString('profile', employeeMap['profile']);

      String empid = prefs.getString('employeeid')??"";
      String organization =prefs.getString('organization')??"";
      Employee emp = new Employee(employeeid: empid, organization: organization);

      //  await getProfileInfo(emp);
      getAllPermission(emp);
      await getProfileInfo(emp);
      perEmployeeLeave= getModulePermission("18","view");

      perLeaveApproval=  getModulePermission("124","view");
      perAttendance=  getModulePermission("5","view");
      perTimeoff=  getModulePermission("179","view");
      await getReportingTeam(emp);

      return true;
    }

    else{
      return false;
    }
  }
}

