import 'package:flutter/material.dart';
import 'home.dart';
import 'global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'profile.dart';
import 'all_reports.dart';
import 'model/model.dart';
import 'services/services.dart';
import 'settings.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => new _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  /*var _defaultimage = new NetworkImage(
      "http://ubiattendance.ubihrm.com/assets/img/avatar.png");*/
  var profileimage;
  bool _checkLoaded = true;
  String fname="";
  String lname="";
  String store="";
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
    //String admin= await getUserPerm();
    setState(() {
     fname = prefs.getString('fname') ?? '';
     profile = prefs.getString('profile') ?? '';
   // print("-------555555->"+globalcompanyinfomap['ProfilePic']);
     profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);
     profileimage.resolve(new ImageConfiguration()).addListener((_, __) {
       if (mounted) {
         setState(() {
           _checkLoaded = false;
         });

       }
     });
    });
  }
  @override
  Widget build(BuildContext context) {

    return new Drawer(

      child:new ListView(
        children: <Widget>[
          new Container(
           // color: bottomNavigationColor(),
            //color: Color.fromRGBO(38,102,75,1.0),
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
                  // Colors are easy thanks to Flutter's Colors class.

                  appStartColor(),
                  appStartColor(),
                  appStartColor(),
                  appStartColor(),
                  //Color.fromRGBO(0,102,153,1.0),
              //  Color.fromRGBO(7,99,145,1.0),
              //Color.fromRGBO(12,99,142,1.0),
              // Color.fromRGBO(34,94,124,1.0),
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
                      )),),
             /*   new Positioned(
                  right: MediaQuery.of(context).size.width*-.06,
                  top: MediaQuery.of(context).size.height*.07,

                  child: new RawMaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CollapsingTab()),
                      );
                    },
                    child: new Icon(
                      Icons.edit,
                      size: 16.0,
                    ),
                    shape: new CircleBorder(),
                    elevation: 0.5,
                    fillColor: Colors.orangeAccent,
                    padding: const EdgeInsets.all(1.0),
                  ),
                ),*/
            ]),
                  //SizedBox(height: 2.0),
                  //Image.asset('assets/logo.png',height: 150.0,width: 150.0),
                  // SizedBox(height: 5.0),

                  SizedBox(height: 4.0,),
                    Text("Hi "+globalpersnalinfomap['FirstName'],style: new TextStyle(fontSize: 18.0,color: Colors.white)),
                  // SizedBox(height: 3.0),
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
                      color: Colors.orangeAccent,
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePageMain()),
              );
            },
          ),

    /*      reportper ==1?new ListTile(
           title: Row(
              children: <Widget>[
                Icon(Icons.attach_money,size: 20.0),SizedBox(width: 5.0),
                new Text("Generate Payroll", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              showDialogWidget("To Generate Payroll, Login to the web panel.", "To Generate Payroll upgrade to Premium Plan.");
            },
          ):new Center(),*/

         /* new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.account_box,size: 20.0),SizedBox(width: 5.0),
                new Text("Profile", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),*/
           /*   Text("Monika Rai",
                style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              )),*/
          /*new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.perm_contact_calendar,size: 20.0),SizedBox(width: 5.0),
                new Text("Employee History", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              /*
              getUserPerm().then((res){
                print('func called with response: '+res);
              });*/


              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );

            },
          ),*/
       /*   new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.location_city,size: 20.0),SizedBox(width: 5.0),
                new Text("Organization", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),*/
          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.settings,size: 20.0),SizedBox(width: 5.0),
                new Text("Settings", style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllSetting()),
              );

            },
          ),


        /*  new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.security,size: 20.0),SizedBox(width: 5.0),
                new Text("Privacy Policy", style: new TextStyle(fontSize: 14.0)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAppPolicy()),
              );
            },
          ), */
          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.security,size: 20.0),SizedBox(width: 5.0),
                new Text("User Guide", style: new TextStyle(fontSize: 14.0)),
              ],
            ),
          ),

          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.library_books,size: 20.0),SizedBox(width: 5.0),
                new Text('Reports', style: new TextStyle(fontSize: 15.0)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllReports()),
              );
            },
          ),
        /*  new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.location_on,size: 20.0),SizedBox(width: 5.0),
                new Text("About Us", style: new TextStyle(fontSize: 14.0)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAppAbout()),
              );
            },
          ),*/
          new ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.lock_open,size: 20.0),SizedBox(width: 5.0),
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