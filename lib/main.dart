import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:ubihrm/global.dart';

import 'attandance/app.dart';

void main(){
  runApp(
      new MaterialApp(
        home: new MyApp(),
      )
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:new Builder(
          builder: (BuildContext context) {
            return new SplashScreen(
                seconds: 2,
                navigateAfterSeconds: new ShrineApp(),
                //title: new Text('',style: TextStyle(fontSize: 32.0),),
                loaderColor: appStartColor(),
                image:   Image.asset('assets/splash_hrm.gif'),
                backgroundColor: Colors.white,
                styleTextUnderTheLoader: new TextStyle(color: Colors.grey[500]),
                photoSize: MediaQuery.of(context).size.width*0.45
              /*onClick: ()=>print("Flutter Egypt"),*/
            );
          }
      ),
    );
  }
}
