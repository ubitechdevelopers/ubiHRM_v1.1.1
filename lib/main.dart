import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

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
            image:Image.asset('assets/ubihrm_splash.gif'),
            backgroundColor: Colors.white,
            photoSize: MediaQuery.of(context).size.width*0.78,
          );
        }
      ),
    );
  }
}
