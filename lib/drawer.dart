import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/attandance/about_app.dart';
import 'package:ubihrm/payroll/allpayroll_list.dart';
import 'package:ubihrm/salary/allsalary_list.dart';
import 'package:ubihrm/userGuide.dart';
import 'all_reports.dart';
import 'global.dart';
import 'home.dart';
import 'login_page.dart';
import 'profile.dart';
import 'settings.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => new _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var profileimage;
  bool _checkLoaded = true;
  String fname="";
  String lname="";
  String appstore="https://apps.apple.com/in/app/ubihrm/id1489689034";
  String playstore="https://play.google.com/store/apps/details?id=com.ubihrm.ubihrm";
  String sstatus="";
  String desination="";
  String profile="";
  int reportper = 0;
  String buystatus = "";
  String trialstatus = "";
  String orgmail = "";


  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fname = prefs.getString('fname') ?? '';
      profile = prefs.getString('profile') ?? '';
      profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);
      profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __)  {
        if (mounted) {
          setState(() {
            _checkLoaded = false;
          });
        }
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child:new ListView(
        children: <Widget>[
          new Container(
            height: sstatus==''?170.0:182.0,
            decoration: BoxDecoration(
              // Box decoration takes a gradient
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: FractionalOffset.topRight,
                end: FractionalOffset.bottomLeft,
                // Add one stop for each color. Stops should increase from 0 to 1
                // stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  appStartColor(),
                  appStartColor(),
                  appStartColor(),
                  appStartColor(),
                ],
              ),
            ),
            child: new DrawerHeader(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:<Widget>[
                    Center(),
                    Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            new GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CollapsingTab()),
                                );
                              },
                              child: Container(
                                width: 85.0,
                                height: 85.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    //  image: NetworkImage(globalcompanyinfomap['ProfilePic']),
                                    image: _checkLoaded ? AssetImage('assets/avatar.png') : NetworkImage(globalcompanyinfomap['ProfilePic']),
                                  )
                                )
                              ),
                            ),
                          ]),
                                                SizedBox(height: 4.0,),
                        Text("Hi "+globalpersnalinfomap['FirstName'],style: new TextStyle(fontSize: 18.0,color: Colors.white)),
                        SizedBox(height: 3.0),
                        Text(globalcompanyinfomap['Designation'],style: new TextStyle(fontSize: 12.0,color: Colors.white)),
                        sstatus!=''?Text(sstatus,style: new TextStyle(fontSize: 10.0,color: Colors.white)):Center(),
                      ],
                    ),
                    (buystatus=="0" && reportper==1)?new Column(
                        children:<Widget>[
                          ButtonTheme(
                            minWidth: 60.0,
                            height: 30.0,
                            child:RaisedButton(
                              child: Row(children:<Widget>[Text("Buy Now")]),
                              color: Colors.orange[800],
                              onPressed: (){

                              },
                              textColor: Colors.white,
                            ),

                          )]):Center(),
                  ]
              ),

            ),
          ),

          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.home,size: 20.0),SizedBox(width: 5.0),
                new Text('Home', style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePageMain()),
              );
            },
          ),

          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.library_books,size: 20.0),SizedBox(width: 5.0),
                new Text('Reports', style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllReports()),
              );
            },
          ),

          (perSalary=='1') ? new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.monetization_on,size: 20.0),SizedBox(width: 5.0),
                new Text("Team's Salary", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => allSalarySummary()),
              );
            },
          ):Center(),

          (perPayroll=='1') ? new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.monetization_on,size: 20.0),SizedBox(width: 5.0),
                new Text("Team's Payroll", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => allPayrollSummary()),
              );
            },
          ):Center(),

          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.settings,size: 20.0),SizedBox(width: 5.0),
                new Text("Settings", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllSetting()),
              );

            },
          ),

          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.share,size: 20.0),SizedBox(width: 5.0),
                new Text("Share", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              final RenderBox box = context.findRenderObject();
              Share.share("Hi! I have had a great experience with ubiHRM App! I highly recommend it to manage your Human resource. Download the Android app via the following link -\n"+playstore+" iPhone users can download through -\n"+appstore,
                  sharePositionOrigin:
                  box.localToGlobal(Offset.zero) &
                  box.size);
            },
          ),

          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.star,size: 20.0),SizedBox(width: 5.0),
                new Text("Rate Us", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              Navigator.of(context).pop();
              LaunchReview.launch(
                  iOSAppId: "1489689034"
              );
            },
          ),

          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.security,size: 20.0),SizedBox(width: 5.0),
                new Text("User Guide", style: new TextStyle(fontSize: 14.0)),
              ],
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserGuide()),
              );
            },
          ),

          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.perm_device_information,size: 20.0),SizedBox(width: 5.0),
                new Text('About', style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutApp()),
              );
            },
          ),

          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.lock,size: 20.0),SizedBox(width: 5.0),
                new Text("Log out", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              logout();
            },
          ),
        ],
      ),
    );
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('response');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false,
    );
  }

}