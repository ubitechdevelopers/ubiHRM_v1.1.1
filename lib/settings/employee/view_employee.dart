import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/settings/employee/addedit_employee.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/drawer.dart';
import 'package:ubihrm/settings/employee/employees_list.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/profile.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/services/services.dart';

class ViewEmployee extends StatefulWidget {
  @override
  final String empid;
  final int sts;
  ViewEmployee({Key key,this.empid,this.sts/*,this.profileimg,this.empcode,this.fname,this.lname,this.dob,this.nationality,this.maritalsts,this.religion,this.bloodg,this.doc,this.gender,this.reportingto,this.div,this.divid,this.dept,this.deptid,this.desg,this.desgid,this.loc,this.locid,this.shift,this.shiftid,this.empsts,this.grade,this.emptype,this.phone,this.email,this.father,this.doj,this.profiletype*/}): super(key:key);
  _ViewEmployeeState createState() => _ViewEmployeeState();
}

class _ViewEmployeeState extends State<ViewEmployee> {

  bool isServiceCalling = false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  bool isloading = false;
  final dateFormat = DateFormat("d MMM yyyy");
  final timeFormat = DateFormat("h:mm a");
  final _formKey = GlobalKey<FormState>();
  int response;
  var profileimage;
  bool showtabbar;
  String orgName="";
  int hrsts=0;
  int adminsts=0;
  int divhrsts=0;
  bool _checkLoaded = true;
  Future _list;
  List datalist = new List();
  String profileimg="";
  String empcode="";
  String name="";
  String dob="";
  String nationality="";
  String maritalsts="";
  String religion="";
  String bloodg="";
  String doc="";
  String gender="";
  String reportingto="";
  String div="";
  String dept="";
  String desg="";
  String loc="";
  String shift="";
  String empsts="";
  String grade="";
  String emptype="";
  String email="";
  String phone="";
  String father="";
  String doj="";
  String profiletype="";

  @override
  void initState() {
    super.initState();
    _list=getEmployeeDetailById(widget.empid);
    _list.then((data) async{
      setState(() {
        datalist = data;
        print("datalist");
        print(datalist);
        print(datalist[0]["Id"]);
        profileimg=datalist[0]["Profile"];
        print(profileimg);
        empcode=datalist[0]["EmployeeCode"];
        print(empcode);
        name= datalist[0]["name"];
        print(name);
        dob=datalist[0]["DOB"];
        print(dob);
        nationality=datalist[0]["Nationality"];
        print(nationality);
        maritalsts=datalist[0]["MaritalStatus"];
        print(maritalsts);
        religion=datalist[0]["Religion"];
        print(religion);
        bloodg=datalist[0]["BloodGroup"];
        print(bloodg);
        doc=datalist[0]["DOC"];
        print(doc);
        gender=datalist[0]["Gender"];
        print(gender);
        reportingto=datalist[0]["ReportingTo"];
        print(reportingto);
        div=datalist[0]["Division"];
        print(div);
        dept=datalist[0]["Department"];
        print(dept);
        desg=datalist[0]["Designation"];
        print(desg);
        loc=datalist[0]["Location"];
        print(loc);
        shift=datalist[0]["Shift"];
        print(shift);
        empsts=datalist[0]["EmployeeStatus"];
        print(empsts);
        grade=datalist[0]["Grade"];
        print(grade);
        emptype=datalist[0]["EmploymentType"];
        print(emptype);
        email=datalist[0]["Email"];
        print(email);
        if(datalist[0]["CountryCode"]!='')
          phone=datalist[0]["CountryCode"]+" "+datalist[0]["Mobile"];
        else
          phone=datalist[0]["Mobile"];
        print(phone);
        father=datalist[0]["FatherName"];
        print(father);
        doj=datalist[0]["DOJ"];
        print(doj);
        profiletype="("+datalist[0]["ProfileType"]+")";
        print(profiletype);
      });
    });
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
      hrsts =prefs.getInt('hrsts')??0;
      adminsts =prefs.getInt('adminsts')??0;
      divhrsts =prefs.getInt('divhrsts')??0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return mainScafoldWidget();
  }

