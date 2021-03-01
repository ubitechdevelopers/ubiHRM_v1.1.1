import 'dart:async';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:simple_share/simple_share.dart';
import 'package:ubihrm/services/attandance_services.dart';

import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';

class OutSideGeoFence extends StatefulWidget {
  @override
  _OutSideGeoFence createState() => _OutSideGeoFence();
}
TextEditingController today;

//FocusNode f_dept ;
class _OutSideGeoFence extends State<OutSideGeoFence> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 1;
  String _orgName;
  String admin_sts='0';
  bool res = true;
  var profileimage;
  bool showtabbar;
  String orgName="";
  String empname="";
  String count='0';
  bool filests=false;
  TextEditingController _searchController;
  FocusNode searchFocusNode;
  //Future<List<OutsideAttendance>> _listFuture;

  String emp='0';

  var formatter = new DateFormat('dd-MMM-yyyy');
  @override
  void initState() {
    super.initState();
    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
    _searchController = new TextEditingController();
    searchFocusNode = FocusNode();
    showtabbar =false;
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    getOrgName();
    //_listFuture = getOutsidegeoReport(today.text,emp);
  }

  getOrgName() async {
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

  getmainhomewidget() {
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
          setState(() {
            today.text = formatter.format(DateTime.now());
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

            //   padding: EdgeInsets.only(left: 2.0, right: 2.0),
            child: Column(
              children: <Widget>[
                //SizedBox(height: 1.0),
                Center(
                  child: Text(
                    'Outside Geo Fence',
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: appStartColor(),
                    ),
                  ),
                ),
                /*Divider(
                  height: 10.0,
                ),*/
                //SizedBox(height: 2.0),
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
                              if (date != null && date.toString() != '') {
                                res=true; //showInSnackBar(date.toString());
                              } else {
                                res=false;
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
                      Center()
                          :Container(
                          color: Colors.white,
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: new FutureBuilder<List<OutsideAttendance>>(
                              future: _listFuture,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data.length > 0) {
                                    return new ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data.length,
                                        itemBuilder:(BuildContext context, int index) {
                                          return new Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                (index == 0)
                                                    ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height:  60,
                                                    ),
                                                    Container(
                                                      //padding: EdgeInsets.only(left: 5.0),
                                                      child: InkWell(
                                                        child: Text(
                                                          'CSV',
                                                          style: TextStyle(
                                                            decoration:
                                                            TextDecoration
                                                                .underline,
                                                            color: Colors
                                                                .blueAccent,
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
                                                          getCsv(
                                                              snapshot.data,
                                                              'Outside_Geo_Fence_Report_' + today.text,
                                                              'outside')
                                                              .then((res) {
                                                            if(mounted){
                                                              setState(() {
                                                                filests = false;
                                                              });
                                                            }
                                                            // showInSnackBar('CSV has been saved in file storage in ubiattendance_files/Department_Report_'+today.text+'.csv');
                                                            dialogwidget(
                                                                "CSV has been saved in internal storage in ubihrm_files/Early_Leavers_Report_" +
                                                                    today.text +
                                                                    ".csv",
                                                                res);
                                                            *//*showDialog(context: context, child:
                                                        new AlertDialog(
                                                          content: new Text("CSV has been saved in file storage in ubiattendance_files/Early_Leavers_Report_"+today.text+".csv"),
                                                        )
                                                        );*//*
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
                                                        child: Text(
                                                          'PDF',
                                                          style: TextStyle(
                                                            decoration:
                                                            TextDecoration
                                                                .underline,
                                                            color: Colors
                                                                .blueAccent,
                                                            fontSize: 16,),
                                                        ),
                                                        onTap: () {
                                                          *//* final uri = Uri.file('/storage/emulated/0/ubiattendance_files/Early_Leavers_Report_14-Jun-2019.pdf');
                                                      SimpleShare.share(
                                                          uri: uri.toString(),
                                                          title: "Share my file",
                                                          msg: "My message");*//*
                                                          if (mounted) {
                                                            setState(() {
                                                              filests = true;
                                                            });
                                                          }
                                                          CreatePDF(
                                                              snapshot.data,
                                                              'Outside Geo Fence Report ('+today.text+')',
                                                              snapshot.data.length.toString(),
                                                              'Outside_Geo_Fence_Report_' + today.text,
                                                              'outside'
                                                          ).then((res) {
                                                            if(mounted) {
                                                              setState(() {
                                                                filests =false;
                                                                // OpenFile.open("/sdcard/example.txt");
                                                              });
                                                            }
                                                            dialogwidget(
                                                                'PDF has been saved in internal storage in ubihrm_files/' +
                                                                    'Outside_Geo_Fence_Report_' + today.text + '.pdf',
                                                                res);
                                                            // showInSnackBar('PDF has been saved in file storage in ubiattendance_files/'+'Department_Report_'+today.text+'.pdf');
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ):new Center(),
                                              ]
                                          );
                                        }
                                    );
                                  }
                                }
                                return new Center(
                                  //child: Text("No CSV/PDF generated", textAlign: TextAlign.center,),
                                );
                              }
                          )
                      ),
                    )*/
                  ],
                ),
                today.text.isNotEmpty?Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
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
                                res = true;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ):Center(),
                //getEmployee_DD(),
                Divider(
                  height: 5,
                ),
                //SizedBox(height: 5.0),
                Container(
                  //  padding: EdgeInsets.only(bottom:10.0,top: 10.0),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width *1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.28,
                        child: Text(
                          '  Name',
                          style: TextStyle(color: appStartColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.35,
                        child: Text(
                          'Time In',
                          style: TextStyle(color: appStartColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.20,
                        child: Text('Time Out',
                            style: TextStyle(color: appStartColor(),
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                            textAlign: TextAlign.left),
                      ),
                    ],
                  ),
                ),
                //SizedBox(height: 5.0),
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
        ] );
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
    return new FutureBuilder<List<OutsideAttendance>>(
        future: getOutsidegeoReport(today.text,empname),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            count=snapshot.data.length.toString();
            if (snapshot.data.length > 0) {
              return new ListView.builder(
                  itemCount: snapshot.data.length,
                  //    padding: EdgeInsets.only(left: 15.0,right: 15.0),
                  itemBuilder: (BuildContext context, int index) {
                    return new Container(
                      //          width: MediaQuery.of(context).size.width * .9,
                      child:Column(
                          children: <Widget>[
                            SizedBox(height: 5.0,),
                            (index == 0)?
                            Row(
                                children: <Widget>[
                                  //SizedBox(height: 25.0,),
                                  Container(
                                    padding: EdgeInsets.only(left: 5.0),
                                    child: Text("Total: ${count}",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16.0,),),
                                  ),
                                ]
                            ):new Center(),
                            (index == 0)?
                            Divider(color: Colors.black26,):new Center(),
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment : MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(width: 8.0,),
                                Expanded(
                                  flex: 20,
                                  child:  new Container(
                                      width: MediaQuery.of(context).size.width * 0.18,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(
                                            snapshot.data[index].empname.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13.0),textAlign: TextAlign.left,),
                                        ],
                                      )),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(""),
                                ),
                                Expanded(
                                  flex: 37,
                                  child:  new Container(
                                    //width: MediaQuery.of(context).size.width * 0.37,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        /* new Text(
                                    snapshot.data[index].client.toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,
                                  ),*/
                                        InkWell(
                                          child:Text(
                                            snapshot.data[index].locationin.toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                          onTap: () {
                                            goToMap(snapshot.data[index].latin,snapshot.data[index].lonin.toString());
                                          },
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(2.0),
                                          color: snapshot.data[index].incolor.toString()=='0'?Colors.red:Colors.green,

                                          child: Text(snapshot.data[index].instatus,
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0,color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(""),
                                ),
                                Expanded(
                                  flex: 37,
                                  child:  new Container(
                                    // width: MediaQuery.of(context).size.width * 0.37,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[


                                        InkWell(
                                          child:Text(
                                            snapshot.data[index].locationout.toString(),
                                            style: TextStyle
                                              (
                                                color: Colors.black54,fontSize: 12.0
                                            ),
                                          ),
                                          onTap: ()
                                          {
                                            goToMap(
                                                snapshot.data[index].latout.toString(),
                                                snapshot.data[index].lonout.toString()
                                            );
                                          },
                                        ),
                                        snapshot.data[index].outstatus!=''?
                                        new Container(
                                          padding: EdgeInsets.all(2.0),

                                          color: snapshot.data[index].outcolor.toString()=='0'?Colors.red:Colors.green,
                                          child: Text(snapshot.data[index].outstatus,
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0,color: Colors.white),
                                          ),
                                        ):Center(child: Text("-"),),
                                      ],
                                    ),
                                  ),
                                ),
                                /*
                            Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.19,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center,
                                  children: <Widget>[
                                    Text(snapshot.data[index].timein
                                        .toString(),style: TextStyle(fontWeight: FontWeight.bold),),

                                    Text(snapshot.data[index].attdate
                                        .toString(),style: TextStyle(color: Colors.grey),),
                                  ],
                                )

                            ),
                            Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.22,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center,
                                  children: <Widget>[
                                    Text(snapshot.data[index].timein
                                        .toString(),style: TextStyle(fontWeight: FontWeight.bold),),

                                    Text(snapshot.data[index].attdate .toString(),style: TextStyle(color: Colors.grey
                                    ),),
                                  ],
                                )

                            ),*/
                              ],
                            ),

                            Divider
                              (
                              color: Colors.blueGrey.withOpacity(0.25),
                              height: 10.2,
                            ),
                          ]),
                    );
                  });
            }
            else
            {
              return new Center(
                child: Container(
                  width: MediaQuery.of(context).size.width*1,
                  color: appStartColor().withOpacity(0.1),
                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                  child:Text("No employees found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                ),
              );
            }
          }
          else if (snapshot.hasError)
          {
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
                //width: MediaQuery.of(context).size.width*.45,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: InputBorder.none,
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
                          color: Colors.black
                      ),
                      value: emp,
                      onChanged: (String newValue) {
                        setState(() {
                          emp = newValue;
                          if(res = true){
                            //_listFuture = getOutsidegeoReport(today.text,emp);
                          }else {
                            count='0';
                          }
                        });
                      },
                      items: snapshot.data.map((Map map) {
                        return new DropdownMenuItem<String>(
                          value: map["Id"].toString(),
                          child: new SizedBox(
                              width: 250.0,
                              child: map["Code"]!=''&&map["Code"]!='null'?new Text(map["Code"]+' - '+map["Name"]): new Text(map["Name"],)
                          ),
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
} /////////mail class close
