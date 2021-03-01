import 'dart:async';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/home.dart';
import 'package:ubihrm/services/services.dart';
import '../drawer.dart';
import '../profile.dart';
import '../services/attandance_saveimage.dart';
import '../services/attandance_services.dart';
import '../image_view.dart';
import 'punchlocation.dart';
import 'teampunchlocatio_summary.dart';


void main() => runApp(new PunchLocationSummary());

class PunchLocationSummary extends StatefulWidget {
  @override
  _PunchLocationSummary createState() => _PunchLocationSummary();
}

TextEditingController today;
class _PunchLocationSummary extends State<PunchLocationSummary> with WidgetsBindingObserver{
  static const platform = const MethodChannel('location.spoofing.check');
  String address = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String lat="";
  String long="";
  String desination="";
  String profile="";
  String org_name="";
  String orgid="";
  String empid="";
  String empname="";
  String admin_sts='0';
  int _currentIndex = 1;
  String streamlocationaddr = "";
  bool isServiceCalling = false;

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
    initPlatformState();
    getOrgName();
    platform.setMethodCallHandler(_handleMethod);
    //setLocationAddress();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    print("Punchlocation summary initPlatformState");
    appResumedPausedLogic();
    locationChannel.invokeMethod("openLocationDialog");
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted)
        setState(() {
          locationThreadUpdatedLocation = locationThreadUpdatedLocation;
        });
    });

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      setaddress();
      streamlocationaddr = globalstreamlocationaddr;
      desination = prefs.getString('desination') ?? '';
      profile = prefs.getString('profile') ?? '';
      admin_sts = prefs.getString('sstatus') ?? '0';
      org_name = prefs.getString('org_name') ?? '';
      orgid = prefs.getString('orgdir') ?? '';
      empid = prefs.getString('empid') ?? '';
    });

    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoaded = false;
        });
      }
    }));
    showtabbar=false;
  }

  setaddress() async {
    globalstreamlocationaddr = await getAddressFromLati(assign_lat.toString(),assign_long.toString());
    var serverConnected = await checkConnectionToServer();
    if (serverConnected != 0) if (assign_lat == 0.0 || assign_lat == null || !locationThreadUpdatedLocation) {
      locationChannel.invokeMethod("openLocationDialog");
    }
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "locationAndInternet":
        locationThreadUpdatedLocation = true;
        var long = call.arguments["longitude"].toString();
        var lat = call.arguments["latitude"].toString();
        assign_lat = double.parse(lat);
        assign_long = double.parse(long);
        address = await getAddressFromLati(lat, long);
        globalstreamlocationaddr = address;
        print(call.arguments["mocked"].toString());

        getAreaStatus().then((res) {
          print('home dot dart');
          if (mounted) {
            setState(() {
              areaSts = res.toString();
              print('response'+res.toString());
              if (assignedAreaIds.isNotEmpty && perGeoFence=="1") {
                AbleTomarkAttendance = areaSts;
              }
            });
          }
        }).catchError((onError) {
          print('Exception occured in clling function.......');
          print(onError);
        });

        setState(() {
          if (call.arguments["mocked"].toString() == "Yes") {
            fakeLocationDetected = true;
          } else {
            fakeLocationDetected = false;
          }
          if (call.arguments["TimeSpoofed"].toString() == "Yes") {
            timeSpoofed = true;
          }
        });
        break;

        return new Future.value("");
    }
  }

  Future<bool> sendToHome() async{
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
      child: RefreshIndicator(
        child: new Scaffold(
          backgroundColor:scaffoldBackColor(),
          endDrawer: new AppDrawer(),
          appBar: new PunchVisitAppHeader(profileimage,showtabbar,orgName),
          bottomNavigationBar:new HomeNavigation(),
          body:  ModalProgressHUD(
              inAsyncCall: isServiceCalling,
              opacity: 0.15,
              progressIndicator: SizedBox(
                child:new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation(Colors.green),
                    strokeWidth: 5.0),
                height: 40.0,
                width: 40.0,
              ),
              child: getWidgets(context)
          ),
          //body: getWidgets(context),
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
        ),
        onRefresh: () async {
          Completer<Null> completer = new Completer<Null>();
          await Future.delayed(Duration(seconds: 1)).then((onvalue) {
            setState(() {
              today.text = formatter.format(DateTime.now());
              getSummaryPunch(today.text,empname);
              empname='';
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            });
            completer.complete();
          });
          return completer.future;
        },
      ),
    );
  }
  /////////////
  _showDialog(visit_id) async {
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
                      labelText: 'Visit Feedback', hintText: 'Visit Feedback(Optional)'),
                ),
              ),
              SizedBox(height: 4.0,),

            ],
          ),
        ),
        actions: <Widget>[
          new RaisedButton(
              child: const Text('PUNCH',style: TextStyle(color: Colors.white),),
              color: Colors.orange[800],
              onPressed: () async{
                setState(() {
                  isServiceCalling = true;
                });
                SaveImage saveImage = new SaveImage();
                Navigator.of(context, rootNavigator: true).pop();
                saveImage.saveVisitOut(empid,globalstreamlocationaddr.toString(),visit_id.toString(),assign_lat.toString(),assign_long.toString(),_comments.text,orgid).then((res){
                  if(res){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PunchLocationSummary()),
                    );
                    showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          content: new Text("Visit punched successfully"),
                        );
                      });
                    /*showDialog(context: context, child:
                    new AlertDialog(
                      content: new Text("Visit punched successfully!"),
                    )
                    );*/
                  }else{
                    _comments.text='';
                    showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          content: new Text("Visit not captured, please punch again"),
                        );
                      });
                    /*showDialog(context: context, child:
                    new AlertDialog(
                      //title: new Text("Warning!"),
                      content: new Text("Visit was not captured, please punch again!"),
                    )
                    );*/
                    setState(() {
                      isServiceCalling = false;
                    });
                  }
                }).catchError((ett){
                  //showInSnackBar('Unable to punch visit');
                  showDialog(
                    context: context,
                    builder: (context) {
                      Future.delayed(Duration(seconds: 3), () {
                        Navigator.of(context).pop(true);
                      });
                      return AlertDialog(
                        content: new Text("Unable to punch visit"),
                      );
                    });
                  /*showDialog(context: context, child:
                  new AlertDialog(
                    //title: new Text("Warning!"),
                    content: new Text('Unable to punch visit'),
                  )
                  );*/
                });
              }),
          new FlatButton(
              shape: Border.all(color: Colors.orange[800]),
              child: const Text('CANCEL',style: TextStyle(color: Colors.black87),),
              onPressed: () {
                _comments.text='';
                Navigator.of(context, rootNavigator: true).pop();
              }),
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
                      ),
                    ]),

                Container(
                  padding: EdgeInsets.only(top:12.0),
                  child:Center(
                    child:Text("My Visits",
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
                Divider(height:2,),
                SizedBox(height: 8,),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20.0,),
                    SizedBox(width: MediaQuery.of(context).size.width*0.02),
                    Container(
                      width: MediaQuery.of(context).size.width*0.47,
                      child:Text(' Client',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                    ),

                    SizedBox(height: 20.0,),
                    Container(
                      width: MediaQuery.of(context).size.width*0.2,
                      child:Text('Visit In',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                    ),
                    SizedBox(height: 20.0,),
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
                    future: getSummaryPunch(today.text,empname),
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
                                          Padding(
                                            padding: const EdgeInsets.only(left:10.0),
                                            child: Container(
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
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].pi_img,org_name: org_name)),
                                                        );
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
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].po_img,org_name: org_name)),
                                                        );
                                                      },
                                                    ),),

                                                ],
                                              )

                                          ),
                                        ],
                                      ), //
                                      Padding(
                                        padding: const EdgeInsets.only(left:10.0),
                                        child: snapshot.data[index].desc == ''
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
                              child:Text("No visits found",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
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

class PunchVisitAppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;
  PunchVisitAppHeader(profileimage1,showtabbar1,orgname1){
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
                        image: _checkLoadedprofile ? AssetImage('assets/default.png') : profileimage,
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


