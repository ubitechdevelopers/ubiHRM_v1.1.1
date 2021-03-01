import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/global.dart' as globals;
import 'package:ubihrm/model/model.dart';
import 'package:url_launcher/url_launcher.dart';


Future checkNow() async {
  final res = await http.get(path_ubiattendance + 'getAppVersion?platform=Android');
  print(path_ubiattendance + 'getAppVersion?platform=Android');
  return ((json.decode(res.body.toString()))[0]['version']).toString();
}


Future checkMandUpdate() async {
  final res = await http.get(path_ubiattendance+ 'checkMandUpdate?platform=Android');
  print(path_ubiattendance + 'checkMandUpdate?platform=Android');
  return ((json.decode(res.body))[0]['is_update']).toString();
}


Future UpdateStatus() async {
  try{
    final res = await http.get(path_ubiattendance+ 'UpdateStatus?platform=Android');
    print(path_ubiattendance+ 'UpdateStatus?platform=Android');
    return ((json.decode(res.body.toString()))[0]['status']).toString();
  } catch(e){
    print("Exception"+e);
    print("Error finding current version of the app");
    return"error";
  }
}


String Formatdate(String date_) {
  var months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  var dy = [
    'st',
    'nd',
    'rd',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'st',
    'nd',
    'rd',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'st'
  ];
  var date = date_.split("-");
  return (date[2] + "" + dy[int.parse(date[2]) - 1] + " " + months[int.parse(date[1]) - 1]);
}


String Formatdate1(String date_) {
  var months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  var date = date_.split("-");
  return (date[2] + "-" + months[int.parse(date[1]) - 1]);
}


String Formatdate2(String date_) {
  var months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  var date = date_.split("-");
  return (date[2] + "-" + months[int.parse(date[1]) - 1]  + "-" + date[0]);
}


setPunchPrefs(lid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('lid', lid);
}


goToMap(String lat, String long) async{
  if((lat.toString()).startsWith('0',0) || (long.toString()).startsWith('0',0) )
    return false;
  String url = "https://maps.google.com/?q="+lat+","+long;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print( 'Could not launch $url');
  }
}


class StreamLocation{
  LocationData _currentLocation;
  StreamSubscription<LocationData> _locationSubscription;
  Location _location = new Location();
  String streamlocationaddr="";
  String lat="";
  String long="";
  bool _permission = true;
  String error;

/*void startStreaming(int listlength) async{
    try {
      _permission = await _location.hasPermission();
      error = null;
    }catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
        'Permission denied - please ask the user to enable it from the app settings';
      }
      _location = null;
    }

    try {
      int counter = 0;
      stopstreamingstatus = false;
      _locationSubscription =
          _location.onLocationChanged().listen((LocationData result) async{
            _currentLocation = result;
            list.add(result);
            print("List streaming in newservices " +list[list.length - 1].toString());
            getAddress(list[list.length - 1]);
            if (counter > listlength) {
              list.removeAt(0);
              stopstreamingstatus = true;
              _locationSubscription.cancel();
            }
            counter++;
          });
    } catch(e){
      //print(e.toString());
      _currentLocation = null;
    }
  }*/

  getAddress( LocationData _currentLocation) async{
    try {
      if (_currentLocation != null) {
        var addresses = await Geocoder.local.findAddressesFromCoordinates(
            Coordinates(
                _currentLocation.latitude, _currentLocation.longitude));
        var first = addresses.first;
        streamlocationaddr = "${first.addressLine}";
        globalstreamlocationaddr = streamlocationaddr;
      }
    }catch(e){
      if (_currentLocation != null) {
        globalstreamlocationaddr = "${_currentLocation.latitude},${_currentLocation.longitude}";
      }

    }
  }
}


class Home{
  var dio = new Dio();

  checkTimeIn(String empid, String orgid) async{
    try {
      final prefs = await SharedPreferences.getInstance();
      FormData formData = new FormData.from({
        "uid": empid,
        "refno": orgid,
      });
      Response response = await dio.post(
          path_ubiattendance+"getInfo",
          data: formData);
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
        prefs.setString('aid', aid);
        prefs.setString('sstatus', sstatus);
        prefs.setString('mail_varified', mail_varified);
        prefs.setString('profile', profile);
        prefs.setString('newpwd', newpwd);
        prefs.setString('Otimests', Otimests);
        prefs.setString('shiftId', timeinoutMap['shiftId']);
        prefs.setString('leavetypeid', timeinoutMap['leavetypeid']);
        prefs.setInt('Is_Delete', Is_Delete);
        prefs.setString('Attid', timeinoutMap['Attid']);
        return timeinoutMap['act'];
      } else {
        return "Poor network connection";
      }
    }catch(e){
      return "Poor network connection";
    }
  }

  managePermission(String empid, String orgid, String designation) async{
    final prefs = await SharedPreferences.getInstance();
    String admin_sts=prefs.getString('sstatus') ?? '0';

    if(admin_sts=='1'){
      globals.department_permission = 1;
      globals.designation_permission = 1;
      globals.shift_permission = 1;
      globals.timeoff_permission = 1;
      globals.punchlocation_permission = 1;
      globals.employee_permission = 1;
      globals.report_permission = 1;
    }
  }

/*  checkTimeInQR(String empid, String orgid) async{
    try {
      FormData formData = new FormData.from({
        "uid": empid,
        "refid": orgid,
      });
      Response response = await dio.post(
          path_ubiattendance+"getInfo",
          data: formData);
      if (response.statusCode == 200) {
        Map timeinoutMap = json.decode(response.data);
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
  }*/

}


class NewServices{
  var dio = new Dio();
/*  getProfile(String empid) async{
    try {
      FormData formData = new FormData.from({
        "uid": empid,
      });
      Response response = await dio.post(
          path+"getProfile",
          data: formData);

      if (response.statusCode == 200) {
        Map profileMap = json.decode(response.data);
        return profileMap;
      }else{
        return "No Connection";
      }
    }catch(e){
      print(e.toString());
      return "Poor network connection";
    }
  }


  updateProfile(Profile profile) async{
    try {
      FormData formData = new FormData.from({
        "uid": profile.uid,
        "refno": profile.orgid,
        "no": profile.mobile,
        "con": profile.countryid
      });
      Response response = await dio.post(
          path+"updateProfile",
          data: formData);
      if (response.statusCode == 200) {
        Map profileMap = json.decode(response.data);
        if(profileMap["res"]==1){
          return "success";
        }else{
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


  Future<bool> updateProfilePhoto(int uploadtype, String empid, String orgid) async {
    try{
      File imagei = null;
      imageCache.clear();
      //for gallery
      if(uploadtype==1){
        imagei = await ImagePicker.pickImage(source: ImageSource.gallery);
      }
      //for camera
      if(uploadtype==2){
        imagei = await ImagePicker.pickImage(source: ImageSource.camera);
      }
      //for removing photo
      if(uploadtype==3){
        imagei = null;
      }

      if(imagei!=null ) {
        //// sending this base64image string +to rest api
        FormData formData = new FormData.from({
          "uid": empid,
          "refno": orgid,
          "file": new UploadFileInfo(imagei, "sample.png"),
        });
        Response<String> response1=await dio.post(path_hrm_india+"updateProfilePhoto",data:formData);
        imageCache.clear();
        Map MarkAttMap = json.decode(response1.data);
        if (MarkAttMap["status"])
          return true;
        else
          return false;
      }else if(uploadtype==3 && imagei==null){
        FormData formData = new FormData.from({
          "uid": empid,
          "refno": orgid,
        });
        Response<String> response1=await dio.post(path_hrm_india+"updateProfilePhoto",data:formData);
        Map MarkAttMap = json.decode(response1.data);
        if (MarkAttMap["status"])
          return true;
        else
          return false;
      }else{
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }


  Future<List<Desg>> getAllDesgPermission(String orgid, String desinationId) async{
    try {
      FormData formData = new FormData.from({
        "orgid": orgid,
        "roleid": desinationId
      });
      Response response = await dio.post(
          path+"getAllDesgPermission",
          data: formData
      );
      List responseJson = json.decode(response.data.toString());
      List<Desg> desigList = createDesgPermissionList(responseJson);
      return desigList;
    }catch(e){
      print(e.toString());
    }
  }

  List<Desg> createDesgPermissionList(List data){
    List<Desg> list = new List();
    for (int i = 0; i < data.length; i++) {
      String desg = data[i]["rolename"];
      String id =data[i]["id"];
      List permissionlist = data[i]["permissions"];
      Desg dpt = new Desg(desg: desg,id:id,modulepermissions: permissionlist);
      list.add(dpt);
    }
    return list;
  }


  savePermission(List<Desg> data, String orgid, String empid) async{
    List<Map> list = new List();
    for (int i = 0; i < data.length; i++) {
      Map per = {
        "id":data[i].id.toString(),
        "rolename":data[i].desg.toString(),
        "permissions":data[i].modulepermissions
      };
      list.add(per);
    }
    var jsonlist;
    jsonlist = json.encode(list);
    try {
      FormData formData = new FormData.from({
        "jsondata": jsonlist,
        "orgid": orgid,
        "userid": empid
      });
      Response response = await dio.post(path+"saveAllDesgPermission/",data: formData, options: new Options(contentType:ContentType.parse("application/json")));

      if (response.statusCode == 200) {
        return "success";
      }else{
        return "failed";
      }
    }catch(e){
      return "connection error";
    }
  }*/


  ///////////////////// SERVICES TO RE-SEND VERIFACATION MAIL TO ORGANIATION /////////////////
  resendVerificationMail(String orgid) async{
    print("this is our resendVerificationMail");
    try{
      final prefs = await SharedPreferences.getInstance();
      //String path1 = prefs.getString('path');
      FormData formData = new FormData.from({
        "orgid": orgid,
      });
      Response response1 = await dio.post(path+"resend_verification_mail", data: formData);
      if (response1.statusCode == 200) {
        Map veriMap = json.decode(response1.data);
        return veriMap["status"];
      }else{
        return false;
      }
    }catch(e){
      return false;
    }
  }
///////////////////// SERVICES TO RE-SEND VERIFACATION MAIL TO ORGANIATION /////////////////
}


/*getLastTimeout() async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  String orgdir = prefs.getString('organization') ?? '';
  String empid = prefs.getString('employeeid')??"";
  var response =  await dio.post(path_ubiattendance+"getEmplolyeeTimeout?empid="+empid+"&orgid="+orgdir);
  Map responseJson = json.decode(response.data.toString());
  return responseJson['sts'];
}*/


