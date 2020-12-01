import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
import '../model/model.dart';
import '../services/leave_services.dart';
import 'myleave.dart';

class RequestLeave extends StatefulWidget {
  @override
  _RequestLeaveState createState() => _RequestLeaveState();
}

class _RequestLeaveState extends State<RequestLeave> {
  bool isServiceCalling = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // String leavetypeid="32";
  List<Map> leavetimeList = [{"id":"2","name":"Half Day"},{"id":"1","name":"Full Day"}];
  List<Map> leavetypeList = [];

  String leavetimevalue = "1";
  String leavetimevalue1 = "1";
  String leavetypevalue = "1";
  bool isloading = false;
  String admin_sts='0';
  String leavetype='0';
  String CompoffSts='0';
  String substituteemp='0';
  DateTime Date1 = new DateTime.now();
  DateTime Date2 = new DateTime.now();
  final _dateController = TextEditingController();
  final _dateController1 = TextEditingController();
  final _leavetimevalueController = TextEditingController();
  final _leavetimevalueController1 = TextEditingController();
  final _reasonController = TextEditingController();
  FocusNode textSecondFocusNode = new FocusNode();
  FocusNode textthirdFocusNode = new FocusNode();
  FocusNode textfourthFocusNode = new FocusNode();
  final dateFormat = DateFormat("d MMM yyyy");
  final timeFormat = DateFormat("h:mm a");
  final _formKey = GlobalKey<FormState>();
  String _radioValue = "1"; // half day from type
  String _radioValue1 = "1"; // half day to type
  bool visibilityFromHalf = false;
  bool visibilityToHalf = false;
  int _currentIndex = 0;
  int response;
  var profileimage;
  bool showtabbar;
  String orgName="";
  bool _checkLoadedprofile=true;
  Widget mainWidget= new Container(width: 0.0,height: 0.0,);
  @override
  void initState() {
    super.initState();
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    showtabbar=false;
    /*  profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoadedprofile = false;
        });

      }
    }));*/
    initPlatformState();
    getOrgName();
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
  }



  initPlatformState() async{
    final prefs = await SharedPreferences.getInstance();
    mainWidget = loadingWidget();
    String empid = prefs.getString('employeeid')??"";
    String organization =prefs.getString('organization')??"";
    int profiletype =prefs.getInt('profiletype')??0;
    int hrsts =prefs.getInt('hrsts')??0;
    int adminsts =prefs.getInt('adminsts')??0;
    int dataaccess =prefs.getInt('dataaccess')??0;

    Employee emp = new Employee(
      employeeid: empid,
      organization: organization,
      profiletype:profiletype,
      hrsts:hrsts,
      adminsts:adminsts,
      dataaccess:dataaccess,
    );

    //if(empid!='')
    //bool ish = await getAllPermission(emp);

    //getModulePermission("178","view");
    //getProfileInfo();
    //getReportingTeam();
    /*islogin().then((Widget configuredWidget) {
      setState(() {
        mainWidget = configuredWidget;
      });
    });*/
  }

  void _handleRadioValueChange(String value) {
    setState(() {
      _radioValue = value;
    });
  }

