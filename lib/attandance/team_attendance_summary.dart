import 'dart:async';
import 'dart:convert';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/services/attandance_services.dart';
import '../image_view.dart';
import '../appbar.dart';
import '../drawer.dart';
import '../global.dart';
import 'attendance_summary.dart';
import 'home.dart';
import '../image_view.dart';

void main() => runApp(new MyTeamAtt());

class MyTeamAtt extends StatefulWidget {
  @override
  _MyTeamAtt createState() => _MyTeamAtt();
}

const labelMonth = 'Month';
const labelDate = 'Date';
const labelWeekDay = 'Week Day';
class _MyTeamAtt extends State<MyTeamAtt> {
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
  bool res = true;
  DateTime startDate1;
  DateTime startDate;
  DateTime endDate;
  DateTime endDate1;
  DateTime selectedDate;
  DateTime selectedDate1;
  DateTime firstDate;
  DateTime lastDate;
  //DateTime selectedDate;
  DateTime date;
  //List<DateTime> markedDates;
  TextEditingController _searchController;
  FocusNode searchFocusNode;
  String empname = "";
  bool _checkLoaded = true;

  @override
  void initState() {
    super.initState();
    _searchController = new TextEditingController();
    searchFocusNode = FocusNode();
    initPlatformState();
    getOrgName();
    /*startDate = DateTime.now().subtract(Duration(days: 30));
    startDate1 = DateTime(startDate.year, startDate.month, startDate.day);
    print("startDate");
    print(startDate);
    print(startDate1);
    endDate = DateTime.now();
    endDate1 = DateTime(endDate.year, endDate.month, endDate.day);
    print("endDate");
    print(endDate);
    print(endDate1);
    date = startDate1;*/

    startDate = DateTime.now().subtract(Duration(days: 30));
    startDate1 = DateTime(startDate.year, startDate.month, startDate.day);
    print("startDate");
    print(startDate);
    print(startDate1);
    endDate = DateTime.now();
    endDate1 = DateTime(endDate.year, endDate.month, endDate.day);
    print("endDate");
    print(endDate);
    print(endDate1);
    selectedDate = DateTime.now().subtract(Duration(days: 0));
    selectedDate1 = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    print("selectedDate");
    print(selectedDate);
    print(selectedDate1);
    date = selectedDate;
    print("date");
    print(date);
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
  }

  onSelect(data) {
    if (data != null && data.toString() != '') {
      setState(() {
        res = true;
        date = data;
        print("date");
        print(date);
      });
    }else{
      setState(() {
        res = false;
      });
    }
    print("Selected Date -> $data");
  }

  onWeekSelect(data) {
    print("Selected week starting at -> $data");
  }

