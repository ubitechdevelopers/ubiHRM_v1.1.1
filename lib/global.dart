import 'package:flutter/material.dart';
import 'model/model.dart';

appStartColor() {
  return Color.fromRGBO(0, 166, 90,1.0);
}

appEndColor() {
  return Colors.green[200];
}

scaffoldBackColor(){
  return  Colors.green[100];
}

headingColor(){
  return Colors.green;
}

bottomNavigationColor(){
  return Color.fromRGBO(0, 166, 90,1.0);
}

circleIconBackgroundColor(){
  return Colors.green[50];
}

String path="http://192.168.0.200/UBIHRM/HRMINDIA/ubiapp/";

String path_ubiattendance="http://192.168.0.200/ubiattendance/index.php/Att_services/";

String path_hrm_india="https://ubitech.ubihrm.com/services/";

List<Permission> globalpermissionlist =new List();
Map globalcompanyinfomap;
Map globalpersnalinfomap;
Map globalcontactusinfomap;
Map globalprofileinfomap;