/*Future<String> PunchSkip(lid) async {
  Map MarkPunchMap = {'status': 'failure'};
  try {
    final prefs = await SharedPreferences.getInstance();
    Dio dio = new Dio();
    FormData formData = new FormData.from({
      "lid": lid,
    });
    Response<String> response1 = await dio.post(path_ubiattendance + "skipPunch", data: formData);
    MarkPunchMap = json.decode(response1.data);
    if (MarkPunchMap['status'].toString() == 'success') setPunchPrefs('0');
    return MarkPunchMap['status'].toString();
  } catch (e) {
    return MarkPunchMap['status'].toString();
  }
}

Future<Map> PunchInOut(comments, client_name, empid, location_addr1, lid, act, orgdir, latit, longi) async {
  Map MarkPunchMap;
  try {
    //final prefs = await SharedPreferences.getInstance();
    Dio dio = new Dio();
    FormData formData = new FormData.from({
      "comment": comments,
      "cname": client_name,
      "uid": empid,
      "orgid": orgdir,
      "loc": location_addr1,
      "longi": longi,
      "latit": latit,
      "act": act,
      "lid": lid,
    });

    Response<String> response1 = await dio.post(path_ubiattendance + "punchLocation", data: formData);

    print(response1.toString());
    MarkPunchMap = json.decode(response1.data);

    if (MarkPunchMap["status"].toString() == 'success') {
      setPunchPrefs(MarkPunchMap["lid"].toString());
      return MarkPunchMap;
    } else
      return MarkPunchMap;
  } catch (e) {
    MarkPunchMap = {'status': 'failure', 'lid': lid};
    return MarkPunchMap;
  }
}


checkPunch(String empid, String orgid) async {
  var dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  return "PunchIn";
}


Future<Map> registerEmp(name,email,pass,phone) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '0';
  final response = await http.get(path_ubiattendance+"registerEmp?f_name= $name&username=$email&password=$pass""&contact=$phone&org_id=$orgdir");
  var res=json.decode(response.body.toString());
  Map<String,String> data={'id':res['id'].toString(),'sts':res['sts'].toString()};
  return data;
}


Future<String> checkAdminSts() async{
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '0';
  String empid = prefs.getString('empid') ?? '0';
  final response = await http.get(path_ubiattendance+"getSuperviserSts?uid=$empid&refid=$orgdir");
  var res=json.decode(response.body.toString());

  prefs.setString('sstatus', res[0]['appSuperviserSts'].toString());
  employee_permission=int.parse(res[0]['appSuperviserSts']);
  return res[0]['appSuperviserSts'].toString();
}


bool validateMobile(String value) {
  if (value.length <6)
    return false;
  else
    return true;
}


bool validateEmail(String value) {
  Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return false;
  else
    return true;
}


Future<List<Map>> getDepartmentsList(int label) async{
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  final response = await http.get(path_ubiattendance + 'DepartmentMaster?orgid=$orgid');
  List data = json.decode(response.body.toString());
  List<Map> depts = createList(data,label);
  return depts;
}

List<Map> createList(List data,int label) {
  List<Map> list = new List();
  if(label==1) // with -All- label
    list.add({"Id":"0","Name":"-All-"});
  else
    list.add({"Id":"0","Name":"-Select-"});
  for (int i = 0; i < data.length; i++) {
    if(data[i]["archive"].toString()=='1') {
      Map tos={"Name":data[i]["Name"].toString(),"Id":data[i]["Id"].toString()};
      list.add(tos);
    }
  }
  return list;
}


Future<List<Map>> getDesignationsList(int label) async{
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  final response = await http.get(path_ubiattendance + 'DesignationMaster?orgid=$orgid');
  List data = json.decode(response.body.toString());
  List<Map> depts = createList(data,label);
  return depts;
}


Future<List<Map>> getShiftsList() async{
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  final response = await http.get(path_ubiattendance + 'shiftMaster?orgid=$orgid');
  List data = json.decode(response.body.toString());
  List<Map> depts = createList(data,0);
  return depts;
}


Future<List<Map>> getEmployeesList1(int label) async{
  Dio dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  //String path_hrm_india1 = prefs.getString('path_hrm_india');
  String orgid = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;

  print(path_ubiattendance + 'getTotalEmployeesList?orgid=$orgid&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final response = await dio.post(path_ubiattendance + 'getTotalEmployeesList?organization=$orgid&employeeid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  List data = json.decode(response.data.toString());
  List<Map> depts = createEMpListDD1(data,label);
  print(depts);
  return depts;
}

List<Map> createEMpListDD1(List data,int label) {
  List<Map> list = new List();
  if(label==1) // with -All- label
    list.add({"Id":"0","Name":"-All-","Code":""});
  else
    list.add({"Id":"0","Name":"-Select-","Code":""});
  for (int i = 0; i < data.length; i++) {
    Map tos;
    if(data[i]["name"].toString()!='' && data[i]["name"].toString()!=null)
      tos={"Id":data[i]["id"].toString(),"Name":data[i]["name"].toString(),"Code":data[i]["ecode"].toString()};
    list.add(tos);
  }
  return list;
}


Future<List<Attn>> getEmpHistoryOf30(listType,emp) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? "";

  final response = await http.get(
      path_ubiattendance + 'getEmpHistoryOf30?refno=$orgdir&datafor=$listType&emp=$emp&empid=$empid');
  final res = json.decode(response.body);
  List responseJson;
  if (listType == 'present')
    responseJson = res['present'];
  else if (listType == 'absent')
    responseJson = res['absent'];
  else if (listType == 'latecomings')
    responseJson = res['lateComings'];
  else if (listType == 'earlyleavings') responseJson = res['earlyLeavings'];
  List<Attn> userList = createListEmpHistoryOf30(responseJson);
  return userList;
}

List<Attn> createListEmpHistoryOf30(List data) {
  List<Attn> list = new List();
  for (int i = 0; i < data.length; i++) {
    String Name = Formatdate(data[i]["AttendanceDate"].toString());
    String TimeIn = data[i]["TimeIn"].toString();
    String TimeOut = data[i]["TimeOut"].toString() == '00:00'
        ? '-'
        : data[i]["TimeOut"].toString();
    String EntryImage = data[i]["EntryImage"].toString() == ''
        ? 'http://ubiattendance.ubihrm.com/assets/img/avatar.png'
        : data[i]["EntryImage"].toString();
    String ExitImage = data[i]["ExitImage"].toString() == ''
        ? 'http://ubiattendance.ubihrm.com/assets/img/avatar.png'
        : data[i]["ExitImage"].toString();
    String CheckInLoc = data[i]["checkInLoc"].toString();
    String CheckOutLoc = data[i]["CheckOutLoc"].toString();
    String LatitIn = data[i]["latit_in"].toString();
    String LatitOut = data[i]["latit_out"].toString();
    String LongiIn = data[i]["longi_in"].toString();
    String LongiOut = data[i]["longi_out"].toString();
    Attn tos = new Attn(
        Name: Name,
        TimeIn: TimeIn,
        TimeOut: TimeOut,
        EntryImage: EntryImage,
        ExitImage: ExitImage,
        CheckInLoc: CheckInLoc,
        CheckOutLoc: CheckOutLoc,
        LatitIn: LatitIn,
        LatitOut: LatitOut,
        LongiIn: LongiIn,
        LongiOut: LongiOut);
    list.add(tos);
  }
  return list;
}


Future<bool> getOrgPerm(perm) async {
  final prefs = await SharedPreferences.getInstance();
  String org_perm = prefs.getString('org_perm') ?? '';
  List<String> permissions = org_perm.split(',');
  return permissions.contains(perm.toString()); // return true if permission found in list set
}


Future<List> getAttentancees() async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  final response = await http.get(path_ubiattendance + 'getAttendancees?orgid=$orgid');
  List responseJson = json.decode(response.body.toString());
  return responseJson;
}


Future <Map> checkOrganization(crn) async{
  final prefs = await SharedPreferences.getInstance();
  final response = await http.get(path_ubiattendance + 'checkOrganization?refid=$crn');
  var responseJson = json.decode(response.body.toString());
  Map<String,String> res ;
  if(responseJson['sts'].toString()=='1')
    res={'sts':responseJson['sts'].toString(),'Id':responseJson['result'][0]['Id'].toString(),'Name':responseJson['result'][0]['Name'].toString()};
  else
    res={'sts':responseJson['sts'].toString()};
  return res;
}
*/


Future<DateTime> getOrgCreatedDate() async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance +'getOrgCreatedDate?orgid=$orgid');
  final response = await http.get(path_ubiattendance +'getOrgCreatedDate?orgid=$orgid');
  return DateTime.parse((json.decode(response.body.toString()))[0]['CreatedDate']);
}


//////////////////////////////////generate employees list for DD starts///////////////////////////////////////
Future<List<Map>> getEmployeesList(int label, String dept, String desg) async{
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  final response = await http.get(path_ubiattendance + 'getEmployeesList?orgid=$orgid&empid=$empid&dept=$dept&desg=$desg&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  print(path_ubiattendance + 'getEmployeesList?orgid=$orgid&empid=$empid&dept=$dept&desg=$desg&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  List data = json.decode(response.body.toString());
  List<Map> depts = createEMpListDD(data,label);
  return depts;
}

List<Map> createEMpListDD(List data,int label) {
  List<Map> list = new List();
  if(label==1) // with -All- label
    list.add({"Id":"0","Name":"-All-","Code":""});
  else
    list.add({"Id":"0","Name":"-Select-","Code":""});
  for (int i = 0; i < data.length; i++) {
    Map tos;
    if(data[i]["Name"].toString()!='' && data[i]["Name"].toString()!=null)
      tos={"Id":data[i]["Id"].toString(),"Name":data[i]["name"].toString(),"Code":data[i]["ecode"].toString()};
    list.add(tos);
  }
  return list;
}
//////////////////////////////////generate employees list for DD ends here///////////////////////////////////////


//*************************************************************************************************************************//

Future<List<Map>> getDivisionsList(int label) async{
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('organization') ?? '';
  print(path_ubiattendance + 'DivisionMaster?orgid=$orgdir');
  final response = await http.get(path_ubiattendance + 'DivisionMaster?orgid=$orgdir');
  List data = json.decode(response.body.toString());
  //print(data);
  List<Map> div = create(data, label);
  return div;
}

List<Map> create(List data, int label) {
  List<Map> list = new List();
  if (label == 1) // with -All- label
    list.add({"Id": "0", "Name": "-All-"});
  else
    list.add({"Id": "0", "Name": "-Select-"});

  for (int i = 0; i < data.length; i++) {
    if (data[i]["archive"].toString() == '0') {
      Map tos = {
        "Name": data[i]["Name"].toString(),
        "Id": data[i]["Id"].toString()
      };
      list.add(tos);
    }
  }
  return list;
}


Future<List<Map>> getLocationsList(int label) async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'LocationMaster?orgid=$orgid');
  final response = await http.get(path_ubiattendance + 'LocationMaster?orgid=$orgid');
  List data = json.decode(response.body.toString());
  //print(data);
  List<Map> loc = createLocationList(data, label);
  return loc;
}

List<Map> createLocationList(List data, int label) {
  List<Map> list = new List();
  if (label == 1) // with -All- label
    list.add({"Id": "0", "Name": "-All-"});
  else
    list.add({"Id": "0", "Name": "-Select-"});

  for (int i = 0; i < data.length; i++) {
    Map tos = {
      "Name":data[i]["Name"].toString(),
      "Id":data[i]["Id"].toString()
    };
    list.add(tos);
  }
  return list;
}


Future<List<Map>> getDepartmentsList(int label) async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'DepartmentMaster?orgid=$orgid');
  final response = await http.get(path_ubiattendance + 'DepartmentMaster?orgid=$orgid');
  List data = json.decode(response.body.toString());
  //print(data);
  List<Map> depts = createList(data, label);
  return depts;
}


Future<List<Map>> getDesignationsList(int label) async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'DesignationMaster?orgid=$orgid');
  final response = await http.get(path_ubiattendance + 'DesignationMaster?orgid=$orgid');
  List data = json.decode(response.body.toString());
  //print(data);
  List<Map> desg = createList(data, label);
  return desg;
}


Future<List<Map>> getShiftsList(int label) async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'shiftMaster?orgid=$orgid');
  final response = await http.get(path_ubiattendance + 'shiftMaster?orgid=$orgid');
  List data = json.decode(response.body.toString());
  //print(data);
  List<Map> shift = createList(data, label);
  return shift;
}

List<Map> createList(List data, int label) {
  List<Map> list = new List();
  if (label == 1) // with -All- label
    list.add({"Id": "0", "Name": "-All-"});
  else
    list.add({"Id": "0", "Name": "-Select-"});

  for (int i = 0; i < data.length; i++) {
    if (data[i]["archive"].toString() == '1') {
      Map tos = {
        "Name": data[i]["Name"].toString(),
        "Id": data[i]["Id"].toString()
      };
      list.add(tos);
    }
  }
  return list;
}

/*Future<List<Map>> getList(int label, String val) async {
  List<Map> datalist = new List();
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'otherMaster?orgid=$orgid');
  final response = await http.get(path_ubiattendance + 'otherMaster?orgid=$orgid');
  List data = json.decode(response.body.toString());
  if(val.contains('EmployeeStatus')) {
    datalist = createStatusList(data, label);
    print("EmployeeStatus");
    print(datalist);
  } else if(val.contains('Gender')) {
    print("Gender");
    print(datalist);
    datalist = createGenderList(data, label);
  }
  return datalist;
}*/

