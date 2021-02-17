// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/services/attandance_services.dart';

import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';

// This app is a stateful, it tracks the user's current choice.
class EmployeeWise_att extends StatefulWidget {
  @override
  final String empid;
  DateTime month;
  final String empname;
  final String shift;
  final String shifttime;
  final String breaktime;

  EmployeeWise_att({Key key,  this.empid,  this.month,  this.empname,  this.shift,  this.shifttime,  this.breaktime}) : super(key: key);
  _EmployeeWise_att createState() => _EmployeeWise_att();
}
TextEditingController today;
class _EmployeeWise_att extends State<EmployeeWise_att> with SingleTickerProviderStateMixin {
  TabController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _orgName;
  String selectedmonth;
  var profileimage;
  bool showtabbar;
  String orgName="";
  bool filests=false;
  String emp='0';
  String empname= '';

  List presentlist= new List(), absentlist= new List(), latecommerlist= new List(), earlyleaverlist= new List();
  var formatter = new DateFormat('yyyy-MM-dd');
  var formatter1 = new DateFormat('MMMM yyyy');
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

  static const rowSpacer=TableRow(
      children: [
        SizedBox(
          height: 0,
        ),
        SizedBox(
          height: 0,
        )
      ]);

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 4, vsync: this);
    showtabbar =false;
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    getOrgName();
    //setAlldata();
    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: new Scaffold(
        key: _scaffoldKey,
        backgroundColor:scaffoldBackColor(),
        appBar: new AppHeader(profileimage, showtabbar,orgName),
        endDrawer: new AppDrawer(),
        bottomNavigationBar: HomeNavigation(),
        body: getReportsWidget(),
      ),
      onRefresh: () async {
        Completer<Null> completer = new Completer<Null>();
        await Future.delayed(Duration(seconds: 1)).then((onvalue) {
          completer.complete();
        });
        return completer.future;
      },
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
                Padding(
                  padding: const EdgeInsets.only(left:0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            child: Center(child:Text(widget.empname,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: appStartColor()), textAlign: TextAlign.center,),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                new Container(
                  child: Center(child:Text("["+ formatter1.format(widget.month).toString()+ "]",style: TextStyle(fontSize: 16.0, color: Colors.black54),),),
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      child: Center(child:Text("Shift: ",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: appStartColor())),),
                    ),
                    new Container(
                      child: Center(child:Text(widget.shift +" ["+ widget.shifttime +"]",style: TextStyle(fontSize: 16.0,color: Colors.black54),),),
                    ),
                  ],
                ),
                /*SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                child: Center(child:Text("Shift Time: ",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: appStartColor())),),
              ),
              new Container(
                child: Center(child:Text(widget.shifttime,style: TextStyle(fontSize: 16.0,color: Colors.black54),),),
              ),
            ],
          ),*/
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      child: Center(child:Text("Break Time: ",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: appStartColor()),),),
                    ),
                    new Container(
                      child: Center(child:Text(widget.breaktime,style: TextStyle(fontSize: 16.0,color: Colors.black54),),),
                    ),
                  ],
                ),

