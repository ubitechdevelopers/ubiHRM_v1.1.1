import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/attandance/employee.dart';
import 'package:ubihrm/attandance/outside_fence_report.dart';
import 'package:ubihrm/attandance/periodic_att.dart';
import 'package:ubihrm/services/attandance_services.dart';
import '../all_reports.dart';
import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
import 'cust_date_report.dart';
import 'department_att.dart';
import 'designation_att.dart';
import 'earlyLeavers.dart';
import 'late_comers.dart';
import 'visits_list.dart';

class Reports extends StatefulWidget {
  @override
  _Reports createState() => _Reports();
}

class _Reports extends State<Reports> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String buystatus = "";
  String trialstatus = "";
  String orgmail = "";
  String admin_sts = "0";
  var profileimage;
  bool showtabbar;
  DateTime orgCreatedDate;
  String orgName="";
  Future<DateTime> _listFuture;

  @override
  void initState() {
    super.initState();
    showtabbar =false;
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    getOrgName();
    setAlldata();
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';

    });
  }

  setAlldata() async{
    _listFuture = getOrgCreatedDate();
    _listFuture.then((data) async{
      setState(() {
        orgCreatedDate = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  Future<bool> sendToAllReportsList() async{
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AllReports()), (Route<dynamic> route) => true,
    );
    return false;
  }

  getmainhomewidget(){
    return WillPopScope(
      onWillPop: ()=> sendToAllReportsList(),
      child: new Scaffold(
        key: _scaffoldKey,
        backgroundColor:scaffoldBackColor(),
        endDrawer: new AppDrawer(),
        appBar: new AppHeader(profileimage,showtabbar,orgName),
        bottomNavigationBar: HomeNavigation(),
        body:getReportsWidget(),
      ),
    );
  }

  showDialogWidget(String loginstr){
    return showDialog(context: context, builder:(context) {
      return new AlertDialog(
        title: new Text(
          loginstr,
          style: TextStyle(fontSize: 15.0),),
        content: ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Text('Later',style: TextStyle(fontSize: 13.0)),
              shape: Border.all(),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ),
      );
    }
    );

  }

  getReportsWidget(){
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
          decoration: new ShapeDecoration(
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
            color: Colors.white,
          ),
          child: ListView(
              padding: EdgeInsets.all(0.0),
              children: <Widget>[
                //SizedBox(height: 5.0),
                Text('Attendance Reports', style: new TextStyle(fontSize: 22.0, color: appStartColor(),),textAlign: TextAlign.center),

                SizedBox(height: 22.0),
                new RaisedButton(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(const IconData(0xe80e, fontFamily: "CustomIcon"),size: 30.0,),
                        SizedBox(width: 15.0),
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  child: Text('Daily Attendance',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 19.0),)
                              ),
                              Container(
                                  child: Text('Get Daily Attendance',style: TextStyle(fontSize: 14.0,),)
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                  elevation: 4.0,
                  //  splashColor: Colors.orangeAccent,
                  textColor: Colors.black54,
                  onPressed: () {
                    if(trialstatus=="2"){
                      showDialogWidget("Upgrade to Premium plan to check Get Specific Days Attendance records.");
                    }else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomDateAttendance()),
                      );
                    }
                  },
                ),


                SizedBox(height: 6.0),
                new RaisedButton(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(const IconData(0xe80a, fontFamily: "CustomIcon"),size: 30.0,),
                        SizedBox(width: 15.0),
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  child: Text('Late Comers',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 19.0),)
                              ),
                              Container(
                                  child: Text('Get Late Comers List ',style: TextStyle(fontSize: 14.0,),)
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                  elevation: 4.0,
                  textColor: Colors.black54,
                  onPressed: () {
                    if(trialstatus=="2"){
                      showDialogWidget("Upgrade to Premium plan to check Late Comer's records.");
                    }else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LateComers()),
                      );
                    }
                  },
                ),


                SizedBox(height: 6.0),
                new RaisedButton(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(const IconData(0xe816, fontFamily: "CustomIcon"),size: 30.0,),
                        SizedBox(width: 15.0),
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  child: Text('Early Leavers',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 19.0),)
                              ),
                              Container(
                                  child: Text('Get Early Leavers List ',style: TextStyle(fontSize: 14.0,),)
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                  elevation: 4.0,
                  textColor: Colors.black54,
                  onPressed: () {
                    if(trialstatus=="2"){
                      showDialogWidget("Upgrade to Premium plan to check Early Leavers records.");
                    }else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EarlyLeavers()),
                      );
                    }
                  },
                ),


                SizedBox(height: 6.0),
                new RaisedButton(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(const IconData(0xe80d, fontFamily: "CustomIcon"),size: 30.0,),
                        SizedBox(width: 15.0),
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  child: Text('Punched Visits',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 19.0),)
                              ),
                              Container(
                                  child: Text('List of Punched Visits ',style: TextStyle(fontSize: 14.0,),)
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                  elevation: 4.0,
                  textColor: Colors.black54,
                  onPressed: () {
                    if(trialstatus=="2"){
                      showDialogWidget("Upgrade to Premium plan to check Visited Locations records.");
                    }else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VisitList()),
                      );
                    }
                  },
                ),


                SizedBox(height: 6.0),
                new RaisedButton(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(const IconData(0xe803, fontFamily: "CustomIcon"),size: 30.0,),
                        SizedBox(width: 15.0),
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  child: Text('By Department',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 19.0),)
                              ),
                              Container(
                                  child: Text('Attendance by Department',style: TextStyle(fontSize: 14.0,),)
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                  elevation: 4.0,
                  textColor: Colors.black54,
                  onPressed: () {
                    if(trialstatus=="2"){
                      showDialogWidget("Upgrade to Premium plan to check departmentwise attendance records.");
                    }else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Department_att()),
                      );
                    }
                  },
                ),


                SizedBox(height: 6.0),
                new RaisedButton(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(const IconData(0xe804, fontFamily: "CustomIcon"),size: 30.0,),
                        SizedBox(width: 15.0),
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  child: Text('By Designation',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 19.0),)
                              ),
                              Container(
                                  child: Text('Attendance by Designation',style: TextStyle(fontSize: 14.0,),)
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                  elevation: 4.0,
                  textColor: Colors.black54,
                  onPressed: () {
                    if(trialstatus=="2"){
                      showDialogWidget("Upgrade to Premium plan to check designationwise attendance records.");
                    }else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Designation_att()),
                      );
                    }
                  },
                ),


                SizedBox(height: 6.0),
                new RaisedButton(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(const IconData(0xe806, fontFamily: "CustomIcon"),size: 30.0,),
                        SizedBox(width: 15.0),
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  child: Text('By Employee',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 19.0),)
                              ),
                              Container(
                                  child: Text('Attendance by Employee',style: TextStyle(fontSize: 14.0,),)
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                  elevation: 4.0,
                  textColor: Colors.black54,
                  onPressed: () {
                    if(trialstatus=="2"){
                      showDialogWidget("Upgrade to Premium plan to check Employeewise attendance records.");
                    }else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Employee_list(orgDate: orgCreatedDate)),
                      );
                    }
                  },
                ),


                SizedBox(height: 6.0),
                new RaisedButton(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(const IconData(0xe808, fontFamily: "CustomIcon"),size: 30.0,),
                        SizedBox(width: 15.0),
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  child: Text("Outside Geo Fence",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 19.0),)
                              ),
                              Container(
                                  child: Text("Outside the Geo Fence",style: TextStyle(fontSize: 14.0,),)
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                  elevation: 4.0,
                  textColor: Colors.black54,
                  onPressed: () {
                    if(trialstatus=="2"){
                      showDialogWidget("Upgrade to Premium plan to check records of attendance marked out side the geo fence.");
                    }else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OutSideGeoFence()),
                      );
                    }
                  },
                ),


                SizedBox(height: 6.0),
                new RaisedButton(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(const IconData(0xe811, fontFamily: "CustomIcon"),size: 25.0,),
                        SizedBox(width: 20.0),
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  child: Text('Periodic Attendance',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 19.0),)
                              ),
                              Container(
                                  child: Text('Get Attendance of Specific Duration',style: TextStyle(fontSize: 14.0,),)
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                  elevation: 4.0,
                  textColor: Colors.black54,
                  onPressed: () {
                    if(trialstatus=="2"){
                      showDialogWidget("Upgrade to Premium plan to check last 7 days attendance records.");
                    }else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PeriodicAttendance()),
                      );
                    }
                  },
                ),

                SizedBox(height: 6.0),
              ]),
        ),
      ],
    );
  }
}



