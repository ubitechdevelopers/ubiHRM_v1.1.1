// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ubihrm/services/attandance_fetch_location.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/services/attandance_gethome.dart';
import 'package:ubihrm/services/attandance_saveimage.dart';
import 'package:ubihrm/model/timeinout.dart';
import '../drawer.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
//import 'package:datetime_picker_formfield/time_picker_formfield.dart';
import 'package:ubihrm/model/model.dart' as TimeOffModal;
import 'package:ubihrm/services/expense_services.dart';
import 'package:ubihrm/services/timeoff_services.dart';
import 'expenselist.dart';
import '../global.dart';
import '../b_navigationbar.dart';
import '../appbar.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:ubihrm/global.dart' as globals;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';


//import 'settings.dart';
import '../home.dart';
//import 'reports.dart';
import '../profile.dart';

// This app is a stateful, it tracks the user's current choice.
class RequestExpence extends StatefulWidget {
  @override
  _RequestExpenceState createState() => _RequestExpenceState();
}

class _RequestExpenceState extends State<RequestExpence> {
  bool isloading = false;
  bool isServiceCalling = false;
  final _dateController = TextEditingController();
  final _starttimeController = TextEditingController();
  final _endtimeController = TextEditingController();
  final amountController = TextEditingController();
  final _descController = TextEditingController();
  TimeOfDay starttime;
  TimeOfDay endtime;
  FocusNode textSecondFocusNode = new FocusNode();
  FocusNode textthirdFocusNode = new FocusNode();
  FocusNode textfourthFocusNode = new FocusNode();
  FocusNode myFocusNodeamount = new FocusNode();
  final dateFormat = DateFormat("dd-MM-yyyy");
  final timeFormat = DateFormat("H:mm");
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _defaultimage = new NetworkImage(
      "http://ubiattendance.ubihrm.com/assets/img/avatar.png");
  var profileimage;
  bool showtabbar;
  String orgName="";

  String headtype='0';
  bool _checkLoaded = true;
  bool _isButtonDisabled=false;
  int _currentIndex = 1;
  bool _visible = true;
  String location_addr="";
  String location_addr1="";
  String admin_sts='0';
  String act="";
  String act1="";
  int response;
  String fname="", lname="", empid="", email="", status="", orgid="", orgdir="", sstatus="", org_name="", desination="", profile,latit="",longi="";
  String aid="";
  String shiftId="";
  Future<File> ExpenseDoc;
  File _image=null;
  //var tempvar="";
  String close="";
  @override
  void initState() {
    super.initState();
    initPlatformState();
    getOrgName();
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    admin_sts = prefs.getString('sstatus') ?? '0';
    //  response = prefs.getInt('response') ?? 0;
    // if(response==1) {
    // Loc lock = new Loc();
    //  location_addr = await lock.initPlatformState();

    Home ho = new Home();
    act = await ho.checkTimeIn(empid, orgdir);

    ///  print("this is main "+location_addr);
    setState(() {
      //   location_addr1 = location_addr;
      //     response = prefs.getInt('response') ?? 0;
      fname = prefs.getString('fname') ?? '';
      lname = prefs.getString('lname') ?? '';
      empid = prefs.getString('empid') ?? '';
      email = prefs.getString('email') ?? '';
      status = prefs.getString('status') ?? '';
      orgid = prefs.getString('orgid') ?? '';
      orgdir = prefs.getString('orgdir') ?? '';
      sstatus = prefs.getString('sstatus') ?? '';
      org_name = prefs.getString('org_name') ?? '';
      desination = prefs.getString('desination') ?? '';
      profile = prefs.getString('profile') ?? '';
      showtabbar=false;
      profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);

      //  print("1-"+profile);
      profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
        if (mounted) {
          setState(() {
            _checkLoaded = false;
          });
        }
      }));
      //   print("2-"+_checkLoaded.toString());
      //   latit = prefs.getString('latit') ?? '';
      //  longi = prefs.getString('longi') ?? '';
      aid = prefs.getString('aid') ?? "";
      shiftId = prefs.getString('shiftId') ?? "";
      //    print("this is set state "+location_addr1);
      //    act1=act;
      //   print(act1);
    });