  void _handleRadioValueChange1(String value) {
    setState(() {
      _radioValue1 = value;
    });
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),

    ));
  }

  requestleave(var leavefrom, var leaveto, var leavetypefrom, var leavetypeto, var halfdayfromtype, var halfdaytotype, var reason, var substituteemp, var compoffsts) async{
    setState(() {
      isServiceCalling = true;
    });
    print("----> service calling "+isServiceCalling.toString());
    final prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("employeeid")??"";
    String orgid = prefs.getString("organization")??"";
    Leave leave =new Leave(uid: uid, leavefrom: leavefrom, leaveto: leaveto, orgid: orgid, reason: reason, leavetypeid: leavetype, leavetypefrom: leavetypefrom, leavetypeto: leavetypeto, halfdayfromtype: halfdayfromtype, halfdaytotype: halfdaytotype, substituteemp: substituteemp, compoffsts:compoffsts);
    var islogin1 = await requestLeave(leave);
    //print("---ss>"+islogin1);
    if(islogin1=="true"){
      //showInSnackBar("Leave has been applied successfully.");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyLeave()), (Route<dynamic> route) => false,
      );
      // ignore: deprecated_member_use
      showDialog(context: context, child:
      new AlertDialog(

        content: new Text('Leave application applied successfully.'),
      )
      );
    }else if(islogin1=="false1"){
      // ignore: deprecated_member_use
      showDialog(context: context, child:
      new AlertDialog(
        content: new Text('There is some problem while applying for Leave.'),
      )
      );
      setState(() {
        isServiceCalling = false;
      });
      //showInSnackBar("There is some problem while applying for Leave.");
    }else if(islogin1=="false2"){
      // ignore: deprecated_member_use
      showDialog(context: context, child:
      new AlertDialog(
        content: new Text('Please Select leave type.'),
      )
      );
      setState(() {
        isServiceCalling = false;
      });
      //showInSnackBar("There is some problem while applying for Leave.");
    }else if(islogin1=="false3"){
      // ignore: deprecated_member_use
      showDialog(context: context, child:
      new AlertDialog(
        content: new Text('Fiscal year not found'),
      )
      );
      setState(() {
        isServiceCalling = false;
      });
      //showInSnackBar("There is some problem while applying for Leave.");
    }else if(islogin1=="wrong"){
      // ignore: deprecated_member_use
      showDialog(context: context, child:
      new AlertDialog(
        content: new Text('Leave format is wrong'),
      )
      );
      setState(() {
        isServiceCalling = false;
      });
      //showInSnackBar("Leave format is wrong");
    }else if(islogin1=="You cannot apply for comp off"){
      // ignore: deprecated_member_use
      showDialog(context: context, child:
      new AlertDialog(
        content: new Text('You cannot apply for comp off'),
      )
      );
      setState(() {
        isServiceCalling = false;
      });
      //showInSnackBar("Leave format is wrong");
    }else if(islogin1=="You cannot apply more than credited leaves"){
      showDialog(context: context, child:
      new AlertDialog(
        content: new Text('You cannot apply more than credited leaves'),
      )
      );
      setState(() {
        isServiceCalling = false;
      });
      //showInSnackBar("Leave format is wrong");
    }else if(islogin1=="alreadyApply"){
      // ignore: deprecated_member_use
      showDialog(context: context, child:
      new AlertDialog(
        content: new Text('You have already applied for same date'),
      )
      );
      setState(() {
        isServiceCalling = false;
      });
      //showInSnackBar("You already applied for same date");
    }else{
      // ignore: deprecated_member_use
      showDialog(context: context, child:
      new AlertDialog(
        content: new Text('Poor Network Connection'),
      )
      );
      setState(() {
        isServiceCalling = false;
      });
      //showInSnackBar("Poor Network Connection");
    }
  }

