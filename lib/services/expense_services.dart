import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/model/model.dart';
import 'package:dio/dio.dart';
import 'package:ubihrm/global.dart';
import 'dart:convert';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/painting.dart';
import 'dart:io';


class RequestExpenceService{

  var dio = new Dio();






}





class Expense {
  String Id;
  String name;
  String category;
  String desc;
  String applydate;
  String deprt;
  String ests;
  String amt;
  String currency;


  Expense(
      { this.Id,
        this.name,
        this.category,
        this.desc,
        this.applydate, this.deprt,this.ests,this.amt,this.currency,
       });
}



Future<List<Expense>> getExpenselist(date) async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('organization') ?? '';
  String empid =  prefs.getString('employeeid')??"";
//print(date);
// print("888");
  Response<String>response =
  await dio.post(path+"getExpenseDetail?empid="+empid+'&orgid='+orgdir+'&date='+date);
  final res = json.decode(response.data.toString());
 // print(res);

  // print(path+"getapproval?datafor="+listType+'&empid='+empid+'&orgid='+orgdir);

/*  List responseJson;
  if (listType == 'Approved')
    responseJson = res['Approved'];
  else if (listType == 'Pending')
    responseJson = res['Pending'];
  else if (listType == 'Rejected')
    responseJson = res['Rejected'];*/

  List<Expense> userList = createExpenselist(res);

  return userList;
}


List<Expense> createExpenselist(List data) {

  List<Expense> list = new List();
  for (int i = 0; i < data.length; i++) {

    String Id = data[i]["id"].toString();
     String name = data[i]["employee"].toString();
    String category = data[i]["ClaimHeadname"].toString();
    String desc = data[i]["purpose"].toString();
    String applydate = data[i]["fromdate"].toString();
    String deprt = data[i]["department"].toString();
    String ests = data[i]["appsts"].toString();
    String amt = data[i]["totalclaim"].toString();
    String currency = data[i]["empcurency"].toString();
    deprtcurrency=data[i]["empcurency"].toString();
    Expense tos = new Expense(
      Id: Id,
      name: name,
      category: category,
      desc: desc,
      applydate: applydate,
      deprt: deprt,
      ests: ests,
      amt: amt,
      currency: currency,

    );
    list.add(tos);
  }
  return list;
}







Future<List<Map>> getheadtype(int label) async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  final response = await dio.post(path + "getheadtype?orgid=$orgdir&eid=$empid");
 // print("leavetype11----------->");
 //  print(response);
  List data = json.decode(response.data.toString());
 //  print("headtype----------->");
//print(data);
  List<Map> leavetype = createList(data,label);
  return leavetype;
}
List<Map> createList(List data,int label) {
  List<Map> list = new List();
  if(label==1) // with -All- label
    list.add({"Id":"0","Name":"-All-"});
  else
    list.add({"Id":"0","Name":"-Select-"});
  // print("666666666");
  // print(data);
  for (int i = 0; i < data.length; i++) {
    //  if(data[i]["archive"].toString()=='1') {
    print("kkkkkkk"+data[i]["name"].toString());
    Map tos={"Id":data[i]["id"].toString(),"Name":data[i]["name"].toString() };
    list.add(tos);
    // }
  }
  return list;
}



class Expensedate {
 String dates;
 String Fdate;
   Expensedate(
      {
        this.dates,
        this.Fdate,
      });
}
Future<List<Expensedate>> getExpenselistbydate() async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('organization') ?? '';
  String empid =  prefs.getString('employeeid')??"";

  Response<String>response =
  await dio.post(path+"getExpenseDetailbydate?empid="+empid+'&orgid='+orgdir);
  final res = json.decode(response.data.toString());
 // print(res);

 List<Expensedate> userList = createExpenselistbydate(res);

  return userList;
}


List<Expensedate> createExpenselistbydate(List data) {

  List<Expensedate> list = new List();

  for (int i = 0; i < data.length; i++) {

  String dates = data[i]["fromdate"].toString();
  String Fdate = data[i]["Fdate"].toString();

  Expensedate tos = new Expensedate(
    dates: dates,
    Fdate: Fdate,
  );
    list.add(tos);
  }
  return list;
}