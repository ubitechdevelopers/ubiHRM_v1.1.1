import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/model/model.dart';
import 'package:ubihrm/register_page.dart';
import 'package:ubihrm/services/attandance_fetch_location.dart';
import 'package:ubihrm/services/checkLogin.dart';
import 'package:ubihrm/services/services.dart';
import 'package:ubihrm/survey.dart';

import 'global.dart';
import 'home.dart';
import 'services/attandance_services.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  bool _isServiceCalling = false;
  final _formKey = GlobalKey<FormState>();
  final _formKeyKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;
  bool _isButtonDisabled = false;
  bool _obscureText_new = true;
  String barcode = "";
  bool loader = false;
  String location_addr = "";

  String username="";
  bool err=false;
  bool succ=false;
  bool login=false;
  final _username = TextEditingController();
  FocusNode __username = new FocusNode();

  void _toggle_new() {
    setState(() {
      _obscureText_new = !_obscureText_new;
    });
  }

  setLocal(var fname, var empid, var  orgid) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('fname',fname);
    await prefs.setString('empid',empid);
    await prefs.setString('orgid',orgid);
  }

  SharedPreferences prefs;
  Map<String, dynamic>res;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height >= 640.0 ? MediaQuery.of(context).size.height : 640.0,
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Color.fromRGBO(0, 166, 90,1.0).withOpacity(0.9),
                      Color.fromRGBO(0, 166, 90,1.0).withOpacity(0.2)
                      /*Theme.Colors.loginGradientEnd*/
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child:ModalProgressHUD(inAsyncCall: _isServiceCalling,opacity: 0.5,progressIndicator: SizedBox(
                child:
                new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation(appStartColor()),
                    strokeWidth: 5.0),
                height: 40.0,
                width: 40.0,),child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: new Container(
                      width: 135.0,
                      height: 132.0,
                      decoration: new BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: new DecorationImage(
                          image:new AssetImage('assets/img/logohrmbg.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: new BorderRadius.all(new Radius.circular(77.0)),
                        // border: new Border.all(
                        // color: Colors.red,
                        //width: 4.0,
                        // ),
                      ),
                    ),
                  ),
                  _buildSignIn(context),
                ],
              ),
              )
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  //FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  String token1="";
  String tokenn="";

  @override
  void initState(){
    super.initState();
    initPlatformState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /*_pageController = PageController();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );

    gettokenstate();*/
  }

  /*gettokenstate() async{
    final prefs = await SharedPreferences.getInstance();
    _firebaseMessaging.getToken().then((token){
      token1 = token;
      prefs.setString("token1", token1);
      // print(tokenn);
      // print(token1);

    });
  }*/

  initPlatformState() async {
    /*Loc lock = new Loc();
    location_addr = await lock.loginrequestPermission();
    print(location_addr);*/
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child:Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.55,
                    //width: 370.0,
                    //height: 350.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 0.0, left: 20.0, right: 0.0),
                          child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*0.55,
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width*0.35,
                                      /*child: Padding(
                                    padding: EdgeInsets.only(top: 20.0, bottom: 0.0, left: 100.0, right: 10.0),*/
                                      child:GestureDetector(
                                        onTap: () {
                                          scan().then((onValue){
                                            print("******************** QR value **************************");
                                            print(onValue);
                                            print(context);
                                            print(token1);
                                            markAttByQR(onValue,context,token1);
                                          });
                                        },
                                        child:  Image.asset(
                                          'assets/qr.png', height: 35.0, width: 35.0, alignment: Alignment.bottomRight,
                                        ),
                                      )
                                    //),
                                  ),
                                ),
                              ]
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0.0, bottom: 10.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodeEmailLogin,
                            controller: loginEmailController,
                            keyboardType: TextInputType.emailAddress,
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context).requestFocus(myFocusNodePasswordLogin);
                            },
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.userAlt,
                                color: Colors.black,
                                size: 22.0,
                              ),
                              hintText: "Email/Phone",
                              hintStyle: TextStyle(
                                  fontSize: 14.0),
                            ),
                            /*validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Email or Phone no.';
                            }
                          },*/

                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.75,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 5.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodePasswordLogin,
                            controller: loginPasswordController,
                            obscureText: _obscureText_new,
                            style: TextStyle(

                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Padding(
                                padding: const EdgeInsets.only(
                                    top: 0.0, bottom: 5.0, left: 0.0, right: 0.0),
                                child: Icon(
                                  FontAwesomeIcons.lock,
                                  size: 22.0,
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  fontSize: 14.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggle_new,
                                child: Icon(
                                  _obscureText_new ?Icons.visibility_off:Icons.visibility,
                                  size: 30.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),

                            onFieldSubmitted: (String value) {

                              if (loginEmailController.text.trim().isNotEmpty && loginPasswordController.text.trim().isNotEmpty) {
                                checklogin(loginEmailController.text,loginPasswordController.text);
                              }else{

                                if(loginEmailController.text.trim().isEmpty) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        Future.delayed(Duration(seconds: 3), () {
                                          Navigator.of(context).pop(true);
                                        });
                                        return AlertDialog(
                                            content: new Text("Please enter Email or Phone no."),
                                        );
                                      });
                                  /*showDialog(context: context, child:
                                  new AlertDialog(
                                    content: new Text("Please enter Email or Phone no."),
                                  )
                                  );*/
                                }else if(loginPasswordController.text.trim().isEmpty){
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        Future.delayed(Duration(seconds: 3), () {
                                          Navigator.of(context).pop(true);
                                        });
                                        return AlertDialog(
                                          content: new Text("Please enter Password."),
                                        );
                                      });
                                  /*showDialog(context: context, child:
                                  new AlertDialog(
                                    content: new Text("Please enter Password."),
                                  )
                                  );*/
                                }
                              }
                            },
                          ),
                        ),

                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.75,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                        ),

                        Container(
                          //   margin: EdgeInsets.only(top: 170.0),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(top: 5.0, bottom: 4.0, left: 150.0, right: 0.0),
                          child: FlatButton(
                              onPressed: () {
                                _modalBottomSheet(context);
                                /*Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ForgotPassword()),
                                );*/
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color:appStartColor(),
                                    fontSize: 14,
                                    decoration: TextDecoration.underline
                                ),
                              )
                          ),
                        ),

                        Container(
                          //   margin: EdgeInsets.only(top: 170.0),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                              top: 0.0, bottom: 0.0, left: 25.0, right: 25.0),
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child:  ButtonTheme(
                            minWidth: 200.0,
                            height: 40.0,
                            child: RaisedButton(
                              /*highlightColor: Colors.transparent,
                    s           plashColor: Theme.Colors.loginGradientEnd,*/
                              //color: Color.fromRGBO(0, 166, 90,1.0),
                                color: Colors.orange[800],
                                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                /* shape: new RoundedRectangleBorder(
                                 borderRadius: new BorderRadius.circular(30.0)),*/
                                child: Padding(
                                  padding: const EdgeInsets.symmetric( vertical: 0.0, horizontal: 0.0),
                                  child: Text(
                                    "Already registered? Sign In",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (loginEmailController.text.trim().isNotEmpty && loginPasswordController.text.trim().isNotEmpty) {

                                    checklogin(loginEmailController.text.trim(),loginPasswordController.text.trim(),);
                                  }else{

                                    if(loginEmailController.text.trim().isEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 3), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              content: new Text("Please enter Email or Phone no."),
                                            );
                                          });
                                      /*showDialog(context: context, child:
                                      new AlertDialog(
                                        content: new Text("Please enter Email or Phone no."),
                                      )
                                      );*/
                                    }else if(loginPasswordController.text.trim().isEmpty){
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 3), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              content: new Text("Please enter Password."),
                                            );
                                          });
                                      /*showDialog(context: context, child:
                                      new AlertDialog(
                                        content: new Text("Please enter Password."),
                                      )
                                      );*/
                                    }
                                  }
                                }
                            ),
                          ),
                        ),


                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              /* Expanded(child: Container(
                                margin: EdgeInsets.only(left: 60.0,right:0.0,top: 10.0),

                                child:Text("Not registered?", style: TextStyle(
                                  color: Colors.black54,fontSize: 14,),),
                              ),),*/
                              Expanded(child: Container(
                                  height: 50.0,
                                  //margin: EdgeInsets.only(top: 250.0),
                                  //width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(
                                      top: 10.0, bottom: 0.0, left: 25.0, right: 25.0),
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),

                                  child: new ButtonTheme(
                                    // color:appStartColor(),
                                    child: OutlineButton(
                                        child: new Text("Company not registered? Sign Up", style: TextStyle(
                                          color:  Colors.black,
                                          fontSize: 15.0,),),
                                        borderSide: BorderSide(color: Colors.orange[800]),
                                        onPressed: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => Register()),
                                          );
                                        }
                                    ),
                                    // borderSide: BorderSide(color:  appStartColor()),
                                    /* shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))*/

                                  )
                              ),
                              ),
                            ]
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  checklogin(String username, String pass) async{
    setState(() {
      _isServiceCalling = true;
    });
    Login dologin = Login();
    UserLogin user = new UserLogin(username: username,password: pass,token:token1);
    dologin.checklogin(user, context).then((res) async {
      print("response");
      print(res);
      if(res=='true'){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePageMain()), (Route<dynamic> route) => false,
        );
      }else if(res=='false1'){
        setState(() {
          _isServiceCalling = false;
        });
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pop(true);
              });
              return AlertDialog(
                content: new Text("Your trial period has expired!"),
              );
            });
        /*showDialog(context: context, child:
          new AlertDialog(
            content: new Text("Your trial period has expired!"),
          )
        );*/
      }else if(res=='false2'){
        setState(() {
          _isServiceCalling = false;
        });
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pop(true);
              });
              return AlertDialog(
                content: new Text("Your plan has expired!"),
              );
            });
        /*showDialog(context: context, child:
          new AlertDialog(
            content: new Text("Your plan has expired!"),
          )
        );*/
      }else if(res=='false3'){
        setState(() {
          _isServiceCalling = false;
        });
        final prefs = await SharedPreferences.getInstance();
        String orgid = prefs.getString('orgid')??"";
        String name = prefs.getString('name')??"";
        String email = prefs.getString('email')??"";
        print(orgid+" "+name+" "+email);
        showDialog(
          barrierDismissible: false,
          context: context, child:
          new AlertDialog(
            title: new Text("You have not verified your registered mail id, please verify to login again.",
              style: TextStyle(fontSize: 16.0),),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    'VERIFY', style: TextStyle(color: Colors.white),),
                  color: Colors.orange[800],
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    verification(orgid, name, email).then((result) {
                      showDialog(
                        barrierDismissible: false,
                        context: context, child:
                        new AlertDialog(
                          title: new Text("Mail verification link has been sent on your registered mail id, by clicking on sent verification link you can verify you mail id",
                          style: TextStyle(fontSize: 16.0),),
                          content: RaisedButton(
                            child: Text('Open Mail', style: TextStyle(color: Colors.white),),
                            color: Colors.orange[800],
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              openEmailApp(context);
                            },
                          ),
                        )
                      );
                    });
                  },
                ),
                FlatButton(
                  shape: Border.all(color: Colors.orange[800]),
                  child: Text(
                    'CANCEL', style: TextStyle(color: Colors.black87),),
                  onPressed: () {
                    _exitApp(context);
                  },
                ),
              ],
            ),
          )
        );
      }else if(res=='false4'){
        setState(() {
          _isServiceCalling = false;
        });
        showDialog(context: context, child:
          new AlertDialog(
            content: new Text("Please conatct your admin."),
          )
        );
      }else{
        setState(() {
          _isServiceCalling = false;
        });
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pop(true);
              });
              return AlertDialog(
                content: new Text("Invalid login credentials."),
              );
            });
        /*showDialog(context: context, child:
        new AlertDialog(
          content: new Text("Invalid login credentials."),
        )
        );*/
      }
    }).catchError((exp){
      print(exp);
      setState(() {
        _isServiceCalling=false;
      });
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: new Text("Unable to connect server."),
            );
          });
      /*showDialog(context: context, child:
      new AlertDialog(
        content: new Text("Unable to connect server."),
      )
      );*/
    });;
  }


  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }

  /*markAttByQR(var qr, BuildContext context,token1) async{
    Login dologin = Login();
    setState(() {
      loader = true;
    });
    var islogin = await dologin.markAttByQR(qr,token1, context);
    print(islogin);
    if(islogin=='Success'){
      setState(() {
        loader = false;
      });
      showDialog(
          context : context,
          builder: (_) => new
          AlertDialog(
            //title: new Text("Dialog Title"),
            content: new Text("Successfull"
            ),
          )
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePageMain()), (Route<dynamic> route) => false,
      );
    }else if(islogin=='false1'){
      setState(() {
        loader = false;
      });
      showDialog(context: context, child:
      new AlertDialog(

        content: new Text("Your trial period has expired!"),
      )
      );
    }else if(islogin=='false2'){
      setState(() {
        loader = false;
      });
      showDialog(context: context, child:
      new AlertDialog(

        content: new Text("Your plan has expired!"),
      )
      );
    }else if(islogin=="false"){
      setState(() {
        loader = false;
      });
      showDialog(context: context, child:
      new AlertDialog(

        content: new Text("Invalid login!"),

      )
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false,
      );
    }else if(islogin=="imposed"){
      setState(() {
        loader = false;
      });
      showDialog(
          context : context,
          builder: (_) => new
          AlertDialog(
            //title: new Text("Dialog Title"),
            content: new Text("Invalid login."
            ),
          )
      );
    }else{
      setState(() {
        loader = false;
      });
      *//*Scaffold.of(context)
          .showSnackBar(
          SnackBar(content: Text("Attendance is already marked")));*//*
    }
  }*/


  markAttByQR(var qr, BuildContext context, token1) async{
    Login dologin = Login();
    setState(() {
      loader = true;
    });
    var islogin = await dologin.markAttByQR(qr, context, token1);
    print(islogin);
    if(islogin=="Success"){
      setState(() {
        loader = false;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePageMain()), (Route<dynamic> route) => false,
      );
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: new Text("Successfully Logged In"),
            );
          });
      /*showDialog(
          context : context,
          builder: (_) => new
          AlertDialog(
            //title: new Text("Dialog Title"),
            content: new Text("Successfully Logged In"
            ),
          )
      );*/
      Scaffold.of(context)
          .showSnackBar(
          SnackBar(content: Text("Attendance marked successfully.")));
    }else if(islogin=="failure"){
      setState(() {
        loader = false;
      });
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: new Text("Invalid login"),
            );
          });
      /*showDialog(
          context : context,
          builder: (_) => new
          AlertDialog(
            //title: new Text("Dialog Title"),
            content: new Text("Invalid login."
            ),
          )
      );*/
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false,
      );

      Scaffold.of(context)
          .showSnackBar(
          SnackBar(content: Text("Invalid login credentials")));
    }else if(islogin=="imposed"){
      setState(() {
        loader = false;
      });
      showDialog(
          context : context,
          builder: (_) => new
          AlertDialog(
            //title: new Text("Dialog Title"),
            content: new Text("Invalid login."
            ),
          )
      );
    }else{
      setState(() {
        loader = false;
      });
      Scaffold.of(context)
          .showSnackBar(
          SnackBar(content: Text("Attendance is already marked")));
    }
  }


  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      return barcode;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
        return "pemission denied";
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
        return "error";
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
      return "error";
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
      return "error";
    }
  }

  _modalBottomSheet(context) async{
    showRoundedModalBottomSheet(
        context: context,
        color:Colors.grey[100],
        builder: (BuildContext bc){
          return new  Container(
            //height: 250.0,
            height: MediaQuery.of(context).size.height*0.38,
            child: new Container(
              decoration: new BoxDecoration(
                  color: appStartColor().withOpacity(0.1),
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(0.0),
                      topRight: const Radius.circular(0.0))),
              alignment: Alignment.topCenter,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Text("Forgot Password",style: new TextStyle(fontSize: 22.0,color: appStartColor())),
                    ),

                    SizedBox(height: 25.0),
                    Padding(
                      padding: const EdgeInsets.only(left:20.0, right:20.0),
                      child: succ==false?Container(
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  width: MediaQuery.of(context).size.width*.9,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),

                                  ),
                                  child: TextFormField(
                                    controller: _username,
                                    focusNode: __username,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Email',
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.all(0.0),
                                          child: Icon(
                                            Icons.email,
                                            color: Colors.grey,
                                          ), // icon is 48px widget.
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ):Center(),
                    ), //Enter date

                    SizedBox(height: 12.0),
                    Padding(
                      padding: const EdgeInsets.only(right:15.0),
                      child: succ==false?ButtonBar(
                        children: <Widget>[
                          RaisedButton(
                            child: _isButtonDisabled==false?Text('SUBMIT',style: TextStyle(color: Colors.white),):Text('WAIT...',style: TextStyle(color: Colors.white),),
                            color: Colors.orange[800],
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                if (_username.text == ''||_username.text == null) {
                                  //showInSnackBar("Please Enter Email");
                                  showDialog(context: context, child:
                                  new AlertDialog(
                                    content: new Text("Please Enter Email"),
                                  )
                                  );
                                  FocusScope.of(context).requestFocus(__username);
                                } else {
                                  if(_isButtonDisabled)
                                    return null;
                                  setState(() {
                                    _isButtonDisabled=true;
                                  });
                                  resetMyPassword(_username.text).then((res){
                                    if(res==1) {
                                      username = _username.text;
                                      _username.text='';
                                      //showInSnackBar("Request submitted successfully");
                                      showDialog(context: context, child:
                                      new AlertDialog(
                                        content: new Text("Mail to reset your password has been successfully sent."),
                                      )
                                      );
                                      setState(() {
                                        login=true;
                                        succ=true;
                                        err=false;
                                        _isButtonDisabled=false;
                                      });
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 3), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              content: new Text("Email Not Found"),
                                            );
                                          });
                                      /*showDialog(context: context, child:
                                      new AlertDialog(
                                        content: new Text("Email Not Found"),
                                      )
                                      );*/
                                      //showInSnackBar("Email Not Found.");
                                      setState(() {
                                        login=false;
                                        succ=false;
                                        err=true;
                                        _isServiceCalling=false;
                                      });
                                    }
                                  }).catchError((onError){
                                    //showInSnackBar("Unable to call reset password service");
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          Future.delayed(Duration(seconds: 3), () {
                                            Navigator.of(context).pop(true);
                                          });
                                          return AlertDialog(
                                            content: new Text("Unable to call reset password service"),
                                          );
                                        });
                                    /*showDialog(context: context, child:
                                    new AlertDialog(
                                      content: new Text("Unable to call reset password service"),
                                    )
                                    );*/
                                    setState(() {
                                      login=false;
                                      succ=false;
                                      err=false;
                                      _isButtonDisabled=false;
                                    });
                                    // showInSnackBar("Unable to call reset password service::"+onError.toString());
                                    print(onError);
                                  });
                                }
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            },
                          ),
                          FlatButton(
                            color: Colors.white,
                            shape: Border.all(color: Colors.orange[800]),
                            child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            },
                          ),
                        ],
                      ):Center(),
                    ),

                    err==true?Text('Invalid Email.',style: TextStyle(color: Colors.red,fontSize: 16.0),):Center(),
                    /*Padding(
                      padding: const EdgeInsets.only(left:20.0, right:20.0),
                      child: succ==true?Text('Please check your mail for the reset password link. Once you reset the password, click on the below link.',style: TextStyle(fontSize: 16.0),textAlign: TextAlign.justify,):Center(),
                    ),*/
                    /*login==true?InkWell(
                      child: Text('\nClick here to Login',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0,color: appStartColor(), decoration: TextDecoration.underline),textAlign: TextAlign.right,),
                      onTap:() async{
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString('username', username);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      } ,
                    ):Center(),*/
                  ],
                ),
              ),
            ),
          );

        }
    );
  }
}

Future<bool> _exitApp(BuildContext context) {
  return showDialog(
    context: context,
    child: new AlertDialog(
      title: new Text('Do you want to exit this app?'),
      //content: new Text('We hate to see you leave...'),
      actions: <Widget>[
        new FlatButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
          child: new Text('No'),
        ),
        new FlatButton(
          onPressed: () => exit(0),
          child: new Text('Yes'),
        ),
      ],
    ),
  ) ?? false;
}

void openEmailApp(BuildContext context){
  try{
    AppAvailability.launchApp(Platform.isIOS ? "message://" : "com.google.android.gm").then((_) {
      print("App Email launched!");
    }).catchError((err) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("App Email not found!")
      ));
      print(err);
    });
  } catch(e) {
    print(e);
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Email App not found!")));
  }
}