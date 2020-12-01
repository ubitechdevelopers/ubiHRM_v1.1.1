// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/attandance/outside_label.dart';
//import 'package:simple_share/simple_share.dart';
import 'package:ubihrm/services/attandance_services.dart';

import './image_view.dart';
import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';

// This app is a stateful, it tracks the user's current choice.
class CustomDateAttendance extends StatefulWidget {
  @override
  _CustomDateAttendance createState() => _CustomDateAttendance();
}
TextEditingController today;
class _CustomDateAttendance extends State<CustomDateAttendance> with SingleTickerProviderStateMixin {
  TabController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String countP='0',countA='0',countL='0',countE='0';
  Future<List<Attn>> _listFuture1,_listFuture2,_listFuture3,_listFuture4;
  List presentlist= new List(), absentlist= new List(), latecommerlist= new List(),earlyleaverlist= new List();
  String _orgName;
  var formatter = new DateFormat('dd-MMM-yyyy');
  var profileimage;
  bool showtabbar;
  String orgName="";
  bool filests=false;
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
    getOrgName();
    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
    showtabbar =false;
    profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);
    //setAlldata();
  }
  //****___setAlldata comment
  /*setAlldata(){
    _listFuture1 = getCDateAttn('present',today.text);
    _listFuture2 = getCDateAttn('absent',today.text);
    _listFuture3 = getCDateAttn('latecomings',today.text);
    _listFuture4 = getCDateAttn('earlyleavings',today.text);

    _listFuture1.then((data) async{
      setState(() {
        presentlist = data;
        countP = data.length.toString();
      });
    });

    _listFuture2.then((data) async{
      setState(() {
        absentlist = data;
        countA = data.length.toString();
      });
    });

    _listFuture3.then((data) async{
      setState(() {
        latecommerlist = data;
        countL = data.length.toString();
      });
    });

    _listFuture4.then((data) async{
      setState(() {
        earlyleaverlist = data;
        countE= data.length.toString();
      });
    });
  }*/

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
            //height:MediaQuery.of(context).size.height*0.75,
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
                  child: Center(child:Text("Daily Attendance",style: TextStyle(fontSize: 20.0,color: appStartColor()),),),
                ),
                Row(
                  children: <Widget>[
                      Expanded(
                        child: Container(
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
                                  lastDate: DateTime.now());
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
                                  res=true; //showInSnackBar(date.toString());
                                  //setAlldata();

                                }else {
                                  res=false;
                                  countP='0';
                                  countA='0';
                                  countE='0';
                                  countL='0';
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
                      ),
                      /*Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child:(res == false)?
                      Center():Container(
                          color: Colors.white,
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: new Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                (presentlist.length > 0 || absentlist.length > 0 || latecommerlist.length > 0 || earlyleaverlist.length > 0)
                                    ?Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height:  60,
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
                                              'Custom_date_Report_' + today.text,
                                              'cust').then((res) {
                                            print('snapshot.data');

                                            if(mounted){
                                              setState(() {
                                                filests = false;
                                              });
                                            }
                                            // showInSnackBar('CSV has been saved in file storage in ubiattendance_files/Department_Report_'+today.text+'.csv');
                                            dialogwidget(
                                                "CSV has been saved in internal storage in ubihrm_files/Custom_date_Report_" +
                                                    today.text + ".csv", res);

                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width:8,
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
                                           final uri = Uri.file('/storage/emulated/0/ubiattendance_files/Designation_Wise_Report_14-Jun-2019.pdf');
                                          SimpleShare.share(
                                              uri: uri.toString(),
                                              title: "Share my file",
                                              msg: "My message");
                                          if (mounted) {
                                            setState(() {
                                              filests = true;
                                            });
                                          }
                                          CreatePDFAll(
                                              presentlist,
                                              absentlist,
                                              latecommerlist,
                                              earlyleaverlist,
                                              'Custom Date Report ('+today.text+')',
                                              'Custom_date_Report_' + today.text,
                                              'cust')
                                              .then((res) {
                                            if(mounted) {
                                              setState(() {
                                                filests =
                                                false;
                                                // OpenFile.open("/sdcard/example.txt");
                                              });
                                            }
                                            dialogwidget(
                                                'PDF has been saved in internal storage in ubihrm_files/' +
                                                    'Custom_date_Report_' + today.text + '.pdf',
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
                                      child: Text("No CSV/PDF generated", textAlign: TextAlign.center,),
                                    )
                                ),
                              ]
                          )
                      ),
                    )*/
                  ],
                ),
                Divider(),
                res==true?new Container(
                  padding: EdgeInsets.all(0.1),
                  margin: EdgeInsets.all(0.1),
                  child: new ListTile(
                    title: new SizedBox(height: MediaQuery.of(context).size.height*0.20,
                      child: new FutureBuilder<List<Map<String,String>>>(
                          future: getChartDataCDate(today.text),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              //print("--------------->>>>>>>>");
                              // print(today);
                              if (snapshot.data.length > 0) {
                                return new PieOutsideLabelChart.withRandomData(snapshot.data);
                              }
                            }
                            return new Center( child: CircularProgressIndicator());
                          }
                      ),
                      //  child: new PieOutsideLabelChart.withRandomData(),
                      width: MediaQuery.of(context).size.width*1.0,),
                  ),
                ):Container(
                  height: MediaQuery.of(context).size.height*0.25,
                  child:Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width*1,
                      color:appStartColor().withOpacity(0.1),
                      padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                      child:Text("No chart available",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                    ),
                  ),
                ),
                res==true?new Row(
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
                ):Center(),
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 40.0,),
                    Container(
                      width: MediaQuery.of(context).size.width*0.45,
                      child:Text('  Name',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
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
                  height: MediaQuery.of(context).size.height*0.50,
                  child: new TabBarView(
                    controller: _controller,
                    children: <Widget>[
                      new Container(
                        height: MediaQuery.of(context).size.height*0.35,
                        //   shape: Border.all(color: Colors.deepOrange),
                        child: new ListTile(
                          title:
                          Container(
                            height: MediaQuery.of(context).size.height*30,
                            //width: MediaQuery.of(context).size.width*.99,
                            color: Colors.white,
                            //////////////////////////////////////////////////////////////////////---------------------------------
                            child: new FutureBuilder<List<Attn>>(
                              future: getCDateAttn('present',today.text),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if(snapshot.data.length>0) {
                                    return new ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return new Column(
                                              children: <Widget>[
                                                /*(index == 0)?
                                          Row(
                                              children: <Widget>[
                                                //SizedBox(height: 25.0,),
                                                Container(
                                                  padding: EdgeInsets.only(left: 5.0),
                                                  child: Text("Total Present: ${countP}",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16.0,),),
                                                ),
                                              ]
                                          ):new Center(),
                                          (index == 0)?
                                          Divider(color: Colors.black26,):new Center(),*/
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    //SizedBox(height: 25.0,),
                                                    Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.45,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                                          //SizedBox(height: 15.0,),

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
                                                    //SizedBox(width:3.0),
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
                                    return new Container(
                                        height: MediaQuery.of(context).size.height*0.30,
                                        child:Center(
                                          child: Container(
                                            width: MediaQuery.of(context).size.width*1,
                                            color:appStartColor().withOpacity(0.1),
                                            padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                            child:Text("No present employees found on this date",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                                          ),
                                        )
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
                              future:getCDateAttn('absent',today.text),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
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
                                                child: Text("Total Absent: ${countA}",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16.0,),),
                                              ),
                                            ]
                                        ):new Center(),
                                        (index == 0)?
                                        Divider(color: Colors.black26,):new Center(),*/
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
                                                                  .toString()),
                                                            ],
                                                          )

                                                      ),
                                                    ),
                                                  ],

                                                ),
                                              ]
                                          );
                                        }
                                    );
                                  }else{
                                    return new Container(
                                        height: MediaQuery.of(context).size.height*0.30,
                                        child:Center(
                                          child: Container(
                                            width: MediaQuery.of(context).size.width*1,
                                            color:appStartColor().withOpacity(0.1),
                                            padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                            child:Text("No absent employees found on this date",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                                          ),
                                        )
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
                              future:getCDateAttn('latecomings',today.text),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if(snapshot.data.length>0) {
                                    return new ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return new Column(
                                              children: <Widget>[
                                                /*(index == 0)?
                                          Row(
                                              children: <Widget>[
                                                //SizedBox(height: 25.0,),
                                                Container(
                                                  padding: EdgeInsets.only(left: 5.0),
                                                  child: Text("Total Late Comers: ${countL}",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16.0,),),
                                                ),
                                              ]
                                          ):new Center(),
                                          (index == 0)?
                                          Divider(color: Colors.black26,):new Center(),*/
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

                                                      ),),
                                                  ],

                                                ),
                                                Divider(color: Colors.black26,),
                                              ]);}
                                    );
                                  }else{
                                    return new Container(
                                        height: MediaQuery.of(context).size.height*0.30,
                                        child:Center(
                                          child: Container(
                                            width: MediaQuery.of(context).size.width*1,
                                            color:appStartColor().withOpacity(0.1),
                                            padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                            child:Text("No late comer employees found on this date",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                                          ),
                                        )
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
                              future: getCDateAttn('earlyleavings',today.text),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if(snapshot.data.length>0) {
                                    return new ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return new Column(
                                              children: <Widget>[
                                                /*(index == 0)?
                                          Row(
                                              children: <Widget>[
                                                //SizedBox(height: 25.0,),
                                                Container(
                                                  padding: EdgeInsets.only(left: 5.0),
                                                  child: Text("Total Early Leavers: ${countE}",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16.0,),),
                                                ),
                                              ]
                                          ):new Center(),
                                          (index == 0)?
                                          Divider(color: Colors.black26,):new Center(),*/
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
                                    return new Container(
                                        height: MediaQuery.of(context).size.height*0.25,
                                        child:Center(
                                          child: Container(
                                            width: MediaQuery.of(context).size.width*1,
                                            color:appStartColor().withOpacity(0.1),
                                            padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                            child:Text("No early leaver employees found on this date",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                                          ),
                                        )
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
                    child: Container(
                      width: MediaQuery.of(context).size.width*1,
                      color:appStartColor().withOpacity(0.1),
                      padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                      child:Text("Please select the date",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
