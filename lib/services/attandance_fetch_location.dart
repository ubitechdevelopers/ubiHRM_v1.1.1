import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
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
      perm.PermissionStatus permission = await PermissionHandler().checkPermissionStatus(this.permission);

      if (permission.toString()=='PermissionStatus.granted') {
        return fetchlocation();
      }else {
        return requestPermission();
      }
    }catch(e){
      print(e.toString());
      return e.toString();
    }
  }

  loginrequestPermission() async {
    perm.PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
    if(permission.toString()=='PermissionStatus.granted'){
      return;
    }else{
      final permissions = await PermissionHandler().requestPermissions([PermissionGroup.location]);
      return;
    }
  }

  requestPermission() async {
    final permissions = await PermissionHandler().requestPermissions([this.permission]);
    bool isShown = await PermissionHandler().shouldShowRequestPermissionRationale(this.permission);
    perm.PermissionStatus permission = await PermissionHandler().checkPermissionStatus(this.permission);
    if (permission.toString() == "PermissionStatus.granted" || permission.toString() == "PermissionStatus.disabled") {
      return fetchlocation();
    } else if (!isShown) {
      return "PermissionStatus.deniedNeverAsk";
    } else {
      return requestPermission();
    }
  }

  checkPermission() async {
    perm.PermissionStatus permission = await PermissionHandler().checkPermissionStatus(this.permission);
    return permission.toString();
  }

  fetchlatilongi() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      LocationData location;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        location = await _location.getLocation();
        error = null;
        return location;
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          error = 'Permission denied';
        } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
          error = 'Permission denied - please ask the user to enable it from the app settings';
        }
        location = null;
        return location;
      }
      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  fetchlocation() async {
    try {
      print("fetchlocation.....");
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