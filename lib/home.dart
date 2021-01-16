import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/employees_list.dart';
import 'package:ubihrm/payroll_expence/expenselist.dart';

import 'all_reports.dart';
import 'attandance/flexi_time.dart';
import 'attandance/home.dart';
import 'attandance/punchlocation_summary.dart';
import 'b_navigationbar.dart';
import 'dashboard.dart';
import 'drawer.dart';
import 'expence/expenselist.dart';
import 'global.dart';
import 'leave/myleave.dart';
import 'login_page.dart';
import 'model/model.dart';
import 'payroll//mypayroll_list.dart';
import 'profile.dart';
import 'salary/mysalary_list.dart';
import 'services/services.dart';
import 'timeoff/timeoff_summary.dart';



class HomePageMain extends StatefulWidget {
  @override
  _HomePageStatemain createState() => _HomePageStatemain();
}

class _HomePageStatemain extends State<HomePageMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static const platform = const MethodChannel('location.spoofing.check');
  var orgname;
  double height = 0.0;
  double insideContainerHeight = 300.0;
  int _currentIndex = 0;
  int response;
  bool loader = true;
  String empid;
  String organization;
  Employee emp;
  String month;
  var profileimage;
  bool showtabbar;
  String orgName = "";
  bool fakeLocationDetected = false;
  String address = "";
  bool _checkLoadedprofile = true;
  String sts="";
  String location_addr = "";

  Widget mainWidget = new Container(
    width: 0.0,
    height: 0.0,
  );
  @override
  void initState() {
    super.initState();
    initPlatformState();
    getOrgName();
    platform.setMethodCallHandler(_handleMethod);
   /*print("orgCreateDate");
    print(orgCreatedDate);
    var orgCreationDate = DateTime.parse(orgCreatedDate);
    print(orgCreationDate.add(Duration(days: 3)));
    if(mailVerifySts == "1")
      print("Shaifali Rathore");*/
  }

  getOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName = prefs.getString('orgname') ?? '';
    });
  }

  initPlatformState() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('MMMM');
    month = formatter.format(now);

    getAreaStatus().then((res) {
      print('lib/home dot dart');
      if (mounted) {
        setState(() {
          areaSts = res.toString();
          print('response'+res.toString());
          if (assignedAreaIds.isNotEmpty && perGeoFence=="1") {
            AbleTomarkAttendance = areaSts;
          }
        });
      }
    }).catchError((onError) {
      print('Exception occured in clling function.......');
      print(onError);
    });

    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        mainWidget = loadingWidget();
      });

      islogin().then((Widget configuredWidget) {
        if(mounted) {
          setState(() {
            mainWidget=configuredWidget;
          });
        }
      });
    } else {
      setState(() {
        mainWidget = plateformstatee();
      });
      showDialog(
        context: context,
        child: new AlertDialog(
          content: new Text("Internet connection not found!."),
        ));
    }
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    print("lib/home.dart's handle method");
    switch (call.method) {
      case "locationAndInternet":
        locationThreadUpdatedLocation = true;
        var long = call.arguments["longitude"].toString();
        var lat = call.arguments["latitude"].toString();
        assign_lat = double.parse(lat);
        assign_long = double.parse(long);
        address = await getAddressFromLati(lat, long);
        globalstreamlocationaddr = address;
        print(call.arguments["mocked"].toString());

        getAreaStatus().then((res) {
          print('home.dart');
          if (mounted) {
            setState(() {
              areaSts = res.toString();
              print('response'+res.toString());
              if (assignedAreaIds.isNotEmpty && perGeoFence == "1") {
                AbleTomarkAttendance = areaSts;
              }
            });
          }
        }).catchError((onError) {
          print('Exception occured in clling function.......');
          print(onError);
        });

        setState(() {
          if (call.arguments["mocked"].toString() == "Yes") {
            fakeLocationDetected = true;
          } else {
            fakeLocationDetected = false;
          }
          if (call.arguments["TimeSpoofed"].toString() == "Yes") {
            timeSpoofed = true;
          }
        });
        break;

        return new Future.value("");
    }
  }

  Future<Widget> islogin() async {
    final prefs = await SharedPreferences.getInstance();
    int response = prefs.getInt('response') ?? 0;
    if (response == 1) {
      String empid = prefs.getString('employeeid') ?? "";
      String organization = prefs.getString('organization') ?? "";
      String userprofileid = prefs.getString('userprofileid') ?? "";
      String empemail = prefs.getString('empemail') ?? "";
      String empnumber = prefs.getString('empnumber') ?? "";
      String email = prefs.getString('email') ?? "";
      String number = prefs.getString('number') ?? "";
      String name = prefs.getString('name') ?? "";

      Employee emp = new Employee(
          employeeid: empid,
          organization: organization,
          userprofileid: userprofileid,
      );


      await getAllPermission(emp);
      await getProfileInfo(emp, context);
      await getfiscalyear(emp);
      await getReportingTeam(emp);

      if(empemail==email || empnumber==number) {
        if (showMailVerificationDialog == 'true') {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () async => false,
                child: new AlertDialog(
                  title: new Text("Verify Email"),
                  content: ButtonBar(
                    children: <Widget>[
                      RaisedButton(
                        child: Text(
                          'VERIFY', style: TextStyle(color: Colors.white),),
                        color: Colors.orange[800],
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          updateCounter();
                          verification(organization, name, email).then((result) {
                            print("result");
                            print(result=="true");
                            if(result=="true") {
                              showDialog(
                                  barrierDismissible: false,
                                  context: _scaffoldKey.currentContext,
                                  builder: (BuildContext context) {
                                    return WillPopScope(
                                        onWillPop: () async => false,
                                        child: new AlertDialog(
                                          title: new Text(
                                            "Email verification link has been sent on your registered Email ID. Kindly verify.",
                                            style: TextStyle(fontSize: 16.0),),
                                          content: RaisedButton(
                                            child: Text('Open Mail',
                                              style: TextStyle(
                                                  color: Colors.white),),
                                            color: Colors.orange[800],
                                            onPressed: () {
                                              Navigator.of(
                                                  _scaffoldKey.currentContext,
                                                  rootNavigator: true).pop();
                                              openEmailApp(context);
                                            },
                                          ),
                                        )
                                    );
                                  }
                              );
                            } else {
                              showDialog(
                                context: _scaffoldKey.currentContext,
                                builder: (context) {
                                  Future.delayed(Duration(seconds: 3), () {
                                    Navigator.of(context).pop(true);
                                  });
                                  return AlertDialog(
                                    content: new Text("Unable to send verification link"),
                                  );
                                });
                            }
                          });
                        },
                      ),
                      FlatButton(
                        shape: Border.all(color: Colors.orange[800]),
                        child: Text(
                          'LATER', style: TextStyle(color: Colors.black87),),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          updateCounter();
                        },
                      ),
                    ],
                  ),
                )
              );
            }
          );
        } else if(showMailVerificationDialog == 'logout') {
          logout();
        }
      }

      perEmployeeLeave = getModulePermission("18", "view");
      perAttendance = getModulePermission("5", "view");
      perTimeoff = getModulePermission("179", "view");
      perSalary = getModulePermission("66", "view");
      perPayroll = getModulePermission("458", "view");
      perPayPeriod = getModulePermission("491", "view");
      perGeoFence = getModulePermission("318", "view");
      perSalaryExpense = getModulePermission("170", "view");
      perPayrollExpense = getModulePermission("473", "view");
      perFlexi = getModulePermission("448", "view");
      perPunchLocation = getModulePermission("305", "view");

      perLeaveApproval = getModuleUserPermission("124", "view");
      perTimeoffApproval = getModuleUserPermission("180", "view");
      perSalaryExpenseApproval = getModuleUserPermission("170", "view");
      perPayrollExpenseApproval = getModuleUserPermission("473","view");
      perAttReport = getModuleUserPermission("68", "view");
      perLeaveReport = getModuleUserPermission("69", "view");
      perFlexiReport = getModuleUserPermission("448", "view");

      showtabbar = false;
      profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);

      profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
        if (mounted) {
          setState(() {
            _checkLoadedprofile = false;
          });
        }
      }));
      return mainScafoldWidget();
    } else {
      return new LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget;
  }

  Widget loadingWidget() {
    return Container(
        decoration: new BoxDecoration(color: Colors.green[100]),
        child: Center(
            child: SizedBox(
              child: new CircularProgressIndicator(),
            )));
  }

  Widget plateformstatee() {
    return new Container(
      decoration: new BoxDecoration(color: Colors.white),
      child: new Center(
        child: new Text(
          "UBIHRM",
          style: TextStyle(fontSize: 30.0, color: Colors.green),
        ),
      ),
    );
  }

  Widget mainScafoldWidget() {
    return WillPopScope(
      //onWillPop: () async => true,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: scaffoldBackColor(),
        endDrawer: new AppDrawer(),
        appBar: new HomeAppHeader(profileimage, showtabbar, orgName),
        bottomNavigationBar: new HomeNavigation(),
        body: homewidget()
      ),
    );
  }

  Card makeDashboardItem(String title, functionname, Imagename) {
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
          child: new InkWell(
            onTap: () {
              if((title=="Dashboard"|| title=="Leave") && fiscalyear=="") {
                showDialog(context: context, child:
                new AlertDialog(
                  content: new Text("Fiscal year is not generated yet"),
                )
                );
              }else{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => functionname),
                );
              }
            },
            child: Column(
              //   crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: [
                new Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                              Imagename),
                        ),
                        color: circleIconBackgroundColor())),
                Text(title,
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 15.0, color: Colors.black)),
              ],
            ),
          ),
        ));
  }

  Widget homewidget() {
    return Stack(
      children: <Widget>[
        Container(
          //height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          // width: MediaQuery.of(context).size.width*0.9,
          decoration: new ShapeDecoration(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            color: Colors.white,
          ),
          child: GridView.count(
            crossAxisCount: 3,
            padding: EdgeInsets.all(3.0),
            children: <Widget>[
              makeDashboardItem("Dashboard",DashboardMain(), 'assets/icons/Dashboard_icon.png'),
              makeDashboardItem("Profile", CollapsingTab(), 'assets/icons/profile_icon.png'),
              makeDashboardItem("Employee", EmployeeList(sts: "1"), 'assets/icons/Employee_icon.png'),
              if(perAttendance == '1') makeDashboardItem("Attendance", HomePage(), 'assets/icons/Attendance_icon.png'),
              if(perEmployeeLeave == '1')  makeDashboardItem("Leave",  MyLeave(), 'assets/icons/leave_icon.png'),
              if(perTimeoff == '1') makeDashboardItem("Time Off", TimeoffSummary(), 'assets/icons/Timeoff_icon.png'),
              if(perPunchLocation == '1') makeDashboardItem("Visits", PunchLocationSummary(), 'assets/icons/visits_icon.png'),
              if(perFlexi == '1') makeDashboardItem("Flexi Time", Flexitime(), 'assets/icons/Flexi_icon.png'),
              if(perSalary == '1') makeDashboardItem("Salary", SalarySummary(), 'assets/icons/Salary_icon.png'),
              if(perPayroll == '1' || perPayPeriod == '1') makeDashboardItem("Payroll", PayrollSummary(), 'assets/icons/Salary_icon.png'),
              if(perSalaryExpense == '1') makeDashboardItem("Expense", MyExpence(), 'assets/icons/Expense_icon.png'),
              if(perPayrollExpense == '1') makeDashboardItem("Expense", MyPayrollExpense(), 'assets/icons/Expense_icon.png'),
              if(perAttendance == '1' || perEmployeeLeave == '1' || perTimeoff == '1') makeDashboardItem("Reports", AllReports(), 'assets/icons/graph_icon.png'),
            ],
          ),
        ),
      ],
    );
  }
  
  logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('response');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), (
        Route<dynamic> route) => false,
    );
  }
}

class HomeAppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;
  HomeAppHeader(profileimage1,showtabbar1,orgname1){
    profileimage = profileimage1;
    orgname = orgname1;
    if (profileimage!=null) {
      _checkLoadedprofile = false;
    };
    showtabbar= showtabbar1;
  }

  @override
  Widget build(BuildContext context) {
    return new GradientAppBar(
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
                      color: Colors.white,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        // image: AssetImage('assets/avatar.png'),
                        image: _checkLoadedprofile ? AssetImage('assets/default.png') : profileimage,
                      )
                  )
              ),
            ),
            Flexible(
              child: Container(
                  padding: const EdgeInsets.all(8.0), child: Text(orgname)
              ),
            )
          ],
        ),
        bottom:
        showtabbar==true ? TabBar(
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: choices.map((Choice choice) {
            return Tab(
              text: choice.title,
            );
          }).toList(),
        ):null
    );
  }
  @override
  Size get preferredSize => new Size.fromHeight(showtabbar==true ? 100.0 : 60.0);

}

void openEmailApp(BuildContext context){
  try{
    AppAvailability.launchApp(Platform.isIOS ? "message://" : "com.google.android.gm").then((_) {
      print("App Email launched!");
    }).catchError((err) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("App Email not found!")
      ));
      print(err);
    });
  } catch(e) {
    print(e);
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Email App not found!")));
  }
}