/*          Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child:(emp != '0')?Container(
                      color: Colors.white,
                      height: 65,
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: new Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            (presentlist.length > 0 || absentlist.length > 0 || latecommerlist.length > 0 || earlyleaverlist.length > 0)?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height:  65,
                                ),
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
                                      *//*final uri = Uri.file('/storage/emulated/0/ubiattendance_files/Employee_Wise_Report_14-Jun-2019.pdf');
                                    SimpleShare.share(
                                        uri: uri.toString(),
                                        title: "Share my file",
                                        msg: "My message");*//*
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
                            ):Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top:12.0),
                                  child: Text("No CSV/Pdf generated", textAlign: TextAlign.center,),
                                )
                            )
                          ]
                      )
                  ):Center()
              )
            ],
          ),*/
                SizedBox(height: 10.0,),

                Divider(height: 0.5),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 40.0,),
                    Container(
                      width: MediaQuery.of(context).size.width*0.18,
                      child:Text('  Date',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                    ),
                    SizedBox(height: 40.0,),
                    Container(
                        width: MediaQuery.of(context).size.width*0.22,
                        child:Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text('Status',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: new Container(
                                    //alignment: Alignment.topLeft,
                                    child:InkWell(
                                      child: Icon(Icons.info, color: appStartColor(),),
                                      onTap: (){
                                        showDialog<String>(
                                            context: context,
                                            // ignore: deprecated_member_use
                                            child: AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              //contentPadding: const EdgeInsets.all(15.0),
                                              content: Wrap(
                                                children: <Widget>[
                                                  Container(
                                                    //height: MediaQuery.of(context).size.height,
                                                    width: MediaQuery.of(context).size.width * 0.90,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        new Text('Help Guide',
                                                          style: TextStyle(
                                                              color: Colors.black87,
                                                              fontSize: 18.0,
                                                              fontWeight: FontWeight.w600
                                                          ),
                                                        ),
                                                        SizedBox(height: 20,),
                                                        Table(
                                                          defaultVerticalAlignment: TableCellVerticalAlignment.top,
                                                          columnWidths: {
                                                            0: FlexColumnWidth(25),
                                                            // 0: FlexColumnWidth(4.501), // - is ok
                                                            // 0: FlexColumnWidth(4.499), //- ok as well
                                                            1: FlexColumnWidth(10),
                                                          },
                                                          children: [
                                                            TableRow(
                                                                children: [
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        new Text(
                                                                          'Present',
                                                                          style: TextStyle(
                                                                              color: Colors.blueAccent,
                                                                              fontSize: 15.0,
                                                                              fontWeight: FontWeight
                                                                                  .bold
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: Text('P',
                                                                            style: TextStyle(
                                                                                color: Colors.blueAccent,
                                                                                fontSize: 15.0,
                                                                                fontWeight: FontWeight
                                                                                    .w400
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ]
                                                            ),
                                                            TableRow(
                                                                children: [
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        new Text(
                                                                          'Absent',
                                                                          style: TextStyle(
                                                                              color: Colors.red,
                                                                              fontSize: 15.0,
                                                                              fontWeight: FontWeight
                                                                                  .bold
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: Text(
                                                                            'A',
                                                                            style: TextStyle(
                                                                                color: Colors.red,
                                                                                fontSize: 15.0,
                                                                                fontWeight: FontWeight
                                                                                    .w400
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ]
                                                            ),
                                                            TableRow(
                                                                children: [
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        new Text(
                                                                          'Week Off',
                                                                          style: TextStyle(
                                                                              color:Colors.orange,
                                                                              fontSize: 15.0,
                                                                              fontWeight: FontWeight
                                                                                  .bold
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: Text(
                                                                            'W',
                                                                            style: TextStyle(
                                                                                color:Colors.orange,
                                                                                fontSize: 15.0,
                                                                                fontWeight: FontWeight
                                                                                    .w400
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ]
                                                            ),
                                                            TableRow(
                                                                children: [
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        new Text(
                                                                          'Half Day',
                                                                          style: TextStyle(
                                                                              color:Colors.blueGrey,
                                                                              fontSize: 15.0,
                                                                              fontWeight: FontWeight
                                                                                  .bold
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: Text(
                                                                            'HD',
                                                                            style: TextStyle(
                                                                                color: Colors.blueGrey,
                                                                                fontSize: 15.0,
                                                                                fontWeight: FontWeight
                                                                                    .w400
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ]
                                                            ),
                                                            TableRow(
                                                                children: [
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        new Text(
                                                                          'Holiday',
                                                                          style: TextStyle(
                                                                              color:Colors.green,
                                                                              fontSize: 15.0,
                                                                              fontWeight: FontWeight
                                                                                  .bold
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: Text(
                                                                            'H',
                                                                            style: TextStyle(
                                                                                color: Colors.green,
                                                                                fontSize: 15.0,
                                                                                fontWeight: FontWeight
                                                                                    .w400
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ]
                                                            ),
                                                            TableRow(
                                                                children: [
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        new Text(
                                                                          'Leave',
                                                                          style: TextStyle(
                                                                              color:Colors.lightBlueAccent,
                                                                              fontSize: 15.0,
                                                                              fontWeight: FontWeight
                                                                                  .bold
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: Text(
                                                                            'L',
                                                                            style: TextStyle(
                                                                                color:Colors.lightBlueAccent,
                                                                                fontSize: 15.0,
                                                                                fontWeight: FontWeight
                                                                                    .w400
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ]
                                                            ),
                                                            TableRow(
                                                                children: [
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        new Text(
                                                                          'Comp Off',
                                                                          style: TextStyle(
                                                                              color:Colors.purpleAccent,
                                                                              fontSize: 15.0,
                                                                              fontWeight: FontWeight
                                                                                  .bold
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: Text(
                                                                            'CO',
                                                                            style: TextStyle(
                                                                                color:Colors.purpleAccent,
                                                                                fontSize: 15.0,
                                                                                fontWeight: FontWeight
                                                                                    .w400
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ]
                                                            ),
                                                            TableRow(
                                                                children: [
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        new Text(
                                                                          'Work from Home',
                                                                          style: TextStyle(
                                                                              color:Colors.brown[200],
                                                                              fontSize: 15.0,
                                                                              fontWeight: FontWeight
                                                                                  .bold
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: Text(
                                                                            'WFH',
                                                                            style: TextStyle(
                                                                                color:Colors.brown[200],
                                                                                fontSize: 15.0,
                                                                                fontWeight: FontWeight
                                                                                    .w400
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ]
                                                            ),
                                                            TableRow(
                                                                children: [
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        new Text(
                                                                          'Unpaid Leave',
                                                                          style: TextStyle(
                                                                              color:Colors.brown,
                                                                              fontSize: 15.0,
                                                                              fontWeight: FontWeight
                                                                                  .bold
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: Text(
                                                                            'UL',
                                                                            style: TextStyle(
                                                                                color:Colors.brown,
                                                                                fontSize: 15.0,
                                                                                fontWeight: FontWeight
                                                                                    .w400
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ]
                                                            ),
                                                            TableRow(
                                                                children: [
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        new Text(
                                                                          'Half Day - Unpaid',
                                                                          style: TextStyle(
                                                                              color:Colors.grey,
                                                                              fontSize: 15.0,
                                                                              fontWeight: FontWeight
                                                                                  .bold
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: Text(
                                                                            'HDU',
                                                                            style: TextStyle(
                                                                                color:Colors.grey,
                                                                                fontSize: 15.0,
                                                                                fontWeight: FontWeight
                                                                                    .w400
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ]
                                                            ),
                                                            TableRow(
                                                                children: [
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        new Text(
                                                                          'Present on Week Off',
                                                                          style: TextStyle(
                                                                              color:Colors.orange,
                                                                              fontSize: 15.0,
                                                                              fontWeight: FontWeight
                                                                                  .bold
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  TableCell(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: Text(
                                                                            'PW',
                                                                            style: TextStyle(
                                                                                color:Colors.orange,
                                                                                fontSize: 15.0,
                                                                                fontWeight: FontWeight
                                                                                    .w400
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ]
                                                            ),
                                                          ],
                                                        ),

                                                      ],),

                                                  ),
                                                ],
                                              ),
                                            )
                                        );
                                      },),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                    ),
                    SizedBox(height: 40.0,),
                    Container(
                      width: MediaQuery.of(context).size.width*0.20,
                      child:Text('Time In',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                    ),
                    SizedBox(height: 40.0,),
                    Container(
                      width: MediaQuery.of(context).size.width*0.25,
                      child:Text('Time Out',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                    ),
                  ],
                ),
                new Divider(height: 1.0,),
                res==true?new Container(
                  height: MediaQuery.of(context).size.height*.45,
                  child: /*new TabBarView(
              controller: _controller,
              children: <Widget>[*/
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
                          future: getAttSummary(widget.empid, formatter.format(widget.month)),
                          builder: (context, snapshot) {
                            print("getAttSummary");
                            print(snapshot.hasData);
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
                                                InkWell(
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width * 0.25,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: <Widget>[
                                                        Text(snapshot.data[index].Date
                                                            .toString(), style: TextStyle(
                                                            color: appStartColor(),
                                                            //fontWeight: FontWeight.bold,
                                                            fontSize: 15.0, decoration: TextDecoration.underline),),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    showDialog<String>(
                                                      context: context,
                                                      // ignore: deprecated_member_use
                                                      child: AlertDialog(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        contentPadding: const EdgeInsets.all(15.0),
                                                        content: Wrap(
                                                          children: <Widget>[
                                                            Container(
                                                              //height: MediaQuery.of(context).size.height * 0.45,
                                                              width: MediaQuery.of(context).size.width * 0.90,
                                                              child: Column(
                                                                children: <Widget>[
                                                                  new Text(
                                                                    snapshot.data[index].FullDate.toString(),
                                                                    style: TextStyle(
                                                                        color: Colors.black87,
                                                                        fontSize: 18.0,
                                                                        fontWeight: FontWeight.w600
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 20,),
                                                                  Table(
                                                                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                                                                    columnWidths: {
                                                                      0: FlexColumnWidth(45),
                                                                      // 0: FlexColumnWidth(4.501), // - is ok
                                                                      // 0: FlexColumnWidth(4.499), //- ok as well
                                                                      1: FlexColumnWidth(35),
                                                                    },
                                                                    children: [
                                                                      TableRow(
                                                                          children: [
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  new Text(
                                                                                    'Status',
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .black87,
                                                                                        fontSize: 15.0,
                                                                                        fontWeight: FontWeight
                                                                                            .bold
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      snapshot.data[index].AttSts=='P'?"Present":
                                                                                      snapshot.data[index].AttSts=='A'?"Absent":
                                                                                      snapshot.data[index].AttSts=='W'?"Week Off":
                                                                                      snapshot.data[index].AttSts=='HD'?"Half Day":
                                                                                      snapshot.data[index].AttSts=='H'?"Holiday":
                                                                                      snapshot.data[index].AttSts=='L'?"Leave":
                                                                                      snapshot.data[index].AttSts=='CO'?"Comp Off":
                                                                                      snapshot.data[index].AttSts=='WFH'?"Work From Home":
                                                                                      snapshot.data[index].AttSts=='UL'?"Unpaid Leave":
                                                                                      snapshot.data[index].AttSts=='HDU'?"Half Day - Unpaid":
                                                                                      snapshot.data[index].AttSts=='PW'?"Present on Week Off":"-",
                                                                                      style: TextStyle(
                                                                                          color: snapshot.data[index].AttSts=='P'?Colors.blueAccent:
                                                                                          snapshot.data[index].AttSts=='A'?Colors.red:
                                                                                          snapshot.data[index].AttSts=='W'?Colors.orange:
                                                                                          snapshot.data[index].AttSts=='HD'?Colors.blueGrey:
                                                                                          snapshot.data[index].AttSts=='H'?Colors.green:
                                                                                          snapshot.data[index].AttSts=='L'?Colors.lightBlueAccent:
                                                                                          snapshot.data[index].AttSts=='CO'?Colors.purpleAccent:
                                                                                          snapshot.data[index].AttSts=='WFH'?Colors.brown[200]:
                                                                                          snapshot.data[index].AttSts=='UL'?Colors.brown:
                                                                                          snapshot.data[index].AttSts=='HDU'?Colors.grey:
                                                                                          snapshot.data[index].AttSts=='PW'?Colors.orange:Colors.grey,
                                                                                          fontSize: 15.0,
                                                                                          fontWeight: FontWeight
                                                                                              .w400
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ]
                                                                      ),
                                                                      TableRow(
                                                                          children: [
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  new Text(
                                                                                    'Time In',
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .black87,
                                                                                        fontSize: 15.0,
                                                                                        fontWeight: FontWeight
                                                                                            .bold
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      snapshot.data[index]
                                                                                          .TimeIn
                                                                                          .toString(),
                                                                                      style: TextStyle(
                                                                                          color: Colors
                                                                                              .black87,
                                                                                          fontSize: 15.0,
                                                                                          fontWeight: FontWeight
                                                                                              .w400
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ]
                                                                      ),
                                                                      TableRow(
                                                                          children: [
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  new Text(
                                                                                    'Time Out',
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .black87,
                                                                                        fontSize: 15.0,
                                                                                        fontWeight: FontWeight
                                                                                            .bold
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      snapshot.data[index]
                                                                                          .TimeOut
                                                                                          .toString(),
                                                                                      style: TextStyle(
                                                                                          color: Colors
                                                                                              .black87,
                                                                                          fontSize: 15.0,
                                                                                          fontWeight: FontWeight
                                                                                              .w400
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ]
                                                                      ),
                                                                      TableRow(
                                                                          children: [
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  new Text(
                                                                                    'Logged Hours',
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .black87,
                                                                                        fontSize: 15.0,
                                                                                        fontWeight: FontWeight
                                                                                            .bold
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      snapshot.data[index]
                                                                                          .TotalTime
                                                                                          .toString(),
                                                                                      style: TextStyle(
                                                                                          color: Colors
                                                                                              .black87,
                                                                                          fontSize: 15.0,
                                                                                          fontWeight: FontWeight
                                                                                              .w400
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ]
                                                                      ),
                                                                      TableRow(
                                                                          children: [
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  new Text(
                                                                                    'Late By',
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .black87,
                                                                                        fontSize: 15.0,
                                                                                        fontWeight: FontWeight
                                                                                            .bold
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      snapshot.data[index]
                                                                                          .LateComingHours
                                                                                          .toString(),
                                                                                      style: TextStyle(
                                                                                          color: Colors
                                                                                              .black87,
                                                                                          fontSize: 15.0,
                                                                                          fontWeight: FontWeight
                                                                                              .w400
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ]
                                                                      ),
                                                                      TableRow(
                                                                          children: [
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  new Text(
                                                                                    'Early Leaving By',
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .black87,
                                                                                        fontSize: 15.0,
                                                                                        fontWeight: FontWeight
                                                                                            .bold
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      snapshot.data[index]
                                                                                          .EarlyLeavingHours
                                                                                          .toString(),
                                                                                      style: TextStyle(
                                                                                          color: Colors
                                                                                              .black87,
                                                                                          fontSize: 15.0,
                                                                                          fontWeight: FontWeight
                                                                                              .w400
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ]
                                                                      ),
                                                                      TableRow(
                                                                          children: [
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  new Text(
                                                                                    'Overtime/Undertime:',
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .black87,
                                                                                        fontSize: 15.0,
                                                                                        fontWeight: FontWeight
                                                                                            .bold
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      snapshot.data[index]
                                                                                          .OverTime
                                                                                          .toString(),
                                                                                      style: TextStyle(
                                                                                          color: Colors
                                                                                              .black87,
                                                                                          fontSize: 15.0,
                                                                                          fontWeight: FontWeight
                                                                                              .w400
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ]
                                                                      ),
                                                                      TableRow(
                                                                          children: [
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  new Text(
                                                                                    'Time In Device',
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .black87,
                                                                                        fontSize: 15.0,
                                                                                        fontWeight: FontWeight
                                                                                            .bold
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      snapshot.data[index]
                                                                                          .Device
                                                                                          .toString(),
                                                                                      style: TextStyle(
                                                                                          color: Colors
                                                                                              .black87,
                                                                                          fontSize: 15.0,
                                                                                          fontWeight: FontWeight
                                                                                              .w400
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ]
                                                                      ),
                                                                      snapshot.data[index]
                                                                          .DeviceTimeOut
                                                                          .toString()!=""?TableRow(
                                                                          children: [
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  new Text(
                                                                                    'Time Out Device',
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .black87,
                                                                                        fontSize: 15.0,
                                                                                        fontWeight: FontWeight
                                                                                            .bold
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      snapshot.data[index]
                                                                                          .DeviceTimeOut
                                                                                          .toString(),
                                                                                      style: TextStyle(
                                                                                          color: Colors
                                                                                              .black87,
                                                                                          fontSize: 15.0,
                                                                                          fontWeight: FontWeight
                                                                                              .w400
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ]
                                                                      ):rowSpacer,
                                                                      snapshot.data[index]
                                                                          .TimeOffTime.toString()!=""?TableRow(
                                                                          children: [
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  new Text(
                                                                                    'Time Off Hours',
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .black87,
                                                                                        fontSize: 15.0,
                                                                                        fontWeight: FontWeight
                                                                                            .bold
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      snapshot.data[index]
                                                                                          .TimeOffTime.toString(),
                                                                                      style: TextStyle(
                                                                                          color: Colors
                                                                                              .black87,
                                                                                          fontSize: 15.0,
                                                                                          fontWeight: FontWeight
                                                                                              .w400
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ]
                                                                      ):rowSpacer,
                                                                      /*TableRow(
                                                                          children: [
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  new Text(
                                                                                    'Shift Hours:',
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .black87,
                                                                                        fontSize: 15.0,
                                                                                        fontWeight: FontWeight
                                                                                            .bold
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      snapshot.data[index]
                                                                                          .ShiftTime.toString(),
                                                                                      style: TextStyle(
                                                                                          color: Colors
                                                                                              .black87,
                                                                                          fontSize: 15.0,
                                                                                          fontWeight: FontWeight
                                                                                              .w400
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ]
                                                                      ),
                                                                      TableRow(
                                                                          children: [
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  new Text(
                                                                                    'Break Hours:',
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .black87,
                                                                                        fontSize: 15.0,
                                                                                        fontWeight: FontWeight
                                                                                            .bold
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            TableCell(
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      snapshot.data[index]
                                                                                          .BreakTime.toString(),
                                                                                      style: TextStyle(
                                                                                          color: Colors
                                                                                              .black87,
                                                                                          fontSize: 15.0,
                                                                                          fontWeight: FontWeight
                                                                                              .w400
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ]
                                                                      ),*/
                                                                    ],
                                                                  ),

                                                                ],),

                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context).size.width * 0.10,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      Text(snapshot.data[index].AttSts
                                                          .toString(), style: TextStyle(
                                                          color: snapshot.data[index].AttSts=='P'?Colors.blueAccent:
                                                          snapshot.data[index].AttSts=='A'?Colors.red:
                                                          snapshot.data[index].AttSts=='W'?Colors.orange:
                                                          snapshot.data[index].AttSts=='HD'?Colors.blueGrey:
                                                          snapshot.data[index].AttSts=='H'?Colors.green:
                                                          snapshot.data[index].AttSts=='L'?Colors.lightBlueAccent:
                                                          snapshot.data[index].AttSts=='CO'?Colors.purpleAccent:
                                                          snapshot.data[index].AttSts=='WFH'?Colors.brown[200]:
                                                          snapshot.data[index].AttSts=='UL'?Colors.brown:
                                                          snapshot.data[index].AttSts=='HDU'?Colors.grey:
                                                          snapshot.data[index].AttSts=='PW'?Colors.orange:Colors.grey,
                                                          //fontWeight: FontWeight.bold,
                                                          fontSize: 15.0),),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                    width: MediaQuery.of(context).size.width * 0.25,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: <Widget>[
                                                        Text(snapshot.data[index].TimeIn
                                                            .toString(),style: TextStyle(
                                                          //fontWeight: FontWeight.bold
                                                            fontSize: 15.0
                                                        ),),
                                                      ],
                                                    )

                                                ),
                                                Flexible(
                                                  child: Container(
                                                      width: MediaQuery.of(context).size.width * 0.35,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .center,
                                                        children: <Widget>[
                                                          Text(snapshot.data[index].TimeOut
                                                              .toString(),style: TextStyle(
                                                            //fontWeight: FontWeight.bold
                                                              fontSize: 15.0
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
                                    child:Text("No attendances found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
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

/*dialogwidget(msg, filename) {
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
  }*/



}
