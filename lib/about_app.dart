import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/drawer.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/home.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'attandance/home.dart';

void main() => runApp(new AboutApp());

class AboutApp extends StatefulWidget {
  @override
  _AboutApp createState() => _AboutApp();
}

class _AboutApp extends State<AboutApp> {
  String org_name = "";
  String new_ver='1.1.0';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      org_name= prefs.getString('orgname') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getOrgName();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    checkNow().then((res){
      setState(() {
        new_ver=res;
        print("new_ver");
        print(new_ver);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: new Scaffold(
          key: _scaffoldKey,
          backgroundColor:scaffoldBackColor(),
          appBar: new AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(org_name, style: new TextStyle(fontSize: 20.0)),
              ],
            ),
            leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePageMain()),
              );
            },),
            backgroundColor: appStartColor(),
          ),
          endDrawer: new AppDrawer(),
          body: userWidget()
      ),
      onRefresh: () async {
        Completer<Null> completer = new Completer<Null>();
        await Future.delayed(Duration(seconds: 1)).then((onvalue) {
          completer.complete();
        });
        return completer.future;
      },
    );
  }

  userWidget(){
    return Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            decoration: new ShapeDecoration(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
              color: Colors.white,
            ),
            child: ListView(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //SizedBox(height: 60,),
                      Center(
                        child:Text(
                            "About ubiHRM",
                            style: new TextStyle(
                                fontSize: 30.0,
                                color:appStartColor(),
                                fontWeight: FontWeight.w600
                            )
                        ),
                      ),
                      SizedBox(height: 15,),
                      Center(
                        child: Text(
                          'Installed Version '+appVersion,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      //SizedBox(height: 15,),
                      /*Center(
                        child: Text(
                          'Released On '+appVersionReleaseDate,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),*/
                      SizedBox(height: 15,),
                      Center(
                        child: Text(
                          'Latest Version '+new_ver,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      /*Center(
                        child: Text(
                          'Released On '+latestVersionReleaseDate,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),*/
                      SizedBox(height: 15,),
                      Center(
                          child: new_ver==appVersion?Text(
                            'The latest version is already installed.',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.green
                            ),
                          ):Text(
                            'Please install the latest version.',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.red
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]
    );
  }
}