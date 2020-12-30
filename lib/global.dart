import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'model/model.dart';
import 'model/timeinout.dart';

appStartColor() {
  return Color.fromRGBO(0, 166, 90,1.0);
}

appEndColor() {
  return Colors.green[200];
}

scaffoldBackColor() {
  return  Colors.green[100];
}

headingColor() {
  return Colors.green;
}

bottomNavigationColor(){
  return Color.fromRGBO(51,51,51,1.0);
}

circleIconBackgroundColor(){
  return Colors.green[50];
}

String path="http://ubihrmglobal.zentylpro.com/ubiapp/";
String path_ubiattendance="http://ubihrmglobal.zentylpro.com/HRMAPP/index.php/Att_services/";
String path_hrm_india="http://ubihrmglobal.zentylpro.com/services/";

/*String path="https://ubitech.ubihrm.com/ubiapp/";
String path_ubiattendance="https://ubitech.ubihrm.com/HRMAPP/index.php/Att_services/";
String path_hrm_india="https://ubitech.ubihrm.com/services/";*/

int home_load_num = 0;
List<Permission> globalpermissionlist =new List();
List<Permission> globalpermissionlist1 =new List();
Map globalcompanyinfomap;
Map globalpersnalinfomap;
Map globalcontactusinfomap;
Map globalprofileinfomap;
Map globalogrperminfomap;
Map globallabelinfomap;
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
var perGeoFence;
var perSalaryExpense;
var perPayrollExpense;
var perFlexi;
var deprtcurrency;
String appVersion='1.0.2';
String latestVersionReleaseDate='01-Dec-2020';
String appVersionReleaseDate='02-Feb-2020';


bool locationThreadUpdatedLocation=false;
bool timeSpoofed=false;
int areaId=0;
var orgCreatedDate='0000-00-00';
String geoFenceOrgPerm="0";//Geo Fence org permission
String mailVerifySts="0";//Geo Fence org permission
String grpCompanySts="0";//Geo Fence org permission
String fenceAreaSts="0";
String areaSts='';
String assignedAreaIds = "";
var assign_lat = 0.0;//These are user to store latitude got from javacode throughout the app
var assign_long = 0.0;//These are user to store latitude got from javacode throughout the app
var assigned_lat = 0.0;//These are user to store geofence latitude got from server throughout the app
var assigned_long = 0.0;//These are user to store geofence latitude got from server throughout the app
var assign_radius = 0.0;
String globalcity='City Not Fetched';
String showMailVerificationDialog="false";
String geoFenceStatus='';//Geofence in or out
String AbleTomarkAttendance='0';
