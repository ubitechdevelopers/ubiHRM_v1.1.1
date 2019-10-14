// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:ubihrm/services/attandance_fetch_location.dart';
//import 'package:simple_permissions/simple_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'login.dart';
import 'dart:convert';
import 'package:ubihrm/services/salary_services.dart';
//import 'attendance_summary.dart';
import '../home.dart';
import 'dart:async';
import 'package:ubihrm/services/attandance_fetch_location.dart';
import 'package:ubihrm/timeoff/timeoff.dart';
import 'package:ubihrm/services/timeoff_services.dart';
import 'package:ubihrm/model/model.dart';
//import 'settings.dart';
import '../profile.dart';
//import 'reports.dart';
import '../b_navigationbar.dart';
import '../global.dart';
import '../drawer.dart';
import '../appbar.dart';
import 'package:url_launcher/url_launcher.dart';


// This app is a stateful, it tracks the user's current choice.
class allSalarySummary extends StatefulWidget {
  @override
  _allSalarySummary createState() => _allSalarySummary();
}

class _allSalarySummary extends State<allSalarySummary> {
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

  getOrgName() async{
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
  //  if (response == 1) {
  //    Loc lock = new Loc();
  //    location_addr = await lock.initPlatformState();
      //act =await checkPunch(empid, orgdir);

      //act= 'PunchOut';

      setState(() {
  //      location_addr1 = location_addr;
   //    response = prefs.getInt('response') ?? 0;
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
    //    act= lid!='0'?'PunchOut':'PunchIn';
        showtabbar=false;
        profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
        profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __){
          if (mounted) {
            setState(() {
              _checkLoaded = false;
            });
          }
        }));
   //     latit = prefs.getString('latit') ?? '';
  //      longi = prefs.getString('longi') ?? '';
  //      shiftId = prefs.getString('shiftId') ?? "";
  //      print("this is set state " + lid);
   //     act1 = act;
      });
