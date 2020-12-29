import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/attandance/image_view.dart';
import 'package:ubihrm/attandance/view_employee.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/edit_employee.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'drawer.dart';
import 'settings.dart';

class EmployeeList extends StatefulWidget {
  @override
  _EmployeeList createState() => _EmployeeList();
}
TextEditingController dept;
class _EmployeeList extends State<EmployeeList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int adminsts = 0;
  int profiletype = 0;

  int empCount = 0;
  double tabCount = 0;
  int count = 0;
  int limit;
  bool _shouldAnimate = true;

  String orgname = "";
  String empname = "";

  String buysts = '0';

  final List<String> data = new List();
  int initPosition = 0;

  TextEditingController _searchController;
  FocusNode searchFocusNode;
  bool res=true;

  @override
  void initState() {
    super.initState();
    dept = new TextEditingController();
    _searchController = new TextEditingController();
    searchFocusNode = FocusNode();
    getOrgName();
    getEmpCount().then((res) {
      setState(() {
        empCount = res;
        tabCount = (empCount / 10);
        count = tabCount.ceil();
        for (int i = 1; i <= count; i++) {
          data.add("Page " + i.toString());
        }
      });
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    searchFocusNode.dispose();
    super.dispose();
  }

  getOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgname = prefs.getString('orgname') ?? '';
      profiletype = prefs.getInt('profiletype') ?? 0;
      adminsts = prefs.getInt('adminsts') ?? 0;
      //buysts= prefs.getString('buysts') ?? '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  Future<bool> move() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AllSetting()), (
        Route<dynamic> route) => false,
    );
    return false;
  }

  getmainhomewidget() {
    return new WillPopScope(
      onWillPop: () => move(),
      child: new Scaffold(
        backgroundColor: scaffoldBackColor(),
        key: _scaffoldKey,
        appBar: AppBar(
          titleSpacing: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(orgname, style: new TextStyle(fontSize: 20.0)),
            ],
          ),
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
            move();
          }),
          backgroundColor: appStartColor(),
        ),
        endDrawer: AppDrawer(),
        bottomNavigationBar: new HomeNavigation(),
        body: mainbodyWidget(),
      ),
    );
  }

  mainbodyWidget() {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          decoration: new ShapeDecoration(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            color: Colors.white,
          ),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      'Employees',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: appStartColor(),
                      ),
                    )
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                          labelText: 'Search Employee',
                          suffixIcon: _searchController.text.isNotEmpty?IconButton(icon: Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EmployeeList()),
                                );
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
                ],
              ),

              _searchController.text.isEmpty?Padding(
                padding: const EdgeInsets.only(top:90.0),
                child: tabBarView()
              ):Padding(
                padding: const EdgeInsets.only(top:90.0),
                child: Center(child:getDeptWidget(0, empCount),),
              )
            ],
          ),
        ),
      ],
    );
  }

  tabBarView(){
    return Container(
      child: CustomTabView(
        initPosition: initPosition,
        itemCount: data.length,
        tabBuilder: (context, index) => Tab(text: data[index]),
        pageBuilder: (context, index) => Center(child: getDeptWidget(index, 10)),
        onPositionChange: (index) {
          print('current position: $index');
          initPosition = index;
        },
        //onScroll: (position) => print('$position'),
      ),
    );
  }

  showDialogWidget(String loginstr) {
    return showDialog(context: context, builder: (context) {
      return new AlertDialog(
        title: new Text(
          loginstr,
          style: TextStyle(fontSize: 15.0),),
        content: ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Text('Later', style: TextStyle(fontSize: 13.0)),
              shape: Border.all(),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            /*RaisedButton(
              child: Text(
                'Pay Now', style: TextStyle(color: Colors.white,fontSize: 13.0),),
              color: Colors.orangeAccent,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage()),
                );
              },
            ),*/

          ],
        ),
      );
    }
    );
  }

  getDeptWidget(int index, int limit) {
    return new FutureBuilder<List<Emp>>(
      future: getEmployee(index*10, limit, empname),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("snapshot.data.length");
          print(snapshot.data.length);
          if(snapshot.data.length>0) {
            return new ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  child: new Column(
                    children: <Widget>[
                      SizedBox(height: 5.0,),
                      Wrap(
                        children: <Widget>[
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment
                                  .center,
                              children: <Widget>[
                                InkWell(
                                  child: new Container(
                                      margin: EdgeInsets.only(left: 5.0),
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  snapshot.data[index].Profile.toString())
                                          )
                                      )
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ImageView(
                                                  myimage: snapshot.data[index].Profile,
                                                  org_name: orgname)),
                                    );
                                  },
                                ),
                                SizedBox(width: 10.0,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.63,
                                          child: new Text(
                                            snapshot.data[index].Name
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 15.0, fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        new InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Icon(
                                              Icons.visibility_outlined,
                                              color: Colors.blue,
                                              size: 22.0,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator
                                                .push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (
                                                      context) =>
                                                      ViewEmployee(
                                                          empid: snapshot.data[index]
                                                              .Id
                                                              .toString(),
                                                          profileimg: snapshot.data[index]
                                                              .Profile
                                                              .toString(),
                                                          empcode: snapshot.data[index]
                                                            .EmpCode
                                                            .toString(),
                                                          fname: snapshot.data[index]
                                                              .FName
                                                              .toString(),
                                                          lname: snapshot.data[index]
                                                              .LName
                                                              .toString(),
                                                          dob: snapshot.data[index]
                                                              .DOB
                                                              .toString(),
                                                          nationality: snapshot.data[index]
                                                              .Nationality
                                                              .toString(),
                                                          maritalsts: snapshot.data[index]
                                                            .MaritalSts
                                                            .toString(),
                                                          religion: snapshot.data[index]
                                                              .Religion
                                                              .toString(),
                                                          bloodg: snapshot.data[index]
                                                              .BloodG
                                                              .toString(),
                                                          doc: snapshot.data[index]
                                                              .DOC
                                                              .toString(),
                                                          gender: snapshot.data[index]
                                                              .Gender
                                                              .toString(),
                                                          reportingto: snapshot.data[index]
                                                            .ReportingTo
                                                            .toString(),
                                                          div: snapshot.data[index]
                                                              .Division
                                                              .toString(),
                                                          divid: snapshot.data[index]
                                                              .DivisionId
                                                              .toString(),
                                                          dept: snapshot.data[index]
                                                            .Department
                                                            .toString(),
                                                          deptid: snapshot.data[index]
                                                            .DepartmentId
                                                            .toString(),
                                                          desg: snapshot.data[index]
                                                            .Designation
                                                            .toString(),
                                                          desgid: snapshot.data[index]
                                                            .DesignationId
                                                            .toString(),
                                                          loc: snapshot.data[index]
                                                            .Location
                                                            .toString(),
                                                          locid: snapshot.data[index]
                                                            .LocationId
                                                            .toString(),
                                                          shift: snapshot.data[index]
                                                              .Shift
                                                              .toString(),
                                                          shiftid: snapshot.data[index]
                                                              .ShiftId
                                                              .toString(),
                                                          empsts: snapshot.data[index]
                                                              .EmpSts
                                                              .toString(),
                                                          grade: snapshot.data[index]
                                                              .Grade
                                                              .toString(),
                                                          emptype: snapshot.data[index]
                                                            .EmpType
                                                            .toString(),
                                                          email: snapshot.data[index]
                                                            .Email
                                                            .toString(),
                                                          phone: snapshot.data[index]
                                                            .Mobile
                                                            .toString(),
                                                          father: snapshot.data[index]
                                                              .FatherName
                                                              .toString(),
                                                          doj: snapshot.data[index]
                                                              .DOJ
                                                              .toString(),
                                                          profiletype: snapshot.data[index]
                                                            .ProfileType
                                                            .toString(),
                                                          )),
                                            );
                                            /*showDialog<String>(
                                              context: context,
                                              // ignore: deprecated_member_use
                                              child: AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(10),
                                                ),
                                                contentPadding: const EdgeInsets
                                                    .all(15.0),
                                                content: Wrap(
                                                  children: <Widget>[
                                                    Container(
                                                      height: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .height * 0.45,
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.70,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .end,
                                                            children: <
                                                                Widget>[
                                                              InkWell(
                                                                highlightColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                child:
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      "Edit",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .blueAccent,
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight
                                                                              .w600
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                onTap: () {
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
                                                                                fname: snapshot.data[index]
                                                                                    .FName
                                                                                    .toString(),
                                                                                lname: snapshot.data[index]
                                                                                    .LName
                                                                                    .toString(),
                                                                                phone: snapshot.data[index]
                                                                                    .Mobile
                                                                                    .toString(),
                                                                                email: snapshot.data[index]
                                                                                    .Email
                                                                                    .toString(),
                                                                                department: snapshot.data[index]
                                                                                    .DepartmentId
                                                                                    .toString(),
                                                                                designation: snapshot.data[index]
                                                                                    .DesignationId
                                                                                    .toString(),
                                                                                shift: snapshot.data[index]
                                                                                    .ShiftId
                                                                                    .toString(),
                                                                                empid: snapshot.data[index]
                                                                                    .Id
                                                                                    .toString())),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          InkWell(
                                                            child: Container(
                                                                width: 70.0,
                                                                height: 70.0,
                                                                decoration: new BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    image: new DecorationImage(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        image:
                                                                        NetworkImage(
                                                                            snapshot.data[index]
                                                                                .Profile
                                                                                .toString())
                                                                    )
                                                                )
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: 10.0),
                                                          new Text(
                                                            snapshot.data[index]
                                                                .Name
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontSize: 18.0,
                                                                fontWeight: FontWeight
                                                                    .w600
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20,),
                                                          Table(
                                                            defaultVerticalAlignment: TableCellVerticalAlignment
                                                                .top,
                                                            columnWidths: {
                                                              0: FlexColumnWidth(
                                                                  8),
                                                              // 0: FlexColumnWidth(4.501), // - is ok
                                                              // 0: FlexColumnWidth(4.499), //- ok as well
                                                              1: FlexColumnWidth(
                                                                  5),
                                                            },
                                                            children: [
                                                              globallabelinfomap["depart"]!=""?TableRow(
                                                                  children: [
                                                                    TableCell(
                                                                      child: Row(
                                                                        children: <
                                                                            Widget>[
                                                                          new Text(
                                                                            globallabelinfomap["depart"]+':',
                                                                            style: TextStyle(
                                                                              color: Colors
                                                                                  .black87,
                                                                              fontSize: 15.0,
                                                                              fontWeight: FontWeight
                                                                                  .w400,
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
                                                                              snapshot.data[index]
                                                                                  .Department
                                                                                  .toString(),
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .black87,
                                                                                  fontSize: 15.0,
                                                                                  fontWeight: FontWeight
                                                                                      .bold
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ]
                                                              ):Center(),
                                                              globallabelinfomap["desig"]!=""?TableRow(
                                                                  children: [
                                                                    TableCell(
                                                                      child: Row(
                                                                        children: <
                                                                            Widget>[
                                                                          new Text(
                                                                            globallabelinfomap["desig"]+':',
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .black87,
                                                                                fontSize: 15.0,
                                                                                fontWeight: FontWeight
                                                                                    .w400
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
                                                                              snapshot.data[index]
                                                                                  .Designation
                                                                                  .toString(),
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .black87,
                                                                                  fontSize: 15.0,
                                                                                  fontWeight: FontWeight
                                                                                      .bold
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ]
                                                              ):Center(),
                                                              globallabelinfomap["personal_no"]!=""?TableRow(
                                                                  children: [
                                                                    TableCell(
                                                                      child: Row(
                                                                        children: <
                                                                            Widget>[
                                                                          new Text(
                                                                            globallabelinfomap["personal_no"]+':',
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .black87,
                                                                                fontSize: 15.0,
                                                                                fontWeight: FontWeight
                                                                                    .w400
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
                                                                              snapshot.data[index]
                                                                                  .Mobile
                                                                                  .toString(),
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .black87,
                                                                                  fontSize: 15.0,
                                                                                  fontWeight: FontWeight
                                                                                      .bold
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ]
                                                              ):Center(),
                                                              globallabelinfomap["shift"]!=""?TableRow(
                                                                  children: [
                                                                    TableCell(
                                                                      child: Row(
                                                                        children: <
                                                                            Widget>[
                                                                          new Text(
                                                                            globallabelinfomap["shift"]+':',
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .black87,
                                                                                fontSize: 15.0,
                                                                                fontWeight: FontWeight
                                                                                    .w400
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
                                                                              snapshot.data[index]
                                                                                  .Shift
                                                                                  .toString(),
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .black87,
                                                                                  fontSize: 15.0,
                                                                                  fontWeight: FontWeight
                                                                                      .bold
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ]
                                                              ):Center(),
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
                                                                                    .w400
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
                                                                              snapshot.data[index]
                                                                                  .ProfileType
                                                                                  .toString(),
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .green,
                                                                                  fontSize: 15.0,
                                                                                  fontWeight: FontWeight
                                                                                      .bold
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
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );*/
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.0,)
                    ]
                  ),
                );
              },
            );
          } else{
            return new Center(
              child: Container(
                width: MediaQuery.of(context).size.width*1,
                color: appStartColor().withOpacity(0.1),
                padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                child:Text("No employees found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
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

class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  CustomTabView({
    @required this.itemCount,
    @required this.tabBuilder,
    @required this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView> with TickerProviderStateMixin {
  TabController controller;
  int _currentCount;
  int _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition ?? 0;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 :
        _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_){
            if(mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: TabBar(
            isScrollable: true,
            controller: controller,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).hintColor,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
            tabs: List.generate(
              widget.itemCount,
                  (index) => widget.tabBuilder(context, index),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount,
                  (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation.value);
    }
  }
}

