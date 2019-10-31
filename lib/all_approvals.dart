import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'global.dart';
import 'drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profile.dart';
import 'b_navigationbar.dart';
import 'leave/approval.dart';
import 'timeoff/timeoff_approval.dart';
import 'appbar.dart';
import 'services/services.dart';
import 'model/model.dart';

class AllApprovals extends StatefulWidget {
  @override
  _AllApprovals createState() => _AllApprovals();
}
class _AllApprovals extends State<AllApprovals> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 1;
  String _orgName;
  String buystatus = "";
  String trialstatus = "";
  String orgmail = "";
  String admin_sts = "0";
  var profileimage;
  bool showtabbar;
  String orgName="";


  @override
  void initState() {
    super.initState();
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    showtabbar=false;
    getOrgName();
   /* perLeaveApproval=  getModuleUserPermission("124","view");
    perTimeoffApproval=  getModuleUserPermission("180","view");*/

  }
  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });

    String empid = prefs.getString('employeeid')??"";
    String organization =prefs.getString('organization')??"";
    String userprofileid =prefs.getString('userprofileid')??"";
    Employee emp = new Employee(employeeid: empid, organization: organization,userprofileid:userprofileid);

    //  await getProfileInfo(emp);
    getAllPermission(emp).then((res) {
      setState(() {
        perLeaveApproval=   getModuleUserPermission("124","view");
        perTimeoffApproval=  getModuleUserPermission("180","view");
        print("leave "+perLeaveApproval);
        print("timeoff "+perTimeoffApproval);
      });
    });


   /* getAllPermission(emp);
    perLeaveApproval=   getModuleUserPermission("124","view");
    perTimeoffApproval=  getModuleUserPermission("180","view");
    print("leave "+perLeaveApproval);
    print("timeoff "+perTimeoffApproval);*/

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
/*  getmainhomewidget(){
    //  print('99999999999999' + _orgName.toString());
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(_orgName, style: new TextStyle(fontSize: 20.0)),
            /*  Image.asset(
                    'assets/logo.png', height: 40.0, width: 40.0),*/
          ],
        ),
        leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
          Navigator.pop(context);}),
        backgroundColor: Colors.teal,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          if(newIndex==2){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            );
            return;
          } if (newIndex == 0) {
            (admin_sts == '1')
                ? Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Reports()),
            )
                : Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
            return;
          }
          if(newIndex==1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            return;
          }
          setState((){_currentIndex = newIndex;});

        }, // this will be set when a new tab is tapped
        items: [
          (admin_sts == '1')
              ? BottomNavigationBarItem(
            icon: new Icon(
                Icons.library_books,color: Colors.orangeAccent
            ),
            title: new Text('Reports',style: TextStyle(color: Colors.orangeAccent),),
          )
              : BottomNavigationBarItem(
            icon: new Icon(
                Icons.person,color: Colors.orangeAccent
            ),
            title: new Text('Profile',style: TextStyle(color: Colors.orangeAccent),),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.home,color: Colors.black54,),
            title: new Text('Home',style: TextStyle(color: Colors.black54),),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings')
          )
        ],
      ),

      endDrawer: new AppDrawer(),
      body:
      Container(
        padding: EdgeInsets.only(left: 2.0,right: 2.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8.0),
            Text('Reports',
              style: new TextStyle(fontSize: 22.0, color: Colors.teal,),),
            SizedBox(height: 5.0),
            new Expanded(
              child: getReportsWidget(),
            )
          ],
        ),

      ),
    );

  } */

  Future<bool> sendToHome() async{
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );*/
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePageMain()), (Route<dynamic> route) => false,
    );
    return false;
  }


  getmainhomewidget() {
    return WillPopScope(
      onWillPop: ()=> sendToHome(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor:scaffoldBackColor(),
        endDrawer: new AppDrawer(),
        appBar: AppHeader(profileimage,showtabbar,orgName),

/*      appBar: GradientAppBar(
          automaticallyImplyLeading: false,
          backgroundColorStart: appStartColor(),
          backgroundColorEnd: appEndColor(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/avatar.png'),
                      )
                  )),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('UBIHRM')
              )
            ],

          ),

        ),*/
        bottomNavigationBar:  new HomeNavigation(),

        body:getReportsWidget(),

      ),
    );
  }
