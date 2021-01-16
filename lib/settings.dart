import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/department_list.dart';
import 'package:ubihrm/designation_list.dart';
import 'package:ubihrm/division_list.dart';
import 'package:ubihrm/employees_list.dart';
import 'package:ubihrm/geofence_list.dart';
import 'package:ubihrm/holiday_list.dart';
import 'package:ubihrm/home.dart';
import 'package:ubihrm/profile.dart';
import 'package:ubihrm/services/services.dart';
import 'package:ubihrm/shift_list.dart';
import 'b_navigationbar.dart';
import 'change_pass.dart';
import 'drawer.dart';
import 'global.dart';

class AllSetting extends StatefulWidget {
  @override
  _AllSetting createState() => _AllSetting();
}
class _AllSetting extends State<AllSetting> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var profileimage;
  bool showtabbar;
  String orgName="";
  int hrsts=0;
  int adminsts=0;
  int divhrsts=0;

  @override
  void initState() {
    super.initState();
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    showtabbar=false;
    getOrgName();
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
      hrsts =prefs.getInt('hrsts')??0;
      adminsts =prefs.getInt('adminsts')??0;
      divhrsts =prefs.getInt('divhrsts')??0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }
  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<bool> move() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePageMain()), (
        Route<dynamic> route) => false,
    );
    return false;
  }

  getmainhomewidget() {
    return WillPopScope(
      onWillPop: () => move(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor:scaffoldBackColor(),
        endDrawer: new AppDrawer(),
        appBar: new SettingsAppHeader(profileimage,showtabbar,orgName),
        bottomNavigationBar:  new HomeNavigation(),
        body:getReportsWidget(),
      ),
    );
  }

  getReportsWidget(){
    return Stack(
      children: <Widget>[
        Container(
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            //width: MediaQuery.of(context).size.width*0.9,
            //height:MediaQuery.of(context).size.height*0.75,
            decoration: new ShapeDecoration(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
              color: Colors.white,
            ),
            child:ListView(
                children: <Widget>[
                  Text('Settings', style: new TextStyle(fontSize: 22.0, color: appStartColor()),textAlign: TextAlign.center),
                  SizedBox(height: 15.0),
                  (adminsts==1||hrsts==1||divhrsts==1)?new RaisedButton(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(Icons.home_work_outlined,size: 30.0,color: Colors.grey[400],),
                          /*Container(
                            child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                          ),*/
                          SizedBox(width: 17.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('Divisions',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                    elevation: 4.0,
                    textColor: Colors.black54,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Division()),
                      );
                    },
                  ):Center(),
                  (adminsts==1||hrsts==1||divhrsts==1)?SizedBox(height: 6.0):Center(),

                  (adminsts==1||hrsts==1||divhrsts==1)?new RaisedButton(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(const IconData(0xe803, fontFamily: "CustomIcon"),size: 30.0,),
                          SizedBox(width: 17.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('Departments',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                    elevation: 4.0,
                    textColor: Colors.black54,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Department()),
                      );
                    },
                  ):Center(),
                  (adminsts==1||hrsts==1||divhrsts==1)?SizedBox(height: 6.0):Center(),

                  (adminsts==1||hrsts==1||divhrsts==1)?new RaisedButton(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(const IconData(0xe804, fontFamily: "CustomIcon"),size: 30.0,),
                          SizedBox(width: 17.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('Designations',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                    elevation: 4.0,
                    textColor: Colors.black54,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Designation()),
                      );
                    },
                  ):Center(),
                  (adminsts==1||hrsts==1||divhrsts==1)?SizedBox(height: 6.0):Center(),

                  (adminsts==1||hrsts==1||divhrsts==1)?new RaisedButton(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(const IconData(0xe800, fontFamily: "CustomIcon"),size: 30.0,),
                          SizedBox(width: 17.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('Shifts',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                    elevation: 4.0,
                    textColor: Colors.black54,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShiftList()),
                      );
                    },
                  ):Center(),
                  ((adminsts==1||hrsts==1||divhrsts==1) && perAttendance=='1' && perGeoFence=='1')?SizedBox(height: 6.0):Center(),

                  ((adminsts==1||hrsts==1||divhrsts==1) && perAttendance=='1' && perGeoFence=='1')?new RaisedButton(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(Icons.location_on_outlined,size: 30.0,color: Colors.grey[400],),
                          /*Container(
                            child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                          ),*/
                          SizedBox(width: 17.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('Geo Fence',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                    elevation: 4.0,
                    textColor: Colors.black54,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Geofence()),
                      );
                    },
                  ):Center(),
                  ((adminsts==1||hrsts==1||divhrsts==1) && perAttendance=='1')?SizedBox(height: 6.0):Center(),

                  new RaisedButton(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(const IconData(0xe817, fontFamily: "CustomIcon"),size: 30.0,),
                          SizedBox(width: 17.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('Employees',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                                ),

                              ],
                            ),
                          ),
                          Container(
                            child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                    elevation: 4.0,
                    textColor: Colors.black54,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EmployeeList()),
                      );
                    },
                  ),
                  SizedBox(height: 6.0),

                  (adminsts==1||hrsts==1||divhrsts==1)?new RaisedButton(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(const IconData(0xe809, fontFamily: "CustomIcon"),size: 30.0,),
                          SizedBox(width: 17.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('Holidays',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                    elevation: 4.0,
                    textColor: Colors.black54,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Holiday()),
                      );
                    },
                  ):Center(),
                  (adminsts==1||hrsts==1||divhrsts==1)?SizedBox(height: 6.0):Center(),

                  new RaisedButton(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(const IconData(0xe802, fontFamily: "CustomIcon"),size: 30.0,),
                          SizedBox(width: 17.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('Change Password',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                                ),

                              ],
                            ),
                          ),
                          Container(
                            child: Icon(Icons.keyboard_arrow_right,size: 40.0,),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                    elevation: 4.0,
                    textColor: Colors.black54,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => changePassword()),
                      );
                    },
                  ),
                ])
        ),
      ],
    );
  }
}

class SettingsAppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;
  SettingsAppHeader(profileimage1,showtabbar1,orgname1){
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageMain()), (Route<dynamic> route) => false,
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
                        // image: AssetImage('assets/avatar.png'),
                        image: _checkLoadedprofile ? AssetImage('assets/default.png') : profileimage,
                      )
                  )
              ),
            ),
            Flexible(
              child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(orgname, overflow: TextOverflow.ellipsis,)
              ),
            )
          ],
        ),
        bottom:
        showtabbar==true ? TabBar(
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
