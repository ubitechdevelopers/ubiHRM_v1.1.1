import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/global.dart';
import 'package:http/http.dart' as http;


class Regularization {
  String id;
  String timein;
  String timeout;
  String device;
  String date;

  Regularization({this.id, this.timein, this.timeout,this.device,this.date});
}


Future<List<Regularization>> getRegularization(month) async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  final response = await http.get(path_ubiattendance+'getRegularization?&month=$month&uid=$empid&orgid=$orgdir');
  print(path_ubiattendance+'getRegularization?&month=$month&uid=$empid&orgid=$orgdir');
  List responseJson = json.decode(response.body.toString());
  List<Regularization> regList = creategetRegularizationList(responseJson);
  return regList;
}

List<Regularization> creategetRegularizationList(List data) {
  List<Regularization> list = new List();
  for (int i = 0; i < data.length; i++) {
    String id = data[i]["id"];
    String timein = data[i]["timein"];
    String timeout = data[i]["timeout"];
    String device = data[i]["device"];
    String regDate = data[i]["date"];
    Regularization regularization = new Regularization(id: id, timein: timein, timeout: timeout,device: device,  date: regDate);
    list.add(regularization);
  }
  return list;
}


Future<String> OnSendRegularizeRequest(String id,String timein,String timeout,String remark) async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  final response = await http.get(path_ubiattendance+'OnSendRegularizeRequest?uid=$empid&orgid=$orgdir&id=$id&timein=$timein&timeout=$timeout&remark=$remark');
  print(path_ubiattendance+'OnSendRegularizeRequest?uid=$empid&orgid=$orgdir&id=$id&timein=$timein&timeout=$timeout&remark=$remark');
  return response.body.toString();
}

