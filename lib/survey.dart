//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/home.dart';
import 'package:ubihrm/model/model.dart';
import 'package:ubihrm/services/checkLogin.dart';
import 'global.dart';


class SurveyForm extends StatefulWidget {
  @override
  final String trialOrgId;
  final String orgName;
  final String name;
  final String email;
  final String countrycode;
  final String phone;
  final String password;
  SurveyForm({Key key, this.trialOrgId, this.orgName, this.name, this.email, this.countrycode, this.phone, this.password}) : super(key: key);

  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  bool _isServiceCalling = false;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FocusNode myFocusNodeEmpNum = FocusNode();
  final FocusNode myFocusNodeReq = FocusNode();
  final FocusNode __contcode = FocusNode();

  TextEditingController OrgNameController = new TextEditingController();
  TextEditingController NameController = new TextEditingController();
  TextEditingController EmailController = new TextEditingController();
  TextEditingController ContCodeController = new TextEditingController();
  TextEditingController PhoneController = new TextEditingController();
  TextEditingController EmpNumController = new TextEditingController();
  TextEditingController ReqController = new TextEditingController();

  bool _isButtonDisabled = false;
  bool chkAttVal = false;
  bool chkLeaveVal = false;
  bool chkPayrollVal = false;
  bool chkSalaryVal = false;
  bool chkTimesheetVal = false;
  bool chkPerformanceVal = false;

  String attModule='', leaveModule='',payrollModule='', expenseModule='', salaryModule='', timesheetModule='', performanceModule='';

  List<String> _timeIST = ['09:00-10:00',
    '10:00-11:00',
    '11:00-12:00',
    '12:00-13:00',
    '13:00-14:00',
    '14:00-15:00',
    '15:00-16:00',
    '16:00-17:00',
    '17:00-18:00',
    '18:00-19:00'];
  String _selectedISTtime;

