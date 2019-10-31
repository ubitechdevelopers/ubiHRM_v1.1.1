// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:ubihrm/services/attandance_fetch_location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../profile.dart';
import 'askregister.dart';
import 'package:ubihrm/services/attandance_gethome.dart';
import 'package:ubihrm/services/attandance_saveimage.dart';
import 'package:ubihrm/model/timeinout.dart';
import 'attendance_summary.dart';
import '../drawer.dart';
import 'package:ubihrm/services/services.dart';
import 'package:ubihrm/services/attandance_newservices.dart';
import '../global.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity/connectivity.dart';
import 'package:ubihrm/b_navigationbar.dart';
import '../home.dart';



// This app is a stateful, it tracks the user's current choice.
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamLocation sl = new StreamLocation();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  /*var _defaultimage =
      new NetworkImage("http://ubiattendance.ubihrm.com/assets/img/avatar.png");*/
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



  @override
  void initState() {
    super.initState();

    initPlatformState();
    getOrgName();
    setLocationAddress();
    startTimer();

  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    if(mounted) {
      setState(() {
        orgName = prefs.getString('orgname') ?? '';
      });
    }
  }


 /* @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }*/
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
        //print("home addr" + streamlocationaddr);
        //print(lat + ", " + long);

        //print(stopstreamingstatus.toString());
      });
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

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {

    /*await availableCameras();*/
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    //   print("employeeid---"+empid);
    desinationId = globalcompanyinfomap['Designation'];
    response = prefs.getInt('response') ?? 0;

    //var timeout=  await getLastTimeout();

    // print(timeout);
    // print("******");
    // if (response == 1) {
    Loc lock = new Loc();
    location_addr = await lock.initPlatformState();
    print(location_addr);

    Home ho = new Home();
    act = await ho.checkTimeIn(empid, orgdir);
    print(act);
    ho.managePermission(empid, orgdir, desinationId);
    // //print(act);
    ////print("this is-----> "+act);
    ////print("this is main "+location_addr);
    if(mounted) {
    setState(() {
      Is_Delete = prefs.getInt('Is_Delete') ?? 0;
      newpwd = prefs.getString('newpwd') ?? "";
      userpwd = prefs.getString('usrpwd') ?? "";
      //  print("New pwd"+newpwd+"  User ped"+userpwd);
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
      //       profile = prefs.getString('profile') ?? '';
      //      profileimage = new NetworkImage( profile);
      profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);

      //      print("ABCDEFGHI-"+profile);

      profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
        if (mounted) {
          setState(() {
            _checkLoaded = false;
          });
        }
      }));
      showtabbar = false;
      //    print("ABCDEF"+fname);
      latit = prefs.getString('latit') ?? '';
      longi = prefs.getString('longi') ?? '';
      aid = prefs.getString('aid') ?? "";
      shiftId = prefs.getString('shiftId') ?? "";
      ////print("this is set state "+location_addr1);
      act1 = act;
      //    print("ABC"+act1);
      streamlocationaddr = globalstreamlocationaddr;

      perPunchLocation = getModulePermission("305", "view");
    });
  }
    //}
  }

  @override
  Widget build(BuildContext context) {
    (mail_varified=='0' && alertdialogcount==0 && admin_sts=='1')?Future.delayed(Duration.zero, () => _showAlert(context)):"";
 //act1=='1'?_showAlertbeforeTimeOut(context):"";
    //return (response == 0 || userpwd!=newpwd || Is_Delete!=0) ? new AskRegisterationPage//() :

   return getmainhomewidget();

    /* return MaterialApp(
      home: (response==0) ? new AskRegisterationPage() : getmainhomewidget(),
    );*/
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
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );*/
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

