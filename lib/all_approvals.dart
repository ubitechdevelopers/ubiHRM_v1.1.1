import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/expence/salary_expense_appproval.dart';
import 'package:ubihrm/payroll_expence/payroll_expense_approval.dart';
import 'package:url_launcher/url_launcher.dart';

import 'b_navigationbar.dart';
import 'drawer.dart';
import 'global.dart';
import 'home.dart';
import 'leave/approval.dart';
import 'model/model.dart';
import 'profile.dart';
import 'services/services.dart';
import 'timeoff/timeoff_approval.dart';

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
        perSalaryExpenseApproval=  getModuleUserPermission("170","view");
        perPayrollExpenseApproval=  getModuleUserPermission("473","view");
        print("leave "+perLeaveApproval);
        print("timeoff "+perTimeoffApproval);
        print("salary expense "+perSalaryExpenseApproval);
        print("payroll expense "+perPayrollExpenseApproval);
      });
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

  Future<bool> sendToHome() async{
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

        bottomNavigationBar:  new HomeNavigation(),

        body:getReportsWidget(),

      ),
    );
  }

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
                /*Navigator.push(
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
              //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Approvals',
                      style: new TextStyle(fontSize: 22.0, color: appStartColor()),textAlign: TextAlign.center),
                  //SizedBox(height: 10.0),

                  SizedBox(height: 16.0),
                  perLeaveApproval=='1' ?
                  new RaisedButton(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(
                      //     padding: EdgeInsets.only(left:  5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(const IconData(0xe821, fontFamily: "CustomIcon"), size: 30.0,),
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
                    textColor: Colors.black54,
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
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(const IconData(0xe801, fontFamily: "CustomIcon"),size: 30.0,),
                          SizedBox(width: 15.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text('Time Off',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
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
                        MaterialPageRoute(builder: (context) => TimeOffApp()),
                      );
                    },
                  ):Center(),

                  SizedBox(height: 6.0),
                  perSalaryExpenseApproval=='1' ?
                  new RaisedButton(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(const IconData(0xe800, fontFamily: "CustomIcon"),size: 30.0,),
                          SizedBox(width: 15.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text('Expense',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
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
                        MaterialPageRoute(builder: (context) => SalaryExpenseApproval()),
                      );
                    },
                  ): Center(),

                  SizedBox(height: 6.0),
                  perPayrollExpenseApproval=='1' ?
                  new RaisedButton(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(const IconData(0xe800, fontFamily: "CustomIcon"),size: 30.0,),
                          SizedBox(width: 15.0),
                          Expanded(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text('Expense',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
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
                        MaterialPageRoute(builder: (context) => PayrollExpenseApproval()),
                      );
                    },
                  ): Center(),

                  (perLeaveApproval!='1' &&  perTimeoffApproval!='1' && perSalaryExpenseApproval!='1' && perPayrollExpenseApproval!='1') ?new Center(
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

                ]
            )
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
    if (profileimage!=null) {
      _checkLoadedprofile = false;
      //    print(_checkLoadedprofile);
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
                  MaterialPageRoute(builder: (context) => HomePageMain()),
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



