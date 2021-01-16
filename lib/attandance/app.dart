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
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/home.dart';
import 'package:ubihrm/services/attandance_services.dart';

import 'check_update.dart';


class ShrineApp extends StatefulWidget {
  @override
  _ShrineAppState createState() => _ShrineAppState();
}

class _ShrineAppState extends State<ShrineApp> {
  String streamlocationaddr="";
  String lat="";
  String long="";
  int response;
  int responsestate;
  String cur_ver='1.0.9',new_ver='1.0.9';
  String updatestatus;

  @override
  void initState() {
    super.initState();
    getShared();
    checkNow().then((res){
      setState(() {
        new_ver=res;
      });
    });

    UpdateStatus().then((res){
      setState(() {
        updatestatus = res;
      });
    });
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
    );
  }
}


