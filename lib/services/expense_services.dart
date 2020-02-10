import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/global.dart';

class RequestExpenceService{
  var dio = new Dio();
}

class Expense {
  String Id;
  String name;
  String category;
  String categoryid;
  String desc;
  String applydate;
  String deprt;
  String ests;
  String amt;
  String Psts;
  String currency;
  String doc;

  Expense({
    this.Id,
    this.name,
    this.category,
    this.categoryid,
    this.desc,
    this.applydate,
    this.deprt,
    this.ests,
    this.amt,
    this.Psts,
    this.currency,
    this.doc,
  });
}

Future<List<Expense>> getExpenseApprovals(listType) async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String path1 = prefs.getString('path');
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Response<String> response = await dio.post(path1+"getExpenseApproval?datafor="+listType+'&empid='+empid+'&orgid='+orgdir);
  print('path1+"getExpenseApproval?datafor');
  print(path1+"getExpenseApproval?datafor="+listType+'&empid='+empid+'&orgid='+orgdir);
  final res = json.decode(response.data.toString());
  List<Expense> userList = createExpenseApporval(res);
  return userList;
}

List<Expense> createExpenseApporval(List data) {
  List<Expense> list = new List();
  for (int i = 0; i < data.length; i++) {
    String Id = data[i]["Id"].toString();
    String name = data[i]["Name"].toString();
    String categoryid = data[i]["ClaimHeadId"].toString();
    String category = data[i]["ClaimHead"].toString();
    String ests = data[i]["ApproverSts"].toString();
    String desc = data[i]["Purpose"].toString();
    String applydate = data[i]["FromDate"].toString();
    String doc = data[i]["Doc"].toString();
    String amt = data[i]["TotalAmt"].toString();
    String currency = data[i]["EmpCurrency"].toString();
    String Pstatus = data[i]["Pstatus"].toString();
    String Psts="";
    if(data[i]["Pstatus"].contains("Pending at")) {
      Psts = data[i]["Pstatus"].toString();
    }
    Expense tos = new Expense(
      Id: Id,
      name: name,
      categoryid: categoryid,
      category: category,
      ests: ests,
      desc: desc,
      applydate: applydate,
      doc: doc,
      amt: amt,
      currency: currency,
      Psts: Psts,
    );
    list.add(tos);
  }
  return list;
}

ApproveExpense(expenseid,comment,sts) async{
  String empid;
  String organization;
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String path1 = prefs.getString('path');
  empid = prefs.getString('employeeid')??"";
  organization =prefs.getString('organization')??"";
  try {
    FormData formData = new FormData.from({
      "eid": empid,
      "orgid": organization,
      "expenseid": expenseid,
      "comment": comment,
      "sts": sts,
    });
    Response response = await dio.post(path1+"ApprovedExpense", data: formData);
    print(path1+"ApprovedExpense?eid=$empid&orgid=$organization&expenseid=$expenseid&comment=$comment&sts=$sts");
    final expenseMap = response.data.toString();
    print("-------------------");
    print(response.toString());
    if (expenseMap.contains("false"))
    {
      print("false approve expense function--->" + response.data.toString());
      return "false";
    } else {
      print("true  approve expense function---" + response.data.toString());
      return "true";
    }
  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }
}
//////////////////////////////////////SALARY EXPENSE APPROVAL TAB ID 4 AND MODULT ID 170 ENDS HERE///////////////////////////////////////

//////////////////////////////////////////////PAYROLL EXPENSE APPROVAL TAB ID 8 AND MODULT ID 473/////////////////////////////////////////////////
Future<List<Expense>> getPayrollExpenseApprovals(listType) async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String path1 = prefs.getString('path');
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Response<String> response = await dio.post(path1+"getPayrollExpenseApproval?datafor="+listType+'&empid='+empid+'&orgid='+orgdir);
  print('path1+"getExpenseApproval?datafor');
  print(path1+"getExpenseApproval?datafor="+listType+'&empid='+empid+'&orgid='+orgdir);
  final res = json.decode(response.data.toString());
  List<Expense> userList = createPayrollExpenseApporval(res);
  return userList;
}

List<Expense> createPayrollExpenseApporval(List data) {
  List<Expense> list = new List();
  for (int i = 0; i < data.length; i++) {
    String Id = data[i]["Id"].toString();
    String name = data[i]["Name"].toString();
    String categoryid = data[i]["ClaimHeadId"].toString();
    String category = data[i]["ClaimHead"].toString();
    String ests = data[i]["ApproverSts"].toString();
    String desc = data[i]["Purpose"].toString();
    String applydate = data[i]["FromDate"].toString();
    String doc = data[i]["Doc"].toString();
    String amt = data[i]["TotalAmt"].toString();
    String currency = data[i]["EmpCurrency"].toString();
    String Pstatus = data[i]["Pstatus"].toString();
    String Psts="";
    if(data[i]["Pstatus"].contains("Pending at")) {
      Psts = data[i]["Pstatus"].toString();
    }
    Expense tos = new Expense(
      Id: Id,
      name: name,
      categoryid: categoryid,
      category: category,
      ests: ests,
      desc: desc,
      applydate: applydate,
      doc: doc,
      amt: amt,
      currency: currency,
      Psts: Psts,
    );
    list.add(tos);
  }
  return list;
}