//    }
  }

  withdrawlTimeOff(String timeoffid) async{
    RequestTimeOffService ns = new RequestTimeOffService();

    var timeoff = TimeOff(TimeOffId: timeoffid, OrgId: orgid, EmpId: empid, ApprovalSts: '5');
    var islogin = await ns.withdrawTimeOff(timeoff);
   // print(islogin);
    if(islogin=="success"){
      setState(() {
        _isButtonDisabled=false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => allSalarySummary()),
      );

    }else if(islogin=="failure"){
      setState(() {
        _isButtonDisabled=false;
      });
      showDialog(context: context, child:
      new AlertDialog(
        title: new Text("Sorry!"),
        content: new Text("Timeoff withdrawl failed."),
      )
      );
    }else{
      setState(() {
        _isButtonDisabled=false;
      });
      showDialog(context: context, child:
      new AlertDialog(
        title: new Text("Sorry!"),
        content: new Text("Poor network connection."),
      )
      );
    }
  }

  confirmWithdrawl(String timeoffid) async{
    showDialog(context: context, child:
    new AlertDialog(
      title: new Text("Are you sure?",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18.0),),
      content:  ButtonBar(
        children: <Widget>[
          FlatButton(
            shape: Border.all(color: Colors.orange[800]),
            child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
            onPressed: () {
              setState(() {
                _isButtonDisabled=false;
              });
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          RaisedButton(
            child: Text('Withdraw',style: TextStyle(color: Colors.white),),
            color: Colors.orange[800],
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              withdrawlTimeOff(timeoffid);
            },
          ),
        ],
      ),
    )
    );
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:scaffoldBackColor(),
      endDrawer: new AppDrawer(),
      appBar: new AppHeader(profileimage,showtabbar,orgName),

      /*appBar: GradientAppBar(
        automaticallyImplyLeading: false,
        *//*    title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            new Text(org_name, style: new TextStyle(fontSize: 20.0)),

          ],
        ),
        leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },),
        backgroundColor: Colors.teal,*//*
        backgroundColorStart: appStartColor(),
        backgroundColorEnd: appEndColor(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            new Container(
                width: 40.0,
                height: 40.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/avatar.png'),
                    )
                )),
            Container(
                padding: const EdgeInsets.all(8.0), child: Text('UBIHRM')
            )
          ],

        ),

      ),*/
      bottomNavigationBar:  new HomeNavigation(),
      /*     bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          if(newIndex==2){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            );
            return;
          }
          else if (newIndex == 0) {
            (admin_sts == '1')
                ? Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Reports()),
            )
                : Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
            return;
          }
          if(newIndex==1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            return;
          }
          print("Current pressed new indexed "+newIndex.toString());
          setState((){_currentIndex = newIndex;});
        }, // this will be set when a new tab is tapped
        items: [
          (admin_sts == '1')
              ? BottomNavigationBarItem(
            icon: new Icon(
              Icons.library_books,
            ),
            title: new Text('Reports'),
          )
              : BottomNavigationBarItem(
            icon: new Icon(
              Icons.person,
            ),
            title: new Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.home,color: Colors.black54,),
            title: new Text('Home',style:TextStyle(color: Colors.black54,)),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings')
          )
        ],
      ),*/

      // endDrawer: new AppDrawer(),
    //  body: (act1 == '') ? Center(child: loader()) : checkalreadylogin(),
      body:getMarkAttendanceWidgit(),
     /* floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.orange[800],
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TimeOffPage()),
          );
        },
        tooltip: 'Request TimeOff',
        child: new Icon(Icons.add),
      ),*/
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
       //     height:MediaQuery.of(context).size.height*0.75,
            decoration: new ShapeDecoration(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
              color: Colors.white,
            ),
            child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Salary',
                      style: new TextStyle(fontSize: 22.0, color: appStartColor())),
                  //SizedBox(height: 10.0),

                  new Divider(color: Colors.black54,height: 1.5,),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 50.0,),
                      new Expanded(
                        child:  Container(
                          width: MediaQuery.of(context).size.width*0.40,
                          child:Text('Name',style: TextStyle(color:Colors.orange[800],fontWeight:FontWeight.bold,fontSize: 16.0),),
                        ),),
                 //     SizedBox(width: MediaQuery.of(context).size.width*0.02),
                      new Expanded(
                        child:  Container(
                        width: MediaQuery.of(context).size.width*0.25,
                          margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child:Text('Month',style: TextStyle(color: Colors.orange[800],fontWeight:FontWeight.bold,fontSize: 16.0),),
                      ),),

                  //    SizedBox(height: 50.0,),
                      new Expanded(
                        child:  Container(
                        width: MediaQuery.of(context).size.width*0.17,
                        margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child:Text('Amount',style: TextStyle(color: Colors.orange[800],fontWeight:FontWeight.bold,fontSize: 16.0),textAlign: TextAlign.right),
                      ),),

                  //    SizedBox(height: 50.0,),
                     /* new Expanded(
                        child:  Container(
                        width: MediaQuery.of(context).size.width*0.17,
                          margin: EdgeInsets.only(left:9.0),
                        child:Text('Days',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                      ),),*/

                      new Expanded(
                        child:  Container(
                        width: MediaQuery.of(context).size.width*0.20,
                        margin: EdgeInsets.only(left:30.0),
                        child:Text('Action',style: TextStyle(color:Colors.orange[800],fontWeight:FontWeight.bold,fontSize: 16.0),),
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
                      future: getsalarySummaryAll(),
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
                                         width: MediaQuery.of(context).size.width * 0.25,
                                                //margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                        snapshot.data[index].name.toString(),style:TextStyle()),),),
                                            new Expanded(
                                            child: Container(
                                            width: MediaQuery.of(context).size.width * 0.25,
                                                margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                                           child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,                                              children: <Widget>[
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
                                           width: MediaQuery.of(context).size.width * 0.20,
                                           margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                                           child:  Text(
                                           snapshot.data[index].EmployeeCTC.toString()+" "+snapshot.data[index].Currency.toString(),style:TextStyle(),  textAlign: TextAlign.right,),),),

                                        /*    new Expanded(
                                              child: Container(
                                              width: MediaQuery.of(context).size.width * 0.15, margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                                              child:  Text(
                                                  snapshot.data[index].paid_days.toString(),style:TextStyle(fontWeight: FontWeight.bold)),
                                            ),),*/
                                            new Expanded(

                                            child: Container(
                                              width: MediaQuery.of(context) .size .width * 0.30,margin: EdgeInsets.only(left:30.0),
                                             height: 28.0,
                                                child: new OutlineButton(
                                                  onPressed: () {

                                                    print(path+"viewpayslip/"+snapshot.data[index].id.toString()+"/1/"+orgdir+"/"+empid);
                                                    launchMap(path+"viewpayslip/"+snapshot.data[index].id.toString()+"/1/"+orgdir+"/"+empid);

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
                                child:Text("No Records",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                              ),
                            );
                        } else if (snapshot.hasError) {
                          return new Text("Unable to connect server");
                        }

                        // By default, show a loading spinner
                        return new Center( child: CircularProgressIndicator());
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

