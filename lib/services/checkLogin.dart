import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/model/model.dart';
//import 'package:ubihrm/model/user.dart';
import 'package:ubihrm/global.dart';
import 'dart:convert';
import 'dart:async';
import 'services.dart';

class Login{

  var dio = new Dio();

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
      "qr":false,

    });

    Response<String> response =
    await dio.post(path + "checklogin", data: formData);
    print(path);
    print("login response_______"+response.toString());
    print(response.statusCode);

    if(response.statusCode==200){
      Map employeeMap = json.decode(response.data);
      if(employeeMap['response']==1){
        prefs.setInt("response", 1);
        prefs.setString("employeeid", employeeMap['employeeid']);
        prefs.setString("organization", employeeMap['organization']);
        prefs.setString("userprofileid", employeeMap['userprofileid']);
        prefs.setString("countryid", employeeMap['countryid']);
        print("countryid");
        print(employeeMap['countryid']);

        print("*********PRATIBHA***********");
        if(employeeMap['countryid']=="93"){
         //print("Helloindia");

          /*prefs.setString("path", 'http://192.168.0.200/UBIHRM/HRMINDIA/ubiapp/');
          prefs.setString("path_ubiattendance", 'http://192.168.0.200/UBIHRM/HRMINDIA/HRMAPP/index.php/Att_services/');
          prefs.setString("path_hrm_india", 'http://192.168.0.200/UBIHRM/HRMINDIA/services/');*/

          prefs.setString("path", 'https://ubitech.ubihrm.com/ubiapp/');
          prefs.setString("path_ubiattendance", 'https://ubitech.ubihrm.com/HRMAPP/index.php/Att_services/');
          prefs.setString("path_hrm_india", 'https://ubitech.ubihrm.com/services/');

        }else{
         //print("Hiiiall");

          /*prefs.setString("path", 'http://192.168.0.200/UBIHRM/HRMALL/ubiapp/');
          prefs.setString("path_ubiattendance", 'http://192.168.0.200/UBIHRM/HRMALL/HRMAPP/index.php/Att_services/');
          prefs.setString("path_hrm_india", 'http://192.168.0.200/UBIHRM/HRMALL/services/');*/

          prefs.setString("path", 'https://ubitechdigital.ubihrm.com/ubiapp/');
          prefs.setString("path_ubiattendance", 'https://ubitechdigital.ubihrm.com/HRMAPP/index.php/Att_services/');
          prefs.setString("path_hrm_india", 'https://ubitechdigital.ubihrm.com/services/');

        }
        prefs.setString("empid", employeeMap['employeeid']);
        prefs.setString("orgdir", employeeMap['organization']);
        prefs.setString("orgname", employeeMap['organizationname']);
        prefs.setString('fname',employeeMap['fname']);
        prefs.setString('profile', employeeMap['profile']);

        String empid = prefs.getString('employeeid')??"";
        String organization =prefs.getString('organization')??"";
        String userprofileid =prefs.getString('userprofileid')??"";
        print("----------->");
        print(userprofileid);
        print("----------->");
        Employee emp = new Employee(employeeid: empid, organization: organization, userprofileid: userprofileid);

        //await getProfileInfo(emp);
        await getAllPermission(emp);
        await getProfileInfo(emp);
        perEmployeeLeave= getModulePermission("18","view");
        //perLeaveApproval=  getModulePermission("124","view");
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

  checkLoginForQr(User user) async{
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

      // Response response1 = await dio.post("https://sandbox.ubiattendance.com/index.php/services/checkLogin",data: formData);
      // Response response1 = await dio.post("https://ubiattendance.ubihrm.com/index.php/services/checkLogin",data: formData);
      Response response1 = await dio.post(path+"checklogin", data: formData);
      // Response response1 = await dio.post("http://192.168.0.200/UBIHRM/HRMINDIA/services/checkLogin", data: formData);
      print(response1.toString());
      print(response1.statusCode.toString());

      if (response1.statusCode == 200) {
        Map employeeMap = json.decode(response1.data);
        print(employeeMap["response"]);
        if(employeeMap['response']==1){
          prefs.setInt("response", 1);
          prefs.setString("employeeid", employeeMap['employeeid']);
          prefs.setString("organization", employeeMap['organization']);
          prefs.setString("userprofileid", employeeMap['userprofileid']);
          prefs.setString("countryid", employeeMap['countryid']);
          print("countryid");
          print(employeeMap['countryid']);

          print("*********PRATIBHA123***********");
          if(employeeMap['countryid']=="93"){
            //print("Helloindia");

            /*prefs.setString("path", 'http://192.168.0.200/UBIHRM/HRMINDIA/ubiapp/');
            prefs.setString("path_ubiattendance", 'http://192.168.0.200/UBIHRM/HRMINDIA/HRMAPP/index.php/Att_services/');
            prefs.setString("path_hrm_india", 'http://192.168.0.200/UBIHRM/HRMINDIA/services/');*/

            prefs.setString("path", 'https://ubitech.ubihrm.com/ubiapp/');
            prefs.setString("path_ubiattendance", 'https://ubitech.ubihrm.com/HRMAPP/index.php/Att_services/');
            prefs.setString("path_hrm_india", 'https://ubitech.ubihrm.com/services/');

          }else{
            //print("Hiiiall");

            /*prefs.setString("path", 'http://192.168.0.200/UBIHRM/HRMALL/ubiapp/');
            prefs.setString("path_ubiattendance", 'http://192.168.0.200/UBIHRM/HRMALL/HRMAPP/index.php/Att_services/');
            prefs.setString("path_hrm_india", 'http://192.168.0.200/UBIHRM/HRMALL/services/');*/

            prefs.setString("path", 'https://ubitechdigital.ubihrm.com/ubiapp/');
            prefs.setString("path_ubiattendance", 'https://ubitechdigital.ubihrm.com/HRMAPP/index.php/Att_services/');
            prefs.setString("path_hrm_india", 'https://ubitechdigital.ubihrm.com/services/');

          }
          prefs.setString("empid", employeeMap['employeeid']);
          prefs.setString("orgdir", employeeMap['organization']);
          prefs.setString("orgname", employeeMap['organizationname']);
          prefs.setString('fname',employeeMap['fname']);
          prefs.setString('profile', employeeMap['profile']);

          String empid = prefs.getString('employeeid')??"";
          String organization =prefs.getString('organization')??"";
          String userprofileid =prefs.getString('userprofileid')??"";

          Employee emp = new Employee(employeeid: empid, organization: organization, userprofileid: userprofileid);

          //  await getProfileInfo(emp);
          await getAllPermission(emp);
          await getProfileInfo(emp);
          perEmployeeLeave= getModulePermission("18","view");
          perTimeoffApproval = getModuleUserPermission("180", "view");
          perLeaveApproval=  getModuleUserPermission("124","view");
          perAttendance=  getModulePermission("5","view");
          perTimeoff=  getModulePermission("179","view");
          await getReportingTeam(emp);

          return "Success";
        }
        // if (employeeMap["response"] == 1) {
        /*  var user = new Employee.fromJson(employeeMap);
          print(user.fname + " " + user.lname);
          print(user.org_perm);
          Home ho = new Home();
          StreamLocation sl = new StreamLocation();
          sl.startStreaming(1);
          Map timeinout = await ho.checkTimeInQR(user.empid, user.orgid);
          print(timeinout);
          var marktimeinout = MarkTime(timeinout["uid"].toString(), timeinout["location"], timeinout["aid"].toString(), timeinout["act"], timeinout["shiftId"], timeinout["refid"].toString(), timeinout["latit"].toString(), timeinout["longi"].toString());
          if(timeinout["act"]!="Imposed") {
            SaveImage mark = new SaveImage();
            bool res = await mark.saveTimeInOutQR(marktimeinout);
            if (res)
              return "success";
            else
              return "poor network";
          }else{
            return "imposed";
          }
        } */else {
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
/*Future<bool> checklogin(UserLogin user) async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  // var empid;
 // var organization;
 // Employee emp;


  FormData formData = new FormData.from({
    "user_name": user.username,
    "user_password": user.password,
    "token": user.token,
    "qr":false,

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
      prefs.setString("userprofileid", employeeMap['userprofileid']);
      prefs.setString("empid", employeeMap['employeeid']);
      prefs.setString("orgdir", employeeMap['organization']);
      prefs.setString("orgname", employeeMap['organizationname']);
      prefs.setString('fname',employeeMap['fname']);
      prefs.setString('profile', employeeMap['profile']);

      String empid = prefs.getString('employeeid')??"";
      String organization =prefs.getString('organization')??"";
      String userprofileid =prefs.getString('userprofileid')??"";
      Employee emp = new Employee(employeeid: empid, organization: organization,userprofileid:userprofileid);

      //  await getProfileInfo(emp);
      await getAllPermission(emp);
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

checkLoginForQr(User user) async{
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

      // Response response1 = await dio.post("https://sandbox.ubiattendance.com/index.php/services/checkLogin",data: formData);
      // Response response1 = await dio.post("https://ubiattendance.ubihrm.com/index.php/services/checkLogin",data: formData);
      Response response1 = await dio.post(path+"checklogin", data: formData);
      // Response response1 = await dio.post("http://192.168.0.200/UBIHRM/HRMINDIA/services/checkLogin", data: formData);
      print(response1.toString());
      print(response1.statusCode.toString());

      if (response1.statusCode == 200) {
        Map employeeMap = json.decode(response1.data);
        print(employeeMap["response"]);
        if(employeeMap['response']==1){
          prefs.setInt("response", 1);
          prefs.setString("employeeid", employeeMap['employeeid']);
          prefs.setString("organization", employeeMap['organization']);
          prefs.setString("empid", employeeMap['employeeid']);
          prefs.setString("orgdir", employeeMap['organization']);
          prefs.setString("orgname", employeeMap['organizationname']);
          prefs.setString('fname',employeeMap['fname']);
          prefs.setString('profile', employeeMap['profile']);

          String empid = prefs.getString('employeeid')??"";
          String organization =prefs.getString('organization')??"";
          Employee emp = new Employee(employeeid: empid, organization: organization);

          //  await getProfileInfo(emp);
          await getAllPermission(emp);
          await getProfileInfo(emp);
          perEmployeeLeave= getModulePermission("18","view");

          perLeaveApproval=  getModulePermission("124","view");
          perAttendance=  getModulePermission("5","view");
          perTimeoff=  getModulePermission("179","view");
          await getReportingTeam(emp);

          return "Success";
        }
        // if (employeeMap["response"] == 1) {
        /*  var user = new Employee.fromJson(employeeMap);
          print(user.fname + " " + user.lname);
          print(user.org_perm);
          Home ho = new Home();
          StreamLocation sl = new StreamLocation();
          sl.startStreaming(1);
          Map timeinout = await ho.checkTimeInQR(user.empid, user.orgid);
          print(timeinout);
          var marktimeinout = MarkTime(timeinout["uid"].toString(), timeinout["location"], timeinout["aid"].toString(), timeinout["act"], timeinout["shiftId"], timeinout["refid"].toString(), timeinout["latit"].toString(), timeinout["longi"].toString());
          if(timeinout["act"]!="Imposed") {
            SaveImage mark = new SaveImage();
            bool res = await mark.saveTimeInOutQR(marktimeinout);
            if (res)
              return "success";
            else
              return "poor network";
          }else{
            return "imposed";
          }
        } */else {
          return "failure";
        }
      } else {
        return "poor network";
      }
    }catch(e){
      print(e.toString());
      return "poor network";
    }
  }*/

markAttByQR(String qr,token1) async{
  List splitstring = qr.split("ykks==");
  User qruser = new User(splitstring[0], splitstring[1],token1);
  String result = await checkLoginForQr(qruser);
  return result;
  print(splitstring[0]);
  print(splitstring[1]);
  print(qr);
  //return "success";
}}