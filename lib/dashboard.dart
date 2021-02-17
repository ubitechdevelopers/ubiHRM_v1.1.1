import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appbar.dart';
import 'b_navigationbar.dart';
import 'drawer.dart';
import 'global.dart';
import 'graphs.dart';
import 'login_page.dart';
import 'model/model.dart';
import 'piegraph.dart';
import 'services/services.dart';

class DashboardMain extends StatefulWidget {
  @override
  _DashboardStatemain createState() => _DashboardStatemain();
}

class _DashboardStatemain extends State<DashboardMain> {
  // StreamLocation sl = new StreamLocation();
  double height = 0.0;
  double insideContainerHeight=300.0;
  int _currentIndex = 0;
  int response;
  bool loader = true;
  String empid;
  String organization;
  Employee emp;
  String month;
  var profileimage;
  bool showtabbar;
  String orgName="";
  bool _checkLoadedprofile = true;
  String location_addr = "";

  Widget mainWidget= new Container(width: 0.0,height: 0.0,);
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

  initPlatformState() async{
    final prefs = await SharedPreferences.getInstance();

    var now = new DateTime.now();
    print("---------------->"+now.toString());
    var formatter = new DateFormat('MMMM yyyy');
    month = formatter.format(now);
    print("---------------->>>>"+month);

    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        mainWidget = loadingWidget();
      });
      islogin().then((Widget configuredWidget) {
        setState(() {
          mainWidget = configuredWidget;
        });
      });
    }else{
      setState(() {
        mainWidget = plateformstatee();
      });
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            content: new Text("Internet connection not found"),
          );
        });
      /*showDialog(context: context, child:
      new AlertDialog(
        content: new Text("Internet connection not found!."),
      )
      );*/
    }
  }

  Future<Widget> islogin() async{
    final prefs = await SharedPreferences.getInstance();
    int response = prefs.getInt('response')??0;
    if(response==1){
      //print("AAAAAAAAA");
      String empid = prefs.getString('employeeid')??"";
      String organization =prefs.getString('organization')??"";
      String userprofileid =prefs.getString('userprofileid')??"";
      Employee emp = new Employee(employeeid: empid, organization: organization,userprofileid:userprofileid);

      await getfiscalyear(emp);
      await getovertime(emp);

      showtabbar =false;
      profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
      profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
        if (mounted) {
          setState(() {
            _checkLoadedprofile = false;
          });
        }
      }));
      return mainScafoldWidget();
    }else{
      return new LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget;
  }

  Widget loadingWidget(){
    return Container(
        decoration: new BoxDecoration(color: Colors.green[100]),
        child: Center(
            child:SizedBox(
              //child: Text("Loading..", style: TextStyle(fontSize: 10.0,color: Colors.white),),
              child: new CircularProgressIndicator(),
            )
        ));
  }

  Widget plateformstatee(){
    return new Container(
      decoration: new BoxDecoration(color: Colors.white),
      child: new Center(
        child: new Text("UBIHRM", style: TextStyle(fontSize: 30.0,color: Colors.green),),
      ),
    );
  }

  Widget mainScafoldWidget(){
    //print("BBBBBB");
    return  Scaffold(
        backgroundColor:scaffoldBackColor(),
        endDrawer: new AppDrawer(),
        appBar: new AppHeader(profileimage,showtabbar,orgName),
        bottomNavigationBar:new HomeNavigation(),
        body: homewidget()
    );
  }

  Widget homewidget(){
    // print("CCCCCCCC");
    return Stack(
      children: <Widget>[
        Container(
          //height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            // width: MediaQuery.of(context).size.width*0.9,
            decoration: new ShapeDecoration(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
              color: Colors.white,
            ),
            child: ListView(
              children: <Widget>[
                //overtime!=null?SizedBox(height: 10.0,):undertime!=null?SizedBox(height: 10.0,):Center(),
                overtime!=null?getimg():undertime!=null?getimg1():Center(),
                overtime!=null?SizedBox(height: 20.0,):undertime!=null?SizedBox(height: 20.0,):Center(),
                //SizedBox(height: 20.0,),
                perAttendance=='1'?Row(children: <Widget>[
                  //SizedBox(width: 20.0,),
                  Text("Monthly summary ["+month+"]",style: TextStyle(color: headingColor(), fontSize: 15.0, fontWeight: FontWeight.bold)),
                ]
                ):Center(),

                perAttendance=='1'?  Divider(height: 10.0,):Center(),
                perAttendance=='1'?  new Container(
                  padding: EdgeInsets.all(0.2),
                  margin: EdgeInsets.all(0.2),
                  height: 200.0,
                  child: new FutureBuilder<List<Map<String,String>>>(
                    future: getAttsummaryChart(),
                    builder: (context, snapshot)
                    {
                      if (snapshot.hasData){
                        if (snapshot.data.length > 0)
                        {
                          return new DonutAutoLabelChart.withSampleData(snapshot.data);
                        }
                        return new Center(
                            child: CircularProgressIndicator()
                        );
                      }
                      //return new Center( child: Text("No data found"), );
                      return new Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width*1,
                          color: appStartColor().withOpacity(0.1),
                          padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                          child:Text("No data found",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                        ),
                      );
                      // return new Center( child: CircularProgressIndicator());
                    }
                  ),
                  //child: new DonutAutoLabelChart .withSampleData(),
                ):Center(),

                perAttendance =='1' ?SizedBox(height: 40.0,):Center(),

                perEmployeeLeave =='1' ?
                Row(children: <Widget>[
                  SizedBox(width: 20.0,),
                  Text("Leave Data ["+fiscalyear+"]",style: TextStyle(color: headingColor(), fontSize: 15.0, fontWeight: FontWeight.bold)),
                ]
                ):Center(),
                perEmployeeLeave =='1' ? Divider(height: 10.0,):Center(),
                perEmployeeLeave =='1' ?  new Container(
                  padding: EdgeInsets.all(0.2),
                  margin: EdgeInsets.all(0.2),
                  height: 200.0,
                  child: new FutureBuilder<List<Map<String,String>>>(
                      future: getChartDataLeave(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.length > 0) {
                            return new StackedHorizontalBarChart.withSampleData(snapshot.data);
                          }
                          //return new Center( child: Text("No data found"), );
                          return new Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width*1,
                              color: appStartColor().withOpacity(0.1),
                              padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                              child:Text("No data found",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                            ),
                          );
                        }
                        //return new Center( child: Text("No data found"), );
                        return new Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width*1,
                            color: appStartColor().withOpacity(0.1),
                            padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                            child:Text("No data found",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                          ),
                        );
                      }
                  ),
                  // child: new StackedHorizontalBarChart .withSampleData()
                ):Center(),

                perEmployeeLeave =='1' ?SizedBox(height: 40.0,):Center(),
                //SizedBox(height: 20.0,),

                Row(children: <Widget>[
                  SizedBox(width: 20.0,),
                  // Text("Monthly Holidays ["+month+"]",style: TextStyle(color: headingColor(), fontSize: 15.0, fontWeight: FontWeight.bold)),
                  Flexible(child:
                    Text("Upcoming Holidays ["+fiscalyear+"]",style: TextStyle(color: headingColor(), fontSize: 15.0, fontWeight: FontWeight.bold))),
                  ]
                ),
                Divider(height: 10.0,),
                SizedBox(height: 10.0,),
                new Column(
                  children: <Widget>[
                    new Row(children: <Widget>[
                      SizedBox(height: height),
                      new Expanded(
                        child: Container(
                            height: MediaQuery.of(context).size.height*.1,
                            width: MediaQuery.of(context).size.width*.99,
                            child: FutureBuilder<List<Holi>>(
                              future: getHolidays(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  print("snapshot.data.length------->>>>");
                                  print(snapshot.data.length);
                                  if(snapshot.data.length>0) {
                                    return new ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          var string=snapshot.data[index].name;
                                          var name =  string.replaceAll("Holiday - ", "");
                                          return new Column(
                                            children: <Widget>[
                                              new Row(
                                                children: <Widget>[
                                                  SizedBox(width: 20.0,),
                                                  Text(name+" ",style: TextStyle(color: headingColor(), fontSize: 16.0, fontWeight: FontWeight.bold)),
                                                  Text("-"),
                                                  //  Text(snapshot.data[index].message),
                                                  Text(snapshot.data[index].date,style: TextStyle(color: Colors.grey[600]),textAlign: TextAlign.right),

                                                ],),
                                            ],);
                                        }
                                    );
                                  }else{
                                    return new Center(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width*1,
                                        color: appStartColor().withOpacity(0.1),
                                        padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                        child:Text("No upcoming holidays",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                                      ),
                                    );
                                  }
                                }else if (snapshot.hasError) {
                                  return new Text("Unable to connect server");
                                }
                                // By default, show a loading spinner
                                return new Center(child: CircularProgressIndicator());
                              },
                            )
                        ),),
                    ],),
                  ],)
              ],
            )
        ),
      ],
    );
  }


  Widget getimg() {
    return  new  Column(children: <Widget>[
      // SizedBox(width: 20.0,),
      Row(children: <Widget>[
        new  Text("    "+month+"",textAlign: TextAlign.left,style: TextStyle(color: headingColor(), fontSize: 15.0, fontWeight: FontWeight.bold,)),
      ]),
      Divider(),
      Container(
        height: 165,
        width: 120,
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: new Border.all(
            color: Colors.green,
            width: 2.5,
          ),
        ),

        child: new Center(
          child: new
          Text(
            "Overtime \n     "+overtime,
            style: TextStyle(
                fontSize: 16.0,
                color: overtime!=''? Colors.green:appStartColor()),
          ),
        ),
      ), ]);
  }

  Widget getimg1() {
    return  new
    Column(children: <Widget>[
      // SizedBox(width: 20.0,),
      Row(children: <Widget>[
        new  Text("     "+month+"",textAlign: TextAlign.left,style: TextStyle(color: headingColor(), fontSize: 16.0, fontWeight: FontWeight.bold,)),
      ]),
      Divider(),
      Container(
        height: 165,
        width: 120,
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: new Border.all(
            color: Colors.red,
            width: 2.5,
          ),
        ),
        child: new Center(
          child: new

          Text(
            "Undertime \n    "+undertime,
            style: TextStyle(
                fontSize: 16.0,
                color: undertime!=''? Colors.redAccent:appStartColor()),
          ),

        ),
      ),
    ]
    );
  }



}

