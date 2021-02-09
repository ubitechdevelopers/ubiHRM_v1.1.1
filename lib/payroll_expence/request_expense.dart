// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/services/payroll_services.dart';
import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
import 'expenselist.dart';

// This app is a stateful, it tracks the user's current choice.
class RequestPayrollExpense extends StatefulWidget {
  @override
  _RequestPayrollExpenseState createState() => _RequestPayrollExpenseState();
}

class _RequestPayrollExpenseState extends State<RequestPayrollExpense> {
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
  //FilePickerResult _file=null;
  File _file=null;
  //var tempvar="";
  String close="";
  @override
  void initState() {
    super.initState();
    _dateController.text = formatter1.format(DateTime.now());
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
      MaterialPageRoute(builder: (context) => MyPayrollExpense()), (Route<dynamic> route) => false,
    );
    return false;
  }

  getmainhomewidget(){
    return WillPopScope(
      onWillPop: ()=> sendToExpenseList(),
      child: RefreshIndicator(
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
        onRefresh: () async {
          Completer<Null> completer = new Completer<Null>();
          await Future.delayed(Duration(seconds: 1)).then((onvalue) {
            setState(() {
              _dateController.clear();
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            });
            completer.complete();
          });
          return completer.future;
        },
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
                //SizedBox(height: 5.0),
                //   mainAxisAlignment: MainAxisAlignment.start,
                Text('Expense Claim',
                  style: new TextStyle(fontSize: 22.0, color: appStartColor()),textAlign: TextAlign.center,),
                new Divider(color: Colors.black54,height: 1.5,),
                new Expanded(child: ListView(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 5.0),
                        Row(
                          children: <Widget>[
                            //SizedBox(height: MediaQuery.of(context).size.height * .01),
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
                                  if (_dateController.text.isEmpty){
                                    return 'Please enter expense date';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) {
                                  if (_formKey.currentState.validate()) {}
                                },
                              ),
                            ),
                          ],
                        ),//Enter date
                        new Row(
                          children: <Widget>[
                            Expanded(child: gethead_DD())
                          ]
                        ),
                        //SizedBox(height: 5.0),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child:  Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.sentences,
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
                                    return null;
                                  },
                                  onFieldSubmitted: (String value) {
                                    if (_formKey.currentState.validate()) {}
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
                                        Icons.monetization_on,
                                        color: Colors.grey,
                                      ), // icon is 48px widget.
                                    )
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter amount';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (String value) {
                                  if (_formKey.currentState.validate()) {}
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.0),
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.90,
                                  decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(width: 1.0, color: Colors.grey),
                                      )
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0, bottom:16.0, top: 3.0),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            child: Icon(Icons.attach_file, color: Colors.grey,),
                                          ),
                                          InkWell(
                                            child: Container(
                                              //width: MediaQuery.of(context).size.width*0.6,
                                              padding: EdgeInsets.fromLTRB(10.0,0.0, 0.0, 0.0),
                                              //margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                              child:showFile(_file),
                                            ),
                                            onTap: () async {
                                              //var file = await ImagePicker.pickImage(source: ImageSource.gallery);
                                              File file = await FilePicker.getFile(type: FileType.any);
                                              //FilePickerResult file = await FilePicker.platform.pickFiles(type: FileType.any);
                                              print(file);
                                              setState(() {
                                                //_image = image;
                                                _file = file;
                                                /*int sizeInBytes = _file.lengthSync();
                                                print("sizeInBytes");
                                                print(sizeInBytes);
                                                double sizeInMb = sizeInBytes / (1024 * 1024);
                                                print("sizeInMb");
                                                print(sizeInMb);
                                                if (sizeInMb > 2){
                                                  showDialog(context: context, child:
                                                  new AlertDialog(
                                                    content: new Text(
                                                        "file size should not be greater than 2 MB"),
                                                  )
                                                  );
                                                }*/
                                              });
                                            },
                                          )
                                        ],
                                      )
                                  ),
                                ),

                              ),
                            ]),
                        SizedBox(height: 5.0),
                        Row(
                          children: [
                            Text("Note: Supported Document: png, jpg, doc, docx, pdf",
                              textAlign: TextAlign.start,
                              style: new TextStyle(fontSize:14.0, color: Colors.orange[900],),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("File Size: Max 2 MB",
                              textAlign: TextAlign.start,
                              style: new TextStyle(fontSize:14.0, color: Colors.orange[900],),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        ButtonBar(
                          children: <Widget>[
                            RaisedButton(
                              child: isServiceCalling?Text('Processing..',style: TextStyle(color: Colors.white),):Text('SUBMIT',style: TextStyle(color: Colors.white),),
                              color: Colors.orange[800],
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  /*if (headtype == '0') {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        Future.delayed(Duration(seconds: 3), () {
                                          Navigator.of(context).pop(true);
                                        });
                                        return AlertDialog(
                                          content: new Text("Please select headtype"),
                                        );
                                      });
                                  }else {*/
                                    savePayrollExpense(_dateController.text, headtype, _descController.text.trim(), amountController.text.trim(), _file, context);
                                  //}
                                }
                              },
                            ),

                            FlatButton(
                              shape: Border.all(color: Colors.orange[800]),
                              child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MyPayrollExpense()),
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
    future: getpayrollheadtype(0), //with -select- label
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return DropdownButtonHideUnderline(
          child: new DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Category',
              prefixIcon: Padding(
                padding: EdgeInsets.all(1.0),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: Colors.grey,
                ), // icon is 48px widget.
                //child: Icon(const IconData(0xe804, fontFamily: "CustomIcon"),size: 20.0,),
              ),
              // icon is 48px widget.
            ),
            isDense: true,
            isExpanded: false,
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
                  //width: MediaQuery.of(context).size.width * 10,
                    child: new Text(
                      map["Name"],
                    )
                ),
              );
            }).toList(),
            validator: (String value) {
              if (headtype=='0') {
                return 'Please select headtype';
              }
              return null;
            },
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


  Future<bool> savePayrollExpense(var expensedate, var category, var desc, var amount, File file, BuildContext context) async { // visit in function
    try {
      Dio dio = new Dio();
      setState(() {
        isServiceCalling = true;
      });
      final prefs = await SharedPreferences.getInstance();
      String orgid = prefs.getString('organization') ?? '';
      String empid = prefs.getString('employeeid') ?? "";
      if (file!=null) {
        String ext = p.extension(file.path);
        print(ext);
        FormData formData = new FormData.from({
          "empid": empid,
          "orgid": orgid,
          "edate": expensedate,
          "category": category,
          "desc": desc,
          "amt": amount,
          "file": new UploadFileInfo(file, "doc"+ext),
          //"file": File(file.files.single.path)
        });
        print(formData);
        print(file);
        Response<String> response1;
        try {
          print(path +"savePayrollExpense?empid="+empid+"&orgid="+orgid+"&edate="+expensedate+"&desc="+desc+"&category="+category+"&amt="+amount+"&file=$file");
          response1 = await dio.post(path + "savePayrollExpense", data: formData);
          print("----->save payroll Expense* --->" + response1.toString());
        } catch (e) {
          print(e.toString());
        }

        var MarkAttMap = json.decode(response1.data);
        print("MarkAttMap");
        print(MarkAttMap[0]);
        //if ((response1.toString().contains("true"))) {
        if (MarkAttMap[0]["status"].toString()=="true" && MarkAttMap[0]["imgsts"].toString()=="true") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyPayrollExpense()),
          );
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.of(context).pop(true);
                });
                return AlertDialog(
                  content: new Text("Expense submitted successfully"),
                );
              });
          // ignore: deprecated_member_use
          /*showDialog(context: context, child:
            new AlertDialog(
              content: new Text('Expense submitted successfully.'),
            )
          );*/
          return true;
          //} else if((response1.toString().contains("false1"))){
        } else if (MarkAttMap[0]["status"].toString()=="true" && MarkAttMap[0]["imgsts"].toString()=="false") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyPayrollExpense()),
          );
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.of(context).pop(true);
                });
                return AlertDialog(
                  content: new Text("Expense submitted successfully, but unable to upload attachment"),
                );
              });
          /*showDialog(context: context, child:
          new AlertDialog(
            content: new Text('Expense submitted successfully, but unable to upload attachment'),
          ));*/
          setState(() {
            isServiceCalling = false;
          });
        } else if (MarkAttMap[0]["status"].toString()=="true" && MarkAttMap[0]["imgsts"].toString()=="false1") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyPayrollExpense()),
          );
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.of(context).pop(true);
                });
                return AlertDialog(
                  content: new Text("Expense submitted successfully, but invalid file type"),
                );
              });
          /*showDialog(context: context, child:
          new AlertDialog(
            content: new Text('Expense submitted successfully, but invalid file type.'),
          ));*/
          setState(() {
            isServiceCalling = false;
          });
        } else if (MarkAttMap[0]["status"].toString()=="true" && MarkAttMap[0]["imgsts"].toString()=="false2") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyPayrollExpense()),
          );
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.of(context).pop(true);
                });
                return AlertDialog(
                  content: new Text("Expense submitted successfully, but file size should not be greater than 2 MB"),
                );
              });
          /*showDialog(context: context, child:
          new AlertDialog(
            content: new Text('Expense submitted successfully, but file size should not be greater than 2 MB.'),
          ));*/
          setState(() {
            isServiceCalling = false;
          });
        } else if (MarkAttMap[0]["status"].toString().contains("false1") && MarkAttMap[0]["imgsts"].toString().contains("false")) {
          /*showDialog(context: context, child:
          new AlertDialog(
            content: new Text('Expense already applied on this date.'),
          ));*/
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.of(context).pop(true);
                });
                return AlertDialog(
                  content: new Text("Expense already applied on this date"),
                );
              });
          setState(() {
            isServiceCalling = false;
          });
        } else {
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.of(context).pop(true);
                });
                return AlertDialog(
                  content: new Text("There is some problem while applying for expense"),
                );
              });
          /*showDialog(context: context, child:
          new AlertDialog(
            content: new Text('There is some problem while applying for expense.'),
          ));*/
          setState(() {
            isServiceCalling = false;
          });
        }
      } else{
        FormData formData = new FormData.from({
          "empid": empid,
          "orgid": orgid,
          "edate": expensedate,
          "category": category,
          "desc": desc,
          "amt": amount,
        });
        Response<String> response1;
        try {
          print(path +"savePayrollExpense?empid="+empid+"&orgid="+orgid+"&edate="+expensedate+"&desc="+desc+"&category="+category+"&amt="+amount);
          response1 = await dio.post(path + "savePayrollExpense", data: formData);
          print("----->save Expense* --->" + response1.toString());
        } catch (e) {
          print('------------*');
          print(e.toString());
          print('------------*');
        }
        var MarkAttMap = json.decode(response1.data);
        if (MarkAttMap[0]["status"].toString()=="true" && MarkAttMap[0]["imgsts"].toString()=="false") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyPayrollExpense()),
          );
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.of(context).pop(true);
                });
                return AlertDialog(
                  content: new Text("Expense submitted successfully"),
                );
              });
          // ignore: deprecated_member_use
          /*showDialog(context: context, child:
          new AlertDialog(
            content: new Text('Expense submitted successfully.'),
          )
        );*/
          return true;
        } else if(MarkAttMap[0]["status"].toString()=="false1" && MarkAttMap[0]["imgsts"].toString()=="false"){
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.of(context).pop(true);
                });
                return AlertDialog(
                  content: new Text("Expense already applied on this date"),
                );
              });
          // ignore: deprecated_member_use
          /*showDialog(context: context, child:
        new AlertDialog(
          content: new Text('Expense already applied on this date.'),
        )
        );*/
          setState(() {
            isServiceCalling = false;
          });
        } else {
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.of(context).pop(true);
                });
                return AlertDialog(
                  content: new Text("There is some problem while applying for expense"),
                );
              });
          /*showDialog(context: context, child:
        new AlertDialog(
          content: new Text('There is some problem while applying for expense.'),
        )
        );*/
          setState(() {
            isServiceCalling = false;
          });
        }
      }    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Widget showFile(_file) {
    return FutureBuilder<File>(
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if(_file!=null ) {
          return new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(_file.path.split('/').last,style: TextStyle(fontSize: 13.0, color: Colors.green),
                overflow: TextOverflow.ellipsis, ),
            ]);
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Attachment',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16.0, color: Colors.red),
            textAlign: TextAlign.start,
          );
        } else {
          return const Text(
            'Select Attachment',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16.0, color: Colors.black54),
            textAlign: TextAlign.start,
          );
        }
      },
    );
  }
}




