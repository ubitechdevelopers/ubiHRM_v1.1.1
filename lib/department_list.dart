import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/appbar.dart';
import 'drawer.dart';

class Department extends StatefulWidget {
  @override
  _Department createState() => _Department();
}

class _Department extends State<Department> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _sts = 'Active';
  String _sts1 = 'Active';
  String orgName="";
  int hrsts=0;
  int adminsts=0;
  int divhrsts=0;
  bool _isButtonDisabled= false;
  TextEditingController _searchController;
  FocusNode searchFocusNode;
  String deptname = "";
  var profileimage;
  bool showtabbar;

  @override
  void initState() {
    super.initState();
    _searchController = new TextEditingController();
    searchFocusNode = FocusNode();
    profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);
    getOrgName();
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
      hrsts =prefs.getInt('hrsts')??0;
      adminsts =prefs.getInt('adminsts')??0;
      divhrsts =prefs.getInt('divhrsts')??0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  /*void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value, textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }*/

  getmainhomewidget() {
    return RefreshIndicator(
      child: new Scaffold(
        backgroundColor: scaffoldBackColor(),
        key: _scaffoldKey,
        appBar: AppHeader(profileimage,showtabbar,orgName),
        bottomNavigationBar: new HomeNavigation(),
        endDrawer: new AppDrawer(),
        body: Container(
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          decoration: new ShapeDecoration(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            color: Colors.white,
          ),

          child: Column(
            children: <Widget>[
              Center(
                child: Text('Departments',
                  style: new TextStyle(fontSize: 22.0, color: appStartColor(),),),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _searchController,
                    focusNode: searchFocusNode,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius:  new BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(Icons.search, size: 30,),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Search Department',
                      //labelText: 'Search Department',
                      suffixIcon: _searchController.text.isNotEmpty?IconButton(icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Department()),
                            );
                          }
                      ):null,
                      //focusColor: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        deptname = value;
                      });
                    },
                  ),
                ),
              ),
              //Divider(),
              //Divider(height: 10.0,),
              //SizedBox(height: 5.0),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:15.0),
                      child: Container(
                        //width: MediaQuery.of(context).size.width*0.65,
                        child: Text('Departments', style: TextStyle(
                            color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                      ),
                    ),
                    /*SizedBox(
                      width: 5,
                    ),*/
                    Padding(
                      padding: const EdgeInsets.only(right:30.0),
                      child: Container(
                        child: Text('Status', style: TextStyle(
                            color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              new Expanded(
                child: getDeptWidget(),
              ),
            ],
          ),
        ),
        floatingActionButton: (adminsts==1||hrsts==1||divhrsts==1)?new FloatingActionButton(
          backgroundColor: Colors.orange[800],
          onPressed: (){
            showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.of(context).pop(true);
                });
                return AlertDialog(
                  content: new Text("To Add a new Department, login to the web panel"),
                );
              });
          },
          tooltip: 'Add Department',
          child: new Icon(Icons.add),
        ):Center(),
      ),
      onRefresh: () async {
        Completer<Null> completer = new Completer<Null>();
        await Future.delayed(Duration(seconds: 1)).then((onvalue) {
          setState(() {
            _searchController.clear();
            deptname='';
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          });
          completer.complete();
        });
        return completer.future;
      },
    );
  }

  getDeptWidget() {
    return new FutureBuilder<List<Dept>>(
        future: getDepartments(deptname),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return new ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Column(
                        children: <Widget>[
                          new FlatButton(
                            child: new Row(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  width: MediaQuery.of(context).size.width*0.65,
                                  child: new Text(
                                      snapshot.data[index].dept.toString(),style: TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                new Container(
                                  child: new Text(
                                    snapshot.data[index].status.toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: snapshot.data[index].status
                                            .toString() != 'Active' ? Colors
                                            .red : Colors.green),),
                                ),
                              ],
                            ),
                            onPressed: () {
                              //null;
                              editDept(context, snapshot.data[index].dept
                                  .toString(), snapshot.data[index].status
                                  .toString(), snapshot.data[index].id
                                  .toString());
                            },),
                        ]
                    );
                  }
              );
            }else{
              return new Center(
                child: Container(
                  width: MediaQuery.of(context).size.width*1,
                  color: appStartColor().withOpacity(0.1),
                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                  child:Text("No department found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Center(child: new Text("Unable to connect server"));
          }
          return new Center(child: CircularProgressIndicator());
        }
    );
  }

