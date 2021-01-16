import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:ubihrm/global.dart' as globals;
import 'package:ubihrm/global.dart';
import 'package:ubihrm/model/timeinout.dart';


class SaveImage{
  String base64Image;
  String base64Image1;

  Future<bool> saveTimeInOutImagePicker(MarkTime mk) async {
    try{
      File imagei = null;
      imageCache.clear();
      Dio dio = new Dio();
      String location = globals.globalstreamlocationaddr;
      String city = globals.globalcity;
      String lat = globals.assign_lat.toString();
      String long = globals.assign_long.toString();
      /*LocationData _currentLocation = globals.list[globals.list.length - 1];
      String lat = _currentLocation.latitude.toString();
      String long = _currentLocation.longitude.toString();*/

      if (globalogrperminfomap['attselfiests'] == "1") {
        imagei = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 400.0, maxHeight: 400.0);
        if (imagei!= null) {
          FormData formData = new FormData.from({
            "uid": mk.uid,
            "location": location,
            "aid": mk.aid,
            "act": mk.act,
            "shiftid": mk.shiftid,
            "refid": mk.refid,
            "latit": lat,
            "longi": long,
            "city": city,
            "file": new UploadFileInfo(imagei, "image.png"),
            "platform":'android',
            "appVersion": globals.appVersion,
            "geofence": globals.geoFenceStatus,
          });
          print("Mark attendance with image");
          print(path_ubiattendance +
              "saveImage?uid=${mk.uid}&location=$location&aid=${mk.aid}&act=${mk
                  .act}&shiftid=${mk.shiftid}&refid=${mk
                  .refid}&latit=$lat&longi=$long&city=$city&file=$imagei&platform=android&appVersion=${globals.appVersion}&geofence=${globals.geoFenceStatus}");
          print("Mark attendance with image");
          Response<String> response1 = await dio.post(path_ubiattendance + "saveImage", data: formData);
          print("response1.toString()");
          print(response1.toString());
          imagei.deleteSync();
          imageCache.clear();
          Map MarkAttMap = json.decode(response1.data);
          print(MarkAttMap.toString());
          print("MarkAttMap");
          print(MarkAttMap["status"].toString());
          if (MarkAttMap["status"] == 1 || MarkAttMap["status"] == 2) {
            print("MarkAttMap1");
            print(MarkAttMap["status"].toString());
            return true;
          }else {
            print("MarkAttMap2");
            print(MarkAttMap["status"].toString());
            return false;
          }
        } else {
          print("In else part");
          return false;
        }
      }else{
        FormData formData = new FormData.from({
          "uid": mk.uid,
          "location": location,
          "aid": mk.aid,
          "act": mk.act,
          "shiftid": mk.shiftid,
          "refid": mk.refid,
          "latit": lat,
          "longi": long,
          "city": city,
          "platform":'android',
          "appVersion": globals.appVersion,
          "geofence": globals.geoFenceStatus,
        });
        print("Mark attendance without image");
        print(path_ubiattendance + "saveImage?uid=${mk.uid}&location=$location&aid=${mk.aid}&act=${mk
            .act}&shiftid=${mk.shiftid}&refid=${mk
            .refid}&latit=$lat&longi=$long&city=$city&platform=android&appVersion=${globals.appVersion}&geofence=${globals.geoFenceStatus}");
        Response<String> response1 = await dio.post(path_ubiattendance + "saveImage", data: formData);
        print(response1.toString());
        Map MarkAttMap = json.decode(response1.data);
        print(MarkAttMap.toString());
        print("MarkAttMap");
        print(MarkAttMap["status"].toString());
        if (MarkAttMap["status"] == 1 || MarkAttMap["status"] == 2) {
          print("MarkAttMap1");
          print(MarkAttMap["status"]);
          return true;
        } else {
          print("MarkAttMap2");
          print(MarkAttMap["status"]);
          return false;
        }
      }
    } catch (e) {
      print(e.toString());
      print("ONCE AGAIN");
      return false;
    }
  }


  Future<bool> saveVisit(MarkVisit mk) async { // visit in function
    try{
      File imagei = null;
      imageCache.clear();
      Dio dio = new Dio();
      String location = globals.globalstreamlocationaddr;
      String lat = globals.assign_lat.toString();
      String long = globals.assign_long.toString();
      /*LocationData _currentLocation = globals.list[globals.list.length - 1];
      String lat = _currentLocation.latitude.toString();
      String long = _currentLocation.longitude.toString();*/

      if (globalogrperminfomap['visitselfiests'] == "1") {
        imagei = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 350.0, maxHeight: 350.0);
        if (imagei != null ) {
          FormData formData = new FormData.from({
            "uid": mk.uid,
            "location": location,
            "cid": mk.cid,
            "refid": mk.refid,
            "latit": lat,
            "longi": long,
            "file": new UploadFileInfo(imagei, "image.png"),
          });
          print("Visit in with image");
          print(path_ubiattendance + "saveVisit?uid=${mk.uid}&location=$location&cid=${mk.cid}&refid=${mk.refid}&latit=$lat&longi=$long&file=$imagei");
          Response<String> response1;
          try {
            print("Shaifali Rathore");
            response1 = await dio.post(path_ubiattendance + "saveVisit", data: formData);
            print("response1.toString()");
            print(response1.toString());
          } catch (e) {
            print(e.toString());
          }
          imagei.deleteSync();
          imageCache.clear();
          Map MarkAttMap = json.decode(response1.data);
          print(MarkAttMap.toString());
          print("MarkAttMap");
          if (MarkAttMap["res"].toString() == '1')
            return true;
          else
            return false;
        } else {
          print("Hello");
          return false;
        }
      }else{ // if image is optional at the time of marking visit
        FormData formData = new FormData.from({
          "uid": mk.uid,
          "location": location,
          "cid": mk.cid,
          "refid": mk.refid,
          "latit": lat,
          "longi": long,
        });
        print("Visit in without image");
        print(path_ubiattendance + "saveVisit?uid=${mk.uid}&location=$location&cid=${mk.cid}&refid=${mk.refid}&latit=$lat&longi=$long");
        Response<String> response1;
        try {
          response1 = await dio.post(path_ubiattendance + "saveVisit", data: formData);
          print(response1.toString());
        } catch (e) {
          print(e.toString());
        }

        Map MarkAttMap = json.decode(response1.data);

        if (MarkAttMap["res"].toString() == '1')
          return true;
        else
          return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }


  Future<bool> saveVisitOut(empid,addr,visit_id,latit,longi,remark,refid) async { // visit in function
    try{
      Dio dio = new Dio();
      String location = globals.globalstreamlocationaddr;
      String lat = globals.assign_lat.toString();
      String long = globals.assign_long.toString();
      /*String lat = _currentLocation.latitude.toString();
      String long = _currentLocation.longitude.toString();*/
      File imagei = null;
      imageCache.clear();
      if (globalogrperminfomap['visitselfiests'] == "1") {
        imagei = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 350.0, maxHeight: 350.0);
        if (imagei != null) {
          FormData formData = new FormData.from({
            "empid": empid,
            "visit_id": visit_id,
            "addr": addr,
            "latit": latit,
            "longi": longi,
            "remark": remark,
            "refid": refid,
            "file": new UploadFileInfo(imagei, "image.png"),
          });
          print("Visit out with image");
          print(path_ubiattendance + "saveVisitOut?empid=$empid&visit_id=$visit_id&addr=$addr&latit=$latit&longi=$longi&remark=$remark&refid=$refid&file=$imagei");
          Response<String> response1;
          try {
            response1 = await dio.post(path_ubiattendance + "saveVisitOut", data: formData);
            print(response1.toString());
          } catch (e) {
            print(e.toString());
          }
          imagei.deleteSync();
          imageCache.clear();
          Map MarkAttMap = json.decode(response1.data);

          if (MarkAttMap["res"].toString() == '1')
            return true;
          else
            return false;
        } else {
          return false;
        }
      }else { // if image is notmandatory while marking punchout
        FormData formData = new FormData.from({
          "empid": empid,
          "visit_id": visit_id,
          "addr": addr,
          "latit": latit,
          "longi": longi,
          "remark": remark,
          "refid": refid
        });
        print("Visit out without image");
        print(path_ubiattendance + "saveVisitOut?empid=$empid&visit_id=$visit_id&addr=$addr&latit=$latit&longi=$longi&remark=$remark&refid=$refid");

        Response<String> response1;
        try {
          response1 = await dio.post(path_ubiattendance + "saveVisitOut", data: formData);
          print(response1.toString());
        } catch (e) {
          print(e.toString());
        }
        Map MarkAttMap = json.decode(response1.data);

        if (MarkAttMap["res"].toString() == '1')
          return true;
        else
          return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }


  Future<bool> saveFlexi(MarkVisit mk) async {
    try {
      Dio dio = new Dio();
      String location = globals.globalstreamlocationaddr;
      String lat = globals.assign_lat.toString();
      String long = globals.assign_long.toString();
      /*LocationData _currentLocation = globals.list[globals.list.length - 1];
      String lat = _currentLocation.latitude.toString();
      String long = _currentLocation.longitude.toString();*/

      File imagei = null;
      imageCache.clear();
      if (globalogrperminfomap['flexiselfiests'] == "1") {
        imagei = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 350.0, maxHeight: 350.0);
        if (imagei != null) {
          FormData formData = new FormData.from({
            "uid": mk.uid,
            "location": location,
            "cid": mk.cid,
            "refid": mk.refid,
            "latit": lat,
            "longi": long,
            "file": new UploadFileInfo(imagei, "image.png"),
          });
          print("Flexi time in with image");
          print(path_ubiattendance + "saveFlexi?uid=${mk.uid}&location=$location&cid=${mk.cid}&refid=${mk.refid}&latit=$lat&longi=$long&file=$imagei");

          Response<String> response1;
          try {
            response1 = await dio.post(path_ubiattendance + "saveFlexi", data: formData);
            print(response1.toString());
          } catch (e) {
            print(e.toString());
          }
          imagei.deleteSync();
          imageCache.clear();
          Map MarkAttMap = json.decode(response1.data);

          if (MarkAttMap["res"].toString() == '1')

            return true;
          else
            return false;
        } else {
          return false;
        }
      }else{
        FormData formData = new FormData.from({
          "uid": mk.uid,
          "location": location,
          "cid": mk.cid,
          "refid": mk.refid,
          "latit": lat,
          "longi": long,
        });
        print("Flexi time in without image");
        print(path_ubiattendance + "saveFlexi?uid=${mk.uid}&location=$location&cid=${mk.cid}&refid=${mk.refid}&latit=$lat&longi=$long");

        Response<String> response1;
        try {
          response1 = await dio.post(path_ubiattendance + "saveFlexi", data: formData);
          print(response1.toString());
        } catch (e) {
          print(e.toString());
        }

        Map MarkAttMap = json.decode(response1.data);

        if (MarkAttMap["res"].toString() == '1')
          return true;
        else
          return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }


  Future<bool> saveFlexiOut(empid, addr, visit_id, latit, longi,  refid) async {
    try {
      Dio dio = new Dio();
      String location = globals.globalstreamlocationaddr;
      String lat = globals.assign_lat.toString();
      String long = globals.assign_long.toString();
      /*String lat = _currentLocation.latitude.toString();
      String long = _currentLocation.longitude.toString();*/
      File imagei = null;
      imageCache.clear();
      if (globalogrperminfomap['flexiselfiests'] == "1") {
        imagei = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 350.0, maxHeight: 350.0);
        if (imagei != null) {
          FormData formData = new FormData.from({
            "empid": empid,
            "visit_id": visit_id,
            "addr": addr,
            "latit": latit,
            "longi": longi,
            "refid": refid,
            "file": new UploadFileInfo(imagei, "image.png"),
          });
          print("Flexi time out with image");
          print(path_ubiattendance + "saveFlexiOut?empid=$empid&visit_id=$visit_id&addr=$addr&latit=$latit&longi=$longi&refid=$refid&file=$imagei");
          Response<String> response1;
          try {
            response1 = await dio.post(path_ubiattendance + "saveFlexiOut", data: formData);
            print(response1.toString());
          } catch (e) {
            print(e.toString());
          }
          imagei.deleteSync();
          imageCache.clear();
          Map MarkAttMap = json.decode(response1.data);
          if (MarkAttMap["res"].toString() == '1')
            return true;
          else
            return false;
        } else {
          return false;
        }
      }else{
        FormData formData = new FormData.from({
          "empid": empid,
          "visit_id": visit_id,
          "addr": addr,
          "latit": latit,
          "longi": longi,
          "refid": refid,
        });
        print("Flexi time out without image");
        print(path_ubiattendance + "saveFlexiOut?empid=$empid&visit_id=$visit_id&addr=$addr&latit=$latit&longi=$longi&refid=$refid");
        Response<String> response1;
        try {
          response1 = await dio.post(path_ubiattendance + "saveFlexiOut", data: formData);
          print(response1.toString());
        } catch (e) {
          print(e.toString());
        }

        Map MarkAttMap = json.decode(response1.data);
        if (MarkAttMap["res"].toString() == '1')
          return true;
        else
          return false;
      }
    } catch (e) {
      print("e.toString()");
      print(e.toString());
      return false;
    }
  }

}