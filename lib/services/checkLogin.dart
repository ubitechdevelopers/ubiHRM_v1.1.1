import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/model/model.dart';
import 'services.dart';

class Login{

  var dio = new Dio();

  Future<String> checklogin(UserLogin user, BuildContext context) async{
    final prefs = await SharedPreferences.getInstance();
    Dio dio = new Dio();

    FormData formData = new FormData.from({
      "user_name": user.username,
      "user_password": user.password,
      "token": user.token,
      "qr":false,
    });

    Response<String> response = await dio.post(path + "checklogin", data: formData);
    print(path + "checklogin?user_name=${user.username}&user_password=${user.password}&token=${user.token}");
    print("login response_______"+response.toString());
    print(response.statusCode);

    if(response.statusCode==200){
      Map employeeMap = json.decode(response.data);
      if(employeeMap['response']==1){
        prefs.setInt("response", 1);
        prefs.setInt("plansts", employeeMap['plansts']);
        prefs.setInt("empcount", employeeMap['empcount']);
        prefs.setInt("attcount", employeeMap['attcount']);
        prefs.setInt("empattcount", employeeMap['empattcount']);
        prefs.setString("employeeid", employeeMap['employeeid']);
        prefs.setString("empemail", employeeMap['empemail']);
        prefs.setString("empnumber", employeeMap['empnumber']);
        prefs.setString("email", employeeMap['email']);
        prefs.setString("number", employeeMap['number']);
        prefs.setString("name", employeeMap['name']);
        prefs.setString("organization", employeeMap['organization']);
        prefs.setString("userprofileid", employeeMap['userprofileid']);
        prefs.setString("countryid", employeeMap['countryid']);
        prefs.setString("empid", employeeMap['employeeid']);
        prefs.setString("orgdir", employeeMap['organization']);
        prefs.setString("orgname", employeeMap['organizationname']);
        //prefs.setString('fname',employeeMap['fname']);
        //prefs.setString('profile', employeeMap['profile']);
        prefs.setInt('profiletype', employeeMap['profiletype']);
        prefs.setInt('hrsts', employeeMap['hrsts']);
        prefs.setInt('adminsts', employeeMap['adminsts']);
        prefs.setInt('dataaccess', employeeMap['dataaccess']);
        prefs.setInt('SAPintegrationsts', employeeMap['SAPintegrationsts']);
        prefs.setInt('divhrsts', employeeMap['divhrsts']);

        String empid = prefs.getString('employeeid')??"";
        String organization =prefs.getString('organization')??"";
        String userprofileid =prefs.getString('userprofileid')??"";

        Employee emp = new Employee(
          employeeid: empid,
          organization: organization,
          userprofileid: userprofileid,
        );

        await getAllPermission(emp);
        await getProfileInfo(emp, context);
        await getReportingTeam(emp);

        perEmployeeLeave = getModulePermission("18","view");
        perAttendance = getModulePermission("5","view");
        perTimeoff = getModulePermission("179","view");
        perSalary = getModulePermission("66", "view");
        perPayroll = getModulePermission("458", "view");
        perPayPeriod = getModulePermission("491", "view");
        perEmployee = getModulePermission("496", "view");
        perGeoFence = getModulePermission("318", "view");
        perSalaryExpense = getModulePermission("170", "view");
        perPayrollExpense = getModulePermission("473", "view");
        perFlexi = getModulePermission("448", "view");
        perPunchLocation = getModulePermission("305", "view");

        perLeaveApproval = getModuleUserPermission("124","view");
        perTimeoffApproval = getModuleUserPermission("180", "view");
        perSalaryExpenseApproval = getModuleUserPermission("170","view");
        perPayrollExpenseApproval = getModuleUserPermission("473","view");
        userPerEmployee = getModuleUserPermission("496", "view");
        perAttReport = getModuleUserPermission("68", "view");
        perLeaveReport = getModuleUserPermission("69", "view");
        perFlexiReport = getModuleUserPermission("448", "view");

        return "true";
      } else if(employeeMap['response']==2){
        return "false1";
      } else if(employeeMap['response']==3){
        return "false2";
      } else if(employeeMap['response']==4){
        prefs.setString("orgid", employeeMap['orgid']);
        prefs.setString("name", employeeMap['name']);
        prefs.setString("email", employeeMap['email']);
        //print(prefs.getString('orgid'));
        //print(prefs.getString('name'));
        //print(prefs.getString('email'));
        return "false3";
      } else if(employeeMap['response']==5){
        return "false4";
      } else{
        return "false";
      }
    }
  }

