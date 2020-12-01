import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'model/model.dart';
import 'model/timeinout.dart';

//import 'package:ubihrm/model/timeinout.dart';

appStartColor() {
  return Color.fromRGBO(0, 166, 90,1.0);
  // return Colors.yellowAccent[200];
}

appEndColor()
{
  return Colors.green[200];
}

scaffoldBackColor()
{
  return  Colors.green[100];
}

headingColor()
{
  return Colors.green;
}

bottomNavigationColor(){
  // return Color.fromRGBO(0, 166, 90,1.0);
  return Color.fromRGBO(51,51,51,1.0);
}

circleIconBackgroundColor(){
  return Colors.green[50];
}

/*String path="http://192.168.0.200/UBIHRM/GLOBAL/ubiapp/";
String path_ubiattendance="http://192.168.0.200/UBIHRM/GLOBAL/HRMAPP/index.php/Att_services/";
String path_hrm_india="http://192.168.0.200/UBIHRM/GLOBAL/services/";*/

String path="http://ubihrmglobal.zentylpro.com/ubiapp1/";
String path_ubiattendance="http://ubihrmglobal.zentylpro.com/HRMAPP/index.php/Att_services1/";
String path_hrm_india="http://ubihrmglobal.zentylpro.com/services/";

/*String path="https://ubitech.ubihrm.com/ubiapp/";
String path_ubiattendance="https://ubitech.ubihrm.com/HRMAPP/index.php/Att_services/";
String path_hrm_india="https://ubitech.ubihrm.com/services/";*/

/*String path="https://sandbox.ubihrm.com/ubiapp/";
String path_ubiattendance="https://sandbox.ubihrm.com/HRMAPP/index.php/Att_services/";
String path_hrm_india="https://sandbox.ubihrm.com/services/";*/

/*String path="https://ubihrm.ubipayroll.com/ubiapp/";
String path_ubiattendance="https://ubihrm.ubipayroll.com/HRMAPP/index.php/Att_services/";
String path_hrm_india="https://ubihrm.ubipayroll.com/services/";*/

int home_load_num = 0;
List<Permission> globalpermissionlist =new List();
List<Permission> globalpermissionlist1 =new List();
Map globalcompanyinfomap;
Map globalpersnalinfomap;
Map globalcontactusinfomap;
Map globalprofileinfomap;
Map globalogrperminfomap;
Map globalyearfiscal;

//////Copied from  attendance global///////
List<LocationData> list = new List();
String globalstreamlocationaddr="";
bool stopstreamingstatus = false;

int department_permission = 0, designation_permission = 0, leave_permission = 0, shift_permission = 0, timeoff_permission = 1,punchlocation_permission = 1, employee_permission = 0, permission_module_permission = 0, report_permission = 0;
int globalalertcount = 0;
MarkTime mk1;
int visitImage = 1;

//////Copied from  attendance global///////
var perEmployeeLeave;
var perLeaveApproval;
var perTimeoffApproval;
var perSalaryExpenseApproval;
var perPayrollExpenseApproval;
var perAttendance;
var perAttReport;
var perFlexiReport;
var perLeaveReport;
var perTimeoff;
var perReport;
var perSet;
var perAttMS;
var perHoliday;
var fiscalyear;
var perPunchLocation;
var overtime;
var undertime;
var perSalary;
var perPayroll;
var perPayPeriod;
var perSalaryExpense;
var perPayrollExpense;
var perFlexi;
var deprtcurrency;
String appVersion='1.0.8';
String latestVersionReleaseDate='01-Dec-2020';
String appVersionReleaseDate='02-Feb-2020';

