import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/appbar.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/settings.dart';
import 'drawer.dart';

class Division extends StatefulWidget {
  @override
  _DivisionState createState() => _DivisionState();
}

class _DivisionState extends State<Division> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static const statuses =  ['Active', 'Inactive'];
  String orgName = "";
  bool _isButtonDisabled = false;
  int hrsts=0;
  int adminsts=0;
  int divhrsts=0;
  TextEditingController _searchController;
  FocusNode searchFocusNode;
  String divname = "";
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

  getOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName = prefs.getString('orgname') ?? '';
      hrsts =prefs.getInt('hrsts')??0;
      adminsts =prefs.getInt('adminsts')??0;
      divhrsts =prefs.getInt('divhrsts')??0;
    });
  }

  Widget build(BuildContext context) {
    return mainDivisionWidget();
  }

  Future<bool> move() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AllSetting()), (
        Route<dynamic> route) => false,
    );
    return false;
  }

  mainDivisionWidget() {
    return WillPopScope(
      onWillPop: () => move(),
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
            children: [
              Center(
                  child: Text(
                'Divisions',
                style: TextStyle(
                  fontSize: 22.0,
                  color: appStartColor(),
                ),
              )),
              //Divider(),
              SizedBox(height: 5.0,),
              /*Container(
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
                      hintText: 'Search Division',
                      labelText: 'Search Division',
                      suffixIcon: _searchController.text.isNotEmpty?IconButton(icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Division()),
                            );
                          }
                      ):null,
                      //focusColor: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        divname = value;
                      });
                    },
                  ),
                ),
              ),*/
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Container(
                        //width: MediaQuery.of(context).size.width*0.65,
                        child: Text(
                          'Name',
                          style: TextStyle(
                              color: appStartColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                    /*SizedBox(
                      width: 5,
                    ),*/
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Container(
                        child: Text(
                          'Status',
                          style: TextStyle(
                              color: appStartColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              new Expanded(
                child: getDivisionWidget(),
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
                  content: new Text("To Add a new Division, login to the web panel"),
                );
              });
          },
          tooltip: 'Add Division',
          child: new Icon(Icons.add),
        ):Center(),
      ),
    );
  }

  getDivisionWidget() {
    return FutureBuilder<List<Div>>(
      future: getDivision(divname),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("snapshot.data.length");
          print(snapshot.data.length);
          if (snapshot.data.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Text(snapshot.data[index].div.toString(),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        //width: MediaQuery.of(context).size.height * 0.10,
                        child: Text(snapshot.data[index].status.toString(),
                            style: TextStyle(
                                fontSize: 14,
                                color: snapshot.data[index].status.toString() ==
                                            'Active'
                                        ? Colors.green
                                        : Colors.red)),
                      ),
                    ],
                  ),
                  onTap: () {
                    showAlertDialog(context, snapshot.data[index].id.toString(), snapshot.data[index].div.toString(),
                      snapshot.data[index].status.toString(),
                    );
                  },
                );
              },
            );
          }else{
            return new Center(
              child: Container(
                width: MediaQuery.of(context).size.width*1,
                color: appStartColor().withOpacity(0.1),
                padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                child:Text("No division found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return new Text("Unable to connect server");
        }
        return Center(child: CircularProgressIndicator());
      });
  }

  showAlertDialog(BuildContext context, String id, String div, String status) async {
    print("status division");
    print(status);
    var Name = new TextEditingController();
    Name.text=div;
    Widget cancelButton = FlatButton(
      shape: Border.all(color: Colors.orange[800]),
      child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget updateButton = RaisedButton(
      color: Colors.orange[800],
      child: Text(
        "UPDATE",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async {
        if(_isButtonDisabled)
          return null;
        setState(() {
          _isButtonDisabled=true;
        });
        var sts = await updateDiv(status, id);
        if(sts.contains("1")){
          Navigator.of(context, rootNavigator: true).pop('dialog');
          showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pop(true);
              });
              return AlertDialog(
                content: new Text("Division is updated successfully"),
              );
            });
          /*showDialog(context: context, child:
          new AlertDialog(
            content: new Text('Division update successfully.'),
          )
          );*/
          getDivisionWidget();
          setState(() {
            _isButtonDisabled=false;
          });
        }else if(sts.contains("-2")){
          Navigator.of(context, rootNavigator: true).pop('dialog');
          showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pop(true);
              });
              return AlertDialog(
                content: new Text("This division can't be deactivated. Employees are already assigned to it"),
              );
            });
          /*showDialog(context: context, child:
          new AlertDialog(
            content: new Text("Employees assigned to this division therefore can't be updated"),
          )
          );*/
          getDivisionWidget();
          setState(() {
            _isButtonDisabled=false;
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
                content: new Text("Unable to update division"),
              );
            });
          /*showDialog(context: context, child:
          new AlertDialog(
            content: new Text('Unable to update division'),
          )
          );*/
          setState(() {
            _isButtonDisabled=false;
          });
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height*0.22,
        width: MediaQuery.of(context).size.width*0.32,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
               new Expanded(
                   child:  TextField(
                     enabled: false, //Disable a `TextField`
                     controller: Name,
                     decoration: new InputDecoration(
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(8),
                           borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                         ),
                         labelText: 'Division', hintText: 'Division Name'),
                   ),
               ),

              SizedBox(height: 10,),
              new Expanded(child:
                new InputDecorator(
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                    ),
                    labelText: 'Status',
                  ),
                  child:DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: status,
                      onChanged: (String newValue) {
                        print(status);
                        setState(() {
                          status=newValue;
                          Navigator.of(context, rootNavigator: true).pop('dialog'); // here I pop to avoid multiple Dialogs
                          showAlertDialog(context, id, div, status);
                        });
                        print("status");
                        print(status);
                      },
                      items: statuses.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        updateButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
