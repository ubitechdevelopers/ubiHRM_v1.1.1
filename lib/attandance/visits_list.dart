import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_share/simple_share.dart';
import 'package:ubihrm/services/attandance_services.dart';

import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';

class VisitList extends StatefulWidget {
  @override
  _VisitList createState() => _VisitList();
}

TextEditingController today;

//FocusNode f_dept ;
class _VisitList extends State<VisitList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 1;
  String _orgName;
  String admin_sts='0';
  bool res = true;
  var formatter = new DateFormat('dd-MMM-yyyy');
  var profileimage;
  bool showtabbar;
  String orgName="";
  bool filests=false;
  Future<List<Punch>> _listFuture;

  @override
  void initState() {
    super.initState();
    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
    // f_dept = FocusNode();
    showtabbar =false;
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    getOrgName();
    _listFuture = getVisitsDataList(today.text);
  }

  getOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName = prefs.getString('orgname') ?? '';
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
        //   padding: EdgeInsets.only(left: 2.0, right: 2.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 1.0),
            Center(
              child: Text(
                'Visits',
                style: new TextStyle(
                  fontSize: 20.0,
                  color: appStartColor(),
                ),
              ),
            ),
            /*Divider(
              height: 10.0,
            ),*/
            SizedBox(height: 2.0),
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
                          if (date != null && date.toString() != '') {
                            res=true; //showInSnackBar(date.toString());
                            _listFuture = getVisitsDataList(today.text);
                          }
                          else {
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
                      child: new FutureBuilder<List<Punch>>(
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
                                                          'Visits_Report_' +
                                                              today
                                                                  .text,
                                                          'visitlist')
                                                          .then((res) {
                                                        if(mounted){
                                                          setState(() {
                                                            filests = false;
                                                          });
                                                        }
                                                        // showInSnackBar('CSV has been saved in file storage in ubiattendance_files/Department_Report_'+today.text+'.csv');
                                                        dialogwidget(
                                                            "CSV has been saved in internal storage in ubihrm_files/Late_Comers_Report_" +
                                                                today.text +
                                                                ".csv",
                                                            res);
                                                        *//*showDialog(context: context, child:
                                                        new AlertDialog(
                                                          content: new Text("CSV has been saved in file storage in ubiattendance_files/Late_Comers_Report_"+today.text+".csv"),
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
                                                      //final uri = Uri.file('/storage/emulated/0/ubiattendance_files/Late_Comers_Report_14-Jun-2019.pdf');
                                                      *//*SimpleShare.share(
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
                                                          'Visits Report ('+today.text+')',
                                                          snapshot.data.length.toString(),
                                                          'Visits_Report_' + today.text,
                                                          'visitlist')
                                                          .then((res) {
                                                        setState(() {
                                                          filests =false;
                                                          // OpenFile.open("/sdcard/example.txt");
                                                        });
                                                        dialogwidget(
                                                            'PDF has been saved in internal storage in ubihrm_files/' +
                                                                'Late_Comers_Report_' +
                                                                today.text +
                                                                '.pdf',
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
            Divider(
              height: 5,
            ),
            SizedBox(height: 2.0),
            Container(
              //  padding: EdgeInsets.only(bottom:10.0,top: 10.0),
       //       width: MediaQuery.of(context).size.width * .9,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  SizedBox(height: 20.0,),
                  //SizedBox(width: MediaQuery.of(context).size.width*0.02),
                  Expanded(
                    flex: 50,
                    child:Text(' Name',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                  ),
                  SizedBox(height: 20.0,),
                  Expanded(
                    flex: 50,
                    // width: MediaQuery.of(context).size.width*0.2,
                    child:Text('Client',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                  ),

                ],
              ),
            ),
            //SizedBox(height: 5.0),
            Divider(
              height: 8.2,
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
    return new FutureBuilder<List<Punch>>(
        future: _listFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return new ListView.builder(
                  itemCount: snapshot.data.length,
                  //    padding: EdgeInsets.only(left: 15.0,right: 15.0),
                  itemBuilder: (BuildContext context, int index) {

                    return new Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  flex:50,

                                  child: Column(

                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[

                                      Text(" "+snapshot.data[index].Emp
                                          .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                      SizedBox(height: 10.0,),
                                      Text(" TimeIn:    "+snapshot.data[index].pi_time
                                          .toString(),),
                                      SizedBox(height: 5.0,),
                                      Text(" TimeOut: "+snapshot.data[index].po_time
                                          .toString(),),


                                    ],
                                  )
                              ),

                              Expanded(
                                flex:50,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(snapshot.data[index].client
                                        .toString(), style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),),

                                    InkWell(
                                      child: Text('In: ' +
                                          snapshot.data[index]
                                              .pi_loc.toString(),
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12.0)),
                                      onTap: () {
                                        goToMap(
                                            snapshot.data[index]
                                                .pi_latit ,
                                            snapshot.data[index]
                                                .pi_longi);
                                      },
                                    ),
                                    SizedBox(height:2.0),
                                    InkWell(
                                      child: Text('Out: ' +
                                          snapshot.data[index]
                                              .po_loc.toString(),
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12.0),),
                                      onTap: () {
                                        goToMap(
                                            snapshot.data[index]
                                                .po_latit,
                                            snapshot.data[index]
                                                .po_longi);
                                      },
                                    ),
                                  ],
                                ),
                              ),


                            ],
                          ),

                          snapshot.data[index].desc == '' ? Container() : snapshot
                              .data[index].desc != 'Visit out not punched' ?
                          Row(
                            children: <Widget>[
                              SizedBox(width: 5.0,),
                              Text('Remark:  ',
                                style: TextStyle(fontWeight: FontWeight.bold,),),
                              Text(snapshot.data[index].desc)
                            ],

                          ) :
                          Row(
                            children: <Widget>[
                              SizedBox(width: 5.0,),
                              Text('Remark:  ', style: TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.red),),
                              Text(snapshot.data[index].desc,
                                style: TextStyle(color: Colors.red),)
                            ],

                          ),
                          Divider(color: Colors.black26,),
                        ]);
                  });
            } else {
              return new Center(
                child: Container(
                  width: MediaQuery.of(context).size.width*1,
                  color: appStartColor().withOpacity(0.1),
                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                  child:Text("No Visits found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                ),
              );
              /*return new Center(
                child: Text("No Visits found", style: TextStyle(color: appStartColor(),fontSize: 18.0),),
              );*/
            }
          } else if (snapshot.hasError) {
		   return new Text("Unable to connect server");
          }
          // return loader();
          return new Center(child: CircularProgressIndicator());
        });
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
} /////////mail class close
