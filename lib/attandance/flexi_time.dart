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
import 'package:ubihrm/global.dart';
import 'package:ubihrm/home.dart';
import 'package:ubihrm/model/timeinout.dart';
import 'package:ubihrm/register_page.dart';
import 'package:ubihrm/services/attandance_saveimage.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../drawer.dart';
import '../profile.dart';
import 'flexi_list.dart';

// This app is a stateful, it tracks the user's current choice.
class Flexitime extends StatefulWidget {
  @override
  _Flexitime createState() => _Flexitime();
}

class _Flexitime extends State<Flexitime> {
  StreamLocation sl = new StreamLocation();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Flexi> flexiidsts = null;
  var profileimage;
  bool _checkLoaded = true;
  int _currentIndex = 1;
  String userpwd = "new";
  String newpwd = "new";
  int Is_Delete=0;
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
  String flexitimein = "";
  String fid = "";
  String sts ="";
  bool showtabbar ;
  String orgName="";

  @override
  void initState() {
    super.initState();
    initPlatformState();
    /*setLocationAddress();
    startTimer();*/
    getOrgName();
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
  }

  /*startTimer() {
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
    setState(() {
      streamlocationaddr = globalstreamlocationaddr;
      if (list != null && list.length > 0) {
        lat = list[list.length - 1].latitude.toString();
        long = list[list.length - 1].longitude.toString();
        if (streamlocationaddr == '') {
          streamlocationaddr = lat + ", " + long;
        }
      }
      if(streamlocationaddr == ''){
        sl.startStreaming(5);
        startTimer();
      }
    });
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
    empid = prefs.getString('employeeid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    desinationId = prefs.getString('desinationId') ?? '';
    response = prefs.getInt('response') ?? 0;

    checkTimeinflexi().then((EmpList) {
      setState(() {
        flexiidsts = EmpList;
        fid = flexiidsts[0].fid;
        flexitimein = flexiidsts[0].sts;
        print("id and sts");
        print(fid);
        print(flexitimein);
      });
    });

    //Loc lock = new Loc();
    //location_addr = await lock.initPlatformState();
    Home ho = new Home();
    act = await ho.checkTimeIn(empid, orgdir);
    ho.managePermission(empid, orgdir, desinationId);
    setState(() {
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
      orgid = prefs.getString('orgdir') ?? '';
      orgdir = prefs.getString('orgdir') ?? '';
      org_name = prefs.getString('org_name') ?? '';
      desination = prefs.getString('desination') ?? '';
      profile = prefs.getString('profile') ?? '';
      profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);
      profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __){
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

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  loader() {
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset('assets/spinner.gif', height: 50.0, width: 50.0),
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
          ]
        ),
      ),
    );
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
      onWillPop: ()=> sendToHome(),
      child: new Scaffold(
        key: _scaffoldKey,
        backgroundColor:scaffoldBackColor(),
        endDrawer: new AppDrawer(),
        appBar: new FlexiAppHeader(profileimage,showtabbar,orgName),
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
        MaterialPageRoute(builder: (context) => Register()), (Route<dynamic> route) => false,
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
                ]
              ),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                ]
              ),

              FlatButton(
                child: new Text(
                  "Fetch Location now",
                  style: new TextStyle(color: appStartColor(), decoration: TextDecoration.underline),
                ),
                onPressed: () {
                  /*startTimer();
                  sl.startStreaming(5);*/

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Flexitime()),
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
          ]
      );
    }
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
              ]
            ),
            SizedBox(height: 5.0),
            FlatButton(
              child: new Text(
                "Refresh location",
                style: new TextStyle(color: appStartColor(), decoration: TextDecoration.underline),
              ),
              onPressed: () {
                /*startTimer();
                sl.startStreaming(5);*/

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Flexitime()),
                );
              },
            ),
          ]
        ),
      ),
    );
  }

  mainbodyWidget() {
    //to do check act1 for poor network connection
    if (act1 == "Poor network connection") {
      return poorNetworkWidget();
    } else {
      return SafeArea(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.80,
              margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              decoration: new ShapeDecoration(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 5.0),
                  Text("Flexi Attendance", style: new TextStyle(fontSize: 22.0,color: appStartColor())),
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
                          )
                        )
                      ),
                    ]),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .01),
                  Text("Hi " + globalpersnalinfomap['FirstName'], style: new TextStyle(fontSize: 16.0)),
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
          SizedBox(height: 20.0),
          getwidget(location_addr1),
        ]
      ),
    );
  }

  getwidget(String addrloc) {
    if (addrloc != "PermissionStatus.deniedNeverAsk") {
      return Column(children: [
        ButtonTheme(
          minWidth: 120.0,
          height: 45.0,
          child:flexitimein=='2'?getFlexioutButton():getFlexiInButton(),
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
                        MaterialPageRoute(builder: (context) => Flexitime()),
                      );
                    },
                  )
                ],

              ),
            ),
          ])
        ),

        SizedBox(height:MediaQuery.of(context).size.height *0.05,),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlexiList()),
                );
              },
              child: Center(
                child: new Text(
                  "Check Flexi Log",
                  style: new TextStyle(
                    color: Colors.orange[800],
                    decoration: TextDecoration.underline,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ]),
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

  getFlexiInButton() {
    return RaisedButton(
      child: Text('TIME IN',
          style: new TextStyle(fontSize: 22.0, color: Colors.white)),
      color: Colors.orange[800],
      onPressed: () {
        saveFlexiImage();
      },
    );
  }

  getFlexioutButton() {
    return  RaisedButton(
      child: const Text('TIME OUT',style: TextStyle(color: Colors.white,fontSize: 22),),
      color: Colors.orange[800],
      onPressed: () {
        saveFlexioutImage();
      }
    );
  }


  saveFlexiImage() async {
    print('saveFlexiImage');
    client ="";
    MarkVisit mk = new MarkVisit(empid,client,streamlocationaddr,orgdir,lat,long);
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      SaveImage saveImage = new SaveImage();
      bool issave = false;
      setState(() {
        act1 = "";
      });
      issave = await saveImage.saveFlexi(mk);
      print("issave");
      print(issave);

      if (issave) {
        /*showDialog(context: context, child:
        new AlertDialog(
          content: new Text("Attendance punched successfully!"),
        )
        );*/
        //await new Future.delayed(const Duration(seconds: 2));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FlexiList()),
        );
        showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: new Text("Attendance punched successfully"),
            );
          });
        setState(() {
          act1 = act;
        });
      } else {
        /*showDialog(context: context, child:
        new AlertDialog(
          content: new Text("Flexi Attendance was not captured, please punch again!"),
        )
        );*/
        showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: new Text("Flexi Attendance was not captured, please punch again"),
            );
          });
        setState(() {
          act1 = act;
        });
      }
    }else {
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


  saveFlexioutImage() async {
    print("saveFlexioutImage");
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {

      SaveImage saveImage = new SaveImage();
      bool issave = false;
      setState(() {
        act1 = "";
      });

      print('streamlocationaddr.toString()');
      print(streamlocationaddr.toString());

      issave = await saveImage.saveFlexiOut(empid,streamlocationaddr.toString(),fid.toString(),lat,long,orgid);

      if(issave){
        print("issave");
        print(issave);

        /*showDialog(context: context, child:
        new AlertDialog(
          content: new Text("Attendance punched successfully!"),
        )
        );*/
        //await new Future.delayed(const Duration(seconds: 2));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FlexiList()),
        );
        showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: new Text("Attendance punched successfully!"),
            );
          });
        setState(() {
          act1 = act;
        });
      }else{
        /*showDialog(context: context, child:
        new AlertDialog(
          content: new Text('Flexi Attendance was not captured, please punch again!'),
        )
        );*/
        showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: new Text("Flexi Attendance was not captured, please punch again"),
            );
          });
        setState(() {
          act1 = act;
        });
      }
    }else {
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


}

class FlexiAppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;

  FlexiAppHeader(profileimage1,showtabbar1,orgname1){
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageMain()),
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
                  child: Text(orgname,overflow: TextOverflow.ellipsis,)
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

