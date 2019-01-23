import 'package:flutter/material.dart';
import 'home.dart';
import 'global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'profile.dart';
import 'model/model.dart';
import 'services/services.dart';
import 'services/checkLogin.dart';

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
            color: bottomNavigationColor(),
            height: sstatus==''?160.0:172.0,
            child: new DrawerHeader(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:<Widget>[
                  Center(),
                  Column(
                children: <Widget>[
                  new Stack(
                    children: <Widget>[
                  new Container(
                      width: 90.0,
                      height: 90.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                           //  image: NetworkImage(globalcompanyinfomap['ProfilePic']),
                         image: _checkLoaded ? AssetImage('assets/avatar.png') : NetworkImage(globalcompanyinfomap['ProfilePic']),
                          )
                      )),
                new Positioned(
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
                      size: 18.0,
                    ),
                    shape: new CircleBorder(),
                    elevation: 0.5,
                    fillColor: Colors.orangeAccent,
                    padding: const EdgeInsets.all(1.0),
                  ),
                ),
            ]),
                  //SizedBox(height: 2.0),
                  //Image.asset('assets/logo.png',height: 150.0,width: 150.0),
                  // SizedBox(height: 5.0),
                  Text("Hi "+globalpersnalinfomap['FirstName'],style: new TextStyle(fontSize: 20.0,color: Colors.white)),
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
              Text("Monika Rai",
                style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              )),
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
             // Navigator.pop(context);

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