Future<List<Map>> getEmpStatusList(int label, int val) async {
  List<Map> datalist = new List();
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'empStatusMaster');
  final response = await http.get(path_ubiattendance + 'empStatusMaster');
  List data = json.decode(response.body.toString());
  datalist = createStatusList(data, label, val);
  return datalist;
}

List<Map> createStatusList(List data, int label, int val) {
  List<Map> list = new List();
  if (label == 1) // with -All- label
    list.add({"Id": "0", "Name": "-All-"});
  else
    list.add({"Id": "0", "Name": "-Select-"});

  for (int i = 0; i < data.length; i++) {
    if (val == 1) {
      if (data[i]['DisplayName'] == 'On Job' || data[i]['DisplayName'] == 'Probation') {
        Map empsts = {
          "Id": data[i]["Id"].toString(),
          "Name": data[i]["DisplayName"].toString(),
          "ActualValue": data[i]["ActualValue"].toString(),
        };
        list.add(empsts);
      }
    }else{
      Map empsts = {
        "Id": data[i]["Id"].toString(),
        "Name": data[i]["DisplayName"].toString(),
        "ActualValue": data[i]["ActualValue"].toString(),
      };
      list.add(empsts);
    }
  }
  return list;
}

Future<List<Map>> getGenderList(int label) async {
  List<Map> datalist = new List();
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'genderMaster');
  final response = await http.get(path_ubiattendance + 'genderMaster');
  List data = json.decode(response.body.toString());
  datalist = createGenderList(data, label);
  return datalist;
}

List<Map> createGenderList(List data, int label) {
  List<Map> list = new List();
  if (label == 1) // with -All- label
    list.add({"Id": "0", "Name": "-All-"});
  else
    list.add({"Id": "0", "Name": "-Select-"});

  for (int i = 0; i < data.length; i++) {
    //if (data[i]['OtherType'] == 'Gender') {
      Map gender = {
        "Id": data[i]["Id"].toString(),
        "Name": data[i]["DisplayName"].toString(),
        "ActualValue": data[i]["ActualValue"].toString(),
      };
      list.add(gender);
    //}
  }
  return list;
}

Future<List<Map>> getNationalityList(int label) async {
  List<Map> datalist = new List();
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'NationalityMaster');
  final response = await http.get(path_ubiattendance + 'NationalityMaster');
  List data = json.decode(response.body.toString());
  datalist = createnationalityList(data, label);
  return datalist;
}

List<Map> createnationalityList(List data, int label) {
  List<Map> list = new List();
  if (label == 1) // with -All- label
    list.add({"Id": "0", "Name": "-All-"});
  else
    list.add({"Id": "0", "Name": "-Select-"});

  for (int i = 0; i < data.length; i++) {
    Map nationality = {
      "Id": data[i]["Id"].toString(),
      "Name": data[i]["Name"].toString(),
    };
    list.add(nationality);
  }
  return list;
}

Future<List<Map>> getGradeList(int label) async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'gradeMaster?orgid=$orgid');
  final response = await http.get(path_ubiattendance + 'gradeMaster?orgid=$orgid');
  List data = json.decode(response.body.toString());
  List<Map> shift = createGradeList(data, label);
  return shift;
}

List<Map> createGradeList(List data, int label) {
  List<Map> list = new List();
  if (label == 1) // with -All- label
    list.add({"Id": "0", "Name": "-All-"});
  else
    list.add({"Id": "0", "Name": "-Select-"});

  for (int i = 0; i < data.length; i++) {
    Map tos = {
      "Name": data[i]["Name"].toString(),
      "Id": data[i]["Id"].toString()
    };
    list.add(tos);
  }
  return list;
}

//*************************************************************************************************************************//

//*************************************************************************************************************************//
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
/////////////////////////DIVISION CODE STARTS FROM HERE////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
class Div {
  String id;
  String div;
  String status;
  Div({this.id, this.div, this.status});
}

Future<List<Map>> getDivForDropDown() async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  String orgdir = prefs.getString('organization') ?? '';
  print(path_ubiattendance + 'DivisionMaster?orgid=$orgdir');
  final response = await dio.post(path_ubiattendance + 'DivisionMaster?orgid=$orgdir');
  List data = json.decode(response.data.toString());
  print(data);
  List<Map> divList = createDivList(data);
  return divList;
}

List<Map> createDivList(List data) {
  List<Map> list = new List();
  for (int i = 0; i < data.length; i++) {
    Map tos={"Id":data[i]["Id"].toString(), "Name":data[i]["Name"].toString()};
    list.add(tos);
  }
  return list;
}

Future<List<Div>> getDivision(String divname) async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'DivisionMaster?orgid=$orgid');
  final response = await http.get(path_ubiattendance + 'DivisionMaster?orgid=$orgid');
  List responseJson = json.decode(response.body.toString());
  print("data");
  print(responseJson);
  List<Div> divList = createDivisionList(responseJson,divname);
  return divList;
}

List<Div> createDivisionList(List data, String divname) {
  List<Div> list = new List();
  if(divname.isNotEmpty) {
    for (int i = 0; i < data.length; i++) {
      String id = data[i]["Id"];
      String div = toBeginningOfSentenceCase(data[i]["Name"]);
      String status = data[i]["archive"] == '0' ? 'Active' : 'Inactive';
      Div divison = new Div(id: id, div: div, status: status);
      if(div.toLowerCase().contains(divname.toLowerCase()))
        list.add(divison);
    }
  }else{
    for (int i = 0; i < data.length; i++) {
      String id = data[i]["Id"];
      String div = toBeginningOfSentenceCase(data[i]["Name"]);
      String status = data[i]["archive"] == '0' ? 'Active' : 'Inactive';
      Div divison = new Div(id: id, div: div, status: status);
      list.add(divison);
    }
  }
  return list;
}


Future<String> updateDiv(String sts, String id) async {
  print( sts + "   " + id);
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  sts = sts.toString() == 'Active' ? '0' : '1';
  print(path_ubiattendance + 'UpdateDiv?uid=$empid&orgid=$orgdir&sts=$sts&id=$id');
  final response = await http.get(path_ubiattendance + 'UpdateDiv?uid=$empid&orgid=$orgdir&sts=$sts&id=$id');
  print(response.body.toString());
  return response.body.toString();
}
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
/////////////////////////DIVISION CODE ENDS HERE////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//*************************************************************************************************************************//

//*************************************************************************************************************************//
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////DEPARTMENT CODE STARTS FORM HERE////////////////////////
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
class Dept {
  String dept;
  String status;
  String id;
  Dept({this.dept, this.status, this.id});
}


Future<List<Dept>> getDepartments(String deptname) async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'DepartmentMaster?orgid=$orgid');
  final response = await http.get(path_ubiattendance + 'DepartmentMaster?orgid=$orgid');
  List responseJson = json.decode(response.body.toString());
  List<Dept> deptList = createDeptList(responseJson,deptname);
  return deptList;
}

List<Dept> createDeptList(List data,String deptname) {
  List<Dept> list = new List();
  if(deptname.isNotEmpty) {
    for (int i = 0; i < data.length; i++) {
      String dept = toBeginningOfSentenceCase(data[i]["Name"]);
      String status = data[i]["archive"] == '1' ? 'Active' : 'Inactive';
      String id = data[i]["Id"];
      Dept dpt = new Dept(dept: dept, status: status, id: id);
      if(dept.toLowerCase().contains(deptname.toLowerCase()))
        list.add(dpt);
    }
  }else{
    for (int i = 0; i < data.length; i++) {
      String dept = toBeginningOfSentenceCase(data[i]["Name"]);
      String status = data[i]["archive"] == '1' ? 'Active' : 'Inactive';
      String id = data[i]["Id"];
      Dept dpt = new Dept(dept: dept, status: status, id: id);
      list.add(dpt);
    }
  }
  return list;
}


Future<String> addDept(name, status) async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  status = status.toString() == 'Active' ? '1' : '0';
  final response = await http.get(path_ubiattendance +'addDept?uid=$empid&orgid=$orgdir&name=$name&sts=$status');
  return response.body.toString();
}

Future<String> updateDept(dept, sts, did) async {
  print(dept + "   " + sts + "   " + did);
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  sts = sts.toString() == 'Active' ? '1' : '0';
  print(path_ubiattendance + 'updateDept?uid=$empid&orgid=$orgdir&dept=$dept&sts=$sts&id=$did');
  final response = await http.get(path_ubiattendance + 'updateDept?uid=$empid&orgid=$orgdir&dept=$dept&sts=$sts&id=$did');
  print(response.body.toString());
  return response.body.toString();
}
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
/////////////////////////DEPARTMENT CODE ENDS HERE////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//*************************************************************************************************************************//

//*************************************************************************************************************************//
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
/////////////////////////DESIGNATION CODE STARTS FROM HERE////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
class Desg {
  String desg;
  String status;
  String id;
  List modulepermissions;
  Desg({this.desg, this.status, this.id, this.modulepermissions});
}


Future<List<Desg>> getDesignation(String desgname) async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'DesignationMaster?orgid=$orgid');
  final response = await http.get(path_ubiattendance + 'DesignationMaster?orgid=$orgid');
  List responseJson = json.decode(response.body.toString());
  List<Desg> desgList = createDesgList(responseJson,desgname);
  return desgList;
}

List<Desg> createDesgList(List data,String desgname) {
  List<Desg> list = new List();
  if(desgname.isNotEmpty) {
    for (int i = 0; i < data.length; i++) {
      String desg = toBeginningOfSentenceCase(data[i]["Name"]);
      String status = data[i]["archive"] == '1' ? 'Active' : 'Inactive';
      String id = data[i]["Id"];
      Desg dpt = new Desg(desg: desg, status: status, id: id);
      if(desg.toLowerCase().contains(desgname.toLowerCase()))
        list.add(dpt);
    }
  }else{
    for (int i = 0; i < data.length; i++) {
      String desg = toBeginningOfSentenceCase(data[i]["Name"]);
      String status = data[i]["archive"] == '1' ? 'Active' : 'Inactive';
      String id = data[i]["Id"];
      Desg dpt = new Desg(desg: desg, status: status, id: id);
      list.add(dpt);
    }
  }
  return list;
}


Future<String> addDesg(name, status) async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  status = status.toString() == 'Active' ? '1' : '0';
  final response = await http.get(path_ubiattendance + 'addDesg?uid=$empid&orgid=$orgdir&name=$name&sts=$status');
  return response.body.toString();
}


Future<String> updateDesg(desg, sts, did) async {
  print(desg + "   " + sts + "   " + did);
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  sts = sts.toString() == 'Active' ? '1' : '0';
  print(path_ubiattendance + 'updateDesg?uid=$empid&orgid=$orgdir&desg=$desg&sts=$sts&id=$did');
  final response = await http.get(path_ubiattendance + 'updateDesg?uid=$empid&orgid=$orgdir&desg=$desg&sts=$sts&id=$did');
  print(response.body.toString());
  return response.body.toString();
}
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
/////////////////////////DESIGNATION CODE ENDS HERE////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//*************************************************************************************************************************//

//*************************************************************************************************************************//
// /////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
/////////////////////////SHIFT CODE STARTS FORM HERE////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
class Shift {
  String Id;
  String Name;
  String TimeIn;
  String TimeOut;
  String Status;
  String Type;

  Shift({this.Id, this.Name, this.TimeIn, this.TimeOut, this.Status, this.Type});
}


Future<List<Shift>> getShifts(String shiftname) async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'shiftMaster?orgid=$orgid');
  final response = await http.get(path_ubiattendance + 'shiftMaster?orgid=$orgid');
  List responseJson = json.decode(response.body.toString());
  List<Shift> shiftList = createShiftList(responseJson,shiftname);
  return shiftList;
}