ApprovePayrollExpense(expenseid,comment,sts) async{
  String empid;
  String organization;
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String path1 = prefs.getString('path');
  empid = prefs.getString('employeeid')??"";
  organization =prefs.getString('organization')??"";
  try {
    FormData formData = new FormData.from({
      "eid": empid,
      "orgid": organization,
      "expenseid": expenseid,
      "comment": comment,
      "sts": sts,
    });
    Response response = await dio.post(path1+"ApprovedPayrollExpense", data: formData);
    print(path1+"ApprovedExpense?eid=$empid&orgid=$organization&expenseid=$expenseid&comment=$comment&sts=$sts");
    final expenseMap = response.data.toString();
    print("-------------------");
    print(response.toString());
    if (expenseMap.contains("false"))
    {
      print("false approve expense function--->" + response.data.toString());
      return "false";
    } else {
      print("true  approve expense function---" + response.data.toString());
      return "true";
    }
  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }
}
////////////////////////////////////PAYROLL EXPENSE APPROVAL TAB ID 8 AND MODULT ID 473 ENDS HERE//////////////////////////////////////

Future<List<Expense>> getExpenseDetailById(Id) async{
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String path_hrm_india1 = prefs.getString('path_hrm_india');
  //String id = prefs.getString('expenseid') ?? '';
  String orgid = prefs.getString('organization') ?? '';
  //String empid = prefs.getString('employeeid')??"";
  try {
    FormData formData = new FormData.from({
      "Id" : Id,
      //"empid":empid,
      "orgid":orgid
    });
    //Response response = await dio.post("https://sandbox.ubiattendance.com/index.php/services/getInfo", data: formData);
    Response response = await dio.post(
        path_hrm_india1+"showExpenseDetail",
        data: formData
    );
    //print(response.data.toString());
    //print('--------------------getLeaveSummary Called-----------------------');
    List responseJson = json.decode(response.data.toString());
    print("***************"+responseJson.toString());
    //print("LEAVE LIST");
    //  print(userList);
    //print("---#####################----->"+response.data.toString());
    //print("LEAVE LIST");
    List<Expense> expenseDetail = viewExpenseDetail(responseJson);

    return expenseDetail;

  }catch(e){
    //print(e.toString());
  }
}

List<Expense> viewExpenseDetail(List data) {

  List<Expense> list = new List();
  for (int i = 0; i < data.length; i++) {

    String Id = data[i]["Id"].toString();
    //String name = data[i]["employee"].toString();
    String category = data[i]["ClaimHead"].toString();
    String desc = data[i]["Purpose"].toString();
    String applydate = data[i]["CreatedDate"].toString();
    //String deprt = data[i]["department"].toString();
    String ests = data[i]["appstatus"].toString();
    String amt = data[i]["TotalAmt"].toString();
    String doc = data[i]["Doc"].toString();
    print("document"+doc);
    String currency = data[i]["empcurency"].toString();
    deprtcurrency=data[i]["empcurency"].toString();
    Expense tos = new Expense(
      Id: Id,
      //name: name,
      category: category,
      desc: desc,
      applydate: applydate,
      doc: doc,
      ests: ests,
      amt: amt,
      currency: currency,
    );
    list.add(tos);
  }
  return list;
}

Future<List<Expense>> getExpenselist(date) async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String path1 = prefs.getString('path');
  String orgdir = prefs.getString('organization') ?? '';
  String empid =  prefs.getString('employeeid')??"";
//print(date);
// print("888");
  Response<String>response =
  await dio.post(path1+"getExpenseDetail?empid="+empid+'&orgid='+orgdir+'&date='+date);
  final res = json.decode(response.data.toString());
  //print(res);

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
  String path1 = prefs.getString('path');
  Dio dio = new Dio();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  final response = await dio.post(path1 + "getheadtype?orgid=$orgdir&eid=$empid");
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
  Expensedate({
    this.dates,
    this.Fdate,
  });
}

Future<List<Expensedate>> getExpenselistbydate() async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String path1 = prefs.getString('path');
  String orgdir = prefs.getString('organization') ?? '';
  String empid =  prefs.getString('employeeid')??"";

  Response<String>response =
  await dio.post(path1+"getExpenseDetailbydate?empid="+empid+'&orgid='+orgdir);
  final res = json.decode(response.data.toString());
  //print(res);

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

withdrawExpense(Expense expense) async{
  Dio dio = new Dio();
  try {
    final prefs = await SharedPreferences.getInstance();
    String path_hrm_india1 = prefs.getString('path_hrm_india');
    FormData formData = new FormData.from({
      "id": expense.Id,
      "status": expense.ests
    });
    print("---------------"+expense.Id);
    print("---------------"+expense.ests);
    //Response response = await dio.post("https://sandbox.ubiattendance.com/index.php/services/getInfo", data: formData);
    Response response = await dio.post(
        path_hrm_india1+"changeExpenseSts",
        data: formData);
    //print(response.toString());
    if (response.statusCode == 200) {
      Map leaveMap = json.decode(response.data);
      if(leaveMap["status"]==true){
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



