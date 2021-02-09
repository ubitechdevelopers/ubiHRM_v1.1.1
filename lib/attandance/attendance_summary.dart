import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/profile.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/services/services.dart';
import './image_view.dart';
import '../drawer.dart';
import 'home.dart';
import 'team_attendance_summary.dart';


void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();

}

class _MyApp extends State<MyApp> {
  String fname="";
  String lname="";
  String desination="";
  String profile="";
  String org_name="";
  int _currentIndex = 1;
  String admin_sts='0';
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar ;
  String orgName="";
  bool _checkLoaded = true;

  @override
  void initState() {
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
  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    profile = prefs.getString('profile') ?? '';
    //   profileimage = new NetworkImage(profile);
    // //print("1-"+profile);
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);

    profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoaded = false;
        });
      }
    }));
    showtabbar=false;
    setState(() {
      fname = prefs.getString('fname') ?? '';
      lname = prefs.getString('lname') ?? '';
      desination = prefs.getString('desination') ?? '';
      profile = prefs.getString('profile') ?? '';
      org_name = prefs.getString('org_name') ?? '';
      admin_sts = prefs.getString('sstatus') ?? '';
    });
  }
  // This widget is the root of your application.
  Future<bool> sendToHome() async{
    print("-------> back button pressed");
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
      child: RefreshIndicator(
        child: new Scaffold(
          backgroundColor:scaffoldBackColor(),
          endDrawer: new AppDrawer(),
          appBar: new AttendanceAppHeader(profileimage,showtabbar,orgName),
          bottomNavigationBar:new HomeNavigation(),
          body: getWidgets(context),
        ),
        onRefresh: () async {
          Completer<Null> completer = new Completer<Null>();
          await Future.delayed(Duration(seconds: 1)).then((onvalue) {
            completer.complete();
          });
          return completer.future;
        },
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
  String timoffend;
  String EntryImage;
  String checkInLoc;
  String ExitImage;
  String CheckOutLoc;
  String latit_in;
  String longi_in;
  String latit_out;
  String longi_out;
  String AttendanceStatus;
  int id=0;
  User({this.AttendanceDate,this.thours,this.id,this.TimeOut,this.TimeIn,this.timoffend,this.bhour,this.EntryImage,this.checkInLoc,this.ExitImage,this.CheckOutLoc,this.latit_in,this.longi_in,this.latit_out,this.longi_out,this.AttendanceStatus});
}

String dateFormatter(String date_) {
  // String date_='2018-09-2';
  var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun','Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  var dy = ['st', 'nd', 'rd', 'th', 'th', 'th','th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th','st','nd','rd', 'th', 'th', 'th', 'th', 'th', 'th', 'th','st'];
  var date = date_.split("-");
  return(date[2]+""+dy[int.parse(date[2])-1]+" "+months[int.parse(date[1])-1]);
}

getWidgets(context){
  return
    Container(
        margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        // width: MediaQuery.of(context).size.width*0.9,
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
                            MaterialPageRoute(builder: (context) => MyTeamAtt()),
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
                  child:Text('My Attendance Log',
                    style: new TextStyle(fontSize: 18.0, color: Colors.black87,),textAlign: TextAlign.center,),
                ),
              ),

              Divider(),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10.0,),
                  SizedBox(width: MediaQuery.of(context).size.width*0.02),
                  Container(
                    width: MediaQuery.of(context).size.width*0.40,
                    child:Text('Date',style: TextStyle(color: Colors.green,fontWeight:FontWeight.bold,fontSize: 16.0),),
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    width: MediaQuery.of(context).size.width*0.22,
                    child:Text('Time In',style: TextStyle(color: Colors.green,fontWeight:FontWeight.bold,fontSize: 16.0),),
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    width: MediaQuery.of(context).size.width*0.23,
                    child:Text('Time Out',style: TextStyle(color: Colors.green,fontWeight:FontWeight.bold,fontSize: 16.0),),
                  ),
                ],
              ),
              Divider(),

              Expanded(
                  child:  Container(
                      height: MediaQuery.of(context).size.height*0.60,
                      child: FutureBuilder<List<User>>(
                        future: getSummary(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.length > 0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    //   double h_width = MediaQuery.of(context).size.width*0.5; // screen's 50%
                                    //   double f_width = MediaQuery.of(context).size.width*1; // screen's 100%
                                    return new Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[
                                              SizedBox(height: 40.0,),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.40,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(snapshot.data[index]
                                                        .AttendanceDate
                                                        .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          fontSize: 16.0),),

                                                    InkWell(
                                                      child: Text('Time In: ' +
                                                          snapshot.data[index]
                                                              .checkInLoc
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 12.0)),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .latit_in,
                                                            snapshot.data[index]
                                                                .longi_in);
                                                      },
                                                    ),
                                                    SizedBox(height: 2.0),
                                                    InkWell(
                                                      child: Text('Time Out: ' +
                                                          snapshot.data[index]
                                                              .CheckOutLoc
                                                              .toString(),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black54,
                                                            fontSize: 12.0),),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .latit_out,
                                                            snapshot.data[index]
                                                                .longi_out);
                                                      },
                                                    ),
                                                    SizedBox(height: 2.0),
                                                    RichText(
                                                      text: new TextSpan(
                                                        // Note: Styles for TextSpans must be explicitly defined.
                                                        // Child text spans will inherit styles from parent
                                                        style: new TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black54,
                                                        ),
                                                        children: <TextSpan>[
                                                          new TextSpan(
                                                            text: 'Status: ',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .black54,),),
                                                          new TextSpan(
                                                            text: snapshot
                                                                .data[index]
                                                                .AttendanceStatus
                                                                .toString(),
                                                            style: TextStyle(
                                                              color: snapshot
                                                                  .data[index]
                                                                  .AttendanceStatus ==
                                                                  'Present'
                                                                  ? Colors
                                                                  .blueAccent
                                                                  :
                                                              snapshot
                                                                  .data[index]
                                                                  .AttendanceStatus ==
                                                                  'Absent'
                                                                  ? Colors.red
                                                                  :
                                                              snapshot
                                                                  .data[index]
                                                                  .AttendanceStatus ==
                                                                  'Holiday'
                                                                  ? Colors.green
                                                                  :
                                                              snapshot
                                                                  .data[index]
                                                                  .AttendanceStatus ==
                                                                  'Half Day'
                                                                  ? Colors
                                                                  .blueGrey
                                                                  :
                                                              snapshot
                                                                  .data[index]
                                                                  .AttendanceStatus ==
                                                                  'Week off'
                                                                  ? Colors
                                                                  .orange
                                                                  :
                                                              snapshot
                                                                  .data[index]
                                                                  .AttendanceStatus ==
                                                                  'Leave'
                                                                  ? Colors
                                                                  .lightBlueAccent
                                                                  :
                                                              snapshot
                                                                  .data[index]
                                                                  .AttendanceStatus ==
                                                                  'Comp Off'
                                                                  ? Colors
                                                                  .purpleAccent
                                                                  :
                                                              snapshot
                                                                  .data[index]
                                                                  .AttendanceStatus ==
                                                                  'Work from Home'
                                                                  ? Colors
                                                                  .brown[200]
                                                                  :
                                                              snapshot
                                                                  .data[index]
                                                                  .AttendanceStatus ==
                                                                  'Unpaid Leave'
                                                                  ? Colors.brown
                                                                  :
                                                              snapshot
                                                                  .data[index]
                                                                  .AttendanceStatus ==
                                                                  'Half Day - Unpaid'
                                                                  ? Colors.grey
                                                                  : Colors
                                                                  .black54,
                                                            ),),
                                                        ],
                                                      ),
                                                    ),

                                                    snapshot.data[index].bhour.toString() != '' && snapshot.data[index].timoffend.toString() != "00:00:00"
                                                        ? Container(
                                                      color: Colors.orange[800],
                                                      child: Text("" +
                                                          snapshot.data[index]
                                                              .bhour
                                                              .toString() +
                                                          " Hr(s)",
                                                        style: TextStyle(),),
                                                    )
                                                        : SizedBox(
                                                      height: 0.0,),

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
                                                      Text(snapshot.data[index]
                                                          .TimeIn
                                                          .toString(),
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),),
                                                      GestureDetector(
                                                        // When the child is tapped, show a snackbar
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (
                                                                    context) =>
                                                                    ImageView(
                                                                        myimage: snapshot
                                                                            .data[index]
                                                                            .EntryImage,
                                                                        org_name: "Ubitech Solutions")),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: 62.0,
                                                          height: 62.0,
                                                          child: Container(
                                                              decoration: new BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image: new DecorationImage(
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      image: new NetworkImage(
                                                                          snapshot
                                                                              .data[index]
                                                                              .EntryImage)
                                                                  )
                                                              )),),),

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
                                                      Text(snapshot.data[index]
                                                          .TimeOut
                                                          .toString(),
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold),),
                                                      GestureDetector(
                                                        // When the child is tapped, show a snackbar
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (
                                                                    context) =>
                                                                    ImageView(
                                                                        myimage: snapshot
                                                                            .data[index]
                                                                            .ExitImage,
                                                                        org_name: "Ubitech Solutions")),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: 62.0,
                                                          height: 62.0,
                                                          child: Container(
                                                              decoration: new BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image: new DecorationImage(
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      image: new NetworkImage(
                                                                          snapshot
                                                                              .data[index]
                                                                              .ExitImage)
                                                                  )
                                                              )),),),

                                                    ],
                                                  )

                                              ),
                                            ],

                                          ),
                                          Divider(color: Colors.black26,),
                                        ]);
                                  }
                              );
                            } else {
                              return new Center(
                                child: Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 1,
                                  color: appStartColor().withOpacity(0.1),
                                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  child: Text(
                                    "No data found", style: TextStyle(fontSize: 16.0),
                                    textAlign: TextAlign.center,),
                                ),
                              );
                            }
                          }else if (snapshot.hasError) {
                            return new Text("Unable to connect server");
                          }
                          // By default, show a loading spinner
                          return new Center( child: CircularProgressIndicator());
                        },
                      )
                  )),
            ]
        ));
}

