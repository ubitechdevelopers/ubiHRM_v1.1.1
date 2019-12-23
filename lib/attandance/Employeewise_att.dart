// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/services/attandance_services.dart';

import './image_view.dart';
import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
// This app is a stateful, it tracks the user's current choice.
class EmployeeWise_att extends StatefulWidget {
  @override
  _EmployeeWise_att createState() => _EmployeeWise_att();
}
//TextEditingController today;
class _EmployeeWise_att extends State<EmployeeWise_att> with SingleTickerProviderStateMixin {
  TabController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _orgName;
  var profileimage;
  bool showtabbar;
  String orgName="";

  String emp='0';
//  var formatter = new DateFormat('dd-MMM-yyyy');
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
 //   today = new TextEditingController();
   // today.text = formatter.format(DateTime.now());
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
          //Divider(height: 2.0,),
          getEmployee_DD(),
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
                  text: 'Late \nComing',
                ),
                new Tab(
                  text: 'Early \nLeaving',
                ),
              ],
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 40.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.42,
                child:Text('  Date',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),

              SizedBox(height: 40.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.20,
                child:Text('Time In',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
              SizedBox(height: 40.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.20,
                child:Text('Time Out',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
            ],
          ),
          new Divider(height: 1.0,),
          res==true?new Container(
            height: MediaQuery.of(context).size.height*.50,
            child: new TabBarView(
              controller: _controller,
              children: <Widget>[
                new Container(
                  height: MediaQuery.of(context).size.height*0.35,
                  //   shape: Border.all(color: Colors.deepOrange),
                  child: new ListTile(
                    title:
                    Container( height: MediaQuery.of(context).size.height*30,
                      width: MediaQuery.of(context).size.width*.99,
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Attn>>(
                        future: getEmpHistoryOf30('present',emp),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[
                                              SizedBox(height: 40.0,),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.42,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(snapshot.data[index].Name
                                                        .toString(), style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0),),

                                                    InkWell(
                                                      child: Text('Time In: ' +
                                                          snapshot.data[index]
                                                              .CheckInLoc.toString(),
                                                          style: TextStyle(
                                                              color: Colors.black54,
                                                              fontSize: 12.0)),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitIn ,
                                                            snapshot.data[index]
                                                                .LongiIn);
                                                      },
                                                    ),
                                                    SizedBox(height:2.0),
                                                    InkWell(
                                                      child: Text('Time Out: ' +
                                                          snapshot.data[index]
                                                              .CheckOutLoc.toString(),
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 12.0),),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitOut,
                                                            snapshot.data[index]
                                                                .LongiOut);
                                                      },
                                                    ),
                                                    SizedBox(height: 15.0,),


                                                  ],
                                                ),
                                              ),

                                              Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.20,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Text(snapshot.data[index].TimeIn
                                                          .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                      GestureDetector(
                                                        onTap: (){
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].EntryImage,org_name: "Ubitech Solutions")),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: 62.0,
                                                          height: 62.0,
                                                          child: Container(
                                                              decoration: new BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image: new DecorationImage(
                                                                      fit: BoxFit.fill,
                                                                      image: new NetworkImage(
                                                                          snapshot
                                                                              .data[index]
                                                                              .EntryImage)
                                                                  )
                                                              )),),
                                                      ),

                                                    ],
                                                  )

                                              ),
                                              Flexible(
                                                child: Container(
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width * 0.20,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: <Widget>[
                                                        Text(snapshot.data[index].TimeOut
                                                            .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                        GestureDetector(
                                                          onTap: (){
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].ExitImage,org_name: "Ubitech Solutions")),
                                                            );
                                                          },
                                                          child: Container(
                                                            width: 62.0,
                                                            height: 62.0,
                                                            child: Container(
                                                                decoration: new BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    image: new DecorationImage(
                                                                        fit: BoxFit.fill,
                                                                        image: new NetworkImage(
                                                                            snapshot
                                                                                .data[index]
                                                                                .ExitImage)
                                                                    )
                                                                )),),
                                                        ),

                                                      ],
                                                    )

                                                ),
                                              ),
                                            ],

                                          ),
                                          Divider(color: Colors.black26,),
                                        ]);}
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
                            //  return new Text("${snapshot.error}");
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
                        future: getEmpHistoryOf30('absent',emp),
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
                                              .width * 0.42,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              Text(snapshot.data[index].Name
                                                  .toString(), style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),),
                                            ],
                                          ),
                                        ),

                                        Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.20,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                Text(snapshot.data[index].TimeIn
                                                    .toString()),
                                              ],
                                            )

                                        ),
                                        Flexible(
                                          child:Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.20,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                Text(snapshot.data[index].TimeOut
                                                    .toString()),
                                              ],
                                            )
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
                                  child:Text("No Employees found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                                ),
                              );
                            }
                          }
                          else if (snapshot.hasError) {
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
                        future: getEmpHistoryOf30('latecomings',emp),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[
                                              SizedBox(height: 40.0,),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.42,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(snapshot.data[index].Name
                                                        .toString(), style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0),),

                                                    InkWell(
                                                      child: Text('Time In: ' +
                                                          snapshot.data[index]
                                                              .CheckInLoc.toString(),
                                                          style: TextStyle(
                                                              color: Colors.black54,
                                                              fontSize: 12.0)),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitIn ,
                                                            snapshot.data[index]
                                                                .LongiIn);
                                                      },
                                                    ),
                                                    SizedBox(height:2.0),
                                                    InkWell(
                                                      child: Text('Time Out: ' +
                                                          snapshot.data[index]
                                                              .CheckOutLoc.toString(),
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 12.0),),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitOut,
                                                            snapshot.data[index]
                                                                .LongiOut);
                                                      },
                                                    ),
                                                    SizedBox(height: 15.0,),


                                                  ],
                                                ),
                                              ),

                                              Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.20,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Text(snapshot.data[index].TimeIn
                                                          .toString(),style: TextStyle(fontWeight: FontWeight.bold),),

                                                      Container(
                                                          width: 62.0,
                                                          height: 62.0,
                                                          child: InkWell(
                                                            child: Container(
                                                                decoration: new BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    image: new DecorationImage(
                                                                        fit: BoxFit.fill,
                                                                        image: new NetworkImage(
                                                                            snapshot
                                                                                .data[index]
                                                                                .EntryImage)
                                                                    )
                                                                )),
                                                            onTap: (){
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].EntryImage,org_name: "Ubitech Solutions")),
                                                              );
                                                            },
                                                          ),),


                                                    ],
                                                  )
                                              ),

                                              Flexible(
                                                child: Container(
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width * 0.20,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: <Widget>[
                                                        Text(snapshot.data[index].TimeOut
                                                            .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                        Container(
                                                            width: 62.0,
                                                            height: 62.0,
                                                            child: InkWell(
                                                              child: Container(
                                                                  decoration: new BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      image: new DecorationImage(
                                                                          fit: BoxFit.fill,
                                                                          image: new NetworkImage(
                                                                              snapshot
                                                                                  .data[index]
                                                                                  .ExitImage)
                                                                      )
                                                                  )),
                                                              onTap: (){
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].ExitImage,org_name: "Ubitech Solutions")),
                                                                );
                                                              },
                                                            ),),


                                                      ],
                                                    )

                                                ),
                                              ),
                                            ],

                                          ),
                                          Divider(color: Colors.black26,),
                                        ]);}
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
                        future: getEmpHistoryOf30('earlyleavings',emp),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[
                                              SizedBox(height: 40.0,),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.42,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(snapshot.data[index].Name
                                                        .toString(), style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0),),

                                                    InkWell(
                                                      child: Text('Time In: ' +
                                                          snapshot.data[index]
                                                              .CheckInLoc.toString(),
                                                          style: TextStyle(
                                                              color: Colors.black54,
                                                              fontSize: 12.0)),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitIn ,
                                                            snapshot.data[index]
                                                                .LongiIn);
                                                      },
                                                    ),
                                                    SizedBox(height:2.0),
                                                    InkWell(
                                                      child: Text('Time Out: ' +
                                                          snapshot.data[index]
                                                              .CheckOutLoc.toString(),
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 12.0),),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitOut,
                                                            snapshot.data[index]
                                                                .LongiOut);
                                                      },
                                                    ),
                                                    SizedBox(height: 15.0,),


                                                  ],
                                                ),
                                              ),

                                              Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.20,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Text(snapshot.data[index].TimeIn
                                                          .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                      GestureDetector(
                                                        onTap: (){
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].EntryImage,org_name: "Ubitech Solutions")),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: 62.0,
                                                          height: 62.0,
                                                          child: Container(
                                                              decoration: new BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image: new DecorationImage(
                                                                      fit: BoxFit.fill,
                                                                      image: new NetworkImage(
                                                                          snapshot
                                                                              .data[index]
                                                                              .EntryImage)
                                                                  )
                                                              )),),
                                                      ),

                                                    ],
                                                  )

                                              ),
                                              Flexible(
                                                child: Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.20,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Text(snapshot.data[index].TimeOut
                                                          .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                      GestureDetector(
                                                        onTap: (){
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].ExitImage,org_name: "Ubitech Solutions")),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: 62.0,
                                                          height: 62.0,
                                                          child: Container(
                                                              decoration: new BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image: new DecorationImage(
                                                                      fit: BoxFit.fill,
                                                                      image: new NetworkImage(
                                                                          snapshot
                                                                              .data[index]
                                                                              .ExitImage)
                                                                  )
                                                              )),),
                                                      ),

                                                    ],
                                                  )
                                                ),
                                              ),
                                            ],

                                          ),
                                          Divider(color: Colors.black26,),
                                        ]);}
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

  Widget getEmployee_DD() {
    String dc = "0";
    return new FutureBuilder<List<Map>>(
        future: getEmployeesList(0),// with -select- label
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

                  child: new DropdownButton<String>(
                    isDense: true,
                    style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.black
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
                            child: map["Code"]!=''&&map["Code"]!='null'?new Text(map["Name"]+' ('+map["Code"]+')'): new Text(map["Name"],)
                        ),
                      );
                    }).toList(),

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


}
