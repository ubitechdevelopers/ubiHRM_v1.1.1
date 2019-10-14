import 'package:flutter/material.dart';
import '../drawer.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
//import 'package:Shrine/addShift.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'home.dart';
import 'settings.dart';
import 'profile.dart';
import 'reports.dart';
import 'image_view.dart';
import 'package:ubihrm/b_navigationbar.dart';
import '../global.dart';
import '../appbar.dart';
import 'flexi_time.dart';

class FlexiList extends StatefulWidget {
  @override
  _FlexiList createState() => _FlexiList();
}

TextEditingController today;
String _orgName;
String orgName ;
//FocusNode f_dept ;
class _FlexiList extends State<FlexiList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 1;

  String admin_sts='0';
  bool res = true;
  var formatter = new DateFormat('dd-MMM-yyyy');
  bool showtabbar ;
  String orgName = "";
  var profileimage;
  bool _checkLoaded=true;

  @override
  void initState() {
    super.initState();
    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
    // f_dept = FocusNode();
    getOrgName();
  }

  getOrgName() async {

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orgName = prefs.getString('org_name') ?? '';
      orgName  = prefs.getString('orgname') ?? '';
      admin_sts = prefs.getString('sstatus') ?? '0';

      profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);

      //      print("ABCDEFGHI-"+profile);
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
  Future<bool> sendToHome() async{
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Flexitime()), (Route<dynamic> route) => false,
    );
    return false;
  }

  getmainhomewidget() {
    return new WillPopScope(
      onWillPop: ()=> sendToHome(),
      child: new Scaffold(
      key: _scaffoldKey,
      backgroundColor:scaffoldBackColor(),
      appBar: new AppHeader(profileimage,showtabbar,orgName),
      bottomNavigationBar: new HomeNavigation(),
      endDrawer: new AppDrawer(),
      body: Container(
        margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        decoration: new ShapeDecoration(
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
          color: Colors.white,
        ),
        //   padding: EdgeInsets.only(left: 2.0, right: 2.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8.0),
            Center(
              child: Text(
                'Flexi Log',
                  style: new TextStyle(fontSize: 22.0, color: appStartColor()),textAlign: TextAlign.center
              ),
            ),
            Divider(
              height: 1.0,
            ),
            //SizedBox(height: 2.0),
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
                  SizedBox(width: 1.0,),
              /*    Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Text(
                      'Name',
                      style: TextStyle(color: Colors.orange),
                      textAlign: TextAlign.left,
                    ),
                  ),*/
               Expanded(
                 flex: 48,
                 child: Padding(
                   // width: MediaQuery.of(context).size.width * 0.37,
                   padding: EdgeInsets.only(left: 4.0),
                    child: Text(
                      'Location',
                      style: TextStyle(color: Colors.green,fontWeight:FontWeight.bold,fontSize: 16.0),
                      textAlign: TextAlign.left,
                    ),
                   ),
                  ),

                  Expanded(
                    flex: 26,
                    child:Container(
                  //  width: MediaQuery.of(context).size.width * 0.15,
                    child: Text('Time In',
                        style: TextStyle(color: Colors.green,fontWeight:FontWeight.bold,fontSize: 16.0),
                        textAlign: TextAlign.center),
                  ),
                  ),

                  Expanded(
                    flex: 26,
                    child:Container(
                  //  width: MediaQuery.of(context).size.width * 0.15,
                    child: Text('Time Out ',
                        style: TextStyle(color: Colors.green,fontWeight:FontWeight.bold,fontSize: 16.0),
                        textAlign: TextAlign.center),
                  ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 5.0),
            Divider(
              height: 5.2,
            ),
            new Expanded(
              child: res == true ? getEmpDataList(today.text) : Center(),
            ),
          ],
        ),
      ),
      ),
    );
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
    return new FutureBuilder<List<FlexiAtt>>(
        future: getFlexiDataList(date),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return new ListView.builder(
                  itemCount: snapshot.data.length,
                  //    padding: EdgeInsets.only(left: 15.0,right: 15.0),
                  itemBuilder: (BuildContext context, int index) {
                    return new Container(
                      //          width: MediaQuery.of(context).size.width * .9,
                      child:Column(children: <Widget>[
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                           // SizedBox(width: 8.0,),
                         /*   new Container(
                                width: MediaQuery.of(context).size.width * 0.18,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(
                                      snapshot.data[index].Emp.toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                                  ],
                                )),*/
                            Expanded(
                              flex: 46,
                           child: new Container(
                             // width: MediaQuery.of(context).size.width * 0.37,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                 /* new Text(
                                    snapshot.data[index].client.toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,
                                  ),*/
                                  InkWell(
                                    child:Text("In: "+
                                        snapshot.data[index].pi_loc.toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                    onTap: ()
                                    {
                                     goToMap(snapshot.data[index].pi_latit,snapshot.data[index].pi_longi.toString());
                                    },
                                  ),
                                  SizedBox(height: 5.0),
                                  InkWell(
                                    child:Text("Out: "+
                                        snapshot.data[index].po_loc.toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                    onTap: () {goToMap(snapshot.data[index].po_latit.toString(),snapshot.data[index].po_longi.toString());},
                                  ),
                                ],
                              ),
                             ),
                            ),

                            Expanded(
                              flex: 27,
                              child:Container(
                                //width: MediaQuery.of(context).size.width * 0.19,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(snapshot.data[index].pi_time
                                        .toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0),),
                                    Container(
                                      width: 62.0,
                                      height: 62.0,
                                      child:InkWell(
                                        child: Container(
                                            decoration: new BoxDecoration(
                                                shape: BoxShape .circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: new NetworkImage(snapshot.data[index].pi_img)
                                                )
                                            )),
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].pi_img,org_name: _orgName)),
                                          );
                                        },
                                      ),
                                    ),
                                    Text(snapshot.data[index].timeindate.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0,color: Colors.grey),),
                                  ],
                                )
                              ),
                            ),

                            Expanded(
                              flex: 27,
                              child:Container(
                               // width: MediaQuery.of(context).size.width * 0.22,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(snapshot.data[index].po_time
                                    .toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0),),
                                    Container(
                                      width: 62.0,
                                      height: 62.0,
                                      child:InkWell(
                                        child: Container(
                                            decoration: new BoxDecoration(
                                                shape: BoxShape
                                                    .circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: new NetworkImage(
                                                        snapshot
                                                            .data[index]
                                                            .po_img)
                                                )
                                            )),
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].po_img,org_name: _orgName)),
                                          );
                                        },
                                      ),
                                    ),
                                    Text(snapshot.data[index].timeoutdate.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0,color: Colors.grey),),

                                  ],
                                )
                               ),
                            ),

                          ],
                        ),

                        Divider(
                          color: Colors.blueGrey.withOpacity(0.25),
                          height: 10.2,
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
                  child:Text("No Flexi Log Found ",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
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
