import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:ubihrm/app.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/services/services.dart';

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

class _MyAppState extends State<MyApp>{
  static const platform = const MethodChannel('location.spoofing.check');
  String address="";

  void initState() {
    super.initState();
    print("main.dart's initState");
    platform.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "locationAndInternet":
        locationThreadUpdatedLocation = true;
        var long = call.arguments["longitude"].toString();
        var lat = call.arguments["latitude"].toString();
        assign_lat = double.parse(lat);
        assign_long = double.parse(long);
        address = await getAddressFromLati(lat, long);
        print("================================================>>>>>>>>>>>>>>>>"+address);
        globalstreamlocationaddr = address;
        print(call.arguments["mocked"].toString());

        getAreaStatus().then((res) {
          print('home dot dart');
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
          print('Exception occured in clling function.......');
          print(onError);
        });

        globalstreamlocationaddr=address;

        break;

        return new Future.value("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:new Builder(
          builder: (BuildContext context) {
            return new SplashScreen(
              seconds: 2,
              navigateAfterSeconds: ShrineApp(),
              image:Image.asset('assets/ubihrm_splash.gif'),
              backgroundColor: Colors.white,
              photoSize: MediaQuery.of(context).size.width*0.86,
            );
          }
      ),
    );
  }
}
