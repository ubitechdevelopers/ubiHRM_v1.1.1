// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/register_page.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/services/services.dart';
import 'package:ubihrm/services/timeoff_services.dart';
import 'package:ubihrm/timeoff/timeoff_summary.dart';
import 'package:url_launcher/url_launcher.dart';
import '../drawer.dart';
import '../global.dart';
import '../home.dart';
import '../profile.dart';


class TimeOffTimer extends StatefulWidget {
  @override
  final String timeoffId;
  final String stopTime;
  final String action;
  TimeOffTimer({Key key, this.timeoffId,this.stopTime,this.action})
      : super(key: key);
  _TimeOffTimerState createState() => _TimeOffTimerState();
}

class _TimeOffTimerState extends State<TimeOffTimer> {
  StreamLocation sl = new StreamLocation();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var profileimage;
  bool showtabbar ;
  bool _checkLoaded = true;
  int _currentIndex = 1;
  String userpwd = "new";
  String newpwd = "new";
  int Is_Delete=0;
  bool _visible = true;
  String location_addr = "";
  String location_addr1 = "";
  String streamlocationaddr = "";
  String admin_sts = '0';
  String mail_varified = '1';
  String lat = "";
  String long = "";
  String act = "";
  String act1 = "";
  String act2 = "";
  int alertdialogcount = 0;
  Timer timer;
  Timer timer1;
  int response;
  bool _checkLoadedprofile = true;
  final Widget removedChild = Center();
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
      desinationId = "",
      profile,
      latit = "",
      longi = "",
      Otimests = "";
  String aid = "";
  String shiftId = "";
  List<Widget> widgets;
  String orgName="";
  int approval_count;

  Stopwatch watch = Stopwatch();
  Timer timer2;
  bool startStop = true;

  String elapsedTime = '';

  int _isStartPressed=0;
  int _isStopPressed=0;

  DateTime time;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getOrgName();
    /*setLocationAddress();
    startTimer();*/
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    if(mounted) {
      setState(() {
        orgName = prefs.getString('orgname') ?? '';
      });
    }
  }

  updateTime(Timer timer2) {
    if (watch.isRunning) {
      setState(() {
        print("startstop Inside=$startStop");
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      });
    }
  }

  startWatch() {
    setState(() {
      startStop = false;
      watch.start();
      timer2 = Timer.periodic(Duration(milliseconds: 100), updateTime);
    });
  }

  stopWatch() {
    setState(() {
      startStop = true;
      watch.stop();
      setTime();
    });
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
    });
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

