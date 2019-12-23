import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../all_reports.dart';
import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
import 'timeoff_list.dart';



class TimeoffReports extends StatefulWidget {
  @override
  _TimeoffReports createState() => _TimeoffReports();
}
class _TimeoffReports extends State<TimeoffReports> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 1;
  String _orgName;
  String buystatus = "";
  String trialstatus = "";
  String orgmail = "";
  String admin_sts = "0";
  var profileimage;
  String orgName="";

  bool showtabbar;
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
    //  print('99999999999999' + _orgName.toString());
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

/*  showDialogWidget(String loginstr){

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
            RaisedButton(
              child: Text(
                'Pay Now', style: TextStyle(color: Colors.white,fontSize: 13.0),),
              color: Colors.orangeAccent,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage()),
                );
              },
            ),
          ],
        ),
      );
    }
    );

  }*/

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
                Text('Timeoff Reports',
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


                        Container(


                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: appStartColor(),
                          ),
                          child: Icon(Icons.access_alarms,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                          padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        ),

                        SizedBox(width: 15.0),
                        Expanded(

                          child:Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(

                                  child: Text("Employees on Timeoff",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                              ),
                              /*Container(
                                //    width: MediaQuery.of(context).size.width*0.5,

                                  child: Text("Show Today's Attendance ",style: TextStyle(fontSize: 15.0,),)
                              ),*/
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
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TimeOffList()),
                    );
                  },
                ),
              ]),
        ),
      ],
    );
  }
}



