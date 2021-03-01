import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/reports/compoffleave.dart';
import 'package:url_launcher/url_launcher.dart';

import '../reports/all_reports.dart';
import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
import 'employee_leave.dart';



class LeaveReports extends StatefulWidget {
  @override
  _LeaveReports createState() => _LeaveReports();
}
class _LeaveReports extends State<LeaveReports> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 1;
  String _orgName;
  String buystatus = "";
  String trialstatus = "";
  String orgmail = "";
  String admin_sts = "0";
  var profileimage;
  bool showtabbar;
  String orgName="";
  int hrsts=0;
  int adminsts=0;
  int divhrsts=0;
  int profiletype=0;

  @override
  void initState() {
    super.initState();
    showtabbar =false;
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    getOrgName();
  }
  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
      profiletype =prefs.getInt('profiletype')??0;
      hrsts =prefs.getInt('hrsts')??0;
      adminsts =prefs.getInt('adminsts')??0;
      divhrsts =prefs.getInt('divhrsts')??0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<bool> sendToAllReportsList() async{
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );*/
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AllReports()), (Route<dynamic> route) => true,
    );
    return false;
  }

  getmainhomewidget(){
    return WillPopScope(
      onWillPop: ()=> sendToAllReportsList(),
      child: RefreshIndicator(
        child: new Scaffold(
          key: _scaffoldKey,
          backgroundColor:scaffoldBackColor(),
          endDrawer: new AppDrawer(),
          appBar: new AppHeader(profileimage,showtabbar,orgName),
          bottomNavigationBar: HomeNavigation(),
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

  loader(){
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset(
                  'assets/spinner.gif', height: 80.0, width: 80.0),
            ]),
      ),
    );
  }

  launchMap(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print( 'Could not launch $url');
    }
  }

  getReportsWidget(){
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
          //width: MediaQuery.of(context).size.width*0.9,
          //  height:MediaQuery.of(context).size.height*0.75,
          decoration: new ShapeDecoration(
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
            color: Colors.white,
          ),
          child: ListView(
              padding: EdgeInsets.all(0.0),

              children: <Widget>[
                //SizedBox(height: 5.0),
                Text('Leave Reports',
                    style: new TextStyle(fontSize: 22.0, color: appStartColor(),),textAlign: TextAlign.center),


                ///// 1st button//////
                SizedBox(height: 16.0),
                new RaisedButton(
                  //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
                  //   shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
                  //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Container(
                    //     padding: EdgeInsets.only(left:  5.0),
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(const IconData(0xe821, fontFamily: "CustomIcon"), size: 30.0,),
                        /*Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: appStartColor(),
                          ),
                          child: Icon(Icons.directions_walk,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                          padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        ),*/
                        SizedBox(width: 15.0),
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  child: Text("Employees on Leave",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 19.0),)
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmployeeLeaveList()),
                    );
                  },
                ),

                SizedBox(height: 6.0),
                perCompOff == '1'?
                ((hrsts==1 || adminsts==1 || divhrsts==1) || ((profiletype==0 || profiletype==2) && perCompOffReport=='1'))?
                new RaisedButton(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(const IconData(0xe821, fontFamily: "CustomIcon"), size: 30.0,),
                        /*Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: appStartColor(),
                          ),
                          child: Icon(Icons.directions_walk,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                          padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        ),*/
                        SizedBox(width: 15.0),
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  child: Text("Compensatory Leave",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 19.0),)
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
                      MaterialPageRoute(builder: (context) => CompOffLeave()),
                    );
                  },
                ):Center():Center(),
              ]),
        ),
      ],
    );
  }
}



