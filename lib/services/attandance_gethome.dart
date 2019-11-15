import 'package:ubihrm/model/user.dart';
import 'package:dio/dio.dart';
import 'package:ubihrm/model/employee.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../global.dart' as globals;
import 'attandance_fetch_location.dart';
import 'package:ubihrm/model/timeinout.dart';


class Home{
  var dio = new Dio();

  checkTimeIn(String empid, String orgid) async{
    try {
      final prefs = await SharedPreferences.getInstance();
      String path_ubiattendance1 = prefs.getString('path_ubiattendance');
      FormData formData = new FormData.from({
        "uid": empid,
        "refno": orgid,
      });
      //Response response = await dio.post("https://sandbox.ubiattendance.com/index.php/services/getInfo", data: formData);
      Response response = await dio.post(
          path_ubiattendance1+"getInfo",
          data: formData);
      //print("<<------------------GET HOME-------------------->>");
      //print(response.toString());
      //print("this is status "+response.statusCode.toString());
      if (response.statusCode == 200) {
        Map timeinoutMap = json.decode(response.data);
        String aid = timeinoutMap['aid'].toString();
        String sstatus = timeinoutMap['sstatus'].toString();
        String mail_varified = timeinoutMap['mail_varified'].toString();
        String profile = timeinoutMap['profile'].toString();
        String newpwd = timeinoutMap['pwd'].toString();
        int Is_Delete = int.parse(timeinoutMap['Is_Delete']);
        String Otimests = timeinoutMap['Otimests'].toString();
        String Attid = timeinoutMap['Attid'].toString();
        print("---------->"+Is_Delete.toString());
        //  print(newpwd+" new pwd  and old pwd "+  prefs.getString('userpwd'));
        // print(timeinoutMap['pwd']);
        prefs.setString('aid', aid);
        prefs.setString('sstatus', sstatus);
        prefs.setString('mail_varified', mail_varified);
        prefs.setString('profile', profile);
        prefs.setString('newpwd', newpwd);
        prefs.setString('Otimests', Otimests);
        prefs.setString('shiftId', timeinoutMap['shiftId']);
        prefs.setString('leavetypeid', timeinoutMap['leavetypeid']);
        prefs.setInt('Is_Delete', Is_Delete);
       print(Otimests);
        prefs.setString('Attid', timeinoutMap['Attid']);

        print("------->aaaaaaaa");
        print(aid);
        print("------->aaaaaaaa");
        print(timeinoutMap['act']);
        print("lllllll");
        return timeinoutMap['act'];
      } else {
        return "Poor network connection";
      }
    }catch(e){
   //   print("PRATIBHA");
      return "Poor network connection";
    }
  }

  managePermission(String empid, String orgid, String designation) async{
//print("This is called manage permissions-------------------->");
    /*Comment permission module below as per discussion with badi ma'am @ 5 nov- Abhinav*/

    /* try {
      final prefs = await SharedPreferences.getInstance();
      FormData formData = new FormData.from({
        "uid": empid,
        "refid": orgid,
        "roleid": designation
      });

      Response response = await dio.post(
          globals.path+"getUserPermission",
          data: formData
      );

      //print("<<------------------GET USER PERMISSION-------------------->>");
      //print(response.toString());
      //print("this is user permission "+response.statusCode.toString());
      if (response.statusCode == 200) {
        Map permissionMap = json.decode(response.data.toString());
        //print(permissionMap["userpermission"]["DepartmentMaster"]);
        globals.department_permission = permissionMap["userpermission"]["DepartmentMaster"]==1 ? permissionMap["userpermission"]["DepartmentMaster"]: 0;
        globals.designation_permission = permissionMap["userpermission"]["DesignationMaster"]==1 ? permissionMap["userpermission"]["DesignationMaster"]: 0;
        globals.leave_permission = permissionMap["userpermission"]["EmployeeLeave"]==1 ? permissionMap["userpermission"]["EmployeeLeave"]: 0;
        globals.shift_permission = permissionMap["userpermission"]["ShiftMaster"]==1 ? permissionMap["userpermission"]["ShiftMaster"]: 0;
        globals.timeoff_permission = permissionMap["userpermission"]["Timeoff"]==1 ? permissionMap["userpermission"]["Timeoff"]: 0;
        globals.punchlocation_permission = permissionMap["userpermission"]["checkin_master"]==1 ? permissionMap["userpermission"]["checkin_master"]: 0;
        globals.employee_permission = permissionMap["userpermission"]["EmployeeMaster"]==1 ? permissionMap["userpermission"]["EmployeeMaster"]: 0;
        globals.permission_module_permission = permissionMap["userpermission"]["UserPermission"]==1 ? permissionMap["userpermission"]["UserPermission"]: 0;
        globals.report_permission = permissionMap["userpermission"]["ReportMaster"]==1 ? permissionMap["userpermission"]["ReportMaster"]: 0;
      } else {
        return "Poor network connection";
      }
    }catch(e){
      //print(e.toString());
      return "Poor network connection";
    }*/

    /*Putting Admin_sts instead of permissions*/
    final prefs = await SharedPreferences.getInstance();
    String admin_sts=prefs.getString('sstatus') ?? '0';
    //print("---------> this is admin status from get home "+admin_sts);
    if(admin_sts=='1'){
      globals.department_permission = 1;
      globals.designation_permission = 1;
      //globals.leave_permission = 1;
      globals.shift_permission = 1;
      globals.timeoff_permission = 1;
      globals.punchlocation_permission = 1;
      globals.employee_permission = 1;
      //globals.permission_module_permission = 1;
      globals.report_permission = 1;
    }
  }

  checkTimeInQR(String empid, String orgid) async{
    try {
      final prefs = await SharedPreferences.getInstance();
      String path_ubiattendance1 = prefs.getString('path_ubiattendance');
      FormData formData = new FormData.from({
        "uid": empid,
        "refid": orgid,
      });
      //Response response = await dio.post("https://sandbox.ubiattendance.com/index.php/services/getInfo", data: formData);
      Response response = await dio.post(
          path_ubiattendance1+"getInfo",
          data: formData);
      //Response response = await dio.post("http://192.168.0.20 0/UBIHRM/HRMINDIA/services/getInfo", data: formData);
      //Response response = await dio.post("https://ubitech.ubihrm.com/services/getInfo", data: formData);

      //print(response.toString());
      //print("this is status "+response.statusCode.toString());
      if (response.statusCode == 200) {
        Map timeinoutMap = json.decode(response.data);
        /*Loc lock = new Loc();
        Map location = await lock.fetchlatilongi();*/
        String lat="",long="";
        String streamlocationaddr = "";
        if(globals.list!=null && globals.list.length>0) {
          lat = globals.list[globals.list.length - 1].latitude.toString();
          long = globals.list[globals.list.length - 1].longitude.toString();
          streamlocationaddr = globals.globalstreamlocationaddr;
          timeinoutMap.putIfAbsent('latit', ()=> lat );
          timeinoutMap.putIfAbsent('longi', ()=> long );
        }else{
          timeinoutMap.putIfAbsent('latit', ()=> 0.0 );
          timeinoutMap.putIfAbsent('longi', ()=> 0.0 );
        }
        timeinoutMap.putIfAbsent('location', ()=> streamlocationaddr );
        timeinoutMap.putIfAbsent('uid', ()=> empid );
        timeinoutMap.putIfAbsent('refid', ()=> orgid );
        return timeinoutMap;
      } else {
        return "Poor network connection";
      }
    }catch(e){
      //print(e.toString());
      return "Poor network connection";
    }
  }

}