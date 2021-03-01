// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/home.dart';
import 'package:ubihrm/login_page.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/services/services.dart';
import 'check_update.dart';


class ShrineApp extends StatefulWidget {
  @override
  _ShrineAppState createState() => _ShrineAppState();
}

class _ShrineAppState extends State<ShrineApp> {
  static const platform = const MethodChannel('location.spoofing.check');
  String address="";
  String lat="";
  String long="";
  int response;
  int responsestate;
  String cur_ver='1.1.1', new_ver='1.1.1';
  String updatestatus;

  @override
  void initState() {
    super.initState();
    appVersion=cur_ver;
    getShared();
    checkNow().then((res){
      setState(() {
        new_ver=res;
        print("new_ver");
        print(new_ver);
      });
    });

    UpdateStatus().then((res){
      setState(() {
        updatestatus = res;
      });
    });
    platform.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "locationAndInternet":
        locationThreadUpdatedLocation = true;
        var long = call.arguments["longitude"].toString();
        var lat = call.arguments["latitude"].toString();
        assign_lat = double.parse(lat);
        assign_long = double.parse(long);
        address = await getAddressFromLati(lat, long);
        print("================================================>>>>>>>>>>>>>>>>"+address);
        globalstreamlocationaddr = address;
        print(call.arguments["mocked"].toString());

        getAreaStatus().then((res) {
          print('home dot dart');
          if (mounted) {
            setState(() {
              areaSts = res.toString();
              print('response'+res.toString());
              if (assignedAreaIds.isNotEmpty && perGeoFence=="1") {
                AbleTomarkAttendance = areaSts;
              }
            });
          }
        }).catchError((onError) {
          print('Exception occured in clling function.......');
          print(onError);
        });

        if(call.arguments["TimeSpoofed"].toString()=="Yes"){
          timeSpoofed=true;
        }
        break;

        return new Future.value("");
    }
  }

  getShared() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      response = prefs.getInt('response') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ubiHRM',
      home:((cur_ver == new_ver || new_ver=="error") || updatestatus=='0')?HomePageMain():CheckUpdate(),
      /*routes: {
        // When we navigate to the "/" route, build the FirstScreen Widget
        '/login': (context) => LoginPage(),
        // When we navigate to the "/second" route, build the SecondScreen Widget
        '/home': (context) => HomePageMain()

      },*/
    );
  }
}


