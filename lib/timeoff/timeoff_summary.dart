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
//import 'package:ubihrm/services/att_services.dart';
//import 'attendance_summary.dart';
import '../home.dart';
import 'dart:async';
import 'package:ubihrm/services/attandance_fetch_location.dart';
import 'timeoff.dart';
import 'package:ubihrm/services/timeoff_services.dart';
import 'package:ubihrm/model/model.dart';
import 'teamtimeoffsummary.dart';
import '../b_navigationbar.dart';
import '../global.dart';
import '../drawer.dart';
import '../appbar.dart';


// This app is a stateful, it tracks the user's current choice.
class TimeoffSummary extends StatefulWidget {
  @override
  _TimeoffSummary createState() => _TimeoffSummary();
}

class _TimeoffSummary extends State<TimeoffSummary> {
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
        profileimage.resolve(new ImageConfiguration()).addListener((_, __) {
          if (mounted) {
            setState(() {
              _checkLoaded = false;
            });
          }
        });
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
        MaterialPageRoute(builder: (context) => TimeoffSummary()),
      );
      showDialog(context: context, child:
      new AlertDialog(
        title: new Text("Withdrawl"),
        content: new Text("Timeoff withdrawn successfully."),
      )
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
            child: Text('CANCEL'),
            shape: Border.all(color: Colors.black54),
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
    return WillPopScope(
      onWillPop: ()=> sendToHome(),
      child: Scaffold(
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

        body:getMarkAttendanceWidgit(),
        floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.orange[800],
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TimeOffPage()),
            );
          },
          tooltip: 'Request TimeOff',
          child: new Icon(Icons.add),
        ),
      ),
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
                                          color: Colors.orange,
                                          size: 22.0 ),
                                      GestureDetector(
                                        onTap: () {
                                          false;
                                        },

                                        child: const Text(
                                            'Self',
                                            style: TextStyle(fontSize: 18,color: Colors.orange,fontWeight:FontWeight.bold)
                                        ),
                                      ),
                                    ]),

                                SizedBox(height:MediaQuery.of(context).size.width*.036),
                                Divider(
                                  color: Colors.orange,
                                  height: 0.4,
                                ),
                                Divider(
                                  color: Colors.orange,
                                  height: 0.4,
                                ),
                                Divider(
                                  color: Colors.orange,
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
                                          color: Colors.orange,
                                          size: 22.0 ),
                                      GestureDetector(

                                        child: const Text(
                                            'Team',
                                            style: TextStyle(fontSize: 18,color: Colors.orange)
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
                          style: new TextStyle(fontSize: 18.0, color: Colors.black87,)),
                    ),
                  ),

                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20.0,),
                 //     SizedBox(width: MediaQuery.of(context).size.width*0.02),
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[

                                            new Expanded(
                                              child: Container(
                                                  height: MediaQuery .of(context).size.height * 0.04,
                                                  width: MediaQuery .of(context).size.width * 0.50,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    new Text(
                                                      snapshot.data[index].TimeofDate.toString(),style: TextStyle(fontWeight: FontWeight.bold),),

                                                  ],
                                                )),),




                                            new Expanded(
                                            child:  Container(
                                              child:Column(
                                                children: <Widget>[
                          //                        new Text(snapshot.data[index].ApprovalSts.toString(), style: TextStyle(color: snapshot.data[index].ApprovalSts.toString()=='Approved'?Colors.green.withOpacity(0.75):snapshot.data[index].ApprovalSts.toString()=='Rejected' || snapshot.data[index].ApprovalSts.toString()=='Cancel' ?Colors.red.withOpacity(0.65):snapshot.data[index].ApprovalSts.toString().startsWith('Pending')?Colors.orange[800]:Colors.black54, fontSize: 14.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),

                                                  (snapshot.data[index].withdrawlsts && snapshot.data[index].ApprovalSts.toString()!='Withdrawn' && snapshot.data[index].ApprovalSts.toString()!="Rejected")?InkWell(
                                                    child: Container(
                                                      height: MediaQuery .of(context).size.height * 0.04,
                                                      margin: EdgeInsets.only(left:32.0),
                                                      padding: EdgeInsets.only(left:32.0),
                                                      width: MediaQuery .of(context).size.width * 0.50,
                                                      child: new OutlineButton(
                                                      child:new Icon(Icons.replay, size: 16.0,color:appStartColor(), ),
                                                      borderSide: BorderSide(color: appStartColor()),

                                                      //  color: Colors.orangeAccent,
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
                                                  ):Center(),

                                                ],
                                              ),
                                            ),
                                          ),

                                            //Divider(),
                                          ],
                                        ),
                                        //SizedBox(width: 30.0,),
                                        Container(
                                          width: MediaQuery.of(context).size.width*.90,
                                          padding: EdgeInsets.only(top:1.5,bottom: 0.5),
                                          margin: EdgeInsets.only(top: 4.0),
                                          child: Text('Duration: '+snapshot.data[index].TimeFrom.toString()+' to '+snapshot.data[index].TimeTo.toString(), style: TextStyle(color: Colors.black54),),
                                        ),

                                        snapshot.data[index].Reason.toString()!='-'?Container(
                                          width: MediaQuery.of(context).size.width*.90,
                                          padding: EdgeInsets.only(top:1.5,bottom: 0.5),
                                          margin: EdgeInsets.only(top: 4.0),
                                          child: Text('Reason: '+snapshot.data[index].Reason.toString(), style: TextStyle(color: Colors.black54),),
                                        ):Center(),
                                 //       new Text(snapshot.data[index].ApprovalSts.toString(), style: TextStyle(color: snapshot.data[index].ApprovalSts.toString()=='Approved'?Colors.green.withOpacity(0.75):snapshot.data[index].ApprovalSts.toString()=='Rejected' || snapshot.data[index].ApprovalSts.toString()=='Cancel' ?Colors.red.withOpacity(0.65):snapshot.data[index].ApprovalSts.toString().startsWith('Pending')?Colors.orange[800]:Colors.black54, fontSize: 14.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),

                                        snapshot.data[index].ApproverComment.toString()!='-'?Container(
                                          width: MediaQuery.of(context).size.width*.90,
                                          padding: EdgeInsets.only(top:1.5,bottom: 0.5),
                                          margin: EdgeInsets.only(top: 3.0),
                                          child: Text('Comment: '+snapshot.data[index].ApproverComment.toString(), style: TextStyle(color: Colors.black54), ),
                                        ):Center(
                                          // child:Text(snapshot.data[index].withdrawlsts.toString()),
                                        ),

                                        snapshot.data[index].ApprovalSts.toString()!='-'?Container(
                                          width: MediaQuery.of(context).size.width*.90,
                                          padding: EdgeInsets.only(top:1.5,bottom: 1.5),
                                          margin: EdgeInsets.only(top: 4.0),
                                          child: RichText(
                                            text: new TextSpan(
                                              // Note: Styles for TextSpans must be explicitly defined.
                                              // Child text spans will inherit styles from parent
                                              style: new TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                                new TextSpan(text: 'Status: ',style:TextStyle(color: Colors.black54,), ),
                                                new TextSpan(text: snapshot.data[index].ApprovalSts.toString(), style: TextStyle(color: snapshot.data[index].ApprovalSts.toString()=='Approved'?appStartColor() :snapshot.data[index].ApprovalSts.toString()=='Rejected' || snapshot.data[index].ApprovalSts.toString()=='Cancel' ?Colors.red:snapshot.data[index].ApprovalSts.toString().startsWith('Pending')?Colors.orange[800]:Colors.blue[600], fontSize: 14.0),),
                                              ],
                                            ),
                                          ),
                                        ):Center(
                                          // child:Text(snapshot.data[index].withdrawlsts.toString()),
                                        ),

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
                                child:Text("you have not taken any time off  ",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
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




  getPunchPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('getPunchPrefs called: new lid- '+ prefs.getString('lid').toString());
    return prefs.getString('lid');
  }


/////////////////////futere method dor getting today's punched liist-start

/////////////////////futere method dor getting today's punched liist-close

}

