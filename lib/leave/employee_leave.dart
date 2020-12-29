import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/services/leave_services.dart';

import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
import 'leave_reports.dart';

class EmployeeLeaveList extends StatefulWidget {
  @override
  _EmployeeLeaveList createState() => _EmployeeLeaveList();
}
TextEditingController today;

//FocusNode f_dept ;
class _EmployeeLeaveList extends State<EmployeeLeaveList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 1;
  String _orgName;
  bool res = true;
  String admin_sts='0';
  String emp='0';
  var formatter = new DateFormat('dd-MMM-yyyy');
  var profileimage;
  bool showtabbar;
  String orgName="";
  String empname="";
  TextEditingController _searchController;
  FocusNode searchFocusNode;

  @override
  void initState() {
    super.initState();
    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
    _searchController = new TextEditingController();
    searchFocusNode = FocusNode();
    showtabbar =false;
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    // f_dept = FocusNode();
    getOrgName();
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(
          value,
          textAlign: TextAlign.center,
        ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  Future<bool> sendToLeaveReport() async{
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );*/
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LeaveReports()), (Route<dynamic> route) => true,
    );
    return false;
  }

  getmainhomewidget() {
    return WillPopScope(
      onWillPop: ()=> sendToLeaveReport(),
      child: new Scaffold(
        key: _scaffoldKey,
        backgroundColor:scaffoldBackColor(),
        appBar: new AppHeader(profileimage, showtabbar,orgName),
        endDrawer: new AppDrawer(),
        bottomNavigationBar: HomeNavigation(),
        body: getReportsWidget(),
      ),
    );
  }


  getReportsWidget() {
    return Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
            //width: MediaQuery.of(context).size.width*0.9,
            //  height:MediaQuery.of(context).size.height*0.75,
            decoration: new ShapeDecoration(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              color: Colors.white,
            ),

            child: Column(
              children: <Widget>[
                //SizedBox(height: 1.0),
                Center(
                  child: Text(
                    "Employees on Leave" ,
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: appStartColor(),
                    ),
                  ),
                ),
                Divider(
                  height: 10.0,
                ),
                SizedBox(height: 2.0),
                Container(
                  child: DateTimeField(
                    //dateOnly: true,
                    format: formatter,
                    controller: today,
                    readOnly: true,
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.date_range,
                          color: Colors.grey,
                        ), // icon is 48px widget.
                      ), // icon is 48px widget.
                      labelText: 'Select Date',
                    ),
                    onChanged: (date) {
                      setState(() {
                        if (date != null && date.toString()!='') {
                          res = true; //showInSnackBar(date.toString());
                        } else{
                          res = false;
                        }
                      });
                    },
                    validator: (date) {
                      if (date == null) {
                        return 'Please select date';
                      }
                    },
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
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
                              hintText: 'Search Employee',
                              labelText: 'Search Employee',
                              /*suffixIcon: _searchController.text.isNotEmpty?IconButton(icon: Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    //getLateEmpDataList(today.text,empname);
                                    //res = true;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => LateComers()),
                                    );
                                    Navigator.pop(context);
                                  }
                              ):null,*/
                            ),
                            onChanged: (value) {
                              setState(() {
                                print("value");
                                print(value);
                                empname = value;
                                res = true;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //getEmployee_DD(),

                SizedBox(height: 12.0),
                Container(
                  //  padding: EdgeInsets.only(bottom:10.0,top: 10.0),
                  width: MediaQuery.of(context).size.width * .9,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(child:
                      Container(

                        width: MediaQuery.of(context).size.width * 0.33,
                        child: Text(
                          '   Name',
                          style: TextStyle(color: appStartColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      ),
                      Expanded(child: Container(
                        width: MediaQuery.of(context).size.width * 0.40,
                        child: Text(
                          'Duration',
                          style: TextStyle(color: appStartColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ),),
                      Expanded(child:    Container(
                        width: MediaQuery.of(context).size.width * 0.50,
                        child: Text('Type',
                            style: TextStyle(color: appStartColor(),
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                            textAlign: TextAlign.left),
                      ),),
                      /*Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        child: Text('Utilization',
                            style: TextStyle(color: appStartColor(),
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                            textAlign: TextAlign.left),
                      ),*/
                    ],
                  ),
                ),
                SizedBox(height: 5.0),
                Divider(
                  height: 5.2,
                ),
                new Expanded(
                  child: res == true ? getEmpDataList(today.text) : Container(
                    height: MediaQuery.of(context).size.height*0.25,
                    child:Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width*1,
                        color:appStartColor().withOpacity(0.1),
                        padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                        child:Text("Please select the date",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]);
  }

  loader() {
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset('assets/spinner.gif', height: 50.0, width: 50.0),
            ]),
      ),
    );
  }

  getEmpDataList(date) {
    return new FutureBuilder<List<EmpListLeave>>(
        future: getEmployeeLeaveList(date,empname),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return new ListView.builder(
                  itemCount: snapshot.data.length,
                  //    padding: EdgeInsets.only(left: 15.0,right: 15.0),
                  itemBuilder: (BuildContext context, int index) {
                    return new Column(children: <Widget>[
                      new FlatButton(
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(child:   new Container(
                                width: MediaQuery.of(context).size.width * 0.28,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(
                                        snapshot.data[index].name.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                  ],
                                ))),
                            Expanded(child:   new Container(
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: new Text(
                                snapshot.data[index].from.toString()+" - "+snapshot.data[index].to.toString(),
                              ),
                            )),
                            Expanded(child:    new Container(
                              width: MediaQuery.of(context).size.width * 0.44,
                              child: new Text(
                                snapshot.data[index].leavetype.toString()+snapshot.data[index].days.toString()+" \n"+snapshot.data[index].breakdown.toString(),
                              ),
                            )),
                            /*new Container(
                              width: MediaQuery.of(context).size.width * 0.20,
                              child: new Text(
                                snapshot.data[index].breakdown.toString(),
                                style: TextStyle(
                                    color:appStartColor()),
                              ),
                            ),*/
                          ],
                        ),
                        onPressed: () {
                          null;
                          //    editDept(context,snapshot.data[index].dept.toString(),snapshot.data[index].status.toString(),snapshot.data[index].id.toString());
                        },
                      ),
                      Divider(
                        color: Colors.blueGrey.withOpacity(0.25),
                        height: 0.2,
                      ),
                    ]);
                  });
            } else {
              return new Center(
                child: Container(
                  width: MediaQuery.of(context).size.width*1,
                  color: appStartColor().withOpacity(0.1),
                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                  child:Text("No employee is on Leave ",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                ),
              );
            }
          } else if (snapshot.hasError) {
            return new Text("Unable to connect server");
          }
          // return loader();
          return new Center(child: CircularProgressIndicator());
        });
  }


  Widget getEmployee_DD() {
    String dc = "0";
    return new FutureBuilder<List<Map>>(
        future: getEmployeesList(1, '0', '0'),// with -select- label
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            try {
              return new Container(
                //    width: MediaQuery.of(context).size.width*.45,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Select Employee',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ), // icon is 48px widget.
                    ),
                  ),

                  child: DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      isDense: true,

                      style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,

                      ),
                      value: emp,
                      onChanged: (String newValue) {
                        setState(() {
                          emp = newValue;
                          res = true;
                        });
                      },
                      items: snapshot.data.map((Map map) {
                        return new DropdownMenuItem<String>(
                          value: map["Id"].toString(),
                          child: new SizedBox(
                              width: 200.0,
                              child: map["Code"]!=''&&map["Code"]!='null'?new Text(map["Code"]+' - '+map["Name"]):new Text(map["Name"],)),
                        );
                      }).toList(),

                    ),
                  ),
                ),
              );
            }
            catch(e){
              return Text("EX: Unable to fetch employees");
            }
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return new Text("ER: Unable to fetch employees");
          }
          // return loader();
          return new Center(child: SizedBox(
            child: CircularProgressIndicator(strokeWidth: 2.2,),
            height: 20.0,
            width: 20.0,
          ),);
        });
  }




} /////////mail class close