  Future<bool> sendToSettings() async{
    if(widget.sts==1) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => EmployeeList(sts: widget.sts)), (
          Route<dynamic> route) => false,
      );
    }else if(widget.sts==2) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => EmployeeList(sts: widget.sts)), (
          Route<dynamic> route) => false,
      );
    }else if(widget.sts==3) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => CollapsingTab()), (
          Route<dynamic> route) => false,
      );
    }
    return false;
  }

  Widget mainScafoldWidget(){
    return  WillPopScope(
      onWillPop: ()=> sendToSettings(),
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor:scaffoldBackColor(),
          endDrawer: new AppDrawer(),
          appBar: new ViewEmployeeAppHeader(profileimage,showtabbar,orgName,widget.sts),
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
                            ((adminsts==1||hrsts==1||divhrsts==1) || widget.sts==5)?new InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Tooltip(
                                    message: 'Edit',
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                      size: 26.0,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: (){
                                Navigator
                                    .push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (
                                    context) =>
                                    EditEmployee(
                                        empid: widget.empid,
                                        sts: widget.sts
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
                                          image: NetworkImage(profileimg)
                                      )
                                  )
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Text(
                                  name,
                                  style: TextStyle(
                                      color: Colors
                                          .black87,
                                      fontSize: 20.0,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                new Text(
                                  profiletype,
                                  style: TextStyle(
                                      color: appStartColor(),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              children: <Widget>[
                                new Text("COMPANY DETAILS",
                                  //textAlign: TextAlign.center,
                                  style: new TextStyle(fontWeight: FontWeight.bold, fontSize:16.0, color:Colors.black/*color: appStartColor()*/ ),
                                ),
                                //Spacer()
                              ],
                            ),
                            Divider(),
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
                                          children: <Widget>[
                                            new Text(
                                              globallabelinfomap['emp_code'],
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
                                                empcode!=""?empcode:"",
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
                                              globallabelinfomap['depart'],
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
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                dept!=""?dept:"",
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
                                              globallabelinfomap['division'],
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
                                                div!=""?div:"",
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
                                              globallabelinfomap['desig'],
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
                                                desg!=""?desg:"",
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
                                              globallabelinfomap['location'],
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
                                                loc!=""?loc:"",
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
                                              globallabelinfomap['empsts'],
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
                                                empsts!=""?empsts:"",
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
                                              globallabelinfomap['emptype'],
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
                                                emptype!=""?emptype:"",
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
                                              globallabelinfomap['current_email_id'],
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
                                                email!=""?email:"",
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
                                              globallabelinfomap['grade'],
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
                                                grade!=""?grade:"",
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
                                              globallabelinfomap['shift'],
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
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                shift!=""?shift:"",
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
                                              globallabelinfomap['reporting_to'],
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
                                                reportingto!=""?reportingto:"",
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
                                rowSpacer
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              children: <Widget>[
                                new Text("PERSONAL DETAILS",
                                  //textAlign: TextAlign.center,
                                  style: new TextStyle(fontWeight: FontWeight.bold, fontSize:16.0, color:Colors.black),
                                ),
                                //Spacer()
                              ],
                            ),
                            Divider(),
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
                                              globallabelinfomap['fathername'],
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
                                                father!=""?father:"",
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
                                              globallabelinfomap['maritalsts'],
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
                                                maritalsts!=""?maritalsts:"",
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
                                              globallabelinfomap['dob'],
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
                                                dob!=""?dob:"",
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
                                              globallabelinfomap['bloodg'],
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
                                                bloodg!=""?bloodg:"",
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
                                              globallabelinfomap['gender'],
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
                                                gender!=""?gender:"",
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
                                              globallabelinfomap['nationality'],
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
                                                nationality!=""?nationality:"",
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
                                              globallabelinfomap['religion'],
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
                                                religion!=""?religion:"",
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
                                              globallabelinfomap['doj'],
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
                                                doj!=""?doj:"",
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
                                              globallabelinfomap['doc'],
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
                                                doc!=""?doc:"",
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
                                              globallabelinfomap['personal_no'],
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
                                                phone!=""?phone:"",
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
                                              globallabelinfomap['current_email_id'],
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
                                                email!=""?email:"",
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
                              ],
                            ),
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


class ViewEmployeeAppHeader extends StatelessWidget implements PreferredSizeWidget{
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;
  int sts;

  ViewEmployeeAppHeader(profileimage1,showtabbar1,orgname1, sts1){
    profileimage = profileimage1;
    orgname = orgname1;
    if (profileimage!=null) {
      _checkLoadedprofile = false;
    };
    showtabbar= showtabbar1;
    sts=sts1;
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
                if(sts==1) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => EmployeeList(sts: sts)), (
                      Route<dynamic> route) => false,
                  );
                }else if(sts==2) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => EmployeeList(sts: sts)), (
                      Route<dynamic> route) => false,
                  );
                }else if(sts==3) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => CollapsingTab()), (
                      Route<dynamic> route) => false,
                  );
                }
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
