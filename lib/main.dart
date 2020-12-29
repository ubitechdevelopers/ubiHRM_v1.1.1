import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/home.dart';
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

class _MyAppState extends State<MyApp> {
  static const platform = const MethodChannel('location.spoofing.check');
  String address="";

  void initState() {
    super.initState();
    print("main.dart's initState");
    platform.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    print("main.dart's handle method");
    switch(call.method) {
      case "locationAndInternet":
        locationThreadUpdatedLocation=true;
        if(call.arguments["TimeSpoofed"].toString()=="Yes"){
          timeSpoofed=true;
        }
        String long=call.arguments["longitude"].toString();
        print("longitude");
        print(long);
        String lat=call.arguments["latitude"].toString();
        print("latitude");
        print(lat);
        assign_lat=double.parse(lat);
        print("latitude1");
        print(assign_lat);
        assign_long=double.parse(long);
        print("longitude1");
        print(assign_lat);
        address=await getAddressFromLati(lat, long);
        print("address");
        print(address);
        print(call.arguments["mocked"].toString());
        globalstreamlocationaddr=address;
        getAreaStatus().then((res) {
          print('main dot dart');
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
          print('Exception occured in calling function.......');
          print(onError);
        });
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
              navigateAfterSeconds: new HomePageMain(),
              image:Image.asset('assets/ubihrm_splash.gif'),
              backgroundColor: Colors.white,
              photoSize: MediaQuery.of(context).size.width*0.86,
            );
          }
      ),
    );
  }
}
