import 'package:flutter/material.dart';
import 'drawer.dart';
import 'piegraph.dart';
import 'graphs.dart';
//import 'graphtest.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'global.dart';
import 'services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'model/model.dart';
import 'myleave.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:date_format/date_format.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double height = 0.0;
  double insideContainerHeight=300.0;
  int _currentIndex = 0;
  int response;
  bool loader = true;
  String empid;
  String organization;
  Employee emp;
  Widget mainWidget= new Container(width: 0.0,height: 0.0,);
  @override
  void initState() {
    super.initState();

    initPlatformState();

  }

  initPlatformState() async{
    final prefs = await SharedPreferences.getInstance();

    empid = prefs.getString('employeeid')??"";
    organization =prefs.getString('organization')??"";

    emp = new Employee(employeeid: empid, organization: organization);

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
      showDialog(context: context, child:
      new AlertDialog(
        content: new Text("Internet connection not found!."),
      )
      );
    }
  }

  Future<Widget> islogin() async{
    final prefs = await SharedPreferences.getInstance();
    int response = prefs.getInt('response')??0;
    if(response==1){
      String empid = prefs.getString('employeeid')??"";
      String organization =prefs.getString('organization')??"";
      Employee emp = new Employee(employeeid: empid, organization: organization);
      //getModulePermission("178","view");
      await getProfileInfo(emp);
      await getReportingTeam(emp);
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
     return Center(child:SizedBox(

      //child: Text("Loading..", style: TextStyle(fontSize: 10.0,color: Colors.white),),
      child: new CircularProgressIndicator(),
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
    return  Scaffold(
        backgroundColor:scaffoldBackColor(),
        endDrawer: new AppDrawer(),
        appBar: GradientAppBar(
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
        ),
        bottomNavigationBar:new Theme(
            data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: bottomNavigationColor(),
            ), // sets the inactive color of the `BottomNavigationBar`
            child:  BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (newIndex) {
                if (newIndex == 2) {
                  /* Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              );*/
                  return;
                } else if (newIndex == 0) {
                  /* (admin_sts == '1')
                  ? Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Reports()),
              )
                  : Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );*/

                  return;
                }

                setState(() {
                  _currentIndex = newIndex;
                });
              }, // this will be set when a new tab is tapped
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.library_books,
                    color: Colors.white,
                  ),
                  title: new Text('Reports',style: TextStyle(color: Colors.white)),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.home,
                    color: Colors.orangeAccent,
                  ),
                  title: new Text('Home',
                      style: TextStyle(color: Colors.orangeAccent)),
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    title: Text('Settings',style: TextStyle(color: Colors.white)))
              ],
            )),
        body: homewidget()
    );
  }

  Widget homewidget(){

    return Stack(
      children: <Widget>[
        Container(
            //height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
             // width: MediaQuery.of(context).size.width*0.9,
              decoration: new ShapeDecoration(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                color: Colors.white,
              ),
              child: ListView(

                children: <Widget>[
                  SizedBox(height: 20.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                          onTap: () {
                          },
                          child: Column(
                            children: [
                              new Container(
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: new BoxDecoration(

                                      shape: BoxShape.circle,
                                      image: new DecorationImage(

                                        fit: BoxFit.fill,
                                        image: AssetImage('assets/attendance_icon.png'),
                                      ),
                                      color: circleIconBackgroundColor()
                                  )),
                              Text('My Attendance',
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(fontSize: 15.0, color: Colors.black)),
                            ],
                          )),

                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyLeave()),
                            );
                          },
                          child: Column(
                            children: [
                              new Container(
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage('assets/leave_icon.png'),
                                      ),
                                      color: circleIconBackgroundColor()
                                  )),
                              Text('My Leave',
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(fontSize: 15.0, color: Colors.black)),
                            ],
                          )),
                      GestureDetector(
                          onTap: () {
                          },
                          child: Column(
                            children: [
                              new Container(
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage('assets/timeoff_icon.png'),
                                      ),
                                      color: circleIconBackgroundColor()
                                  )),
                              Text('My Timeoff',
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(fontSize: 15.0, color: Colors.black)),
                            ],
                          )),

                    ],

                  ),
                  SizedBox(height: 20.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                          onTap: () {
                          },
                          child: Column(
                            children: [
                              new Container(
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage('assets/settings.png'),
                                      ),
                                      color:circleIconBackgroundColor()
                                  )),
                              Text(' Settings         ',
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(fontSize: 15.0, color: Colors.black)),
                            ],
                          )),
                      GestureDetector(
                          onTap: () {
                          },
                          child: Column(
                            children: [
                              new Container(
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage('assets/profile.png'),
                                      ),
                                      color: circleIconBackgroundColor()
                                  )),
                              Text('My Profile',
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(fontSize: 15.0, color: Colors.black)),
                            ],
                          )),
                      GestureDetector(
                          onTap: () {
                          },
                          child: Column(
                            children: [
                              new Container(
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage('assets/reports.png'),
                                      ),
                                      color: circleIconBackgroundColor()
                                  )),
                              Text('My Reports',
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(fontSize: 15.0, color: Colors.black)),
                            ],
                          )),

                    ],

                  ),
                  SizedBox(height: 40.0,),
                  Row(children: <Widget>[
                    SizedBox(width: 20.0,),
                    Text("Leave Summary",style: TextStyle(color: headingColor(), fontSize: 16.0, fontWeight: FontWeight.bold)),
                  ]
                  ),

                  Divider(height: 10.0,),
                  /*SimpleBarChart.withSampleData(),*/



                  new Container(
                    padding: EdgeInsets.all(0.2),
                    margin: EdgeInsets.all(0.2),
                    height: 200.0,
                    child: new FutureBuilder<List<Map<String,String>>>(
                        future: getChartDataYes(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.length > 0) {
                              return new StackedHorizontalBarChart.withSampleData(snapshot.data);
                            }
                          }
                          return new Center( child: CircularProgressIndicator());
                        }
                    ),
                    // child: new StackedHorizontalBarChart .withSampleData()
                  ),
              /*    Row(children: <Widget>[
                    Icon(Icons.brightness_1,color: Colors.blue,),
                    SizedBox(width: 20.0,),
                    Text('Leave entitled'),
                    SizedBox(width: 30.0,),
                    Icon(Icons.brightness_1,color: Colors.red,),
                    SizedBox(width: 20.0,),
                    Text('Balance Leave')
                  ],),

                  Row(children: <Widget>[
                    Icon(Icons.brightness_1,color: Colors.green,),
                    SizedBox(width: 20.0,),
                    Text('Leave utilized')
                  ],),
*/

                  // Attendance monthly summary bar graph

                  SizedBox(height: 40.0,),
                  Row(children: <Widget>[
                    SizedBox(width: 20.0,),
                    Text("Attendance monthly summary",style: TextStyle(color: headingColor(), fontSize: 16.0, fontWeight: FontWeight.bold)),
                  ]
                  ),

                  Divider(height: 10.0,),
                  /*SimpleBarChart.withSampleData(),*/
                  new Container(

                    padding: EdgeInsets.all(0.2),
                    margin: EdgeInsets.all(0.2),
                    height: 200.0,

                    child: new FutureBuilder<List<Map<String,String>>>(
                        future: getAttsummaryChart(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.length > 0) {
                              return new DonutAutoLabelChart.withSampleData(snapshot.data);
                            }
                          }
                          return new Center( child: CircularProgressIndicator());
                        }
                    ),

                    //child: new DonutAutoLabelChart .withSampleData(),
                  ),

          /*        Row(children: <Widget>[
                    Icon(Icons.brightness_1,color: Colors.green,),
                    SizedBox(width: 20.0,),
                    Text('Total Present'),
                    SizedBox(width: 30.0,),
                    Icon(Icons.brightness_1,color: Colors.orangeAccent,),
                    SizedBox(width: 20.0,),
                    Text('Total Abscent')
                  ],),

                  Row(children: <Widget>[
                    Icon(Icons.brightness_1,color: Colors.blue,),
                    SizedBox(width: 20.0,),
                    Text('Total Leave')
                  ],),
*/

                  SizedBox(width: 40.0,),
                  SizedBox(height: 40.0,),
                  Row(children: <Widget>[
                    SizedBox(width: 20.0,),

                    Text("Holidays this month",style: TextStyle(color: headingColor(), fontSize: 16.0, fontWeight: FontWeight.bold)),
                  ]
                  ),
                  Divider(height: 10.0,),
                  SizedBox(height: 10.0,),

            new   Row(children: <Widget>[

                    SizedBox(height: height),
                    new Expanded(
                 child:   Container(

                        height: insideContainerHeight,
                        width: 400.0,
              //  padding: new EdgeInsets.all(2.0),
                        //color: Colors.green[50],

                        child: FutureBuilder<List<Holi>>(
                          future: getHolidays(emp),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if(snapshot.data.length>0) {

                                return new ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      var string=snapshot.data[index].name;
                                      var name =  string.replaceAll("Holiday - ", "");
                                 return new Row(
                                 children: <Widget>
                                    [
                                    SizedBox(width: 20.0,),
                                  Text(name+" ",style: TextStyle(color: headingColor(), fontSize: 16.0, fontWeight: FontWeight.bold)),
                                   Text("-"),
                                      //  Text(snapshot.data[index].message),
                                    Text(snapshot.data[index].date,style: TextStyle(color: Colors.grey[600]),),

                                     ],);


                                    }

                                );

                              }else{
                                return new Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*1,
                                    color: Colors.teal.withOpacity(0.1),
                                    padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                    child:Text("No Holiday Found ",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                                  ),
                                );
                              }
                            }
                            else if (snapshot.hasError) {
                              return new Text("Unable to connect server");
                            }

                            // By default, show a loading spinner
                            return new Center( child: CircularProgressIndicator());
                          },
                        )
                    ),),
                  ],)



            /*      Row(children: <Widget>[
                    SizedBox(width: 20.0,),
                    Text("Holidays this month",style: TextStyle(color: headingColor(), fontSize: 16.0, fontWeight: FontWeight.bold)),
                  ]
                  ),
                  Divider(height: 10.0,),
                  SizedBox(height: 10.0,),
                  Row(children: <Widget>[
                   Text('1.Makar sankranti ',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                   Expanded(
                     child: Container(
                      width:0.5,
                     ),
                   ),
                   Container(child:Text("14th Jan 2019",style: TextStyle(color: Colors.grey[600]),)) ,
                  ],
                  )
                  ,
                /*  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(width: 20.0,),
                      Text('14th Jan 2019',style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold),),

                  ],

                  ),*/
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(width: 20.0,),
                      Text('Indian rituals')
                    ],),
                  SizedBox(width: 30.0,),
                  Row(children: <Widget>[
                    Text('2.Republic Day 2019',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),


                  ],),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(width: 20.0,),
                      Text('26th Jan',style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold),),

                    ],),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(width: 20.0,),
                      Text('National holiday on republic day of india')
                    ],),
                  SizedBox(width: 30.0,),
                  Row(children: <Widget>[
                    Text('3. Holiday - Holi 2019',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),


                  ],),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(width: 20.0,),
                      Text('4th Mar',style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold),),
                      Text(' - ',style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold),),
                      Text('9th Mar',style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold),),
                    ],),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(width: 20.0,),
                      Text('Festival of colors')
                    ],),
                  SizedBox(width: 20.0,),
*/
                ],
              )

          ),



      ],
    );
  }
}
