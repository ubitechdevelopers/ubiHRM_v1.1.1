import 'package:flutter/material.dart';
//import 'package:simple_permissions/simple_permissions.dart';
import 'drawer.dart';
import 'piegraph.dart';
import 'graphs.dart';
import 'global.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'b_navigationbar.dart';
import 'services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'model/model.dart';
import 'leave/myleave.dart';
import 'expence/expenselist.dart';
import 'timeoff/timeoff_summary.dart';
import 'dart:async';
import 'profile.dart';
import 'attandance/home.dart';
import 'all_reports.dart';
import 'appbar.dart';
//import 'services/attandance_fetch_location.dart';
import 'salary/mysalary_list.dart';
import 'package:intl/intl.dart';
import 'settings.dart';


import 'package:connectivity/connectivity.dart';


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
        //    print("HIIIIIIIIIIIIII");
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
      //   print("AAAAAAAAA");
      String empid = prefs.getString('employeeid')??"";
      String organization =prefs.getString('organization')??"";
      String userprofileid =prefs.getString('userprofileid')??"";
      Employee emp = new Employee(employeeid: empid, organization: organization,userprofileid:userprofileid);

      //  await getProfileInfo(emp);
      await getAllPermission(emp);
      await getProfileInfo(emp);
      await getfiscalyear(emp);
      await getovertime(emp);

      perEmployeeLeave= getModulePermission("18","view");
      //print(perEmployeeLeave);
      perLeaveApproval=  getModuleUserPermission("124","view");
      perAttendance=  getModulePermission("5","view");
      perTimeoff=  getModulePermission("179","view");
      perSalary=  getModulePermission("66","view");
      perExpense=  getModulePermission("170","view");
      perFlexi= getModulePermission("448","view");
      await getReportingTeam(emp);

      /*Loc lock = new Loc();
      location_addr = await lock.initPlatformState();*/



      showtabbar =false;
      profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
      // profileimage = new NetworkImage(pic);
//print("ABCDEFGHI");
//print(profileimage);
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

/*        appBar: GradientAppBar(
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
        ),*/
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
                overtime!=null?Divider(height: 10.0,):undertime!=null?Divider(height: 10.0,):Center(),
                SizedBox(height: 20.0,),
                overtime!=null?getimg():undertime!=null?getimg1():Center(),



                SizedBox(height: 20.0,),
                perAttendance=='1'?  Row(children: <Widget>[
                  SizedBox(width: 20.0,),
                  Text("Monthly summary ["+month+"]",style: TextStyle(color: headingColor(), fontSize: 15.0, fontWeight: FontWeight.bold)),
                ]
                ):Center(),

                perAttendance=='1'?  Divider(height: 10.0,):Center(),
                /*SimpleBarChart.withSampleData(),*/
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

                SizedBox(height: 40.0,),
                //SizedBox(width: 40.0,),
                perEmployeeLeave =='1' ?

                Row(children: <Widget>[
                  SizedBox(width: 20.0,),
                  Text("Leave Data ["+fiscalyear+"]",style: TextStyle(color: headingColor(), fontSize: 15.0, fontWeight: FontWeight.bold)),
                ]
                ):Center(),
                Divider(height: 10.0,),

                //   perEmployeeLeave =='1' ? Divider(height: 0.0,):Center(),
                /*SimpleBarChart.withSampleData(),*/

                perEmployeeLeave =='1' ?  new Container(

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
                ):Center(
                  child: Text(""),

                ),
                SizedBox(height: 40.0,),
                Row(children: <Widget>[
                  SizedBox(width: 20.0,),
                 // Text("Monthly Holidays ["+month+"]",style: TextStyle(color: headingColor(), fontSize: 15.0, fontWeight: FontWeight.bold)),
                  Text("Upcoming Holidays",style: TextStyle(color: headingColor(), fontSize: 15.0, fontWeight: FontWeight.bold)),
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
                           //height: MediaQuery.of(context).size.height*.55,
                          height: insideContainerHeight,
                            width: MediaQuery.of(context).size.width*.99,
                          //   height: insideContainerHeight,
                            //width: 400.0,
                            //  padding: new EdgeInsets.all(2.0),
                            //color: Colors.green[50],

                            child: FutureBuilder<List<Holi>>(
                              future: getHolidays(),
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
                                        color: appStartColor().withOpacity(0.1),
                                        padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                        child:Text("No Holidays this month",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                                      ),
                                    );
                                  }
                                }
                                else if (snapshot.hasError) {
                                  return new Text("Unable to connect server");
                                }

                                // By default, show a loading spinner
                                return new Center(child: CircularProgressIndicator());
                              },
                            )
                        ),),
                    ],),

                    //undertime!='null'?getimg1():getimg(),

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




  Widget getimg() {
    return  new  Column(children: <Widget>[
      // SizedBox(width: 20.0,),
      Row(children: <Widget>[
        new  Text("    "+month+"",textAlign: TextAlign.left,style: TextStyle(color: headingColor(), fontSize: 15.0, fontWeight: FontWeight.bold,)),

      ]),
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