/*
  mainbodyWidget() {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15.0),
              getReportsWidget(),
              //getMarkAttendanceWidgit(),
            ],
          ),


        ],
      ),

    );
  }
*/
  loader(){
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset(
                  'assets/spinner.gif', height: 80.0, width: 80.0),
            ]),
      ),
    );
  }

  launchMap(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print( 'Could not launch $url');
    }
  }

  showDialogWidget(String loginstr){

    return showDialog(context: context, builder:(context) {

      return new AlertDialog(
        title: new Text(
          loginstr,
          style: TextStyle(fontSize: 15.0),),
        content: ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Text('Later',style: TextStyle(fontSize: 13.0)),
              shape: Border.all(),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            RaisedButton(
              child: Text(
                'Pay Now', style: TextStyle(color: Colors.white,fontSize: 13.0),),
              color: Colors.orange[800],
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                /*       Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage()),
                );*/
              },
            ),
          ],
        ),
      );
    }
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

            //    mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Approvals',
                      style: new TextStyle(fontSize: 22.0, color: appStartColor()),textAlign: TextAlign.center),
                  //SizedBox(height: 10.0),



                  SizedBox(height: 16.0),
                  perLeaveApproval=='1' ?
                  new RaisedButton(
                    //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
               //     shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
                    //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(

                      //     padding: EdgeInsets.only(left:  5.0),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: appStartColor(),
                            ),
                            child: Icon(Icons.directions_walk,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                            padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                          ),

                          SizedBox(width: 15.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('Leave',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
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
                    textColor: Colors.black,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TabbedApp()),
                      );
                    },
                  ): Center(),

                  SizedBox(height: 6.0),
                  perTimeoffApproval=='1' ?
                  new RaisedButton(
                    //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
          //          shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
                    //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(

                      //     padding: EdgeInsets.only(left:  5.0),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: appStartColor(),
                            ),
                            child: Icon(Icons.alarm_on,size: 30.0,color: Colors.white,textDirection: TextDirection.ltr),
                            padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                          ),

                          SizedBox(width: 15.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('Time off',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
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
                    textColor: Colors.black,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TimeOffApp()),
                      );
                    },
                  ):Center(),

                  ( perLeaveApproval!='1' &&  perTimeoffApproval!='1' ) ?new Center(
                    child: Padding(
                      padding: EdgeInsets.only(top:100.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width*1,
                        color: appStartColor().withOpacity(0.1),
                        padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                        child:Text("No Approvals found for you",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                      ),
                    ),
                  ) : Center()
         /*         new Divider(height: 5.5,),
                  new Row(

                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[

                        //     Expanded(
                         new RaisedButton(
                           color: Colors.orange[300],
                           elevation: 4.0,
                           splashColor: Colors.lightBlueAccent,
                           textColor: Colors.white,
                           onPressed: () {
                             Navigator.push(
                               context,
                               MaterialPageRoute(builder: (context) => TabbedApp()),
                             );
                           },
                        child:Container(

                          width:MediaQuery.of(context).size.width*0.80,
                          height:MediaQuery.of(context).size.height*0.10,
                          padding: EdgeInsets.fromLTRB(0.0, 5.0, 3.0, 5.0),
                      /*    decoration: new ShapeDecoration(
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                            color: Colors.orange[300],
                          ),*/
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[

                              Icon(Icons.directions_walk,size: 40.0,color: Colors.white),
                              //      SizedBox(width: 5.0,),
                              Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 15.0),

                                        child: Text('Leave',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0,color: Colors.white),)
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_right,size: 50.0,color: Colors.white),

                            ],

                          ),
                        ),


                            )
                      ]
                  ),

                  new Divider(height: 4.5,),
                  new Row(


                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[

                        //     Expanded(
                        new RaisedButton(
                          color: Colors.green[400],
                          elevation: 4.0,
                          splashColor: Colors.greenAccent,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TimeOffApp()),
                            );
                          },
                          child:Container(

                            width:MediaQuery.of(context).size.width*0.80,
                            height:MediaQuery.of(context).size.height*0.10,
                            padding: EdgeInsets.fromLTRB(0.0, 5.0, 3.0, 5.0),
                         /*   decoration: new ShapeDecoration(
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                              color: Colors.orange[300],
                            ),*/
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[

                                Icon(Icons.alarm_on,size: 40.0,color: Colors.white),
                                //      SizedBox(width: 5.0,),
                                Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                                  child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 15.0),

                                          child: Text('Time Off',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0,color: Colors.white),)
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right,size: 50.0,color: Colors.white),

                              ],

                            ),
                          ),


                        )
                      ]
                  ),*/

                ])
        ),
      ],
    );
  }
}

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;
  AppHeader(profileimage1,showtabbar1,orgname1){
    profileimage = profileimage1;
    orgname = orgname1;
    // print("--------->");
    // print(profileimage);
    //  print("--------->");
    //   print(_checkLoadedprofile);
    if (profileimage!=null) {
      _checkLoadedprofile = false;
      //    print(_checkLoadedprofile);
    };
    showtabbar= showtabbar1;
  }
  /*void initState() {
    super.initState();
 //   initPlatformState();
  }
*/
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
                  MaterialPageRoute(builder: (context) => HomePageMain()),
                );
              },),
            /*GestureDetector(
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
                        image: _checkLoadedprofile ? AssetImage('assets/avatar.png') : profileimage,
                      )
                  )
              ),
            ),*/
            Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(orgname,overflow: TextOverflow.ellipsis,)
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
              //   unselectedLabelColor: Colors.white70,
              //   indicatorColor: Colors.white,
              //   icon: Icon(choice.icon),
            );
          }).toList(),
        ):null
    );
  }
  @override
  Size get preferredSize => new Size.fromHeight(showtabbar==true ? 100.0 : 60.0);

}



