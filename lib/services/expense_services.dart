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


//////////////////////////////////////SALARY EXPENSE APPROVAL TAB ID 4 AND MODULT ID 170 STARTS FROM HERE///////////////////////////////////////
Future<List<Expense>> getExpenseApprovals(listType) async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Response<String> response = await dio.post(path+"getExpenseApproval?datafor="+listType+'&empid='+empid+'&orgid='+orgdir);
  print(path+"getExpenseApproval?datafor="+listType+'&empid='+empid+'&orgid='+orgdir);
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
    Response response = await dio.post(path+"ApprovedExpense", data: formData);
    print(path+"ApprovedExpense?eid=$empid&orgid=$organization&expenseid=$expenseid&comment=$comment&sts=$sts");
    final expenseMap = response.data.toString();

    if (expenseMap.contains("false")) {
      return "false";
    } else {
      return "true";
    }
  }catch(e){
    print(e.toString());
    return "Poor network connection";
  }
}
//////////////////////////////////////SALARY EXPENSE APPROVAL TAB ID 4 AND MODULT ID 170 ENDS HERE///////////////////////////////////////


Future<List<Expense>> getExpenseDetailById(Id) async{
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('organization') ?? '';
  try {
    FormData formData = new FormData.from({
      "Id" : Id,
      "orgid":orgid
    });
    Response response = await dio.post(
        path_hrm_india+"showExpenseDetail",
        data: formData
    );
    List responseJson = json.decode(response.data.toString());
    List<Expense> expenseDetail = viewExpenseDetail(responseJson);
    return expenseDetail;
  }catch(e){
    print(e.toString());
  }
}

List<Expense> viewExpenseDetail(List data) {
  List<Expense> list = new List();
  for (int i = 0; i < data.length; i++) {
    String Id = data[i]["Id"].toString();
    String category = data[i]["ClaimHead"].toString();
    String desc = data[i]["Purpose"].toString();
    String applydate = data[i]["CreatedDate"].toString();
    String ests = data[i]["appstatus"].toString();
    String amt = data[i]["TotalAmt"].toString();
    String doc = data[i]["Doc"].toString();
    String currency = data[i]["empcurency"].toString();
    deprtcurrency=data[i]["empcurency"].toString();
    Expense tos = new Expense(
      Id: Id,
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
  String orgdir = prefs.getString('organization') ?? '';
  String empid =  prefs.getString('employeeid')??"";
  Response<String>response = await dio.post(path+"getExpenseDetail?empid="+empid+'&orgid='+orgdir+'&date='+date);
  final res = json.decode(response.data.toString());
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
  List data = json.decode(response.data.toString());
  List<Map> leavetype = createList(data,label);
  return leavetype;
}

List<Map> createList(List data,int label) {
  List<Map> list = new List();
  if(label==1) // with -All- label
    list.add({"Id":"0","Name":"-All-"});
  else
    list.add({"Id":"0","Name":"-Select-"});

  for (int i = 0; i < data.length; i++) {
    Map tos={"Id":data[i]["id"].toString(),"Name":data[i]["name"].toString() };
    list.add(tos);
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
  String orgdir = prefs.getString('organization') ?? '';
  String empid =  prefs.getString('employeeid')??"";
  Response<String>response = await dio.post(path+"getExpenseDetailbydate?empid="+empid+'&orgid='+orgdir);
  final res = json.decode(response.data.toString());
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
    FormData formData = new FormData.from({
      "id": expense.Id,
      "status": expense.ests
    });
    Response response = await dio.post(path_hrm_india+"changeExpenseSts", data: formData);
    if (response.statusCode == 200) {
      final expenseMap = response.data.toString();
      if (expenseMap.contains("true")) {
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