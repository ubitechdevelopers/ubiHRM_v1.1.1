// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/model/model.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/services/services.dart';
import 'package:ubihrm/services/timeoff_services.dart';
import 'package:ubihrm/timeoff/timeoff_timer.dart';

import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
import '../home.dart';
import '../login_page.dart';
import '../profile.dart';
import 'teamtimeoffsummary.dart';
import 'timeoff.dart';


// This app is a stateful, it tracks the user's current choice.
class TimeoffSummary extends StatefulWidget {
  @override
  final String time;
  TimeoffSummary({Key key, this.time})
      : super(key: key);
  _TimeoffSummary createState() => _TimeoffSummary();
}

class _TimeoffSummary extends State<TimeoffSummary> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var profileimage;
  bool showtabbar;
  String orgName="";


  bool _checkwithdrawntimeoff = false;
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
    showtabbar=false;
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoaded = false;
        });
      }
    }));
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
  initPlatformState() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mainWidget = loadingWidget();
    });
    String id = prefs.getString('expenseid')??"";
    //String empid = prefs.getString('employeeid')??"";
    //String organization =prefs.getString('organization')??"";
    islogin().then((Widget configuredWidget) {
      setState(() {
        mainWidget = configuredWidget;
      });
    });
  }

  Widget loadingWidget(){
    return Center(child:SizedBox(
      child:
      Text("Loading..", style: TextStyle(fontSize: 10.0,color: Colors.white),),
    ));
  }

  withdrawlTimeOff(String timeoffid) async{
    try {
      setState(() {
        _checkwithdrawntimeoff = true;
      });
      final prefs = await SharedPreferences.getInstance();
      String empid = prefs.getString('employeeid') ?? "";
      String orgid = prefs.getString('organization') ?? "";
      print("orgid");
      print(orgid);
      RequestTimeOffService ns = new RequestTimeOffService();
      var timeoff = TimeOff(TimeOffId: timeoffid, OrgId: orgid, EmpId: empid, ApprovalSts: '5');
      var islogin = await ns.withdrawTimeOff(timeoff);
      print("islogin");
      print(islogin);
      if (islogin == "success") {
        setState(() {
          _isButtonDisabled = false;
          _checkwithdrawntimeoff = false;
        });
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
              content: new Text("Time Off withdrawn successfully."),
            );
          });
        // ignore: deprecated_member_use
        /*showDialog(context: context, child:
        new AlertDialog(
          content: new Text("Time Off application withdrawn successfully."),
        )
        );*/
      } else if (islogin == "failure") {
        setState(() {
          _isButtonDisabled = false;
          _checkwithdrawntimeoff = false;
        });
        showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: new Text("Time Off could not be withdrawn."),
            );
          });
        // ignore: deprecated_member_use
        /*showDialog(context: context, child:
        new AlertDialog(
          content: new Text("Time Off could not be withdrawn."),
        )
        );*/
      } /*else {
        setState(() {
          _isButtonDisabled = false;
        });
        // ignore: deprecated_member_use
        showDialog(context: context, child:
        new AlertDialog(
          //title: new Text("Sorry!"),
          content: new Text("Poor network connection."),
        )
        );
      }*/
    }catch(e){
      print(e.toString());
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            content: new Text("Poor network connection."),
          );
        });
      /*showDialog(context: context, child:
      new AlertDialog(
        content: new Text("Poor network connection."),
      )
      );*/
    }
  }

  confirmWithdrawl(String timeoffid) async{
    showDialog(context: context, child:
    new AlertDialog(
      title: new Text("Withdraw Time Off?",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18.0),),
      content:  ButtonBar(
        children: <Widget>[
          RaisedButton(
            child:_checkwithdrawntimeoff?Text('Processing..',style: TextStyle(color: Colors.white),):Text('Withdraw',style: TextStyle(color: Colors.white),),
            color: Colors.orange[800],
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              withdrawlTimeOff(timeoffid);
            },
          ),
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
        ],
      ),
    )
    );
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value, textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return  getmainhomewidget();
  }

  Future<Widget> islogin() async{
    final prefs = await SharedPreferences.getInstance();
    int response = prefs.getInt('response')??0;
    if(response==1){
      return getmainhomewidget();
    }else{
      return new LoginPage();
    }
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
    return WillPopScope(
      onWillPop: ()=> sendToHome(),
      child: RefreshIndicator(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor:scaffoldBackColor(),
          endDrawer: new AppDrawer(),
          appBar: new TimeOffAppHeader(profileimage,showtabbar,orgName),
          bottomNavigationBar:  new HomeNavigation(),
          body: ModalProgressHUD(
              inAsyncCall: _checkwithdrawntimeoff,
              opacity: 0.15,
              progressIndicator: SizedBox(
                child:new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation(Colors.green),
                    strokeWidth: 5.0),
                height: 40.0,
                width: 40.0,
              ),
              child: getMarkAttendanceWidgit()
          ),
          //body:getMarkAttendanceWidgit(),
          floatingActionButton: new FloatingActionButton(
            backgroundColor: Colors.orange[800],
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimeOffPage()),
              );
            },
            tooltip: 'Request Time Off',
            child: new Icon(Icons.add),
          ),
        ),
        onRefresh: () async {
          Completer<Null> completer = new Completer<Null>();
          await Future.delayed(Duration(seconds: 1)).then((onvalue) {
            getTimeOffSummary();
            completer.complete();
          });
          return completer.future;
        },
      ),
    );
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

  Widget getMarkAttendanceWidgit() {
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
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex:48,
                          child:Column(
                              children: <Widget>[
                                // width: double.infinity,
                                //height: MediaQuery.of(context).size.height * .07,
                                SizedBox(height:MediaQuery.of(context).size.width*.02),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                          Icons.person,
                                          color: Colors.orange[800],
                                          size: 22.0 ),
                                      GestureDetector(
                                        onTap: () {
                                          false;
                                        },

                                        child: Text(
                                            'Self',
                                            style: TextStyle(fontSize: 18,color: Colors.orange[800],fontWeight:FontWeight.bold)
                                        ),
                                      ),
                                    ]),

                                SizedBox(height:MediaQuery.of(context).size.width*.036),
                                Divider(
                                  color: Colors.orange[800],
                                  height: 0.4,
                                ),
                                Divider(
                                  color: Colors.orange[800],
                                  height: 0.4,
                                ),
                                Divider(
                                  color: Colors.orange[800],
                                  height: 0.4,
                                ),
                              ]
                          ),
                        ),

                        Expanded(
                          flex:48,
                          child:InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TeamTimeoffSummary()),
                              );
                            },
                            child: Column(
                              // width: double.infinity,
                                children: <Widget>[
                                  SizedBox(height:MediaQuery.of(context).size.width*.02),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                            Icons.group,
                                            color: Colors.orange[800],
                                            size: 22.0 ),
                                        GestureDetector(

                                          child: Text(
                                              'Team',
                                              style: TextStyle(fontSize: 18,color: Colors.orange[800])
                                          ),
                                        ),
                                      ]),
                                  SizedBox(height:MediaQuery.of(context).size.width*.04),
                                ]
                            ),
                          ),
                        )
                      ]
                  ),

                  Container(
                    padding: EdgeInsets.only(top:12.0),
                    child:Center(
                      child:Text('My Time Off',
                        style: new TextStyle(fontSize: 18.0, color: Colors.black87,),textAlign: TextAlign.center,),
                    ),
                  ),

                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20.0,),
                      //SizedBox(width: MediaQuery.of(context).size.width*0.02),
                      new Expanded(
                        child:  Container(
                          width: MediaQuery.of(context).size.width*0.50,
                          child:Text('Date',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                        ),),

                      new Expanded(
                        child:  Container(
                          width: MediaQuery.of(context).size.width*0.50,
                          margin: EdgeInsets.only(left:32.0),
                          padding: EdgeInsets.only(right:12.0),
                          child:Text('Action',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),textAlign: TextAlign.right,),
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
                      child: new FutureBuilder<List<TimeOff>>(
                        future: getTimeOffSummary(),
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
                                            //crossAxisAlignment: CrossAxisAlignment.start,
                                            //mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[

                                              new Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(0.0,0.0,10.0,0.0),
                                                  child: Container(
                                                    height: MediaQuery .of(context).size.height * 0.04,
                                                    width: MediaQuery .of(context).size.width * 0.60,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        new Text(snapshot.data[index].TimeofDate.toString(),style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                                      ],
                                                    )
                                                  ),
                                                ),
                                              ),

                                              (snapshot.data[index].starticonsts)?
                                              InkWell(
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                                                  child: Container(
                                                    height: 30,
                                                    width: 65,
                                                    decoration: BoxDecoration(
                                                        color: Colors.orange[800],
                                                    ),
                                                    child: Center(child: Text("Start",style: TextStyle(fontSize:15.0,fontWeight:FontWeight.bold,color: Colors.white),)),
                                                  ),
                                                ),
                                                onTap: (){
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => TimeOffTimer(
                                                      timeoffId: snapshot.data[index].TimeOffId.toString(),
                                                      action: "Start"
                                                    )),
                                                  );
                                                },
                                              ):Center(),

                                              (snapshot.data[index].stopiconsts)?
                                              InkWell(
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                                                  child: Container(
                                                    height: 30,
                                                    width: 65,
                                                    decoration: BoxDecoration(
                                                        color: Colors.orange[800],
                                                        border: Border.all(color: Colors.orange[800],width: 1)
                                                    ),
                                                    child: Center(child: Text("End",style: TextStyle(fontSize:15.0,fontWeight:FontWeight.bold,color: Colors.white),)),
                                                  ),),
                                                onTap: (){
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => TimeOffTimer(
                                                      timeoffId: snapshot.data[index].TimeOffId.toString(),
                                                      action: "Stop"
                                                    )),
                                                  );
                                                },
                                              ):Center(),

                                              (snapshot.data[index].withdrawlsts)?
                                              InkWell(
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                                                  child: Container(
                                                    height: MediaQuery .of(context).size.height * 0.04,
                                                    //margin: EdgeInsets.only(left:40.0),
                                                    //padding: EdgeInsets.only(left:40.0),
                                                    width: MediaQuery .of(context).size.width * 0.13,
                                                    child: new OutlineButton(
                                                      child:new Icon(Icons.replay, size: 22.0,color:appStartColor(), ),
                                                      borderSide: BorderSide(color: appStartColor()),
                                                      onPressed: () {
                                                        if(_isButtonDisabled)
                                                          return null;
                                                        setState(() {
                                                          _isButtonDisabled=true;
                                                          checkProcessing = index;
                                                        });
                                                        confirmWithdrawl(snapshot.data[index].TimeOffId.toString());
                                                      },
                                                      shape: new CircleBorder(),
                                                    ),
                                                  ),
                                                ),
                                              ):Center(),
                                            ],
                                          ),
                                          //SizedBox(width: 30.0,),

                                          snapshot.data[index].TimeFrom.toString()!='-'?Container(
                                            width: MediaQuery.of(context).size.width*.70,
                                            //padding: EdgeInsets.only(top:1.5,bottom: 0.5),
                                            //margin: EdgeInsets.only(top: 4.0),
                                            child: Text('Requested Duration: '+snapshot.data[index].TimeFrom.toString()+' - '+snapshot.data[index].TimeTo.toString(), style: TextStyle(fontSize: 12.0,color: Colors.black54),),
                                          ):Center(),

                                          snapshot.data[index].Reason.toString()!='-'?Container(
                                            width: MediaQuery.of(context).size.width*.70,
                                            //padding: EdgeInsets.only(top:1.5,bottom: 0.5),
                                            margin: EdgeInsets.only(top: 4.0),
                                            child: Text('Reason: '+snapshot.data[index].Reason.toString(),overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0,color: Colors.black54, ),),
                                          ):Center(),


                                          snapshot.data[index].StartTimeFrom.toString()!='-'?Container(
                                            width: MediaQuery.of(context).size.width*.70,
                                            //padding: EdgeInsets.only(top:1.5,bottom: 0.5),
                                            margin: EdgeInsets.only(top: 4.0),
                                            child: Text(snapshot.data[index].StopTimeTo.toString()=='-'?'Actual Time Off Start: '+snapshot.data[index].StartTimeFrom.toString():'Actual Duration: '+snapshot.data[index].StartTimeFrom.toString()+' - '+snapshot.data[index].StopTimeTo.toString(), style: TextStyle(fontSize: 12.0,color: Colors.black54),),
                                          ):Center(),

                                          snapshot.data[index].TimeOffSts.toString()!='null'?Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            //padding: EdgeInsets.only(top:1.5,bottom: 0.5),
                                            margin: EdgeInsets.only(top: 4.0),
                                            child: Text('Time Off Status: '+snapshot.data[index].TimeOffSts.toString(), style: TextStyle(fontSize: 12.0,color: Colors.black54),),
                                          ):Center(),

                                          (snapshot.data[index].ApprovalSts.toString()!='-' && snapshot.data[index].ApprovalSts.toString()!='Withdrawn')?Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            //padding: EdgeInsets.only(top:1.5,bottom: 1.5),
                                            margin: EdgeInsets.only(top: 4.0),
                                            child: RichText(
                                              text: new TextSpan(
                                                style: new TextStyle(
                                                  fontSize: 13.5,
                                                  color: Colors.black54,
                                                ),
                                                children: <TextSpan>[
                                                  new TextSpan(text: 'Approval Status: ',style:TextStyle(fontSize: 13.5,color: Colors.black54,), ),
                                                  new TextSpan(text: snapshot.data[index].ApprovalSts.toString(), style: TextStyle(color: snapshot.data[index].ApprovalSts.toString()=='Approved'?appStartColor() :snapshot.data[index].ApprovalSts.toString()=='Rejected' || snapshot.data[index].ApprovalSts.toString()=='Cancel' ?Colors.red:snapshot.data[index].ApprovalSts.toString().startsWith('Pending')?Colors.orange[800]:Colors.blue[600], fontSize: 13.5),),
                                                ],
                                              ),
                                            ),
                                          ):Center(),

                                          snapshot.data[index].ApproverComment.toString()!='-'?Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            //padding: EdgeInsets.only(top:1.5,bottom: 0.5),
                                            margin: EdgeInsets.only(top: 3.0),
                                            child: Text('Comment: '+snapshot.data[index].ApproverComment.toString(), style: TextStyle(fontSize: 12.0,color: Colors.black54), ),
                                          ):Center(),

                                          snapshot.data[index].StartLoc.toString()!='-'?Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: InkWell(
                                                  child: Container(
                                                    //width: MediaQuery.of(context).size.width*.90,
                                                    //padding: EdgeInsets.only(top:1.5,bottom: 1.5),
                                                    margin: EdgeInsets.only(top: 4.0),
                                                    child: Text('Start Location: '+snapshot.data[index].StartLoc.toString()+'...', style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 12.0),overflow: TextOverflow.ellipsis,maxLines: 1,),
                                                  ),
                                                  onTap: () {
                                                    goToMap(snapshot.data[index].LatIn, snapshot.data[index].LongIn);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ):Center(),

                                          snapshot.data[index].EndLoc.toString()!='-'?Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: InkWell(
                                                  child: Container(
                                                    //width: MediaQuery.of(context).size.width*.90,
                                                    //padding: EdgeInsets.only(top:1.5,bottom: 1.5),
                                                    margin: EdgeInsets.only(top: 4.0),
                                                    child: Text('End Location: '+snapshot.data[index].EndLoc.toString(), style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 12.0),overflow: TextOverflow.ellipsis,maxLines: 1,),
                                                  ),
                                                  onTap: () {
                                                    goToMap(snapshot.data[index].LatOut , snapshot.data[index].LongOut);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ):Center(),

                                          Divider(color: Colors.black54,),
                                        ]
                                    );
                                  }
                              );
                            }else
                              return new Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width*1,
                                  color: appStartColor().withOpacity(0.1),
                                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                  child:Text("You have not taken any time off",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
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
}

class TimeOffAppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;
  TimeOffAppHeader(profileimage1,showtabbar1,orgname1){
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

