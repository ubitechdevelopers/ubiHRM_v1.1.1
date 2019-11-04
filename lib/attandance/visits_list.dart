import 'package:flutter/material.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:ubihrm/attandance/addShift.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import '../drawer.dart';
import '../appbar.dart';
import '../global.dart';
import '../b_navigationbar.dart';

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


  @override
  void initState() {
    super.initState();
    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
    // f_dept = FocusNode();
    showtabbar =false;
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    getOrgName();
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
              child: res == true ? getEmpDataList(today.text) : Center(),
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
        future: getVisitsDataList(date),
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
} /////////mail class close