//////////edit department
  editDept(context,dept,sts,did) async {
    _sts1=sts;
    var new_dept = new TextEditingController();
    new_dept.text=dept;
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.all(15.0),
        content: Container(
          height: MediaQuery.of(context).size.height*0.23,
          width: MediaQuery.of(context).size.width*0.32,
          child: Column(
            children: <Widget>[
              SizedBox(height: 15.0),
              new Expanded(
                child: new TextField(
                  enabled: false,
                  controller: new_dept,
                  autofocus: false,
                  decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                      ),
                      labelText: 'Department', hintText: 'Department Name'),
                ),
              ),
              SizedBox(height: 5.0),
              new Expanded(
                child:  new InputDecorator(
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                    ),
                    labelText: 'Status',
                  ),
                  isEmpty: _sts1 == '',
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      value: _sts1,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          _sts1 = newValue;
                          Navigator.of(context, rootNavigator: true).pop('dialog'); // here I pop to avoid multiple Dialogs
                          //print("this is set state"+_sts1);
                          editDept(context, dept, _sts1, did);
                        });
                      },
                      items: <String>['Active', 'Inactive'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: new RaisedButton(
              color: Colors.orange[800],
              child: const Text('UPDATE',style: TextStyle(color: Colors.white),),
              onPressed: () {
                if( new_dept.text.trim()==''){
                  //showInSnackBar('Enter Department Name');
                  showDialog(
                    context: context,
                    builder: (context) {
                      Future.delayed(Duration(seconds: 3), () {
                        Navigator.of(context).pop(true);
                      });
                      return AlertDialog(
                        content: new Text("Please enter the Department's name"),
                      );
                    });
                  /*showDialog(context: context, child:
                  new AlertDialog(
                    content: new Text("Enter department name"),
                  ));*/
                } else {
                  if(_isButtonDisabled)
                    return null;
                  setState(() {
                    _isButtonDisabled=true;
                  });
                  updateDept(new_dept.text,_sts1,did).
                  then((res) {
                    if(res=='0') {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(Duration(seconds: 3), () {
                            Navigator.of(context).pop(true);
                          });
                          return AlertDialog(
                            content: new Text("Unable to update department"),
                          );
                        });
                      //showInSnackBar('Unable to update department');
                      /*showDialog(context: context, child:
                      new AlertDialog(
                        content: new Text("Unable to update department"),
                      ));*/
                    }else if(res=='-1') {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(Duration(seconds: 3), () {
                            Navigator.of(context).pop(true);
                          });
                          return AlertDialog(
                            content: new Text("This department already exists"),
                          );
                        });
                      //showInSnackBar('Department name already exist');
                      /*showDialog(context: context, child:
                      new AlertDialog(
                        content: new Text("Department name already exist"),
                      ));*/
                    }else if(res=='2') {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(Duration(seconds: 3), () {
                            Navigator.of(context).pop(true);
                          });
                          return AlertDialog(
                            content: new Text("This department can't be updated. Employees are already assigned to it"),
                          );
                        });
                      //showInSnackBar('Department name already exist');
                      /*showDialog(context: context, child:
                      new AlertDialog(
                        content: new Text("Employees assigned to this department therefore can't be updated"),
                      ));*/
                    }else {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(Duration(seconds: 3), () {
                            Navigator.of(context).pop(true);
                          });
                          return AlertDialog(
                            content: new Text("Department is updated successfully"),
                          );
                        });
                      //showInSnackBar('Department updated successfully');
                      /*showDialog(context: context, child:
                      new AlertDialog(
                      content: new Text("Department updated successfully"),
                      ));*/
                      getDeptWidget();
                      new_dept.text = '';
                      _sts1 = 'Active';
                    }
                    setState(() {
                      _isButtonDisabled=false;
                    });
                  });
                }
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: new FlatButton(
                shape: Border.all(color: Colors.orange[800]),
                child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                }),
          ),
        ],
      ),
    );
  }
//////////edit department-end

}/////////mail class close
