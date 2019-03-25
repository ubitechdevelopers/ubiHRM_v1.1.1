import 'package:flutter/material.dart';
import 'model/model.dart';
import 'model/timeinout.dart';
//import 'package:ubihrm/model/timeinout.dart';

appStartColor() {
  return Color.fromRGBO(0, 166, 90,1.0);
 // return Colors.yellowAccent[200];
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
 // return Color.fromRGBO(0, 166, 90,1.0);
  return Color.fromRGBO(51,51,51,1.0);
}

circleIconBackgroundColor(){
  return Colors.green[50];
}

String path="http://192.168.0.200/UBIHRM/HRMINDIA/ubiapp/";

//String path_ubiattendance="http://192.168.0.200/ubiattendance/index.php/Att_services/";

String path_ubiattendance="http://192.168.0.200/UBIHRM/HRMINDIA/HRMAPP/index.php/Att_services/";


String path_hrm_india="http://192.168.0.200/UBIHRM/HRMINDIA/services/";

/*String path="https://ubitech.ubihrm.com/ubiapp/";
String path_ubiattendance="https://ubiattendance.ubihrm.com/index.php/Att_services/";
String path_hrm_india="https://ubitech.ubihrm.com/services/";*/

/*
String path="https://sandbox.ubihrm.com/ubiapp/";
String path_ubiattendance="https://ubiattendance.ubihrm.com/index.php/Att_services/";
String path_hrm_india="https://sandbox.ubihrm.com/services/";*/

int home_load_num = 0;
List<Permission> globalpermissionlist =new List();
Map globalcompanyinfomap;
Map globalpersnalinfomap;
Map globalcontactusinfomap;
Map globalprofileinfomap;


//////Copied from  attendance global///////
List<Map<String, double>> list = new List();
String globalstreamlocationaddr="";
bool stopstreamingstatus = false;

int department_permission = 0, designation_permission = 0, leave_permission = 0, shift_permission = 0, timeoff_permission = 1,punchlocation_permission = 1, employee_permission = 0, permission_module_permission = 0, report_permission = 0;
int globalalertcount = 0;
MarkTime mk1;
//////Copied from  attendance global///////

var perL;
var perA;
var perAtt;
var perTimeO;
var perReport;
var perSet;
var perAttMS;
var perHoliday;

