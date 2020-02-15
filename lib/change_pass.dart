// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/drawer.dart';
import 'package:ubihrm/services/attandance_services.dart';

import 'appbar.dart';
import 'b_navigationbar.dart';
import 'global.dart';



class changePassword extends StatefulWidget {
  @override
  _changePassword createState() => _changePassword();
}
class _changePassword extends State<changePassword> {
  bool isloading = false;
  final _oldPass = TextEditingController();
  final _newPass = TextEditingController();
  FocusNode __oldPass = new FocusNode();
  FocusNode __newPass = new FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText_old = true;
  bool _obscureText_new = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int response=0;
  int _currentIndex = 2;
  String org_name="";
  String admin_sts="0";
  var profileimage;
  bool showtabbar;
  String orgName="";

  @override
  void initState() {
    super.initState();
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    showtabbar=false;
  //  initPlatformState();
    getOrgName();
  }
  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  /*initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    response = prefs.getInt('response') ?? 0;
    admin_sts = prefs.getString('sstatus') ?? '0';
    if(response==1) {
      Home ho = new Home();
      setState(() {
        org_name = prefs.getString('org_name') ?? '';
      });
    }
  }*/


  void _toggle_old() {
    setState(() {
      _obscureText_old = !_obscureText_old;
    });
  }
  void _toggle_new() {
    setState(() {
      _obscureText_new = !_obscureText_new;
    });
  }

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  getmainhomewidget(){
    return Scaffold(
      backgroundColor:scaffoldBackColor(),
      key: _scaffoldKey,
      appBar:  new AppHeader(profileimage,showtabbar,orgName),
      bottomNavigationBar: new HomeNavigation(),
      endDrawer: new AppDrawer(),
      body:  mainbodyWidget(),
    );

  }
  checkalreadylogin(){
    if(response==1) {
      return new IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          underdevelopment(),
          underdevelopment(),
          mainbodyWidget(),
        ],
      );
    }else{
      /* Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );*/
    }
  }
  loader(){
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset(
                  'assets/spinner.gif', height: 80.0, width: 80.0),
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

  mainbodyWidget(){
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      //width: MediaQuery.of(context).size.width*0.9,
      //      height:MediaQuery.of(context).size.height*0.75,
      decoration: new ShapeDecoration(
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
        color: Colors.white,
      ),
      child: Form(
        key: _formKey,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //SizedBox(height: 20.0),
                  Center(
                    child:Text("Change Password",style: new TextStyle(fontSize: 22.0,color: appStartColor())),
                  ),
                  Divider(height: 10.0,),
                  SizedBox(height: 30.0),
                  Container(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width*.7,
                              child: TextFormField(
                                controller: _oldPass,
                                onFieldSubmitted: (String value) {
                                  FocusScope.of(context).requestFocus(__newPass);
                                },
                                keyboardType: TextInputType.text,
                                obscureText: _obscureText_old,
                                decoration: InputDecoration(
                                    labelText: 'Old Password',
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Icon(
                                        Icons.lock,
                                        color: Colors.grey,
                                      ), // icon is 48px widget.
                                    )
                                ),
                                validator: (value) {
                                  if (value.isEmpty || value==null) {
//                                  FocusScope.of(context).requestFocus(__oldPass);
                                    return 'Please enter old password';
                                  }
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width*.1,
                            child: FlatButton(
                              padding: EdgeInsets.only(right:10.0),
                              child: Icon(
                                _obscureText_old ?Icons.visibility_off:Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: _toggle_old,
                            ),
                          ),
                        ],
                      )
                  ), //Enter date
                  SizedBox(height: 12.0),
                  Container(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                           child:Container(
                            width: MediaQuery.of(context).size.width*.7,
                            child: TextFormField(
                              controller: _newPass,
                              focusNode: __newPass,
                              keyboardType: TextInputType.text,
                              obscureText: _obscureText_new,

                              decoration: InputDecoration(
                                  labelText: 'New Password',
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.grey,
                                    ), // icon is 48px widget.
                                  )
                              ),
                              validator: (value) {
                                if (value.isEmpty || value==null || value.length<6 ) {
                                  __oldPass.notifyListeners();
                                  //                                 FocusScope.of(context).requestFocus(__newPass);
                                  return 'Password must be at least 6 characters';
                                }
                              },
                            ),
                          ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width*.1,
                            child: FlatButton(
                              padding: EdgeInsets.only(right:10.0),
                              child: Icon(
                                _obscureText_new ?Icons.visibility_off:Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: _toggle_new,
                            ),
                          ),
                        ],
                      )
                  ),

                  ButtonBar(
                    children: <Widget>[
                      RaisedButton(
                        child: Text('SUBMIT',style: TextStyle(color: Colors.white),),
                        color: Colors.orange[800],
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if (_oldPass.text == _newPass.text) {
                              //showInSnackBar("New password can't same as old");
                              // ignore: deprecated_member_use
                              showDialog(context: context, child:
                              new AlertDialog(
                                // title: new Text("Sorry!"),
                                content: new Text("New password can't same as old"),
                              )
                              );
                              FocusScope.of(context).requestFocus(__newPass);
                            } else {
                              changeMyPassword(_oldPass.text, _newPass.text).then((res){
                                if(res==1) {
                                  _newPass.text='';
                                  _oldPass.text='';

                                  //showInSnackBar("Password changed successfully");
                                  // ignore: deprecated_member_use
                                  showDialog(context: context, child:
                                  new AlertDialog(
                                    // title: new Text("Sorry!"),
                                    content: new Text("Password changed successfully"),
                                  )
                                  );
                                }
                                else if(res==2)
                                  //showInSnackBar("Old Password did not match");
                                  // ignore: deprecated_member_use
                                  showDialog(context: context, child:
                                  new AlertDialog(
                                    // title: new Text("Sorry!"),
                                    content: new Text("Old password did not match"),
                                  )
                                  );
                                else if(res==3)
                                  //showInSnackBar("New password can't be the same as old password");
                                  // ignore: deprecated_member_use
                                  showDialog(context: context, child:
                                  new AlertDialog(
                                  // title: new Text("Sorry!"),
                                  content: new Text("New password can't be the same as old password"),
                                  )
                                  );
                                else
                                  //showInSnackBar("Unable to set password "+res.toString());
                                  // ignore: deprecated_member_use
                                  showDialog(context: context, child:
                                  new AlertDialog(
                                    // title: new Text("Sorry!"),
                                    content: new Text("Unable to set password "+res.toString()),
                                  )
                                  );
                              }).catchError((onError){
                                //showInSnackBar("Unable to connect server");
                                // ignore: deprecated_member_use
                                showDialog(context: context, child:
                                new AlertDialog(
                                  // title: new Text("Sorry!"),
                                  content: new Text("Unable to connect server"),
                                )
                                );
                                print(onError);
                              });
                            }
                          }
                        },
                      ),
                      FlatButton(
                        shape: Border.all(color: Colors.orange[800]),
                        child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}