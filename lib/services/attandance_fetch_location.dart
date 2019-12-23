import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loc{
  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;

  Location _location = new Location();
  String error;
  PermissionGroup permission;

  var result;

  @override

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    try {
      this.permission = PermissionGroup.location;
      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      PermissionStatus permission = await PermissionHandler().checkPermissionStatus(this.permission);
      /*bool res = await PermissionHandler().shouldShowRequestPermissionRationale(this.permission);
      print("shaifali");
      print(res);*/
      //print("deeksha");
      print(permission);
      //print("deeksha");

      if (permission.toString()=='PermissionStatus.granted') {
        //print("sohan");
        return fetchlocation();
      }/*else if(!res){
        return "PermissionStatus.deniedNeverAsk";
      }*/else {
       // print("sohan-------------->>>");
        return requestPermission();
      }
    }catch(e){
      print(e.toString());
      return e.toString();
    }
  }

  /*requestPermission() async {
    final res  = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
    bool res1 = await PermissionHandler().shouldShowRequestPermissionRationale(PermissionGroup.contacts);
  //  print("permission status is " + res.toString());
//    print(res);
    if(res.toString()=="PermissionStatus.authorized"){
      return fetchlocation();
    }else if(res.toString()=="PermissionStatus.deniedNeverAsk"){
      //bool opensett = await SimplePermissions.openSettings();
      //print("this is open settings "+ opensett.toString());
      return "PermissionStatus.deniedNeverAsk";
    }else{
      return requestPermission();
    }
  }*/
  loginrequestPermission() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
    //print("prakarsh@@@@@@@@@@@@");
    print(permission);
    if(permission.toString()=='PermissionStatus.granted'){
      //print("prakarsh------------>>>");
      return;
    }else{
      //print("prakarsh");
      final permissions = await PermissionHandler().requestPermissions([PermissionGroup.location]);
      return;
    }
  }

  requestPermission() async {
    final permissions = await PermissionHandler().requestPermissions([this.permission]);
    //print("Shaifali***************");
    print(permissions);
    bool isShown = await PermissionHandler().shouldShowRequestPermissionRationale(this.permission);
    //print("shaifali---------->>>>>");
    print(isShown);
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(this.permission);
    //print("Shaifali+++++++++++++++");
    print(permission);

    //print("permission status is " + res.toString());
    /*print('location permission....');
    print(permissions);
    print(permission);
    print('location permission....');*/
    if (permission.toString() == "PermissionStatus.granted" || permission.toString() == "PermissionStatus.disabled") {
      return fetchlocation();
    } else if (!isShown) {
      //print("Shaifali Rathore");
      return "PermissionStatus.deniedNeverAsk";
    } else {
      return requestPermission();
    }
  }
  /*checkPermission() async {
    bool res = await PermissionHandler().shouldShowRequestPermissionRationale(PermissionGroup.contacts);
    print("permission is " + res.toString());
    return res;
  }*/

  checkPermission() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(this.permission);
    print("permission is " + permission.toString());
    return permission.toString();
  }

  fetchlatilongi() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      LocationData location;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        //print("Ruchi=================");
        location = await _location.getLocation();
        error = null;
        return location;
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          error = 'Permission denied';
        } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
          error = 'Permission denied - please ask the user to enable it from the app settings';
        }
        //print("Hellllllllllllllllllllo");
        location = null;
        return location;
      }
      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      //if (!mounted) return;
      // _startLocation = location;
      double latitude = _startLocation["latitude"];
      double longitude = _startLocation["longitude"];
      prefs.setString('latit', latitude.toString());
      prefs.setString('longi', longitude.toString());
      print(latitude);
      print(longitude);
      _location = null;
      location = null;
      final coordinates = new Coordinates(latitude, longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(
          coordinates);
      var first = addresses.first;
      return "${first.featureName} : ${first.addressLine}";
    }catch(e){
      //print("HIIIIIIIIIIIIIIIIIIIIIIII");
      print(e.toString());
      return null;
    }
  }

  fetchlocation() async {
    try {
      print("fetchlocation.....");

      /*final prefs = await SharedPreferences.getInstance();
      Map<String, double> location;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        location = await _location.getLocation();
        error = null;
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          error = 'Permission denied';
        } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
          error =
          'Permission denied - please ask the user to enable it from the app settings';
        }
        location = null;
      }
      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      //if (!mounted) return;
      _startLocation = location;
      double latitude = _startLocation["latitude"];
      double longitude = _startLocation["longitude"];
      prefs.setString('latit', latitude.toString());
      prefs.setString('longi', longitude.toString());
      print(latitude);
      print(longitude);
      _location = null;
      location = null;
      final coordinates = new Coordinates(latitude, longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(
          coordinates);
      var first = addresses.first;
      return "${first.featureName} : ${first.addressLine}";*/
      return "Fetching location, please wait a while... or refresh";
    }catch(e){
      print("catch fetchlocation.....");

      print(e.toString());
      return "Unable to fetch: Click below REFRESH link and make sure GPS is on to get location.";
    }
  }

  void handleDone(){
    print("done");
  }

}