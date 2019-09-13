// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:ubihrm/services/attandance_fetch_location.dart';
//import 'package:simple_permissions/simple_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'timeoff_summary.dart';
import 'package:ubihrm/services/timeoff_services.dart';
import 'package:ubihrm/model/model.dart';
import '../b_navigationbar.dart';
import '../global.dart';
import '../drawer.dart';
import '../appbar.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'timeoff_summary.dart';

// This app is a stateful, it tracks the user's current choice.
class TeamTimeoffSummary extends StatefulWidget {
  @override
  _TeamTimeoffSummary createState() => _TeamTimeoffSummary();
}

class _TeamTimeoffSummary extends State<TeamTimeoffSummary> {
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
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => TimeoffSummary()), (Route<dynamic> route) => false,
    );
    return false;
  }
  getmainhomewidget() {
    return new WillPopScope(
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
     )
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
                            child:InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TimeoffSummary()),
                                );

                              },
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

                                        child: const Text(
                                            'Self',
                                            style: TextStyle(fontSize: 18,color: Colors.orange,)
                                        ),
                                        // color: Colors.teal[50],
                                        /* splashColor: Colors.white,
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(0.0))*/
                                      ),
                                    ]
                                ),
                                SizedBox(height:MediaQuery.of(context).size.width*.03),
                              ]
                          ),
                          ),
                        ),

                        Expanded(
                          flex:48,
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
                                        onTap: () {
                                          /* Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MyTeamAtt()),
                                  );*/
                                          false;
                                        },
                                        child: const Text(
                                            'Team',
                                            style: TextStyle(fontSize: 18,color: Colors.orange,fontWeight:FontWeight.bold)
                                        ),
                                      ),
                                    ]),
                                SizedBox(height:MediaQuery.of(context).size.width*.03),
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
                      ]
                  ),

                  Container(
                    padding: EdgeInsets.only(top:12.0),
                    child:Center(
                      child:Text("Team's Time Off ",
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
                          child:Text('Name',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                        ),),

                      new Expanded(
                        child:  Container(
                          width: MediaQuery.of(context).size.width*0.50,
                          margin: EdgeInsets.only(left:32.0),
                          padding: EdgeInsets.only(right:12.0),
                          child:Text('Applied on',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),textAlign: TextAlign.right,),
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
                      child:new FutureBuilder<List<TIMEOFFA>>(
                        future: getTeamTimeoffapproval(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Row(
                                            mainAxisAlignment: MainAxisAlignment .spaceAround,
                                            children: <Widget>[
                                            //  SizedBox(height: 40.0,),

                                              new Expanded(
                                                child: Container(
                                                  width: MediaQuery.of(context) .size.width * 0.50,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment  .start,
                                                    children: <Widget>[
                                                      new Text(snapshot.data[index].name.toString(), style: TextStyle(
                                                          color: Colors.black87,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16.0),),
                                                    ],
                                                  ),
                                                ),
                                              ),


                                              new Expanded(
                                                child:Container(
                                                    width: MediaQuery .of(context)  .size.width * 0.50,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment .center,
                                                      children: <Widget>[
                                                        Text("          "+snapshot.data[index].applydate
                                                            .toString()),
                                                      ],
                                                    )

                                                ),
                                              ),

                                            ],

                                          ),

                                          Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            padding: EdgeInsets.only(top:1.5,bottom: .5),
                                            margin: EdgeInsets.only(top: 4.0),
                                            child: Text('Date: '+snapshot.data[index].TimeofDate.toString(), style: TextStyle(color: Colors.black54),),
                                          ),



                                          new Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              new Expanded(
                                                child: Container(
                                                  //     color:Colors.red,
                                                  //     height: MediaQuery .of(context).size.height * 0.06,
                                                    width: MediaQuery .of(context).size.width * 0.70,
                                                    padding: EdgeInsets.only(top:1.5,bottom: .5),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        //     new SizedBox(width: 5.0,),
                                                        new Text("Duration: "+snapshot.data[index].Fdate.toString()+snapshot.data[index].Tdate.toString(),style: TextStyle(color: Colors.grey[600]),)
                                                      ],
                                                    )
                                                ),
                                              ),

                                              (snapshot.data[index].sts.toString() == 'true')?
                                              new Expanded(
                                                child: Container (
                                                  //      color:Colors.yellow,
                                                    height: MediaQuery .of(context).size.height * 0.06,
                                                    margin: EdgeInsets.only(left:32.0),
                                                    padding: EdgeInsets.only(left:32.0),
                                                    width: MediaQuery.of(context).size.width * 0.30,
                                                    child: new OutlineButton(
                                                      onPressed: () {
                                                        _modalBottomSheet(
                                                            context, snapshot.data[index].Id.toString());
                                                      },
                                                      child:new Icon(
                                                        Icons.thumb_up,
                                                        size: 16.0,
                                                        color:appStartColor(),
                                                        //      textDirection: TextDirection.rtl,
                                                      ),
                                                      borderSide: BorderSide(color:appStartColor()),
                                                      shape: new CircleBorder(),
                                                      //         padding:EdgeInsets.all(5.0),
                                                    )
                                                ),
                                              ):Center(),
                                            ],
                                          ),

                                          snapshot.data[index].Reason.toString()!='-'?Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            padding: EdgeInsets.only(top:1.5,bottom: .5),
                                            margin: EdgeInsets.only(top: 4.0),
                                            child: Text('Reason: '+snapshot.data[index].Reason.toString(), style: TextStyle(color: Colors.black54),),
                                          ):Center(),


                                          (snapshot.data[index].Timeoffsts.toString()!='Pending' ) ?Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            padding: EdgeInsets.only(top:.5,bottom: 1.5),
                                            margin: EdgeInsets.only(top: 1.0),
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
                                                  new TextSpan(text: snapshot.data[index].Timeoffsts.toString(), style: TextStyle(color: snapshot.data[index].Timeoffsts.toString()=='Approved'?appStartColor() :snapshot.data[index].Timeoffsts.toString()=='Rejected' || snapshot.data[index].Timeoffsts.toString()=='Cancel' ?Colors.red:Colors.blue[600], fontSize: 14.0),),
                                                ],
                                              ),
                                            ),
                                          ):Center(
                                            // child:Text(snapshot.data[index].withdrawlsts.toString()),
                                          ),


                                          (snapshot.data[index].Timeoffsts.toString()=='Pending' && snapshot.data[index].Psts.toString()!='') ?Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            padding: EdgeInsets.only(top:.5,bottom: 1.5),
                                            margin: EdgeInsets.only(top: 1.0),
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
                                                  new TextSpan(text: snapshot.data[index].Psts.toString(), style: TextStyle(color: Colors.orange[800], fontSize: 14.0),),
                                                ],
                                              ),
                                            ),
                                          ):Center(
                                            // child:Text(snapshot.data[index].withdrawlsts.toString()),
                                          ),


                                          Divider(color: Colors.black45,),
                                        ] );
                                  }
                              );
                            }else{
                              return new Center(
                                child:Text("No Records"),
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                            return new Text("Unable to connect server");
                          }

                          // By default, show a loading spinner
                          return new Center(child: CircularProgressIndicator());
                        },
                      ),
                      //////////////////////////////////////////////////////////////////////---------------------------------
                    ),),

                ])
        ),



      ],
    );
  }


  _modalBottomSheet(context,String timeoffid) async{

    final FocusNode myFocusNodeComment = FocusNode();
    TextEditingController CommentController = new TextEditingController();

    showRoundedModalBottomSheet(
        context: context,
        //  radius: 190.0,
        //   radius: 190.0, // This is the default
        // color:Colors.lightGreen.withOpacity(0.9),
        color:Colors.grey[100],
        //   color:Colors.cyan[200].withOpacity(0.7),
        builder: (BuildContext bc){
          return new  Container(
            // padding: MediaQuery.of(context).viewInsets,
            //duration: const Duration(milliseconds: 100),
            // curve: Curves.decelerate,

            // child: new Expanded(
            //height: MediaQuery.of(context).size.height-100.0,
            height: 200.0,
            child: new Container(
              decoration: new BoxDecoration(
                  color: appStartColor().withOpacity(0.1),
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(0.0),
                      topRight: const Radius.circular(0.0))),


              alignment: Alignment.topCenter,
              child: Wrap(
                children: <Widget>[
                  /*    new Container(
                    width: MediaQuery.of(context).size.width * .20,
                    child:Text(psts,style:TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 18.0,
                        color: Colors.black)),

                  ),
                  Divider(color: Colors.black45,),*/
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20.0, bottom: 20.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      focusNode: myFocusNodeComment,
                      controller: CommentController,
                      keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (String value) {
                        FocusScope.of(context).requestFocus(myFocusNodeComment);
                      },
                      style: TextStyle(
                          fontFamily: "WorkSansSemiBold",
                          fontSize: 16.0,
                          height: 1.0,
                          color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white, filled: true,
                        /* icon: Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 22.0,
                        ),*/
                        hintText: "Comment",
                        hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold", fontSize: 15.0),
                        /*  suffixIcon: GestureDetector(
                          //onTap: _toggleLogin,
                          child: Icon(
                            Icons.edit,
                            size: 15.0,
                            color: Colors.black,
                          ),
                        ),*/
                      ),

                      /*validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Email or Phone no.';
                            }
                          },*/
                      maxLines: 3,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 0.0, left: 60.0, right: 7.0),
                    child:  ButtonTheme(
                      minWidth: 50.0,
                 //     height: 40.0,
                      child: OutlineButton(
                        onPressed: () async  {
                          //getApprovals(choice.title);
                          //Navigator.pop(context);  // for close bottom sheet
                          final sts= await ApproveTimeoff(timeoffid,CommentController.text,2);
                          //  print("kk");
                          // print("kk"+sts);
                          if(sts=="true") {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (_) =>
                                new AlertDialog(
                                  //title: new Text("Dialog Title"),
                                  content: new Text("Approved"),
                                )
                            );

                            await new Future.delayed(const Duration(seconds: 2));
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TeamTimeoffSummary()),
                            );
                          }
                          else{
                            showDialog(
                                context: context,
                                builder: (_) =>
                                new AlertDialog(
                                  //title: new Text("Dialog Title"),
                                  content: new Text("Could not be approved. Try again."),
                                )
                            );
                          }

                          /*Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TimeOffApp()),
                          );*/
                        },
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0),),

                        /* gradient: LinearGradient(
                          colors: <Color>[Colors.green[700], Colors.green[700]],
                        ),*/
                        child: new Text('Approve',
                            style: new TextStyle(
                              color: Colors.green[700],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                        borderSide: BorderSide(color: Colors.green[700],),

                      ),
                    ),),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 0.0, left: 5.0, right: 20.0),
                    child:  ButtonTheme(
                      minWidth: 50.0,
                   //   height: 40.0,
                      child: OutlineButton(
                        onPressed: () async {
                          //getApprovals(choice.title);
                          var sts = await ApproveTimeoff(timeoffid,CommentController.text,1);
                          print("ff"+sts);
                          if(sts=="true") {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (_) =>
                                new AlertDialog(
                                  //title: new Text("Dialog Title"),
                                  content: new Text("Application for timeoff is rejected"),
                                )
                            );

                            await new Future.delayed(const Duration(seconds: 2));
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TeamTimeoffSummary()),
                            );

                          }
                          else{
                            showDialog(
                                context: context,
                                builder: (_) =>
                                new AlertDialog(
                                  //title: new Text("Dialog Title"),
                                  content: new Text("Could not be rejected"),
                                )
                            );
                          }



                         /* Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TimeOffApp()),
                          );*/
                        },
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0),),

                        /* color: Colors.red,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),*/
                       /* gradient: LinearGradient(
                          colors: <Color>[Colors.red[700], Colors.red[700]],
                        ),*/
                        child: new Text('Reject',
                            style: new TextStyle(
                                color: Colors.red[700],
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold)
                        ),
                        borderSide: BorderSide(color: Colors.red[700],),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

        }
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