  setLocal(var fname, var empid, var  orgid) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('fname',fname);
    await prefs.setString('empid',empid);
    await prefs.setString('orgid',orgid);
  }

  SharedPreferences prefs;
  Map<String, dynamic>res;

  @override
  void dispose() {
    super.dispose();
  }

  //FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  String token1="";
  String tokenn="";

  @override
  void initState(){
    OrgNameController.text = widget.orgName;
    NameController.text = widget.name;
    EmailController.text = widget.email;
    ContCodeController.text = widget.countrycode;
    PhoneController.text = widget.phone;
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /*_firebaseMessaging.configure(
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: new Scaffold(
        key: _scaffoldKey,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 980.0 ? MediaQuery.of(context).size.height : 980.0,
                //height: MediaQuery.of(context).size.height*1.25,
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
                child:ModalProgressHUD(
                    inAsyncCall: _isServiceCalling,
                    opacity: 0.5,progressIndicator: SizedBox(
                  child: new CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation(Colors.green),
                      strokeWidth: 5.0),
                  height: 40.0,
                  width: 40.0,),
                    child: Column(
                      children: <Widget>[
                        /*Padding(
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
                        ),*/

                        _buildSignUp(context)
                      ],
                    )
                ),
              )
          ),
        ),
      ),
    );
  }

  _buildSignUp(BuildContext context) {
    return Container(
      //padding: EdgeInsets.only(top: 0.0),
      child: Form(
        key: _formKey,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.topCenter,
                overflow: Overflow.visible,
                children: <Widget>[
                  Card(
                    elevation: 2.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      //width: 370.0,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*1.3,
                      //height: 870.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0,bottom: 0.0),
                            child: new Text("Take a quick survey!",
                              //textAlign: TextAlign.center,
                              style: new TextStyle(fontWeight: FontWeight.bold, fontSize:26.0, color:Colors.black/*color: appStartColor()*/ ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0,bottom: 0.0),
                            child: new Text("Please take 2 minutes to answer these short questions.",
                              //textAlign: TextAlign.center,
                              style: new TextStyle(fontWeight: FontWeight.bold, fontSize:14.0, color:Colors.black/*color: appStartColor()*/ ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 20.0, bottom: 7.0, left: 25.0, right: 25.0),
                                  child: TextFormField(
                                    //focusNode: myFocusNodeOrgName,
                                    controller: OrgNameController,
                                    keyboardType: TextInputType.text,
                                    enabled: false,
                                    textCapitalization: TextCapitalization.words,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black54),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                      // border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.solidBuilding,
                                        color: Colors.black,
                                      ),
                                      hintText: "Organization Name",
                                      hintStyle: TextStyle(
                                          fontSize: 14.0),
                                    ),
                                    /*validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter company name';
                                      }
                                    },*/
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 7.0, bottom: 7.0, left: 25.0, right: 25.0),
                                  child: TextFormField(
                                    //focusNode: myFocusNodeName,
                                    controller: NameController,
                                    keyboardType: TextInputType.text,
                                    enabled: false,
                                    //textCapitalization: TextCapitalization.words,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black54),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                      //border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.userAlt,
                                        color: Colors.black,
                                      ),
                                      hintText: "Full Name",
                                      hintStyle: TextStyle(
                                          fontSize: 14.0),
                                    ),
                                    /*validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter contact person name';
                                      }
                                    },*/
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 7.0, bottom: 7.0, left: 25.0, right: 25.0),
                                  child: TextFormField(
                                    //focusNode: myFocusNodeEmail,
                                      controller: EmailController,
                                      keyboardType: TextInputType.emailAddress,
                                      enabled: false,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black54),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                        icon: Icon(
                                          FontAwesomeIcons.solidEnvelope,
                                          color: Colors.black,
                                        ),
                                        hintText: "Email ID",
                                        hintStyle: TextStyle(
                                            fontSize: 14.0),
                                      ),
                                      validator: validateEmail
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0,bottom: 5),
                                child: Container(
                                  child: Icon(
                                    Icons.phone,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                ),
                              ),

                              new Expanded(
                                flex: 20,
                                child:Padding(
                                    padding: EdgeInsets.only(top: 7.0, bottom: 7.0, left: 14.0, right: 0.0),
                                    child: new TextFormField(
                                      //focusNode: __contcode,
                                      controller: ContCodeController,
                                      enabled: false,
                                      textAlign: TextAlign.justify,
                                      style: new TextStyle(
                                        //height: 1.25,
                                        fontSize: 16.0,
                                        color: Colors.black54,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                      ),

                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        WhitelistingTextInputFormatter.digitsOnly,
                                      ],
                                    )
                                ),
                              ),

                              Expanded(
                                flex: 75,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 7.0, bottom: 7.0, left: 10.0, right: 25.0),
                                  child: TextFormField(
                                    //focusNode: myFocusNodePhone,
                                    controller: PhoneController,
                                    keyboardType: TextInputType.phone,
                                    enabled: false,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly,
                                    ],
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black54),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                      hintText: "Contact No.",
                                      hintStyle: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black54,),
                                    ),
                                    /*validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter phone no.';
                                      }
                                    },*/
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 7.0, bottom: 7.0, left: 25.0, right: 25.0),
                                  child: TextFormField(
                                    //focusNode: myFocusNodeEmpNum,
                                    controller: EmpNumController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                      icon: Icon(
                                        FontAwesomeIcons.users,
                                        color: Colors.black,
                                      ),
                                      hintText: "No. of Employees",
                                      hintStyle: TextStyle(
                                          fontSize: 14.0),
                                    ),
                                    /*validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter contact person name';
                                      }
                                    },*/
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 60.0, top: 20.0,bottom: 0.0),
                            child: Row(
                              children: <Widget>[
                                new Text("MODULES REQUIRED",
                                  //textAlign: TextAlign.center,
                                  style: new TextStyle(fontWeight: FontWeight.bold, fontSize:16.0, color:Colors.black/*color: appStartColor()*/ ),
                                ),
                                //Spacer()
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left:45.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                          value: chkAttVal,
                                          onChanged: (bool value) {
                                            setState(() {
                                              chkAttVal = value;
                                              print("after click");
                                              print(chkAttVal);
                                              if(chkAttVal==true) {
                                                attModule = "true";
                                                print(attModule);
                                              }
                                            });
                                          },
                                        ),
                                        Text('Attendance')
                                      ],
                                    ),
                                    SizedBox(width:20),
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                          value: chkLeaveVal,
                                          onChanged: (bool value) {
                                            setState(() {
                                              chkLeaveVal = value;
                                              if(chkLeaveVal==true) {
                                                leaveModule = "true";
                                              }
                                            });
                                          },
                                        ),
                                        Text('Leave')
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    widget.countrycode=='+91'?Row(
                                      children: <Widget>[
                                        Checkbox(
                                          value: chkPayrollVal,
                                          onChanged: (bool value) {
                                            setState(() {
                                              chkPayrollVal = value;
                                              if(chkPayrollVal==true) {
                                                payrollModule = "true";
                                              }
                                            });
                                          },
                                        ),
                                        Text('Payroll')
                                      ],
                                    ):
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                          value: chkSalaryVal,
                                          onChanged: (bool value) {
                                            setState(() {
                                              chkSalaryVal = value;
                                              if(chkSalaryVal==true) {
                                                salaryModule = "true";
                                              }
                                            });
                                          },
                                        ),
                                        Text('Salary')
                                      ],
                                    ),
                                    SizedBox(width:53),
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                          value: chkPerformanceVal,
                                          onChanged: (bool value) {
                                            setState(() {
                                              chkPerformanceVal = value;
                                              if(chkPerformanceVal==true) {
                                                performanceModule = "true";
                                              }
                                            });
                                          },
                                        ),
                                        Text('Performance')
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                          value: chkTimesheetVal,
                                          onChanged: (bool value) {
                                            setState(() {
                                              chkTimesheetVal = value;
                                              if(chkTimesheetVal==true) {
                                                timesheetModule="true";
                                              }
                                            });
                                          },
                                        ),
                                        Text('Timesheet')
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left:60.0,top: 20.0,bottom: 0.0),
                            child: Row(
                              children: <Widget>[
                                new Text("REQUIREMENTS IN BRIEF",
                                  //textAlign: TextAlign.center,
                                  style: new TextStyle(fontWeight: FontWeight.bold, fontSize:16.0, color:Colors.black/*color: appStartColor()*/ ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 7.0, bottom: 7.0, left: 25.0, right: 25.0),
                                  child: TextFormField(
                                    //maxLines: 2,
                                    //focusNode: myFocusNodeReq,
                                    controller: ReqController,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                      icon: Icon(
                                        FontAwesomeIcons.pencilAlt,
                                        color: Colors.black,
                                      ),
                                      hintText: "Requirements in brief",
                                      hintStyle: TextStyle(
                                          fontSize: 14.0),
                                    ),
                                    /*validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter contact person name';
                                      }
                                    },*/
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(
                                      top: 5.0, bottom: 7.0, left: 25.0, right: 25.0),
                                  child:new InputDecorator(
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                      icon: Icon(
                                        FontAwesomeIcons.tty,
                                        color: Colors.black,
                                      ),
                                    ),
                                    child: Container(
                                      height: 21,
                                      child: DropdownButtonHideUnderline(
                                        child: new DropdownButton<String>(
                                          isExpanded: false,
                                          isDense: true,
                                          hint: new Text("Select preferred time(IST) to call", style: TextStyle(fontSize: 14.0)),
                                          //style: TextStyle(fontSize: 14.0),
                                          value: _selectedISTtime,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              _selectedISTtime=newValue;
                                            });
                                          },
                                          items: _timeIST.map((time) {
                                            return new DropdownMenuItem<String>(
                                              child: new Text(time),
                                              value: time,
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top:30.0),
                            child: Center(
                              child: RaisedButton(
                                  child:Text('SUBMIT',style: TextStyle(color: Colors.white, fontSize: 18),),
                                  color: Colors.orange[800],
                                  onPressed: () {
                                    print("Hello");
                                    print(EmpNumController.text);
                                    print(attModule);
                                    print(leaveModule);
                                    print(expenseModule);
                                    print(salaryModule);
                                    print(timesheetModule);
                                    print(performanceModule);
                                    print(ReqController.text);
                                    print(_selectedISTtime);
                                    //if (_formKey.currentState.validate()) {
                                    if(EmpNumController.text==""){
                                      showDialog(context: context, child:
                                      new AlertDialog(
                                        content: new Text("Please enter no. of employees"),
                                      ));
                                      FocusScope.of(context).requestFocus(myFocusNodeEmpNum);
                                    }else if((chkAttVal||chkLeaveVal||chkPayrollVal||chkSalaryVal||chkTimesheetVal||chkPerformanceVal)==false){
                                      showDialog(context: context, child:
                                      new AlertDialog(
                                        content: new Text("Please select atleast one module"),
                                      ));
                                    }else if(_selectedISTtime==null){
                                      showDialog(context: context, child:
                                      new AlertDialog(
                                        content: new Text("Please select preferred time (IST) to call"),
                                      ));
                                    }else{
                                      print(path+"savesurvey?trialorgid=${widget.trialOrgId}&org_name=${OrgNameController.text}&name=${NameController.text}&email=${EmailController.text}&countrycode=${ContCodeController.text}&phone=${PhoneController.text}&empno=${EmpNumController.text}&attmodule=$attModule&leavemodule=$leaveModule&payrollmodule=$payrollModule&salarymodule=$salaryModule&timesheetmodule=$timesheetModule&performancemodule=$performanceModule&requirement=${ReqController.text}&timetocall=$_selectedISTtime");
                                      var url = path+"savesurvey";
                                      http.post(url, body: {
                                        "trialorgid": widget.trialOrgId,
                                        "org_name": OrgNameController.text,
                                        "name": NameController.text,
                                        "email": EmailController.text,
                                        "countrycode": ContCodeController.text,
                                        "phone": PhoneController.text,
                                        "empno": EmpNumController.text,
                                        "attmodule": attModule,
                                        "leavemodule": leaveModule,
                                        "payrollmodule": payrollModule,
                                        "salarymodule": salaryModule,
                                        "timesheetmodule": timesheetModule,
                                        "performancemodule": performanceModule,
                                        "requirement": ReqController.text,
                                        "timetocall": _selectedISTtime,
                                        "platform": 'android'
                                      }).then((response) {
                                        if (response.statusCode == 200) {
                                          if (response.body.toString().contains("true")) {
                                            gethome () async{
                                              await new Future.delayed(const Duration(seconds: 1));
                                              checklogin(widget.phone, widget.password, context);
                                            }
                                            gethome ();
                                            /*showDialog(context: context, child:
                                                new AlertDialog(
                                                  content: new Text(
                                                      "Survey submitted successfully"),
                                                ));*/
                                            /*Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder: (context) => Otp(
                                                trialOrgId: widget.trialOrgId,
                                              )), (Route<dynamic> route) => false,
                                            );*/
                                          }else if(response.body.toString().contains("false")){
                                            showDialog(context: context, child:
                                            new AlertDialog(
                                              content: new Text(
                                                  "Survey not submitted successfully"),
                                            ));
                                          }else if(response.body.toString().contains("false1")){
                                            showDialog(context: context, child:
                                            new AlertDialog(
                                              content: new Text("Survey not submitted"),
                                            ));
                                          }
                                        }
                                      });
                                    }
                                    //}
                                  }
                              ),
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),

                  /*Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[]),*/
                ],
              ),
            ],



          ),
        ),
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
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

          content: new Text("Your trial period has expired"),
        )
        );
      }else if(res=='false2'){
        setState(() {
          _isServiceCalling = false;
        });
        showDialog(context: context, child:
        new AlertDialog(

          content: new Text("Your plan has expired"),
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
}

Future<bool> _exitApp(BuildContext context) {
  return showDialog(
    context: context,
    child: new AlertDialog(
      title: new Text('Do you want to exit this survey form?'),
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
  ) ??
      false;
}