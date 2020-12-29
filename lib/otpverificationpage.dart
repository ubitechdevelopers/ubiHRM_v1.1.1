import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ubihrm/global.dart';
import 'package:ubihrm/home.dart';
import 'package:ubihrm/login_page.dart';
import 'package:ubihrm/model/model.dart';
import 'package:ubihrm/register_page.dart';
import 'package:ubihrm/services/checkLogin.dart';
import 'package:ubihrm/survey.dart';

class Otp extends StatefulWidget {
  final String trialOrgId;
  final String email;
  final String newEmail;
  final bool isGuestCheckOut;

  const Otp({
    Key key,
    @required this.trialOrgId,
    @required this.email,
    this.newEmail = "",
    this.isGuestCheckOut,
  }) : super(key: key);

  @override
  _OtpState createState() => new _OtpState();
}

class _OtpState extends State<Otp> with SingleTickerProviderStateMixin {
  // Constants
  final int time = 120;
  AnimationController _controller;

  // Variables
  Size _screenSize;
  int _currentDigit;
  int _firstDigit;
  int _secondDigit;
  int _thirdDigit;
  int _fourthDigit;
  int _fifthDigit;
  int _sixthDigit;

  Timer timer;
  int totalTimeInSeconds;
  bool _hideResendButton;

  final FocusNode myFocusNodeEmail = FocusNode();
  TextEditingController EmailController = new TextEditingController();

  String userName = "";
  bool didReadNotifications = false;
  bool loader = false;
  bool otploader = false;
  bool _isServiceCalling = false;
  int unReadNotificationsCount = 0;

