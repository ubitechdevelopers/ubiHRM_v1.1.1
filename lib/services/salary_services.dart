import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/global.dart';


class Salary{
  String id;
  String name;
  String month;
  String paid_days;
  String EmployeeCTC;
  String Currency;

  Salary({this.id,this.name, this.month, this.paid_days,this.EmployeeCTC,this.Currency});
}


class RequestsalaryService{
  var dio = new Dio();
}


Future<List<Salary>> getsalarySummary() async{
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  String empname = "";
  try {
    FormData formData = new FormData.from({
      "employeeid": empid,
      "organization": organization,
    });
    Response response = await dio.post(path+"getSalarysummary", data: formData);
    print(path+"getSalarysummary?employeeid=$empid&organization=$organization");
    List responseJson = json.decode(response.data.toString());

    List<Salary> userList = createsalaryList(responseJson,empname);

    return userList;

  }catch(e){
    print(e.toString());
  }
}


Future<List<Salary>> getSalarySummaryAll(String empname, String month) async{
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  try {
    print(path+"getSalarysummary?all=all&month=$month&employeeid=$empid&organization=$organization&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess");
    Response response = await dio.post(path+"getSalarysummary?all=all&month=$month&employeeid=$empid&organization=$organization&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess");
    List responseJson = json.decode(response.data.toString());

    List<Salary> userList = createsalaryList(responseJson,empname);

    return userList;

  }catch(e){
    print(e.toString());
  }
}

List<Salary> createsalaryList(List data, String empname){

  List<Salary> list = new List();
  if(empname.isNotEmpty) {
    for (int i = 0; i < data.length; i++) {
      String id = data[i]["Id"];
      String name = data[i]["name"];
      String PaidDays = data[i]["PaidDays"];
      String SalaryMonth = data[i]["SalaryMonth"];
      String EmployeeCTC = data[i]["EmployeeCTC"];
      String Currency = data[i]["currency"];

      Salary salary = new Salary(id: id,
          name: name,
          paid_days: PaidDays,
          month: SalaryMonth,
          EmployeeCTC: EmployeeCTC,
          Currency: Currency);

      if (name.toLowerCase().contains(empname.toLowerCase()))
        list.add(salary);
    }
  }else {
    for (int i = 0; i < data.length; i++) {
      String id = data[i]["Id"];
      String name = data[i]["name"];
      String PaidDays = data[i]["PaidDays"];
      String SalaryMonth = data[i]["SalaryMonth"];
      String EmployeeCTC = data[i]["EmployeeCTC"];
      String Currency = data[i]["currency"];

      Salary salary = new Salary(id: id,
          name: name,
          paid_days: PaidDays,
          month: SalaryMonth,
          EmployeeCTC: EmployeeCTC,
          Currency: Currency);

      list.add(salary);
    }
  }
  return list;
}
