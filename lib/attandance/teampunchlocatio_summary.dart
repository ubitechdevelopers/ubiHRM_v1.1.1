import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../drawer.dart';
import 'home.dart';
import 'package:ubihrm/global.dart';

import '../services/attandance_services.dart';
import '../services/attandance_newservices.dart';
import 'punchlocation.dart';
import 'reports.dart';
import 'profile.dart';
import 'settings.dart';
import '../services/attandance_saveimage.dart';
import '../appbar.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'punchlocation_summary.dart';
//import 'Image_view.dart';

//import 'package:intl/intl.dart';


void main() => runApp(new TeamPunchLocationSummary());

class TeamPunchLocationSummary extends StatefulWidget {
  @override
  _TeamPunchLocationSummary createState() => _TeamPunchLocationSummary();
}

class _TeamPunchLocationSummary extends State<TeamPunchLocationSummary> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String lat="";
  String long="";
  String desination="";
  String profile="";
  String org_name="";
  String orgid="";
  String empid="";
  String admin_sts='0';
  int _currentIndex = 1;
  String streamlocationaddr = "";

  String orgName="";
  var profileimage;
  bool showtabbar ;
  bool _checkLoaded = true;

  StreamLocation sl = new StreamLocation();
  bool _isButtonDisabled= false;
  final _comments=TextEditingController();
  String latit,longi,location_addr1;
  Timer timer;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    getOrgName();
    setLocationAddress();
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      streamlocationaddr = globalstreamlocationaddr;
      desination = prefs.getString('desination') ?? '';
      profile = prefs.getString('profile') ?? '';
      admin_sts = prefs.getString('sstatus') ?? '0';
      org_name = prefs.getString('org_name') ?? '';
      orgid = prefs.getString('orgdir') ?? '';
      empid = prefs.getString('empid') ?? '';
    });

    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);

    //      print("ABCDEFGHI-"+profile);
    profileimage.resolve(new ImageConfiguration()).addListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoaded = false;
        });
      }
    });
    showtabbar=false;
  }
  setLocationAddress() async {
    setState(() {
      streamlocationaddr = globalstreamlocationaddr;
      if (list != null && list.length > 0) {
        lat = list[list.length - 1]['latitude'].toString();
        long = list[list.length - 1]["longitude"].toString();
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
  // This widget is the root of your application.
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
    //  return false;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false,
    );
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: ()=> sendToHome(),
      child: new Scaffold(
        backgroundColor:scaffoldBackColor(),
        endDrawer: new AppDrawer(),
        appBar: new AppHeader(profileimage,showtabbar,orgName),
        bottomNavigationBar:new HomeNavigation(),
        /*
        floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.orange[800],
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PunchLocation()),
            );
          },
          tooltip: 'Punch Visit',
          child: new Icon(Icons.add),
        ),*/

        body: getWidgets(context),
      ),
    );

  }
  /////////////

  _showDialog(visit_id) async {
    sl.startStreaming(2);
    setState(() {
      if(list!=null && list.length>0) {
        latit = list[list.length - 1]['latitude'].toString();
        longi = list[list.length - 1]["longitude"].toString();
        location_addr1 = globalstreamlocationaddr;
      }else{
        latit = "0.0";
        longi = "0.0";
        location_addr1 = "";
      }
    });
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Container(
          height: MediaQuery.of(context).size.height*0.20,
          child: Column(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  maxLines: 5,
                  autofocus: true,
                  controller: _comments,
                  decoration: new InputDecoration(
                      labelText: 'Visit Feedback ', hintText: 'Visit Feedback (Optional)'),
                ),
              ),
              SizedBox(height: 4.0,),

            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
              shape: Border.all(color: Colors.black54),
              child: const Text('CANCEL',style: TextStyle(color: Colors.black),),
              onPressed: () {
                _comments.text='';
                Navigator.of(context, rootNavigator: true).pop();
              }),
          new RaisedButton(
              child: const Text('PUNCH',style: TextStyle(color: Colors.white),),
              color: Colors.orange[800],
              onPressed: () {
                sl.startStreaming(5);
                SaveImage saveImage = new SaveImage();
                /* print('****************************>>');
                print(streamlocationaddr.toString());
                print(visit_id.toString());
                print('00000000000');
                print(_comments.text);
                print('111111111111111');
                print(latit+' '+longi);
                print('22222222222222');
                print('<<****************************');*/
                Navigator.of(context, rootNavigator: true).pop();
                saveImage.saveVisitOut(empid,streamlocationaddr.toString(),visit_id.toString(),latit,longi,_comments.text,orgid).then((res){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TeamPunchLocationSummary()),
                  );
                }).catchError((ett){
                  showInSnackBar('Unable to punch visit');
                });
                /*       //  Loc lock = new Loc();
                //   location_addr1 = await lock.initPlatformState();
                if(_isButtonDisabled)
                  return null;

                Navigator.of(context, rootNavigator: true).pop('dialog');
                setState(() {
                  _isButtonDisabled=true;
                });
                //PunchInOut(comments.text,'','empid', location_addr1, 'lid', 'act', 'orgdir', latit, longi).then((res){
                SaveImage saveImage = new SaveImage();
                 saveImage.visitOut(comments.text,visit_id,location_addr1,latit, longi).then((res){
print('visit out called for visit id:'+visit_id);
                /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PunchLocationSummary()),
                  );
*/


                }).catchError((onError){
                  showInSnackBar('Unable to punch visit');
                });