/*  startTimer() {
    const fiveSec = const Duration(seconds: 5);
    int count = 0;
    timer = new Timer.periodic(fiveSec, (Timer t) {
      count++;
      setLocationAddress();
      if (stopstreamingstatus) {
        t.cancel();
      }
    });
  }

  startTimer1() {
    const fiveSec = const Duration(seconds: 1);
    int count = 0;
    timer1 = new Timer.periodic(fiveSec, (Timer t) {
      print("timmer is running");
    });
  }

  setLocationAddress() async {
    if(mounted) {
      setState(() {
        streamlocationaddr = globalstreamlocationaddr;
        if (list != null && list.length > 0) {
          lat = list[list.length - 1].latitude.toString();
          long = list[list.length - 1].longitude.toString();
          if (streamlocationaddr == '') {
            streamlocationaddr = lat + ", " + long;
          }
        }
        if (streamlocationaddr == '') {
          sl.startStreaming(5);
          startTimer();
        }
      });
    }
  }*/

  launchMap(String lat, String long) async {
    String url = "https://maps.google.com/?q=" + lat + "," + long;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      //print('Could not launch $url');
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    desinationId = globalcompanyinfomap['Designation'];
    response = prefs.getInt('response') ?? 0;
    //Loc lock = new Loc();
    //location_addr = await lock.initPlatformState();
    //print(location_addr);

    Home ho = new Home();
    act = await ho.checkTimeIn(empid, orgdir);
    print(act);
    ho.managePermission(empid, orgdir, desinationId);
    await getCountAproval();
    if(mounted) {
      setState(() {
        newpwd = prefs.getString('newpwd') ?? "";
        userpwd = prefs.getString('usrpwd') ?? "";
        location_addr1 = location_addr;
        admin_sts = prefs.getString('sstatus').toString() ?? '0';
        mail_varified = prefs.getString('mail_varified').toString() ?? '0';
        alertdialogcount = globalalertcount;
        response = prefs.getInt('response') ?? 0;
        fname = prefs.getString('fname') ?? '';
        lname = prefs.getString('lname') ?? '';
        empid = prefs.getString('empid') ?? '';
        email = prefs.getString('email') ?? '';
        status = prefs.getString('status') ?? '';
        orgid = prefs.getString('orgid') ?? '';
        orgdir = prefs.getString('orgdir') ?? '';
        org_name = prefs.getString('org_name') ?? '';
        desination = prefs.getString('desination') ?? '';
        Otimests = prefs.getString('Otimests') ?? '';
        profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);
        profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
          if (mounted) {
            setState(() {
              _checkLoaded = false;
            });
          }
        }));
        showtabbar = false;
        latit = prefs.getString('latit') ?? '';
        longi = prefs.getString('longi') ?? '';
        aid = prefs.getString('aid') ?? "";
        shiftId = prefs.getString('shiftId') ?? "";
        act1 = act;
        streamlocationaddr = globalstreamlocationaddr;
        perPunchLocation = getModulePermission("305", "view");
      });
    }
    //}
  }

  @override
  Widget build(BuildContext context) {
    (mail_varified=='0' && alertdialogcount==0 && admin_sts=='1')?Future.delayed(Duration.zero, () => _showAlert(context)):"";
    return getmainhomewidget();
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(
          value,
          textAlign: TextAlign.center,
        ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<bool> sendToHome() async{
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePageMain()), (Route<dynamic> route) => false,
    );
    return false;
  }

  getmainhomewidget() {
    return new WillPopScope(
        onWillPop: () => sendToHome(),
        child: Scaffold(
          backgroundColor:scaffoldBackColor(),
          endDrawer: new AppDrawer(),
          appBar: new AttendanceHomeAppHeader(profileimage,showtabbar,orgName),
          bottomNavigationBar:new HomeNavigation(),
          body: (act1 == '') ? Center(child: loader()) : checkalreadylogin(),
        )
    );
  }

  checkalreadylogin() {
    if (response == 1) {
      return new IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          underdevelopment(),
          (streamlocationaddr != '') ? mainbodyWidget() : refreshPageWidgit(),
          underdevelopment()
        ],
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Register()),
            (Route<dynamic> route) => false,
      );
    }
  }

  refreshPageWidgit() {
    if (location_addr1 != "PermissionStatus.deniedNeverAsk") {
      return new Container(
        child: Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.all_inclusive,
                      color: appStartColor(),
                    ),
                    Text(
                      "Fetching location, please wait...",
                      style: new TextStyle(fontSize: 20.0, color: appStartColor()),
                    )
                  ]),
              SizedBox(height: 15.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //SizedBox(width: 20.0,),
                    Text(
                      "Note: ",
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      "If location not being fetched automatically?",
                      style: new TextStyle(fontSize: 12.0, color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ]),

              FlatButton(
                child: new Text(
                  "Fetch Location now",
                  style: new TextStyle(
                      color: appStartColor(), decoration: TextDecoration.underline),
                ),
                onPressed: () {
                  /*startTimer();
                  sl.startStreaming(5);*/
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TimeOffTimer()),
                  );
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Location permission is restricted from app settings, click "Open Settings" to allow permission.',
                textAlign: TextAlign.center,
                style: new TextStyle(fontSize: 14.0, color: Colors.red)),
            RaisedButton(
              child: Text('Open Settings'),
              onPressed: () {
                PermissionHandler().openAppSettings();
              },
            ),
          ]);

    }
  }

  loader() {
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              //Text("Loading...")
              //Image.asset('assets/spinner.gif', height: 50.0, width: 50.0),
              CircularProgressIndicator()
            ]
        ),
      ),
    );
  }

  underdevelopment() {
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.android,
                color: appStartColor(),
              ),
              Text(
                "Under development",
                style: new TextStyle(fontSize: 30.0, color: appStartColor()),
              )
            ]),
      ),
    );
  }

  poorNetworkWidget() {
    return Container(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.error,
                      color: appStartColor(),
                    ),
                    Text(
                      "Poor network connection.",
                      style: new TextStyle(fontSize: 20.0, color: appStartColor()),
                    ),
                  ]),
              SizedBox(height: 5.0),
              FlatButton(
                child: new Text(
                  "Refresh location",
                  style: new TextStyle(
                      color: appStartColor(), decoration: TextDecoration.underline),
                ),
                onPressed: () {
                  /*startTimer();
                  sl.startStreaming(5);*/
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TimeOffTimer()),
                  );
                },
              ),
            ]),
      ),
    );
  }

  mainbodyWidget() {
    ////to do check act1 for poor network connection
    if (act1 == "Poor network connection") {
      return poorNetworkWidget();
    } else {
      return SafeArea(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              decoration: new ShapeDecoration(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                color: Colors.white,
              ),
              height: MediaQuery.of(context).size.height * 0.80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //Text(elapsedTime, style: new TextStyle(fontSize: 22.0,color: appStartColor())),
                  SizedBox(height: MediaQuery.of(context).size.height * .02),
                  new GestureDetector(
                    onTap: () {
                    },
                    child: new Stack(children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.height * .18,
                          height: MediaQuery.of(context).size.height * .18,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image:_checkLoaded ? AssetImage('assets/default.png') : profileimage,
                              ))),
                    ]),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .02),
                  Text("Hi " + globalpersnalinfomap['FirstName'], style: new TextStyle(fontSize: 16.0)),
                  SizedBox(height: MediaQuery.of(context).size.height*.02),
                  (act1 == '') ? loader() : getMarkAttendanceWidgit(),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  getMarkAttendanceWidgit() {
    if (act1 == "Imposed") {
      return getAlreadyMarkedWidgit();
    } else {
      return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              getwidget(location_addr1),
            ]),
      );
    }
  }


  getAlreadyMarkedWidgit() {
    return Column(children: <Widget>[
      SizedBox(
        height: 27.0,
      ),
      Container(
        decoration: new ShapeDecoration(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0)),
            color: Colors.green[50]),
        child: Padding(
          padding: const EdgeInsets.only(top:12.0),
          child: Text(
            'Attendance has been Marked.\n Thank you!',
            textAlign: TextAlign.center,
            style: new TextStyle(color: Colors.black87, fontSize: 15.0),
          ),
        ),
        width: double.infinity,
        height: 60.0,
      ),
    ]);
  }

  getwidget(String addrloc) {
    if (addrloc != "PermissionStatus.deniedNeverAsk") {
      return Column(children: [
        Container(
          width: MediaQuery.of(context).size.width * .5,
          height: MediaQuery.of(context).size.height*.06,
          child: getStartTimeOffButton(),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .03),
        Container(
            color: appStartColor().withOpacity(0.1),
            height: MediaQuery.of(context).size.height * .15,
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              FlatButton(
                child: new Text('You are at: ' + streamlocationaddr,
                    textAlign: TextAlign.center,
                    style: new TextStyle(fontSize: 14.0)),
                onPressed: () {
                  launchMap(lat, long);
                },
              ),
              new Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text('Location not correct? ',style: TextStyle(color: appStartColor()),),
                    SizedBox(width: 5.0,),
                    new InkWell(
                      child: new Text(
                        "Refresh location",
                        style: new TextStyle(
                            color: appStartColor(),
                            decoration: TextDecoration.underline),
                      ),
                      onTap: () {
                        /*startTimer();
                        sl.startStreaming(5);*/
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TimeOffTimer()),
                        );
                      },
                    )
                  ],
                ),
              ),
            ])),
      ]);
    } else {
      return Column(children: [
        Text(
            'Location permission is restricted from app settings, click "Open Settings" to allow permission.',
            textAlign: TextAlign.center,
            style: new TextStyle(fontSize: 14.0, color: Colors.red)),
        RaisedButton(
          child: Text('Open Settings'),
          onPressed: () {
            PermissionHandler().openAppSettings();
          },
        ),
      ]);
    }
  }

  getStartTimeOffButton() {
    if (widget.action == "Start") {
      return RaisedButton(
        child: Text('START TIME OFF', style: new TextStyle(fontSize: 18.0, color: Colors.white)),
        color: Colors.orange[800],
        onPressed: () {
          /*setState(() {
            _isStartPressed = _isStartPressed + 1;
            print("_isStartPressed");
            print(_isStartPressed);
          });*/
          time = DateTime.now();
          act = "Start";
          print(act);
          print(time);
          saveTimeOff(time, act);
          stopWatch();
        },
      );
    } else if (widget.action == "Stop"){
      return RaisedButton(
        child: Text('END TIME OFF', style: new TextStyle(fontSize: 18.0, color: Colors.white)),
        color: Colors.orange[800],
        onPressed: () {
         /* setState(() {
            _isStopPressed = _isStopPressed + 1;
          });*/
          time = DateTime.now();
          act = "Stop";
          print(act);
          print(time);
          saveTimeOff(time, act);
          startWatch();
        },
      );
  }
  }

  Text getText(String addrloc) {
    if (addrloc != "PermissionStatus.deniedNeverAsk") {
      return Text('You are at: ' + addrloc,
          textAlign: TextAlign.center, style: new TextStyle(fontSize: 14.0));
    } else {
      return new Text(
          'Location access is denied. Enable the access through the settings.',
          textAlign: TextAlign.center,
          style: new TextStyle(fontSize: 14.0, color: Colors.red));
    }
  }

  saveTimeOff(time, act) async {
    MarkStartTimeOff mk = new MarkStartTimeOff(empid, orgid, time, act, widget.timeoffId, streamlocationaddr, lat, long);
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      SaveTimerTime save = new SaveTimerTime();
      String issave = "false";
      try {
        issave = await save.saveTimeOff(mk);
        print("issave");
        print(issave);
        if (issave.contains("true")) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TimeoffSummary(
              time: elapsedTime
            )),
          );
        } else if(issave.contains("unmarked")){
          showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pop(true);
              });
              return AlertDialog(
                content: new Text("Before Starting TimeOff you need to mark Time In"),
              );
            });
          /*showDialog(context: context, child:
          new AlertDialog(
            content: new Text("Before Starting TimeOff you need to mark Time In"),
          )
          );*/
        } else {
          showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pop(true);
              });
              return AlertDialog(
                content: new Text("There is some problem"),
              );
            });
          /*showDialog(context: context, child:
          new AlertDialog(
            content: new Text("There is some problem"),
          )
          );*/
        }
      }catch(e){
        print("EXCEPTION PRINT: "+e.toString());
      }
    }else{
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            content: new Text("Internet connection not found."),
          );
        });
      /*showDialog(context: context, child:
      new AlertDialog(
        content: new Text("Internet connection not found."),
      )
      );*/
    }
  }

  resendVarification() async{
    NewServices ns= new NewServices();
    bool res = await ns.resendVerificationMail(orgid);
    if(res){
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              content: Row( children:<Widget>[
                Text("Verification link has been sent to \nyour organization's registered Email."),
              ]
              )
          )
      );
    }
  }

  void _showAlert(BuildContext context) {
    globalalertcount = 1;
    if(mounted) {
      setState(() {
        alertdialogcount = 1;
      });
    }
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text("Verify Email"),
            content: Container(
                height: MediaQuery.of(context).size.height*0.22,
                child:Column(
                    children:<Widget>[
                      Container(width:MediaQuery.of(context).size.width*0.6, child:Text("Your organization's Email is not verified. Please verify now.")),

                      new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children:<Widget>[
                            ButtonBar(
                              children: <Widget>[
                                FlatButton(
                                  child: Text('Later'),
                                  shape: Border.all(color: Colors.black54),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true).pop();
                                  },
                                ),
                                new RaisedButton(
                                  child: new Text(
                                    "Verify",
                                    style: new TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  color: Colors.orange[800],
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true).pop();
                                    resendVarification();
                                  },
                                ),
                              ],
                            ),
                          ])
                    ]
                ))
        )
    );
  }
}

class AttendanceHomeAppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;
  AttendanceHomeAppHeader(profileimage1,showtabbar1,orgname1){
    profileimage = profileimage1;
    orgname = orgname1;
    if (profileimage!=null) {
      _checkLoadedprofile = false;
    };
    showtabbar= showtabbar1;
  }

  @override
  Widget build(BuildContext context) {
    return new GradientAppBar(
        backgroundColorStart: appStartColor(),
        backgroundColorEnd: appEndColor(),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(icon:Icon(Icons.arrow_back),
              onPressed:(){
                print("ICON PRESSED");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageMain()), (Route<dynamic> route) => false,
                );
              },),
            GestureDetector(
              // When the child is tapped, show a snackbar
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CollapsingTab()),
                );
              },
              child:Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        // image: AssetImage('assets/avatar.png'),
                        image: _checkLoadedprofile ? AssetImage('assets/default.png') : profileimage,
                      )
                  )
              ),
            ),
            Flexible(
              child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(orgname, overflow: TextOverflow.ellipsis,)
              ),
            )
          ],
        ),
        bottom:
        showtabbar==true ? TabBar(
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: choices.map((Choice choice) {
            return Tab(
              text: choice.title,
              //   unselectedLabelColor: Colors.white70,
              //   indicatorColor: Colors.white,
              //   icon: Icon(choice.icon),
            );
          }).toList(),
        ):null
    );
  }
  @override
  Size get preferredSize => new Size.fromHeight(showtabbar==true ? 100.0 : 60.0);
}

