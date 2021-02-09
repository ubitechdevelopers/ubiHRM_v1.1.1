import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'all_approvals.dart';
import 'global.dart';
import 'home.dart';
import 'model/model.dart';
import 'profile.dart';
import 'services/services.dart';
import 'settings.dart';

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
  int adminsts=0;
  int hrsts=0;
  int divhrsts=0;
  String empid;
  String organization;
  Employee emp;
  var PerLeave;
  var PerApprovalLeave;
  String userprofileid;
  //int empcount=0;
  //int plansts=0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('employeeid') ?? "";
    organization = prefs.getString('organization') ?? "";
    userprofileid = prefs.getString('userprofileid') ?? "";
    hrsts = prefs.getInt('hrsts')??0;
    adminsts = prefs.getInt('adminsts')??0;
    divhrsts = prefs.getInt('divhrsts')??0;
    plansts = prefs.getInt('plansts');
    empcount = prefs.getInt('empcount');

    emp = new Employee(employeeid: empid,
        organization: organization,
        userprofileid: userprofileid);

    getCountAproval().then((res) {
      if(mounted) {
        setState(() {
          approval_count = res;
        });
      }
    });
    print('------>123');
    print(approval_count);
    print('------>123');
  }

  Widget build(BuildContext context) {
    return new Theme(
      data: Theme.of(context).copyWith(
        // sets the background color of the `BottomNavigationBar`
        canvasColor: bottomNavigationColor(),
      ), // sets the inactive color of the `BottomNavigationBar`
      child:BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: const Color(0xFF2845E7),
        items: [
          /* BottomNavigationBarItem(
              icon: new Icon(
                  Icons.description,
                  color: Colors.white,
                  size: 25.0 ),
              //  icon:  new Image.asset("assets/Hom.png", height: 30.0, width: 30.0),
              title: new Text('Reports', style: TextStyle(color: Colors.white)),
            ),*/

          /*BottomNavigationBarItem(
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
                title: Text('Settings',style: TextStyle(color: Colors.white))),*/
          new  BottomNavigationBarItem(
            icon: new Stack(
              children: <Widget>[
                new Icon(Icons.check_circle_outline,color: Colors.white,),
                new Positioned(
                    right: 0,
                    top:0,
                    child:
                    new Container(
                      padding: EdgeInsets.all(1),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                        //borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: new Text(
                        "$approval_count",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                )
              ],
            ),
            title: Text('Approvals',style: TextStyle(color: Colors.white)),
          ),

          /*BottomNavigationBarItem(
              icon: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 25.0 ),
              title: Text('Profile',style: TextStyle(color: Colors.white))),*/

          BottomNavigationBarItem(
            icon: new Icon(
                Icons.home,
                color: Colors.white,
                size: 25.0 ),
            //  icon:  new Image.asset("assets/Hom.png", height: 30.0, width: 30.0),
            title: new Text('Home', style: TextStyle(color: Colors.white)),
          ),

          BottomNavigationBarItem(
              icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 25.0 ),
              title: Text('Settings',style: TextStyle(color: Colors.white))),
        ],

        currentIndex: _currentIndex,
        onTap: (newIndex) {
          if (newIndex == 0) {
            ((adminsts==1 || divhrsts==1 || hrsts==1) && ((plansts==0 && empcount<2) || (plansts==0 && empcount>1 && attcount==0)))?null:(perAttendance=='1' || perEmployeeLeave=='1' || perTimeoff=='1')?
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllApprovals()),
            ):Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CollapsingTab()),
            );
            return;
          } else if (newIndex == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePageMain()),
            );
            return;
          }

          if (newIndex == 2) {
            ((adminsts==1 || divhrsts==1 || hrsts==1) && ((plansts==0 && empcount<2) || (plansts==0 && empcount>1 && attcount==0)))?null:Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllSetting()),
            );
            return;
          }

          setState(() {
            _currentIndex = newIndex;
          });
        },
        // _currentIndex: 0,
      ),
      // body: HomePage()  // code removed for brevity
    );
  }
}
