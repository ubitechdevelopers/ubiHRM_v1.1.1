import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../appbar.dart';
import '../reports/flexi_report.dart';
import '../reports/reports.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
import '../home.dart';
import '../leave/leave_reports.dart';
import '../model/model.dart';
import '../services/services.dart';
import '../timeoff/timeoff_reports.dart';


class AllReports extends StatefulWidget {
  @override
  _AllReports createState() => _AllReports();
}
class _AllReports extends State<AllReports> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String buystatus = "";
  String trialstatus = "";
  String orgmail = "";
  String admin_sts = "0";
  var profileimage;
  bool showtabbar;
  String orgName="";

  @override
  void initState() {
    super.initState();
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    showtabbar=false;
    getOrgName();
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
    String empid = prefs.getString('employeeid')??"";
    String organization =prefs.getString('organization')??"";
    String userprofileid =prefs.getString('userprofileid')??"";
    int profiletype =prefs.getInt('profiletype')??0;
    int hrsts =prefs.getInt('hrsts')??0;
    int adminsts =prefs.getInt('adminsts')??0;
    int dataaccess =prefs.getInt('dataaccess')??0;

    Employee emp = new Employee(
      employeeid: empid,
      organization: organization,
      userprofileid: userprofileid,
      profiletype:profiletype,
      hrsts:hrsts,
      adminsts:adminsts,
      dataaccess:dataaccess,
    );

    getAllPermission(emp).then((res) {
      if(mounted) {
        setState(() {
          perAttReport=getModuleUserPermission("68", "view");
          perLeaveReport=getModuleUserPermission("69", "view");
          perFlexiReport=getModuleUserPermission("448", "view");
          print("attendance " + perAttReport);
          print("leave " + perLeaveReport);
          print("flexi " + perFlexiReport);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  Future<bool> sendToHome() async{
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePageMain()), (Route<dynamic> route) => false,
    );
    return false;
  }

  getmainhomewidget() {
    return WillPopScope(
      onWillPop: ()=> sendToHome(),
      child: RefreshIndicator(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor:scaffoldBackColor(),
          endDrawer: new AppDrawer(),
          appBar: new AppHeader(profileimage,showtabbar,orgName),
          bottomNavigationBar:  new HomeNavigation(),
          body:getReportsWidget(),
        ),
        onRefresh: () async {
          Completer<Null> completer = new Completer<Null>();
          await Future.delayed(Duration(seconds: 1)).then((onvalue) {
            completer.complete();
          });
          return completer.future;
        },
      ),
    );
  }

  getReportsWidget(){
    return Stack(
      children: <Widget>[
        Container(
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            decoration: new ShapeDecoration(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
              color: Colors.white,
            ),
            child:ListView(
                children: <Widget>[
                  Text('Reports', style: new TextStyle(fontSize: 22.0, color: appStartColor()),textAlign: TextAlign.center),
                  SizedBox(height: 15.0),
                  perAttReport=='1' ?
                  new RaisedButton(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(const IconData(0xe800, fontFamily: "CustomIcon"),size: 30.0,),
                          SizedBox(width: 17.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('Attendance',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0))
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Reports()),
                      );
                    },
                  ):Center(),


                  SizedBox(height: 6.0),
                  perLeaveReport=='1' ?
                  new RaisedButton(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(const IconData(0xe821, fontFamily: "CustomIcon"), size: 30.0,),
                          SizedBox(width: 17.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('Leave',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LeaveReports()),
                      );
                    },
                  ):Center(),


                  SizedBox(height: 6.0),
                  perAttReport=='1' ?
                  new RaisedButton(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(const IconData(0xe801, fontFamily: "CustomIcon"),size: 30.0,),
                          SizedBox(width: 15.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('Time Off',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TimeoffReports()),
                      );
                    },
                  ):Center(),

                  SizedBox(height: 6.0),
                  perFlexiReport=='1' ?
                  new RaisedButton(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: appStartColor(),
                            ),
                            child: Icon(Icons.av_timer,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                            padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                          ),
                          SizedBox(width: 15.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('Flexi Time',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FlexiReport()),
                      );
                    },
                  ):Center(),

                  (perLeaveReport!='1' &&  perAttReport!='1' && perFlexiReport!='1' ) ?
                  new Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top:100.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width*1,
                        color: appStartColor().withOpacity(0.1),
                        padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                        child:Text("No Reports found for you",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                      ),
                    ),
                  ) : Center()
                ])
        ),
      ],
    );
  }
}

