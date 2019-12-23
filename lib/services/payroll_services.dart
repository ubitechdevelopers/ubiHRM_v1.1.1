import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/model/model.dart';


class RequestPayrollService{

  var dio = new Dio();

}

Future<List<Payroll>> getPayrollSummary() async{
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
    print(path1+"getPayrollSummary?employeeid=$empid&organization=$organization");
    Response response = await dio.post(path1+"getPayrollSummary", data: formData);
    print('--------------------Payroll Summary Called-----------------------');
    List responseJson = json.decode(response.data.toString());
    print(json.decode(response.data.toString()));

    List<Payroll> userList = createPayrollList(responseJson);

    return userList;

  }catch(e){
    print(e.toString());
  }
}

Future<List<Payroll>> getPayrollSummaryAll() async{
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
    print(path1+"getPayrollSummary?all=all&employeeid=$empid&organization=$organization");
    Response response = await dio.post(path1+"getPayrollSummary?all=all", data: formData);
    print('--------------------Payroll Summary Called For ALL-----------------------');
    print(response.data.toString());
    List responseJson = json.decode(response.data.toString());
    print(json.decode(response.data.toString()));

    List<Payroll> userList = createPayrollList(responseJson);

    return userList;

  }catch(e){
    print(e.toString());
  }
}

List<Payroll> createPayrollList(List data){
  List<Payroll> list = new List();
  for (int i = 0; i < data.length; i++) {
    String id = data[i]["Id"];
    String name=data[i]["name"];
    String PaidDays=data[i]["PaidDays"];
    String SalaryMonth=data[i]["SalaryMonth"];
    String EmployeeCTC=data[i]["EmployeeCTC"];
    String Currency=data[i]["currency"];
    Payroll payroll = new Payroll(id:id, name:name, paid_days:PaidDays, month:SalaryMonth, EmployeeCTC:EmployeeCTC, Currency:Currency);
    list.add(payroll);
  }
  return list;
}
