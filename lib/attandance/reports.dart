import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../all_reports.dart';
import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
import 'Employeewise_att.dart';
import 'attendance_report_yes.dart';
import 'cust_date_report.dart';
import 'department_att.dart';
import 'designation_att.dart';
import 'earlyLeavers.dart';
import 'last_seven_days.dart';
import 'late_comers.dart';
import 'payment.dart';
import 'thismonth.dart';
import 'today_attendance_report.dart';
import 'visits_list.dart';



class Reports extends StatefulWidget {
  @override
  _Reports createState() => _Reports();
}
class _Reports extends State<Reports> {
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

        /*appBar: GradientAppBar(
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

        bottomNavigationBar: HomeNavigation(),
         /*     currentIndex: _currentIndex,
              onTap: (newIndex) {
                if(newIndex==2){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  );
                  return;
                } if (newIndex == 0) {
                  (admin_sts == '1')
                      ? Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Reports()),
                  )
                      : Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                  return;
                }
                if(newIndex==1){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                  return;
                }
                setState((){_currentIndex = newIndex;});

              }, // this will be set when a new tab is tapped
              items: [
                (admin_sts == '1')
                    ? BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.library_books,color: Colors.orangeAccent
                  ),
                  title: new Text('Reports',style: TextStyle(color: Colors.orangeAccent),),
                )
                    : BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.person,color: Colors.orangeAccent
                  ),
                  title: new Text('Profile',style: TextStyle(color: Colors.orangeAccent),),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.home,color: Colors.black54,),
                  title: new Text('Home',style: TextStyle(color: Colors.black54),),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    title: Text('Settings')
                )
              ],*/


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
                color: Colors.orange,
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
            Text('Attendance Reports',
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

                              child: Text("Today's",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                          //    width: MediaQuery.of(context).size.width*0.5,

                              child: Text("Show Today's Attendance ",style: TextStyle(fontSize: 15.0,),)
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
              textColor: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TodayAttendance()),
                );
              },
            ),



            ///////2nd button///////
            SizedBox(height: 6.0),
            new RaisedButton(
              //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
          //    shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
              //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Container(
                //   color: Colors.red,
                //     padding: EdgeInsets.only(left:  5.0),
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[


                    Container(


                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: appStartColor(),
                      ),
                      child: Icon(Icons.timer_off,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    ),

                    SizedBox(width: 15.0),
                    Expanded(

                      child:Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(

                              child: Text('Late Comers',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                            //    width: MediaQuery.of(context).size.width*0.5,

                              child: Text('Get Late Comers List ',style: TextStyle(fontSize: 15.0,),)
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
              textColor: Colors.black,
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



           /* new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.timer_off,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('Late Comers',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Get Late Comers List ',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: Colors.green[400],
              elevation: 4.0,
              splashColor: Colors.greenAccent,
              textColor: Colors.white,
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

            */

            /////// 3rd button///////
            SizedBox(height: 6.0),
            new RaisedButton(
              //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
          //    shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
              //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Container(
                //   color: Colors.red,
                //     padding: EdgeInsets.only(left:  5.0),
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[


                    Container(


                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: appStartColor(),
                      ),
                      child: Icon(Icons.desktop_windows,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    ),

                    SizedBox(width: 15.0),
                    Expanded(

                      child:Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(

                              child: Text('Early Leavers',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                            //    width: MediaQuery.of(context).size.width*0.5,

                              child: Text('Get Early Leavers List ',style: TextStyle(fontSize: 15.0,),)
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
              textColor: Colors.black,
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

/*
            SizedBox(height: 6.0),
            new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.desktop_windows,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('Early Leavers',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Get Early Leavers List ',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: Colors.lightBlue[300],
              elevation: 4.0,
              splashColor: Colors.lightBlueAccent,
              textColor: Colors.white,
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

            */

          /////////  4th button  ////////


          SizedBox(height: 6.0),
          new RaisedButton(
            //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
        //    shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
            //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: Container(
              //   color: Colors.red,
              //     padding: EdgeInsets.only(left:  5.0),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[


                  Container(


                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: appStartColor(),
                    ),
                    child: Icon(Icons.location_on,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  ),

                  SizedBox(width: 15.0),
                  Expanded(

                    child:Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(

                            child: Text('Punched Visits',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                        ),
                        Container(
                          //    width: MediaQuery.of(context).size.width*0.5,

                            child: Text('List of punched visits ',style: TextStyle(fontSize: 15.0,),)
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
            textColor: Colors.black,
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


/*
            SizedBox(height: 6.0),
            new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.location_on,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('Punched Visits',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('List of punched visits ',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: Colors.deepPurple[200],
              elevation: 4.0,
              splashColor: Colors.lightBlueAccent,
              textColor: Colors.white,
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

            */

/*
/////////5th button ///////////

            SizedBox(height: 6.0),
            new RaisedButton(
              //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
          //    shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
              //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Container(
                //   color: Colors.red,
                //     padding: EdgeInsets.only(left:  5.0),
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[


                    Container(


                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: appStartColor(),
                      ),
                      child: Icon(Icons.group,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    ),

                    SizedBox(width: 15.0),
                    Expanded(

                      child:Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(

                              child: Text('Time Off',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                            //    width: MediaQuery.of(context).size.width*0.5,

                              child: Text('Get Employees Time Off List ',style: TextStyle(fontSize: 15.0,),)
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
              textColor: Colors.black,
              onPressed: () {
                if(trialstatus=="2"){
                  showDialogWidget("Upgrade to Premium plan to check Employee's Timeoff records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TimeOffList()),
                  );
                }
              },
            ),
*/

/*
            SizedBox(height: 6.0),
            new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.group,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('Time Off',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Get Employees Time Off List ',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: Colors.cyan,
              elevation: 4.0,
              splashColor: Colors.cyanAccent,
              textColor: Colors.white,
              onPressed: () {
                if(trialstatus=="2"){
                showDialogWidget("Upgrade to Premium plan to check Employee's Timeoff records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TimeOffList()),
                  );
                }
              },
            ),

        */

/////////6th button ///////////

            SizedBox(height: 6.0),
            new RaisedButton(
              //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
         //     shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
              //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Container(
                //   color: Colors.red,
                //     padding: EdgeInsets.only(left:  5.0),
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[


                    Container(


                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: appStartColor(),
                      ),
                      child: Icon(Icons.perm_contact_calendar,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    ),

                    SizedBox(width: 15.0),
                    Expanded(

                      child:Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(

                              child: Text('Custom Date',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                            //    width: MediaQuery.of(context).size.width*0.5,

                              child: Text('Get Specific Days Attendance',style: TextStyle(fontSize: 15.0,),)
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
              textColor: Colors.black,
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
/*
            SizedBox(height: 6.0),
            new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.perm_contact_calendar,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('Custom Date',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Get Specific Days Attendance',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: Colors.lightGreen,
              elevation: 4.0,
              splashColor: Colors.lightGreenAccent,
              textColor: Colors.white,
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

            */

/////////7th button ///////////

            SizedBox(height: 6.0),
            new RaisedButton(
              //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
         //     shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
              //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Container(
                //   color: Colors.red,
                //     padding: EdgeInsets.only(left:  5.0),
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[


                    Container(


                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: appStartColor(),
                      ),
                      child: Icon(Icons.perm_contact_calendar,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    ),

                    SizedBox(width: 15.0),
                    Expanded(

                      child:Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(

                              child: Text("Yesterday's ",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                            //    width: MediaQuery.of(context).size.width*0.5,

                              child: Text("Get Yesterday's List",style: TextStyle(fontSize: 15.0,),)
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
              textColor: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YesAttendance()),
                );
              },
            ),

          /*

            SizedBox(height: 6.0),
            new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.perm_contact_calendar,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text("Yesterday's ",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text("Get Yesterday's List",style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: Colors.pink[200],
              elevation: 4.0,
              splashColor: Colors.tealAccent,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YesAttendance()),
                );
              },
            ),

            */

       /////////8th button ///////////

            SizedBox(height: 6.0),
            new RaisedButton(
              //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
       //       shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
              //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Container(
                //   color: Colors.red,
                //     padding: EdgeInsets.only(left:  5.0),
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[


                    Container(


                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: appStartColor(),
                      ),
                      child: Icon(Icons.perm_contact_calendar,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    ),

                    SizedBox(width: 15.0),
                    Expanded(

                      child:Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(

                              child: Text('Last 7 Days',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                            //    width: MediaQuery.of(context).size.width*0.5,

                              child: Text('Get Last 7 Days Attendance',style: TextStyle(fontSize: 15.0,),)
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
              textColor: Colors.black,
              onPressed: () {
                if(trialstatus=="2"){
                  showDialogWidget("Upgrade to Premium plan to check last 7 days attendance records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LastSeven()),
                  );
                }
              },
            ),

/*
            SizedBox(height: 6.0),
            new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.perm_contact_calendar,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('Last 7 Days',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Get Last 7 Days Attendance',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: Colors.amber,
              elevation: 4.0,
              splashColor: Colors.amberAccent,
              textColor: Colors.white,
              onPressed: () {
                if(trialstatus=="2"){
                showDialogWidget("Upgrade to Premium plan to check last 7 days attendance records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LastSeven()),
                  );
                }
              },
            ),

      */

            /////////9th button ///////////

            SizedBox(height: 6.0),
            new RaisedButton(
              //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
             //  shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
              //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Container(
                //   color: Colors.red,
                //     padding: EdgeInsets.only(left:  5.0),
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[


                    Container(


                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: appStartColor(),
                      ),
                      child: Icon(Icons.perm_contact_calendar,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    ),

                    SizedBox(width: 15.0),
                    Expanded(

                      child:Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(

                              child: Text('Last 30 Days',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                            //    width: MediaQuery.of(context).size.width*0.5,

                              child: Text('Get Last 30 Days Attendance',style: TextStyle(fontSize: 15.0,),)
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
              textColor: Colors.black,
              onPressed: () {
                if(trialstatus=="2"){
                  showDialogWidget("Upgrade to Premium plan to check last 30 days attendance records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThisMonth()),
                  );
                }
              },
            ),

/*
            SizedBox(height: 6.0),
            new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.perm_contact_calendar,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('Last 30 Days',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Get Last 30 Days Attendance',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: Colors.teal[300],
              elevation: 4.0,
              splashColor: Colors.tealAccent,
              textColor: Colors.white,
              onPressed: () {
                if(trialstatus=="2"){
                showDialogWidget("Upgrade to Premium plan to check last 30 days attendance records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThisMonth()),
                  );
                }
              },
            ),
*/

            /////////10th button ///////////

            SizedBox(height: 6.0),
            new RaisedButton(
              //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
        //      shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
              //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Container(
                //   color: Colors.red,
                //     padding: EdgeInsets.only(left:  5.0),
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[


                    Container(


                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: appStartColor(),
                      ),
                      child: Icon(Icons.perm_contact_calendar,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    ),

                    SizedBox(width: 15.0),
                    Expanded(

                      child:Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(

                              child: Text('By Department',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                            //    width: MediaQuery.of(context).size.width*0.5,

                              child: Text('Attendance by Department',style: TextStyle(fontSize: 15.0,),)
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
              textColor: Colors.black,
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
/*
            SizedBox(height: 6.0),
            new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.perm_contact_calendar,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('By Department',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Attendance by Department',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: Colors.deepPurple[200],
              elevation: 4.0,
              splashColor: Colors.deepPurpleAccent,
              textColor: Colors.white,
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

        */

            /////////11th button ///////////

            SizedBox(height: 6.0),
            new RaisedButton(
              //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
        //      shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
              //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Container(
                //   color: Colors.red,
                //     padding: EdgeInsets.only(left:  5.0),
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[


                    Container(


                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: appStartColor(),
                      ),
                      child: Icon(Icons.perm_contact_calendar,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    ),

                    SizedBox(width: 15.0),
                    Expanded(

                      child:Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(

                              child: Text('By Designation',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                            //    width: MediaQuery.of(context).size.width*0.5,

                              child: Text('Attendance by Designation',style: TextStyle(fontSize: 15.0,),)
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
              textColor: Colors.black,
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
/*
            SizedBox(height: 6.0),
            new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.perm_contact_calendar,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('By Designation',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Attendance by Designation',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: Colors.cyan,
              elevation: 4.0,
              splashColor: Colors.cyanAccent,
              textColor: Colors.white,
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
*/

            /////////11th button ///////////

            SizedBox(height: 6.0),
            new RaisedButton(
              //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
         //     shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
              //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Container(
                //   color: Colors.red,
                //     padding: EdgeInsets.only(left:  5.0),
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[


                    Container(


                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: appStartColor(),
                      ),
                      child: Icon(Icons.perm_contact_calendar,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    ),

                    SizedBox(width: 15.0),
                    Expanded(

                      child:Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(

                              child: Text('By Employee',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                            //    width: MediaQuery.of(context).size.width*0.5,

                              child: Text('Attendance by Employee',style: TextStyle(fontSize: 15.0,),)
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
              textColor: Colors.black,
              onPressed: () {
                if(trialstatus=="2"){
                  showDialogWidget("Upgrade to Premium plan to check Employeewise attendance records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmployeeWise_att()),
                  );
                }
              },
            ),


    /*        SizedBox(height: 6.0),
            new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.perm_contact_calendar,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('By Employee',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Attendance by Employee',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: Colors.lightGreen,
              elevation: 4.0,
              splashColor: Colors.lightGreenAccent,
              textColor: Colors.white,
              onPressed: () {
                if(trialstatus=="2"){
                  showDialogWidget("Upgrade to Premium plan to check Employeewise attendance records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmployeeWise_att()),
                  );
                }
              },
            ),*/


          ]),
    ),
    ],
    );
  }
}



