// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/model/timeinout.dart';
import 'package:ubihrm/register_page.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/services/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../drawer.dart';
import '../global.dart';
import '../profile.dart';
import '../services/attandance_saveimage.dart';
import 'punchlocation_summary.dart';

// This app is a stateful, it tracks the user's current choice.
class PunchLocation extends StatefulWidget {
  @override
  _PunchLocation createState() => _PunchLocation();
}

class _PunchLocation extends State<PunchLocation> with WidgetsBindingObserver{
  static const platform = const MethodChannel('location.spoofing.check');
  String address = "";
  StreamLocation sl = new StreamLocation();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _clientname = TextEditingController();
  /*var _defaultimage =
      new NetworkImage("http://ubiattendance.ubihrm.com/assets/img/avatar.png");*/

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
  int alertdialogcount = 0;
  Timer timer;
  Timer timer1;
  int response;
  final Widget removedChild = Center();
  String fname = "",
      lname = "",
      empid = "",
      cid = "",
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
      longi = "";
  String aid = "";
  String client='0';
  String shiftId = "";
  List<Widget> widgets;

  String orgName="";
  var profileimage;
  bool showtabbar ;
  bool _checkLoaded = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initPlatformState();
    getOrgName();
    platform.setMethodCallHandler(_handleMethod);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    print("Punchlocation initPlatformState");
    appResumedPausedLogic();
    locationChannel.invokeMethod("openLocationDialog");
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted)
        setState(() {
          locationThreadUpdatedLocation = locationThreadUpdatedLocation;
        });
    });

    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    desinationId = prefs.getString('desinationId') ?? '';
    response = prefs.getInt('response') ?? 0;

    if (response == 1) {
      Home ho = new Home();
      act = await ho.checkTimeIn(empid, orgdir);
      ho.managePermission(empid, orgdir, desinationId);
      setState(() {
        setaddress();
        Is_Delete = prefs.getInt('Is_Delete') ?? 0;
        newpwd = prefs.getString('newpwd') ?? "";
        userpwd = prefs.getString('usrpwd') ?? "";
        print("New pwd"+newpwd+"  User ped"+userpwd);
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
        profile = prefs.getString('profile') ?? '';
        profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
        profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
          if (mounted) {
            setState(() {
              _checkLoaded = false;
            });
          }
        }));
        showtabbar=false;
        latit = prefs.getString('latit') ?? '';
        longi = prefs.getString('longi') ?? '';
        aid = prefs.getString('aid') ?? "";
        shiftId = prefs.getString('shiftId') ?? "";
        act1 = act;
        streamlocationaddr = globalstreamlocationaddr;
      });

    }
  }

  setaddress() async {
    globalstreamlocationaddr = await getAddressFromLati(assign_lat.toString(),assign_long.toString());
    var serverConnected = await checkConnectionToServer();
    if (serverConnected != 0) if (assign_lat == 0.0 || assign_lat == null || !locationThreadUpdatedLocation) {
      locationChannel.invokeMethod("openLocationDialog");
    }
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
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

  launchMap(String lat, String long) async {
    String url = "https://maps.google.com/?q=" + lat + "," + long;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      //print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // return (response == 0 || userpwd!=newpwd || Is_Delete!=0) ? new AskRegisterationPage() : getmainhomewidget();
    return getmainhomewidget();
  }

  Future<bool> sendToPunchVisitList() async{
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => PunchLocationSummary()), (Route<dynamic> route) => false,
    );
    return false;
  }

  getmainhomewidget() {
    return new WillPopScope(
      onWillPop: ()=> sendToPunchVisitList(),
      child: RefreshIndicator(
        child: new Scaffold(
          key: _scaffoldKey,
          backgroundColor:scaffoldBackColor(),
          endDrawer: new AppDrawer(),
          appBar: new PunchVisitAppHeader(profileimage,showtabbar,orgName),
          bottomNavigationBar:new HomeNavigation(),
          body: (act1 == '') ? Center(child: loader()) : checkalreadylogin(),
        ),
        onRefresh: () async {
          Completer<Null> completer = new Completer<Null>();
          await Future.delayed(Duration(seconds: 1)).then((onvalue) {
            completer.complete();
          });
          return completer.future;
        },
      )
    );
  }

  checkalreadylogin() {
    if (response == 1) {
      return new IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          underdevelopment(),
          (globalstreamlocationaddr.isNotEmpty || globalstreamlocationaddr!="Location not fetched") ? mainbodyWidget() : refreshPageWidgit(),
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
    //if (location_addr1 != "PermissionStatus.deniedNeverAsk") {
    if (globalstreamlocationaddr.isNotEmpty) {
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
                      color:appStartColor(),
                    ),
                    Text(
                      "Fetching location, please wait...",
                      style: new TextStyle(fontSize: 20.0, color:appStartColor()),
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
                      color:appStartColor(), decoration: TextDecoration.underline),
                ),
                onPressed: () {
                  /*startTimer();
                  sl.startStreaming(5);*/

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PunchLocation()),
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
              Image.asset('assets/spinner.gif', height: 50.0, width: 50.0),
            ]),
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
                color:appStartColor(),
              ),
              Text(
                "Under development",
                style: new TextStyle(fontSize: 30.0, color:appStartColor()),
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
                      style: new TextStyle(fontSize: 20.0, color:appStartColor()),
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
                  locationChannel.invokeMethod("startAssistant");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PunchLocation()),
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
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              decoration: new ShapeDecoration(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                color: Colors.white,
              ),
              height: MediaQuery.of(context).size.height * 0.80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //SizedBox(height: 5.0),
                  Text('Punch Visits', style: new TextStyle(fontSize: 22.0, color: appStartColor())),
                  new Divider(color: Colors.black54,height: 1.5,),
                  SizedBox(height: MediaQuery.of(context).size.height * .06),
                  //Image.asset('assets/logo.png',height: 150.0,width: 150.0),
                  // SizedBox(height: 5.0),
                  getClients_DD(),
                  SizedBox(height: 35.0),
                  SizedBox(height: MediaQuery.of(context).size.height * .01),
                  // SizedBox(height: MediaQuery.of(context).size.height*.01),
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
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 35.0),
            getwidget(globalstreamlocationaddr),
          ]),
    );

  }

  getwidget(String addrloc) {
    //if (addrloc != "PermissionStatus.deniedNeverAsk") {
    if (addrloc != "Location not fetched") {
      return Column(children: [
        ButtonTheme(
          minWidth: 120.0,
          height: 45.0,
          child: getVisitInButton(),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .04),
        Container(
            color:appStartColor().withOpacity(0.1),
            height: MediaQuery.of(context).size.height * .15,
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              FlatButton(
                child: new Text(
                    (globalstreamlocationaddr.isNotEmpty || globalstreamlocationaddr!="Location not fetched")
                    ? 'You are at: ' + globalstreamlocationaddr
                    : "Location could not be fetched",
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
                    new Text('Location not correct? ',style: TextStyle(color:appStartColor()),),
                    SizedBox(width: 5.0,),
                    new InkWell(
                      child: new Text(
                        "Refresh location",
                        style: new TextStyle(
                            color:appStartColor(),
                            decoration: TextDecoration.underline),
                      ),
                      onTap: () {
                        /*startTimer();
                        sl.startStreaming(5);*/
                        locationChannel.invokeMethod("startAssistant");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PunchLocation()),
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
        Text('Location permission is restricted from app settings, click "Open Settings" to allow permission.', textAlign: TextAlign.center, style: new TextStyle(fontSize: 14.0, color: Colors.red)),
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

  getVisitInButton() {
    return RaisedButton(
      child: Text('VISIT IN',
          style: new TextStyle(fontSize: 22.0, color: Colors.white)),
      color: Colors.orange[800],
      onPressed: () {
        if(_clientname.text.trim()=='') {
          //showInSnackBar('Please insert client name first');
          showDialog(context: context, child:
          new AlertDialog(
            //title: new Text("Warning!"),
            content: new Text('Please insert client name first.'),
          )
          );
          return false;
        }else
          saveVisitImage();
      },
    );
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
      /*return new  Text('Location is restricted from app settings, click here to allow location permission and refresh', textAlign: TextAlign.center, style: new TextStyle(fontSize: 14.0,color: Colors.red));*/
    }
  }

  saveVisitImage() async {
    //sl.startStreaming(5);
    client = _clientname.text.trim();
    MarkVisit mk = new MarkVisit(empid, client, globalstreamlocationaddr, orgdir, lat, long);
    /* mk1 = mk;*/

    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      /* Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraExampleHome()),
      );*/
      SaveImage saveImage = new SaveImage();
      bool issave = false;
      setState(() {
        act1 = "";
      });
      issave = await saveImage.saveVisit(mk);
      print("issave");
      print(issave);
      if (issave==true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PunchLocationSummary()),
        );
        showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: new Text("Visit punched successfully"),
            );
          });
        /*showDialog(context: context, child:
        new AlertDialog(
          content: new Text("Visit punched successfully!"),
        )
        );*/
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
              content: new Text("Visit was not captured, please punch again"),
            );
          });
        /*showDialog(context: context, child:
        new AlertDialog(
          //title: new Text("Warning!"),
          content: new Text("Visit was not captured, please punch again!"),
        )
        );*/
        setState(() {
          act1 = act;
        });
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

////////////////////////////////////////////////////////////
  Widget getClients_DD() {
    return Center(
      child: Form(
        child: TextFormField(
          controller: _clientname,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
              labelText: 'Client Name',
              prefixIcon: Padding(
                padding: EdgeInsets.all(0.0),
                child: Icon(
                  Icons.supervised_user_circle,
                  color: Colors.grey,
                ), // icon is 48px widget.
              )
          ),

        ),
      ),
    );
  }
///////////////////////////////////////////////////////////
}

class PunchVisitAppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;
  PunchVisitAppHeader(profileimage1,showtabbar1,orgname1){
    profileimage = profileimage1;
    orgname = orgname1;
    // print("--------->");
    // print(profileimage);
    //  print("--------->");
    //   print(_checkLoadedprofile);
    if (profileimage!=null) {
      _checkLoadedprofile = false;
      //    print(_checkLoadedprofile);
    };
    showtabbar= showtabbar1;
  }
  /*void initState() {
    super.initState();
 //   initPlatformState();
  }
*/
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
                  MaterialPageRoute(builder: (context) => PunchLocationSummary()), (Route<dynamic> route) => false,
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

