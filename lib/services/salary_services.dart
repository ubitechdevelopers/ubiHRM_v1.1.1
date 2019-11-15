import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/model/model.dart';
import 'package:dio/dio.dart';
import 'package:ubihrm/global.dart';
import 'dart:convert';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/painting.dart';
import 'dart:io';


class RequestsalaryService{

  var dio = new Dio();

}


Future<List<Salary>> getsalarySummary() async{
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String path1 = prefs.getString('path');
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  try {
    FormData formData = new FormData.from({
      "employeeid": empid,
      "organization": organization,
    });
    //Response response = await dio.post("https://sandbox.ubiattendance.com/index.php/services/getInfo", data: formData);
    Response response = await dio.post(
        path1+"getSalarysummary",
        data: formData);
   // print('--------------------salarySummary Called-----------------------');
   // print(response.data.toString());
    List responseJson = json.decode(response.data.toString());
    print(json.decode(response.data.toString()));

    List<Salary> userList = createsalaryList(responseJson);

    return userList;

  }catch(e){
    //print(e.toString());
  }
}

Future<List<Salary>> getsalarySummaryAll() async{
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String path1 = prefs.getString('path');
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  try {
       FormData formData = new FormData.from({
       "employeeid": empid,
       "organization": organization,
    });
    //Response response = await dio.post("https://sandbox.ubiattendance.com/index .php/services/getInfo", data: formData);
    Response response = await dio.post(
        path1+"getSalarysummary?all=all",
        data: formData);
   print('--------------------salarySummary Called-----------------------');
   print(response.data.toString());
    List responseJson = json.decode(response.data.toString());
    print(json.decode(response.data.toString()));

    List<Salary> userList = createsalaryList(responseJson);

    return userList;

  }catch(e){
    //print(e.toString());
  }
}

List<Salary> createsalaryList(List data){

  List<Salary> list = new List();
  for (int i = 0; i < data.length; i++) {
    String id = data[i]["Id"];
    String name=data[i]["name"];
    String PaidDays=data[i]["PaidDays"];
    String SalaryMonth=data[i]["SalaryMonth"];
    String EmployeeCTC=data[i]["EmployeeCTC"];
    String Currency=data[i]["currency"];
  // EmployeeCTC=EmployeeCTC.abs();


    //print(id);
    Salary salary = new Salary(id:id,name:name,paid_days:PaidDays,month:SalaryMonth,EmployeeCTC:EmployeeCTC,Currency:Currency);

    list.add(salary);

  }

  return list;
}





