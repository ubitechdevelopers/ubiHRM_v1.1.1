// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_share/simple_share.dart';
import 'package:ubihrm/services/attandance_services.dart';

import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
import 'outside_label.dart';

// This app is a stateful, it tracks the user's current choice.
class ThisMonth extends StatefulWidget {
  @override
  _ThisMonth createState() => _ThisMonth();
}

class _ThisMonth extends State<ThisMonth> with SingleTickerProviderStateMixin {

  TabController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _orgName;
  var profileimage;
  bool showtabbar;
  String orgName="";
  bool filests=false;

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
            child: Center(child:Text("Attendance snap - Last 30 days",style: TextStyle(fontSize: 20.0,color: appStartColor()),),),
          ),
          new Container(
            padding: EdgeInsets.all(0.1),
            margin: EdgeInsets.all(0.1),
            child: new ListTile(
              title: new SizedBox(height: MediaQuery.of(context).size.height*0.20,

                child: new FutureBuilder<List<Map<String,String>>>(
                    future: getChartDataLast('l30'),
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
              Flexible(
                child: Text('Present(P)',
                  style: TextStyle(color: Colors.black87, fontSize: 12.0),),
              ),
              Flexible(
                child: Text('Absent(A)',
                  style: TextStyle(color: Colors.black87, fontSize: 12.0),),
              ),
              Flexible(
                child: Text('Late Comers(LC)',
                  style: TextStyle(color: Colors.black87, fontSize: 12.0),),
              ),
              Flexible(
                child: Text('Early Leavers(EL)',
                  style: TextStyle(color: Colors.black87, fontSize: 12.0),),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 40.0,),
              SizedBox(width: MediaQuery.of(context).size.width*0.02),
              Container(
                width: MediaQuery.of(context).size.width*0.20,
                child:Text('Date',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
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
                child:Text('Time Out',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
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
                        future: getAttnDataLast('l30','present'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      children: <Widget>[
                                        (index == 0)
                                            ? Row(children: <Widget>[
                                          SizedBox(
                                            height: 25.0,
                                          ),
                                          Container(
                                            padding:
                                            EdgeInsets.only(left: 5.0),
                                            child: Text(
                                              "Total Present: " +
                                                  snapshot.data.length
                                                      .toString(),
                                              style: TextStyle(
                                                color: Colors.orange,
                                                fontWeight: FontWeight
                                                    .bold,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                         /* Container(
                                            padding:
                                            EdgeInsets.only(left: 5.0),
                                            child: InkWell(
                                              child: Text(
                                                'CSV',
                                                style: TextStyle(
                                                    decoration:
                                                    TextDecoration
                                                        .underline,
                                                    color:
                                                    Colors.blueAccent),
                                              ),
                                              onTap: () {
                                                //if (trialstatus != '2') {
                                                setState(() {
                                                  filests=true;
                                                });

                                                getMonthlyCSV(snapshot.data,
                                                    'Monthly_Present',
                                                    'present').then((
                                                    res) {
                                                  setState(() {
                                                    filests=false;
                                                  });
                                                  dialogwidget(
                                                      'CSV has been saved in internal storage in ubihrm_files/Monthly_Present',
                                                      res);
                                                });
                                                *//* } else {
                                                          showInSnackBar(
                                                              "For CSV please Buy Now");
                                                        }*//*
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding:
                                            EdgeInsets.only(left: 5.0),
                                            child: InkWell(
                                              child: Text(
                                                'PDF',
                                                style: TextStyle(
                                                    decoration:
                                                    TextDecoration
                                                        .underline,
                                                    color:
                                                    Colors.blueAccent),
                                              ),
                                              onTap: () {
                                                //if (trialstatus != '2') {
                                                setState(() {
                                                  filests=true;
                                                });
                                                CreateMonthlyPDF(
                                                    snapshot.data,
                                                    'Monthly Present Employees Report',
                                                    snapshot.data.length.toString(),
                                                    'Monthly_Present',
                                                    'present')
                                                    .then((res) {
                                                  setState(() {
                                                    filests=false;
                                                  });
                                                  dialogwidget(
                                                      'PDF has been saved in internal storage in ubihrm_files/Monthly_Present.pdf',
                                                      res);
                                                });
                                                *//* } else {
                                                          showInSnackBar(
                                                              "For PDF please Buy Now");
                                                        }*//*
                                              },
                                            ),
                                          ),*/
                                        ])
                                            : new Center(),
                                        (index == 0)
                                            ? Divider(
                                          color: Colors.black26,
                                        ) : new Center(),
                                        Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
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

                                      ),
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
                                  child:Text("No Employees found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                                ),
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                            return new Text("Unable to connect server");
                           // return new Text("EXCEPTION: ${snapshot.error}");
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
                        future: getAttnDataLast('l30','absent'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {

                                    return Column(
                                      children: <Widget>[
                                        (index == 0)
                                        ? Row(children: <Widget>[
                                      SizedBox(
                                        height: 25.0,
                                      ),
                                      Container(
                                        padding:
                                        EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          "Total Absent: " +
                                              snapshot.data.length
                                                  .toString(),
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight
                                                .bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      /*Container(
                                        padding:
                                        EdgeInsets.only(left: 5.0),
                                        child: InkWell(
                                          child: Text(
                                            'CSV',
                                            style: TextStyle(
                                                decoration:
                                                TextDecoration
                                                    .underline,
                                                color:
                                                Colors.blueAccent),
                                          ),
                                          onTap: () {
                                            //if (trialstatus != '2') {
                                            setState(() {
                                              filests=true;
                                            });

                                            getMonthlyCSV(snapshot.data,
                                                'Monthly_Absent',
                                                'absent').then((
                                                res) {
                                              setState(() {
                                                filests=false;
                                              });
                                              dialogwidget(
                                                  'CSV has been saved in internal storage in ubihrm_files/Monthly_Absent',
                                                  res);
                                            });
                                            *//* } else {
                                                          showInSnackBar(
                                                              "For CSV please Buy Now");
                                                        }*//*
                                          },
                                        ),
                                      ),
                                      Container(
                                        padding:
                                        EdgeInsets.only(left: 5.0),
                                        child: InkWell(
                                          child: Text(
                                            'PDF',
                                            style: TextStyle(
                                                decoration:
                                                TextDecoration
                                                    .underline,
                                                color:
                                                Colors.blueAccent),
                                          ),
                                          onTap: () {
                                            //if (trialstatus != '2') {
                                            setState(() {
                                              filests=true;
                                            });
                                            CreateMonthlyPDF(
                                                snapshot.data,
                                                'Monthly Absent Employees',
                                                snapshot.data.length.toString(),
                                                'Monthly_Absent',
                                                'absent')
                                                .then((res) {
                                              setState(() {
                                                filests=false;
                                              });
                                              dialogwidget(
                                                  'PDF has been saved in internal storage in ubihrm_files/Monthly_Absent.pdf',
                                                  res);
                                            });
                                            *//* } else {
                                                          showInSnackBar(
                                                              "For PDF please Buy Now");
                                                        }*//*
                                          },
                                        ),
                                      ),*/
                                    ]) : new Center(),
                                    (index == 0)
                                    ? Divider(
                                    color: Colors.black26,
                                    ) : new Center(),
                                      Row(
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
                                                fontSize: 16.0),textAlign: TextAlign.center,),
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

                                      ),
                                    ]
                                    );
                                  }
                              );
                            }else{
                              return new  Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width*1,
                                  color: appStartColor().withOpacity(0.1),
                                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                  child:Text("No Employees found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                                ),
                              );
                            }
                          }
                          else if (snapshot.hasError) {
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
                        future: getAttnDataLast('l30','latecomings'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      children: <Widget>[
                                        (index == 0)
                                        ? Row(children: <Widget>[
                                      SizedBox(
                                        height: 25.0,
                                      ),
                                      Container(
                                        padding:
                                        EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          "Total Late Comers: " +
                                              snapshot.data.length
                                                  .toString(),
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight
                                                .bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                     /* Container(
                                        padding:
                                        EdgeInsets.only(left: 5.0),
                                        child: InkWell(
                                          child: Text(
                                            'CSV',
                                            style: TextStyle(
                                                decoration:
                                                TextDecoration
                                                    .underline,
                                                color:
                                                Colors.blueAccent),
                                          ),
                                          onTap: () {
                                            //if (trialstatus != '2') {
                                            setState(() {
                                              filests=true;
                                            });

                                            getMonthlyCSV(snapshot.data,
                                                'Monthly_Late_Comers',
                                                'late').then((
                                                res) {
                                              setState(() {
                                                filests=false;
                                              });
                                              dialogwidget(
                                                  'CSV has been saved in internal storage in ubihrm_files/Monthly_Late_Comers',
                                                  res);
                                            });
                                            *//* } else {
                                                          showInSnackBar(
                                                              "For CSV please Buy Now");
                                                        }*//*
                                          },
                                        ),
                                      ),
                                      Container(
                                        padding:
                                        EdgeInsets.only(left: 5.0),
                                        child: InkWell(
                                          child: Text(
                                            'PDF',
                                            style: TextStyle(
                                                decoration:
                                                TextDecoration
                                                    .underline,
                                                color:
                                                Colors.blueAccent),
                                          ),
                                          onTap: () {
                                            //if (trialstatus != '2') {
                                            setState(() {
                                              filests=true;
                                            });
                                            CreateMonthlyPDF(
                                                snapshot.data,
                                                'Monthly Late Comers Employees',
                                                snapshot.data.length.toString(),
                                                'Monthly_Late_Comers',
                                                'late')
                                                .then((res) {
                                              setState(() {
                                                filests=false;
                                              });
                                              dialogwidget(
                                                  'PDF has been saved in internal storage in ubihrm_files/Monthly_Late_Comers.pdf',
                                                  res);
                                            });
                                            *//* } else {
                                                          showInSnackBar(
                                                              "For PDF please Buy Now");
                                                        }*//*
                                          },
                                        ),
                                      ),*/
                                    ])
                                        : new Center(),
                                    (index == 0)
                                    ? Divider(
                                    color: Colors.black26,
                                    )
                                        : new Center(),
                                      Row(
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
                                                fontSize: 16.0),textAlign: TextAlign.center,),
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

                                      ),
                                    ]
                                    );
                                  }
                              );
                            }else{
                              return new Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width*1,
                                  color:appStartColor().withOpacity(0.1),
                                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                  child:Text("No Employees found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                                ),
                              );
                            }
                          }
                          else if (snapshot.hasError) {
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
                        future: getAttnDataLast('l30','earlyleavings'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      children: <Widget>[
                                        (index == 0)
                                        ? Row(children: <Widget>[
                                      SizedBox(
                                        height: 25.0,
                                      ),
                                      Container(
                                        padding:
                                        EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          "Total Early Leavers: " +
                                              snapshot.data.length
                                                  .toString(),
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight
                                                .bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      /*Container(
                                        padding:
                                        EdgeInsets.only(left: 5.0),
                                        child: InkWell(
                                          child: Text(
                                            'CSV',
                                            style: TextStyle(
                                                decoration:
                                                TextDecoration
                                                    .underline,
                                                color:
                                                Colors.blueAccent),
                                          ),
                                          onTap: () {
                                            //if (trialstatus != '2') {
                                            setState(() {
                                              filests=true;
                                            });

                                            getMonthlyCSV(snapshot.data,
                                                'Monthly_Early_Leavers',
                                                'early').then((
                                                res) {
                                              setState(() {
                                                filests=false;
                                              });
                                              dialogwidget(
                                                  'CSV has been saved in internal storage in ubihrm_files/Monthly_Early_Leavers',
                                                  res);
                                            });
                                            *//* } else {
                                                          showInSnackBar(
                                                              "For CSV please Buy Now");
                                                        }*//*
                                          },
                                        ),
                                      ),
                                      Container(
                                        padding:
                                        EdgeInsets.only(left: 5.0),
                                        child: InkWell(
                                          child: Text(
                                            'PDF',
                                            style: TextStyle(
                                                decoration:
                                                TextDecoration
                                                    .underline,
                                                color:
                                                Colors.blueAccent),
                                          ),
                                          onTap: () {
                                            //if (trialstatus != '2') {
                                            setState(() {
                                              filests=true;
                                            });
                                            CreateMonthlyPDF(
                                                snapshot.data,
                                                'Monthly Early Leavers Employees',
                                                snapshot.data.length.toString(),
                                                'Monthly_Early_Leavers',
                                                'early')
                                                .then((res) {
                                              setState(() {
                                                filests=false;
                                              });
                                              dialogwidget(
                                                  'PDF has been saved in internal storage in ubihrm_files/Monthly_Early_Leavers.pdf',
                                                  res);
                                            });
                                            *//* } else {
                                                          showInSnackBar(
                                                              "For PDF please Buy Now");
                                                        }*//*
                                          },
                                        ),
                                      ),*/
                                    ])
                                        : new Center(),
                                    (index == 0)
                                    ? Divider(
                                    color: Colors.black26,
                                    )
                                        : new Center(),
                                      Row(
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
                                                fontSize: 16.0),textAlign: TextAlign.center,),
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

                                      ),
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
                                  child:Text("No Employees found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                                ),
                              );
                            }
                          }
                          else if (snapshot.hasError) {
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

  dialogwidget(msg, filename) {
    showDialog(
        context: context,
        // ignore: deprecated_member_use
        child: new AlertDialog(
          content: new Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text('Later'),
              shape: Border.all(),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            RaisedButton(
              child: Text(
                'Share File',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.orange[800],
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                final uri=Uri.file(filename);
                SimpleShare.share(
                    uri: uri.toString(),
                    title: "UBIHRM Report",
                    msg: "UBIHRM Report");
              },
            ),
          ],
        ));
  }
}