  // Returns "Appbar"
  get _getAppbar {
    return new AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: new InkWell(
        borderRadius: BorderRadius.circular(30.0),
        /*child: new Icon(
          Icons.arrow_back,
          color: Colors.black54,
        ),
        onTap: () {
          Navigator.pop(context);
        },*/
      ),
      centerTitle: true,
    );
  }

  // Return "Verification Code" label
  get _getVerificationCodeLabel {
    return new Text(
      "Verification Code",
      textAlign: TextAlign.center,
      style: new TextStyle(
          fontSize: 28.0, color: appStartColor(), fontWeight: FontWeight.bold),
    );
  }

  // Return "Email" label
  get _getEmailLabel {
    return new Text(
      "Please enter the OTP sent\non your registered Email ID.",
      textAlign: TextAlign.center,
      style: new TextStyle(
          fontSize: 18.0, color: appStartColor(), fontWeight: FontWeight.w600),
    );
  }

  // Return "OTP" input field
  get _getInputField {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _otpTextField(_firstDigit),
        _otpTextField(_secondDigit),
        _otpTextField(_thirdDigit),
        _otpTextField(_fourthDigit),
        _otpTextField(_fifthDigit),
        _otpTextField(_sixthDigit),
      ],
    );
  }

  // Returns "Timer" label
  get _getTimerText {
    return Container(
      height: 32,
      child: new Offstage(
        offstage: !_hideResendButton,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(Icons.access_time),
            new SizedBox(
              width: 5.0,
            ),
            OtpTimer(_controller, 15.0, Colors.black)
          ],
        ),
      ),
    );
  }

  // Returns "Resend" button
  get _getResendButton {
    return new InkWell(
      child: new Container(
        height: 32,
        width: 120,
        decoration: BoxDecoration(
            color: Colors.orange[800],
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: new Text(
          "Resend OTP",
          style:
          new TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      onTap: () {
        showDialog(context: context,
          builder: (_) => AlertDialog(
            elevation: 10.0,
            title: Text('Enter Registered Email ID', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
            content: new TextFormField(
              focusNode: myFocusNodeEmail,
              controller: EmailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                /*icon: Icon(
                  FontAwesomeIcons.userAlt,
                  color: Colors.black,
                  size: 22.0,
                ),*/
                hintText: "Email Id",
                hintStyle: TextStyle(fontSize: 14.0),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right:20.0),
                child: Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('SUBMIT'),
                      color: Colors.orange[800],
                      onPressed: () {
                        if(EmailController.text==""){
                          showDialog(context: context, child:
                          new AlertDialog(
                            content: new Text("Please enter registered Mail ID"),
                          ));
                        }else{
                          resendOTP(EmailController.text.trim());
                          print('resendOTP(EmailController);');
                          print(EmailController.text.trim());
                          EmailController.clear();
                          Navigator.of(context, rootNavigator: true).pop();
                          /* resendOTP(widget.trialOrgId);
                          print('resendOTP(widget.trialOrgId);');
                          print(widget.trialOrgId);*/
                        }
                      },
                    ),
                    SizedBox(width:10.0),
                    FlatButton(
                      shape: Border.all(color: Colors.orange[800]),
                      child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        // Resend you OTP via API or anything
      },
    );
  }

  // Returns "Otp" keyboard
  get _getOtpKeyboard {
    return new Container(
        height: _screenSize.width - 105,
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "1",
                      onPressed: () {
                        _setCurrentDigit(1);
                      }),
                  _otpKeyboardInputButton(
                      label: "2",
                      onPressed: () {
                        _setCurrentDigit(2);
                      }),
                  _otpKeyboardInputButton(
                      label: "3",
                      onPressed: () {
                        _setCurrentDigit(3);
                      }),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "4",
                      onPressed: () {
                        _setCurrentDigit(4);
                      }),
                  _otpKeyboardInputButton(
                      label: "5",
                      onPressed: () {
                        _setCurrentDigit(5);
                      }),
                  _otpKeyboardInputButton(
                      label: "6",
                      onPressed: () {
                        _setCurrentDigit(6);
                      }),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "7",
                      onPressed: () {
                        _setCurrentDigit(7);
                      }),
                  _otpKeyboardInputButton(
                      label: "8",
                      onPressed: () {
                        _setCurrentDigit(8);
                      }),
                  _otpKeyboardInputButton(
                      label: "9",
                      onPressed: () {
                        _setCurrentDigit(9);
                      }),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new SizedBox(
                    width: 80.0,
                  ),
                  _otpKeyboardInputButton(
                    label: "0",
                    onPressed: () {
                      _setCurrentDigit(0);
                    }),
                  _otpKeyboardActionButton(
                    label: new Icon(
                      Icons.backspace,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_sixthDigit != null) {
                          _sixthDigit = null;
                        } else if (_fifthDigit != null) {
                          _fifthDigit = null;
                        } else if (_fourthDigit != null) {
                          _fourthDigit = null;
                        } else if (_thirdDigit != null) {
                          _thirdDigit = null;
                        } else if (_secondDigit != null) {
                          _secondDigit = null;
                        } else if (_firstDigit != null) {
                          _firstDigit = null;
                        }
                      });
                    }),
                ],
              ),
            ),
          ],
        )
    );
  }

  // Returns "OTP" input part
  get _getInputPart {
    return new Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _getVerificationCodeLabel,
        _getEmailLabel,
        _getInputField,
        //_hideResendButton ? _getTimerText : _getResendButton,
        _getResendButton,
        _getOtpKeyboard
      ],
    );
  }

  // Overridden methods
  @override
  void initState() {
    totalTimeInSeconds = time;
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: time))..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          setState(() {
            _hideResendButton = !_hideResendButton;
          });
        }
      });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _startCountdown();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: new Scaffold(
        appBar: _getAppbar,
        backgroundColor: Colors.white,
        body: new Container(
          width: _screenSize.width,
          //padding: new EdgeInsets.only(bottom: 16.0),
          child: _getInputPart,
        ),
      ),
    );
  }

  // Returns "Otp custom text field"
  Widget _otpTextField(int digit) {
    return new Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      child: new Text(
        digit != null ? digit.toString() : "",
        style: new TextStyle(
          fontSize: 30.0,
          color: appStartColor(),
        ),
      ),
      decoration: BoxDecoration(
//            color: Colors.grey.withOpacity(0.4),
          border: Border(
              bottom: BorderSide(
                width: 2.0,
                color: Colors.black,
              ))),
    );
  }

  // Returns "Otp keyboard input Button"
  Widget _otpKeyboardInputButton({String label, VoidCallback onPressed}) {
    return new Material(
      color: Colors.transparent,
      child: new InkWell(
        onTap: onPressed,
        borderRadius: new BorderRadius.circular(40.0),
        child: new Container(
          height: 80.0,
          width: 80.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: new Center(
            child: new Text(
              label,
              style: new TextStyle(
                fontSize: 30.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Returns "Otp keyboard action Button"
  _otpKeyboardActionButton({Widget label, VoidCallback onPressed}) {
    return new InkWell(
      onTap: onPressed,
      borderRadius: new BorderRadius.circular(40.0),
      child: new Container(
        height: 80.0,
        width: 80.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: new Center(
          child: label,
        ),
      ),
    );
  }

  // Current digit
  void _setCurrentDigit(int i) {
    setState(() {
      _currentDigit = i;
      if (_firstDigit == null) {
        _firstDigit = _currentDigit;
      } else if (_secondDigit == null) {
        _secondDigit = _currentDigit;
      } else if (_thirdDigit == null) {
        _thirdDigit = _currentDigit;
      } else if (_fourthDigit == null) {
        _fourthDigit = _currentDigit;
      } else if (_fifthDigit == null) {
        _fifthDigit = _currentDigit;
      } else if (_sixthDigit == null) {
        _sixthDigit = _currentDigit;

        var otp = _firstDigit.toString() +
          _secondDigit.toString() +
          _thirdDigit.toString() +
          _fourthDigit.toString()+
          _fifthDigit.toString() +
          _sixthDigit.toString();
        print("OTP");
        print(otp);
        verifyOTP(otp);
        // Verify your otp by here. API call
      }
    });
  }

  checklogin(String username, String pass, BuildContext context) async{
    setState(() {
      _isServiceCalling = true;
    });
    Login dologin = Login();
    UserLogin user = new UserLogin(username: username, password: pass);
    dologin.checklogin(user, context).then((res){
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
        showDialog(context: context, child:
        new AlertDialog(

          content: new Text("Your trial period has expired!"),
        )
        );
      }else if(res=='false2'){
        setState(() {
          _isServiceCalling = false;
        });
        showDialog(context: context, child:
        new AlertDialog(

          content: new Text("Your plan has expired!"),
        )
        );
      }else{
        setState(() {
          _isServiceCalling = false;
        });
        showDialog(context: context, child:
        new AlertDialog(

          content: new Text("Invalid login credentials."),
        )
        );
      }
    }).catchError((exp){
      setState(() {
        _isServiceCalling=false;
      });
      showDialog(context: context, child:
      new AlertDialog(

        content: new Text("Unable to connect server."),
      )
      );
    });
  }

  verifyOTP(otp) async{
    print(path+"OTPVerification?otp=$otp");
    var url = path+"OTPVerification";
    setState(() {
      otploader = true;
    });
    http.post(url, body: {
      "otp": otp
    }).then((response)async{
      print(response.statusCode);
      if  (response.statusCode == 200) {
        Map data = json.decode(response.body);
        print("This will return response");
        print(data);
        if (data["sts"].contains("true")) {
          gethome () async{
            await new Future.delayed(const Duration(seconds: 1));
            checklogin(data['phone'], data['pwd'], context);
          }
          gethome ();
          showDialog(context: context, child:
          new AlertDialog(
            content: new Text("OTP verified successfully"),
          ));
         /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
          showDialog(context: context, child:
          new AlertDialog(
            title: Text("OTP verified successfully.\nYour login credentials is"),
            content: new Text("Username:"+data["phone"]+"\n"+"Password:"+data["pwd"]),
          ));*/
        } else if(data["sts"].contains("otptimeout")){
          setState(() {
            otploader = false;
          });
          showDialog(context: context, child:
          new AlertDialog(
            content: new Text("Your OTP has expired"),
          ));
          clearOtp();
        } else if(data["sts"].contains("otpused")) {
          setState(() {
            otploader = false;
          });
          showDialog(context: context, child:
          new AlertDialog(
            content: new Text("OTP already used, Please register again"),
          ));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false,
          );
        } else {
          setState(() {
            otploader = false;
          });
          showDialog(context: context, child:
          new AlertDialog(
            content: new Text("Invalid OTP, Please try again"),
          ));
        }
      }
    }).catchError((onError) {
      print(onError);
      setState(() {
        setState(() {
          otploader = false;
        });
        showDialog(context: context, child:
        new AlertDialog(
          content: new Text("Unable to Connect server."),
        ));
      });
    });
  }

  resendOTP(emailid) async{
    print(path+"resendOTP?emailid=${EmailController.text.trim()}");
    var url = path+"resendOTP";
    setState(() {
      otploader = true;
    });
    http.post(url, body: {
      "emailid": EmailController.text.trim()
    }).then((response)async{
      print(response.statusCode);
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        print("This will return response");
        print(response.body.toString());
        print(data["trialorgid"]);
        print(data["sts"]);
        if (data["sts"].contains("otpSent")) {
          showDialog(context: context, child:
          new AlertDialog(
            content: new Text("OTP has been sent to your registered mail Id"),
          ));
        } else if(data["sts"].contains("otpNotSent")){
          setState(() {
            otploader = false;
          });
          showDialog(context: context, child:
          new AlertDialog(
            content: new Text("Otp has not been sent"),
          ));
        } else if(data["sts"].contains("otpLimitExceeded")){
          setState(() {
            otploader = false;
          });
          showDialog(context: context, child:
          new AlertDialog(
            content: new Text("Otp limit has been exceeded. you need to register again"),
          ));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Register()), (Route<dynamic> route) => false,
          );
        }else if(data["sts"].contains("surveyNotFilled")){
          setState(() {
            otploader = false;
          });
          showDialog(context: context, child:
          new AlertDialog(
            content: new Text("You have not filled your survey form"),
          ));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SurveyForm(
              trialOrgId: data["trialorgid"],
              orgName: data["orgname"],
              name: data["name"],
              email: data["email"],
              countrycode:data["contcode"],
              phone: data["phone"],
            )), (Route<dynamic> route) => false,
          );
        }else if(data["sts"].contains("alreadyRegistered")){
          setState(() {
            otploader = false;
          });
          showDialog(context: context, child:
          new AlertDialog(
            content: new Text("Your organization has been already registered"),
          ));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false,
          );
        } else if(data["sts"].contains("emailIdNotFound")) {
          setState(() {
            otploader = false;
          });
          showDialog(context: context, child:
          new AlertDialog(
            content: new Text("Entered email id is not found"),
          ));
        }
      }
    }).catchError((onError) {
      print(onError);
      setState(() {
        setState(() {
          otploader = false;
        });
        showDialog(context: context, child:
        new AlertDialog(
          content: new Text("Unable to Connect server."),
        ));
      });
    });
  }

  runloader(){
    return new Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CircularProgressIndicator()
            //Image.asset('assets/spinner.gif', height: 50.0, width: 50.0),
          ]
        ),
      ),
    );
  }

  Future<Null> _startCountdown() async {
    setState(() {
      _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }

  void clearOtp() {
    _sixthDigit = null;
    _fifthDigit = null;
    _fourthDigit = null;
    _thirdDigit = null;
    _secondDigit = null;
    _firstDigit = null;
    setState(() {});
  }
}

class OtpTimer extends StatelessWidget {
  final AnimationController controller;
  double fontSize;
  Color timeColor = Colors.black;

  OtpTimer(this.controller, this.fontSize, this.timeColor);

  String get timerString {
    Duration duration = controller.duration * controller.value;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration get duration {
    Duration duration = controller.duration;
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return new Text(
            timerString,
            style: new TextStyle(
                fontSize: fontSize,
                color: timeColor,
                fontWeight: FontWeight.w600),
          );
        });
  }
}

Future<bool> _exitApp(BuildContext context) {
  return showDialog(
    context: context,
    child: new AlertDialog(
      title: new Text('Do you want to exit this verification page?'),
      //content: new Text('We hate to see you leave...'),
      actions: <Widget>[
        new FlatButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
          child: new Text('No'),
        ),
        new FlatButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
          child: new Text('Yes'),
        ),
      ],
    ),
  ) ?? false;
}