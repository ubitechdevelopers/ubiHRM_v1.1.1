// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/appbar.dart';
import 'package:ubihrm/drawer.dart';
import 'package:ubihrm/employees_list.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/login_page.dart';
import 'package:ubihrm/profile.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:url_launcher/url_launcher.dart';

class EditEmployee extends StatefulWidget {
  @override
  final String empid;
  final String fname;
  final String lname;
  final String phone;
  final String email;
  final String divisionid;
  final String departmentid;
  final String designationid;
  final String locationid;
  final String shiftid;
  //final String password;
  EditEmployee({Key key, this.empid, this.fname, this.lname, this.phone, this.email, this.divisionid, this.departmentid, this.designationid, this.locationid, this.shiftid/*, this.password*/})
      : super(key: key);
  _EditEmployee createState() => _EditEmployee();
}

class _EditEmployee extends State<EditEmployee> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _firstName = new TextEditingController();
  TextEditingController _lastName = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _contact = new TextEditingController();

  bool isloading = false;
  bool pageload = true;
  bool _obscureText = true;
  bool supervisor = true;
  bool _isButtonDisabled = false;
  bool _checkLoadedprofile = true;

  int adminsts = 0;
  int response = 0;
  int _currentIndex = 2;

  String updatedcontact = '';
  String div = '0', dept = '0', desg = '0', loc = '0', shift = '0';

  bool showtabbar;
  var profileimage;
  String orgName = "";
  String org_country = "";

  @override
  void initState() {
    super.initState();
    div = widget.divisionid;
    print("div"+div);
    dept = widget.departmentid;
    print("dept"+dept);
    desg = widget.designationid;
    print("desg"+desg);
    loc = widget.locationid;
    print("loc"+loc);
    shift = widget.shiftid;
    print("shift"+shift);
    _firstName.text =widget.fname;
    _lastName.text =widget.lname;
    _contact.text = widget.phone;
    _email.text = widget.email;
    profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    response = prefs.getInt('response') ?? 0;
    if (response == 1) {
      setState(() {
        orgName = prefs.getString('orgname') ?? '';
        org_country = prefs.getString('countryid') ?? '';
        adminsts = prefs.getInt('adminsts') ?? 0;
      });
    }
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  Future<bool> move() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => EmployeeList()), (
        Route<dynamic> route) => false,
    );
    return false;
  }

  getmainhomewidget() {
    return WillPopScope(
      onWillPop: () => move(),
      child: Scaffold(
        backgroundColor:scaffoldBackColor(),
        key: _scaffoldKey,
        appBar: new AppHeader(profileimage,showtabbar,orgName),
        endDrawer: new AppDrawer(),
        body: mainbodyWidget(),
      ),
    );
  }

  checkalreadylogin() {
    if (response == 1) {
      return new IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          underdevelopment(),
          mainbodyWidget(),
        ],
      );
    } else {
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  loader() {
    return new Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            //Image.asset('assets/spinner.gif', height: 30.0, width: 30.0),
            CircularProgressIndicator()
          ]
        )
      ),
    );
  }

  underdevelopment() {
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.android,
                color: appStartColor(),
              ),
              Text(
                "Under development",
                style: new TextStyle(fontSize: 30.0, color: appStartColor()),
              )
            ]),
      ),
    );
  }

  mainbodyWidget() {
    if (pageload == true) loader();
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      decoration: new ShapeDecoration(
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
        color: Colors.white,
      ),
      child: Center(
        child: Form(
          key: _formKey,
          child: SafeArea(
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0.0,bottom: 10.0),
                  child: Center(
                    child:Text("Edit Employee",style: new TextStyle(fontSize: 22.0,color:appStartColor())),
                  ),
                ),
                new Expanded(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:10.0,right:10.0,top:10.0),
                        child: TextFormField(
                          controller: _firstName,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          //initialValue: _firstName.text,
                          decoration: InputDecoration(
                            //isDense: true,
                            border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                            labelText: "First Name",
                            hintText: "First Name",
                            hintStyle: TextStyle(
                                fontSize: 14.0),
                            prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black54,
                          ),
                          ),
                          validator: (value) {
                            if (value.trim().isEmpty || value.isEmpty || value=="") {
                              return 'Please enter first name';
                            }
                          },
                          onFieldSubmitted: (String value) {
                            _firstName.text=value;
                            if (_formKey.currentState.validate()) {}
                          },
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.only(left:10.0,right:10.0),
                        child: TextFormField(
                          controller: _lastName,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          //initialValue: _firstName.text,
                          decoration: InputDecoration(
                            //isDense: true,
                            border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                            labelText: "Last Name",
                            hintText: "Last Name",
                            hintStyle: TextStyle(
                                fontSize: 14.0),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black54,
                            ),
                          ),
                          validator: (value) {
                            if (value.trim().isEmpty || value.isEmpty || value=="") {
                              return 'Please enter last name';
                            }
                          },
                          onFieldSubmitted: (String value) {
                            _lastName.text=value;
                            if (_formKey.currentState.validate()) {}
                          },
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                        child: TextFormField(
                          controller: _contact,
                          // initialValue: widget.phone,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            //isDense: true,
                            border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                            labelText: "Phone",
                            hintText: "Phone",
                            hintStyle: TextStyle(
                                fontSize: 14.0),
                              prefixIcon: Icon(
                              Icons.call,
                              color: Colors.black54,
                              size: 25,
                            )
                          ),
                          validator: (value) {
                            if (value.isEmpty ||
                                value.length < 6 ||
                                value.length > 15) {
                              return 'Please Enter valid Contact';
                            }
                          },
                          onFieldSubmitted: (String value) {
                            _contact.text=value;
                            if (_formKey.currentState.validate()) {}
                          },
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                        child: TextFormField(
                          controller: _email,
                          // initialValue: widget.email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            //isDense: true,
                            border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                            labelText: "Email",
                            hintText: "Email",
                            hintStyle: TextStyle(
                                fontSize: 14.0),
                              prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black54,
                              size: 25,
                            )
                          ),
                          validator: (value) {
                            Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            if (value.isNotEmpty && !regex.hasMatch(value)) {
                              return 'Enter valid email id';
                            }
                          },
                          onFieldSubmitted: (String value) {
                            _email.text=value;
                            if (_formKey.currentState.validate()) {}
                          }
                        ),
                      ),
                      getDivisions_DD(),
                      getDepartments_DD(),
                      getDesignations_DD(),
                      getLocations_DD(),
                      getShifts_DD(),
                      SizedBox(height: 40,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ButtonBar(
                            children: <Widget>[
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: _isButtonDisabled
                                    ? Text(
                                  'Processing..',
                                  style: TextStyle(color: Colors.white),
                                )
                                    : Text(
                                  'UPDATE',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.orange[800],
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    /*if (_firstName.text=="" || _firstName.text.trim().isEmpty) {
                                      showDialog(context: context, child:
                                      new AlertDialog(
                                        content: new Text("Please enter first name"),
                                      ));
                                      return null;
                                    }else if (_lastName.text=="" || _lastName.text.trim().isEmpty) {
                                      showDialog(context: context, child:
                                      new AlertDialog(
                                        content: new Text("Please enter last name"),
                                      ));
                                      return null;
                                    }else if (_contact.text=="" || _contact.text.trim().isEmpty) {
                                      showDialog(context: context, child:
                                      new AlertDialog(
                                        content: new Text("Please enter contact no."),
                                      ));
                                      if(_contact.text.isNotEmpty && (_contact.text.length<6 || _contact.text.length>15))
                                        showDialog(context: context, child:
                                        new AlertDialog(
                                          content: new Text("Please enter valid contact no."),
                                        ));
                                      return null;
                                    }else if(_email.text!="" && !(validateEmail(_email.text.trim()))) {
                                        showDialog(context: context, child:
                                        new AlertDialog(
                                          content: new Text("Please enter valid Email ID"),
                                        ));
                                        return null;
                                    }else*/if (div == '0') {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          Future.delayed(Duration(seconds: 3), () {
                                            Navigator.of(context).pop(true);
                                          });
                                          return AlertDialog(
                                            content: new Text("Please select the division"),
                                          );
                                        });
                                      /*showDialog(context: context, child:
                                      new AlertDialog(
                                        content: new Text("Please select the division"),
                                      ));*/
                                      return null;
                                    }else if (dept == '0') {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          Future.delayed(Duration(seconds: 3), () {
                                            Navigator.of(context).pop(true);
                                          });
                                          return AlertDialog(
                                            content: new Text("Please select the department"),
                                          );
                                        });
                                      /*showDialog(context: context, child:
                                      new AlertDialog(
                                        content: new Text("Please select the department"),
                                      ));*/
                                      return null;
                                    }else if (desg == '0') {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          Future.delayed(Duration(seconds: 3), () {
                                            Navigator.of(context).pop(true);
                                          });
                                          return AlertDialog(
                                            content: new Text("Please select the designation"),
                                          );
                                        });
                                      /*showDialog(context: context, child:
                                      new AlertDialog(
                                        content: new Text("Please select the designation"),
                                      ));*/
                                      return null;
                                    }else if (shift == '0') {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          Future.delayed(Duration(seconds: 3), () {
                                            Navigator.of(context).pop(true);
                                          });
                                          return AlertDialog(
                                            content: new Text("Please select the shift"),
                                          );
                                        });
                                      /*showDialog(context: context, child:
                                      new AlertDialog(
                                        content: new Text("Please select the shift"),
                                      ));*/
                                      return null;
                                    }

                                    if (_isButtonDisabled) return null;
                                    setState(() {
                                      _isButtonDisabled = true;
                                    });
                                    updatedcontact=_contact.text.trim();
                                    print(org_country);
                                    print('org_country');
                                    if(org_country=='93') {
                                      updatedcontact =
                                          updatedcontact = updatedcontact.replaceAll('+91', '');
                                    }
                                    updatedcontact = updatedcontact.replaceAll('+', '');
                                    updatedcontact = updatedcontact.replaceAll('-', '');
                                    updatedcontact = updatedcontact.replaceAll(' ', '');
                                    // prevented by parth sir
                                    editEmployee(_firstName.text.trim(), _lastName.text.trim(), _email.text.trim(), updatedcontact.trim(), div, dept, desg, loc, shift, widget.empid).then((res) {
                                      if (res == 1) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EmployeeList()),
                                        );
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 3), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              content: new Text("Employee details update successfully"),
                                            );
                                          });
                                        /*showDialog(
                                            context: context,
                                            child: new AlertDialog(
                                              content: new Text("Employee details update successfully."),
                                            ));*/
                                      } else if (res == 3)
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 3), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              content: new Text("Contact already exists"),
                                            );
                                          });
                                        /*showDialog(context: context, child:
                                        new AlertDialog(
                                          content: new Text("Contact already exists"),
                                        ));*/
                                      else if (res == 2)
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 3), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              content: new Text("Email ID already exists"),
                                            );
                                          });
                                        /*showDialog(context: context, child:
                                        new AlertDialog(
                                          content: new Text("Email ID already exists"),
                                        ));*/
                                      else
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 3), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              content: new Text("Unable to update employee record"),
                                            );
                                        });
                                        /*showDialog(context: context, child:
                                        new AlertDialog(
                                        content: new Text("Unable to update employee record"),
                                        ));*/
                                      setState(() {
                                        _isButtonDisabled = false;
                                      });
                                      // TimeOfDay.fromDateTime(10000);
                                    }).catchError((exp) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          Future.delayed(Duration(seconds: 3), () {
                                            Navigator.of(context).pop(true);
                                          });
                                          return AlertDialog(
                                            content: new Text("Unable to call service"),
                                          );
                                        });
                                      /*showDialog(context: context, child:
                                      new AlertDialog(
                                        content: new Text("Unable to call service"),
                                      ));*/
                                      print(exp.toString());
                                      setState(() {
                                        _isButtonDisabled = false;
                                      });
                                    });
                                  }
                                },
                              ),
                              SizedBox(width: 10.0),
                              FlatButton(
                                shape: Border.all(color: Colors.orange[800]),
                                child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
                                onPressed: () {
                                  //Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => EmployeeList()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]
            )
          ),
        ),
      ),
    );
  }

  ///////////////////////common dropdowns/////////////////////
  Widget getDivisions_DD() {
    return new FutureBuilder<List<Map>>(
      future: getDivisionsList(0), //with -select- label
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                child: new Container(
                 // width: MediaQuery.of(context).size.width * .9,
                  // width: MediaQuery.of(context).size.width*.45,
                  child: InputDecorator(
                    decoration: InputDecoration(
                     // isDense: true,
                      border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                      labelText: "Division",
                      hintText: "Division",
                      hintStyle: TextStyle(
                          fontSize: 14.0),
                        prefixIcon: Icon(
                        Icons.home_work_outlined,
                        color: Colors.black54,
                        size: 25,
                      )
                    ),
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        child: new DropdownButton<String>(
                          isDense: true,
                          style: new TextStyle(fontSize: 15.0, color: Colors.black),
                          value: div,
                          onChanged: (String newValue) {
                            setState(() {
                              div = newValue;
                              print("div");
                              print(div);
                            });
                          },
                          items: snapshot.data.map((Map map) {
                            return new DropdownMenuItem<String>(
                              value: map["Id"].toString(),
                              child: new SizedBox(
                                width: 200,
                                  child: new Text(
                                    map["Name"],
                                  )),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }
        // return loader();
        return new Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
            ),
            height: 20.0,
            width: 20.0,
          ),
        );
      }
    );
  }

  Widget getDepartments_DD() {
    return new FutureBuilder<List<Map>>(
      future: getDepartmentsList(0), //with -select- label
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                child: new Container(
                 // width: MediaQuery.of(context).size.width * .9,
                  // width: MediaQuery.of(context).size.width*.45,
                  child: InputDecorator(
                    decoration: InputDecoration(
                     // isDense: true,
                      border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                      labelText: "Department",
                      hintText: "Department",
                      hintStyle: TextStyle(
                          fontSize: 14.0),
                      prefixIcon: Icon(
                        const IconData(0xe803, fontFamily: "CustomIcon"),
                        color: Colors.black54,
                        size: 25,
                      )
                    ),
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        child: new DropdownButton<String>(
                          isDense: true,
                          style: new TextStyle(fontSize: 15.0, color: Colors.black),
                          value: dept,
                          onChanged: (String newValue) {
                            setState(() {
                              dept = newValue;
                              print("dept");
                              print(dept);
                            });
                          },
                          items: snapshot.data.map((Map map) {
                            return new DropdownMenuItem<String>(
                              value: map["Id"].toString(),
                              child: new SizedBox(
                                width: 200,
                                  child: new Text(
                                    map["Name"],
                                  )),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }
        // return loader();
        return new Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
            ),
            height: 20.0,
            width: 20.0,
          ),
        );
      }
    );
  }

  Widget getDesignations_DD() {
    return new FutureBuilder<List<Map>>(
      future: getDesignationsList(0),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                child: new Container(
                  //width: MediaQuery.of(context).size.width * .9,
                  // width: MediaQuery.of(context).size.width*.45,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      //isDense: true,
                      border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                      labelText: "Designation",
                      hintText: "Designation",
                      hintStyle: TextStyle(
                          fontSize: 14.0),
                      prefixIcon: Icon(
                        const IconData(0xe804, fontFamily: "CustomIcon"),
                        color: Colors.black54,
                        size: 25
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        child: new DropdownButton<String>(
                          isDense: true,
                          style: new TextStyle(fontSize: 15.0, color: Colors.black),
                          value: desg,
                          onChanged: (String newValue) {
                            setState(() {
                              desg = newValue;
                            });
                          },
                          items: snapshot.data.map((Map map) {
                            return new DropdownMenuItem<String>(
                              value: map["Id"].toString(),
                              child: new SizedBox(
                                width: 200.0,
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
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }
        // return loader();
        return new Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
            ),
            height: 20.0,
            width: 20.0,
          ),
        );
      }
    );
  }

  Widget getLocations_DD() {
    return new FutureBuilder<List<Map>>(
      future: getLocationsList(0),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                child: new Container(
                  //width: MediaQuery.of(context).size.width * .9,
                  // width: MediaQuery.of(context).size.width*.45,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      //isDense: true,
                      border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                      labelText: "Location",
                      hintText: "Location",
                      hintStyle: TextStyle(
                          fontSize: 14.0),
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                        color: Colors.black54,
                        size: 25
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        child: new DropdownButton<String>(
                          isDense: true,
                          style: new TextStyle(fontSize: 15.0, color: Colors.black),
                          value: loc,
                          onChanged: (String newValue) {
                            setState(() {
                              loc = newValue;
                            });
                          },
                          items: snapshot.data.map((Map map) {
                            return new DropdownMenuItem<String>(
                              value: map["Id"].toString(),
                              child: new SizedBox(
                                width: 200.0,
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
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }
        // return loader();
        return new Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
            ),
            height: 20.0,
            width: 20.0,
          ),
        );
      }
    );
  }

  Widget getShifts_DD() {
    return new FutureBuilder<List<Map>>(
      future: getShiftsList(0),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(left:10.0, right:10.0),
                child: new Container(
                  //width: MediaQuery.of(context).size.width * .9,
                  //width: MediaQuery.of(context).size.width*.45,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      //isDense: true,
                      border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                      //border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.access_alarm,
                        color: Colors.black54,
                        size: 25,
                      ),
                      labelText: "Shift",
                      hintText: "Shift",
                      hintStyle: TextStyle(
                          fontSize: 14.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        child: new DropdownButton<String>(
                          isDense: true,
                          style: new TextStyle(fontSize: 15.0, color: Colors.black),
                          value: shift,
                          onChanged: (String newValue) {
                            setState(() {
                              shift = newValue;
                            });
                          },
                          items: snapshot.data.map((Map map) {
                            return new DropdownMenuItem<String>(
                              value: map["Id"].toString(),
                              child: new SizedBox(
                                  width: 200.0,
                                  child: new Text(
                                    map["Name"],
                                  )),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }
        // return loader();
        return new Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
            ),
            height: 20.0,
            width: 20.0,
          ),
        );
      }
    );
  }

  openWhatsApp(msg, number) async {
    var url = "https://wa.me/" + number + "?text=" + msg;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Maps';
    }
  }

  dialogwidget(msg, number) {
    showDialog(context: context,
      child: new AlertDialog(
        content: new Text('Do you want to notify user?'),
        actions: <Widget>[
          FlatButton(
            child: Text('Close'),
            shape: Border.all(),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          RaisedButton(
            child: Text(
              'Notify user',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.amber,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              openWhatsApp(msg, number);
            },
          ),
        ],
      )
    );
  }

}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return false;
  else
    return true;
}