/*          appBar: GradientAppBar(
            backgroundColorStart: appStartColor(),
            backgroundColorEnd: appEndColor(),
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

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
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            // image: AssetImage('assets/avatar.png'),
                            image: _checkLoaded ? AssetImage('assets/avatar.png') : profileimage,

                          )
                      )),),
                Container(
                    padding: const EdgeInsets.all(8.0), child: Text('UBIHRM')
                )
              ],

            ),
          ),*/
          bottomNavigationBar:new HomeNavigation(),
       // endDrawer: new AppDrawer(),
        body: (act1 == '') ? Center(child: loader()) : checkalreadylogin(),
        //bottomSheet: getQuickLinksWidget(),


       /* persistentFooterButtons: <Widget>[
          quickLinkList1(),
        ], */  // body: homewidget()


      )

    );
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

   /* if(userpwd!=newpwd){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AskRegisterationPage()),
            (Route<dynamic> route) => false,
      );
    }*/
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
                      "Fetching location, please wait..",
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
                  sl.startStreaming(5);
                  print("shaifali-----------");
                  startTimer();
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
              // foregroundDecoration: BoxDecoration(color:Colors.red ),
              height: MediaQuery.of(context).size.height * 0.80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * .02),
                  new GestureDetector(
                    onTap: () {
                      // profile navigation
                      /* Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));*/
                    },
                    child: new Stack(children: <Widget>[
                      Container(
                          //   foregroundDecoration: BoxDecoration(color:Colors.yellow ),
                          width: MediaQuery.of(context).size.height * .18,
                          height: MediaQuery.of(context).size.height * .18,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image:_checkLoaded ? AssetImage('assets/avatar.png') : profileimage,
                               //image: AssetImage('assets/avatar.png')
                              ))),
                 /*     new Positioned(
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
                  SizedBox(height: MediaQuery.of(context).size.height * .02),
                  //Image.asset('assets/logo.png',height: 150.0,width: 150.0),
                  // SizedBox(height: 5.0),
                  Text("Hi " + globalpersnalinfomap['FirstName'], style: new TextStyle(fontSize: 16.0)),
                  //SizedBox(height: MediaQuery.of(context).size.height * .001),
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
        // height: MediaQuery.of(context).size.height*0.5,
        //foregroundDecoration: BoxDecoration(color:Colors.green ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              /* Text('Mark Attendance',
                style: new TextStyle(fontSize: 30.0, color: Colors.teal)),
            SizedBox(height: 10.0),*/
              getwidget(location_addr1),
              //    SizedBox(height: MediaQuery.of(context).size.height*.1),

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
        child: Text(
          '\nToday\'s attendance is marked successfully.',
          textAlign: TextAlign.center,
          style: new TextStyle(color: Colors.black87, fontSize: 15.0),
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
          //SizedBox(width: 30.0,),
          new InkWell(
            child: new Text(
              "Check Attendance Log",
              style: new TextStyle(
                 // color: appStartColor(),
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
      /*SizedBox(height: MediaQuery.of(context).size.height*.25),
          Container(
            height: MediaQuery.of(context).size.height*.10,
            color: Colors.teal.withOpacity(0.8),
            child: Column(
                children:[
                  SizedBox(height: 10.0,),
                  getQuickLinksWidget()
                ]
            ),
          )*/
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
            //color: Colors.teal.withOpacity(0.1),
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
                  /* Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );*/
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
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                    )
                  ],
                ),
              ),
            ])),

        SizedBox(height:MediaQuery.of(context).size.height *0.05,),

    /*new SizedBox(
    width: double.infinity,
      height: MediaQuery.of(context).size.height * .08,
       child: FlatButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Att_tab()),
            );
          },
          child: const Text(
              'Attendance Log',
              style: TextStyle(fontSize: 18,color: Colors.white,)
          ),
          color: Colors.orange[800],
           splashColor: Colors.orange[800],

          /* shape: new RoundedRectangleBorder(
               borderRadius: new BorderRadius.circular(0.0))*/
        ),
      ),*/

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
            //print("hello-------------");
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
          // //print("Time out button pressed");
         // _showAlertbeforeTimeOut(context);

         saveImage();

          //Navigator.pushNamed(context, '/home');
        },
      );
    } else if (act1 == 'TimeOut' ) {
      return RaisedButton(
        child: Text('TIME OUT',
            style: new TextStyle(fontSize: 22.0, color: Colors.white)),
        color: Colors.orange[800],
        onPressed: () {
          // //print("Time out button pressed");
          saveImage();
        },
      );
    }


   /*  else if(act1=='1')  {
   // return  _showAlertbeforeTimeOut(context);

  return  Container(
        child: Text('TIME OUT1',
            style: new TextStyle(fontSize: 22.0, color: Colors.white)),
        color: Colors.orange[800],

      );
    }*/
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

  saveImage() async {
    sl.startStreaming(5);

    MarkTime mk = new MarkTime(
        empid, streamlocationaddr, aid, act1, shiftId, orgdir, lat, long);
   /* mk1 = mk;*/

    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      /* Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraExampleHome()),
      );*/
      SaveImage saveImage = new SaveImage();
      bool issave = false;
      if(mounted) {
      setState(() {
        act1 = "";
      });
    }
      try {
        issave = await saveImage.saveTimeInOutImagePicker(mk);
       //print('------------------>');
       //print(issave);
       //print('------------------>');
        if (issave) {
          showDialog(context: context, child:
          new AlertDialog(
            content: new Text("Attendance marked successfully!"),
          )
          );
         // if(mounted) {

        //  }
          await new Future.delayed(const Duration(seconds: 2));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
          );

         // Home ho = new Home();
         // act = await ho.checkTimeIn(empid, orgdir);
          setState(() {
            act1 = act;
            //  Navigator.of(context, rootNavigator: true).pop('dialog');
          });

        } else {
          print('------------------<<<<<<<<<<<');
          showDialog(context: context, child:
          new AlertDialog(
            title: new Text("Warning!"),
            content: new Text("Problem while marking attendance, try again."),
          )
          );
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

 /*_showAlertwidget() {
 return  new
 Column(
       children: <Widget>[

    Center(

 child: Row(
     mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: <Widget>[

     SizedBox(width: 5.0),
   Expanded(
   child:Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: <Widget>[

   Container(
    // padding: EdgeInsets.fromLTRB(4.0, 3.0,4.0,0.0),
     // margin: EdgeInsets.fromLTRB(4.0, 0.0,4.0,0.0),
   //height: insideContainerHeight,
   width: 500.0,
     child:Text("You have not marked Time Out yesterday. ",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),

   ),

 ])

  )]
 )

    ),


   ButtonTheme(
   minWidth: 100.0,
   height: 20.0,
   child:  new FlatButton(
     //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
     //   shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
     //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
     padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 10.0),
     child: Container(
   //     padding: EdgeInsets.only(left:  5.0),
       child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: <Widget>[

           SizedBox(width: 5.0),
           Container(
             child: Icon(Icons.radio_button_checked,size: 20.0,color: Colors.green,),
           ),
           Expanded(
            child:Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 Container(
                     padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
        child: Text("Doing overtime? Punch your Time Out now.",style: TextStyle(fontSize: 16.0),)
                 ),

               ],
             ),
           ),

       ],
       ),
     ),
     color: Colors.white,
     //elevation: 4.0,
     //  splashColor: Colors.orangeAccent,
     textColor: Colors.black,
     onPressed: () {


       Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => HomePageTimeOut()),
       );
     },
   ),
   ),
   ButtonTheme(
     minWidth: 100.0,
     height: 40.0,
     child:  new FlatButton(
       //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
       //   shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
       //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
       padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
       child: Container(
       child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: <Widget>[
           SizedBox(width: 5.0),
           Container(
             child: Icon(Icons.radio_button_unchecked,size: 20.0,color: Colors.orange,),
           ),
             Expanded(
             child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[
                 Container(
                     padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                 child: Text("Forgot to punch Timeout? Punch Time In now.",style: TextStyle(fontSize: 16.0),)
                   ),
                 ],
               ),
             ),

           ],
         ),
       ),
       color: Colors.white,
       //elevation: 4.0,
       //  splashColor: Colors.orangeAccent,
       textColor: Colors.black,
       onPressed: () {

         Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => HomePageTimeIn()),
         );

       },
     ),
   ),
       ]);
   *//* showDialog(
        context: context,
        builder: (context) => AlertDialog(
         // title: Text("Wifi"),
          content: new Text("you have not mark time out yesterday \n Are you doing overtime ? and you forgot to mark timeout?"),
        )
    );*//*
  }*/


}

class AttendanceHomeAppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;
  AttendanceHomeAppHeader(profileimage1,showtabbar1,orgname1){
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

