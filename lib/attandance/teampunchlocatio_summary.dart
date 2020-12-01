import 'dart:async';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/home.dart';
import '../appbar.dart';
import '../drawer.dart';
import '../services/attandance_saveimage.dart';
import '../services/attandance_services.dart';
import 'punchlocation_summary.dart';
//import 'Image_view.dart';

//import 'package:intl/intl.dart';


void main() => runApp(new TeamPunchLocationSummary());

class TeamPunchLocationSummary extends StatefulWidget {
  @override
  _TeamPunchLocationSummary createState() => _TeamPunchLocationSummary();
}
TextEditingController today;
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

  bool res = true;
  var formatter = new DateFormat('dd-MMM-yyyy');

  StreamLocation sl = new StreamLocation();
  bool _isButtonDisabled= false;
  final _comments=TextEditingController();
  String latit,longi,location_addr1;
  Timer timer;
  TextEditingController _searchController;
  FocusNode searchFocusNode;
  String empname = "";

  @override
  void initState() {
    super.initState();
    _searchController = new TextEditingController();
    searchFocusNode = FocusNode();
    initPlatformState();
    getOrgName();
    setLocationAddress();
    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
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
    profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoaded = false;
        });
      }
    }));
    showtabbar=false;
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
      MaterialPageRoute(builder: (context) => HomePageMain()), (Route<dynamic> route) => false,
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
        latit = list[list.length - 1].latitude.toString();
        longi = list[list.length - 1].longitude.toString();
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
                      labelText: 'Visit Feedback', hintText: 'Visit Feedback (Optional)'),
                ),
              ),
              SizedBox(height: 4.0,),

            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
              shape: Border.all(color: Colors.orange[800]),
              child: const Text('CANCEL',style: TextStyle(color: Colors.black87),),
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
                                        color: Colors.orange[800],
                                        size: 22.0 ),

                                    GestureDetector(
                                      child: Text(
                                          'Self',
                                          style: TextStyle(fontSize: 18,color: Colors.orange[800],)
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
                                      color: Colors.orange[800],
                                      size: 22.0 ),
                                  GestureDetector(
                                    onTap: () {
                                      /* Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MyTeamAtt()),
                                  );*/
                                      false;
                                    },
                                    child: Text(
                                        'Team',
                                        style: TextStyle(fontSize: 18,color: Colors.orange[800],fontWeight:FontWeight.bold)
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
                  ]),
              /// My log start here

              Container(
                padding: EdgeInsets.only(top:12.0,),
                child:Center(
                  child:Text("Team's Visits",
                    style: new TextStyle(fontSize: 18.0, color: Colors.black87,),textAlign: TextAlign.center,),
                ),
              ),
              Container(
                child: DateTimeField(
                  //dateOnly: true,
                  format: formatter,
                  controller: today,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Icon(
                        Icons.date_range,
                        color: Colors.grey,
                      ), // icon is 48px widget.
                    ), // icon is 48px widget.
                    labelText: 'Select Date',
                  ),
                  onChanged: (date) {
                    setState(() {
                      if (date != null && date.toString() != '')
                        res = true; //showInSnackBar(date.toString());
                      else
                        res = false;
                    });
                  },
                  validator: (date) {
                    if (date == null) {
                      return 'Please select date';
                    }
                  },
                ),
              ),
              Divider(height: 1,),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    controller: _searchController,
                    focusNode: searchFocusNode,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius:  new BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(Icons.search, size: 30,),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Search Employee',
                      //labelText: 'Search Employee',
                      suffixIcon: _searchController.text.isNotEmpty?IconButton(icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EmployeeList()),
                            );*/
                          }
                      ):null,
                      //focusColor: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        empname = value;
                        res = true;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 8,),
              //Divider(color: Colors.black54,height: 1.5,),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10.0,),
                  //SizedBox(width: MediaQuery.of(context).size.width*0.02),
                  Expanded(
                    flex: 50,
                    child:Text('Name',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                  ),
                  SizedBox(height: 10.0,),
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
                  future: getTeamSummaryPunch(today.text,empname),
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
                            color: appStartColor().withOpacity(0.1),
                            padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                            child:Text("Team's visit not found",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
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
