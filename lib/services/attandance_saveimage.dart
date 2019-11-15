import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/model/timeinout.dart';
import 'package:ubihrm/services/attandance_fetch_location.dart';
import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ubihrm/global.dart' as globals;



class SaveImage{
  String base64Image;
  String base64Image1;
  Future<bool> saveTimeInOut(File imagefile,MarkTime mk) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      String path_ubiattendance1 = prefs.getString('path_ubiattendance');
      File imagei = imagefile;
      imageCache.clear();
      //imagei = await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 200.0,maxHeight: 200.0);
      if(imagei!=null) {
        /*
      final tempDir = await getTemporaryDirectory();
      String path = tempDir.path;
      int rand = new Math.Random().nextInt(10000);
      im.Image image1 = im.decodeImage(imagei.readAsBytesSync());
      imagei.deleteSync();
      im.Image smallerImage = im.copyResize(image1, 500); // choose the size here, it will maintain aspect ratio
      File compressedImage = new File('$path/img_$rand.jpg')..writeAsBytesSync(im.encodeJpg(smallerImage, quality: 50));
    */
        //// sending this base64image string +to rest api
        Dio dio = new Dio();
        String location = globals.globalstreamlocationaddr;
       LocationData _currentLocation = globals.list[globals.list.length-1];
        String lat = _currentLocation.latitude.toString();
        String long = _currentLocation.longitude.toString();
  //      print("global Address: "+ location);
   //     print("global lat" + lat);
  //      print("global long" + long);
  //      print(mk.uid+" "+location+ " "+mk.aid+" "+mk.act+" "+mk.shiftid+ " " +mk.refid+" "+lat+" "+long);
        FormData formData = new FormData.from({
          "uid": mk.uid,
          "location": location,
          "aid": mk.aid,
          "act": mk.act,
          "shiftid": mk.shiftid,
          "refid": mk.refid,
          "latit": lat,
          "longi": long,
          "file": new UploadFileInfo(imagei, "image.png"),
        });
 //       print("5");
        Response<String> response1=await dio.post(path_ubiattendance1+"saveImage",data:formData);
        //Response<String> response1=await dio.post("https://ubiattendance.ubihrm.com/index.php/services/saveImage",data:formData);
        //Response<String> response1=await dio.post("http://192.168.0.200/ubiattendance/index.php/services/saveImage",data:formData);
        //Response<String> response1 = await dio.post("https://ubitech.ubihrm.com/services/saveImage", data: formData);
        imagei.deleteSync();
        imageCache.clear();
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print(MarkAttMap["status"].toString());
        if (MarkAttMap["status"] == 1 || MarkAttMap["status"] == 2)
          return true;
        else
          return false;
      }else{
        print("6");
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }


