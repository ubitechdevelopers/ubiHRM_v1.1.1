import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'appbar.dart';
import 'attandance/flexi_report.dart';
import 'attandance/reports.dart';
import 'b_navigationbar.dart';
import 'drawer.dart';
import 'global.dart';
import 'home.dart';
import 'leave/leave_reports.dart';
import 'model/model.dart';
import 'services/services.dart';
import 'timeoff/timeoff_reports.dart';


class AllReports extends StatefulWidget {
  @override
  _AllReports createState() => _AllReports();
}
class _AllReports extends State<AllReports> {
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

  @override
  void initState() {
    super.initState();
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    showtabbar=false;
    getOrgName();
   /* perAttReport=  getModuleUserPermission("68","view");
    perLeaveReport=  getModuleUserPermission("69","view");*/

  }
  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';

    });
    String empid = prefs.getString('employeeid')??"";
    String organization =prefs.getString('organization')??"";
    String userprofileid =prefs.getString('userprofileid')??"";
    Employee emp = new Employee(employeeid: empid, organization: organization,userprofileid:userprofileid);

    //  await getProfileInfo(emp);
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
  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<bool> sendToHome() async{
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );*/
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePageMain()), (Route<dynamic> route) => false,
    );
    return false;
  }

  getmainhomewidget() {
    return WillPopScope(
      onWillPop: ()=> sendToHome(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor:scaffoldBackColor(),
        endDrawer: new AppDrawer(),
        appBar: new AppHeader(profileimage,showtabbar,orgName),
/*      appBar: GradientAppBar(

          automaticallyImplyLeading: false,

          backgroundColorStart: appStartColor(),
          backgroundColorEnd: appEndColor(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/avatar.png'),
                      )
                  )),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('UBIHRM')
              )
            ],

          ),

        ),*/
        bottomNavigationBar:  new HomeNavigation(),

        body:getReportsWidget(),

      ),
    );
  }

  /*
  mainbodyWidget() {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15.0),
              getReportsWidget(),
              //getMarkAttendanceWidgit(),
            ],
          ),


        ],
      ),

    );
  }
  */

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
            RaisedButton(
              child: Text(
                'Pay Now', style: TextStyle(color: Colors.white,fontSize: 13.0),),
              color: Colors.orange[800],
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                /*       Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage()),
                );*/
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
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            //width: MediaQuery.of(context).size.width*0.9,
            //      height:MediaQuery.of(context).size.height*0.75,
            decoration: new ShapeDecoration(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
              color: Colors.white,
            ),
            child:ListView(
              //    mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //SizedBox(height: 5.0),
                  Text('Reports',
                      style: new TextStyle(fontSize: 22.0, color: appStartColor()),textAlign: TextAlign.center),
                  //SizedBox(height: 10.0),

                  SizedBox(height: 15.0),
                  perAttReport=='1' ?
                  new RaisedButton(
                    //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
                    //      shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
                    //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(
                      //padding: EdgeInsets.only(left:  5.0),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(const IconData(0xe800, fontFamily: "CustomIcon"),size: 30.0,),
                          /*Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: appStartColor(),
                            ),
                            child: Icon(Icons.add_to_home_screen,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                            padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                          ),*/

                          SizedBox(width: 6.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('  Attendance',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0))
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
                    //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
                    //    shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
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
                  perLeaveReport=='1' ?
                  new RaisedButton(
                    //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
                    //      shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
                    //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(

                      //     padding: EdgeInsets.only(left:  5.0),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(const IconData(0xe801, fontFamily: "CustomIcon"),size: 30.0,),
                          /*Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: appStartColor(),
                            ),
                            child: Icon(Icons.alarm_on,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                            padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                          ),*/

                          SizedBox(width: 15.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('Timeoff',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
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



