import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/profile.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/services/services.dart';

import '../drawer.dart';
import '../global.dart';
import 'flexi_time.dart';
import 'image_view.dart';

class FlexiList extends StatefulWidget {
  @override
  _FlexiList createState() => _FlexiList();
}

TextEditingController today;
String _orgName;

class _FlexiList extends State<FlexiList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
    getOrgName();
  }

  getOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orgName = prefs.getString('org_name') ?? '';
      orgName  = prefs.getString('orgname') ?? '';
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

  Future<bool> sendToHome() async{
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
        appBar: new FlexiAppHeader(profileimage,showtabbar,orgName),
        bottomNavigationBar: new HomeNavigation(),
        endDrawer: new AppDrawer(),
        body: Container(
          margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          decoration: new ShapeDecoration(
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                    'Flexi Logs',
                    style: new TextStyle(fontSize: 22.0, color: appStartColor()),textAlign: TextAlign.center
                ),
              ),
              Divider(
                height: 1.0,
              ),
              Container(
                child: DateTimeField(
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
                    border:InputBorder.none,
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
              Divider(height: 1,),
              SizedBox(height: 5.0),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 1.0,),
                    Expanded(
                      flex: 48,
                      child: Padding(
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
                        child: Text('Time In',
                            style: TextStyle(color: Colors.green,fontWeight:FontWeight.bold,fontSize: 16.0),
                            textAlign: TextAlign.center),
                      ),
                    ),

                    Expanded(
                      flex: 26,
                      child:Container(
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

  getEmpDataList(date) {
    return new FutureBuilder<List<FlexiAtt>>(
      future: getFlexiDataList(date),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 46,
                            child: new Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  InkWell(
                                    child:Text("In: "+
                                        snapshot.data[index].pi_loc.toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                    onTap: () {
                                      goToMap(snapshot.data[index].pi_latit,snapshot.data[index].pi_longi.toString());
                                    },
                                  ),
                                  SizedBox(height: 5.0),
                                  InkWell(
                                    child:Text("Out: "+
                                        snapshot.data[index].po_loc.toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                    onTap: () {
                                      goToMap(snapshot.data[index].po_latit.toString(),snapshot.data[index].po_longi.toString());
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 27,
                            child:Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(snapshot.data[index].pi_time.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0),),
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
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage(snapshot.data[index].po_img)
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
                child:Text("No flexi log found",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
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

}


class FlexiAppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;

  FlexiAppHeader(profileimage1,showtabbar1,orgname1){
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Flexitime()),
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
                  image: _checkLoadedprofile ? AssetImage('assets/avatar.png') : profileimage,
                )
              )
            ),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(orgname,overflow: TextOverflow.ellipsis,)
            ),
          )
        ],
      ),
      bottom: showtabbar==true ? TabBar(
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