  Future<bool> saveTimeInOutImagePicker(MarkTime mk) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      String path_ubiattendance1 = prefs.getString('path_ubiattendance');
      File imagei = null;
      imageCache.clear();
      imagei = await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 200.0,maxHeight: 200.0);
      if(imagei!=null) {
        /*
      final tempDir = await getTemporaryDirectory();
      String path = tempDir.path;
      int rand = new Math.Random().nextInt(10000);
      im.Image image1 = im.decodeImage(imagei.readAsBytesSync());
      imagei.deleteSync();
      im.Image smallerImage = im.copyResize(image1, 500); // choose the size here, it will maintain aspect ratio
      File compressedImage = new File('$path/img_$rand.jpg')..writeAsBytesSync(im.encodeJpg(smallerImage, quality: 50));
    */
        //// sending this base64image string +to rest api
        Dio dio = new Dio();
        String location = globals.globalstreamlocationaddr;
       LocationData _currentLocation = globals.list[globals.list.length-1];
        String lat = _currentLocation.latitude.toString();
        String long = _currentLocation.longitude.toString();
    //    print("global Address: "+ location);
     //   print("global lat" + lat);
     //   print("global long" + long);
     //   print(mk.uid+" "+location+ " "+mk.aid+" "+mk.act+" "+mk.shiftid+ " " +mk.refid+" "+lat+" "+long);
        FormData formData = new FormData.from({
          "uid": mk.uid,
          "location": location,
          "aid": mk.aid,
          "act": mk.act,
          "shiftid": mk.shiftid,
          "refid": mk.refid,
          "latit": lat,
          "longi": long,
          "file": new UploadFileInfo(imagei, "image.png"),
        });
    //    print("5");
        Response<String> response1=await dio.post(path_ubiattendance1+"saveImage",data:formData);
        //Response<String> response1=await dio.post("https://ubiattendance.ubihrm.com/index.php/services/saveImage",data:formData);
        //Response<String> response1=await dio.post("http://192.168.0.200/ubiattendance/index.php/services/saveImage",data:formData);
        //Response<String> response1 = await dio.post("https://ubitech.ubihrm.com/services/saveImage", data: formData);
        imagei.deleteSync();
        imageCache.clear();
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print("AAAAAA---->");
        print(MarkAttMap["status"].toString());
        print("AAAAAA---->");
        if (MarkAttMap["status"] == 1 || MarkAttMap["status"] == 2)
          return true;
        else
          return false;
      }else{
        print("BBBB---->");
        print("6");
        print("BBBB---->");
        return false;
      }
    } catch (e) {
      print("CCCC---->");
     print(e.toString());
      print("CCCC---->");
      return false;
    }
  }

  Future<bool> saveTimeOutOpt(MarkTime mk,Attid) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      String path_ubiattendance1 = prefs.getString('path_ubiattendance');
      File imagei = null;
      imageCache.clear();
      imagei = await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 200.0,maxHeight: 200.0);
      if(imagei!=null) {
        /*
      final tempDir = await getTemporaryDirectory();
      String path = tempDir.path;
      int rand = new Math.Random().nextInt(10000);
      im.Image image1 = im.decodeImage(imagei.readAsBytesSync());
      imagei.deleteSync();
      im.Image smallerImage = im.copyResize(image1, 500); // choose the size here, it will maintain aspect ratio
      File compressedImage = new File('$path/img_$rand.jpg')..writeAsBytesSync(im.encodeJpg(smallerImage, quality: 50));
    */
        //// sending this base64image string +to rest api
        Dio dio = new Dio();
        String location = globals.globalstreamlocationaddr;
        LocationData  _currentLocation = globals.list[globals.list.length-1];
        String lat = _currentLocation.latitude.toString();
        String long = _currentLocation.longitude.toString();
        //    print("global Address: "+ location);
        //   print("global lat" + lat);
        //   print("global long" + long);
        //   print(mk.uid+" "+location+ " "+mk.aid+" "+mk.act+" "+mk.shiftid+ " " +mk.refid+" "+lat+" "+long);
        print(Attid);
        print("*******");
        FormData formData = new FormData.from({
          "uid": mk.uid,
          "location": location,
          "aid": mk.aid,
          "act": mk.act,
          "shiftid": mk.shiftid,
          "refid": mk.refid,
          "latit": lat,
          "longi": long,
          "Attid": Attid,
          "file": new UploadFileInfo(imagei, "image.png"),
        });
        //    print("5");
        Response<String> response1=await dio.post(path_ubiattendance1+"saveImagenew?Attid=$Attid",data:formData);
      //  print(await dio.post(globals.path_ubiattendance+"saveImagenew?Attid=$Attid",data:formData));

        //Response<String> response1=await dio.post("https://ubiattendance.ubihrm.com/index.php/services/saveImage",data:formData);
        //Response<String> response1=await dio.post("http://192.168.0.200/ubiattendance/index.php/services/saveImage",data:formData);
        //Response<String> response1 = await dio.post("https://ubitech.ubihrm.com/services/saveImage", data: formData);
        imagei.deleteSync();
        imageCache.clear();
        /*getTempImageDirectory();*/
        print(response1.data.toString());
        Map MarkAttMap = json.decode(response1.data.toString());
        print("AAAAAA---->");
        print(MarkAttMap["status"].toString());
        print("AAAAAA---->");
        if (MarkAttMap["status"] == 1 || MarkAttMap["status"] == 2)
          return true;
        else
          return false;
      }else{
        print("BBBB---->");
        print("6");
        print("BBBB---->");
        return false;
      }
    } catch (e) {
      print("CCCC---->");
      print(e.toString());
      print("CCCC---->");
      return false;
    }
  }
  Future<bool> saveTimeInOut1(File imagefile, ) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      String path_ubiattendance1 = prefs.getString('path_ubiattendance');
      File imagei = imagefile;
      imageCache.clear();
      //imagei = await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 200.0,maxHeight: 200.0);
      if(imagei!=null) {
        Dio dio = new Dio();
        String location ="Dummy address";// globals.globalstreamlocationaddr;
        //Map<String, double> _currentLocation = globals.list[globals.list.length-1];
        String lat = "1.0.20";//_currentLocation["latitude"].toString();
        String long = "1.0.20";//_currentLocation["longitude"].toString();
        //print("global Address: "+ location);
        print("global lat" + lat);
        print("global long" + long);
        //print(mk.uid+" "+location+ " "+mk.aid+" "+mk.act+" "+mk.shiftid+ " " +mk.refid+" "+lat+" "+long);
        FormData formData = new FormData.from({
          "uid": 4140,
          "location": location,
          "aid": 0,
          "act": "TimeIn",
          "shiftid": 48,
          "refid": 10,
          "latit": lat,
          "longi": long,
          "file": new UploadFileInfo(imagei, "image.png"),
        });
        print("5");
        Response<String> response1=await dio.post(path_ubiattendance1+"saveImage",data:formData);
        //Response<String> response1=await dio.post("https://ubiattendance.ubihrm.com/index.php/services/saveImage",data:formData);
        //Response<String> response1=await dio.post("http://192.168.0.200/ubiattendance/index.php/services/saveImage",data:formData);
        //Response<String> response1 = await dio.post("https://ubitech.ubihrm.com/services/saveImage", data: formData);
        imagei.deleteSync();
        imageCache.clear();
        /* getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print(MarkAttMap["status"].toString());
        if (MarkAttMap["status"] == 1 || MarkAttMap["status"] == 2)
          return true;
        else
          return false;
      }else{
        print("6");
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }



  Future<bool> saveTimeInOutQR(MarkTime mk) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      String path_ubiattendance1 = prefs.getString('path_ubiattendance');
      File imagei = null;
      imageCache.clear();

      imagei = await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 200.0,maxHeight: 200.0);

      if(imagei!=null) {
        /*
      final tempDir = await getTemporaryDirectory();
      String path = tempDir.path;
      int rand = new Math.Random().nextInt(10000);
      im.Image image1 = im.decodeImage(imagei.readAsBytesSync());
      imagei.deleteSync();
      im.Image smallerImage = im.copyResize(image1, 500); // choose the size here, it will maintain aspect ratio
      File compressedImage = new File('$path/img_$rand.jpg')..writeAsBytesSync(im.encodeJpg(smallerImage, quality: 50));
    */
        //// sending this base64image string +to rest api
        Dio dio = new Dio();
        print(mk.uid);
        print(mk.location);
        print(mk.aid);
        print(mk.act);
        print(mk.shiftid);
        print(mk.refid);
        print(mk.latit);
        print(mk.longi);
        print(imagei.path);
        FormData formData = new FormData.from({
          "uid": mk.uid,
          "location": mk.location,
          "aid": mk.aid,
          "act": mk.act,
          "shiftid": mk.shiftid,
          "refid": mk.refid,
          "latit": mk.latit,
          "longi": mk.longi,
          "file": new UploadFileInfo(imagei, "image.png"),
        });
        print("5");
        print(path_ubiattendance1+"saveImage");
        Response<String> response1=await dio.post(path_ubiattendance1+"saveImage",data:formData);
        //Response<String> response1=await dio.post("https://ubiattendance.ubihrm.com/index.php/services/saveImage",data:formData);
        //Response<String> response1=await dio.post("http://192.168.0.200/ubiattendance/index.php/services/saveImage",data:formData);
        //Response<String> response1 = await dio.post("https://ubitech.ubihrm.com/services/saveImage", data: formData);
        imagei.deleteSync();
        imageCache.clear();
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print(MarkAttMap["status"].toString());
        if (MarkAttMap["status"] == 1 || MarkAttMap["status"] == 2)
          return true;
        else
          return false;
      }else{
        print("6");
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

/* getTempImageDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    var imageDirectory = Directory(directory.path);

    print('The image directory ${imageDirectory.path} exists: ${imageDirectory.existsSync()}');

    if (imageDirectory.existsSync()) {
      imageDirectory.deleteSync(recursive: true);
      imageCache.clear();
      print("deleted");
    }


  }*/


  Future<bool> saveVisit(MarkVisit mk) async { // visit in function
    try{
      final prefs = await SharedPreferences.getInstance();
      String path_ubiattendance1 = prefs.getString('path_ubiattendance');
      File imagei = null;
      imageCache.clear();
      if(globals.visitImage==1) {
        imagei = await ImagePicker.pickImage(
            source: ImageSource.camera, maxWidth: 350.0, maxHeight: 350.0);
        if (imagei != null ) {
          //// sending this base64image string +to rest api
          Dio dio = new Dio();
          String location = globals.globalstreamlocationaddr;
          LocationData _currentLocation = globals.list[globals.list
              .length - 1];
          String lat = _currentLocation.latitude.toString();
          String long = _currentLocation.longitude.toString();
          /*print('-------------------------------');
        print(mk.uid+" "+mk.cid);
        print('-------------------------------');
        return false;*/
          FormData formData = new FormData.from({
            "uid": mk.uid,
            "location": location,
            "cid": mk.cid,
            "refid": mk.refid,
            "latit": lat,
            "longi": long,
            "file": new UploadFileInfo(imagei, "image.png"),
          });
          print("5");
          Response<String> response1;
          try {
            print('------------**');
            response1 = await dio.post(
                path_ubiattendance1 + "saveVisit", data: formData);
            print("----->save visit image* --->" + response1.toString());
          } catch (e) {
            print('------------*');
            print(e.toString());
            print('------------*');
          }
          imagei.deleteSync();
          imageCache.clear();
          /*getTempImageDirectory();*/
          Map MarkAttMap = json.decode(response1.data);
          print('------------1*');
          print(MarkAttMap["res"].toString());
          print('------------2*');
          if (MarkAttMap["res"].toString() == '1')
            return true;
          else
            return false;
        } else {
          print("6*");
          return false;
        }
      }else{ // if image is optional at the time of marking visit

        Dio dio = new Dio();
        String location = globals.globalstreamlocationaddr;
        LocationData _currentLocation = globals.list[globals.list
            .length - 1];
        String lat = _currentLocation.latitude.toString();
        String long = _currentLocation.longitude.toString();
        /*print('-------------------------------');
        print(mk.uid+" "+mk.cid);
        print('-------------------------------');
        return false;*/
        FormData formData = new FormData.from({
          "uid": mk.uid,
          "location": location,
          "cid": mk.cid,
          "refid": mk.refid,
          "latit": lat,
          "longi": long,
          //"file": new UploadFileInfo(imagei, "image.png"),
        });
        print("5*****");
        Response<String> response1;
        try {
          print('------------');
          response1 = await dio.post(
              path_ubiattendance1 + "saveVisit", data: formData);
          print("----->save visit image --->" + response1.toString());
        } catch (e) {
          print('------------');
          print(e.toString());
          print('------------');
        }

        Map MarkAttMap = json.decode(response1.data);
        print('------------1');
        print(MarkAttMap["res"].toString());
        print('------------2');
        if (MarkAttMap["res"].toString() == '1')
          return true;
        else
          return false;

      }
    } catch (e) {
      print('7');
      print("------->");
      print(e.toString());
      print("------->");

      return false;
    }
  }



  Future<bool> saveVisitOut(empid,addr,visit_id,latit,longi,remark,refid) async { // visit in function
    try{
      final prefs = await SharedPreferences.getInstance();
      String path_ubiattendance1 = prefs.getString('path_ubiattendance');
      File imagei = null;
      imageCache.clear();
      if(globals.visitImage==1) {
        imagei = await ImagePicker.pickImage(
            source: ImageSource.camera, maxWidth: 350.0, maxHeight: 350.0);
        if (imagei != null) {
          //// sending this base64image string +to rest api
          Dio dio = new Dio();
          String location = globals.globalstreamlocationaddr;
          LocationData _currentLocation = globals.list[globals.list
              .length - 1];
          String lat = _currentLocation.latitude.toString();
          String long = _currentLocation.longitude.toString();
          /*print('-------------------------------');
          print("****** empid "+empid+"-->  orgid"+refid+" *********");
          print('-------------------------------');*/
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
          print("5");

          Response<String> response1;
          try {
            print('------------visit out----11');
            response1 = await dio.post(
                path_ubiattendance1 + "saveVisitOut", data: formData);
          } catch (e) {
            print('------------visit out--1');
            print(e.toString());
            print('------------visit out--2');
          }
          imagei.deleteSync();
          imageCache.clear();
          /*getTempImageDirectory();*/
          Map MarkAttMap = json.decode(response1.data);
          print('visit out------------1');
          print(MarkAttMap["res"].toString());
          print('visit out------------2');
          if (MarkAttMap["res"].toString() == '1')
            return true;
          else
            return false;
        } else {
          print("6");
          return false;
        }
      }else { // if image is notmandatory while marking punchout
        Dio dio = new Dio();
        String location = globals.globalstreamlocationaddr;
        LocationData _currentLocation = globals.list[globals.list
            .length - 1];
        String lat = _currentLocation.latitude.toString();
        String long = _currentLocation.longitude.toString();
        FormData formData = new FormData.from({
          "empid": empid,
          "visit_id": visit_id,
          "addr": addr,
          "latit": latit,
          "longi": longi,
          "remark": remark,
          "refid": refid
        });
        print("5");
        Response<String> response1;
        try {
          print('------------visit out----11');
          response1 = await dio.post(
              path_ubiattendance1 + "saveVisitOut", data: formData);
        } catch (e) {
          print('------------visit out--1');
          print(e.toString());
          print('------------visit out--2');
        }
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print('visit out------------1');
        print(MarkAttMap["res"].toString());
        print('visit out------------2');
        if (MarkAttMap["res"].toString() == '1')
          return true;
        else
          return false;
      }
    } catch (e) {
      print('7');
      print(e.toString());
      return false;
    }
  }



  Future<bool> saveFlexi(MarkVisit mk) async {
    print('------------**v');
    // visit in function
    try {
      final prefs = await SharedPreferences.getInstance();
      String path_ubiattendance1 = prefs.getString('path_ubiattendance');
      print('------------**vv');
      File imagei = null;
      imageCache.clear();
      //   if (globals.FlexiImage != 1) {
      print('------------**vvxx');
      imagei = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 350.0, maxHeight: 350.0);
      if (imagei != null) {
        print('------------**vvxxbb');
        //// sending this base64image string +to rest api
        Dio dio = new Dio();
        String location = globals.globalstreamlocationaddr;
        LocationData _currentLocation = globals.list[globals.list.length - 1];
        String lat = _currentLocation.latitude.toString();
        String long = _currentLocation.longitude.toString();
        print('-------------------------------');
        print(mk.uid+" "+mk.cid);
        print('-------------------------------');
        //  return false;
        FormData formData = new FormData.from({
          "uid": mk.uid,
          "location": location,
          "cid": mk.cid,
          "refid": mk.refid,
          "latit": lat,
          "longi": long,
          "file": new UploadFileInfo(imagei, "image.png"),
        });
        print("5*");
        Response<String> response1;
        try {
          print('------------**');
          response1 =
          await dio.post(path_ubiattendance1 + "saveFlexi", data: formData);
          print("----->save visit image* --->" + response1.toString());
        } catch (e) {
          print('------------*');
          print(e.toString());
          print('------------*');
        }
        imagei.deleteSync();
        imageCache.clear();
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print('------------1*');
        print(MarkAttMap["res"].toString());
        print('------------2*');
        if (MarkAttMap["res"].toString() == '1')
          return true;
        else
          return false;
      } else {
        print("6*");
        return false;
      }

    } catch (e) {
      print('7--');
      print(e.toString());
      return false;
    }
  }




  Future<bool> saveFlexiOut(
      empid, addr, visit_id, latit, longi,  refid) async
  {
    // visit in function
    try {
      final prefs = await SharedPreferences.getInstance();
      String path_ubiattendance1 = prefs.getString('path_ubiattendance');
      File imagei = null;
      imageCache.clear();
      // if (globals.FlexiImage != 1) {
      imagei = await ImagePicker.pickImage(
          source: ImageSource.camera, maxWidth: 350.0, maxHeight: 350.0);
      print(imagei);
      if (imagei != null)
      {
        //// sending this base64image string +to rest api
        Dio dio = new Dio();
        String location = globals.globalstreamlocationaddr;
        LocationData _currentLocation =
        globals.list[globals.list.length - 1];
        String lat = _currentLocation.latitude.toString();
        String long = _currentLocation.longitude.toString();
        /*print('-------------------------------');
        print(mk.uid+" "+mk.cid);
        print('-------------------------------');
        return false;*/
        FormData formData = new FormData.from({
          "empid": empid,
          "visit_id": visit_id,
          "addr": addr,
          "latit": latit,
          "longi": longi,
          "refid": refid,
          "file": new UploadFileInfo(imagei, "image.png"),
        });
        print("5"+empid+"--"+visit_id+"--"+addr+"--"+latit+"--"+longi+"--"+refid+"--");
        Response<String> response1;
        try {
          print('------------visit out----11');
          //  print( await dio.post(globals.path + "saveFlexiOut", data: formData));
          response1 = await dio.post(path_ubiattendance1+"saveFlexiOut", data: formData);
          print(response1);
        } catch (e) {
          print('------------visit out--11');
          print(e.toString());
          print('------------visit out--2');
        }
        imagei.deleteSync();
        imageCache.clear();
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print('visit out------------1');
        print(MarkAttMap["res"].toString());
        print('visit out------------2');
        if (MarkAttMap["res"].toString() == '1')
          return true;
        else
          return false;
      } else {
        print("6");
        return false;
      }

    } catch (e) {
      print('7');
      print(e.toString());
      return false;
    }
  }





}