/*  Future<Widget> islogin() async{
    final prefs = await SharedPreferences.getInstance();
    int response = prefs.getInt('response')??0;
    if(response==1){
      return mainScafoldWidget();
    }else{
      return new LoginPage();
    }

  }*/

  @override
  Widget build(BuildContext context) {
    mainWidget = mainScafoldWidget();
    return mainWidget;
  }


  Widget loadingWidget(){
    return Center(child:SizedBox(

      child:
      Text("Loading..", style: TextStyle(fontSize: 10.0,color: Colors.white),),
    ));
  }

  Future<bool> sendToLeaveList() async{
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );*/
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyLeave()), (Route<dynamic> route) => false,
    );
    return false;
  }

  Widget mainScafoldWidget(){
    return  WillPopScope(
      onWillPop: ()=> sendToLeaveList(),
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor:scaffoldBackColor(),
          endDrawer: new AppDrawer(),
          appBar: new AppHeader(profileimage,showtabbar,orgName),
          bottomNavigationBar:  new HomeNavigation(),
          body: ModalProgressHUD(
              inAsyncCall: isServiceCalling,
              opacity: 0.15,
              progressIndicator: SizedBox(
                child:new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation(Colors.green),
                    strokeWidth: 5.0),
                height: 40.0,
                width: 40.0,
              ),
              child: homewidget()
          )

      ),
    );
  }

  Widget homewidget(){
    return Stack(
      children: <Widget>[
        Container(
          //height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          //width: MediaQuery.of(context).size.width*0.9,
          decoration: new ShapeDecoration(
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
            color: Colors.white,
          ),
          child:Form(
            key: _formKey,
            child: SafeArea(
                child: Column( children: <Widget>[
                  //SizedBox(height: 5.0),
                  Text('Request Leave',
                      style: new TextStyle(fontSize: 22.0, color: appStartColor())),
                  new Divider(color: Colors.black54,height: 1.5,),
                  new Expanded(
                    child: ListView(
                      //padding: EdgeInsets.symmetric(horizontal: 15.0),
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 5.0),
                            getLeaveType_DD(),
                            SizedBox(height: 10.0),
                            //Enter date
                            Row(
                              children: <Widget>[
                                new Expanded(
                                  child: Container(
                                    //margin: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
                                    height: MediaQuery.of(context).size.height*0.1,
                                    //height: 80,
                                    child:DateTimeField(
                                      //firstDate: new DateTime.now(),
                                      //initialDate: new DateTime.now(),
                                      //dateOnly: true,
                                      format: dateFormat,
                                      controller: _dateController,
                                      readOnly: true,
                                      onShowPicker: (context, currentValue) {
                                        print("current value1");
                                        print(currentValue);
                                        print(DateTime.now());
                                        return showDatePicker(
                                            context: context,
                                            firstDate: DateTime.now().subtract(Duration(days: 8)),
                                            initialDate: currentValue ?? DateTime.now(),
                                            lastDate: DateTime(2100)
                                        );
                                      },

                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.all(0.0),
                                          child: Icon(
                                            Icons.date_range,
                                            color: Colors.grey,
                                          ), // icon is 48px widget.
                                        ), // icon is 48px widget.
                                        labelText: 'From Date',
                                      ),
                                      onChanged: (date) {
                                        setState(() {
                                          Date1 = date;
                                        });
                                        print("----->Changed date------> "+Date1.toString());
                                      },
                                      /*validator: (date) {
                                        if (date==null){
                                          return 'Please enter Leave From date';
                                        }
                                      },*/

                                    ),
                                  ),
                                ),
                                (CompoffSts=='0')?SizedBox(width: 10.0):Center(),
                                (CompoffSts=='0')?Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:9.0),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height*0.08,
                                      //height: 60.0,
                                      child: new InputDecorator(
                                        decoration: InputDecoration(
                                          // labelText: 'Leave Type',
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.all(0.0),
                                            child: Icon(
                                              Icons.tonality,
                                              color: Colors.grey,
                                            ), // icon is 48px widget.
                                          ),
                                          border: new UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white,
                                                width: 0.0, style: BorderStyle.none ),),
                                        ),
                                        //   isEmpty: _color == '',
                                        child:  DropdownButtonHideUnderline(
                                          child: new DropdownButton<String>(
                                            isDense: true,
                                            style: new TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black
                                            ),
                                            value: leavetimevalue,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                leavetimevalue = newValue;
                                                if(leavetimevalue=="2"){
                                                  visibilityFromHalf = true;
                                                }else{
                                                  visibilityFromHalf = false;
                                                }
                                              });
                                            },
                                            items: leavetimeList.map((Map map) {
                                              return new DropdownMenuItem<String>(
                                                value: map["id"].toString(),
                                                child: new Text(
                                                  map["name"],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ):Center(),
                              ],
                            ),
                            (visibilityFromHalf)?Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Radio(
                                  value: "1",
                                  groupValue: _radioValue,
                                  onChanged: _handleRadioValueChange,
                                ),
                                Text("First Half",style: TextStyle(fontSize: 16.0),),
                                SizedBox(width: 55.0,),
                                new Radio(
                                  value: "2",
                                  groupValue: _radioValue,
                                  onChanged: _handleRadioValueChange,
                                ),
                                Text("Second Half",style: TextStyle(fontSize: 16.0),)
                              ],
                            ):Container(),
                            SizedBox(height: 5.0,),
                            Row(
                              children: <Widget>[
                                new Expanded(
                                  child: Container(
                                    //margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                                    //height: 70.0,
                                    height: MediaQuery.of(context).size.height*0.1,
                                    child:DateTimeField(
                                      //firstDate: new DateTime.now(),
                                      //initialDate: new DateTime.now(),
                                      //dateOnly: true,
                                      format: dateFormat,
                                      controller: _dateController1,
                                      readOnly: true,
                                      onShowPicker: (context, currentValue) {
                                        print("current value");
                                        print(currentValue);
                                        return showDatePicker(
                                            context: context,
                                            initialDate: currentValue ?? DateTime.now(),
                                            firstDate: DateTime.now().subtract(Duration(days: 8)),
                                            lastDate: DateTime(2100));

                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.all(0.0),
                                          child: Icon(
                                            Icons.date_range,
                                            color: Colors.grey,
                                          ), // icon is 48px widget.
                                        ), // icon is 48px widget.

                                        labelText: 'To Date',
                                      ),
                                      onChanged: (dt) {
                                        setState(() {
                                          Date2 = dt;
                                        });
                                        print("----->Changed date------> "+Date2.toString());
                                      },
                                      /*validator: (dt) {
                                        *//*if (dt==null){
                                          return 'Please enter Leave to date';
                                        }*//*
                                        if(Date2.isBefore(Date1)){
                                          print("Date1 ---->"+Date1.toString());
                                          print("Date2---->"+Date2.toString());
                                          return '\"To Date\" can\'t be smaller.';
                                        }

                                      },*/
                                    ),
                                  ),
                                ),
                                (CompoffSts=='0')?SizedBox(width: 10.0):Center(),
                                (CompoffSts=='0')?Expanded(
                                    child:Padding(
                                      padding: const EdgeInsets.only(top:9.0),
                                      child: Container(
                                        //height: 50.0,
                                        height: MediaQuery.of(context).size.height*0.08,
                                        child: new InputDecorator(
                                            decoration: InputDecoration(
                                              // labelText: 'Leave Type',
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.all(0.0),
                                                child: Icon(
                                                  Icons.tonality,
                                                  color: Colors.grey,
                                                ), // icon is 48px widget.
                                              ),
                                            ),
                                            //   isEmpty: _color == '',
                                            child:  DropdownButtonHideUnderline(
                                              child:  new DropdownButton<String>(
                                                isDense: true,
                                                style: new TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.black
                                                ),
                                                value: leavetimevalue1,
                                                onChanged: (String newValue) {
                                                  setState(() {
                                                    leavetimevalue1 = newValue;
                                                    if(leavetimevalue1=="2"){
                                                      visibilityToHalf = true;
                                                    }else{
                                                      visibilityToHalf = false;
                                                    }
                                                  });
                                                },
                                                items: leavetimeList.map((Map map) {
                                                  return new DropdownMenuItem<String>(
                                                    value: map["id"].toString(),
                                                    child: new Text(
                                                      map["name"],
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            )
                                        ),
                                      ),
                                    )
                                ):Center(),
                              ],
                            ),

                            (visibilityToHalf)?Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Radio(
                                  value: "1",
                                  groupValue: _radioValue1,
                                  onChanged: _handleRadioValueChange1,
                                ),
                                Text("First Half",style: TextStyle(fontSize: 16.0),),
                                SizedBox(width: 55.0,),
                                new Radio(
                                  value: "2",
                                  groupValue: _radioValue1,
                                  onChanged: _handleRadioValueChange1,
                                ),
                                Text("Second Half",style: TextStyle(fontSize: 16.0),)
                              ],
                            ):Container(),

                            SizedBox(height: 5.0,),

                            TextFormField(
                              controller: _reasonController,
                              decoration: InputDecoration(
                                  labelText: 'Reason',
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(bottom:0.0),
                                    child: Icon(
                                      Icons.event_note,
                                      color: Colors.grey,
                                    ), // icon is 48px widget.
                                  )
                              ),
                              /*validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter reason';
                                }
                              },*/
                              onFieldSubmitted: (String value) {
                                /*if (_formKey.currentState.validate()) {
                              //requesttimeoff(_dateController.text ,_starttimeController.text,_endtimeController.text,_reasonController.text, context);
                              }*/
                              },
                              maxLines: 1,
                            ),

                            SizedBox(height: 10.0,),

                            (CompoffSts=='0')?getSubstituteEmp_DD():Center(),
                            //getSubstituteEmp_DD(),

                            ButtonBar(
                              children: <Widget>[

                                RaisedButton(
                                  child: isServiceCalling?Text('Processing..',style: TextStyle(color: Colors.white),):Text('APPLY',style: TextStyle(color: Colors.white),),
                                  color: Colors.orange[800],
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      if (leavetype == '0') {
                                        showDialog(context: context, child:
                                        new AlertDialog(
                                          //title: new Text("Sorry!"),
                                          content: new Text("Please select leave type!"),
                                        )
                                        );
                                      }else if(_dateController.text==""){
                                        showDialog(context: context, child:
                                        new AlertDialog(
                                          //title: new Text("Sorry!"),
                                          content: new Text("Please enter leave from date"),
                                        )
                                        );
                                      }else if(_dateController1.text==""){
                                        showDialog(context: context, child:
                                        new AlertDialog(
                                          //title: new Text("Sorry!"),
                                          content: new Text("Please enter leave to date"),
                                        )
                                        );
                                      }else if(Date2.isBefore(Date1)){
                                        showDialog(context: context, child:
                                        new AlertDialog(
                                          //title: new Text("Sorry!"),
                                          content: new Text("To date can't be smaller"),
                                        )
                                        );
                                      }else if(_reasonController.text==""){
                                        showDialog(context: context, child:
                                        new AlertDialog(
                                          //title: new Text("Sorry!"),
                                          content: new Text("Please enter reason"),
                                        )
                                        );
                                      }else{
                                        if(CompoffSts=='0')
                                          requestleave(_dateController.text, _dateController1.text ,leavetimevalue, leavetimevalue1, _radioValue, _radioValue1, _reasonController.text.trim(), substituteemp, CompoffSts);
                                        else
                                          requestleave(_dateController.text, _dateController1.text , '0', '0', '0', '0', _reasonController.text.trim(), '0', CompoffSts);
                                      }
                                    }
                                  },
                                ),
                                FlatButton(
                                  shape: Border.all(color: Colors.orange[800]),
                                  child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MyLeave()),
                                    );
                                  },
                                ),

                              ],
                            ),
                          ],
                        ),

                      ],
                    ),
                  )
                ]
                )
            ),
          ),

        ),

      ],
    );
  }

  ////////////////common dropdowns
  Widget getLeaveType_DD() {
    String dc = "0";
    return new FutureBuilder<List<Map>>(
        future: getleavetype(0), //with -select- label
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new Container(
              //width: MediaQuery.of(context).size.width*.45,
              //padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Leave Type',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Icon(const IconData(0xe821, fontFamily: "CustomIcon"), size: 25.0,), // icon is 48px widget.
                  ),
                  // icon is 48px widget.
                ),
                child:  DropdownButtonHideUnderline(
                  child: Padding(
                    padding: const EdgeInsets.only(right:0.0),
                    child: new DropdownButton<String>(
                      //iconSize: 0.0,
                      isDense: true,
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.black
                      ),
                      value: leavetype,
                      onChanged: (String newValue) {
                        for(int i=0;i<snapshot.data.length;i++)
                        {
                          if(snapshot.data[i]['Id'].toString()==newValue)
                          {
                            setState(() {
                              CompoffSts= snapshot.data[i]['compoffsts'].toString();
                              print("CompoffSts");
                              print(CompoffSts);
                            });
                            break;
                          }
                          print(i);
                        }
                        setState(() {
                          leavetype=newValue;
                          print("leavetype");
                          print(leavetype);
                        });
                      },
                      items: snapshot.data.map((Map map) {
                        return new DropdownMenuItem<String>(
                          value: map["Id"].toString(),
                          child:  new SizedBox(
                              width: 248,
                              child: new Text(
                                map["Name"],
                              )
                          ),
                        );
                      }).toList(),

                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          // return loader();
          return new Center(child: SizedBox(
            child: CircularProgressIndicator(strokeWidth: 2.2,),
            height: 20.0,
            width: 20.0,
          ),
          );
        });
  }


  //////////////// Substitute Employee dropdowns /////////
  Widget getSubstituteEmp_DD() {
    String dc = "0";
    return new FutureBuilder<List<Map>>(
        future: getsubstitueemp(0), //with -select- label
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Suggest Substitute',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ), // icon is 48px widget.
                  ),
                  // icon is 48px widget.
                ),

                child:  DropdownButtonHideUnderline(
                  child: Padding(
                    padding: const EdgeInsets.only(right:0.0),
                    child: new DropdownButton<String>(
                      //iconSize: 0.0,
                      isDense: true,
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.black
                      ),
                      value: substituteemp,
                      onChanged: (String newValue) {
                        setState(() {
                          substituteemp =newValue;
                        });
                      },
                      items: snapshot.data.map((Map map) {
                        return new DropdownMenuItem<String>(
                          value: map["Id"].toString(),
                          child:  new Container(
                            //width: MediaQuery.of(context).size.width*.8,
                              child: new Text(
                                map["Name"],
                              )
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          // return loader();
          return new Center(child: SizedBox(
            child: CircularProgressIndicator(strokeWidth: 2.2,),
            height: 20.0,
            width: 20.0,
          ),);
        });
  }

}