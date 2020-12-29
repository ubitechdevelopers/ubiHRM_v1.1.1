import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/drawer.dart';
import 'package:ubihrm/edit_employee.dart';
import 'package:ubihrm/employees_list.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/profile.dart';
import 'package:ubihrm/services/services.dart';
import 'package:ubihrm/settings.dart';

class ViewEmployee extends StatefulWidget {
  @override
  final String empid;
  final String profileimg;
  final String empcode;
  final String fname;
  final String lname;
  final String dob;
  final String nationality;
  final String maritalsts;
  final String religion;
  final String bloodg;
  final String doc;
  final String gender;
  final String reportingto;
  final String div;
  final String divid;
  final String dept;
  final String deptid;
  final String desg;
  final String desgid;
  final String loc;
  final String locid;
  final String shift;
  final String shiftid;
  final String empsts;
  final String grade;
  final String emptype;
  final String email;
  final String phone;
  final String father;
  final String doj;
  final String profiletype;
  ViewEmployee({Key key,this.empid,this.profileimg,this.empcode,this.fname,this.lname,this.dob,this.nationality,this.maritalsts,this.religion,this.bloodg,this.doc,this.gender,this.reportingto,this.div,this.divid,this.dept,this.deptid,this.desg,this.desgid,this.loc,this.locid,this.shift,this.shiftid,this.empsts,this.grade,this.emptype,this.phone,this.email,this.father,this.doj,this.profiletype}): super(key:key);
  _ViewEmployeeState createState() => _ViewEmployeeState();
}
class _ViewEmployeeState extends State<ViewEmployee> {

  bool isServiceCalling = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  bool isloading = false;
  final dateFormat = DateFormat("d MMM yyyy");
  final timeFormat = DateFormat("h:mm a");
  final _formKey = GlobalKey<FormState>();
  int response;
  var profileimage;
  bool showtabbar;
  String orgName="";

