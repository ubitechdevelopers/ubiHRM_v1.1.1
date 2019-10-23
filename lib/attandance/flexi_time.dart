// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:ubihrm/services/attandance_fetch_location.dart';
//import 'package:simple_permissions/simple_permissions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'askregister.dart';
import 'package:ubihrm/services/attandance_gethome.dart';
import 'package:ubihrm/services/attandance_saveimage.dart';
import 'package:ubihrm/model/timeinout.dart';
import 'attendance_summary.dart';
import '../drawer.dart';
//import 'timeoff_summary.dart';
import 'package:ubihrm/services/services.dart';
//import 'leave.dart';
import 'package:ubihrm/services/attandance_newservices.dart';
import 'home.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:ubihrm/global.dart';
import 'punchlocation_summary.dart';
import 'settings.dart';
import 'profile.dart';
import 'reports.dart';
import 'flexi_list.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:ubihrm/b_navigationbar.dart';
import '../appbar.dart';

// This app is a stateful, it tracks the user's current choice.
class Flexitime extends StatefulWidget {
  @override
  _Flexitime createState() => _Flexitime();
}

class _Flexitime extends State<Flexitime> {
  StreamLocation sl = new StreamLocation();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _clientname = TextEditingController();
  List<Flexi> flexiidsts = null;
  /*var _defaultimage =
      new NetworkImage("http://ubiattendance.ubihrm.com/assets/img/avatar.png");*/
  var profileimage;
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
    setLocationAddress();
    startTimer();
    getOrgName();
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
  }

  startTimer() {
    const fiveSec = const Duration(seconds: 5);
    int count = 0;
    timer = new Timer.periodic(fiveSec, (Timer t) {
      //print("timmer is running");
      count++;
      //print("timer counter" + count.toString());
      setLocationAddress();
      if (stopstreamingstatus) {
        t.cancel();
        //print("timer canceled");
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
      //print("home addr" + streamlocationaddr);
      //print(lat + ", " + long);

      //print(stopstreamingstatus.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

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

    /*await availableCameras();*/
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('employeeid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    desinationId = prefs.getString('desinationId') ?? '';
    response = prefs.getInt('response') ?? 0;
   /* flexitimein= await checkTimeinflexi();
    print(flexitimein);
    print("---");
    setState(() {
      flexitimein = flexitimein;
    });*/
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

  //  if (response == 1) {
      Loc lock = new Loc();
      location_addr = await lock.initPlatformState();
      Home ho = new Home();
      act = await ho.checkTimeIn(empid, orgdir);
      ho.managePermission(empid, orgdir, desinationId);
      // //print(act);
      ////print("this is-----> "+act);
      ////print("this is main "+location_addr);
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
        // //print("1-"+profile);
        profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __){
          if (mounted) {
            setState(() {
              _checkLoaded = false;
            });
          }
        }));
        showtabbar=false;
        // //print("2-"+_checkLoaded.toString());
        latit = prefs.getString('latit') ?? '';
        longi = prefs.getString('longi') ?? '';
        aid = prefs.getString('aid') ?? "";
        shiftId = prefs.getString('shiftId') ?? "";
        ////print("this is set state "+location_addr1);
        act1 = act;
        // //print(act1);
        streamlocationaddr = globalstreamlocationaddr;

      });


   //// }
  }

  @override
  Widget build(BuildContext context) {
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

  getmainhomewidget() {
    return new WillPopScope(
        onWillPop: () async => true,
        child: new Scaffold(
          key: _scaffoldKey,
          backgroundColor:scaffoldBackColor(),
          endDrawer: new AppDrawer(),
          appBar: new AppHeader(profileimage,showtabbar,orgName),

           /*
          persistentFooterButtons: <Widget>[
            quickLinkList1(),
           ],*/

          bottomNavigationBar:new HomeNavigation(),

        //  endDrawer: new AppDrawer(),
          body: (act1 == '') ? Center(child: loader()) : checkalreadylogin(),
        ));
  }

    checkalreadylogin() {
    ////print("---->"+response.toString());
    if (response == 1) {
      return new IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          underdevelopment(),
          (streamlocationaddr != '') ? mainbodyWidget() : refreshPageWidgit(),
          //(false) ? mainbodyWidget() : refreshPageWidgit(),
          underdevelopment()
        ],
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AskRegisterationPage()),
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
                    SizedBox(width: 20.0,),
                    Icon(
                      Icons.all_inclusive,
                      color: appStartColor(),
                    ),
                    Text(
                      " Fetching location, please wait..",
                      style: new TextStyle(fontSize: 20.0, color: appStartColor()),
                    )
                  ]),
              SizedBox(height: 15.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 20.0,),
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
                  sl.startStreaming(5);
                  startTimer();
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
                  sl.startStreaming(5);
                  startTimer();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Flexitime()),
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
              // foregroundDecoration: BoxDecoration(color:Colors.red ),
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
                //SizedBox(height: MediaQuery.of(context).size.height * .01),
                Text("Flexi Time", style: new TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: appStartColor())),
                SizedBox(height: MediaQuery.of(context).size.height * .02),
                new GestureDetector(
                onTap: () {
                      // profile navigation
                      /* Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));*/
                 },
                  child: new Stack(children: <Widget>[
                  Container(
                         //foregroundDecoration: BoxDecoration(color:Colors.yellow ),
                          width: MediaQuery.of(context).size.height * .18,
                          height: MediaQuery.of(context).size.height * .18,
                          decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                           image: new DecorationImage(
                                fit: BoxFit.fill,
                                image:_checkLoaded ? AssetImage('assets/avatar.png') : profileimage,
                                //image: AssetImage('assets/avatar.png')
                              ))),
                      /*
                      new Positioned(
                      left: MediaQuery.of(context).size.width*.14,
                      top: MediaQuery.of(context).size.height*.11,
                      child: new RawMaterialButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                      },
                      child: new Icon(
                        Icons.edit,
                        size: 18.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 0.5,
                      fillColor: Colors.teal,
                      padding: const EdgeInsets.all(1.0),
                    ),
                  ),*/
                    ]),
                  ),

                  //Image.asset('assets/logo.png',height: 150.0,width: 150.0),
                  // SizedBox(height: 5.0),
                  // getClients_DD(),

                  SizedBox(height: MediaQuery.of(context).size.height * .01),
                  Text("Hi " + globalpersnalinfomap['FirstName'], style: new TextStyle(fontSize: 16.0)),
                 // SizedBox(height: 35.0),
                  //SizedBox(height: MediaQuery.of(context).size.height * .01),
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