//    }
  }

  @override
  Widget build(BuildContext context) {
    // return (response==0) ? new LoginPage() : getmainhomewidget();
    return getmainhomewidget();
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.redAccent,);
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<bool> sendToExpenseList() async{
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );*/
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyExpence()), (Route<dynamic> route) => false,
    );
    return false;
  }

  getmainhomewidget(){
    return WillPopScope(
      onWillPop: ()=> sendToExpenseList(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor:scaffoldBackColor(),
        appBar: new AppHeader(profileimage,showtabbar,orgName),
        bottomNavigationBar:  new HomeNavigation(),
        endDrawer: new AppDrawer(),
        // body: (act1=='') ? Center(child : loader()) : checkalreadylogin(),
        //body:  getExpenseWidgit(),
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
              child: getExpenseWidgit()
          )
      ),
    );

  }
  checkalreadylogin(){
    //   if(response==1) {
    return new IndexedStack(
      index: _currentIndex,
      children: <Widget>[
        //       underdevelopment(),
        //    mainbodyWidget(),
        //      underdevelopment()
      ],
    );
    /*  }else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } */
  }
  loader(){
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset(
                  'assets/spinner.gif', height: 50.0, width: 50.0),
            ]),
      ),
    );
  }
  underdevelopment(){
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.android,color: appStartColor(),),Text("Under development",style: new TextStyle(fontSize: 30.0,color: appStartColor()),)
            ]),
      ),
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
              getTimeoffWidgit(),
              //getMarkAttendanceWidgit(),
            ],
          ),


        ],
      ),

    );
  }
  */



  Widget getExpenseWidgit() {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          //width: MediaQuery.of(context).size.width*0.9,
          //    height: MediaQuery.of(context).size.height * 0.75,
          decoration: new ShapeDecoration(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            color: Colors.white,
          ),

          child:Form(
            key: _formKey,
            child: SafeArea(
              child: Column(children: <Widget>[
                SizedBox(height: 10.0),
                //   mainAxisAlignment: MainAxisAlignment.start,
                Text('Expense Request',
                    style: new TextStyle(fontSize: 22.0, color: appStartColor()),textAlign: TextAlign.center,),
                new Divider(color: Colors.black54,height: 1.5,),
                new Expanded(child: ListView(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            //     SizedBox(height: MediaQuery.of(context).size.height * .01),

                            new Expanded(

                              child:  DateTimeField(
                                //firstDate: new DateTime.now(),
                                //initialDate: new DateTime.now(),
                                //dateOnly: true,
                                //inputType: InputType.date,
                                format: dateFormat,
                                controller: _dateController,
                                readOnly: true,
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate: currentValue ?? DateTime.now(),
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

                                  labelText: 'Date',
                                ),
                                validator: (date) {
                                  if (date==null){
                                    return 'Please enter Expense date';
                                  }
                                },
                              ),
                            ),
                          ],
                        ),//Enter date
                  new Row(
                    children: <Widget>[
                      Expanded(
                        child: gethead_DD())]),


                        //   SizedBox(height: 5.0),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child:  Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: TextFormField(
                                  controller: _descController,
                                  decoration: InputDecoration(
                                      labelText: 'Description',
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: Icon(
                                          Icons.event_note,
                                          color: Colors.grey,
                                        ), // icon is 48px widget.
                                      )
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter description';
                                    }
                                  },
                           onFieldSubmitted: (String value) {
                           /*if (_formKey.currentState.validate()) {

                            saveExpense (_dateController.text, headtype, _descController.text, amountController.text ,_image,context);
                                    }*/
                                  },
                                  maxLines: null,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),

                        Row(
                          children: <Widget>[
                            Expanded(
                              child:  TextFormField(
                                focusNode: myFocusNodeamount,
                                controller: amountController,
                                keyboardType: TextInputType.number,
                               /* inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],*/
                                style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black),
                                decoration: InputDecoration(
                                    labelText: 'Amount',
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Icon(
                                        Icons.call_to_action,
                                        color: Colors.grey,
                                      ), // icon is 48px widget.
                                    )
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter amount';
                                  }
                                },
                              ),
                            ),

                         /*   Expanded(
                              child:Container(
                                width: 50.0,
                              child:  TextFormField(
                                  enabled:false,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                    border: InputBorder.none,
                                  hintText: deprtcurrency,
                                 //   labelText: 'Currency',
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(0.0),
                                       // icon is 48px widget.
                                    )
                                ),
                              )),
                            ),*/
                          ],
                        ),

                        SizedBox(height: 20.0),


                       /* Container(
                          //width: MediaQuery.of(context).size.width*0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              MaterialButton(
                                child: FlatButton.icon(
                                  //color: Colors.red,
                                  icon: Padding(
                                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                                    child: Icon(Icons.file_upload,color:_image!=null ? Colors.green[500]:Colors.grey[500],),
                                  ), //`Icon` to display
                                  label: Container(
                                    padding: EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 10.0),
                                    //margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                                    child:showImage(_image),), //`Text` to display
                                  onPressed: () async {
                                    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                                    print("---------------------------->>>>>>>>>>>"+image.toString());
                                    //  ExpenseDoc=image;
                                    setState(() {
                                      _image = image;
                                    });
                                  },
                                  splashColor: Colors.grey,
                                ),
                                shape: UnderlineInputBorder(),
                                minWidth: 371,
                                //height: 40,
                              ),

                            ],
                          ),
                        ),
*/
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                /*new Icon(
                                  Icons.file_upload,
                                  color: Colors.grey,
                                ),*/

                                Flexible(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width*0.90,
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: FlatButton.icon(
                                              icon: Padding(
                                                padding: const EdgeInsets.only(bottom:15.0),
                                                child: Icon(Icons.file_upload,color:_image!=null ? Colors.green[500]:Colors.grey[500],size: 27,),
                                              ), //
                                              label: Container(
                                                  width: MediaQuery.of(context).size.width*0.6,
                                                  padding: EdgeInsets.fromLTRB(0.0,0.0, 0.0, 15.0),
                                                  //margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                                  child:showImage(_image),
                                              ),
                                              //child: Text("Select Image", style: TextStyle(color:_image!=null ? Colors.green[500]:Colors.grey[500],),textAlign: TextAlign.start,),
                                              onPressed: () async {
                                                var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                                                print(image);
                                                setState(() {
                                                  _image = image;
                                                });
                                              },
                                              splashColor: Colors.grey,
                                              //height: 55,
                                              //minWidth: 350,
                                              shape: UnderlineInputBorder(),
                                          ),
                                      ),
                                    ),

                                ),

                             //showImage(_image)

                             /*ButtonTheme(
                              //minWidth: 100.0,
                             // height: 40.0,
                              child: RaisedButton(
                              //shape: Border.all(color: Colors.black54),
                                shape: CircleBorder(),
                                color:_image!=null ? Colors.green[500]:Colors.grey[500],
                                onPressed: () async {
                                  var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                                // ExpenseDoc=image;
                                  setState(() {
                                    _image = image;
                                  });
                                },
                            child:
                               new Icon(
                                  Icons.file_upload,
                                  color: Colors.white,
                                ),*//*new Text(
                              "Supporting docs", textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14.0, color: Colors.grey[800]),
                            ),*//*
                          ),
                     ),
*/
                    /* Container(
                       padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                       margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                       child:showImage(_image),
                     ),*/
                              ]),
                        SizedBox(height: 5.0),
                       ButtonBar(

                          children: <Widget>[

                            /*RaisedButton(
                              *//* child: _isButtonDisabled?Row(children: <Widget>[Text('Processing ',style: TextStyle(color: Colors.white),),SizedBox(width: 10.0,), SizedBox(child:CircularProgressIndicator(),height: 20.0,width: 20.0,),],):Text('SAVE',style: TextStyle(color: Colors.white),),*//*
                              child: _isButtonDisabled?Text('Processing..',style: TextStyle(color: Colors.white),):Text('ADD',style: TextStyle(color: Colors.white),),
                              color: Colors.orange[800],
                              onPressed: () {
                                 tempvar="2";
                saveExpense (_dateController.text,  headtype, _descController.text,amountController.text , _image, tempvar,context);

                              },
                            ),*/
                            RaisedButton(
                              /* child: _isButtonDisabled?Row(children: <Widget>[Text('Processing ',style: TextStyle(color: Colors.white),),SizedBox(width: 10.0,), SizedBox(child:CircularProgressIndicator(),height: 20.0,width: 20.0,),],):Text('SAVE',style: TextStyle(color: Colors.white),),*/
                              child: isServiceCalling?Text('Processing..',style: TextStyle(color: Colors.white),):Text('SAVE',style: TextStyle(color: Colors.white),),
                              color: Colors.orange[800],
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  if (headtype == '0') {
                                    showDialog(context: context, child:
                                    new AlertDialog(
                                      //title: new Text("Sorry!"),
                                      content: new Text(
                                          "Please select headtype!"),
                                    )
                                    );
                                  }else {
                                    print("hello");
                                    saveExpense(_dateController.text, headtype, _descController.text.trim(), amountController.text.trim(), _image, context);
                                  }
                                  //saveExpense(_dateController.text, headtype, _descController.text.trim(), amountController.text.trim(), _image, context);
                                }
                                //tempvar="1";

                                // requesttimeoff(_dateController.text ,_starttimeController.text,_endtimeController.text,
                                //   _descController.text, context);
                              },
                            ),


                            FlatButton(
                              shape: Border.all(color: Colors.orange[800]),
                              child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MyExpence()),
                                );
                              },
                            ),

                          ],
                        ),

                      ],
                    ),

                  ],
                ),),],
              ),),),
        ),
      ],
    );
  }

  ////////////////common dropdowns
  Widget gethead_DD() {
    String dc = "0";
    return new FutureBuilder<List<Map>>(
       future: getheadtype(0), //with -select- label
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new Container(
              //    width: MediaQuery.of(context).size.width*.45,
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Category',
                  // icon is 48px widget.
                   ),

                  child:  new DropdownButton<String>(
                  isDense: true,
                  style: new TextStyle(
                      fontSize: 15.0,
                      color: Colors.black
                  ),
                  value: headtype,
                  onChanged: (String newValue) {
                    setState(() {
                      headtype =newValue;
                    });
                  },

                  items: snapshot.data.map((Map map) {
                    return new DropdownMenuItem<String>(
                      value: map["Id"].toString(),
                      child:  new SizedBox(
                        //     width: MediaQuery.of(context).size.width * 10,
                          child: new Text(
                            map["Name"],
                          )
                      ),
                    );

                  }).toList(),

                ),
              ),

            );
          }
          else if (snapshot.hasError)
          {
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


  Future<bool> saveExpense(var expensedate, var category, var desc, var amount, File doc, BuildContext context) async { // visit in function

    try {
      Dio dio = new Dio();
      setState(() {
        isServiceCalling = true;
      });
      print("----> service calling "+isServiceCalling.toString());
      final prefs = await SharedPreferences.getInstance();
      String orgid = prefs.getString('organization') ?? '';
      String empid = prefs.getString('employeeid') ?? "";
      if (doc!=null) {
        FormData formData = new FormData.from({
          "empid": empid,
          "orgid": orgid,
          "edate": expensedate,
          "category": category,
          "desc": desc,
          "amt": amount,
          "file": new UploadFileInfo(doc, "image.png"),
        });
        print(formData);
        print(doc);
        //  print("5" +expensedate+"---"+category+"---"+desc+"---"+amount+"---"+empid+"--"+orgid+"--");
        Response<String> response1;
        try {
          final prefs = await SharedPreferences.getInstance();
          String path1 = prefs.getString('path');
          // print(globals.path +"saveExpense?empid="+empid+"&orgid="+orgid+"&edate="+expensedate+"&desc="+desc+"&category="+category+"&amt="+amount);
          response1 = await dio.post(path1 + "saveExpense", data: formData);
          print("----->save Expense* --->" + response1.toString());
        } catch (e) {
          print('------------*');
          print(e.toString());
       //   print('------------*');
        }

        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
       // print('------------1*');
        print(MarkAttMap["status"].toString());
       // print('------------2*');
        if ((response1.toString().contains("true"))) {
        //  print('------true  in img');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyExpence()),
          );
          showDialog(context: context, child:
            new AlertDialog(
              content: new Text('Expense has been applied successfully!'),
            )
          );
          //showInSnackBar("Expense has been applied successfully.");
           /*if(tempvar=="1"){
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => MyExpence()),
             );
           }else{
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => RequestExpence()),
             );
           }*/
          return true;
        }
        else if((response1.toString().contains("false1"))){
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyExpence()),
          );*/
          showDialog(context: context, child:
          new AlertDialog(
            content: new Text('Expense already applied on this date.'),
          ));
          setState(() {
            isServiceCalling = false;
          });
          //print('------false1  in img');
          //showInSnackBar("Expence already applied on this date");
        }
        else {
        //  print('------false  in img');
          showDialog(context: context, child:
          new AlertDialog(
            content: new Text('There is some problem while applying for Expense.'),
          ));
          //showInSnackBar("There is some problem while applying for Expense.");
          //return false;
          setState(() {
            isServiceCalling = false;
          });
        }
      }

    else{
      FormData formData = new FormData.from({
          "empid": empid,
          "orgid": orgid,
          "edate": expensedate,
          "category": category,
          "desc": desc,
          "amt": amount,
          "file":"",
        //  "file": new UploadFileInfo(doc, "image.png"),
        });
     //   print(formData);
      //  print(doc);
        //print("kkkkkkkkkkkkkk");
        //  print("5" +expensedate+"---"+category+"---"+desc+"---"+amount+"---"+empid+"--"+orgid+"--");
        Response<String> response1;
        try {
          final prefs = await SharedPreferences.getInstance();
          String path1 = prefs.getString('path');
          print(path1 +"saveExpense?empid="+empid+"&orgid="+orgid+"&edate="+expensedate+"&desc="+desc+"&category="+category+"&amt="+amount);
          response1 =
          await dio.post(path1 + "saveExpense", data: formData);
          print("----->save Expense* --->" + response1.toString());
        } catch (e) {
          print('------------*');
          print(e.toString());
          print('------------*');
        }
        /*getTempImageDirectory();*/
        Map expensemap = json.decode(response1.data);
      //  print('------------1*');
      //  print(expensemap["status"].toString());
       // print('------------2*');
      if ((response1.toString().contains("true"))) {
      //  print('------true');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyExpence()),
        );
        showDialog(context: context, child:
          new AlertDialog(
            content: new Text('Expense has been applied successfully.'),
          )
        );
       /* if(tempvar=="1"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyExpence()),
          );
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RequestExpence()),
          );
        }*/
        return true;
      }
      else if((response1.toString().contains("false1"))){
        showDialog(context: context, child:
        new AlertDialog(
          content: new Text('Expense already applied on this date.'),
        )
        );
        setState(() {
          isServiceCalling = false;
        });
        //showInSnackBar("Expence already applied on this date");
      }
      else {
     //   print('------false');
        showDialog(context: context, child:
        new AlertDialog(
          content: new Text("There is some problem while applying for Expense."),
        )
        );
        //showInSnackBar("There is some problem while applying for Expense.");
        //return false;
        setState(() {
          isServiceCalling = false;
        });
      }

      }

  }
    catch (e) {
      print('7');
    //  print("------->");
      print(e.toString());
     // print("------->");

      return false;
    }
  }




  Widget showImage(_image) {
  return FutureBuilder<File>(
   //  future: ExpenseDoc,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        /*if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
            return Image.file(
                snapshot.data,
                width: 50,
                height: 50,
              );
        } */
        if(_image!=null ) {
          return new Row(
              mainAxisAlignment: MainAxisAlignment.start,
             children: <Widget>[
               Text("Attachment selected",style: TextStyle(fontSize: 16.0, color: Colors.green),
                 overflow: TextOverflow.ellipsis, ),
               /*Icon(
                Icons.check,
                color: Colors.green,
                ),*/
               /* Container(
                     child:new IconButton(
                       icon: new Icon(Icons.close, color: Colors.redAccent,),
                       onPressed: () {
                        setState(() {
                           print("onpressiconclose");
                           close='1';
                           _image=null;
                           print(_image);
                         });
                       },
                     )
                ),*/
           ]);
        }
        else if (snapshot.error != null) {
          return const Text(
            'Error Picking Attachment',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16.0, color: Colors.grey),
            textAlign: TextAlign.start,
          );
        } else {
          return const Text(
            'Select Attachment',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16.0, color: Colors.grey),
            textAlign: TextAlign.start,
          );
        }
      },
    );
  }
}




