// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/attandance/attendance_summary.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/model/timeinout.dart';
import 'package:ubihrm/register_page.dart';
import 'package:ubihrm/services/attandance_fetch_location.dart';
import 'package:ubihrm/services/attandance_saveimage.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../drawer.dart';
import '../global.dart';
import '../home.dart';
import '../profile.dart';

// This app is a stateful, it tracks the user's current choice.
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = const MethodChannel('location.spoofing.check');
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
  bool fakeLocationDetected = false;
  String address = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getOrgName();
    platform.setMethodCallHandler(_handleMethod);

    print("assignedAreaIds.isNotEmpty");
    print(assignedAreaIds.isNotEmpty);
    print('perGeoFence=="1"');
    print(perGeoFence=="1");
    print("perGeoFence");
    print(perGeoFence);
    print(areaSts);
    print(areaSts=="0");
    //setLocationAddress();
    //startTimer();
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    if(mounted) {
      setState(() {
        orgName = prefs.getString('orgname') ?? '';
      });
    }
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
      print('Could not launch $url');
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    desinationId = globalcompanyinfomap['Designation'];
    response = prefs.getInt('response') ?? 0;

    getAreaStatus().then((res) {
      print('attendance/home dot dart');
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
        print("globalstreamlocationaddr");
        print(globalstreamlocationaddr);
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

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "locationAndInternet":
        locationThreadUpdatedLocation = true;
        var long = call.arguments["longitude"].toString();
        var lat = call.arguments["latitude"].toString();
        assign_lat = double.parse(lat);
        assign_long = double.parse(long);
        address = await getAddressFromLati(lat, long);
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

        setState(() {
          if (call.arguments["mocked"].toString() == "Yes") {
            fakeLocationDetected = true;
          } else {
            fakeLocationDetected = false;
          }
          if (call.arguments["TimeSpoofed"].toString() == "Yes") {
            timeSpoofed = true;
          }
        });
        break;

        return new Future.value("");
    }
  }

  Future<bool> sendToHome() async{
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
                    //SizedBox(width: 20.0,),
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
                    /* new InkWell(
                      child: new Text(
                        "Fetch Location now",
                        style: new TextStyle(
                            color: Colors.teal,
                            decoration: TextDecoration.underline),
                      ),
                      onTap: () {
                        sl.startStreaming(5);
                        startTimer();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                    )*/
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
                    MaterialPageRoute(builder: (context) => HomePage()),
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
                  /*sl.startStreaming(5);
                  startTimer();*/
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
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
                  Text("Punch Attendance", style: new TextStyle(fontSize: 22.0,color: appStartColor())),
                  SizedBox(height: MediaQuery.of(context).size.height * .02),
                  new GestureDetector(
                    onTap: () {
                      // profile navigation
                    },
                    child: new Stack(children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.height * .18,
                          height: MediaQuery.of(context).size.height * .18,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image:_checkLoaded ? AssetImage('assets/avatar.png') : profileimage,
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
      SizedBox(
        height: MediaQuery.of(context).size.height*.08,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new InkWell(
            child: new Text(
              "Check Attendance Log",
              style: new TextStyle(
                  color: Colors.orange[800],
                  decoration: TextDecoration.underline,
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),
          Text(" "),

        ],
      ),
    ]);
  }

  getwidget(String addrloc) {
    if (addrloc != "PermissionStatus.deniedNeverAsk") {
      return Column(children: [
        ButtonTheme(
          minWidth: 120.0,
          height: 45.0,
          child: getTimeInOutButton(),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .03),
        Container(
            color: appStartColor().withOpacity(0.1),
            height: MediaQuery.of(context).size.height * .20,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              FlatButton(
                child: new Text('You are at: ' + streamlocationaddr,
                    textAlign: TextAlign.center,
                    style: new TextStyle(fontSize: 14.0)),
                onPressed: () {
                  launchMap(lat, long);
                },
              ),
              (assignedAreaIds.isNotEmpty && perGeoFence=="1")?areaSts=="0"
                  ? Container(
                padding:
                EdgeInsets.only(top: 5.0, right: 5.0),
                child: Text(
                  'Outside Geofence',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      backgroundColor: Colors.red,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0),
                ),
              ) : Container(
                padding: EdgeInsets.only(top:5.0),
                child: Text(
                  'Within Geofence',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      backgroundColor: Colors.green,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0),
                ),
              ):Center(),
              SizedBox(height: 5.0,),
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
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                    )
                  ],
                ),
              ),
            ])),

        SizedBox(height:MediaQuery.of(context).size.height *0.05,),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //SizedBox(width: 50.0,),
            new InkWell(
              child: new Text(
                "Check Attendance Log",
                style: new TextStyle(
                    color: Colors.orange[800],
                    decoration: TextDecoration.underline,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
            Text(" "),
          ],
        ),
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
    return Container(width: 0.0, height: 0.0);
  }

  getTimeInOutButton() {
    if (act1 == 'TimeIn') {
      return RaisedButton(
        child: Text('TIME IN',
            style: new TextStyle(fontSize: 22.0, color: Colors.white)),
        color: Colors.orange[800],
        onPressed: () {
          saveImage();
        },
      );
    } else if (act1 == 'TimeOut' ) {
      return RaisedButton(
        child: Text('TIME OUT',
            style: new TextStyle(fontSize: 22.0, color: Colors.white)),
        color: Colors.orange[800],
        onPressed: () {
          saveImage();
        },
      );
    }
  }

  saveImage() async {

    if(perGeoFence=="1") {
      if (areaSts=="0") {
        if(assignedAreaIds.isEmpty){
          geoFenceStatus = "";
        }else{
          geoFenceStatus = "Outside Geofence";
        }

        print('geoFenceStatus---->>>>'+geoFenceStatus);
        print('geoFenceOrgPerm---->>>>'+geoFenceOrgPerm);

        if(geoFenceOrgPerm=="1"||fenceAreaSts=="1") {
          print('geoFenceStatus---->>>>'+geoFenceStatus);

          /*await showDialog(
            context: context,
            // ignore: deprecated_member_use
            child: new AlertDialog(
              //title: new Text("Warning!"),
              content: new Text(
                  "You Can't punch Attendance Outside Geofence."),
            ));*/
          return null;
        }

      } else {
        geoFenceStatus = "Within Geofence";
        print('geoFenceStatus--->>>>'+geoFenceStatus);
      }
    }
    print('geoFenceStatus---->>>>'+geoFenceStatus);

    //sl.startStreaming(5);
    if(globalcompanyinfomap['Department']==''){
      await showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: new Text("Department has not been assigned."),
            );
          });
      /*await showDialog(
          context: context,
          // ignore: deprecated_member_use
          child: new AlertDialog(
            //title: new Text("Warning!"),
            content: new Text("Department has not been assigned."),
          ));*/
      return null;
    }
    if(globalcompanyinfomap['Designation']==''){
      await showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: new Text("Designation has not been assigned."),
            );
          });/*showDialog(
          context: context,
          // ignore: deprecated_member_use
          child: new AlertDialog(
            //title: new Text("Warning!"),
            content: new Text("Designation has not been assigned."),
          ));*/
      return null;
    }
    if(globalcompanyinfomap['Shift']==''){
      await showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: new Text("Shift has not been assigned."),
            );
          });/*showDialog(
          context: context,
          // ignore: deprecated_member_use
          child: new AlertDialog(
            //title: new Text("Warning!"),
            content: new Text("Shift has not been assigned."),
          ));*/
      return null;
    }

    MarkTime mk = new MarkTime(empid, streamlocationaddr, aid, act1, shiftId, orgdir, lat, long);
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      SaveImage saveImage = new SaveImage();
      bool issave = false;
      if(mounted) {
        setState(() {
          act1 = "";
        });
      }
      try {
        issave = await saveImage.saveTimeInOutImagePicker(mk);
        print("issave");
        print(issave);
        if (issave) {
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.of(context).pop(true);
                });
                return AlertDialog(
                  content: new Text("Attendance marked successfully!"),
                );
              });
          /*showDialog(context: context, barrierDismissible: true, child:
          new AlertDialog(
            content: new Text("Attendance marked successfully!"),
          )
          );*/
          //await new Future.delayed(const Duration(seconds: 2));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
          );
          setState(() {
            act1 = act;
          });
        } else {
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.of(context).pop(true);
                });
                return AlertDialog(
                  content: new Text("Attendance was not captured. Please punch again!"),
                );
              });
          /*showDialog(context: context, child:
          new AlertDialog(
            //content: new Text("Selfie not captured, please punch again!"),
            content: new Text("Attendance was not captured. Please punch again!"),
          )
          );*/
          if(mounted) {
            setState(() {
              act1 = act;
            });
          }
        }
      }catch(e){
        print("EXCEPTION PRINT: "+e.toString());
      }
    }else{
      showDialog(context: context, child:
      new AlertDialog(
        content: new Text("Internet connection not found."),
      )
      );
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
                        image: _checkLoadedprofile ? AssetImage('assets/avatar.png') : profileimage,
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
            );
          }).toList(),
        ):null
    );
  }
  @override
  Size get preferredSize => new Size.fromHeight(showtabbar==true ? 100.0 : 60.0);
}

