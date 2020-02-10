// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/model/model.dart';
import 'package:ubihrm/services/services.dart';
import 'package:ubihrm/services/timeoff_services.dart';

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
  // Platform messages are asynchronous, so we initialize in an async method.
/*  initPlatformState() async {
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
        profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
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
  }*/

  withdrawlTimeOff(String timeoffid) async{
    setState(() {
      _checkwithdrawntimeoff = true;
    });
    print("----> withdrawn service calling "+_checkwithdrawntimeoff.toString());
    RequestTimeOffService ns = new RequestTimeOffService();
    var timeoff = TimeOff(TimeOffId: timeoffid, OrgId: orgid, EmpId: empid, ApprovalSts: '5');
    var islogin = await ns.withdrawTimeOff(timeoff);
    print(islogin);
    if(islogin=="success"){
      setState(() {
        _isButtonDisabled=false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TimeoffSummary()),
      );
      // ignore: deprecated_member_use
      showDialog(context: context, child:
      new AlertDialog(
        //title: new Text("Withdrawl"),
        content: new Text("Time Off application withdrawn successfully."),
      )
      );
    }else if(islogin=="failure"){
      setState(() {
        _isButtonDisabled=false;
      });
      // ignore: deprecated_member_use
      showDialog(context: context, child:
      new AlertDialog(
        //title: new Text("Sorry!"),
        content: new Text("Timeoff could not be withdrawn."),
      )
      );
    }else{
      setState(() {
        _isButtonDisabled=false;
      });
      // ignore: deprecated_member_use
      showDialog(context: context, child:
      new AlertDialog(
        //title: new Text("Sorry!"),
        content: new Text("Poor network connection."),
      )
      );
    }
  }

  confirmWithdrawl(String timeoffid) async{
    // ignore: deprecated_member_use
    showDialog(context: context, child:
    new AlertDialog(
      title: new Text("Withdraw timeoff?",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18.0),),
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
          tooltip: 'Request Timeoff',
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
                      child:Text('My Timeoff',
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[

                                            new Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(0.0,5.0,0.0,0.0),
                                                child: Container(
                                                    height: MediaQuery .of(context).size.height * 0.04,
                                                    width: MediaQuery .of(context).size.width * 0.50,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      new Text(
                                                        snapshot.data[index].TimeofDate.toString(),style: TextStyle(fontWeight: FontWeight.bold),),

                                                    ],
                                                  )),
                                              ),),




                                            new Expanded(
                                            child:  Container(
                                              child:Column(
                                                children: <Widget>[
                          //                        new Text(snapshot.data[index].ApprovalSts.toString(), style: TextStyle(color: snapshot.data[index].ApprovalSts.toString()=='Approved'?Colors.green.withOpacity(0.75):snapshot.data[index].ApprovalSts.toString()=='Rejected' || snapshot.data[index].ApprovalSts.toString()=='Cancel' ?Colors.red.withOpacity(0.65):snapshot.data[index].ApprovalSts.toString().startsWith('Pending')?Colors.orange[800]:Colors.black54, fontSize: 14.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),

                                                  (snapshot.data[index].withdrawlsts)?
                                                  InkWell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(0.0,3.0,12.0,0.0),
                                                      child: Container(
                                                        height: MediaQuery .of(context).size.height * 0.04,
                                                        margin: EdgeInsets.only(left:40.0),
                                                        padding: EdgeInsets.only(left:40.0),
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
                                          //padding: EdgeInsets.only(top:1.5,bottom: 0.5),
                                          margin: EdgeInsets.only(top: 4.0),
                                          child: Text('Duration: '+snapshot.data[index].TimeFrom.toString()+' to '+snapshot.data[index].TimeTo.toString(), style: TextStyle(color: Colors.black54),),
                                        ),

                                        snapshot.data[index].Reason.toString()!='-'?Container(
                                          width: MediaQuery.of(context).size.width*.90,
                                          //padding: EdgeInsets.only(top:1.5,bottom: 0.5),
                                          margin: EdgeInsets.only(top: 4.0),
                                          child: Text('Reason: '+snapshot.data[index].Reason.toString(), style: TextStyle(color: Colors.black54),),
                                        ):Center(),
                                 //       new Text(snapshot.data[index].ApprovalSts.toString(), style: TextStyle(color: snapshot.data[index].ApprovalSts.toString()=='Approved'?Colors.green.withOpacity(0.75):snapshot.data[index].ApprovalSts.toString()=='Rejected' || snapshot.data[index].ApprovalSts.toString()=='Cancel' ?Colors.red.withOpacity(0.65):snapshot.data[index].ApprovalSts.toString().startsWith('Pending')?Colors.orange[800]:Colors.black54, fontSize: 14.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),

                                        snapshot.data[index].ApproverComment.toString()!='-'?Container(
                                          width: MediaQuery.of(context).size.width*.90,
                                          //padding: EdgeInsets.only(top:1.5,bottom: 0.5),
                                          margin: EdgeInsets.only(top: 3.0),
                                          child: Text('Comment: '+snapshot.data[index].ApproverComment.toString(), style: TextStyle(color: Colors.black54), ),
                                        ):Center(
                                          // child:Text(snapshot.data[index].withdrawlsts.toString()),
                                        ),

                                        snapshot.data[index].ApprovalSts.toString()!='-'?Container(
                                          width: MediaQuery.of(context).size.width*.90,
                                          //padding: EdgeInsets.only(top:1.5,bottom: 1.5),
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




  getPunchPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('getPunchPrefs called: new lid- '+ prefs.getString('lid').toString());
    return prefs.getString('lid');
  }


/////////////////////futere method dor getting today's punched liist-start

/////////////////////futere method dor getting today's punched liist-close

}

class TimeOffAppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;
  TimeOffAppHeader(profileimage1,showtabbar1,orgname1){
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

