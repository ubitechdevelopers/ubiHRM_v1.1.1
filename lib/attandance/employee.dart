// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_strip/month_picker_strip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/attandance/Employeewise_att.dart';
import 'package:ubihrm/services/attandance_services.dart';

import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
// This app is a stateful, it tracks the user's current choice.
class Employee_list extends StatefulWidget {
  final DateTime orgDate;
  @override
  _Employee_list createState() => _Employee_list();
  Employee_list({Key key,  this.orgDate}) : super(key: key);
}

TextEditingController today;
class _Employee_list extends State<Employee_list> with SingleTickerProviderStateMixin {

  DateTime selectedMonth;
  DateTime to;
  DateTime from;

  TabController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _orgName;
  var profileimage;
  bool showtabbar;
  String orgName="";
  bool filests=false;
  String emp='0';
  String empname= '';
  String countE='0';
  Future<List<Attn>> _listFuture;
  List presentlist= new List(), absentlist= new List(), latecommerlist= new List(), earlyleaverlist= new List();
//  var formatter = new DateFormat('dd-MMM-yyyy');
  var formatter = new DateFormat('dd-MMM-yyyy');
  bool res = true;
  List<Map<String,String>> chartData;
  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 4, vsync: this);
    showtabbar =false;
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    getOrgName();
    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
    from = new DateTime.now();
    selectedMonth = new DateTime(from.year, from.month, 1);
    print("Hello");
    print(selectedMonth);
    setAlldata();
  }

  setAlldata() async{
    print("Hello Employees");
    print(selectedMonth);
    _listFuture = getTotalEmployeesList(selectedMonth);

    _listFuture.then((data) async{
      setState(() {
        countE = data.length.toString();
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor:scaffoldBackColor(),
      appBar: new AppHeader(profileimage, showtabbar,orgName),
      endDrawer: new AppDrawer(),
      bottomNavigationBar: HomeNavigation(),
      body: getReportsWidget(),
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
            child: ListView(
              //physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                SizedBox(height:1.0),
                new Container(
                  child: Center(child:Text("Employee Wise Attendance",style: TextStyle(fontSize: 20.0,color: appStartColor()),),),
                ),
                Column(
                  children: <Widget>[
                    new MonthStrip(
                      format: 'MMM yyyy',
                      from: widget.orgDate,
                      to: selectedMonth,
                      initialMonth: selectedMonth,
                      height: 48.0,
                      viewportFraction: 0.25,
                      onMonthChanged: (v) {
                        setState(() {
                          selectedMonth = v;
                          if (v != null && v.toString()!='') {
                            res=true; //showInSnackBar(date.toString());
                            setAlldata();
                          }
                          else {
                            res=false;
                            countE='0';
                          }
                          print(selectedMonth);
                        });
                      },
                    ),
                    Divider(height: 5.0,),
                    Row(
                        children: <Widget>[
                          //SizedBox(height: 25.0,),
                          Container(
                            padding: EdgeInsets.only(left: 20.0, top:4),
                            child: Text("Total Employees: ${countE}",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16.0,),),
                          ),

                          /*SizedBox(width: 40,),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Container(
                          color: Colors.white,
                          //height: 65,
                          //width: MediaQuery.of(context).size.width * 0.25,
                          child: new Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                //(presentlist.length > 0 || absentlist.length > 0 || latecommerlist.length > 0 || earlyleaverlist.length > 0)?
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      //padding: EdgeInsets.only(left: 5.0),
                                      child: InkWell(
                                        child: Text('CSV',
                                          style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            color: Colors.blueAccent,
                                            fontSize: 16,
                                            //fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        onTap: () {
                                          //openFile(filepath);
                                          if (mounted) {
                                            setState(() {
                                              filests = true;
                                            });
                                          }
                                          getCsvAll(
                                              presentlist,
                                              absentlist,
                                              latecommerlist,
                                              earlyleaverlist,
                                              'Employee_Wise_Report',
                                              'emp'
                                          ).then((res) {
                                            print('snapshot.data');

                                            if (mounted) {
                                              setState(() {
                                                filests=false;
                                              });
                                            }
                                            // showInSnackBar('CSV has been saved in file storage in ubiattendance_files/Department_Report_'+today.text+'.csv');
                                            dialogwidget(
                                                "CSV has been saved in internal storage in ubiattendance_files/Employee_Wise_Report" +
                                                    ".csv", res);
                                          }
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width:6,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 5.0),
                                      child: InkWell(
                                        child: Text('PDF',
                                          style: TextStyle(
                                            decoration:
                                            TextDecoration
                                                .underline,
                                            color: Colors
                                                .blueAccent,
                                            fontSize: 16,),
                                        ),
                                        onTap: () {
                                          final uri = Uri.file('/storage/emulated/0/ubiattendance_files/Employee_Wise_Report_14-Jun-2019.pdf');
                                          SimpleShare.share(
                                              uri: uri.toString(),
                                              title: "Share my file",
                                              msg: "My message");
                                          if (mounted) {
                                            setState(() {
                                              filests = true;
                                            });
                                          }
                                          CreateEmployeeWisepdf(
                                              presentlist,
                                              absentlist,
                                              latecommerlist,
                                              earlyleaverlist,
                                              'Employee Report of ' + empname,
                                              'Employee_Wise_Report',
                                              'employeewise'
                                          ).then((res) {
                                            if(mounted) {
                                              setState(() {
                                                filests =
                                                false;
                                                // OpenFile.open("/sdcard/example.txt");
                                              });
                                            }
                                            dialogwidget(
                                                'PDF has been saved in internal storage in ubiattendance_files/Employee_Wise_Report'+
                                                    '.pdf',
                                                res);
                                            // showInSnackBar('PDF has been saved in file storage in ubiattendance_files/'+'Department_Report_'+today.text+'.pdf');
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )*//*:Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top:12.0),
                                      child: Text("No CSV/Pdf generated", textAlign: TextAlign.center,),
                                    )
                                )*//*
                              ]
                          )
                      )
                    )*/
                        ]
                    ),
                    SizedBox(height: 5.0,)
                  ],
                ),

                new Divider(height: 1.0,),
                res==true?new Container(
                    height: MediaQuery.of(context).size.height*.50,
                    child: new Container(
                      height: MediaQuery.of(context).size.height*0.35,
                      //   shape: Border.all(color: Colors.deepOrange),
                      child: new ListTile(
                        title:
                        Container( height: MediaQuery.of(context).size.height*30,
                          //width: MediaQuery.of(context).size.width*.99,
                          color: Colors.white,
                          //////////////////////////////////////////////////////////////////////---------------------------------
                          child: new FutureBuilder<List<Attn>>(
                            future: getTotalEmployeesList(selectedMonth),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                //countE=snapshot.data.length.toString();
                                if(snapshot.data.length>0) {
                                  return new ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Column(
                                          children: <Widget>[
                                            /*(index == 0)?
                                        Row(
                                            children: <Widget>[
                                              //SizedBox(height: 25.0,),
                                              Container(
                                                padding: EdgeInsets.only(left: 5.0),
                                                child: Text("Total Employees: ${snapshot.data.length.toString()}",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16.0,),),
                                              ),
                                            ]
                                        ):new Center(),
                                        (index == 0)?
                                        Divider(color: Colors.black26,):new Center(),*/
                                            new Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceAround,
                                              children: <Widget>[
                                                SizedBox(height: 40.0,),
                                                InkWell(
                                                  child: Container(
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width * 0.65,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: <Widget>[
                                                        Text(snapshot.data[index].Name
                                                            .toString(), style: TextStyle(
                                                            color: appStartColor(),
                                                            //fontWeight: FontWeight.bold,
                                                            fontSize: 16.0, decoration: TextDecoration.underline),),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => EmployeeWise_att(
                                                            empid: snapshot.data[index].Id.toString(),
                                                            month: selectedMonth,
                                                            empname:snapshot.data[index].Name.toString(),
                                                            shift: snapshot.data[index].Shift.toString(),
                                                            shifttime: snapshot.data[index].ShiftTime.toString(),
                                                            breaktime: snapshot.data[index].Break.toString(),
                                                          ),
                                                        )
                                                    );
                                                  },
                                                ),

                                                InkWell(
                                                  child: Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.15,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .center,
                                                        children: <Widget>[
                                                          //Text('view', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),)
                                                          Icon(
                                                            Icons.visibility,
                                                            color: Colors.blue,
                                                            size: 20,

                                                          ),
                                                        ],
                                                      )
                                                  ),
                                                  onTap: (){
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => EmployeeWise_att(
                                                            empid: snapshot.data[index].Id.toString(),
                                                            month: selectedMonth,
                                                            empname:snapshot.data[index].Name.toString(),
                                                            shift: snapshot.data[index].Shift.toString(),
                                                            shifttime: snapshot.data[index].ShiftTime.toString(),
                                                            breaktime: snapshot.data[index].Break.toString(),
                                                          ),
                                                        )
                                                    );
                                                  },
                                                ),
                                              ],

                                            ),
                                          ],
                                        );
                                      }
                                  );
                                }else{
                                  return new Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*1,
                                      color: appStartColor().withOpacity(0.1),
                                      padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                      child:Text("No employees found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                                    ),
                                  );
                                }
                              } else if (snapshot.hasError) {
                                return new Text("Unable to connect server");
                                // return new Text("${snapshot.error}");
                              }
                              // By default, show a loading spinner
                              return new Center( child: CircularProgressIndicator());
                            },
                          ),
                          //////////////////////////////////////////////////////////////////////---------------------------------
                        ),
                      ),
                    )
                ):Container(
                  height: MediaQuery.of(context).size.height*0.25,
                  child:Center(
                    child: Text('No Data Available'),
                  ),
                ),
              ],
            ),
          )
        ]);
  }

}