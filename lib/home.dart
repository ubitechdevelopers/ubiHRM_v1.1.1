import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/CirclePainter.dart';
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
import 'payroll/mypayroll_list.dart';
import 'profile.dart';
import 'salary/mysalary_list.dart';
import 'services/services.dart';
import 'timeoff/timeoff_summary.dart';

class HomePageMain extends StatefulWidget {
  @override
  _HomePageStatemain createState() => _HomePageStatemain();
}

class _HomePageStatemain extends State<HomePageMain> with TickerProviderStateMixin, WidgetsBindingObserver{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AnimationController _controller;
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
  int adminsts=0;
  int hrsts=0;
  int divhrsts=0;
  //int plansts=0;
  //int empcount=0;
  bool fakeLocationDetected = false;
  String address = "";
  bool _checkLoadedprofile = true;
  String sts="";
  String location_addr = "";
  double _visible = 0.25;
  double _visible1 = 0.25;

  Widget mainWidget = new Container(
    width: 0.0,
    height: 0.0,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();
    initPlatformState();
    getOrgName();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  initPlatformState() async {
    print("Lib home initplatformstate");
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
      print('Exception occurred in calling function.......');
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

  getOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName = prefs.getString('orgname') ?? '';
      hrsts = prefs.getInt('hrsts')??0;
      adminsts = prefs.getInt('adminsts')??0;
      divhrsts = prefs.getInt('divhrsts')??0;
    });
  }

  Future<Widget> islogin() async {
    final prefs = await SharedPreferences.getInstance();
    int response = prefs.getInt('response') ?? 0;
    if (response == 1) {
      String empid = prefs.getString('employeeid') ?? "";
      String organization = prefs.getString('organization') ?? "";
      String userprofileid = prefs.getString('userprofileid') ?? "";
      String empemail = prefs.getString('empemail') ?? "";
      print("empemail");print(empemail);
      String empnumber = prefs.getString('empnumber') ?? "";
      print("empnumber");print(empnumber);
      String email = prefs.getString('email') ?? "";
      print("email");print(email);
      String number = prefs.getString('number') ?? "";
      print("number");print(number);
      String name = prefs.getString('name') ?? "";
      plansts = prefs.getInt('plansts');
      empcount = prefs.getInt('empcount');
      attcount = prefs.getInt('attcount');

      Employee emp = new Employee(
          employeeid: empid,
          organization: organization,
          userprofileid: userprofileid,
      );

      await getAllPermission(emp);
      await getProfileInfo(emp, context);
      await getfiscalyear(emp);
      await getReportingTeam(emp);

      if((adminsts==1 || divhrsts==1 || hrsts==1) && plansts==0 && empcount<2) {
        _visible = 0.25;
      }else if((adminsts==1 || divhrsts==1 || hrsts==1) && plansts==0 && empcount>1 && attcount==0) {
        _visible1 = 1.0;
      }else {
        _visible = 1.0;
        _visible1 = 1.0;
      }

      if(empemail==email || empnumber==number){
        print("Inside if");
        if (showMailVerificationDialog == "true") {
          print("Inside if of if");
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
          print("Inside else of if");
          logout();
        }
      } else if(showMailVerificationDialog == 'logout') {
        print("Inside else of if");
        logout();
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
            if( _visible!=0.25 && _visible1!=0.25 &&(title=="Dashboard"|| title=="Leave") && fiscalyear=="") {
              showDialog(context: context, child:
                new AlertDialog(
                  content: new Text("Fiscal year is not generated yet"),
                )
              );
            }else if(_visible==0.25 && _visible1==0.25 && (title=="Profile" || title=="Employee")){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => functionname),
              );
            }else if(_visible==0.25 && _visible1!=0.25 && (title=="Profile" || title=="Employee" || title=="Attendance")){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => functionname),
              );
            }else if(_visible!=0.25 && _visible1!=0.25){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => functionname),
              );
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              ((adminsts==1 || divhrsts==1 || hrsts==1) && (plansts==0 && empcount<2) && title=="Employee")?CustomPaint(
                painter: CirclePainter(
                  0,
                  _controller,
                  color: appStartColor(),
                ),
                child: ScaleTransition(
                    scale: Tween(begin: 0.90, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Curves.fastOutSlowIn,
                      ),
                    ),
                    child: new Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                              Imagename),
                        ),
                      color: circleIconBackgroundColor())))):((adminsts==1 || divhrsts==1 || hrsts==1) && (plansts==0 && empcount>1 && attcount==0) && title=="Attendance")?CustomPaint(
                  painter: CirclePainter(
                    0,
                    _controller,
                    color: appStartColor(),
                  ),
                  child: ScaleTransition(
                      scale: Tween(begin: 0.90, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                      child: new Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                    Imagename),
                              ),
                              color: circleIconBackgroundColor())))):new Container(
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
              ((adminsts==1 || divhrsts==1 || hrsts==1) && (plansts==0 && empcount<2)&& title=="Employee")?ScaleTransition(
                  scale: Tween(begin: 0.80, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),),
                  child: Text(title,
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.bold)),
                ):((adminsts==1 || divhrsts==1 || hrsts==1) && (plansts==0 && empcount>1 && attcount==0) && title=="Attendance")?ScaleTransition(
                scale: Tween(begin: 0.90, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),),
                child: Text(title,
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.bold)),
                ):Text(title,
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 15.0, color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }

  Widget homewidget() {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          decoration: new ShapeDecoration(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            color: Colors.white,
          ),
          child: GridView.count(
            crossAxisCount: 3,
            padding: EdgeInsets.all(3.0),
            children: <Widget>[
              Opacity(opacity:_visible,child: makeDashboardItem("Dashboard", DashboardMain(), 'assets/icons/Dashboard_icon.png')),
              makeDashboardItem("Profile", CollapsingTab(), 'assets/icons/profile_icon.png'),
              makeDashboardItem("Employee", EmployeeList(sts: 1), 'assets/icons/Employee_icon.png'),
              if(perAttendance == '1') Opacity(opacity:_visible1,child: makeDashboardItem("Attendance", HomePage(), 'assets/icons/Attendance_icon.png')),
              if(perEmployeeLeave == '1') Opacity(opacity:_visible,child: makeDashboardItem("Leave",  MyLeave(), 'assets/icons/leave_icon.png')),
              if(perTimeoff == '1') Opacity(opacity:_visible,child: makeDashboardItem("Time Off", TimeoffSummary(), 'assets/icons/Timeoff_icon.png')),
              if(perPunchLocation == '1') Opacity(opacity:_visible,child: makeDashboardItem("Visits", PunchLocationSummary(), 'assets/icons/visits_icon.png')),
              if(perFlexi == '1') Opacity(opacity:_visible,child: makeDashboardItem("Flexi Time", Flexitime(), 'assets/icons/Flexi_icon.png')),
              if(perSalary == '1') Opacity(opacity:_visible,child: makeDashboardItem("Salary", SalarySummary(), 'assets/icons/Salary_icon.png')),
              if(perPayroll == '1' || perPayPeriod == '1') Opacity(opacity:_visible,child: makeDashboardItem("Payroll", PayrollSummary(), 'assets/icons/Salary_icon.png')),
              if(perSalaryExpense == '1') Opacity(opacity:_visible,child: makeDashboardItem("Expense", MyExpence(), 'assets/icons/Expense_icon.png')),
              if(perPayrollExpense == '1') Opacity(opacity:_visible,child: makeDashboardItem("Expense", MyPayrollExpense(), 'assets/icons/Expense_icon.png')),
              if(perAttendance == '1' || perEmployeeLeave == '1' || perTimeoff == '1') Opacity(opacity:_visible,child: makeDashboardItem("Reports", AllReports(), 'assets/icons/graph_icon.png')),
            ],
          ),
        ),
        ((adminsts==1 || divhrsts==1 || hrsts==1) && (plansts==0 && empcount<2))?Positioned(
          left:55.0,
          top:220.0,
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0)
              ),
              color: Colors.transparent
            ),
            child:Padding(
              padding: const EdgeInsets.only(top:10.0, right:10.0, left:10.0, bottom:10.0),
              child: Text("Kindly tap on the Employee Icon to add an employee", style: new TextStyle(
                color: Colors.black54,
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              )),
            ),
          ),
        ):((adminsts==1 || divhrsts==1 || hrsts==1) && (plansts==0 && empcount>1 && attcount==0))?Center(
          child: Container(
            width: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(10.0)
                ),
                color: Colors.transparent
            ),
            child:Padding(
              padding: const EdgeInsets.only(top:10.0, right:10.0, left:10.0, bottom:10.0),
              child: Text("Kindly tap on the Attendance Icon to punch Attendance", style: new TextStyle(
                color: Colors.black54,
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              )),
            ),
          ),
        ):Center()
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

