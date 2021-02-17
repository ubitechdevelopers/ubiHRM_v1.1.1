// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/model/model.dart' as TimeOffModal;
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/services/timeoff_services.dart';

import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
import 'timeoff_summary.dart';

// This app is a stateful, it tracks the user's current choice.
class TimeOffPage extends StatefulWidget {
  @override
  _TimeOffPageState createState() => _TimeOffPageState();
}

class _TimeOffPageState extends State<TimeOffPage> {
  bool isloading = false;
  bool isServiceCalling = false;
  final _dateController = TextEditingController();
  final _starttimeController = TextEditingController();
  final _endtimeController = TextEditingController();
  final _reasonController = TextEditingController();
  TimeOfDay starttime;
  TimeOfDay endtime;
  FocusNode textSecondFocusNode = new FocusNode();
  FocusNode textthirdFocusNode = new FocusNode();
  FocusNode textfourthFocusNode = new FocusNode();
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy");
  final timeFormat = DateFormat("H:mm");
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _defaultimage = new NetworkImage("http://ubiattendance.ubihrm.com/assets/img/avatar.png");
  var profileimage;
  bool showtabbar;
  String orgName="";
  bool _checkLoaded = true;
  bool _isButtonDisabled=false;
  int _currentIndex = 1;
  bool _visible = true;
  String location_addr="";
  String location_addr1="";
  String admin_sts='0';
  String act="";
  String act1="";
  int response;
  String fname="", lname="", empid="", email="", status="", orgid="", orgdir="", sstatus="", org_name="", desination="", profile,latit="",longi="";
  String aid="";
  String shiftId="";
  var time1;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getOrgName();
    _dateController.text=dateFormat.format(DateTime.now());
    _starttimeController.text=DateFormat.Hm().format(DateTime.now());
    _endtimeController.text=DateFormat.Hm().format(DateTime.now().add(Duration(minutes: 1)));
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
  }

  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    admin_sts = prefs.getString('sstatus') ?? '0';
    Home ho = new Home();
    act = await ho.checkTimeIn(empid, orgdir);
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
      showtabbar=false;
      profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);

      profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
        if (mounted) {
          setState(() {
            _checkLoaded = false;
          });
        }
      }));
      aid = prefs.getString('aid') ?? "";
      shiftId = prefs.getString('shiftId') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<bool> sendToTimeoffList() async{
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => TimeoffSummary()), (Route<dynamic> route) => false,
    );
    return false;
  }

  getmainhomewidget(){
    return WillPopScope(
      onWillPop: ()=> sendToTimeoffList(),
      child: RefreshIndicator(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor:scaffoldBackColor(),
            appBar: new AppHeader(profileimage,showtabbar,orgName),
            bottomNavigationBar:  new HomeNavigation(),
            endDrawer: new AppDrawer(),
            body: ModalProgressHUD(
                inAsyncCall: isServiceCalling,
                opacity: 0.15,
                progressIndicator: SizedBox(
                  child:new CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation(Colors.green),
                      strokeWidth: 5.0),
                  height: 40.0,
                  width: 40.0,
                ),
                child: getTimeoffWidgit()
            )
        ),
        onRefresh: () async {
          Completer<Null> completer = new Completer<Null>();
          await Future.delayed(Duration(seconds: 2)).then((onvalue) {
            setState(() {
              _dateController.clear();
              _starttimeController.clear();
              _endtimeController.clear();
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            });
            completer.complete();
          });
          return completer.future;
        },
      ),
    );
  }

  loader(){
    return new Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CircularProgressIndicator()
          ]
        ),
      ),
    );
  }

  underdevelopment(){
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.android,color: appStartColor(),),Text("Under development",style: new TextStyle(fontSize: 30.0,color: appStartColor()),)
            ]),
      ),
    );
  }

  Widget getTimeoffWidgit() {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          //width: MediaQuery.of(context).size.width*0.9,
          //    height: MediaQuery.of(context).size.height * 0.75,
          decoration: new ShapeDecoration(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            color: Colors.white,
          ),

          child:Form(
            key: _formKey,
            child: SafeArea(
              child: Column( children: <Widget>[
                Text('Request Time Off',
                    style: new TextStyle(fontSize: 22.0, color: appStartColor())),
                new Divider(color: Colors.black54,height: 1.5,),
                new Expanded(child: ListView(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            new Expanded(
                              child: DateTimeField(
                                format: dateFormat,
                                controller: _dateController,
                                readOnly: true,
                                onShowPicker: (context, currentValue) {
                                  print("current value1");
                                  print(currentValue);
                                  print(DateTime.now());
                                  return showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now().subtract(Duration(days: 0)),
                                      initialDate: currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Icon(
                                      Icons.date_range,
                                      color: Colors.grey,
                                    ), // icon is 48px widget.
                                  ), // icon is 48px widget.
                                  labelText: 'Date',
                                ),
                                validator: (date) {
                                  if (_dateController.text.isEmpty){
                                    return 'Please enter time off date';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),//Enter date

                        SizedBox(height: 10.0),
                        new Row(
                          children: <Widget>[
                            Expanded(
                              child:DateTimeField(
                                //initialTime: new TimeOfDay.now(),
                                format: timeFormat,
                                controller: _starttimeController,
                                readOnly: true,
                                onShowPicker: (context, currentValue) async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                  );
                                  return DateTimeField.convert(time);
                                },
                                decoration: InputDecoration(
                                  labelText: 'From',
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Icon(
                                      Icons.alarm,
                                      color: Colors.grey,
                                    ), // icon is 48px widget.
                                  ),
                                ),
                                validator: (time) {
                                  if (_starttimeController.text.isEmpty) {
                                    return 'Please enter start time';
                                  }
                                  var arr=_starttimeController.text.split(':');
                                  var arrtime=DateFormat.Hm().format(DateTime.now()).split(':');
                                  print("arrtime[0]");
                                  print(arrtime[0]);
                                  print("arrtime[1]");
                                  print(arrtime[1]);
                                  final startTime = DateTime(2018, 6, 23,int.parse(arr[0]),int.parse(arr[1]),00,00);
                                  final currenttime = DateTime(2018, 6, 23,int.parse(arrtime[0]),int.parse(arrtime[1]),00,00);
                                  if(_dateController.text==dateFormat.format(DateTime.now()) && startTime.isBefore(currenttime)){
                                    return "You can't apply time off \nbefore current time";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child:DateTimeField(
                                //initialTime: new TimeOfDay.now(),
                                format: timeFormat,
                                controller: _endtimeController,
                                readOnly: true,
                                onShowPicker: (context, currentValue) async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                  );
                                  return DateTimeField.convert(time);
                                },
                                decoration: InputDecoration(
                                  labelText: 'To',
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Icon(
                                      Icons.alarm,
                                      color: Colors.grey,
                                    ), // icon is 48px widget.
                                  ),
                                ),
                                validator: (time) {
                                  if (_starttimeController.text.isEmpty) {
                                    return 'Please enter end time';
                                  }

                                  var arr=_starttimeController.text.split(':');
                                  var arr1=_endtimeController.text.split(':');
                                  final startTime = DateTime(2018, 6, 23,int.parse(arr[0]),int.parse(arr[1]),00,00);
                                  final endTime = DateTime(2018, 6, 23,int.parse(arr1[0]),int.parse(arr1[1]),00,00);
                                  if(endTime.isBefore(startTime)){
                                    return '\"To Time\" can\'t be smaller.';
                                  }else if(startTime.isAtSameMomentAs(endTime)){
                                    return '\"To Time\" can\'t be equal.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child:  TextFormField(
                                controller: _reasonController,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.sentences,
                                decoration: InputDecoration(
                                    labelText: 'Reason',
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Icon(
                                        Icons.event_note,
                                        color: Colors.grey,
                                      ), // icon is 48px widget.
                                    )
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter reason';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (String value) {},
                                maxLines: null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        ButtonBar(
                          children: <Widget>[
                            RaisedButton(
                              child:isServiceCalling?Text('Processing..',style: TextStyle(color: Colors.white),):Text('APPLY',style: TextStyle(color: Colors.white),),
                              color: Colors.orange[800],
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  requesttimeoff(_dateController.text ,_starttimeController.text,_endtimeController.text,_reasonController.text.trim(), context);
                                }
                              },
                            ),
                            FlatButton(
                              shape: Border.all(color: Colors.orange[800]),
                              child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TimeoffSummary()),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),),],
              ),
            ),
          ),
        ),
      ],
    );
  }

  requesttimeoff(var timeoffdate,var starttime,var endtime,var reason, BuildContext context) async{
    setState(() {
      isServiceCalling = true;
    });
    print("----> service calling "+isServiceCalling.toString());
    final prefs = await SharedPreferences.getInstance();
    String empid = prefs.getString("empid");
    String orgid = prefs.getString("orgdir");
    var timeoff = TimeOffModal.TimeOff(TimeofDate: timeoffdate,TimeFrom: starttime, TimeTo: endtime, Reason: reason, EmpId: empid, OrgId: orgid);
    RequestTimeOffService request =new RequestTimeOffService();
    var islogin = await request.requestTimeOff(timeoff);
    print("--->"+islogin);
    if(islogin=="true"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TimeoffSummary()),
      );
      showDialog(
      context: context,
      builder: (context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          content: new Text("Time Off applied successfully."),
        );
      });
      /*showDialog(context: context, child:
      new AlertDialog(
        content: new Text('Time Off applied successfully.'),
      )
      );*/
    }else if(islogin=="1"){
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            content: new Text("There is some problem while applying Time Off."),
          );
        });
      /*showDialog(context: context, child:
      new AlertDialog(
        content: new Text('There is some problem while applying Time Off.'),
      )
      );*/
      setState(() {
        isServiceCalling=false;
      });
    }else if(islogin=="2"){
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            content: new Text("Time Off already exists."),
          );
        });
      /*showDialog(context: context, child:
      new AlertDialog(
        content: new Text('Time Off already exists.'),
      )
      );*/
      setState(() {
        isServiceCalling=false;
      });
    }else if(islogin=="3"){
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            content: new Text("Time Off should be between shift timing"),
          );
        });
      /*showDialog(context: context, child:
      new AlertDialog(
        content: new Text('Time Off should be between shift timing'),
      )
      );*/
      setState(() {
        isServiceCalling=false;
      });
    }else if(islogin=="4"){
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            content: new Text("You can not apply for a TimeOff more than decided hours"),
          );
        });
      /*showDialog(context: context, child:
      new AlertDialog(
        content: new Text('You can not apply for a TimeOff more than decided hours'),
      )
      );*/
      setState(() {
        isServiceCalling=false;
      });
    }else if(islogin=="5"){
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            content: new Text("This month's Time Off limit exceeded"),
          );
        });
      /*showDialog(context: context, child:
      new AlertDialog(
        content: new Text("This month's Time Off limit exceeded"),
      )
      );*/
      setState(() {
        isServiceCalling=false;
      });
    }else if(islogin=="6"){
      showDialog(context: context, child:
      new AlertDialog(
        content: new Text("You can not apply for Time Off for today because you have marked your Time Out"),
      )
      );
      setState(() {
        isServiceCalling=false;
      });
    }/*else if(islogin=="7"){
      showDialog(context: context, child:
      new AlertDialog(
        content: new Text("You can not apply for Time Off after marking Time Out"),
      )
      );
      setState(() {
        isServiceCalling=false;
      });
    }*/else if(islogin=="false"){
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            content: new Text("Poor Network Connection."),
          );
        });
      /*showDialog(context: context, child:
      new AlertDialog(
        content: new Text('Poor Network Connection'),
      )
      );*/
      setState(() {
        isServiceCalling=false;
      });
    }else {
      showInSnackBar(islogin);
      setState(() {
        isServiceCalling=false;
      });
    }
  }
}