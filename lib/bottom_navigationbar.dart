import 'package:flutter/material.dart';
import 'drawer.dart';
import 'piegraph.dart';
import 'graphs.dart';
import 'global.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

import 'services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'model/model.dart';
import 'myleave.dart';
import 'dart:async';
import 'home.dart';
import 'package:ubihrm/approval.dart';

import 'package:connectivity/connectivity.dart';

void main() => runApp(new TaskyApp());

final mTitle = "Tasks";

class TaskyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeNavigation(),
      //... another code
    );
  }
}

//Home Page
class HomeNavigation extends StatefulWidget {
  // code removed for brevity

  _BootomNavigationState createState() => _BootomNavigationState();
}


// Home Page state
class _BootomNavigationState extends State<HomeNavigation> {
  int _currentIndex = 0;
  String empid;
  String organization;
  Employee emp;
  var PerLeave;
  var PerApprovalLeave;
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
    getAllPermission(emp);
    //  PLeave= "1";
    emp = new Employee(employeeid: empid, organization: organization);

    setState(() {
      PerLeave= getModulePermission("18","view");
      PerApprovalLeave= getModulePermission("124","view");
    });
  }

  Widget build(BuildContext context) {
    return new Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: bottomNavigationColor(),
        ), // sets the inactive color of the `BottomNavigationBar`
        child:  BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (newIndex) {
            if (newIndex == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePageMain()),
              );
              return;
            }
            if (newIndex == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TabbedApp()),
              );
              return;
            }
            if (newIndex == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TabbedApp()),
              );
              return;
            }else if (newIndex == 0) { Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TabbedApp()),
            );

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

              // icon:  new Image.asset("assets/repo.ico", height: 25.0, width: 30.0),

              //   new Tab(icon: new Image.asset("assets/img/logo.png"), text: "Browse"),
              /* icon: new Icon(
                    Icons.library_books,
                    color: Colors.white,
                  ),*/

              icon: Icon(
                  Icons.description,
                  color: Colors.white,
                  size: 25.0),
              title: new Text('Reports',style: TextStyle(color: Colors.white)),
            ),
            BottomNavigationBarItem(
              icon: new Icon(
                  Icons.home,

                  color: Colors.white,
                  size: 25.0 ),
              //  icon:  new Image.asset("assets/Hom.png", height: 30.0, width: 30.0),

              title: new Text('Home', style: TextStyle(color: Colors.orangeAccent)),

            ),
            BottomNavigationBarItem(
              /*  icon:  new Image.asset("assets/approval.png",
                      height: 40.0,
                      width: 35.0),*/
              icon: Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 25.0),
              title: new Text('Approvals',style: TextStyle(color: Colors.white)),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 25.0 ),
                title: Text('Settings',style: TextStyle(color: Colors.white)))

          ],
        )
      // body: HomePage()  // code removed for brevity
    );
  }
}
