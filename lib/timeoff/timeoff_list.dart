import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/timeoff/timeoff_reports.dart';

import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';

class TimeOffList extends StatefulWidget {
  @override
  _TimeOffList createState() => _TimeOffList();
}
TextEditingController today;

//FocusNode f_dept ;
class _TimeOffList extends State<TimeOffList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 1;
  String _orgName;
  bool res = true;
  String admin_sts='0';
  var formatter = new DateFormat('dd-MMM-yyyy');
  var profileimage;
  bool showtabbar;
  String orgName="";

  @override
  void initState() {
    super.initState();
    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
    showtabbar =false;
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    // f_dept = FocusNode();
    getOrgName();
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

  Future<bool> sendTotimeOffReport() async{
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );*/
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => TimeoffReports()), (Route<dynamic> route) => true,
    );
    return false;
  }

  getmainhomewidget() {
    return WillPopScope(
      onWillPop: ()=> sendTotimeOffReport(),
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
            SizedBox(height: 1.0),
            Center(
              child: Text(
                'Time Off History',
                style: new TextStyle(
                  fontSize: 20.0,
                  color:appStartColor(),
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
                    if (date != null && date.toString()!='')
                      res = true; //showInSnackBar(date.toString());
                    else
                      res = false;
                  });
                },
                validator: (date) {
                  if (date == null) {
                    return 'Please select date';
                  }
                },
              ),
            ),
            SizedBox(height: 12.0),
            Container(
              //  padding: EdgeInsets.only(bottom:10.0,top: 10.0),
              width: MediaQuery.of(context).size.width * .9,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(

                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Text(
                      ' Name',
                      style: TextStyle(color: appStartColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: Text(
                      'From',
                      style: TextStyle(color: appStartColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text('To',
                        style: TextStyle(color: appStartColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                        textAlign: TextAlign.left),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.12,
                    child: Text('Total Time',
                        style: TextStyle(color: appStartColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                        textAlign: TextAlign.left),
                  ),
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
    return new FutureBuilder<List<EmpListTimeOff>>(
        future: getTimeOFfDataList(date),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return new ListView.builder(
                  itemCount: snapshot.data.length,
                  //    padding: EdgeInsets.only(left: 15.0,right: 15.0),
                  itemBuilder: (BuildContext context, int index) {
                    return new Column(children: <Widget>[
                      SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                  width: MediaQuery.of(context).size.width * 0.34,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(
                                          snapshot.data[index].name.toString()),

                                    ],
                                  )),
                              new Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: new Text(
                                  snapshot.data[index].from.toString(),
                                ),
                              ),
                              new Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: new Text(
                                  snapshot.data[index].to.toString(),
                                ),
                              ),
                              Flexible(
                                child: new Container(
                                  width: MediaQuery.of(context).size.width * 0.10,
                                  child: new Text(
                                    snapshot.data[index].diff.toString(),
                                    style: TextStyle(
                                        color:appStartColor()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  //width: MediaQuery.of(context).size.width * 0.10,
                                  child: new Text("Approval Status: ",
                                    style: TextStyle(
                                        color:Colors.black),
                                  ),
                                ),
                                Container(
                                  //width: MediaQuery.of(context).size.width * 0.10,
                                  child: new Text(
                                    snapshot.data[index].sts.toString(),
                                    style: TextStyle(
                                        color: snapshot.data[index].sts=='Approved'?appStartColor():
                                                snapshot.data[index].sts=='Rejected'?Colors.red:
                                                snapshot.data[index].sts=='Pending'?Colors.orange[800]:Colors.orange[800]
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 5,),
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
                  child:Text("No one is on time off",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
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
} /////////mail class close
