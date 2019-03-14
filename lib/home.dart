import 'package:flutter/material.dart';
import 'drawer.dart';
import 'piegraph.dart';
import 'graphs.dart';
import 'global.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'b_navigationbar.dart';
//import 'bottom_navigationbar.dart';
import 'services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'model/model.dart';
import 'myleave.dart';
import 'dart:async';
import 'profile.dart';
import 'package:ubihrm/attandance/home.dart';
import 'package:ubihrm/approval.dart';

import 'package:connectivity/connectivity.dart';


class HomePageMain extends StatefulWidget {
  @override
  _HomePageStatemain createState() => _HomePageStatemain();
}

class _HomePageStatemain extends State<HomePageMain> {
  double height = 0.0;
  double insideContainerHeight=300.0;
  int _currentIndex = 0;
  int response;
  bool loader = true;
  String empid;
  String organization;
  Employee emp;

  var profileimage;
  bool _checkLoadedprofile = true;
  Widget mainWidget= new Container(width: 0.0,height: 0.0,);
  @override
  void initState() {
    super.initState();

    initPlatformState();


   /* profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    profileimage.resolve(new ImageConfiguration()).addListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoadedprofile = false;
        });

      }
    });*/
  }

  initPlatformState() async{
    final prefs = await SharedPreferences.getInstance();

    empid = prefs.getString('employeeid')??"";
    organization =prefs.getString('organization')??"";
    emp = new Employee(employeeid: empid, organization: organization);
    getAllPermission(emp);
    //  PLeave= "1";
    empid = prefs.getString('employeeid')??"";
    organization =prefs.getString('organization')??"";
    emp = new Employee(employeeid: empid, organization: organization);
    getAllPermission(emp);
    await getProfileInfo(emp);
    perL= getModulePermission("18","view");

    perA=  '1';
    perAtt=  getModulePermission("124","view");
    perTimeO=  getModulePermission("124","view");
    perReport=  getModulePermission("124","view");
    perSet=  getModulePermission("124","view");
    perAttMS=  getModulePermission("124","view");
    perHoliday=  getModulePermission("124","view");
    //prefs.setString("PerLeave", PerLeave1);
    //prefs.setString("PerApprovalLeave", PerApprovalLeave1);



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

      await getProfileInfo(emp);
      await getReportingTeam(emp);

     profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
     // profileimage = new NetworkImage(pic);

      profileimage.resolve(new ImageConfiguration()).addListener((_, __) {
        if (mounted) {
          setState(() {
            _checkLoadedprofile = false;
          });

        }
      });
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
    return  Scaffold(
        backgroundColor:scaffoldBackColor(),
        endDrawer: new AppDrawer(),
        appBar: GradientAppBar(
          backgroundColorStart: appStartColor(),
          backgroundColorEnd: appEndColor(),
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

    GestureDetector(
    // When the child is tapped, show a snackbar
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CollapsingTab()),
      );
        },
              child:Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                     // image: AssetImage('assets/avatar.png'),
                      image: _checkLoadedprofile ? AssetImage('assets/avatar.png') : profileimage,
                      )
                  )),),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('UBIHRM')
              )
            ],

          ),
        ),
        bottomNavigationBar:new HomeNavigation(),

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
                    perAtt=='1'?  GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
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
                                    image: AssetImage('assets/attendance_icon.png'),
                                    ),
                                    color: circleIconBackgroundColor()
                                )),
                            Text('My Attendance',
                                textAlign: TextAlign.center,
                                style: new TextStyle(fontSize: 15.0, color: Colors.black)),
                          ],
                        )):Center(),

                    perA=='1'?  GestureDetector(
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
                        )):Center(),


                    perTimeO=='1'?  GestureDetector(
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
                        )):Center(),

                  ],

                ),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   perSet=='1'? GestureDetector(
                        onTap: () {
                        },
                        child: Column(
                          children: [
                            new
                              Container(
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
                        )):Center(),

                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CollapsingTab()),
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
                                      image: AssetImage('assets/profile.png'),
                                    ),
                                    color: circleIconBackgroundColor()
                                )),
                            Text('My Profile',
                                textAlign: TextAlign.center,
                                style: new TextStyle(fontSize: 15.0, color: Colors.black)),
                          ],
                        )),
                   perReport=='1'?   GestureDetector(
                        onTap: () {
                        },
                        child: Column(
                          children: [
                            new


                            Container(
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
                        )):Center(),

                  ],

                ),
                SizedBox(height: 40.0,),

                perL =='1' ? Row(children: <Widget>[
                  SizedBox(width: 20.0,),
                  Text("Leave Summary",style: TextStyle(color: headingColor(), fontSize: 16.0, fontWeight: FontWeight.bold)),
                ]
                ):Center(),

                perL =='1' ? Divider(height: 10.0,):Center(),
                /*SimpleBarChart.withSampleData(),*/

               perL =='1' ?  new Container(

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
                ):Center(
                  child: Text(""),

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
                perAttMS=='1'?  Row(children: <Widget>[
                  SizedBox(width: 20.0,),
                  Text("Attendance monthly summary",style: TextStyle(color: headingColor(), fontSize: 16.0, fontWeight: FontWeight.bold)),
                ]
                ):Center(),

                perAttMS=='1'?  Divider(height: 10.0,):Center(),
                /*SimpleBarChart.withSampleData(),*/
                perAttMS=='1'?  new Container(

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
                return new Center(
                    child: CircularProgressIndicator());

                }
                return new Center( child: Text("No data found"), );
                // return new Center( child: CircularProgressIndicator());
                }

                  ),

                  //child: new DonutAutoLabelChart .withSampleData(),
                ):Center(),

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

                new Column(
                  children: <Widget>[
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
                                          var name =  string.replaceAll("Holiday - ", "");                            return new Column(
                                            children: <Widget>
                                            [
                                              new Row(
                                                children: <Widget>
                                                [
                                                  SizedBox(width: 20.0,),
                                                  Text(name+" ",style: TextStyle(color: headingColor(), fontSize: 16.0, fontWeight: FontWeight.bold)),
                                                  Text("-"),
                                                  //  Text(snapshot.data[index].message),
                                                  Text(snapshot.data[index].date,style: TextStyle(color: Colors.grey[600]),textAlign: TextAlign.right),

                                                ],),
                                            /*  new Row(
                                                children: <Widget>
                                                [
                                                  SizedBox(width: 20.0,),
                                                  snapshot.data[index].message.toString() != '-'
                                                      ? Container(

                                                    //  SizedBox(width: 20.0,),
                                                    child: Text("Indian Ritual"+snapshot.data[index].message,style: TextStyle(color: Colors.grey[600]),),
                                                  ): Center(),
                                                  Divider(color: Colors.black45,),

                                                ],)*/
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
                    ],),

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
