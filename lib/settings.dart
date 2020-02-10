import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'appbar.dart';
import 'b_navigationbar.dart';
import 'change_pass.dart';
import 'drawer.dart';
import 'global.dart';


class AllSetting extends StatefulWidget {
  @override
  _AllSetting createState() => _AllSetting();
}
class _AllSetting extends State<AllSetting> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 1;
  String _orgName;
  String buystatus = "";
  String trialstatus = "";
  String orgmail = "";
  String admin_sts = "0";
  var profileimage;
  bool showtabbar;
  String orgName="";

  @override
  void initState() {
    super.initState();
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    showtabbar=false;
    getOrgName();
  }
  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';

    });
  }
  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }
  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }


  getmainhomewidget() {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:scaffoldBackColor(),
      endDrawer: new AppDrawer(),
      appBar: new AppHeader(profileimage,showtabbar,orgName),
/*      appBar: GradientAppBar(

        automaticallyImplyLeading: false,

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

      ),*/
      bottomNavigationBar:  new HomeNavigation(),

      body:getReportsWidget(),

    );
  }

  /*
  mainbodyWidget() {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15.0),
              getReportsWidget(),
              //getMarkAttendanceWidgit(),
            ],
          ),


        ],
      ),

    );
  }
  */

  loader(){
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset(
                  'assets/spinner.gif', height: 80.0, width: 80.0),
            ]),
      ),
    );
  }

  launchMap(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print( 'Could not launch $url');
    }
  }

  showDialogWidget(String loginstr){

    return showDialog(context: context, builder:(context) {

      return new AlertDialog(
        title: new Text(
          loginstr,
          style: TextStyle(fontSize: 15.0),),
        content: ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Text('Later',style: TextStyle(fontSize: 13.0)),
              shape: Border.all(),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            RaisedButton(
              child: Text(
                'Pay Now', style: TextStyle(color: Colors.white,fontSize: 13.0),),
              color: Colors.orange[800],
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                /*       Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage()),
                );*/
              },
            ),
          ],
        ),
      );
    }
    );

  }

  getReportsWidget(){
    return Stack(
      children: <Widget>[
        Container(
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            //width: MediaQuery.of(context).size.width*0.9,
            //      height:MediaQuery.of(context).size.height*0.75,
            decoration: new ShapeDecoration(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
              color: Colors.white,
            ),
            child:ListView(
              // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Settings',
                      style: new TextStyle(fontSize: 22.0, color: appStartColor()),textAlign: TextAlign.center),
                  //SizedBox(height: 10.0),

                  SizedBox(height: 15.0),

                  new RaisedButton(
                    //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
                    //      shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
                    //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(

                      //     padding: EdgeInsets.only(left:  5.0),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(const IconData(0xe802, fontFamily: "CustomIcon"),size: 30.0,),
                          /*Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: appStartColor(),
                            ),
                            child: Icon(Icons.add_to_home_screen,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                            padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                          ),*/

                          SizedBox(width: 17.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('Change Password',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                                ),

                              ],
                            ),
                          ),
                          Container(
                            child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                    elevation: 4.0,
                    textColor: Colors.black54,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => changePassword()),
                      );
                    },
                  ),


                  SizedBox(height: 6.0),



                ])
        ),
      ],
    );
  }
}