Future<List<User>> getSummary() async {
  final prefs = await SharedPreferences.getInstance();
  //String path_ubiattendance1 = prefs.getString('path_ubiattendance');
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  final response = await http.get(path_ubiattendance+'getHistory?uid=$empid&refno=$orgdir');
  print(path_ubiattendance+'getHistory?uid=$empid&refno=$orgdir');
  List responseJson = json.decode(response.body.toString());
  List<User> userList = createUserList(responseJson);
  return userList;
}

List<User> createUserList(List data){
  List<User> list = new List();
  for (int i = 0; i < data.length; i++) {
    String title = Formatdate2(data[i]["AttendanceDate"]);
    String TimeOut=data[i]["TimeOut"]=="00:00:00"?'-':data[i]["TimeOut"].toString().substring(0,5);
    String TimeIn=data[i]["TimeIn"]=="00:00:00"?'-':data[i]["TimeIn"].toString().substring(0,5);
    String thours=data[i]["thours"]=="00:00:00"?'-':data[i]["thours"].toString().substring(0,5);
    String bhour=data[i]["bhour"]==null?'':'Time Off: '+data[i]["bhour"].substring(0,5);
    String timoffend=data[i]["timoffend"];
    String EntryImage=data[i]["EntryImage"]!=''?data[i]["EntryImage"]:'http://ubiattendance.ubihrm.com/assets/img/avatar.png';
    String ExitImage=data[i]["ExitImage"]!=''?data[i]["ExitImage"]:'http://ubiattendance.ubihrm.com/assets/img/avatar.png';
    String checkInLoc=data[i]["checkInLoc"];
    String CheckOutLoc=data[i]["CheckOutLoc"];
    String Latit_in=data[i]["latit_in"];
    String Longi_in=data[i]["longi_in"];
    String Latit_out=data[i]["latit_out"];
    String Longi_out=data[i]["longi_out"];
    String Att_Sts=data[i]["AttendanceStatus"];
    int id = 0;
    User user = new User(
        AttendanceDate: title,thours: thours,id: id,TimeOut:TimeOut,TimeIn:TimeIn,timoffend:timoffend,bhour:bhour,EntryImage:EntryImage,
        checkInLoc:checkInLoc,ExitImage:ExitImage,CheckOutLoc:CheckOutLoc,latit_in: Latit_in,longi_in: Longi_in,
        latit_out: Latit_out,longi_out: Longi_out, AttendanceStatus: Att_Sts);
    list.add(user);
  }
  return list;
}

class AttendanceAppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;
  AttendanceAppHeader(profileimage1,showtabbar1,orgname1){
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
                  MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false,
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