List<Shift> createShiftList(List data,String shiftname) {
  List<Shift> list = new List();
  if(shiftname.isNotEmpty) {
    for (int i = 0; i < data.length; i++) {
      String name = toBeginningOfSentenceCase(data[i]["Name"]);
      String timein = data[i]["TimeIn"];
      String timeout = data[i]["TimeOut"];
      String id = data[i]["Id"];
      String status = data[i]["archive"] == '0' ? 'Inactive' : 'Active';
      String type = data[i]["shifttype"] == '1' ? 'Single Date' : 'Multi Date';
      Shift shift = new Shift(
          Id: id,
          Name: name,
          TimeIn: timein,
          TimeOut: timeout,
          Status: status,
          Type: type);
      if(name.toLowerCase().contains(shiftname.toLowerCase()))
        list.add(shift);
    }
  }else{
    for (int i = 0; i < data.length; i++) {
      String name = toBeginningOfSentenceCase(data[i]["Name"]);
      String timein = data[i]["TimeIn"];
      String timeout = data[i]["TimeOut"];
      String id = data[i]["Id"];
      String status = data[i]["archive"] == '0' ? 'Inactive' : 'Active';
      String type = data[i]["shifttype"] == '1' ? 'Single Date' : 'Multi Date';
      Shift shift = new Shift(
          Id: id,
          Name: name,
          TimeIn: timein,
          TimeOut: timeout,
          Status: status,
          Type: type);
      list.add(shift);
    }
  }
  return list;
}


Future<int> createShift(name, type, from, to, from_b, to_b) async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  final response = await http.get(path_ubiattendance + 'addShift?name=$name&org_id=$orgdir&ti=$from&to=$to&tib=$from_b&tob=$to_b&sts=1&shifttype=$type');
  int res = int.parse(response.body);
  return res;
}


Future<String> updateShift(shift, sts, did) async {
  print(shift + "   " + sts + "   " + did);
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  sts = sts.toString() == 'Active' ? '1' : '0';
  print(path_ubiattendance + 'updateShift?uid=$empid&orgid=$orgdir&shift=$shift&sts=$sts&id=$did');
  final response = await http.get(path_ubiattendance + 'updateShift?uid=$empid&orgid=$orgdir&shift=$shift&sts=$sts&id=$did');
  print(response.body.toString());
  return response.body.toString();
}

// ///////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
/////////////////////////SHIFT CODE ENDS HERE/////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//*************************************************************************************************************************//

//*************************************************************************************************************************//
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
/////////////////////////Geofence CODE STARTS FROM HERE////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
class Geo{
  String id;
  String name;
  String status;
  Geo({this.id, this.name, this.status});

}

Future<List<Geo>> getGeofence(String geofence) async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'Geofence?orgid=$orgid');
  final response = await http.get(path_ubiattendance + 'Geofence?orgid=$orgid');
  List responseJson = json.decode(response.body.toString());
  print(response.body.toString());
  print(responseJson);
  List<Geo> gioList = createGeofenceList(responseJson,geofence);
  return gioList;
}

List<Geo> createGeofenceList(List data,String geofence) {
  List<Geo> list = new List();
  if(geofence.isNotEmpty) {
    for (int i = 0; i < data.length; i++) {
      String id = data[i]["Id"];
      String name = toBeginningOfSentenceCase(data[i]["Name"]);
      String status = data[i]["archive"] == '1' ? 'Active' : 'Inactive';
      Geo giofence = new Geo(id: id, name: name, status: status);
      if(name.toLowerCase().contains(geofence.toLowerCase()))
        list.add(giofence);
    }
  }else{
    for (int i = 0; i < data.length; i++) {
      String id = data[i]["Id"];
      String name = toBeginningOfSentenceCase(data[i]["Name"]);
      String status = data[i]["archive"] == '1' ? 'Active' : 'Inactive';
      Geo giofence = new Geo(id: id, name: name, status: status);
      list.add(giofence);
    }
  }
  return list;
}


Future<String> UpdateGeo(String sts, String id) async {
  print( sts + "   " + id);
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  sts = sts.toString() == 'Active' ? '1' : '0';
  print(path_ubiattendance + 'UpdateGeo?uid=$empid&orgid=$orgdir&sts=$sts&id=$id');
  final response = await http.get(path_ubiattendance + 'UpdateGeo?uid=$empid&orgid=$orgdir&sts=$sts&id=$id');
  print(response.body.toString());
  return response.body.toString();
}
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
/////////////////////////Geofence CODE ENDS HERE////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//*************************************************************************************************************************//

//*************************************************************************************************************************//
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
/////////////////////////Holodays CODE STARTS FROM HERE////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
Future<List<Holi>> getHolidaysList(String holiday) async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance+'getHolidaysList?orgid=$orgid');
  Response response = await Dio().get(path_ubiattendance+'getHolidaysList?orgid=$orgid');
  print(json.decode(response.data.toString()));
  List data=json.decode(response.data.toString());
  List<Holi> holi = createlist(data,holiday);
  return holi;
}

List<Holi> createlist(List data,String holiday){
  List<Holi> holidaydata = new List();
  if(holiday.isNotEmpty) {
    for (int i = 0; i < data.length; i++) {
      String Name = toBeginningOfSentenceCase(data[i]['Name']);
      String DateFrom = data[i]['DateFrom'];
      String DateTo = data[i]['DateTo'];
      String Duration = data[i]['Duration'];
      Holi h = Holi(
        name: Name,
        DateFrom: DateFrom,
        DateTo: DateTo,
        Duration: Duration,
      );
      if(Name.toLowerCase().contains(holiday.toLowerCase()))
        holidaydata.add(h);
    }
  }else{
    for(int i=0; i<data.length; i++){
      String Name = toBeginningOfSentenceCase(data[i]['Name']);
      String DateFrom = data[i]['DateFrom'];
      String DateTo = data[i]['DateTo'];
      String Duration = data[i]['Duration'];
      Holi h = Holi(
        name:Name,
        DateFrom:DateFrom,
        DateTo:DateTo,
        Duration:Duration,
      );
      holidaydata.add(h);
    }
  }
  return holidaydata;
}


Future<List<Map>> getLocForDropDown() async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  String orgdir = prefs.getString('organization') ?? '';
  print(path_ubiattendance + 'LocationMaster?orgid=$orgdir');
  final response = await dio.post(path_ubiattendance + 'LocationMaster?orgid=$orgdir');
  List data = json.decode(response.data.toString());
  print(data);
  List<Map> leavetype = createLocList(data);
  return leavetype;
}

List<Map> createLocList(List data) {
  List<Map> list = new List();
  for (int i = 0; i < data.length; i++) {
    Map tos={"Id":data[i]["Id"].toString(), "Name":data[i]["Name"].toString()};
    list.add(tos);
  }
  return list;
}

addHoliday(String name,String from,String to,String description,String orAndsts,String div,String loc) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String empid = prefs.getString('empid') ?? '';
    String orgdir = prefs.getString('orgdir') ?? '';
    Dio dio = new Dio();
    print(path_ubiattendance+'addHoliday?name=$name&from=$from&to=$to&description=$description&div=$div&orandsts=$orAndsts&loc=$loc&empid=$empid&orgdir=$orgdir');
    Response response = await dio.post(path_ubiattendance+'addHoliday?name=$name&from=$from&to=$to&description=$description&div=$div&orandsts=$orAndsts&loc=$loc&empid=$empid&orgdir=$orgdir');
    print("response");
    print(response.data.toString());
    final statusMap = response.data.toString();
    print(statusMap.contains("false"));
    if (statusMap.contains("false")) {
      return "false";
    } else if (statusMap.contains("alreadyexist")) {
      return "alreadyexist";
    } else{
      return "true";
    }
  } catch (e) {
    print("Exception" + e.toString());
  }
}

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
/////////////////////////Holoday CODE ENDS HERE////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//*************************************************************************************************************************//

//*************************************************************************************************************************//
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
/////////////////////////* EMPLOYEE CODE STARTS FROM HERE *////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
class Emp {
  String Id;
  String Profile;
  String EmpCode;
  String Name;
  String FName;
  String LName;
  String DOB;
  String Nationality;
  String MaritalSts;
  String Religion;
  String BloodG;
  String DOC;
  String DOJ;
  String Gender;
  String ReportingTo;
  String DivisionId;
  String Division;
  String DepartmentId;
  String Department;
  String DesignationId;
  String Designation;
  String LocationId;
  String Location;
  String ShiftId;
  String Shift;
  String EmpSts;
  String Grade;
  String EmpType;
  String Email;
  String Mobile;
  String FatherName;
  String Status;
  String UserProfileId;
  String UserProfileName;
  String ProfileTypeId;
  String ProfileType;
  String Admin;
  String Password;
  Emp({
    this.Id,
    this.Profile,
    this.EmpCode,
    this.Name,
    this.FName,
    this.LName,
    this.DOB,
    this.Nationality,
    this.MaritalSts,
    this.Religion,
    this.BloodG,
    this.DOC,
    this.DOJ,
    this.Gender,
    this.ReportingTo,
    this.DivisionId,
    this.Division,
    this.DepartmentId,
    this.Department,
    this.DesignationId,
    this.Designation,
    this.LocationId,
    this.Location,
    this.ShiftId,
    this.Shift,
    this.EmpSts,
    this.Grade,
    this.EmpType,
    this.Email,
    this.Mobile,
    this.FatherName,
    this.Status,
    this.UserProfileId,
    this.UserProfileName,
    this.ProfileTypeId,
    this.ProfileType,
    this.Admin,
    this.Password
  });

  Emp.loading() {
    String name = "Loading...";
  }

  Emp.fromMap(Map map){
    //String name = map["name"].length > 20 ? data[i]["name"].substring(0, 15) + '..' : data[i]["name"];
    //String dept = map["Department"].length > 20 ? data[i]["Department"].substring(0, 15) + '..' : data[i]["Department"];
    //String desg = map["Designation"].length > 20 ? data[i]["Designation"].substring(0, 15) + '..' : data[i]["Designation"];
    String name = map["name"];
    String fname = map["fname"];
    String lname = map["lname"];
    String dept = map["Department"];
    String desg = map["Designation"];
    String shift = map["Shift"];
    String deptid = map["DepartmentId"];
    String desgid = map["DesignationId"];
    String shiftid = map["ShiftId"];
    String password = map["Password"];
    String status = map["archive"] == '1' ? 'Active' : 'Inactive';
    String id = map["Id"];
    String Email = map["Email"];
    String Mobile = map["Mobile"];
    String UserProfileId = map["UserProfileId"];
    String UserProfileName = map["UserProfileName"];
    String ProfileTypeId = map["ProfileTypeId"];
    String ProfileType = map["ProfileType"];
    String Profile = map["Profile"];
  }
}


Future getEmpCount(String from) async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('empid')?? '0';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int divhrsts =prefs.getInt('divhrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  print(path_ubiattendance + 'getEmpCount?from=$from&refno=$orgid&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&divhrsts=$divhrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final res = await http.get(path_ubiattendance + 'getEmpCount?from=$from&refno=$orgid&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&divhrsts=$divhrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  return ((json.decode(res.body)));
}

getEmployeeDetailById(id) async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'getUsersDetailById?refno=$orgid&empid=$id');
  final response = await http.get(path_ubiattendance + 'getUsersDetailById?refno=$orgid&empid=$id');
  print("json.decode(response.body.toString())");
  print(json.decode(response.body.toString()));
  return json.decode(response.body.toString());
}

Future<List<Emp>> getEmployee(offset, limit, empname, from) async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('empid')?? '0';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  print(path_ubiattendance + 'getUsersMobile?offset=$offset&limit=$limit&from=$from&refno=$orgid&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final response = await http.get(path_ubiattendance + 'getUsersMobile?offset=$offset&limit=$limit&from=$from&refno=$orgid&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  List responseJson = json.decode(response.body.toString());
  List<Emp> empList = createEmpList(responseJson,empname);
  return empList;
}

