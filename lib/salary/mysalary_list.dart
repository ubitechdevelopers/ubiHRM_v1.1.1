// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/services/salary_services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';


// This app is a stateful, it tracks the user's current choice.
class SalarySummary extends StatefulWidget {
  @override
  _SalarySummary createState() => _SalarySummary();
}

class _SalarySummary extends State<SalarySummary> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var profileimage;
  bool showtabbar;
  String orgName="";

  bool _checkLoaded = true;
  int checkProcessing = 0;
  int _currentIndex = 1;
  bool _visible = true;
  bool _isButtonDisabled=false;
  String location_addr = "";
  String location_addr1 = "";
  String admin_sts='0';
  String act = "";
  String act1 = "";
  //int response;
  String fname = "",
      lname = "",
      empid = "",
      email = "",
      status = "",
      orgid = "",
      orgdir = "",
      sstatus = "",
      org_name = "",
      desination = "",
      profile = "",
      latit = "",
      longi = "";
  String lid = "";
  String shiftId = "";
  TextEditingController client_name,comments;
  Widget mainWidget= new Container(width: 0.0,height: 0.0,);
  @override
  void initState() {
    client_name = new TextEditingController();
    comments = new TextEditingController();
    super.initState();
    initPlatformState();
    getOrgName();


  }

  getOrgName() async
  {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
  }

  @override

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    //   response = prefs.getInt('response') ?? 0;
    admin_sts = prefs.getString('sstatus') ?? 0.toString();

    setState(() {
      fname = prefs.getString('fname') ?? '';
      lname = prefs.getString('lname') ?? '';
      empid = prefs.getString('empid') ?? '';
      email = prefs.getString('email') ?? '';
      status = prefs.getString('status') ?? '';
      orgid = prefs.getString('orgid') ?? '';
      orgdir = prefs.getString('orgdir') ?? '';
      sstatus = prefs.getString('sstatus') ?? '';
      org_name = prefs.getString('org_name') ?? '';
      desination = prefs.getString('desination') ?? '';
      profile = prefs.getString('profile') ?? '';
      lid = prefs.getString('lid') ?? "0";
      showtabbar=false;
      profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
      profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __){
        if (mounted) {
          setState(() {
            _checkLoaded = false;
          });
        }
      }));

    });
  }

  @override
  Widget build(BuildContext context) {
//    return (response == 0) ? new LoginPage() : getmainhomewidget();
    return  getmainhomewidget();
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value, textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  getmainhomewidget() {
    return RefreshIndicator(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor:scaffoldBackColor(),
        endDrawer: new AppDrawer(),
        appBar: new AppHeader(profileimage,showtabbar,orgName),
        bottomNavigationBar:  new HomeNavigation(),
        body:getMarkAttendanceWidgit(),
      ),
      onRefresh: () async {
        Completer<Null> completer = new Completer<Null>();
        await Future.delayed(Duration(seconds: 1)).then((onvalue) {
          completer.complete();
        });
        return completer.future;
      },
    );
  }

  checkalreadylogin() {


    //   if (response == 1) {
    return new IndexedStack(
      index: _currentIndex,
      children: <Widget>[
        //      underdevelopment(),
        //    mainbodyWidget(),
        //     underdevelopment()
      ],
    );
    /*  } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }*/
  }

  loader() {
    /* return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[

                  Text("Under development" + "ff",
                style: new TextStyle(fontSize: 30.0, color: Colors.teal),)
            ]),
      ),
    );*/
  }

  underdevelopment() {
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.android, color: appStartColor(),),
              Text("Under development",
                style: new TextStyle(fontSize: 30.0, color: appStartColor()),)
            ]),
      ),
    );
  }

  /*
  mainbodyWidget() {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15.0),
              getMarkAttendanceWidgit(),
              //getMarkAttendanceWidgit(),
            ],
          ),


        ],
      ),

    );
  }*/

  Widget getMarkAttendanceWidgit() {
    //  double h_width = MediaQuery.of(context).size.width*0.5; // screen's 50%
    //  double f_width = MediaQuery.of(context).size.width*1;


    return Stack(
      children: <Widget>[
        Container(
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            //width: MediaQuery.of(context).size.width*0.9,
            //height:MediaQuery.of(context).size.height*0.75,
            decoration: new ShapeDecoration(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
              color: Colors.white,
            ),
            child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //SizedBox(height: 5.0),
                  Text('My Salary', style: new TextStyle(fontSize: 22.0, color: appStartColor())),
                  SizedBox(height: 5.0),
                  new Divider(),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      //     SizedBox(width: MediaQuery.of(context).size.width*0.02),
                      new Expanded(
                        child:  Container(
                          width: MediaQuery.of(context).size.width*0.20,
                          child:Text('Month',style: TextStyle(color: Colors.orange[800],fontWeight:FontWeight.bold,fontSize: 16.0),),
                        ),),

                      //    SizedBox(height: 50.0,),
                      new Expanded(
                        child:  Container(
                          width: MediaQuery.of(context).size.width*0.20,
                          margin: EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
                          child:Text('Amount',  textAlign: TextAlign.right,style: TextStyle(color: Colors.orange[800],fontWeight:FontWeight.bold,fontSize: 16.0),),
                        ),),

                      //    SizedBox(height: 50.0,),
                      new Expanded(
                        child:  Container(
                          width: MediaQuery.of(context).size.width*0.30,
                          margin: EdgeInsets.only(left:11.0),
                          child:Text('Paid Days',  textAlign: TextAlign.right,style: TextStyle(color: Colors.orange[800],fontWeight:FontWeight.bold,fontSize: 16.0),),
                        ),),

                      new Expanded(
                        child:  Container(
                          width: MediaQuery.of(context).size.width*0.20,
                          margin: EdgeInsets.only(left:25.0),
                          child:Text('Action',style: TextStyle(color: Colors.orange[800],fontWeight:FontWeight.bold,fontSize: 16.0),),
                        ),),
                    ],
                  ),
                  new Divider(),

                  new Expanded(
                    child:  Container(
                      height: MediaQuery.of(context).size.height*.55,
                      width: MediaQuery.of(context).size.width*.99,
                      //padding: EdgeInsets.only(bottom: 15.0),
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Salary>>(
                        future: getsalarySummary(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0){
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {

                                    return new Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[

                                              new Expanded(
                                                child: Container(
                                                    width: MediaQuery.of(context).size.width * 0.30,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        new Text(
                                                          snapshot.data[index].month.toString(),style: TextStyle(),),
                                                        /*  (snapshot.data[index].withdrawlsts && snapshot.data[index].ApprovalSts.toString()!='Withdrawn' && snapshot.data[index].ApprovalSts.toString()!="Rejected")?new Container(
                                                                height:18.5,
                                                                child:new  FlatButton(
                                                                  shape: Border.all(color: Colors.blue),
                                                                  padding: EdgeInsets.all(1.0),
                                                                  onPressed: () {
                                                                    confirmWithdrawl(snapshot.data[index].TimeOffId.toString());
                                                                  },
                                                                  child: Text("Withdraw",style: TextStyle(color: Colors.blue),),
                                                                )
                                                        ):Center(),*/
                                                      ],
                                                    )),),

                                              new Expanded(
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width * 0.25,
                                                  margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                                                  child:  Text(
                                                    snapshot.data[index].EmployeeCTC.toString()+" "+snapshot.data[index].Currency.toString(),style:TextStyle(),  textAlign: TextAlign.right,),
                                                ),),

                                              new Expanded(
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width * 0.17, margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                                                  child:  Text(
                                                    snapshot.data[index].paid_days.toString(),style:TextStyle(),  textAlign: TextAlign.right,),
                                                ),),
                                              new Expanded(
                                                child: Container(
                                                  width: MediaQuery.of(context) .size .width * 0.30,margin: EdgeInsets.only(left:30.0),
                                                  height: 28.0,
                                                  child: new OutlineButton(
                                                    onPressed: () async{
                                                      final prefs = await SharedPreferences.getInstance();
                                                      //String path1 = prefs.getString('path');
                                                      print(path+"viewpayslip/"+snapshot.data[index].id.toString()+"/1/"+orgdir+"/"+empid);
                                                      launchMap(path+"viewpayslip/"+snapshot.data[index].id.toString()+"/1/"+orgdir+"/"+empid);
                                                      //   launchMap(" https://ubiattendance.ubihrm.com/");
                                                    },
                                                    child: new Icon(
                                                      Icons.print,
                                                      size: 17.0,
                                                      color: appStartColor(),
                                                    ),
                                                    borderSide: BorderSide(color:  appStartColor()),
                                                    padding:EdgeInsets.all(3.0),
                                                    shape: new CircleBorder(),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          //SizedBox(width: 30.0,),
                                          Divider(color: Colors.black45,),
                                        ]);
                                  }
                              );
                            }else
                              return new Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width*1,
                                  color: appStartColor().withOpacity(0.1),
                                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                  child:Text("No Records",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                                ),
                              );
                          } else if (snapshot.hasError) {
                            return new Text("Unable to connect server");
                          }
                          return new Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width*1,
                              color: appStartColor().withOpacity(0.1),
                              padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                              child:Text("No Records",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                            ),
                          );
                          // By default, show a loading spinner
                          // return new Center(child: CircularProgressIndicator());
                          //return new Center(child: Text("No data found"),);
                        },
                      ),
                      //////////////////////////////////////////////////////////////////////---------------------------------
                    ),),

                ])
        ),



      ],
    );
  }


  launchMap(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print( 'Could not launch $url');
    }
  }

  getPunchPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('getPunchPrefs called: new lid- '+ prefs.getString('lid').toString());
    return prefs.getString('lid');
  }


/////////////////////futere method dor getting today's punched liist-start

/////////////////////futere method dor getting today's punched liist-close

}