  @override
  void initState() {
    super.initState();
    profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);
    showtabbar=false;
    getOrgName();
  }

  static const rowSpacer=TableRow(
      children: [
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 8,
        )
      ]);

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return mainScafoldWidget();
  }

  Future<bool> sendToSettings() async{
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AllSetting()), (Route<dynamic> route) => false,
    );
    return false;
  }

  Widget mainScafoldWidget(){
    return  WillPopScope(
      onWillPop: ()=> sendToSettings(),
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor:scaffoldBackColor(),
          endDrawer: new AppDrawer(),
          appBar: new ViewEmpAppHeader(profileimage,showtabbar,orgName),
          bottomNavigationBar:  new HomeNavigation(),
          body: ModalProgressHUD(
              inAsyncCall: isServiceCalling,
              opacity: 0.15,
              progressIndicator: SizedBox(
                child:new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation(Colors.green),
                    strokeWidth: 5.0),
                height: 40.0,
                width: 40.0,
              ),
              child: homewidget()
          )
      ),
    );
  }

  Widget homewidget(){
    return SingleChildScrollView(
      child: Stack(
          children: <Widget>[
            Container(
              //height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                //width: MediaQuery.of(context).size.width*0.9,
                decoration: new ShapeDecoration(
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                  color: Colors.white,
                ),
                child:Form(
                    key: _formKey,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0, right:8.0),
                        child: Column(
                          children: <Widget>[
                            widget.profiletype=='Admin'?new InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                    size: 26.0,
                                  ),
                                ),
                              ),
                              onTap: (){
                                Navigator
                                    .of(
                                    context,
                                    rootNavigator: true)
                                    .pop(
                                    'dialog');
                                Navigator
                                    .push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (
                                    context) =>
                                    EditEmployee(
                                        empid: widget.empid,
                                        fname: widget.fname,
                                        lname: widget.lname,
                                        phone: widget.phone,
                                        email: widget.email,
                                        divisionid: widget.divid,
                                        departmentid: widget.deptid,
                                        designationid: widget.desgid,
                                        locationid: widget.locid,
                                        shiftid: widget.shiftid,
                                        )));
                              },
                            ):Center(),
                            InkWell(
                              child: Container(
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape
                                          .circle,
                                      image: new DecorationImage(
                                          fit: BoxFit
                                              .fill,
                                          image:
                                          NetworkImage(widget.profileimg)
                                      )
                                  )
                              ),
                            ),
                            SizedBox(
                                height: 10.0),
                            new Text(
                              widget.fname+" "+widget.lname,
                              style: TextStyle(
                                  color: Colors
                                      .black87,
                                  fontSize: 20.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 20,),
                            Table(
                              defaultVerticalAlignment: TableCellVerticalAlignment.top,
                              columnWidths: {
                                0: FlexColumnWidth(
                                    5),
                                // 0: FlexColumnWidth(4.501), // - is ok
                                // 0: FlexColumnWidth(4.499), //- ok as well
                                1: FlexColumnWidth(
                                    5),
                              },
                              children: [
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              globallabelinfomap['emp_code']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.empcode!='null'?widget.empcode:"",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              globallabelinfomap['dob']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.dob!='null'?widget.dob:"",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              globallabelinfomap['nationality']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.nationality!='null'?widget.nationality:"",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              globallabelinfomap['maritalsts']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.maritalsts!='null'?widget.maritalsts:"",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                        globallabelinfomap['religion']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.religion!='null'?widget.religion:"",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                        globallabelinfomap['bloodg']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.bloodg!='null'?widget.bloodg:"",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                          globallabelinfomap['doc']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.doc!='null'?widget.doc:"",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              globallabelinfomap['gender']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.gender!='null'?widget.gender:"",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              globallabelinfomap['reporting_to']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.reportingto!='null'?widget.reportingto:"",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              globallabelinfomap['division']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.div!='null'?widget.div:"",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              globallabelinfomap['depart']+':',
                                              style: TextStyle(
                                                color: Colors
                                                    .black87,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight
                                                    .w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.dept!='null'?widget.dept:"",
                                                style: TextStyle(
                                                    color: Colors
                                                        .black87,
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              globallabelinfomap['desig']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.desg!='null'?widget.desg:"",
                                                style: TextStyle(
                                                    color: Colors
                                                        .black87,
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              globallabelinfomap['location']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.loc!='null'?widget.loc:"",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              globallabelinfomap['shift']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(widget.shift!='null'?widget.shift:"",
                                                style: TextStyle(
                                                    color: Colors
                                                        .black87,
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              globallabelinfomap['empsts']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.empsts!='null'?widget.empsts:"",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              globallabelinfomap['grade']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.grade!='null'?widget.grade:"",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              globallabelinfomap['emptype']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.emptype!='null'?widget.emptype:"",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              globallabelinfomap['current_email_id']+':',
                                              style: TextStyle(
                                                color: Colors
                                                    .black87,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight
                                                    .w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.email!='null'?widget.email:"",
                                                style: TextStyle(
                                                    color: Colors
                                                        .black87,
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              globallabelinfomap['personal_no']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.phone!='null'?widget.phone:"",
                                                style: TextStyle(
                                                    color: Colors
                                                        .black87,
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              globallabelinfomap['fathername']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.father!='null'?widget.father:"",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              globallabelinfomap['doj']+':',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(
                                                widget.doj!='null'?widget.doj:"",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                rowSpacer,
                                TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            new Text(
                                              'Permissions:',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight
                                                      .w600
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              child: Text(widget.profiletype,
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 15.0,
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      )
                                    ]
                                ),
                              ],
                            ),

                            /*widget.profiletype=='Admin'?ButtonBar(
                              children: <Widget>[
                                RaisedButton(
                                  child: isServiceCalling?Text('Processing..',style: TextStyle(color: Colors.white),):Text('Edit',style: TextStyle(color: Colors.white),),
                                  color: Colors.orange[800],
                                  onPressed: () async {

                                  },
                                ),
                                FlatButton(
                                  shape: Border.all(color: Colors.orange[800]),
                                  child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => EmployeeList()),
                                    );
                                  },
                                ),

                              ],
                            ):Center(),*/
                          ],
                        ),
                      ),
                    )
                )
            )
          ]),
    );
  }
}

class ViewEmpAppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;
  ViewEmpAppHeader(profileimage1,showtabbar1,orgname1){
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
                  MaterialPageRoute(builder: (context) => EmployeeList()), (Route<dynamic> route) => false,
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
                  padding: const EdgeInsets.all(8.0), child: Text(orgname)
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
