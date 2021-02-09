// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_strip/month_picker_strip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/appbar.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/drawer.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/home.dart';
import 'package:ubihrm/model/model.dart';
import 'package:ubihrm/profile.dart';
import 'package:ubihrm/services/payroll_services.dart';
import 'package:ubihrm/services/services.dart';
import 'package:url_launcher/url_launcher.dart';

// This app is a stateful, it tracks the user's current choice.
class allPayrollSummary extends StatefulWidget {
  @override
  _allPayrollSummary createState() => _allPayrollSummary();
}

class _allPayrollSummary extends State<allPayrollSummary> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime selectedMonth;
  DateTime to;
  DateTime from;
  String payPeriodStart='';
  String payPeriodEnd='';
  var profileimage;
  bool showtabbar;
  String orgName="";
  String empname = "";
  bool _checkLoaded = true;
  int checkProcessing = 0;
  String location_addr = "";
  String location_addr1 = "";
  String admin_sts='0';
  String act = "";
  String act1 = "";
  String fname = "",
      lname = "",
      empid = "",
      email = "",
      status = "",
      orgid = "",
      orgdir = "",
      sstatus = "",
      org_name = "",
      desination = "",
      profile = "",
      latit = "",
      longi = "";
  String lid = "";
  String shiftId = "";

  TextEditingController client_name,comments;
  TextEditingController _searchController;
  FocusNode searchFocusNode;
  Widget mainWidget= new Container(width: 0.0,height: 0.0,);

  @override
  void initState() {
    client_name = new TextEditingController();
    comments = new TextEditingController();
    _searchController = new TextEditingController();
    searchFocusNode = FocusNode();
    super.initState();
    from = new DateTime.now();
    selectedMonth = new DateTime(from.year, from.month, 1);
    print("team's payroll");
    print(selectedMonth);
    initPlatformState();
    getOrgName();
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
  }

  @override
  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    //response = prefs.getInt('response') ?? 0;
    admin_sts = prefs.getString('sstatus') ?? 0.toString();

    setState(() {
      fname = prefs.getString('fname') ?? '';
      lname = prefs.getString('lname') ?? '';
      empid = prefs.getString('empid') ?? '';
      email = prefs.getString('email') ?? '';
      status = prefs.getString('status') ?? '';
      orgid = prefs.getString('orgid') ?? '';
      orgdir = prefs.getString('orgdir') ?? '';
      sstatus = prefs.getString('sstatus') ?? '';
      org_name = prefs.getString('org_name') ?? '';
      desination = prefs.getString('desination') ?? '';
      profile = prefs.getString('profile') ?? '';
      lid = prefs.getString('lid') ?? "0";
      showtabbar=false;
      profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
      profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __){
        if (mounted) {
          setState(() {
            _checkLoaded = false;
          });
        }
      }));

    });
  }

  @override
  Widget build(BuildContext context) {
    //return (response == 0) ? new LoginPage() : getmainhomewidget();
    return  getmainhomewidget();
  }

  getmainhomewidget() {
    return RefreshIndicator(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor:scaffoldBackColor(),
        endDrawer: new AppDrawer(),
        appBar: new AllPayrollAppHeader(profileimage,showtabbar,orgName),
        bottomNavigationBar:  new HomeNavigation(),
        body:getMarkAttendanceWidgit(),
      ),
      onRefresh: () async {
        Completer<Null> completer = new Completer<Null>();
        await Future.delayed(Duration(seconds: 1)).then((onvalue) {
          //_searchController.clear();
          completer.complete();
        });
        return completer.future;
      },
    );
  }

  Widget getMarkAttendanceWidgit() {
    //  double h_width = MediaQuery.of(context).size.width*0.5; // screen's 50%
    //  double f_width = MediaQuery.of(context).size.width*1;
   return Stack(
      children: <Widget>[
        Container(
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            //width: MediaQuery.of(context).size.width*0.9,
            //height:MediaQuery.of(context).size.height*0.75,
            decoration: new ShapeDecoration(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
              color: Colors.white,
            ),
            child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Center(child:Text("Team's Payroll", style: new TextStyle(fontSize: 22.0, color: appStartColor())),),
                  SizedBox(height: 5.0,),
                  Padding(
                    padding: const EdgeInsets.only(top:5.0, bottom:5.0),
                    child: new MonthStrip(
                      format: 'MMM yyyy',
                      from: fiscalStart==null?orgCreatedDate:fiscalStart,
                      to: selectedMonth,
                      initialMonth: selectedMonth,
                      height:  25.0,
                      viewportFraction: 0.25,
                      onMonthChanged: (v) {
                        setState(() {
                          selectedMonth = v;
                          print("selectedMonth");
                          print(selectedMonth);
                        });
                      },
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
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
                                suffixIcon: _searchController.text.isNotEmpty?IconButton(icon: Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      empname='';
                                    }
                                ):null,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  print("value");
                                  print(value);
                                  empname = value;
                                  if(value=="")
                                    empname='';
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0, bottom:8.0),
                    child: Center(
                      child:perPayroll=='1'?
                      Text(new DateFormat("MMM yyyy").format(selectedMonth),style: new TextStyle(fontSize: 16.0, color: Colors.black87, fontWeight: FontWeight.bold),):
                      payPeriodStart.isNotEmpty?
                      Text(payPeriodStart+" - "+payPeriodEnd,style: new TextStyle(fontSize: 16.0, color: Colors.black87, fontWeight: FontWeight.bold),):
                      Center()
                    ),
                  ),
                  new Divider(),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      new Expanded(
                        child:  Container(
                          width: MediaQuery.of(context).size.width*0.40,
                          child:Text('Name',style: TextStyle(color:Colors.orange[800],fontWeight:FontWeight.bold,fontSize: 16.0),),
                        ),
                      ),
                      //     SizedBox(width: MediaQuery.of(context).size.width*0.02),
                      new Expanded(
                        child:  Container(
                          width: MediaQuery.of(context).size.width*0.25,
                          margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                          child:Text(perPayroll=='1'?'Month':'Pay Period',style: TextStyle(color: Colors.orange[800],fontWeight:FontWeight.bold,fontSize: 16.0),),
                        ),
                      ),
                      //    SizedBox(height: 50.0,),
                      new Expanded(
                        child:  Container(
                          width: MediaQuery.of(context).size.width*0.17,
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child:Text('Amount',style: TextStyle(color: Colors.orange[800],fontWeight:FontWeight.bold,fontSize: 16.0),textAlign: TextAlign.right),
                        ),
                      ),

                      new Expanded(
                        child:  Container(
                          width: MediaQuery.of(context).size.width*0.15,
                          margin: EdgeInsets.only(left:26.0),
                          child:Text('Action',style: TextStyle(color:Colors.orange[800],fontWeight:FontWeight.bold,fontSize: 16.0),),
                        ),
                      ),
                    ],
                  ),
                  new Divider(),
                  new Expanded(
                    child:  Container(
                      height: MediaQuery.of(context).size.height*.55,
                      //width: MediaQuery.of(context).size.width*.99,
                      //padding: EdgeInsets.only(bottom: 15.0),
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Payroll>>(
                        future: getPayrollSummaryAll(empname, formatter.format(selectedMonth)),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0){
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    //DateTime payPeriodStart=DateTime.parse(snapshot.data[index].startdate);
                                    //DateTime payPeriodEnd=DateTime.parse(snapshot.data[index].enddate);
                                    payPeriodStart=snapshot.data[index].startdate.toString();
                                    print("payPeriodStart");
                                    print(payPeriodStart);
                                    payPeriodEnd=snapshot.data[index].enddate.toString();
                                    print("payPeriodEnd");
                                    print(payPeriodEnd);
                                    return new Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[

                                              //new Expanded(child:
                                              Container(
                                                  width: MediaQuery.of(context).size.width * 0.21,
                                                  //margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                                                  child: Text(
                                                      snapshot.data[index].name.toString(),style:TextStyle(fontWeight: FontWeight.bold)),
                                                ),
                                              //),

                                              //new Expanded(child:
                                              Container(
                                                    width: MediaQuery.of(context).size.width * 0.26,
                                                    //margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                                                    child: //Column(
                                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                                      //children: <Widget>[
                                                      Center(
                                                        child:snapshot.data[index].enddate.toString()==""?
                                                        Text(snapshot.data[index].startdate.toString()):
                                                        Text(snapshot.data[index].startdate.toString()+'\n         to \n'+snapshot.data[index].enddate.toString()),
                                                      ),
                                                    //],)
                                                ),
                                              //),

                                              //new Expanded(child:
                                              Container(
                                                  width: MediaQuery.of(context).size.width * 0.20,
                                                  //margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                                                  child:  Text(
                                                    snapshot.data[index].EmployeeCTC.toString()+" "+snapshot.data[index].Currency.toString(),style:TextStyle(),  textAlign: TextAlign.right,),
                                                ),
                                              //),

                                              //new Expanded( child:
                                              Container(
                                                  width: MediaQuery.of(context) .size .width * 0.15,
                                                  margin: EdgeInsets.only(left:25.0, right:0.0),
                                                  height: 28.0,
                                                  child: new OutlineButton(
                                                    onPressed: () async{
                                                      final prefs = await SharedPreferences.getInstance();
                                                      //String path1 = prefs.getString('path');
                                                      print(path+"viewpayrollslip/"+snapshot.data[index].id.toString()+"/1/"+orgdir+"/"+empid+"/"+grpCompanySts);
                                                      launchMap(path+"viewpayrollslip/"+snapshot.data[index].id.toString()+"/1/"+orgdir+"/"+empid+"/"+grpCompanySts);
                                                    },
                                                    child: new Icon(
                                                      Icons.print,
                                                      size: 17.0,
                                                      color: appStartColor(),
                                                    ),
                                                    borderSide: BorderSide(color:  appStartColor()),
                                                    padding:EdgeInsets.all(3.0),
                                                    shape: new CircleBorder(),
                                                  ),
                                                ),
                                              //)

                                            ],
                                          ),
                                          //SizedBox(width: 30.0,),
                                          Divider(color: Colors.black45,),
                                        ]);
                                  }
                              );
                            }else {
                              payPeriodStart='';
                              payPeriodEnd='';
                              return new Center(
                                child: Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 1,
                                  color: appStartColor().withOpacity(0.1),
                                  padding: EdgeInsets.only(
                                      top: 5.0, bottom: 5.0),
                                  child: Text("No Records",
                                    style: TextStyle(fontSize: 16.0),
                                    textAlign: TextAlign.center,),
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
                    ),),

                ])
        ),

      ],
    );
  }

  launchMap(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print( 'Could not launch $url');
    }
  }

  getPunchPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('getPunchPrefs called: new lid- '+ prefs.getString('lid').toString());
    return prefs.getString('lid');
  }