List<Emp> createEmpList(List data, String empname) {
  List<Emp> list = new List();
  if(empname !='' )
    for (int i = 0; i < data.length; i++) {
      String id = data[i]["Id"];
      String Profile = data[i]["Profile"];
      String empcode = data[i]["EmployeeCode"];
      String name = data[i]["name"];
      String fname = data[i]["fname"];
      String lname = data[i]["lname"];
      String dob = data[i]["DOB"];
      String nationality = data[i]["Nationality"];
      String maritalsts = data[i]["MaritalStatus"];
      String religion = data[i]["Religion"];
      String bloodg = data[i]["BloodGroup"];
      String gender = data[i]["Gender"];
      String reportingto = data[i]["ReportingTo"];
      String doc = data[i]["DOC"];
      String div = data[i]["Division"];
      String divid = data[i]["DivisionId"];
      String dept = data[i]["Department"];
      String deptid = data[i]["DepartmentId"];
      String desg = data[i]["Designation"];
      String desgid = data[i]["DesignationId"];
      String loc = data[i]["Location"];
      String locid = data[i]["LocationId"];
      String shift = data[i]["Shift"];
      String shiftid = data[i]["ShiftId"];
      String empsts = data[i]["EmployeeStatus"];
      String grade = data[i]["Grade"];
      String emptype = data[i]["EmploymentType"];
      String email = data[i]["Email"];
      String phone = data[i]["Mobile"];
      String father = data[i]["FatherName"];
      String doj = data[i]["DOJ"];
      String password = data[i]["Password"];
      String status = data[i]["archive"] == '1' ? 'Active' : 'Inactive';
      String UserProfileId = data[i]["UserProfileId"];
      String UserProfileName = data[i]["UserProfileName"];
      String ProfileTypeId = data[i]["ProfileTypeId"];
      String ProfileType = data[i]["ProfileType"];
      //String Admin = data[i]["Admin"] == '1' ? 'Mobile Admin' : 'User';

      Emp emp = new Emp(
          Id: id,
          Profile: Profile,
          EmpCode: empcode,
          Name: name,
          FName: fname,
          LName: lname,
          DOB: dob,
          Nationality: nationality,
          MaritalSts: maritalsts,
          Religion: religion,
          BloodG: bloodg,
          Gender: gender,
          ReportingTo: reportingto,
          Division: div,
          DivisionId: divid,
          Department: dept,
          DepartmentId: deptid,
          Designation: desg,
          DesignationId: desgid,
          Location: loc,
          LocationId: locid,
          Shift: shift,
          ShiftId: shiftid,
          EmpSts: empsts,
          Grade: grade,
          EmpType: emptype,
          Email: email,
          Mobile: phone,
          FatherName: father,
          DOJ: doj,
          Password: password,
          Status: status,
          UserProfileId: UserProfileId,
          UserProfileName: UserProfileName,
          ProfileTypeId: ProfileTypeId,
          ProfileType: ProfileType,
          //Admin: Admin,
      );
      if(name.toLowerCase().contains(empname.toLowerCase()))
        list.add(emp);
    }
  else
    for (int i = 0; i < data.length; i++) {
      String id = data[i]["Id"];
      String Profile = data[i]["Profile"];
      String empcode = data[i]["EmployeeCode"];
      String name = data[i]["name"];
      String fname = data[i]["fname"];
      String lname = data[i]["lname"];
      String dob = data[i]["DOB"];
      String nationality = data[i]["Nationality"];
      String maritalsts = data[i]["MaritalStatus"];
      String religion = data[i]["Religion"];
      String bloodg = data[i]["BloodGroup"];
      String gender = data[i]["Gender"];
      String reportingto = data[i]["ReportingTo"];
      String doc = data[i]["DOC"];
      String div = data[i]["Division"];
      String divid = data[i]["DivisionId"];
      String dept = data[i]["Department"];
      String deptid = data[i]["DepartmentId"];
      String desg = data[i]["Designation"];
      String desgid = data[i]["DesignationId"];
      String loc = data[i]["Location"];
      String locid = data[i]["LocationId"];
      String shift = data[i]["Shift"];
      String shiftid = data[i]["ShiftId"];
      String empsts = data[i]["EmployeeStatus"];
      String grade = data[i]["Grade"];
      String emptype = data[i]["EmploymentType"];
      String email = data[i]["Email"];
      String phone = data[i]["Mobile"];
      String father = data[i]["FatherName"];
      String doj = data[i]["DOJ"];
      String password = data[i]["Password"];
      String status = data[i]["archive"] == '1' ? 'Active' : 'Inactive';
      String UserProfileId = data[i]["UserProfileId"];
      String UserProfileName = data[i]["UserProfileName"];
      String ProfileTypeId = data[i]["ProfileTypeId"];
      String ProfileType = data[i]["ProfileType"];
      //String Admin = data[i]["Admin"] == '1' ? 'Mobile Admin' : 'User';

      Emp emp = new Emp(
        Id: id,
        Profile: Profile,
        EmpCode: empcode,
        Name: name,
        FName: fname,
        LName: lname,
        DOB: dob,
        Nationality: nationality,
        MaritalSts: maritalsts,
        Religion: religion,
        BloodG: bloodg,
        Gender: gender,
        ReportingTo: reportingto,
        Division: div,
        DivisionId: divid,
        Department: dept,
        DepartmentId: deptid,
        Designation: desg,
        DesignationId: desgid,
        Location: loc,
        LocationId: locid,
        Shift: shift,
        ShiftId: shiftid,
        EmpSts: empsts,
        Grade: grade,
        EmpType: emptype,
        Email: email,
        Mobile: phone,
        FatherName: father,
        DOJ: doj,
        Password: password,
        Status: status,
        UserProfileId: UserProfileId,
        UserProfileName: UserProfileName,
        ProfileTypeId: ProfileTypeId,
        ProfileType: ProfileType,
        //Admin: Admin,
      );
      list.add(emp);
    }
  return list;
}


Future<int> addEmployee(fname, lname, email, countryCode, countryId, contact, password,dept,desg,shift) async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  final response = await http.get(path_ubiattendance + 'registerEmp?uid=$empid&org_id=$orgdir&f_name=$fname&l_name=$lname&password=$password&username=$email&contact=$contact&country=$countryId&countrycode=$countryCode&admin=1&designation=$desg&department=$dept&shift=$shift');
  var res = json.decode(response.body);
  print("--------> Adding employee"+res.toString());
  return res['sts'];
}


Future<int> editEmployee(fname, lname, email, contact, div, dept, desg, loc, shift, empid) async {
  final prefs = await SharedPreferences.getInstance();
  String uid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance+'updateEmp?uid=$uid&org_id=$orgdir&f_name=$fname&l_name=$lname&username=$email&contact=$contact&admin=1&division=$div&designation=$desg&department=$dept&location=$loc&shift=$shift&empid=$empid');
  final response = await http.get(path_ubiattendance +'updateEmp?uid=$uid&org_id=$orgdir&f_name=$fname&l_name=$lname&username=$email&contact=$contact&admin=1&division=$div&designation=$desg&department=$dept&location=$loc&shift=$shift&empid=$empid');
  var res = json.decode(response.body);
  return res['sts'];
}

///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
////////////////////////////* EMPLOYEE CODE ENDS HERE *////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
//*************************************************************************************************************************//


//*************************************************************************************************************************//
// ////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////RESET/FORGOT PASSWORD SERVICE STARTS FORM HERE////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
Future<int> changeMyPassword(oldPass, newPass) async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  final response = await http.get(path_ubiattendance + 'changePassword?uid=$empid&refno=$orgdir&pwd=$oldPass&npwd=$newPass');
  print(path_ubiattendance + 'changePassword?uid=$empid&refno=$orgdir&pwd=$oldPass&npwd=$newPass');
  if(int.parse(response.body)==1){
    prefs.setString('usrpwd', newPass);
  }
  return int.parse(response.body);
}

Future<int> resetMyPassword(username) async {
  var url = path_ubiattendance+"resetPasswordLink";
  final response = await http.post(url, body: {
  "una":username});
  print(path+'resetPasswordLink?una=$username');
  return int.parse(response.body);
}
//'https://ubiattendance.ubihrm.com/index.php/services/resetPasswordLink?una='+una+'&refno='+refno,
// ///////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
/////////////////////////RESET/FORGOT PASSWORD END////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//*************************************************************************************************************************//


//*************************************************************************************************************************//
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/////////////////////////Get att chart data start///////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

//******************Today's Attn Chart Data****************//
Future<List<Map<String, String>>> getChartDataToday() async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  print(path_ubiattendance + 'getChartDataToday?refno=$orgdir&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final response = await http.get(path_ubiattendance + 'getChartDataToday?refno=$orgdir&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final data = json.decode(response.body);
  List<Map<String, String>> val = [
    {
      "present": data['present'].toString(),
      "absent": data['absent'].toString(),
      "late": data['late'].toString(),
      "early": data['early'].toString()
    }
  ];
  return val;
}
//******************Today's Attn Chart Data****************//


//******************Custom Date Attn Chart Data****************//
Future<List<Map<String, String>>> getChartDataCDate(date) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  print(path_ubiattendance + 'getChartDataCDate?refno=$orgdir&date=$date&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final response = await http.get(path_ubiattendance + 'getChartDataCDate?refno=$orgdir&date=$date&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final data = json.decode(response.body);
  List<Map<String, String>> val = [
    {
      "present": data['present'].toString(),
      "absent": data['absent'].toString(),
      "late": data['late'].toString(),
      "early": data['early'].toString()
    }
  ];
  return val;
}
//******************Custom Date Attn Chart Data****************//


//******************Yesterday's Attn Chart Data****************//
Future<List<Map<String, String>>> getChartDataYes() async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  print(path_ubiattendance + 'getChartDataYes?refno=$orgdir&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final response = await http.get(path_ubiattendance + 'getChartDataYes?refno=$orgdir&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final data = json.decode(response.body);
  List<Map<String, String>> val = [
    {
      "present": data['present'].toString(),
      "absent": data['absent'].toString(),
      "late": data['late'].toString(),
      "early": data['early'].toString()
    }
  ];
  return val;
}
//******************Yesterday's Attn Chart Data****************//


//******************Last 7/30 Days Attn Chart Data****************//
Future<List<Map<String, String>>> getChartDataLast(dys, month, emp) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  List<Map<String, String>> val = [];
  print(path_ubiattendance + 'getChartDataLast_7?refno=$orgdir&limit=$dys&month=$month&emp=$emp&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final response = await http.get(path_ubiattendance + 'getChartDataLast_7?refno=$orgdir&limit=$dys&month=$month&emp=$emp&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final data = json.decode(response.body);
  for (int i = 0; i < data.length; i++)
    val.add({
      "date": data[i]['event'].toString(),
      "total": data[i]['total'].toString()
    });
  return val;
}
//******************Last 7/30 Days Attn Chart Data****************//

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////Get chart data ends//////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//*************************************************************************************************************************//


//*************************************************************************************************************************//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////REPORTS SERVICES STARTS//////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
class Attn {
  String Id;
  String Name;
  String Shift;
  String Break;
  String Date;
  String FullDate;
  String TimeIn;
  String TimeOut;
  String EntryImage;
  String ExitImage;
  String CheckInLoc;
  String CheckOutLoc;
  String LatitIn;
  String LatitOut;
  String LongiIn;
  String LongiOut;
  String AttSts;
  String ShiftTime;
  String BreakTime;
  String TimeOffTime;
  String OverTime;
  String LateComingHours;
  String EarlyLeavingHours;
  String Device;
  String DeviceTimeOut;
  String TotalTime;