*/
              })
        ],
      ),
    );
  }
  /////////////
  getWidgets(context){
    return Container(
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            //width: MediaQuery.of(context).size.width*0.9,
            //     height:MediaQuery.of(context).size.height*0.75,
            decoration: new ShapeDecoration(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
              color: Colors.white,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
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
                                MaterialPageRoute(builder: (context) => PunchLocationSummary()),
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
                                        //color: Colors.teal[50],

                                        /* splashColor: Colors.white,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(0.0),

                                  /* side: BorderSide(
                                        color: Colors.blue,
                                        width: 1,

                                        style: BorderStyle.solid
                                    )*/
                                )*/
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
                      ]),
                  /// My log start here

                  Container(
                    padding: EdgeInsets.only(top:12.0,),
                    child:Center(
                      child:Text("Today's Visits",
                          style: new TextStyle(fontSize: 18.0, color: Colors.black87,)),
                    ),
                  ),

                  //Divider(color: Colors.black54,height: 1.5,),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 30.0,),
                      //SizedBox(width: MediaQuery.of(context).size.width*0.02),
                      Expanded(
                        flex: 50,
                        child:Text('Name',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                      ),
                      SizedBox(height: 30.0,),
                      Expanded(
                        flex: 50,
                       // width: MediaQuery.of(context).size.width*0.2,
                        child:Text('Client',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                      ),
                    ],
                  ),
                  Divider(),

                  Expanded(
                    //        height: MediaQuery.of(context).size.height*0.60,
                    child: new FutureBuilder<List<Punch>>(
                      future: getTeamSummaryPunch(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if(snapshot.data.length>0) {
                          return new ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                //   double h_width = MediaQuery.of(context).size.width*0.5; // screen's 50%
                                //   double f_width = MediaQuery.of(context).size.width*1; // screen's 100%

                                  return new Column(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            Expanded(
                                                flex: 50,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(
                                                      snapshot.data[index].Emp
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold),),
                                                    SizedBox(height: 10.0,),
                                                    Text("TimeIn:    " +
                                                        snapshot.data[index]
                                                            .pi_time
                                                            .toString(),),
                                                    SizedBox(height: 5.0,),
                                                    Text("TimeOut: " +
                                                        snapshot.data[index]
                                                            .po_time
                                                            .toString(),),


                                                  ],
                                                )
                                            ),

                                            Expanded(
                                              flex: 50,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: <Widget>[
                                                  Text(
                                                    snapshot.data[index].client
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                    ),),

                                                  InkWell(
                                                    child: Text('In: ' +
                                                        snapshot.data[index]
                                                            .pi_loc.toString(),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black54,
                                                            fontSize: 12.0)),
                                                    onTap: () {
                                                      goToMap(
                                                          snapshot.data[index]
                                                              .pi_latit,
                                                          snapshot.data[index]
                                                              .pi_longi);
                                                    },
                                                  ),
                                                  SizedBox(height: 2.0),
                                                  InkWell(
                                                    child: Text('Out: ' +
                                                        snapshot.data[index]
                                                            .po_loc.toString(),
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 12.0),),
                                                    onTap: () {
                                                      goToMap(
                                                          snapshot.data[index]
                                                              .po_latit,
                                                          snapshot.data[index]
                                                              .po_longi);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),


                                          ],
                                        ),
                                        Divider(color: Colors.black26,),
                                      ]);

                              }
                             );
                              }
                              else
                              {
                                return new Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*1,
                                    color: Colors.teal.withOpacity(0.1),
                                    padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                    child:Text("Team data not found ",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                                  ),
                                );
                              }
                        } else if (snapshot.hasError) {
                          return new Text("Unable to connect server");
                        }

                        // By default, show a loading spinner
                        return new Center( child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ]
            )
        );
  }
}

class User {
  String AttendanceDate;
  String thours;
  String TimeOut;
  String TimeIn;
  String bhour;
  String EntryImage;
  String checkInLoc;
  String ExitImage;
  String CheckOutLoc;
  String latit_in;
  String longi_in;
  String latit_out;
  String longi_out;
  int id=0;
  User({this.AttendanceDate,this.thours,this.id,this.TimeOut,this.TimeIn,this.bhour,this.EntryImage,this.checkInLoc,this.ExitImage,this.CheckOutLoc,this.latit_in,this.longi_in,this.latit_out,this.longi_out});
}

String dateFormatter(String date_) {
  // String date_='2018-09-2';
  var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun','Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  var dy = ['st', 'nd', 'rd', 'th', 'th', 'th','th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th','st','nd','rd', 'th', 'th', 'th', 'th', 'th', 'th', 'th','st'];
  var date = date_.split("-");
  return(date[2]+""+dy[int.parse(date[2])-1]+" "+months[int.parse(date[1])-1]);
}
