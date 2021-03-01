import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/appbar.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/services/attandance_services.dart';
import '../drawer.dart';

class Designation extends StatefulWidget {
  @override
  _Designation createState() => _Designation();
}

class _Designation extends State<Designation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _desgFormKey = GlobalKey<FormState>();
  String _sts1 = 'Active';
  String orgName="";
  String uid="";
  String orgid="";
  String desgCode = "";
  int hrsts=0;
  int adminsts=0;
  int divhrsts=0;
  bool _isButtonDisabled= false;
  bool _isServiceCalling= false;
  TextEditingController _desgCode = new TextEditingController();
  TextEditingController _desgName = new TextEditingController();
  TextEditingController _searchController;
  FocusNode searchFocusNode;
  String desgname = "";
  var profileimage;
  bool showtabbar;
  String desg='0';

  TextStyle _hintStyle = TextStyle(
      color: Colors.black45
  );


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
      uid = prefs.getString("employeeid")??"";
      orgid = prefs.getString("organization")??"";
    });
  }

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

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
                child: Text('Designations',
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
                      hintText: 'Search Designation',
                      //labelText: 'Search Designation',
                      suffixIcon: _searchController.text.isNotEmpty?IconButton(icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Designation()),
                            );
                          }
                      ):null,
                      //focusColor: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        desgname = value;
                      });
                    },
                  ),
                ),
              ),
              //Divider(),
              //SizedBox(height: 5.0),
              Container(
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.65,
                        child: Text('Designations', style: TextStyle(
                            color: appStartColor(),fontSize: 16.0, fontWeight: FontWeight.bold ),),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:20.0),
                      child: Container(
                        child: Text('Status', style: TextStyle(
                            color: appStartColor(),fontSize: 16.0, fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              //SizedBox(height: 5.0),
              new Expanded(
                child: getDesgWidget(),
              ),
            ],
          ),
        ),
        floatingActionButton: (adminsts==1||hrsts==1||divhrsts==1)?new FloatingActionButton(
          backgroundColor: Colors.orange[800],
          onPressed: (){
            _desgCode = new TextEditingController();
            _desgName = new TextEditingController();
            getDesgCode().then((res) {
              setState(() {
                desgCode = res;
                print("desgCode");
                print(desgCode);
                _desgCode.text=desgCode;
              });
            });
            _showDialogDesg(context);
            /*showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.of(context).pop(true);
                });
                return AlertDialog(
                  content: new Text("To Add a new Designation, login to the web panel"),
                );
              });*/
          },
          tooltip: 'Add Designation',
          child: new Icon(Icons.add),
        ):Center(),
      ),
      onRefresh: () async {
        Completer<Null> completer = new Completer<Null>();
        await Future.delayed(Duration(seconds: 1)).then((onvalue) {
          setState(() {
            _searchController.clear();
            desgname='';
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

  getDesgWidget() {
    return new FutureBuilder<List<Desg>>(
      future: getDesignation(desgname),
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
                                      snapshot.data[index].desg.toString(),style: TextStyle(
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
                              editDesg(context, snapshot.data[index].desg
                                  .toString(), snapshot.data[index].status
                                  .toString(), snapshot.data[index].id
                                  .toString());
                            }

                        ),
                        //Divider(),
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
                child:Text("No designation found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
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
  editDesg(BuildContext context,String dept,String sts,String did) async {
    var new_desg = new TextEditingController();
    new_desg.text=dept;
    _sts1=sts;
    await showDialog<String>(
      context: context,
      // ignore: deprecated_member_use
      child: new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.all(15.0),
        content: Container(
          height: MediaQuery.of(context).size.height*0.20,
          child: Column(
            children: <Widget>[
              Center(
                child:Text("Update Designation",style: new TextStyle(fontSize: 22.0,color:appStartColor())),
              ),
              SizedBox(height: 15.0),
              new Expanded(
                child: new TextFormField(
                  enabled: false,
                  controller: new_desg,
                  autofocus: false,
                  decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                      ),
                      labelText: 'Designation', hintText: 'Designation Name'),
                  validator: (value) {
                    if (new_desg.text.trim().isEmpty || new_desg.text.isEmpty) {
                      return 'Please enter designation name';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10.0),
              new DropdownButtonHideUnderline(
                child: new DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                    ),
                    labelText: 'Status',
                  ),
                  value: _sts1,
                  isDense: true,
                  onChanged: (String newValue) {
                    setState(() {
                      _sts1 = newValue;
                      Navigator.of(context, rootNavigator: true).pop('dialog'); // here I pop to avoid multiple Dialogs
                      //print("this is set state"+_sts1);
                      editDesg(context, dept, _sts1, did);
                      _isButtonDisabled = true;
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
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: new RaisedButton(
              color: Colors.orange[800],
                child: _isServiceCalling?Text("Updating..",
                  style: TextStyle(color: Colors.white),
                ):Text("UPDATE",
                  style: TextStyle(color: Colors.white),
                ),
              onPressed: (){
                if (_isButtonDisabled == false)
                  return showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          content: new Text("No changes found"),
                        );
                      });
                setState(() {
                  _isServiceCalling = true;
                  _isButtonDisabled = true;
                });
                updateDesg(new_desg.text,_sts1,did).then((res) {
                  if(res=='1') {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          content: new Text("Designation is updated successfully"),
                        );
                      });
                    getDesgWidget();
                    new_desg.text = '';
                    _sts1 = 'Active';
                  }else if(res=='2') {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          content: new Text("This designation can't be updated. Employees are already assigned to it."),
                        );
                      });
                  }else if(res=='3') {
                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(Duration(seconds: 3), () {
                            Navigator.of(context).pop(true);
                          });
                          return AlertDialog(
                            content: new Text("This Designation can't be updated. Only designation found"),
                          );
                        });
                  }else{
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          content: new Text("Unable to update designation"),
                        );
                      });
                  }
                  setState(() {
                    _isServiceCalling=false;
                    _isButtonDisabled=false;
                  });
                });
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

  _showDialogDesg(BuildContext context) async {
    await showDialog<String>(
      barrierDismissible: false,
      context: context,
      child: new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.all(15.0),
        content: Form(
          key: _desgFormKey,
          child: Container(
            //height: MediaQuery.of(context).size.height*0.20,
            //width: MediaQuery.of(context).size.width*0.35,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //SizedBox(height: 5.0),
                Center(
                  child:Text("Add Designation",style: new TextStyle(fontSize: 22.0,color:appStartColor())),
                ),
                SizedBox(height: 15.0),
                new TextFormField(
                  //enabled: false,
                  autofocus: false,
                  controller: _desgCode,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(),
                      ),
                      //labelText: 'Designation Code',
                      hintText: 'Designation Code',
                      hintStyle: _hintStyle
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty || value.isEmpty || value=="") {
                      return 'Please enter department code';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                new TextFormField(
                  autofocus: false,
                  controller: _desgName,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(),
                      ),
                      //labelText: 'Designation Name',
                      hintText: 'Designation Name',
                      hintStyle: _hintStyle
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty || value.isEmpty || value=="") {
                      return 'Please enter designation name';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: _isServiceCalling
                ? Text('Adding..',
              style: TextStyle(color: Colors.white),
            ) : Text('ADD',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.orange[800],
            onPressed: () {
              if (_desgFormKey.currentState.validate()) {
                setState(() {
                  _isServiceCalling = true;
                  _isButtonDisabled = true;
                });
                var url = path + "addDesignation";
                http.post(url, body: {
                  "uid": uid,
                  "orgid": orgid,
                  "code": _desgCode.text.trim(),
                  "name": _desgName.text.trim(),
                }).then((response) {
                  print(path + 'addDesignation?uid=$uid&orgid=$orgid&code=${_desgCode.text}&name=${_desgName.text}');
                  print(response.body.toString());
                  if (response.statusCode == 200) {
                    Map data = json.decode(response.body);
                    print(response.body.toString());
                    print(data["sts"]);
                    if (data["sts"].contains("true")) {
                      desgid = data["desgid"];
                      desg = desgid;
                      Navigator.of(context, rootNavigator: true).pop();
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("Designation added successfully"),
                            );
                          });
                    } else if (data["sts"].contains("alreadyexists")) {
                      desgid = data["desgid"];
                      desg = desgid;
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("Designation Code or Name already exists"),
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("There is some problem while adding Designation"),
                            );
                          });
                    }
                    setState(() {
                      _isServiceCalling = false;
                      _isButtonDisabled = false;
                    });
                  }
                });
              }
            },
          ),
          //SizedBox(width: 10.0),
          FlatButton(
            shape: Border.all(color: Colors.orange[800]),
            child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
            onPressed: () {
              _desgCode.clear();
              _desgName.clear();
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }
}/////////mail class close

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}