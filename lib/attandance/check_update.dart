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
// this is testing
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/login_page.dart';
import 'package:ubihrm/services/attandance_services.dart';

import 'home.dart';

class CheckUpdate extends StatefulWidget {
  @override
  _CheckUpdate createState() => _CheckUpdate();
}

class _CheckUpdate extends State<CheckUpdate> {
  String mand_update;
  //final _formKey = GlobalKey<FormState>();
  int response;

  loader() {
    return new Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            //Image.asset('assets/spinner.gif', height: 50.0, width: 50.0),
            CircularProgressIndicator()
          ]
        ),
      ),
    );
  }

  void initState() {
    super.initState();
    getShared();
    checkMandUpdate().then((res){
      if(mounted) {
        setState(() {
          //print('**********************************'+res.toString()+'***********************************');
          mand_update=res;
        });
      }
    });
  }

  getShared() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      response = prefs.getInt('response') ?? 0;
      //print("Response "+response.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
        return new Scaffold(
          body:new Builder(
            builder: (BuildContext context) {
              return new Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height*0.4,),
                    Container(
                      width:MediaQuery.of(context).size.width*0.9,
                      child:Text('For better experience, please update the latest version.',textAlign: TextAlign.center,),
                      ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    Container(
                      width:MediaQuery.of(context).size.width*0.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          mand_update=='0'?FlatButton(
                            shape: Border.all(color: Colors.black54),
                            child:Text('Later',style:TextStyle(color: Colors.black54)),
                            onPressed: (){
                              print('clicked');
                              (response == 1) ?
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage()),
                              ) :
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            },
                          ):SizedBox(width: 0.0,),
                          RaisedButton(
                            color: Colors.orangeAccent,
                            child: Text('Update now',style: TextStyle(color: Colors.white),),
                            onPressed: (){
                              LaunchReview.launch(
                                  androidAppId: "com.ubihrm.ubihrm"
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
    }catch(EXP){
      return new Scaffold(
        body:new Builder(
          builder: (BuildContext context) {
            return new Center(
              child: loader(),
            );
          },
        ),
      );
    }

    /*return new Scaffold(
      body:new Builder(
        builder: (BuildContext context) {
          return new Center(
            child: RaisedButton(onPressed: null,child:Text('Update')),
          );
        },
      ),
    );*/

  }

}