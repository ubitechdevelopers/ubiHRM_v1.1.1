import 'dart:async';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/attandance/image_view.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/home.dart';
import '../appbar.dart';
import '../drawer.dart';
import '../services/attandance_services.dart';
import 'punchlocation_summary.dart';


void main() => runApp(new TeamPunchLocationSummary());

class TeamPunchLocationSummary extends StatefulWidget {
  @override
  _TeamPunchLocationSummary createState() => _TeamPunchLocationSummary();
}
TextEditingController today;
class _TeamPunchLocationSummary extends State<TeamPunchLocationSummary> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String lat="";
  String long="";
  String desination="";
  String profile="";
  String org_name="";
  String orgid="";
  String empid="";
  String admin_sts='0';
  int _currentIndex = 1;
  String streamlocationaddr = "";

  String orgName="";
  var profileimage;
  bool showtabbar ;
  bool _checkLoaded = true;

  bool res = true;
  var formatter = new DateFormat('dd-MMM-yyyy');

  StreamLocation sl = new StreamLocation();
  bool _isButtonDisabled= false;
  final _comments=TextEditingController();
  String latit,longi,location_addr1;
  Timer timer;
  TextEditingController _searchController;
  FocusNode searchFocusNode;
  String empname = "";

  @override
  void initState() {
    super.initState();
    _searchController = new TextEditingController();
    searchFocusNode = FocusNode();
    initPlatformState();
    getOrgName();
    //setLocationAddress();
    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      streamlocationaddr = globalstreamlocationaddr;
      desination = prefs.getString('desination') ?? '';
      profile = prefs.getString('profile') ?? '';
      admin_sts = prefs.getString('sstatus') ?? '0';
      org_name = prefs.getString('org_name') ?? '';
      orgid = prefs.getString('orgdir') ?? '';
      empid = prefs.getString('empid') ?? '';
    });

    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);

    profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoaded = false;
        });
      }
    }));
    showtabbar=false;
  }

  Future<bool> sendToHome() async{
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePageMain()), (Route<dynamic> route) => false,
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: ()=> sendToHome(),
      child: new Scaffold(
        backgroundColor:scaffoldBackColor(),
        endDrawer: new AppDrawer(),
        appBar: new AppHeader(profileimage,showtabbar,orgName),
        bottomNavigationBar:new HomeNavigation(),
        body: getWidgets(context),
      ),
    );

  }

  /////////////
  getWidgets(context){
    return Container(
        margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        //width: MediaQuery.of(context).size.width*0.9,
        //height:MediaQuery.of(context).size.height*0.75,
        decoration: new ShapeDecoration(
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
          color: Colors.white,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex:48,
                      child:InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PunchLocationSummary()),
                          );
                        },
                        child:Column(
                            children: <Widget>[
                              // width: double.infinity,
                              //height: MediaQuery.of(context).size.height * .07,
                              SizedBox(height:MediaQuery.of(context).size.width*.02),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                        Icons.person,
                                        color: Colors.orange[800],
                                        size: 22.0 ),

                                    GestureDetector(
                                      child: Text(
                                          'Self',
                                          style: TextStyle(fontSize: 18,color: Colors.orange[800],)
                                      ),
                                    ),
                                  ]
                              ),
                              SizedBox(height:MediaQuery.of(context).size.width*.03),
                            ]
                        ),
                      ),
                    ),

                    Expanded(
                      flex:48,
                      child: Column(
                        // width: double.infinity,
                          children: <Widget>[
                            SizedBox(height:MediaQuery.of(context).size.width*.02),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                      Icons.group,
                                      color: Colors.orange[800],
                                      size: 22.0 ),
                                  GestureDetector(
                                    onTap: () {
                                      /* Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MyTeamAtt()),
                                  );*/
                                      false;
                                    },
                                    child: Text(
                                        'Team',
                                        style: TextStyle(fontSize: 18,color: Colors.orange[800],fontWeight:FontWeight.bold)
                                    ),
                                  ),
                                ]),
                            SizedBox(height:MediaQuery.of(context).size.width*.03),
                            Divider(
                              color: Colors.orange[800],
                              height: 0.4,
                            ),
                            Divider(
                              color: Colors.orange[800],
                              height: 0.4,
                            ),
                            Divider(
                              color: Colors.orange[800],
                              height: 0.4,
                            ),
                          ]
                      ),
                    ),
                  ]),
              /// My log start here
              Container(
                padding: EdgeInsets.only(top:12.0,),
                child:Center(
                  child:Text("Team's Visits",
                    style: new TextStyle(fontSize: 18.0, color: Colors.black87,),textAlign: TextAlign.center,),
                ),
              ),
              Container(
                child: DateTimeField(
                  //dateOnly: true,
                  format: formatter,
                  controller: today,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                  readOnly: true,
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
              //Divider(height: 1,),
              Container(
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
                      //labelText: 'Search Employee',
                      suffixIcon: _searchController.text.isNotEmpty?IconButton(icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            empname='';
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EmployeeList()),
                            );*/
                          }
                      ):null,
                      //focusColor: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        empname = value;
                        res = true;
                      });
                    },
                  ),
                ),
              ),
              //SizedBox(height: 8,),
              //Divider(color: Colors.black54,height: 1.5,),
              Container(
                //  padding: EdgeInsets.only(bottom:10.0,top: 10.0),
                //       width: MediaQuery.of(context).size.width * .9,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    //SizedBox(width: MediaQuery.of(context).size.width*0.02),
                    Expanded(
                      flex: 50,
                      child: Text(
                        '  Name',
                        style: TextStyle(
                            color: appStartColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                      width: 100,
                    ),
                    Expanded(
                      flex: 50,
                      // width: MediaQuery.of(context).size.width*0.2,
                      child: Text(
                        'Visit In',
                        style: TextStyle(
                            color: appStartColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
                      flex: 50,
                      // width: MediaQuery.of(context).size.width*0.2,
                      child: Text(
                        'Visit Out',
                        style: TextStyle(
                            color: appStartColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),

              Expanded(
                //height: MediaQuery.of(context).size.height*0.60,
                child: new FutureBuilder<List<Punch>>(
                  future: getTeamSummaryPunch(today.text,empname),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if(snapshot.data.length>0) {
                        return new ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              //   double h_width = MediaQuery.of(context).size.width*0.5; // screen's 50%
                              //   double f_width = MediaQuery.of(context).size.width*1; // screen's 100%
                              return Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: new Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 50,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  snapshot.data[index].Emp.toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text("Client: "+
                                                    snapshot.data[index].client.toString(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,color: Colors.black54
                                                  ),
                                                ),
                                                InkWell(
                                                  child: Text(
                                                      'In: ' +
                                                          snapshot.data[index].pi_loc
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 12.0)),
                                                  onTap: () {
                                                    goToMap(snapshot.data[index].pi_latit,
                                                        snapshot.data[index].pi_longi);
                                                  },
                                                ),
                                                SizedBox(height: 2.0),
                                                InkWell(
                                                  child: Text(
                                                    'Out: ' +
                                                        snapshot.data[index].po_loc
                                                            .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 12.0),
                                                  ),
                                                  onTap: () {
                                                    goToMap(snapshot.data[index].po_latit,
                                                        snapshot.data[index].po_longi);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Expanded(
                                              flex: 50,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        // Text(snapshot.data[index].Emp.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                        // SizedBox(height: 10.0,),
                                                        Text(
                                                          snapshot.data[index].pi_time
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                        SizedBox(height: 10),
                                                        GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        ImageView(
                                                                            myimage: snapshot
                                                                                .data[index]
                                                                                .pi_img,
                                                                            org_name:
                                                                            "Ubitech Solutions")),
                                                              );
                                                            },
                                                            child: Container(
                                                              width: 62.0,
                                                              height: 62.0,
                                                              child: Container(
                                                                  decoration: new BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      image: new DecorationImage(
                                                                          fit: BoxFit.fill,
                                                                          image: new NetworkImage(
                                                                              snapshot
                                                                                  .data[index]
                                                                                  .pi_img)))),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 20),
                                                  Container(

                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Text(
                                                          snapshot.data[index].po_time
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                        SizedBox(height: 10),
                                                        GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        ImageView(
                                                                            myimage: snapshot
                                                                                .data[index]
                                                                                .po_img,
                                                                            org_name:
                                                                            "Ubitech Solutions")),
                                                              );
                                                            },
                                                            child: Container(
                                                              width: 62.0,
                                                              height: 62.0,
                                                              child: Container(
                                                                  decoration: new BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      image: new DecorationImage(
                                                                          fit: BoxFit.fill,
                                                                          image: new NetworkImage(
                                                                              snapshot
                                                                                  .data[index]
                                                                                  .po_img)))),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                      snapshot.data[index].desc == ''
                                          ? Container()
                                          : snapshot.data[index].desc !=
                                          'Visit out not punched'
                                          ? Row(
                                        children: <Widget>[
                                          //SizedBox(width: 5.0,),
                                          Text(
                                            'Remark:  ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(snapshot.data[index].desc)
                                        ],
                                      )
                                          : Row(
                                        children: <Widget>[
                                          //SizedBox(width: 5.0,),
                                          Text(
                                            'Remark:  ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                          Text(
                                            snapshot.data[index].desc,
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.black26,
                                      ),
                                    ]),
                              );
                            }
                        );
                      }else{
                        return new Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width*1,
                            color: appStartColor().withOpacity(0.1),
                            padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                            child:Text("Team's visit not found",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
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
              ),
            ]
        )
    );
  }
}

class User {
  String AttendanceDate;
  String thours;
  String TimeOut;
  String TimeIn;
  String bhour;
  String EntryImage;
  String checkInLoc;
  String ExitImage;
  String CheckOutLoc;
  String latit_in;
  String longi_in;
  String latit_out;
  String longi_out;
  int id=0;
  User({this.AttendanceDate,this.thours,this.id,this.TimeOut,this.TimeIn,this.bhour,this.EntryImage,this.checkInLoc,this.ExitImage,this.CheckOutLoc,this.latit_in,this.longi_in,this.latit_out,this.longi_out});
}

String dateFormatter(String date_) {
  // String date_='2018-09-2';
  var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun','Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  var dy = ['st', 'nd', 'rd', 'th', 'th', 'th','th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th','st','nd','rd', 'th', 'th', 'th', 'th', 'th', 'th', 'th','st'];
  var date = date_.split("-");
  return(date[2]+""+dy[int.parse(date[2])-1]+" "+months[int.parse(date[1])-1]);
}