  _monthNameWidget(monthName) {
    return Container(
      child: Text(monthName, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black87)),
      padding: EdgeInsets.only(top: 8, bottom: 4),
    );
  }

  /*getMarkedIndicatorWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        margin: EdgeInsets.only(left: 1, right: 1),
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
      ),
      Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
      )
    ]);
  }*/

  dateTileBuilder(date, selectedDate, rowIndex, dayName, isDateMarked, isDateOutOfRange) {
    bool isSelectedDate = date.compareTo(selectedDate) == 0;
    Color fontColor = isDateOutOfRange ? Colors.black26 : Colors.black87;
    TextStyle normalStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: fontColor);
    TextStyle selectedStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black87);
    TextStyle dayNameStyle = TextStyle(fontSize: 14, color: fontColor);
    List<Widget> _children = [
      Text(dayName, style: dayNameStyle),
      Text(date.day.toString(), style: !isSelectedDate ? normalStyle : selectedStyle),
    ];

    /*if (isDateMarked == true) {
      _children.add(getMarkedIndicatorWidget());
    }*/

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      alignment: Alignment.center,
      //padding: EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: !isSelectedDate ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: _children,
      ),
    );
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
          appBar: new AppHeader(profileimage,showtabbar,orgName),
          bottomNavigationBar:new HomeNavigation(),
          body: getWidgets(context),
        ),
        onRefresh: () async {
          Completer<Null> completer = new Completer<Null>();
          await Future.delayed(Duration(seconds: 1)).then((onvalue) {
            getTeamSummary(date,empname);
            empname='';
            completer.complete();
          });
          return completer.future;
        },
      )
    );
  }

  getWidgets(context){
    return Container(
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
                      child:InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
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
                                    child: Text('Team', style: TextStyle(fontSize: 18,color: Colors.orange[800],fontWeight:FontWeight.bold)
                                    ),
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
                  ]
              ),
              /// My log start here

              CalendarStrip(
                startDate: startDate,
                endDate: endDate,
                selectedDate: date,
                onDateSelected: onSelect,
                onWeekSelected: onWeekSelect,
                dateTileBuilder: dateTileBuilder,
                iconColor: Colors.black87,
                monthNameWidget: _monthNameWidget,
                //markedDates: markedDates,
                containerDecoration: BoxDecoration(color: appStartColor().withOpacity(0.1)),
                addSwipeGesture: true,
              ),
              Container(
                padding: EdgeInsets.only(top:5.0,),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Team's Attendance Log", style: new TextStyle(fontSize: 18.0, color: Colors.black87,)),
                    Text(" ("+new DateFormat("d-MMM-y").format(date)+")",style: new TextStyle(fontSize: 16.0, color: Colors.black87, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
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
                            empname='';
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyTeamAtt()),
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

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10.0,),
                  SizedBox(width: MediaQuery.of(context).size.width*0.02),
                  Container(
                    width: MediaQuery.of(context).size.width*0.40,
                    child:Text('Name',style: TextStyle(color: Colors.green,fontWeight:FontWeight.bold,fontSize: 16.0),),
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
              new Expanded(
                  child: res == true ? mainbody() : Center()
                //child: mainbody()
              ),

              /*Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height*.55,
                width: MediaQuery.of(context).size.width*.99,
                //padding: EdgeInsets.only(bottom: 15.0),
                color: Colors.white,
                child: new FutureBuilder<List<User>>(
                  future: getTeamSummary(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length>0) {
                        return new ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new RaisedButton(
                                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                      child: Container(
                                        padding: EdgeInsets.only(left:  0.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            SizedBox(width: 15.0),
                                            Expanded(

                                              child: Container(
                                                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                                  child: Text(snapshot.data[index].AttendanceDate.toString(),textAlign:TextAlign.left,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),)
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      color: Colors.white,
                                      elevation: 4.0,
                                      textColor: Colors.black,
                                    ),
                                    mainbody(),
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
                            child:Text("No Expense History",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                          ),
                        );
                    } else if (snapshot.hasError) {
                      return new Text("Unable to connect server");
                    }
                    return new Center( child: CircularProgressIndicator());
                  },
                ),
                //////////////////////////////////////////////////////////////////////---------------------------------
              ),
            )*/
            ]
        ));
  }

  mainbody() {
    return Container(
        child: FutureBuilder<List<User>>(
          future: getTeamSummary(formatter.format(date),empname),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print("snapshot.data.length");
              print(snapshot.data.length);
              if(snapshot.data.length>0) {
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
                                      Text(snapshot.data[index].EmpName
                                          .toString(), style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),),

                                      InkWell(
                                        child: Text('Time In: ' +
                                            snapshot.data[index]
                                                .checkInLoc.toString(),
                                            style: TextStyle(
                                                color: Colors.black54,
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
                                                .CheckOutLoc.toString(),
                                          style: TextStyle(
                                              color: Colors.black54,
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
                                            new TextSpan(text: 'Status: ',
                                              style: TextStyle(
                                                color: Colors.black54,),),
                                            new TextSpan(
                                              text: snapshot.data[index]
                                                  .AttendanceStatus.toString(),
                                              style: TextStyle(
                                                color: snapshot.data[index]
                                                    .AttendanceStatus ==
                                                    'Present' ? Colors
                                                    .blueAccent :
                                                snapshot.data[index]
                                                    .AttendanceStatus ==
                                                    'Absent' ? Colors.red :
                                                snapshot.data[index]
                                                    .AttendanceStatus ==
                                                    'Holiday' ? Colors.green :
                                                snapshot.data[index]
                                                    .AttendanceStatus ==
                                                    'Half Day'
                                                    ? Colors.blueGrey
                                                    :
                                                snapshot.data[index]
                                                    .AttendanceStatus ==
                                                    'Week off' ? Colors.orange :
                                                snapshot.data[index]
                                                    .AttendanceStatus == 'Leave'
                                                    ? Colors.lightBlueAccent
                                                    :
                                                snapshot.data[index]
                                                    .AttendanceStatus ==
                                                    'Comp Off' ? Colors
                                                    .purpleAccent :
                                                snapshot.data[index]
                                                    .AttendanceStatus ==
                                                    'Work from Home' ? Colors
                                                    .brown[200] :
                                                snapshot.data[index]
                                                    .AttendanceStatus ==
                                                    'Unpaid Leave' ? Colors
                                                    .brown :
                                                snapshot.data[index]
                                                    .AttendanceStatus ==
                                                    'Half Day - Unpaid' ? Colors
                                                    .grey : Colors.black54,
                                              ),),
                                          ],
                                        ),
                                      ),

                                      snapshot.data[index]
                                          .bhour.toString() != '' ? Container(
                                        color: Colors.orangeAccent,
                                        child: Text("" + snapshot.data[index]
                                            .bhour.toString() + " Hr(s)",
                                          style: TextStyle(),),
                                      ) : SizedBox(height: 0.0,),

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
                                        Text(snapshot.data[index].TimeIn
                                            .toString(), style: TextStyle(
                                            fontWeight: FontWeight.bold),),
                                        GestureDetector(
                                          // When the child is tapped, show a snackbar
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImageView(
                                                          myimage: snapshot
                                                              .data[index]
                                                              .EntryImage,
                                                          org_name: "UBIHRM")),
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
                                                        fit: BoxFit.fill,
                                                        image: new NetworkImage(
                                                            snapshot
                                                                .data[index]
                                                                .EntryImage)
                                                    )
                                                )),),
                                        ),
                                        // Text(snapshot.data[index].AttendanceDate.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0,color: Colors.grey),),
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
                                        Text(snapshot.data[index].TimeOut
                                            .toString(), style: TextStyle(
                                            fontWeight: FontWeight.bold),),
                                        GestureDetector(
                                          // When the child is tapped, show a snackbar
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImageView(
                                                          myimage: snapshot
                                                              .data[index]
                                                              .ExitImage,
                                                          org_name: "UBIHRM")),
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
                                                        fit: BoxFit.fill,
                                                        image: new NetworkImage(
                                                            snapshot
                                                                .data[index]
                                                                .ExitImage)
                                                    )
                                                )),),),
                                        // Text(snapshot.data[index].AttendanceDate.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0,color: Colors.grey),),
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
                      "Team data not found", style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.center,),
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return new Text("Unable to connect server");
            }
            // By default, show a loading spinner
            return new Center( child: CircularProgressIndicator());
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
  String EntryImage;
  String checkInLoc;
  String ExitImage;
  String CheckOutLoc;
  String latit_in;
  String longi_in;
  String latit_out;
  String longi_out;
  String AttendanceStatus;
  String EmpName;
  int id=0;
  User({this.AttendanceDate,this.thours,this.id,this.TimeOut,this.TimeIn,this.bhour,this.EntryImage,this.checkInLoc,this.ExitImage,this.CheckOutLoc,this.latit_in,this.longi_in,this.latit_out,this.longi_out,this.AttendanceStatus,this.EmpName});
}