/*
  Widget quickLinkList1() {
    return Container(
      color: Colors.green.withOpacity(0.9),
      width: MediaQuery.of(context).size.width * 0.95,
      // padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.03,bottom:MediaQuery.of(context).size.height*0.03, ),
      child: getBulkAttnWid(),
    );
  }*/

  getMarkAttendanceWidgit() {
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20.0),
            getwidget(location_addr1),
          ]),
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
                       startTimer();
                       sl.startStreaming(5);
                       Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Flexitime()),
                        );
                      },
                    )
                  ],

                ),
              ),
            ]) ),

        SizedBox(height:MediaQuery.of(context).size.height *0.05,),

    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      //SizedBox(width: 30.0,),
        new InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FlexiList()),
            );
          },
          child: new Text(
            "Check Flexi Log",
            style: new TextStyle(
              // color: appStartColor(),
                color: Colors.orange[800],
                decoration: TextDecoration.underline,
                fontSize: 17.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
       Text(" "),
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
    return Container(width: 0.0, height: 0.0);
  }

   /*
  Widget getBulkAttnWid() {
    List <Widget> widList = List<Widget>();
     widList.add(Container(
        padding: EdgeInsets.only(top: 10.0),
        constraints: BoxConstraints(
          maxHeight: 60.0,
          minHeight: 20.0,
        ),
        child: new GestureDetector(
            onTap: () {
              startTimer();
              sl.startStreaming(5);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FlexiList()),
              );
            },
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 30.0,
                  color: Colors.white,
                ),
                Text('Log',
                    textAlign: TextAlign.center,
                    style:
                    new TextStyle(fontSize: 15.0, color: Colors.white)),
              ],
            )),
      ));
    /* widList.add();
    widList.add();*/
    return (Row(children: widList,mainAxisAlignment: MainAxisAlignment.spaceEvenly,));
  }*/

  getFlexiInButton() {
    return RaisedButton(
      child: Text('TIME IN',
          style: new TextStyle(fontSize: 22.0, color: Colors.white)),
      color: Colors.orange[800],
      onPressed: () {
       // if(_clientname.text=='') {
       //   showInSnackBar('Please insert client name first');
        //  return false;
       // }else
          saveFlexiImage();
      },
    );
  }


  getFlexioutButton() {
    return  RaisedButton(
        child: const Text('TIME OUT',style: TextStyle(color: Colors.white,fontSize: 18),),
        color: Colors.orange[800],
        onPressed: () {

          saveFlexioutImage();
        });
  }

  saveFlexioutImage() async {
    sl.startStreaming(5);
    SaveImage saveImage = new SaveImage();
    bool issave = false;
    setState(() {
      act1 = "";
    });
    print('****************************>>');
    print(streamlocationaddr.toString());


    // Navigator.of(context, rootNavigator: true).pop();
    issave = await saveImage.saveFlexiOut(empid,streamlocationaddr.toString(),fid.toString(),lat,long,orgid);

    if(issave){
      print(issave);
      print("444");
    /*  checkTimeinflexi().then((EmpList) {
        setState(() {
          flexiidsts = EmpList;
          fid = flexiidsts[0].fid;
          flexitimein = flexiidsts[0].sts;

        });
      });*/
      showDialog(context: context, child:
      new AlertDialog(
        content: new Text("Attendance punched successfully!"),
      )
      );
      await new Future.delayed(const Duration(seconds: 2));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FlexiList()),
      );
      setState(() {
        act1 = act;
      });
    }else{
      showDialog(context: context, child:
      new AlertDialog(
        content: new Text('Unable to punch attendance.'),
      )
      );
      //showInSnackBar('Unable to punch attendance');
      setState(() {
        act1 = act;
      });
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
      /*return new  Text('Location is restricted from app settings, click here to allow location permission and refresh', textAlign: TextAlign.center, style: new TextStyle(fontSize: 14.0,color: Colors.red));*/
    }
  }

  saveFlexiImage() async {
    print('------------*11');
    sl.startStreaming(5);
   // client = _clientname.text;
    client ="";
    MarkVisit mk = new MarkVisit(
        empid,client, streamlocationaddr, orgdir, lat, long);
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
      issave = await saveImage.saveFlexi(mk);
      ////print(issave);
      if (issave) {
       /* checkTimeinflexi().then((EmpList) {
          setState(() {
            flexiidsts = EmpList;
            fid = flexiidsts[0].fid;
            flexitimein = flexiidsts[0].sts;

            print("id and sts1");
            print(fid);
            print(flexitimein);

          });
        });*/
        showDialog(context: context, child:
        new AlertDialog(
          content: new Text("Attendance punched successfully!"),
        )
        );
        await new Future.delayed(const Duration(seconds: 2));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FlexiList()),
        );

        setState(() {
          act1 = act;
        });
      } else {
        showDialog(context: context, child:
        new AlertDialog(
          title: new Text("Warning!"),
          content: new Text("Problem while punching Attendance, try again."),
        )
        );
        setState(() {
          act1 = act;
        });
      }
    }else {
      showDialog(context: context, child:
      new AlertDialog(
        content: new Text("Internet connection not found."),
      )
      );
    }






    /*SaveImage saveImage = new SaveImage();
    bool issave = false;
    setState(() {
      act1 = "";
    });
    issave = await saveImage.saveTimeInOut(mk);
    ////print(issave);
    if (issave) {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
      setState(() {
        act1 = act;
      });
    } else {
      setState(() {
        act1 = act;
      });
    }*/
  }

/*  saveImage() async {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraApp()),
      );

  }*/

  resendVarification() async{
    NewServices ns= new NewServices();
    bool res = await ns.resendVerificationMail(orgid);
    if(res){
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              content: Row(children:<Widget>[
                Text("Verification link has been sent to \nyour organization's registered Email."),
              ]
              )
          )
      );
    }
  }

////////////////////////////////////////////////////////////
 /* Widget getClients_DD() {

    return Center(
      child: Form(
        child: TextFormField(
          controller: _clientname,

          keyboardType: TextInputType.text,

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
*/

////////////////////////////////////////////////////////////
}
