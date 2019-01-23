import 'package:flutter/material.dart';
import 'drawer.dart';
import 'graphs.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'global.dart';
import 'services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'model/model.dart';
import 'myleave.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int response;
  Widget mainWidget= new Container(width: 0.0,height: 0.0,);
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mainWidget = loadingWidget();
    });

    String empid = prefs.getString('employeeid')??"";
    String organization =prefs.getString('organization')??"";

    Employee emp = new Employee(employeeid: empid, organization: organization);
    if(empid!='')
     bool ish = await getAllPermission(emp);

    getProfileInfo();
    getReportingTeam();

    islogin().then((Widget configuredWidget) {
      if(home_load_num==0) {
        getProfileInfo();
        getReportingTeam();
        //getModulePermission("178","view");
        home_load_num = 1;
      }

      setState(() {
        mainWidget = configuredWidget;
      });
    });
  }

  Future<Widget> islogin() async{
    final prefs = await SharedPreferences.getInstance();
    int response = prefs.getInt('response')??0;
    if(response==1){
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

      child:
      Text("Loading..", style: TextStyle(fontSize: 10.0,color: Colors.white),),
    ));
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
              //width: MediaQuery.of(context).size.width*0.9,
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
                      child: new GroupedFillColorBarChart.withSampleData()
                  ),
                  Row(children: <Widget>[
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
                      child: new GroupedFillColorBarChart.withSampleData()
                  ),
                  Row(children: <Widget>[
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


                  SizedBox(width: 40.0,),
                  SizedBox(height: 40.0,),
                  Row(children: <Widget>[
                    SizedBox(width: 20.0,),
                    Text("Holidays this month",style: TextStyle(color: headingColor(), fontSize: 16.0, fontWeight: FontWeight.bold)),
                  ]
                  ),
                  Divider(height: 10.0,),
                  SizedBox(height: 10.0,),
                  Row(children: <Widget>[
                   Text('1. Holiday - Makar sankranti 2019',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),


                  ],),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(width: 20.0,),
                      Text('14th Jan',style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold),),

                  ],),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(width: 20.0,),
                      Text('Indian rituals')
                    ],),
                  SizedBox(width: 30.0,),
                  Row(children: <Widget>[
                    Text('2. Holiday - Republic Day 2019',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),


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

                ],
              )
          ),



      ],
    );
  }
}