  Attn({
    this.Id,
    this.Name,
    this.Shift,
    this.Break,
    this.Date,
    this.FullDate,
    this.TimeIn,
    this.TimeOut,
    this.EntryImage,
    this.ExitImage,
    this.CheckInLoc,
    this.CheckOutLoc,
    this.LatitIn,
    this.LatitOut,
    this.LongiIn,
    this.LongiOut,
    this.AttSts,
    this.ShiftTime,
    this.BreakTime,
    this.TimeOffTime,
    this.OverTime,
    this.LateComingHours,
    this.EarlyLeavingHours,
    this.Device,
    this.DeviceTimeOut,
    this.TotalTime,
  });
}


//******************Todays Attn List Data**********************//
/*Future<List<Attn>> getTodaysAttn(listType) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  print(path_ubiattendance + 'getAttendances_new?refno=$orgdir&datafor=$listType&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final response = await http.get(
      path_ubiattendance + 'getAttendances_new?refno=$orgdir&datafor=$listType&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final res = json.decode(response.body);
  List responseJson;
  if (listType == 'present')
    responseJson = res['present'];
  else if (listType == 'absent')
    responseJson = res['absent'];
  else if (listType == 'latecomings')
    responseJson = res['lateComings'];
  else if (listType == 'earlyleavings') responseJson = res['earlyLeavings'];
  List<Attn> userList = createTodayEmpList(responseJson);
  return userList;
}*/
//********************Todays Attn List Data************************//
//******************Yesterday's Attn List Data**********************//
/*Future<List<Attn>> getYesAttn(listType) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;

  print(path_ubiattendance + 'getAttendances_yes?refno=$orgdir&datafor=$listType&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final response = await http.get(
      path_ubiattendance + 'getAttendances_yes?refno=$orgdir&datafor=$listType&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final res = json.decode(response.body);
  List responseJson;
  if (listType == 'present')
    responseJson = res['present'];
  else if (listType == 'absent')
    responseJson = res['absent'];
  else if (listType == 'latecomings')
    responseJson = res['lateComings'];
  else if (listType == 'earlyleavings') responseJson = res['earlyLeavings'];
  List<Attn> userList = createTodayEmpList(responseJson);
  return userList;
}*/
//******************Yesterday's Attn List Data*******************//


//******************Custom Date Attn List Data**********************//
Future<List<Attn>> getCDateAttn(listType, date) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  print(path_ubiattendance + 'getCDateAttendances_new?refno=$orgdir&date=$date&datafor=$listType&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final response = await http.get(
      path_ubiattendance + 'getCDateAttendances_new?refno=$orgdir&date=$date&datafor=$listType&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final res = json.decode(response.body);
  List responseJson;
  if (listType == 'present')
    responseJson = res['present'];
  else if (listType == 'absent')
    responseJson = res['absent'];
  else if (listType == 'latecomings')
    responseJson = res['lateComings'];
  else if (listType == 'earlyleavings')
    responseJson = res['earlyLeavings'];
  List<Attn> userList = createTodayEmpList(responseJson);
  return userList;
}
//******************Custom Date Attn List Data**********************//


//******************Custom Date Attn Departmentwise****************//
Future<List<Attn>> getCDateAttnDeptWise(String listType, String date, String dept, String emp) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;

  int dataaccess = prefs.getInt('dataaccess')??0;
  print(path_ubiattendance + 'getCDateAttnDeptWise_new?refno=$orgdir&date=$date&datafor=$listType&dept=$dept&emp=$emp&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final response = await http.get(
      path_ubiattendance + 'getCDateAttnDeptWise_new?refno=$orgdir&date=$date&datafor=$listType&dept=$dept&emp=$emp&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final res = json.decode(response.body);
  List responseJson;
  if (listType == 'present')
    responseJson = res['present'];
  else if (listType == 'absent')
    responseJson = res['absent'];
  else if (listType == 'latecomings')
    responseJson = res['lateComings'];
  else if (listType == 'earlyleavings')
    responseJson = res['earlyLeavings'];
  List<Attn> userList = createTodayEmpList(responseJson);
  return userList;
}
//******************Custom Date Attn Departmentwise****************//


//******************Custom Date Attn DesignationWise*******************//
Future<List<Attn>> getCDateAttnDesgWise(String listType, String date, String desg, String emp) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  print(path_ubiattendance + 'getCDateAttnDesgWise_new?refno=$orgdir&date=$date&datafor=$listType&desg=$desg&emp=$emp&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final response = await http.get(path_ubiattendance + 'getCDateAttnDesgWise_new?refno=$orgdir&date=$date&datafor=$listType&desg=$desg&emp=$emp&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final res = json.decode(response.body);
  print(res);
  List responseJson;
  if (listType == 'present')
    responseJson = res['present'];
  else if (listType == 'absent')
    responseJson = res['absent'];
  else if (listType == 'latecomings')
    responseJson = res['lateComings'];
  else if (listType == 'earlyleavings')
    responseJson = res['earlyLeavings'];
  List<Attn> userList = createTodayEmpList(responseJson);
  return userList;
}
//******************Custom Date Attn DesignationWise*******************//


List<Attn> createTodayEmpList(List data) {
  List<Attn> list = new List();
  for (int i = 0; i < data.length; i++) {
    String Id = data[i]["Id"].toString();
    String Name = data[i]["name"].toString();
    String TimeIn = data[i]["TimeIn"].toString();
    String TimeOut = data[i]["TimeOut"].toString() == '00:00' ? '-' : data[i]["TimeOut"].toString();
    String EntryImage = data[i]["EntryImage"].toString() == '' ? 'http://ubiattendance.ubihrm.com/assets/img/avatar.png' : data[i]["EntryImage"].toString();
    String ExitImage = data[i]["ExitImage"].toString() == '' ? 'http://ubiattendance.ubihrm.com/assets/img/avatar.png' : data[i]["ExitImage"].toString();
    String CheckInLoc = data[i]["checkInLoc"].toString();
    String CheckOutLoc = data[i]["CheckOutLoc"].toString();
    String LatitIn = data[i]["latit_in"].toString();
    String LatitOut = data[i]["latit_out"].toString();
    String LongiIn = data[i]["longi_in"].toString();
    String LongiOut = data[i]["longi_out"].toString();
    Attn tos = new Attn(
        Id: Id,
        Name: Name,
        TimeIn: TimeIn,
        TimeOut: TimeOut,
        EntryImage: EntryImage,
        ExitImage: ExitImage,
        CheckInLoc: CheckInLoc,
        CheckOutLoc: CheckOutLoc,
        LatitIn: LatitIn,
        LatitOut: LatitOut,
        LongiIn: LongiIn,
        LongiOut: LongiOut);
    list.add(tos);
  }
  return list;
}


Future<List<Attn>> getAttnDataLast(String days, var month, String listType, String emp) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  final response = await http.get(path_ubiattendance + 'getAttnDataLast?refno=$orgdir&datafor=$listType&limit=$days&month=$month&emp=$emp&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  print(path_ubiattendance + 'getAttnDataLast?refno=$orgdir&datafor=$listType&limit=$days&month=$month&emp=$emp&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final res = json.decode(response.body.toString());
  List responseJson;responseJson = res['elist'];
  List<Attn> userList = createLastEmpList(responseJson);
  return userList;
}

List<Attn> createLastEmpList(List data) {
  data = data.reversed.toList();
  List<Attn> list = new List();
  for (int i = 0; i < data.length; i++) {
    String Name = '';
    String TimeIn = '';
    String TimeOut = '';
    String date = '';
    String ExitImage = '';
    String CheckInLoc = '';
    String CheckOutLoc = '';
    String LatitIn = '';
    String LatitOut = '';
    String LongiIn = '';
    String LongiOut = '';
    if (data[i].length != 0) {
      for (int j = 0; j < data[i].length; j++) {
        Name = data[i][j]["name"].toString();
        TimeIn = data[i][j]["TimeIn"].toString() == '00:00:00'||data[i][j]["TimeIn"].toString() == '-'
            ? '-'
            : data[i][j]["TimeIn"].toString().substring(0, 5);
        TimeOut = data[i][j]["TimeOut"].toString() == '00:00:00' ||data[i][j]["TimeOut"].toString() == '-'
            ? '-'
            : data[i][j]["TimeOut"].toString().substring(0, 5);
        date = Formatdate1(data[i][j]["AttendanceDate"].toString());
        ExitImage = '';
        CheckInLoc = '';
        CheckOutLoc = '';
        LatitIn = '';
        LatitOut = '';
        LongiIn = '';
        LongiOut = '';

        Attn tos = new Attn(
            Name: Name,
            TimeIn: TimeIn,
            TimeOut: TimeOut,
            EntryImage: date,
            ExitImage: ExitImage,
            CheckInLoc: CheckInLoc,
            CheckOutLoc: CheckOutLoc,
            LatitIn: LatitIn,
            LatitOut: LatitOut,
            LongiIn: LongiIn,
            LongiOut: LongiOut);
        list.add(tos);
      }
    }
  }
  return list;
}


//******************Late Comer Attn Data****************//
class EmpList {
  String diff;
  String timeAct; // timein or timeout
  String name;
  String shift;
  String date;

  EmpList({this.diff, this.timeAct, this.name, this.shift, this.date});
}


