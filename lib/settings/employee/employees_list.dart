import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/CirclePainter.dart';
import 'package:ubihrm/settings/employee/addedit_employee.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/home.dart';
import 'package:ubihrm/profile.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/services/services.dart';
import 'package:ubihrm/settings/employee/view_employee.dart';
import '../../drawer.dart';
import '../../model/model.dart';
import '../settings.dart';

class EmployeeList extends StatefulWidget {
  final int sts;
  final String from;
  EmployeeList({Key key,this.sts,this.from}): super(key:key);

  @override
  _EmployeeList createState() => _EmployeeList();
}
TextEditingController dept;
class _EmployeeList extends State<EmployeeList> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AnimationController _controller;
  int profiletype = 0;
  int empCount = 0;
  double tabCount = 0;
  int count = 0;
  int limit;
  bool _shouldAnimate = true;
  String orgName = "";
  String empname = "";
  var profileimage;
  bool showtabbar;
  String buysts = '0';
  int hrsts=0;
  int adminsts=0;
  int divhrsts=0;
  Employee emp;
  //int plansts=0;
  //int empcount=0;

  final List<String> data = new List();
  int initPosition = 0;

  TextEditingController _searchController;
  FocusNode searchFocusNode;
  bool res=true;
  bool _checkLoadedprofile = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
    dept = new TextEditingController();
    _searchController = new TextEditingController();
    searchFocusNode = FocusNode();
    profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);
    initPlatformState();
    getOrgName();
    getEmpCount(widget.from).then((res) {
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

  initPlatformState() async{
    final prefs = await SharedPreferences.getInstance();
    String empid = prefs.getString('employeeid')??"";
    String organization =prefs.getString('organization')??"";
    emp = new Employee(employeeid: empid, organization: organization);
    await getProfileInfo(emp, context);
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _controller.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  getOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName = prefs.getString('orgname') ?? '';
      profiletype = prefs.getInt('profiletype') ?? 0;
      hrsts =prefs.getInt('hrsts')??0;
      adminsts =prefs.getInt('adminsts')??0;
      divhrsts =prefs.getInt('divhrsts')??0;
      plansts = prefs.getInt('plansts');
      empcount = prefs.getInt('empcount');
    });
  }

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  Future<bool> move() async {
    if(widget.sts==1 && widget.sts==4) {
      await getProfileInfo(emp, context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePageMain()), (
          Route<dynamic> route) => false,
      );
    }else if(widget.sts==2) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AllSetting()), (
          Route<dynamic> route) => false,
      );
    }else{
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePageMain()), (
          Route<dynamic> route) => false,
      );
    }
    return false;
  }

  getmainhomewidget() {
    return new WillPopScope(
      onWillPop: () => move(),
      child: RefreshIndicator(
        child: new Scaffold(
          backgroundColor: scaffoldBackColor(),
          key: _scaffoldKey,
          appBar: EmployeeListAppHeader(profileimage,showtabbar,orgName),
          endDrawer: AppDrawer(),
          bottomNavigationBar: new HomeNavigation(),
          body: mainbodyWidget(),
          floatingActionButton: (adminsts==1||hrsts==1||divhrsts==1)?(plansts==0 && empcount<2)?
          CustomPaint(
            painter: CirclePainter(
              1,
              _controller,
              color: appStartColor(),
            ),
            child: ScaleTransition(
              scale: Tween(begin: 0.90, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: Curves.fastOutSlowIn,
                ),
              ),
              child: new FloatingActionButton(
                backgroundColor: Colors.orange[800],
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditEmployee(sts: 4)),
                  );
                },
                tooltip: 'Add Employee',
                child: new Icon(Icons.person_add_alt_1),
              )
            )
          ):new FloatingActionButton(
            backgroundColor: Colors.orange[800],
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditEmployee(sts: 4)),
              );
            },
            tooltip: 'Add Employee',
            child: new Icon(Icons.person_add_alt_1),
          ):Center()
        ),
        onRefresh: () async {
          Completer<Null> completer = new Completer<Null>();
          await Future.delayed(Duration(seconds: 1)).then((onvalue) {
            setState(() {
              _searchController.clear();
              empname='';
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            });
            completer.complete();
          });
          return mainbodyWidget();
        },
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
                          //labelText: 'Search Employee',
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
              empCount!=0?_searchController.text.isEmpty?Padding(
                padding: const EdgeInsets.only(top:90.0),
                child: tabBarView()
              ):Padding(
                padding: const EdgeInsets.only(top:90.0),
                child: Center(child: getEmpWidget(0, empCount),),
              ):Center(
                child: Container(
                  width: MediaQuery.of(context).size.width*1,
                  color: appStartColor().withOpacity(0.1),
                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                  child:Text("No Team found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                ),
              ),
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
        pageBuilder: (context, index) => Center(child: getEmpWidget(index, 10)),
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

  getEmpWidget(int index, int limit) {
    return new FutureBuilder<List<Emp>>(
      future: getEmployee(index*10, limit, empname, widget.from),
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
                                new Container(
                                  margin: EdgeInsets.only(left: 5.0),
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(snapshot.data[index].Profile.toString())
                                    )
                                  )
                                ),
                                SizedBox(width: 10.0,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            child: Tooltip(
                                              message: 'View',
                                              child: Icon(
                                                Icons.visibility,
                                                color: Colors.blue,
                                                size: 22.0,
                                              ),
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
                                                        empid: snapshot.data[index].Id.toString(),
                                                        sts: widget.sts,
                                                        from: widget.from
                                                      )),
                                            );
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
                  onTap: () {
                    Navigator
                        .push(
                      context,
                      MaterialPageRoute(
                          builder: (
                              context) =>
                              ViewEmployee(
                                  empid: snapshot.data[index].Id.toString(),
                                  sts: widget.sts
                              )),
                    );
                  },
                );
              },
            );
          } else{
            return new Center(
              child: Container(
                width: MediaQuery.of(context).size.width*1,
                color: appStartColor().withOpacity(0.1),
                padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                child:Text("No Team found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
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

class EmployeeListAppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;
  EmployeeListAppHeader(profileimage1,showtabbar1,orgname1){
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
