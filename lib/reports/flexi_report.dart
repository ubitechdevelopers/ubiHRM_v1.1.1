import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/services/attandance_services.dart';

import '../appbar.dart';
import '../drawer.dart';
import '../global.dart';
import '../image_view.dart';


class FlexiReport extends StatefulWidget {
  @override
  _FlexiReport createState() => _FlexiReport();
}

TextEditingController today;
String orgName;

class _FlexiReport extends State<FlexiReport> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 1;
  String emp='0';
  String admin_sts='0';
  bool res = true;
  var formatter = new DateFormat('dd-MMM-yyyy');
  var newDateFormate = new DateFormat('dd-MMM');
  var profileimage;
  bool showtabbar ;
  String orgName="";
  bool _checkLoaded=true;

  @override
  void initState() {
    super.initState();
    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
    getOrgName();
  }

  getOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName = prefs.getString('orgname') ?? '';
      admin_sts = prefs.getString('sstatus') ?? '0';
      profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);
      profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
        if (mounted) {
          setState(() {
            _checkLoaded = false;
          });
        }
      }));
      showtabbar=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  getmainhomewidget() {
    return new Scaffold(
      backgroundColor:scaffoldBackColor(),
      key: _scaffoldKey,
      appBar:  new AppHeader(profileimage,showtabbar,orgName),
      bottomNavigationBar: new HomeNavigation(),
      endDrawer: new AppDrawer(),
      body: Container(
        margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        padding: EdgeInsets.fromLTRB(8.0 ,8.0, 8.0, 8.0),
        decoration: new ShapeDecoration(
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8.0),
            Center(
              child: Text(
                'Flexi Attendance',
                style: new TextStyle(
                  fontSize: 22.0,
                  color: Colors.black54,
                ),
              ),
            ),
            Divider(height: 2.0,),
            getEmployee_DD(),
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
                    lastDate: DateTime(2100)
                  );
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
                    if (date != null && date.toString() != '')
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex:48,
                    child:Container(
                      child: Text(
                        'Name',
                        style: TextStyle(color: Colors.green,fontWeight:FontWeight.bold,fontSize: 16.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),

                  Expanded(
                      flex:26,
                      child:Container(
                        child: Text('Time In',
                          style: TextStyle(color: Colors.green,fontWeight:FontWeight.bold,fontSize: 16.0),
                          textAlign: TextAlign.center),
                      )
                  ),

                  Expanded(
                      flex:26,
                      child:Container(
                        child: Text('Time Out ',
                          style: TextStyle(color: Colors.green,fontWeight:FontWeight.bold,fontSize: 16.0),
                          textAlign: TextAlign.center),
                      )),
                ],
              ),
            ),
            SizedBox(height: 5.0),
            Divider(height: 5.2,),
            new Expanded(
              child: res == true ? getEmpDataList(today.text) : Center(),
            ),
          ],
        ),
      ),
    );
  }

  Widget getEmployee_DD() {
    String dc = "0";
    return new FutureBuilder<List<Map>>(
      future: getEmployeesList(0, '0', '0'),// with -select- label
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          try {
            return new Container(
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
                        child: map["Code"]!=''?new Text(map["Name"]+' ('+map["Code"]+')'):
                        new Text(map["Name"],)),
                    );
                  }).toList(),
                ),
              ),
            );
          } catch(e){
            return Text("EX: Unable to fetch employees");
          }
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return new Text("ER: Unable to fetch employees");
        }
        return new Center(child: SizedBox(
          child: CircularProgressIndicator(strokeWidth: 2.2,),
          height: 20.0,
          width: 20.0,
        ),);
      }
    );
  }

  getEmpDataList(date) {
    return new FutureBuilder<List<FlexiAtt>>(
      future: getFlexiDataListReport(date,emp),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return new ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Container(
                    child:Column(children: <Widget>[
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex:46,
                            child:Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment : MainAxisAlignment.center,
                                children: <Widget>[
                                  new Text(snapshot.data[index].Emp.toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                                  SizedBox(height: 3.0),
                                  InkWell(
                                    child:Text("In: "+ snapshot.data[index].pi_loc.toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                    onTap: () {
                                      goToMap(snapshot.data[index].pi_latit,snapshot.data[index].pi_longi.toString());
                                    },
                                  ),
                                  SizedBox(height: 3.0),
                                  InkWell(
                                    child:Text("Out: "+ snapshot.data[index].po_loc.toString(),
                                      style: TextStyle(
                                          color: Colors.black54,fontSize: 12.0
                                      ),
                                    ),
                                    onTap: () {
                                      goToMap(snapshot.data[index].po_latit.toString(), snapshot.data[index].po_longi.toString());
                                    },
                                  ),
                                ],
                              )
                            ),
                          ),

                          Expanded(
                            flex:27,
                            child:Container(
                              // width: MediaQuery.of(context) .size .width * 0.15,
                              child:Column(
                                children: <Widget>[
                                  new Text(snapshot.data[index].pi_time.toString()+"|"+snapshot.data[index].timeindate.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0),),
                                  Container(
                                    width: 56.0,
                                    height: 56.0,
                                    child:InkWell(
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          shape: BoxShape .circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage(snapshot.data[index].pi_img)
                                          )
                                        )),
                                      onTap:() {
                                        Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].pi_img,org_name: orgName)),
                                        );
                                      },
                                    ),
                                  ),
                                ]
                              ),
                            ),
                          ),

                          Expanded(
                            flex:27,
                            child:Container(
                              child:Column(
                                children: <Widget>[
                                  Text(snapshot.data[index].po_time .toString()+"|" + snapshot.data[index].timeoutdate,style: TextStyle(fontWeight: FontWeight.bold,fontSize:12.0 ),),
                                  Container(
                                    width: 56.0,
                                    height: 56.0,
                                    child:InkWell(
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage(snapshot.data[index].po_img)
                                          )
                                        )),
                                      onTap: () {
                                        Navigator.push(context,MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].po_img,org_name: orgName)),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      Divider(
                        color: Colors.blueGrey.withOpacity(0.25),
                        height: 20.2,
                      ),
                    ]),
                  );
                });
          } else {
            return new Center(
              child: Container(
                width: MediaQuery.of(context).size.width*1,
                color: appStartColor().withOpacity(0.1),
                padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                child:Text("No Attendance Found",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return new Text("Unable to connect server");
        }
        return new Center(child: CircularProgressIndicator());
      }
    );
  }
} /////////mail class close