/////////////////////futere method dor getting today's punched liist-start
/////////////////////futere method dor getting today's punched liist-close
}

class AllPayrollAppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;
  AllPayrollAppHeader(profileimage1,showtabbar1,orgname1){
    profileimage = profileimage1;
    orgname = orgname1;
    if (profileimage!=null) {
      _checkLoadedprofile = false;
    };
    showtabbar= showtabbar1;
  }

  @override
  Widget build(BuildContext context) {
    return new GradientAppBar(
        backgroundColorStart: appStartColor(),
        backgroundColorEnd: appEndColor(),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(icon:Icon(Icons.arrow_back),
              onPressed:(){
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageMain()), (Route<dynamic> route) => false,
                );
              },),
            GestureDetector(
              // When the child is tapped, show a snackbar
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CollapsingTab()),
                );
              },
              child:Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        // image: AssetImage('assets/avatar.png'),
                        image: _checkLoadedprofile ? AssetImage('assets/default.png') : profileimage,
                      )
                  )
              ),
            ),
            Flexible(
              child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(orgname, overflow: TextOverflow.ellipsis,)
              ),
            )
          ],
        ),
        bottom:
        showtabbar==true ? TabBar(
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: choices.map((Choice choice) {
            return Tab(
              text: choice.title,
            );
          }).toList(),
        ):null
    );
  }
  @override
  Size get preferredSize => new Size.fromHeight(showtabbar==true ? 100.0 : 60.0);

}