  checkLoginForQr(User user, BuildContext context) async{
    try {
      final prefs = await SharedPreferences.getInstance();
      Dio dio = new Dio();

      print(user.username + "----");
      print(user.password + "----");
      print(user.token + "----");

      if(user.username=='' || user.password=='')
        return "failure";
      FormData formData = new FormData.from({
        "user_name": user.username,
        "user_password": user.password,
        "token": user.token,
        "qr":true,
      });

      Response response1 = await dio.post(path+"checklogin", data: formData);
      print(response1.toString());
      print(response1.statusCode.toString());

      if (response1.statusCode == 200) {
        Map employeeMap = json.decode(response1.data);
        if(employeeMap['response']==1){
          prefs.setInt("response", 1);
          prefs.setInt("plansts", employeeMap['plansts']);
          prefs.setInt("empcount", employeeMap['empcount']);
          prefs.setString("employeeid", employeeMap['employeeid']);
          prefs.setString("empemail", employeeMap['empemail']);
          prefs.setString("empnumber", employeeMap['empnumber']);
          prefs.setString("email", employeeMap['email']);
          prefs.setString("number", employeeMap['number']);
          prefs.setString("name", employeeMap['name']);
          prefs.setString("organization", employeeMap['organization']);
          prefs.setString("userprofileid", employeeMap['userprofileid']);
          prefs.setString("countryid", employeeMap['countryid']);
          prefs.setString("empid", employeeMap['employeeid']);
          prefs.setString("orgdir", employeeMap['organization']);
          prefs.setString("orgname", employeeMap['organizationname']);
          //prefs.setString('fname',employeeMap['fname']);
          //prefs.setString('profile', employeeMap['profile']);
          prefs.setInt('profiletype', employeeMap['profiletype']);
          prefs.setInt('hrsts', employeeMap['hrsts']);
          prefs.setInt('adminsts', employeeMap['adminsts']);
          prefs.setInt('dataaccess', employeeMap['dataaccess']);
          prefs.setInt('SAPintegrationsts', employeeMap['SAPintegrationsts']);
          prefs.setInt('divhrsts', employeeMap['divhrsts']);

          String empid = prefs.getString('employeeid')??"";
          String organization =prefs.getString('organization')??"";
          String userprofileid =prefs.getString('userprofileid')??"";

          Employee emp = new Employee(
            employeeid: empid,
            organization: organization,
            userprofileid: userprofileid,
          );

          await getAllPermission(emp);
          await getProfileInfo(emp, context);
          await getReportingTeam(emp);

          perEmployeeLeave = getModulePermission("18","view");
          perAttendance = getModulePermission("5","view");
          perTimeoff = getModulePermission("179","view");
          perSalary = getModulePermission("66", "view");
          perPayroll = getModulePermission("458", "view");
          perPayPeriod = getModulePermission("491", "view");
          perEmployee = getModulePermission("496", "view");
          perGeoFence = getModulePermission("318", "view");
          perSalaryExpense = getModulePermission("170", "view");
          perPayrollExpense = getModulePermission("473", "view");
          perFlexi = getModulePermission("448", "view");
          perPunchLocation = getModulePermission("305", "view");

          perLeaveApproval = getModuleUserPermission("124","view");
          perTimeoffApproval = getModuleUserPermission("180", "view");
          perSalaryExpenseApproval = getModuleUserPermission("170","view");
          perPayrollExpenseApproval = getModuleUserPermission("473","view");
          userPerEmployee = getModuleUserPermission("496", "view");
          perAttReport = getModuleUserPermission("68", "view");
          perLeaveReport = getModuleUserPermission("69", "view");
          perFlexiReport = getModuleUserPermission("448", "view");

          return "Success";
        } else {
          return "failure";
        }
      } else {
        return "poor network";
      }
    }catch(e){
      print(e.toString());
      return "poor network";
    }
  }

  markAttByQR(String qr, BuildContext context, token1) async{
    List splitstring = qr.split("ykks==");
    User qruser = new User(splitstring[0], splitstring[1],token1);
    String result = await checkLoginForQr(qruser, context);
    return result;
  }

}
