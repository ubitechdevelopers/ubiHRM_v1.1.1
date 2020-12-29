import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/global.dart';


class RequestPayrollService{
  var dio = new Dio();
}

class Payroll{
  String id;
  String empId;
  String name;
  String startdate;
  String enddate;
  String paid_days;
  String EmployeeCTC;
  String Currency;

  Payroll({this.id, this.empId, this.name, this.startdate, this.enddate, this.paid_days, this.EmployeeCTC, this.Currency});
}

class PayrollExpense {
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

  PayrollExpense({
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

class PayrollExpenseDate {
  String dates;
  String Fdate;
  PayrollExpenseDate({
    this.dates,
    this.Fdate,
  });
}


Future<List<PayrollExpense>> getPayrollExpenselist(date) async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('organization') ?? '';
  String empid =  prefs.getString('employeeid')??"";
  Response<String>response = await dio.post(path+"getPayrollExpenseDetail?empid="+empid+'&orgid='+orgdir+'&date='+date);
  final res = json.decode(response.data.toString());
  List<PayrollExpense> userList = createPayrollExpenselist(res);
  return userList;
}

List<PayrollExpense> createPayrollExpenselist(List data) {
  List<PayrollExpense> list = new List();
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
    PayrollExpense tos = new PayrollExpense(
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


Future<List<PayrollExpenseDate>> getPayrollExpenselistbydate() async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('organization') ?? '';
  String empid =  prefs.getString('employeeid')??"";
  Response<String>response = await dio.post(path+"getPayrollExpenseDetailbydate?empid="+empid+'&orgid='+orgdir);
  final res = json.decode(response.data.toString());
  List<PayrollExpenseDate> userList = createPayrollExpenselistbydate(res);
  return userList;
}

List<PayrollExpenseDate> createPayrollExpenselistbydate(List data) {
  List<PayrollExpenseDate> list = new List();
  for (int i = 0; i < data.length; i++) {
    String dates = data[i]["fromdate"].toString();
    String Fdate = data[i]["Fdate"].toString();
    PayrollExpenseDate tos = new PayrollExpenseDate(
      dates: dates,
      Fdate: Fdate,
    );
    list.add(tos);
  }
  return list;
}


Future<List<Map>> getpayrollheadtype(int label) async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  final response = await dio.post(path + "getpayrollheadtype?orgid=$orgdir&eid=$empid");
  List data = json.decode(response.data.toString());
  List<Map> leavetype = createPayrollHeadList(data,label);
  return leavetype;
}

List<Map> createPayrollHeadList(List data,int label) {
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


Future<List<PayrollExpense>> getPayrollExpenseDetailById(Id) async{
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('organization') ?? '';
  try {
    FormData formData = new FormData.from({
      "Id" : Id,
      "orgid":orgid
    });
    print(path_hrm_india+"showPayrollExpenseDetail?Id=$Id&orgid=$orgid");
    Response response = await dio.post(
        path_hrm_india+"showPayrollExpenseDetail",
        data: formData
    );
    List responseJson = json.decode(response.data.toString());
    List<PayrollExpense> expenseDetail = viewPayrollExpenseDetail(responseJson);

    return expenseDetail;

  }catch(e){
    print(e.toString());
  }
}

List<PayrollExpense> viewPayrollExpenseDetail(List data) {
  List<PayrollExpense> list = new List();
  for (int i = 0; i < data.length; i++) {
    String Id = data[i]["Id"].toString();
    String category = data[i]["ClaimHead"].toString();
    String desc = data[i]["Purpose"].toString();
    String applydate = data[i]["CreatedDate"].toString();
    String ests = data[i]["appstatus"].toString();
    String amt = data[i]["TotalAmt"].toString();
    String doc = data[i]["Doc"].toString();
    print("document"+doc);
    String currency = data[i]["empcurency"].toString();
    PayrollExpense tos = new PayrollExpense(
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


//////////////////////////////////////////////PAYROLL EXPENSE APPROVAL TAB ID 8 AND MODULT ID 473/////////////////////////////////////////////////
Future<List<PayrollExpense>> getPayrollExpenseApprovals(listType) async {
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  Response<String> response = await dio.post(path+"getPayrollExpenseApproval?datafor="+listType+'&empid='+empid+'&orgid='+orgdir);
  print(path+"getPayrollExpenseApproval?datafor="+listType+'&empid='+empid+'&orgid='+orgdir);
  final res = json.decode(response.data.toString());
  List<PayrollExpense> userList = createPayrollExpenseApporval(res);
  return userList;
}

List<PayrollExpense> createPayrollExpenseApporval(List data) {
  List<PayrollExpense> list = new List();
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
    PayrollExpense tos = new PayrollExpense(
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
    Response response = await dio.post(path+"ApprovedPayrollExpense", data: formData);
    print(path+"ApprovedExpense?eid=$empid&orgid=$organization&expenseid=$expenseid&comment=$comment&sts=$sts");
    final expenseMap = response.data.toString();

    if (expenseMap.contains("false")) {
      return "false";
    } else {
      return "true";
    }
  }catch(e){
    //print(e.toString());
    return "Poor network connection";
  }
}


withdrawPayrollExpense(PayrollExpense expense) async{
  Dio dio = new Dio();
  try {
    FormData formData = new FormData.from({
      "id": expense.Id,
      "status": expense.ests
    });
    Response response = await dio.post(path_hrm_india+"changePayrollExpenseSts", data: formData);
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
////////////////////////////////////PAYROLL EXPENSE APPROVAL TAB ID 8 AND MODULT ID 473 ENDS HERE//////////////////////////////////////


Future<List<Payroll>> getPayrollSummary() async{
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  try {
    FormData formData = new FormData.from({
      "employeeid": empid,
      "organization": organization,
    });
    print(path+"getPayrollSummary?employeeid=$empid&organization=$organization");
    Response response = await dio.post(path+"getPayrollSummary", data: formData);
    List responseJson = json.decode(response.data.toString());

    List<Payroll> userList = createPayrollList(responseJson);

    return userList;

  }catch(e){
    print(e.toString());
  }
}


Future<List<Payroll>> getPayrollSummaryAll() async{
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  String organization = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  try {
    /*FormData formData = new FormData.from({
      "employeeid": empid,
      "organization": organization,
    });*/
    print(path+"getPayrollSummary?all=all&employeeid=$empid&organization=$organization&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess");
    Response response = await dio.post(path+"getPayrollSummary?all=all&employeeid=$empid&organization=$organization&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess");
    List responseJson = json.decode(response.data.toString());

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
    String empId = data[i]["EmployeeId"];
    String name=data[i]["name"];
    String PaidDays=data[i]["PaidDays"];
    String StartDate=data[i]["SalaryMonth"];
    String EndDate=data[i]["EndDate"];
    String EmployeeCTC=data[i]["EmployeeCTC"];
    String Currency=data[i]["currency"];
    Payroll payroll = new Payroll(id:id, empId:empId, name:name, paid_days:PaidDays, startdate:StartDate, enddate:EndDate, EmployeeCTC:EmployeeCTC, Currency:Currency);
    list.add(payroll);
  }
  return list;
}
