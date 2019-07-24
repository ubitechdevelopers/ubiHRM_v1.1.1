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
import 'teampunchlocatio_summary.dart';
//import 'Image_view.dart';

//import 'package:intl/intl.dart';


void main() => runApp(new PunchLocationSummary());

class PunchLocationSummary extends StatefulWidget {
  @override
  _PunchLocationSummary createState() => _PunchLocationSummary();
}

class _PunchLocationSummary extends State<PunchLocationSummary> {
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
        ),

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
                    MaterialPageRoute(builder: (context) => PunchLocationSummary()),
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
    return
        Container(
            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
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
                        MaterialPageRoute(builder: (context) => TeamPunchLocationSummary()),
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
                ),
              ]),

          Container(
            padding: EdgeInsets.only(top:12.0),
            child:Center(
              child:Text("My Visits Today",
                  style: new TextStyle(fontSize: 18.0, color: Colors.black87,)),
            ),
          ),
         // Divider(color: Colors.black54,height: 1.5,),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 40.0,),
              SizedBox(width: MediaQuery.of(context).size.width*0.02),
              Container(
                width: MediaQuery.of(context).size.width*0.45,
                child:Text(' Client',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),

              SizedBox(height: 40.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.2,
                child:Text('Visit In',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
              SizedBox(height: 40.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.2,
                child:Text('Visit Out',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
            ],
          ),
          Divider(),

          Expanded(
    //        height: MediaQuery.of(context).size.height*0.60,
            child: new FutureBuilder<List<Punch>>(
              future: getSummaryPunch(),
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
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   children: <Widget>[
                                     SizedBox(height: 40.0,),
                                     Container(
                                       width: MediaQuery
                                           .of(context)
                                           .size
                                           .width * 0.43,
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment
                                             .start,
                                         children: <Widget>[
                                           Text(snapshot.data[index].client
                                               .toString(), style: TextStyle(
                                               color: Colors.black87,
                                               fontWeight: FontWeight.bold,
                                               fontSize: 16.0),),

                                           InkWell(
                                             child: Text('In: ' +
                                                 snapshot.data[index]
                                                     .pi_loc.toString(),
                                                 style: TextStyle(
                                                     color: Colors.black54,
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
                                           snapshot.data[index].po_time == '-'
                                               ? Padding(
                                             padding: EdgeInsets.only(
                                                 right: 8.0,
                                                 top: 8.0,
                                                 bottom: 8.0),
                                             child: InkWell(
                                               child: new Container(
                                                 //width: 100.0,
                                                 height: 25.0,
                                                 decoration: new BoxDecoration(
                                                   color: Colors.orange[800],
                                                   border: new Border.all(
                                                       color: Colors.white,
                                                       width: 2.0),
                                                   //borderRadius: new BorderRadius.circular(10.0),
                                                 ),

                                                 child: new Center(
                                                   child: new Text('Visit out',
                                                     style: new TextStyle(
                                                         fontSize: 16.0,
                                                         color: Colors
                                                             .white),),),
                                               ),
                                               onTap: () {
                                                 _showDialog(
                                                     snapshot.data[index].Id
                                                         .toString());
                                               },),
                                           )
                                               : Container(),

                                           SizedBox(height: 10.0,),


                                         ],
                                       ),
                                     ),

                                     Container(
                                         width: MediaQuery
                                             .of(context)
                                             .size
                                             .width * 0.22,
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment
                                               .center,
                                           children: <Widget>[
                                             Text(snapshot.data[index].pi_time
                                                 .toString(), style: TextStyle(
                                                 fontWeight: FontWeight.bold),),
                                             Container(
                                               width: 62.0,
                                               height: 62.0,
                                               child: InkWell(child: Container(
                                                   decoration: new BoxDecoration(
                                                       shape: BoxShape
                                                           .circle,
                                                       image: new DecorationImage(
                                                           fit: BoxFit.fill,
                                                           image: new NetworkImage(
                                                               snapshot
                                                                   .data[index]
                                                                   .pi_img)
                                                       )
                                                   )),
                                                 onTap: () {
                                                   /*Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].pi_img,org_name: org_name)),
                                                );*/
                                                 },),),

                                           ],
                                         )

                                     ),
                                     Container(
                                         width: MediaQuery
                                             .of(context)
                                             .size
                                             .width * 0.22,
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment
                                               .center,
                                           children: <Widget>[
                                             Text(snapshot.data[index].po_time
                                                 .toString(), style: TextStyle(
                                                 fontWeight: FontWeight.bold),),
                                             Container(
                                               width: 62.0,
                                               height: 62.0,
                                               child: InkWell(
                                                 child: Container(
                                                     decoration: new BoxDecoration(
                                                         shape: BoxShape
                                                             .circle,
                                                         image: new DecorationImage(
                                                             fit: BoxFit.fill,
                                                             image: new NetworkImage(
                                                                 snapshot
                                                                     .data[index]
                                                                     .po_img)
                                                         )
                                                     )),
                                                 onTap: () {
                                                   /*Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].po_img,org_name: org_name)),
                                                );*/
                                                 },
                                               ),),

                                           ],
                                         )

                                     ),
                                   ],
                                 ), //
                                 snapshot.data[index].desc == ''
                                     ? Container()
                                     : snapshot.data[index].desc !=
                                     'Visit out not punched' ?
                                 Row(
                                   children: <Widget>[
                                     // SizedBox(width: 16.0,),
                                     Text('Remark: ', style: TextStyle(
                                       fontWeight: FontWeight.bold,),),
                                     Text(snapshot.data[index].desc)
                                   ],

                                 ) :
                                 Row(
                                   children: <Widget>[
                                     // SizedBox(width: 16.0,),
                                     Text('Remark: ', style: TextStyle(
                                         fontWeight: FontWeight.bold,
                                         color: Colors.red),),
                                     Text(snapshot.data[index].desc,
                                       style: TextStyle(color: Colors.red),)
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
                      child:Text("No Visits Today ",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                      ),
                      );
                      }
                } else if (snapshot.hasError) {
                  return new Text("Unable to connect to server");
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