String dateFormatter(String date_) {
  // String date_='2018-09-2';
  var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun','Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  var dy = ['st', 'nd', 'rd', 'th', 'th', 'th','th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th','st','nd','rd', 'th', 'th', 'th', 'th', 'th', 'th', 'th','st'];
  var date = date_.split("-");
  return(date[2]+""+dy[int.parse(date[2])-1]+" "+months[int.parse(date[1])-1]);
}


Future<List<User>> getTeamSummary(date,empname) async {
  final prefs = await SharedPreferences.getInstance();
  //String path_ubiattendance1 = prefs.getString('path_ubiattendance');
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  int profiletype = prefs.getInt('profiletype')??0;
  int hrsts =prefs.getInt('hrsts')??0;
  int adminsts =prefs.getInt('adminsts')??0;
  int dataaccess = prefs.getInt('dataaccess')??0;
  print(path_ubiattendance+'getTeamHistory?uid=$empid&refno=$orgdir&date=$date&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  final response = await http.get(path_ubiattendance+'getTeamHistory?uid=$empid&refno=$orgdir&date=$date&profiletype=$profiletype&hrsts=$hrsts&adminsts=$adminsts&dataaccess=$dataaccess');
  List responseJson = json.decode(response.body.toString());
  List<User> userList = createUserList(responseJson,empname);
  return userList;
}

List<User> createUserList(List data, String empname){
  List<User> list = new List();
  if(empname.isNotEmpty)
    for (int i = 0; i < data.length; i++) {
      String title = Formatdate2(data[i]["AttendanceDate"]);
      String TimeOut=data[i]["TimeOut"]=="00:00:00"?'-':data[i]["TimeOut"].toString().substring(0,5);
      String TimeIn=data[i]["TimeIn"]=="00:00:00"?'-':data[i]["TimeIn"].toString().substring(0,5);
      String thours = '';//data[i]["thours"]=="00:00:00"?'-':data[i]["thours"].toString().substring(0,5);

      String bhour=data[i]["bhour"]==null?'':'Time Off: '+data[i]["bhour"].substring(0,5);
      String EntryImage=data[i]["EntryImage"]!=''?data[i]["EntryImage"]:'http://ubiattendance.ubihrm.com/assets/img/avatar.png';
      String ExitImage=data[i]["ExitImage"]!=''?data[i]["ExitImage"]:'http://ubiattendance.ubihrm.com/assets/img/avatar.png';
      String checkInLoc=data[i]["checkInLoc"];
      String CheckOutLoc=data[i]["CheckOutLoc"];

      String Latit_in=data[i]["latit_in"];
      String Longi_in=data[i]["longi_in"];
      String Latit_out=data[i]["latit_out"];
      String Longi_out=data[i]["longi_out"];
      String Att_Sts=data[i]["AttendanceStatus"];
      String name=data[i]["EmpName"];

      int id = 0;
      User user = new User(EmpName:name,
          AttendanceDate: title,thours: thours,id: id,TimeOut:TimeOut,TimeIn:TimeIn,bhour:bhour,EntryImage:EntryImage,
          checkInLoc:checkInLoc,ExitImage:ExitImage,CheckOutLoc:CheckOutLoc,latit_in: Latit_in,longi_in: Longi_in,
          latit_out: Latit_out,longi_out: Longi_out, AttendanceStatus: Att_Sts);
      if(name.toLowerCase().contains(empname.toLowerCase()))
        list.add(user);
    }
  else
    for (int i = 0; i < data.length; i++) {
      String title = Formatdate2(data[i]["AttendanceDate"]);
      String TimeOut=data[i]["TimeOut"]=="00:00:00"?'-':data[i]["TimeOut"].toString().substring(0,5);
      String TimeIn=data[i]["TimeIn"]=="00:00:00"?'-':data[i]["TimeIn"].toString().substring(0,5);
      String thours = '';//data[i]["thours"]=="00:00:00"?'-':data[i]["thours"].toString().substring(0,5);

      String bhour=data[i]["bhour"]==null?'':'Time Off: '+data[i]["bhour"].substring(0,5);
      String EntryImage=data[i]["EntryImage"]!=''?data[i]["EntryImage"]:'http://ubiattendance.ubihrm.com/assets/img/avatar.png';
      String ExitImage=data[i]["ExitImage"]!=''?data[i]["ExitImage"]:'http://ubiattendance.ubihrm.com/assets/img/avatar.png';
      String checkInLoc=data[i]["checkInLoc"];
      String CheckOutLoc=data[i]["CheckOutLoc"];

      String Latit_in=data[i]["latit_in"];
      String Longi_in=data[i]["longi_in"];
      String Latit_out=data[i]["latit_out"];
      String Longi_out=data[i]["longi_out"];
      String Att_Sts=data[i]["AttendanceStatus"];
      String name=data[i]["EmpName"];

      int id = 0;
      User user = new User(EmpName:name,
          AttendanceDate: title,thours: thours,id: id,TimeOut:TimeOut,TimeIn:TimeIn,bhour:bhour,EntryImage:EntryImage,
          checkInLoc:checkInLoc,ExitImage:ExitImage,CheckOutLoc:CheckOutLoc,latit_in: Latit_in,longi_in: Longi_in,
          latit_out: Latit_out,longi_out: Longi_out, AttendanceStatus: Att_Sts);
      list.add(user);
    }
  return list;
}