Future<List<EmpList>> getLateEmpDataList(String date,String empname) async {
  if (date == '' || date == null) return null;
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? "";
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  print(path_ubiattendance + 'getlateComings?refno=$orgid&cdate=$date&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final response = await http.get(path_ubiattendance + 'getlateComings?refno=$orgid&cdate=$date&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  List responseJson = json.decode(response.body.toString());
  List<EmpList> list = createListLateComings(responseJson,empname);
  return list;
}

List<EmpList> createListLateComings(List data,String empname) {
  List<EmpList> list = new List();
  if(empname.isNotEmpty) {
    for (int i = 0; i < data.length; i++) {
      String diff = data[i]["lateby"];
      String timeAct = data[i]["timein"];
      String name = data[i]["name"];
      String shift = data[i]["shift"];
      String date = data[i]["date"];
      EmpList row = new EmpList(
          diff: diff,
          timeAct: timeAct,
          name: name,
          shift: shift,
          date: date);

      if (name.toLowerCase().contains(empname.toLowerCase()))
        list.add(row);
    }
  }else
    for (int i = 0; i < data.length; i++) {
      String diff = data[i]["lateby"];
      String timeAct = data[i]["timein"];
      String name = data[i]["name"];
      String shift = data[i]["shift"];
      String date = data[i]["date"];
      EmpList row = new EmpList(diff: diff,
          timeAct: timeAct,
          name: name,
          shift: shift,
          date: date);
      list.add(row);
    }
  return list;
}
//******************Late Comer Attn Data****************//


//******************Early Leaver Attn Data****************//
Future<List<EmpList>> getEarlyEmpDataList(String date, String empname) async {
  if (date == '' || date == null) return null;
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? "";
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;

  print(path_ubiattendance + 'getEarlyLeavings?refno=$orgid&cdate=$date&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final response = await http.get(
      path_ubiattendance + 'getEarlyLeavings?refno=$orgid&cdate=$date&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  List responseJson = json.decode(response.body.toString());
  List<EmpList> list = createListEarlyLeaving(responseJson,empname);
  return list;
}

List<EmpList> createListEarlyLeaving(List data, String empname) {
  List<EmpList> list = new List();
  if(empname.isNotEmpty) {
    for (int i = 0; i < data.length; i++) {
      String diff = data[i]["earlyby"];
      String timeAct = data[i]["timeout"];
      String name = data[i]["name"];
      String shift = data[i]["shift"];
      String date = data[i]["date"];
      EmpList row = new EmpList(
          diff: diff,
          timeAct: timeAct,
          name: name,
          shift: shift,
          date: date);
      if (name.toLowerCase().contains(empname.toLowerCase()))
        list.add(row);
    }
  }else{
    for (int i = 0; i < data.length; i++) {
      String diff = data[i]["earlyby"];
      String timeAct = data[i]["timeout"];
      String name = data[i]["name"];
      String shift = data[i]["shift"];
      String date = data[i]["date"];
      EmpList row = new EmpList(
          diff: diff,
          timeAct: timeAct,
          name: name,
          shift: shift,
          date: date);
      list.add(row);
    }
  }
  return list;
}
//******************Early Leaver Attn Data****************//


//******************Time Off Report Data****************//
class EmpListTimeOff {
  String diff;
  String to;
  String from;
  String name;
  String date;
  String sts;

  EmpListTimeOff({this.diff, this.to, this.from, this.name, this.date, this.sts});
}


Future<List<EmpListTimeOff>> getTimeOFfDataList(String date, String empname) async {
  if (date == '' || date == null) return null;
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  final response = await http.get(path_ubiattendance + 'getTimeoffList?fd=$date&to=$date&refno=$orgid&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  print(path_ubiattendance + 'getTimeoffList?fd=$date&to=$date&refno=$orgid&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  List responseJson = json.decode(response.body);
  List<EmpListTimeOff> list = createTimeOFfDataList(responseJson,empname);
  return list;
}

List<EmpListTimeOff> createTimeOFfDataList(List data,String empname) {
  List<EmpListTimeOff> list = new List();
  if(empname.isNotEmpty) {
    for (int i = 0; i < data.length; i++) {
      String diff = data[i]["diff"];
      String to = data[i]["TimeTo"];
      String from = data[i]["TimeFrom"];
      String name = data[i]["name"];
      String date = data[i]["tod"];
      String sts = data[i]["sts"];
      EmpListTimeOff row = new EmpListTimeOff(
          diff: diff,
          to: to,
          from: from,
          name: name,
          date: date,
          sts: sts
      );
      if(name.toLowerCase().contains(empname.toLowerCase()))
        list.add(row);
    }
  }else {
    for (int i = 0; i < data.length; i++) {
      String diff = data[i]["diff"];
      String to = data[i]["TimeTo"];
      String from = data[i]["TimeFrom"];
      String name = data[i]["name"];
      String date = data[i]["tod"];
      String sts = data[i]["sts"];
      EmpListTimeOff row = new EmpListTimeOff(
          diff: diff,
          to: to,
          from: from,
          name: name,
          date: date,
          sts: sts
      );
      list.add(row);
    }
  }
  return list;
}
//******************Time Off Report Data****************//


//******************Visit Report Data****************//
class Punch {
  String Id;
  String Emp;
  String client;
  String pi_time;
  String pi_loc;
  String po_time;
  String po_loc;
  String pi_longi;
  String pi_latit;
  String po_longi;
  String po_latit;
  String desc;
  String pi_img;
  String po_img;

  Punch({this.Id,this.Emp,this.client,this.pi_time,this.pi_loc,this.po_time,this.po_loc,this.pi_latit,this.pi_longi,this.po_latit,this.po_longi,this.desc,this.pi_img,this.po_img});
}


Future<List<Punch>> getVisitsDataList(date,empname) async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('employeeid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  print(path_ubiattendance + 'getPunchInfo?orgid=$orgdir&date=$date&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final response =
  await http.get(path_ubiattendance + 'getPunchInfo?orgid=$orgdir&date=$date&empid=$empid&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  List responseJson = json.decode(response.body.toString());
  List<Punch> userList = createUserList(responseJson,empname);
  return userList;
}
//******************Visit Report Data****************//


//******************Out Side Fence Report Data****************//
class OutsideAttendance {
  String Id;
  String empname;
  String timein;
  String timeout;
  String locationin;
  String locationout;
  String attdate;
  String latin;
  String lonin;
  String latout;
  String lonout;
  String outstatus;
  String instatus;
  String incolor;
  String outcolor;

  OutsideAttendance({
    this.Id,
    this.empname,
    this.timein,
    this.timeout,
    this.locationin,
    this.locationout,
    this.attdate,
    this.latin,
    this.lonin,
    this.latout,
    this.lonout,
    this.outstatus,
    this.instatus,
    this.incolor,
    this.outcolor,
  });
}


Future<List<OutsideAttendance>> getOutsidegeoReport(String date, String empname) async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  print(path_ubiattendance + 'getOutsidegeoReport?&uid=$empid&orgid=$orgdir&date=$date&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final response = await http.get(path_ubiattendance + 'getOutsidegeoReport?&uid=$empid&orgid=$orgdir&date=$date&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  List responseJson = json.decode(response.body.toString());
  List<OutsideAttendance> userList = createListOutsidefance(responseJson,empname);
  return userList;
}

List<OutsideAttendance> createListOutsidefance(List data,String emp) {
  List<OutsideAttendance> list = new List();
  if(emp.isNotEmpty) {
    for (int i = data.length - 1; i >= 0; i--) {
      String id = data[i]["id"];
      String timein = data[i]["timein"] == "00:00:00" ? '-'
          : data[i]["timein"].toString().substring(0, 5);
      String timeout = data[i]["timeout"] == "00:00:00" ? '-'
          : data[i]["timeout"].toString().substring(0, 5);
      String locationin = data[i]["locationin"];
      String locationout = data[i]["locationout"];
      String attdate = data[i]["attdate"];
      String empname = data[i]["empname"];
      String latin = data[i]["latin"];
      String lonin = data[i]["lonin"];
      String latout = data[i]["latout"];
      String lonout = data[i]["lonout"];
      String outstatus = data[i]["outstatus"];
      String instatus = data[i]["instatus"];
      String incolor = data[i]["incolor"];
      String outcolor = data[i]["outcolor"];

      OutsideAttendance Outsid = new OutsideAttendance(
        Id: id,
        empname: empname,
        timein: timein == '00:00' ? '-' : timein,
        timeout: timeout == '00:00' ? '-' : timeout,
        locationin: locationin.length > 40
            ? locationin.substring(0, 40) + '...'
            : locationin,
        locationout: locationout.length > 40 ? locationout.substring(0, 40) +
            '...' : locationout,
        attdate: attdate,
        latin: latin,
        lonin: lonin,
        latout: latout,
        lonout: lonout,
        outstatus: outstatus,
        instatus: instatus,
        incolor: incolor,
        outcolor: outcolor,
      );
      if(empname.toLowerCase().contains(emp.toLowerCase()))
       list.add(Outsid);
    }
  }else {
    for (int i = data.length - 1; i >= 0; i--) {
      String id = data[i]["id"];
      String timein = data[i]["timein"] == "00:00:00" ? '-'
          : data[i]["timein"].toString().substring(0, 5);
      String timeout = data[i]["timeout"] == "00:00:00" ? '-'
          : data[i]["timeout"].toString().substring(0, 5);
      String locationin = data[i]["locationin"];
      String locationout = data[i]["locationout"];
      String attdate = data[i]["attdate"];
      String empname = data[i]["empname"];
      String latin = data[i]["latin"];
      String lonin = data[i]["lonin"];
      String latout = data[i]["latout"];
      String lonout = data[i]["lonout"];
      String outstatus = data[i]["outstatus"];
      String instatus = data[i]["instatus"];
      String incolor = data[i]["incolor"];
      String outcolor = data[i]["outcolor"];

      OutsideAttendance Outsid = new OutsideAttendance(
        Id: id,
        empname: empname,
        timein: timein == '00:00' ? '-' : timein,
        timeout: timeout == '00:00' ? '-' : timeout,
        locationin: locationin.length > 40
            ? locationin.substring(0, 40) + '...'
            : locationin,
        locationout: locationout.length > 40 ? locationout.substring(0, 40) +
            '...' : locationout,
        attdate: attdate,
        latin: latin,
        lonin: lonin,
        latout: latout,
        lonout: lonout,
        outstatus: outstatus,
        instatus: instatus,
        incolor: incolor,
        outcolor: outcolor,
      );
      list.add(Outsid);
    }
  }
  return list;
}
//******************Out Side Fence Report Data****************//


//******************Employees List For Employee Wise Report****************//
Future<List<Attn>> getTotalEmployeesList(DateTime month, String empname) async{
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('employeeid') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  print(path_ubiattendance + 'getTotalEmployeesList?orgid=$orgid&empid=$empid&month=$month&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final response = await http.get(path_ubiattendance + 'getTotalEmployeesList?orgid=$orgid&empid=$empid&month=$month&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  List data = json.decode(response.body.toString());
  List<Attn> emp = createTotalEmployeesList(data,empname);
  return emp;
}

List<Attn> createTotalEmployeesList(List data,String empname) {
  List<Attn> list = new List();
  if(empname.isNotEmpty) {
    for (int i = 0; i < data.length; i++) {
      String Id = data[i]["id"].toString();
      String Name = data[i]["name"].toString();
      String Shift = data[i]["shift"].toString();
      String ShiftTime = data[i]["shifttime"].toString();
      String Break = data[i]["break"].toString();
      Attn tos = new Attn(
        Id: Id,
        Name: Name,
        Shift: Shift,
        ShiftTime: ShiftTime,
        Break: Break,
      );
      if(Name.toLowerCase().contains(empname.toLowerCase()))
        list.add(tos);
    }
  }else{
    for (int i = 0; i < data.length; i++) {
      String Id = data[i]["id"].toString();
      String Name = data[i]["name"].toString();
      String Shift = data[i]["shift"].toString();
      String ShiftTime = data[i]["shifttime"].toString();
      String Break = data[i]["break"].toString();
      Attn tos = new Attn(
        Id:Id,
        Name: Name,
        Shift:Shift,
        ShiftTime:ShiftTime,
        Break:Break,
      );
      list.add(tos);
    }
  }
  return list;
}
//******************Employees List For Employee Wise Report****************//


//******************Employee Wise Report Data****************//
Future<List<Attn>> getAttSummary(empid, month) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  final response = await http.get(path_ubiattendance+'getAttHistory?uid=$empid&refno=$orgdir&month=$month');
  print(path_ubiattendance+'getAttHistory?uid=$empid&refno=$orgdir&month=$month');
  List responseJson = json.decode(response.body.toString());
  List<Attn> userList = createAttList(responseJson);
  return userList;
}

List<Attn> createAttList(List data){
  List<Attn> list = new List();
  for (int i = 0; i < data.length; i++) {
    String Date = Formatdate1(data[i]["AttendanceDate"]);
    String FullDate = Formatdate2(data[i]["AttendanceDate"]);
    String TimeIn=data[i]["timein"]=="00:00:00"?'-':data[i]["timein"].toString();
    String TimeOut=data[i]["timeout"]=="00:00:00"?'-':data[i]["timeout"].toString();
    String AttSts=data[i]["status"];
    String ShiftTime=data[i]["totalshifttime"];
    String TotalTime=data[i]["totaltime"];
    String BreakTime=data[i]["breakTime"];
    String TimeOffTime=data[i]["timeoff"]=="00:00"?'':data[i]["timein"].toString();
    String LateComingHours=data[i]["latehrs"];
    String EarlyLeavingHours=data[i]["earlyhrs"];
    String OverTime=data[i]["overtime"];
    String Device=data[i]["device"];
    String DeviceTimeOut=data[i]["devicetimeout"];
    int id = 0;
    Attn att = new Attn(
      Date: Date,
      FullDate: FullDate,
      TimeIn:TimeIn,
      TimeOut:TimeOut,
      AttSts: AttSts,
      ShiftTime: ShiftTime,
      BreakTime: BreakTime,
      TimeOffTime: TimeOffTime,
      TotalTime: TotalTime,
      LateComingHours: LateComingHours,
      EarlyLeavingHours: EarlyLeavingHours,
      OverTime: OverTime,
      Device: Device,
      DeviceTimeOut: DeviceTimeOut,
    );
    list.add(att);
  }
  return list;
}
//******************Employee Wise Report Data****************//

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////REPORTS SERVICES ENDS////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//*************************************************************************************************************************//


///////////////////////////// Visit Summary Data /////////////////////////////////
Future<List<Punch>> getSummaryPunch(date,empname) async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'getPunchInfo?date=$date&uid=$empid&orgid=$orgdir');
  final response =await http.get(path_ubiattendance + 'getPunchInfo?date=$date&uid=$empid&orgid=$orgdir');

  List responseJson = json.decode(response.body.toString());
  List<Punch> userList = createUserList(responseJson,empname);
  return userList;
}


Future<List<Punch>> getTeamSummaryPunch(date,empname) async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  print(path_ubiattendance + 'getTeamPunchInfo?date=$date&uid=$empid&orgid=$orgdir&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final response =await http.get(path_ubiattendance + 'getTeamPunchInfo?date=$date&uid=$empid&orgid=$orgdir&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');

  List responseJson = json.decode(response.body.toString());
  List<Punch> userList = createUserList(responseJson,empname);
  return userList;
}

List<Punch> createUserList(List data, String empname) {
  List<Punch> list = new List();
  if(empname.isNotEmpty)
    for (int i = data.length-1; i >=0; i--) {
      String id = data[i]["Id"];
      String client = data[i]["client"];
      String pi_time = data[i]["time_in"]=="00:00:00"?'-':data[i]["time_in"].toString().substring(0,5);
      String pi_loc = data[i]["loc_in"];
      String po_time = data[i]["time_out"]=="00:00:00"?'-':data[i]["time_out"].toString().substring(0,5);
      String po_loc = data[i]["loc_out"];
      String emp = data[i]["emp"];
      String latit_in = data[i]["latit"];
      String longi_in = data[i]["longi"];
      String latit_out = data[i]["latit_in"];
      String longi_out = data[i]["longi_out"];
      String desc = data[i]["desc"];
      String pi_img=data[i]["checkin_img"].toString() == ''
          ? 'http://ubiattendance.ubihrm.com/assets/img/avatar.png'
          : data[i]["checkin_img"].toString();
      String po_img=data[i]["checkout_img"].toString() == ''
          ? 'http://ubiattendance.ubihrm.com/assets/img/avatar.png'
          : data[i]["checkout_img"].toString();
      Punch punches = new Punch(
          Id:id,
          Emp:emp,
          client: client,
          pi_time: pi_time,
          pi_loc: pi_loc.length>40?pi_loc.substring(0,40)+'...':pi_loc,
          po_time: po_time=='00:00'?'-':po_time,
          po_loc: po_loc.length>40?po_loc.substring(0,40)+'...':po_loc,
          pi_latit:latit_in,
          pi_longi:longi_in,
          po_latit:latit_out,
          po_longi:longi_out,
          desc:desc.length>40?desc.substring(0,40)+'...':desc,
          pi_img: pi_img,
          po_img: po_img
      );
      if(emp.toLowerCase().contains(empname.toLowerCase()))
        list.add(punches);
    }
  else
    for (int i = data.length-1; i >=0; i--) {
      String id = data[i]["Id"];
      String client = data[i]["client"];
      String pi_time = data[i]["time_in"]=="00:00:00"?'-':data[i]["time_in"].toString().substring(0,5);
      String pi_loc = data[i]["loc_in"];
      String po_time = data[i]["time_out"]=="00:00:00"?'-':data[i]["time_out"].toString().substring(0,5);
      String po_loc = data[i]["loc_out"];
      String emp = data[i]["emp"];
      String latit_in = data[i]["latit"];
      String longi_in = data[i]["longi"];
      String latit_out = data[i]["latit_in"];
      String longi_out = data[i]["longi_out"];
      String desc = data[i]["desc"];
      String pi_img=data[i]["checkin_img"].toString() == ''
          ? 'http://ubiattendance.ubihrm.com/assets/img/avatar.png'
          : data[i]["checkin_img"].toString();
      String po_img=data[i]["checkout_img"].toString() == ''
          ? 'http://ubiattendance.ubihrm.com/assets/img/avatar.png'
          : data[i]["checkout_img"].toString();
      Punch punches = new Punch(
          Id:id,
          Emp:emp,
          client: client,
          pi_time: pi_time,
          pi_loc: pi_loc.length>40?pi_loc.substring(0,40)+'...':pi_loc,
          po_time: po_time=='00:00'?'-':po_time,
          po_loc: po_loc.length>40?po_loc.substring(0,40)+'...':po_loc,
          pi_latit:latit_in,
          pi_longi:longi_in,
          po_latit:latit_out,
          po_longi:longi_out,
          desc:desc.length>40?desc.substring(0,40)+'...':desc,
          pi_img: pi_img,
          po_img: po_img
      );
      list.add(punches);
    }
  return list;
}
///////////////////////////// Visit Summary Data /////////////////////////////////


///////////////////////////////////Flexi Attendance Service Starts From Here/////////////////////////////////////
class FlexiAtt {
  String Id;
  String Emp;
  String client;
  String pi_time;
  String pi_loc;
  String po_time;
  String po_loc;
  String timeindate;
  String timeoutdate;
  String pi_longi;
  String pi_latit;
  String po_longi;
  String po_latit;
  String desc;
  String pi_img;
  String po_img;
  FlexiAtt({this.Id,this.Emp,this.client,this.pi_time,this.pi_loc,this.po_time,this.po_loc,this.timeindate,this.timeoutdate,this.pi_latit,this.pi_longi,this.po_latit,this.po_longi,this.desc,this.pi_img,this.po_img});
}

class Flexi{
  String fid;
  String sts;
  Flexi({this.fid,this.sts});
}


Future<List<FlexiAtt>> getFlexiDataList(date) async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('employeeid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'getFlexiInfo?uid=$empid&orgid=$orgdir&date=$date');
  final response = await http.get(path_ubiattendance + 'getFlexiInfo?uid=$empid&orgid=$orgdir&date=$date');
  List responseJson = json.decode(response.body.toString());
  List<FlexiAtt> userList = createUserListFlexi(responseJson);
  return userList;
}

List<FlexiAtt> createUserListFlexi(List data) {
  List<FlexiAtt> list = new List();
  for (int i = data.length-1; i >=0; i--) {
    String id = data[i]["Id"];
    String client = data[i]["client"];
    String pi_time = data[i]["time_in"]=="00:00:00"?'-':data[i]["time_in"].toString().substring(0,5);
    String pi_loc = data[i]["loc_in"];
    String po_time = data[i]["time_out"]=="00:00:00"?'-':data[i]["time_out"].toString().substring(0,5);
    String po_loc = data[i]["loc_out"];
    String timeindate = data[i]["date"];
    String timeoutdate = data[i]["timeout_date"];
    String emp = data[i]["emp"];
    String latit_in = data[i]["latit"];
    String longi_in = data[i]["longi"];
    String latit_out = data[i]["latit_in"];
    String longi_out = data[i]["longi_out"];
    String desc = data[i]["desc"];
    String pi_img=data[i]["checkin_img"].toString() == ''
        ? 'http://ubiattendance.ubihrm.com/assets/img/avatar.png'
        : data[i]["checkin_img"].toString();
    String po_img=data[i]["checkout_img"].toString() == ''
        ? 'http://ubiattendance.ubihrm.com/assets/img/avatar.png'
        : data[i]["checkout_img"].toString();

    FlexiAtt flexi = new FlexiAtt(
        Id:id,
        Emp:emp,
        client: client,
        pi_time: pi_time,
        pi_loc: pi_loc.length>40?pi_loc.substring(0,40)+'...':pi_loc,
        po_time: po_time=='00:00'?'-':po_time,
        po_loc: po_loc.length>40?po_loc.substring(0,40)+'...':po_loc,
        timeindate:timeindate,
        timeoutdate:timeoutdate,
        pi_latit:latit_in,
        pi_longi:longi_in,
        po_latit:latit_out,
        po_longi:longi_out,
        desc:desc.length>40?desc.substring(0,40)+'...':desc,
        pi_img: pi_img,
        po_img: po_img
    );
    list.add(flexi);
  }
  return list;
}


Future checkTimeinflexi() async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('employeeid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance+'getAttendanceesFlexi?empid=$empid');
  final res = await http.get(path_ubiattendance+'getAttendanceesFlexi?empid=$empid');
  List<Flexi> list = new List();
  String fid=((json.decode(res.body.toString()))['id']).toString();
  String sts=((json.decode(res.body.toString()))['sts']).toString();
  Flexi flexi = new Flexi(fid:fid, sts:sts);
  list.add(flexi);
  return list;
}


Future<List<FlexiAtt>> getFlexiDataListReport(date,emp) async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('employeeid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'getFlexiInfoReport?seid=$emp&uid=$empid&orgid=$orgdir&date=$date');
  final response = await http.get(path_ubiattendance + 'getFlexiInfoReport?seid=$emp&uid=$empid&orgid=$orgdir&date=$date');
  List responseJson = json.decode(response.body.toString());
  List<FlexiAtt> userList = createListFlexiReport(responseJson);
  return userList;
}

List<FlexiAtt> createListFlexiReport(List data) {
  List<FlexiAtt> list = new List();
  for (int i = data.length-1; i >=0; i--) {
    String id = data[i]["Id"];
    String client = data[i]["client"];
    String pi_time = data[i]["time_in"]=="00:00:00"?'-':data[i]["time_in"].toString().substring(0,5);
    String pi_loc = data[i]["loc_in"];
    String po_time = data[i]["time_out"]=="00:00:00"?'-':data[i]["time_out"].toString().substring(0,5);
    String po_loc = data[i]["loc_out"];
    String timeindate = data[i]["date"];
    String timeoutdate = data[i]["timeout_date"];
    String emp = data[i]["emp"];
    String latit_in = data[i]["latit"];
    String longi_in = data[i]["longi"];
    String latit_out = data[i]["latit_in"];
    String longi_out = data[i]["longi_out"];
    String desc = data[i]["desc"];
    String pi_img=data[i]["checkin_img"].toString() == ''
        ? 'http://ubiattendance.ubihrm.com/assets/img/avatar.png'
        : data[i]["checkin_img"].toString();
    String po_img=data[i]["checkout_img"].toString() == ''
        ? 'http://ubiattendance.ubihrm.com/assets/img/avatar.png'
        : data[i]["checkout_img"].toString();

    FlexiAtt flexi = new FlexiAtt(
        Id:id,
        Emp:emp,
        client: client,
        pi_time: pi_time,
        pi_loc: pi_loc.length>40?pi_loc.substring(0,40)+'...':pi_loc,
        po_time: po_time=='00:00'?'-':po_time,
        po_loc: po_loc.length>40?po_loc.substring(0,40)+'...':po_loc,
        timeindate:timeindate,
        timeoutdate:timeoutdate,
        pi_latit:latit_in,
        pi_longi:longi_in,
        po_latit:latit_out,
        po_longi:longi_out,
        desc:desc.length>40?desc.substring(0,40)+'...':desc,
        pi_img: pi_img,
        po_img: po_img
    );
    list.add(flexi);
  }
  return list;
}
///////////////////////////////////Flexi Attendance Service Ends Here/////////////////////////////////////

Future getDivCode() async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'getdivisioncode?orgid=$orgid');
  final res = await http.get(path_ubiattendance + 'getdivisioncode?orgid=$orgid');
  return((json.decode(res.body)));
}
Future getDeptCode() async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'getdepartmentcode?orgid=$orgid');
  final res = await http.get(path_ubiattendance + 'getdepartmentcode?orgid=$orgid');
  return((json.decode(res.body)));
}
Future getGradeCode() async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'getgradecode?orgid=$orgid');
  final res = await http.get(path_ubiattendance + 'getgradecode?orgid=$orgid');
  return((json.decode(res.body)));
}
Future getDesgCode() async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'getdesignationcode?orgid=$orgid');
  final res = await http.get(path_ubiattendance + 'getdesignationcode?orgid=$orgid');
  return((json.decode(res.body)));
}
Future getLocCode() async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path_ubiattendance + 'getlocationcode?orgid=$orgid');
  final res = await http.get(path_ubiattendance + 'getlocationcode?orgid=$orgid');
  return((json.decode(res.body)));
}
Future getEmpCode() async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  print(path + 'getempcode?orgid=$orgid');
  final res = await http.get(path + 'getempcode?orgid=$orgid');
  return((json.decode(res.body)));
}