// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_strip/month_picker_strip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/services/attandance_services.dart';

import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
import 'outside_label.dart';
// This app is a stateful, it tracks the user's current choice.
class PeriodicAttendance extends StatefulWidget {
  @override
  _PeriodicAttendance createState() => _PeriodicAttendance();
}

class _PeriodicAttendance extends State<PeriodicAttendance> with SingleTickerProviderStateMixin {
  TabController _controller;
  TextEditingController _searchController;
  FocusNode searchFocusNode;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _orgName;
  var profileimage;
  bool showtabbar;
  String orgName="";
  String empname="";
  String newValue='Last 7 days ' ;
  String month;
  Future<List<Attn>> _listFuture,_listFuture1,_listFuture2,_listFuture3,_listFuture4;
  final DateFormat dateFormat = new DateFormat('MMMM yyyy');
  DateTime selectedMonth;
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
    _searchController = new TextEditingController();
    searchFocusNode = FocusNode();
    super.initState();
    _listFuture1 = getAttnDataLast('Last 7 days ','null','present',empname);
    _listFuture2 = getAttnDataLast('Last 7 days ','null','absent',empname);
    _listFuture3 = getAttnDataLast('Last 7 days ','null','latecomings',empname);
    _listFuture4 = getAttnDataLast('Last 7 days ','null','earlyleavings',empname);
    print("empname1");
    print(empname);
    _controller = new TabController(length: 4, vsync: this);
    showtabbar =false;
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    getOrgName();
    selectedMonth = new DateTime.now();
  }

  setAlldata() {

    _listFuture1 = getAttnDataLast(newValue,selectedMonth,'present',empname);
    _listFuture2 = getAttnDataLast(newValue,selectedMonth,'absent',empname);
    _listFuture3 = getAttnDataLast(newValue,selectedMonth,'latecomings',empname);
    _listFuture4 = getAttnDataLast(newValue,selectedMonth,'earlyleavings',empname);

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
                SizedBox(height: 1.0),
                new Container(
                  child: Center(child:Text("Attendance Snap",style: TextStyle(fontSize: 20.0,color: appStartColor()),),),
                ),
                SizedBox(height:10.0),
                /*Container(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
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
                        suffixIcon: _searchController.text.isNotEmpty?IconButton(icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              empname='';
                              *//*Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EmployeeList()),
                              );*//*
                            }
                        ):null,
                        //focusColor: Colors.white,
                      ),
                      onChanged: (value) {
                        setState(() {
                          empname = value;
                          //res = true;
                        });
                      },
                    ),
                  ),
                ),*/
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:10.0),
                      child: Container(
                        width: MediaQuery.of(context).copyWith().size.width*0.45,
                        padding: EdgeInsets.all(5.0),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide( color: Colors.grey.withOpacity(1.0), width: 1,),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            child: Padding(
                              padding: const EdgeInsets.only(left:5.0,top: 5.0,bottom: 5.0,),
                              child: DropdownButton<String>(
                                icon: Icon(Icons.arrow_drop_down),
                                isDense: true,
                                hint: Text('Select Period'),
                                value: newValue,
                                onChanged: (value) async{
                                  newValue=value;
                                  if(newValue=='Custom Month ') {
                                    selectedMonth = DateTime.now();
                                    if(selectedMonth.month==1){
                                      month='January';
                                    }else if(selectedMonth.month==2){
                                      month='Feburary';
                                    }else if(selectedMonth.month==3){
                                      month='March';
                                    }else if(selectedMonth.month==4){
                                      month='April';
                                    }else if(selectedMonth.month==5){
                                      month='May';
                                    }else if(selectedMonth.month==6){
                                      month='June';
                                    }else if(selectedMonth.month==7){
                                      month='July';
                                    }else if(selectedMonth.month==8){
                                      month='August';
                                    }else if(selectedMonth.month==9){
                                      month='September';
                                    }else if(selectedMonth.month==10){
                                      month='October';
                                    }else if(selectedMonth.month==11){
                                      month='November';
                                    }else if(selectedMonth.month==12){
                                      month='December';
                                    }
                                  } else {
                                    selectedMonth = null;
                                  }
                                  print(value);
                                  print(newValue);
                                  setState(() {
                                    setAlldata();
                                    print("empname2");
                                    print(empname);
                                  });
                                },
                                items: <String>['Last 7 days ', 'Last 14 days ', 'Last 30 days ', 'Custom Month '].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                newValue=='Custom Month '?new MonthStrip(
                  format: 'MMM yyyy',
                  from: DateTime.now().subtract(Duration(days: 90)),
                  to: DateTime.now(),
                  initialMonth: selectedMonth,
                  height: 48.0,
                  viewportFraction: 0.25,
                  onMonthChanged: (v) {
                    setState(() {
                      selectedMonth = v;
                      if(selectedMonth.month==1){
                        month='January';
                      }else if(selectedMonth.month==2){
                        month='Feburary';
                      }else if(selectedMonth.month==3){
                        month='March';
                      }else if(selectedMonth.month==4){
                        month='April';
                      }else if(selectedMonth.month==5){
                        month='May';
                      }else if(selectedMonth.month==6){
                        month='June';
                      }else if(selectedMonth.month==7){
                        month='July';
                      }else if(selectedMonth.month==8){
                        month='August';
                      }else if(selectedMonth.month==9){
                        month='September';
                      }else if(selectedMonth.month==10){
                        month='October';
                      }else if(selectedMonth.month==11){
                        month='November';
                      }else if(selectedMonth.month==12){
                        month='December';
                      }
                      print("selectedMonth");
                      print(newValue);
                      print(selectedMonth);
                      setState(() {
                        setAlldata();
                        print("empname3");
                        print(empname);
                      });
                    });
                  },
                ):Center(),
                new Container(
                  padding: EdgeInsets.all(0.1),
                  margin: EdgeInsets.all(0.1),
                  child: new ListTile(
                    title: new SizedBox(height: MediaQuery.of(context).size.height*0.25,

                      child: new FutureBuilder<List<Map<String,String>>>(
                          future: (newValue!= null && selectedMonth!='null')? getChartDataLast(newValue,selectedMonth): getChartDataLast('Last 7 days ','null'),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.length > 0) {
                                return new PieOutsideLabelChart.withRandomData_range(snapshot.data);
                              }
                            }
                            return new Center( child: CircularProgressIndicator());
                          }
                      ),

                      //  child: new PieOutsideLabelChart.withRandomData(),

                      width: MediaQuery.of(context).size.width*1.0,),
                  ),
                ),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(width: 15.0,),
                    Flexible(
                      child: Container(
                        child: Text('Present(P)',
                          style: TextStyle(color: Colors.black87, fontSize: 12.0),),
                      ),
                    ),
                    SizedBox(width: 20.0,),
                    Flexible(
                      child: Container(
                        child: Text('Absent(A)',
                          style: TextStyle(color: Colors.black87, fontSize: 12.0),),
                      ),
                    ),
                    SizedBox(width: 20.0,),
                    Flexible(
                      child: Container(
                        child: Text('Late Comers(LC)',
                          style: TextStyle(color: Colors.black87, fontSize: 12.0),),
                      ),
                    ),
                    SizedBox(width: 15.0,),
                    Flexible(
                      child: Container(
                        child: Text('Early Leavers(EL)',
                          style: TextStyle(color: Colors.black87, fontSize: 12.0),),
                      ),
                    ),
                  ],
                ),
                Divider(),
                new Container(
                  decoration: new BoxDecoration(color: Colors.black54),
                  child: new TabBar(
                    indicator: BoxDecoration(color: Colors.orange[800],),
                    controller: _controller,
                    tabs: [
                      new Tab(
                        text: 'Present',
                      ),
                      new Tab(
                        text: 'Absent',
                      ),
                      new Tab(
                        text: 'Late \nComers',
                      ),
                      new Tab(
                        text: 'Early \nLeavers',
                      ),
                    ],
                  ),
                ),
                new Row(
                  //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 40.0,),
                    SizedBox(width: MediaQuery.of(context).size.width*0.02),
                    Container(
                      width: MediaQuery.of(context).size.width*0.20,
                      child:Text('  Date',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                    ),
                    SizedBox(height: 40.0,),
                    Container(

                      width: MediaQuery.of(context).size.width*0.35,
                      child:Text('Name',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                    ),
                    SizedBox(height: 40.0,),
                    Container(

                      width: MediaQuery.of(context).size.width*0.14,
                      child:Text('Time In',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                    ),
                    SizedBox(height: 40.0,),
                    Container(

                      width: MediaQuery.of(context).size.width*0.16,
                      child:Text('Time Out',textAlign: TextAlign.center,style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                    ),
                  ],
                ),
                new Divider(height: 1.0,),
                new Container(
                  height: MediaQuery.of(context).size.height*0.50,
                  child: new TabBarView(

                    controller: _controller,
                    children: <Widget>[
                      new Container(
                        height: MediaQuery.of(context).size.height*0.35,
                        //   shape: Border.all(color: Colors.deepOrange),
                        child: new ListTile(
                          title:
                          Container( height: MediaQuery.of(context).size.height*30,
                            //width: MediaQuery.of(context).size.width*.99,
                            color: Colors.white,
                            //////////////////////////////////////////////////////////////////////---------------------------------
                            child: new FutureBuilder<List<Attn>>(
                              future: _listFuture1,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if(snapshot.data.length>0) {
                                    return new ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return new Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[

                                              SizedBox(height: 40.0,),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.18,
                                                child:  Text(snapshot.data[index].EntryImage
                                                    .toString(), style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16.0),),
                                              ),
                                              Container(

                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.35,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(snapshot.data[index].Name
                                                        .toString(), style: TextStyle(
                                                        color: Colors
                                                            .black87,
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        fontSize: 16.0),),
                                                  ],
                                                ),
                                              ),
                                              Container(

                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.13,
                                                child:  Text(snapshot.data[index].TimeIn
                                                    .toString(), style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16.0),),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.16,
                                                  child:  Text(snapshot.data[index].TimeOut
                                                      .toString(), style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 16.0),textAlign: TextAlign.center,),
                                                ),
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
                                        child:Text(newValue=="Custom Month "?"No present employees found in "+month:"No present employees found in "+newValue,style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                                      ),
                                    );
                                  }
                                } else if (snapshot.hasError) {
                                  print("Unable to connect server");
                                  return new Text("Unable to connect server");
                                }

                                // By default, show a loading spinner
                                return new Center( child: CircularProgressIndicator());
                              },
                            ),
                            //////////////////////////////////////////////////////////////////////---------------------------------
                          ),
                        ),
                      ),
                      //////////////TABB 2 Start
                      new Container(

                        height: MediaQuery.of(context).size.height*0.35,
                        //   shape: Border.all(color: Colors.deepOrange),
                        child: new ListTile(
                          title:
                          Container( height: MediaQuery.of(context).size.height*30,
                            //width: MediaQuery.of(context).size.width*.99,
                            color: Colors.white,
                            //////////////////////////////////////////////////////////////////////---------------------------------
                            child: new FutureBuilder<List<Attn>>(
                              future: _listFuture2,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if(snapshot.data.length>0) {
                                    return new ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return new Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[

                                              SizedBox(height: 40.0,),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.18,
                                                child:  Text(snapshot.data[index].EntryImage
                                                    .toString(), style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16.0),),
                                              ),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.35,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(snapshot.data[index].Name
                                                        .toString(), style: TextStyle(
                                                        color: Colors
                                                            .black87,
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        fontSize: 16.0)),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.13,
                                                child:  Text(snapshot.data[index].TimeIn
                                                    .toString(), style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16.0),),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.16,
                                                  child:  Text(snapshot.data[index].TimeOut
                                                      .toString(), style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 16.0),textAlign: TextAlign.center,),
                                                ),
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
                                        child:Text(newValue=="Custom Month "?"No absent employees found in "+month:"No absent employees found in "+newValue,style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                                      ),
                                    );
                                  }
                                } else if (snapshot.hasError) {
                                  return new Text("Unable to connect server");
                                }

                                // By default, show a loading spinner
                                return new Center( child: CircularProgressIndicator());
                              },
                            ),
                            //////////////////////////////////////////////////////////////////////---------------------------------
                          ),
                        ),

                      ),

                      /////////////TAB 2 Ends



                      /////////////TAB 3 STARTS

                      new Container(

                        height: MediaQuery.of(context).size.height*0.35,
                        //   shape: Border.all(color: Colors.deepOrange),
                        child: new ListTile(
                          title:
                          Container( height: MediaQuery.of(context).size.height*30,
                            //width: MediaQuery.of(context).size.width*.99,
                            color: Colors.white,
                            //////////////////////////////////////////////////////////////////////---------------------------------
                            child: new FutureBuilder<List<Attn>>(
                              future: _listFuture3,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if(snapshot.data.length>0) {
                                    return new ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return new Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[

                                              SizedBox(height: 40.0,),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.18,
                                                child:  Text(snapshot.data[index].EntryImage
                                                    .toString(), style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16.0),),
                                              ),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.35,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(snapshot.data[index].Name
                                                        .toString(), style: TextStyle(
                                                        color: Colors
                                                            .black87,
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        fontSize: 16.0)),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.13,
                                                child:  Text(snapshot.data[index].TimeIn
                                                    .toString(), style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16.0),),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.16,
                                                  child:  Text(snapshot.data[index].TimeOut
                                                      .toString(), style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 16.0),textAlign: TextAlign.center,),
                                                ),
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
                                        child:Text(newValue=="Custom Month "?"No late comer employees found in "+month:"No late comer employees found in "+newValue,style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                                      ),
                                    );
                                  }
                                } else if (snapshot.hasError) {
                                  return new Text("Unable to connect server");
                                }

                                // By default, show a loading spinner
                                return new Center( child: CircularProgressIndicator());
                              },
                            ),
                            //////////////////////////////////////////////////////////////////////---------------------------------
                          ),
                        ),

                      ),
                      /////////TAB 3 ENDS


                      /////////TAB 4 STARTS
                      new Container(


                        height: MediaQuery.of(context).size.height*0.35,
                        //   shape: Border.all(color: Colors.deepOrange),
                        child: new ListTile(
                          title:
                          Container( height: MediaQuery.of(context).size.height*30,
                            //width: MediaQuery.of(context).size.width*.99,
                            color: Colors.white,
                            //////////////////////////////////////////////////////////////////////---------------------------------
                            child: new FutureBuilder<List<Attn>>(
                              future: _listFuture4,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if(snapshot.data.length>0) {
                                    return new ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return new Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[

                                              SizedBox(height: 40.0,),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.18,
                                                child:  Text(snapshot.data[index].EntryImage
                                                    .toString(), style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16.0),),
                                              ),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.35,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(snapshot.data[index].Name
                                                        .toString(), style: TextStyle(
                                                        color: Colors
                                                            .black87,
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        fontSize: 16.0)),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.13,
                                                child:  Text(snapshot.data[index].TimeIn
                                                    .toString(), style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16.0),),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.16,
                                                  child:  Text(snapshot.data[index].TimeOut
                                                      .toString(), style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 16.0),),
                                                ),),

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
                                        child:Text(newValue=="Custom Month "?"No early leaver employees found in "+month:"No early leaver employees found in "+newValue,style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                                      ),
                                    );
                                  }
                                } else if (snapshot.hasError) {
                                  return new Text("Unable to connect server");
                                }

                                // By default, show a loading spinner
                                return new Center( child: CircularProgressIndicator());
                              },
                            ),
                            //////////////////////////////////////////////////////////////////////---------------------------------
                          ),
                        ),
                      ),
                      ///////////////////TAB 4 Ends
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]);
  }
}
