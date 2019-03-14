import 'package:flutter/material.dart';
import 'drawer.dart';
import 'graphs.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'global.dart';
import 'services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'model/model.dart';
import 'myleave.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'services/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'home.dart';
import 'package:ubihrm/approval.dart';
//import 'bottom_navigationbar.dart';
import 'b_navigationbar.dart';

class RequestLeave extends StatefulWidget {
  @override
  _RequestLeaveState createState() => _RequestLeaveState();
}

class _RequestLeaveState extends State<RequestLeave> {
  bool isServiceCalling = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String leavetypeid="32";
  List<Map> leavetimeList = [{"id":"2","name":"Half Day"},{"id":"1","name":"Full Day"}];
  List<Map> leavetypeList = [];

  String leavetimevalue = "1";
  String leavetimevalue1 = "1";
  String leavetypevalue = "1";
  bool isloading = false;
  String admin_sts='0';
  String leavetype='0';
  DateTime Date1 = new DateTime.now();
  DateTime Date2 = new DateTime.now();
  final _dateController = TextEditingController();
  final _dateController1 = TextEditingController();
  final _leavetimevalueController = TextEditingController();
  final _leavetimevalueController1 = TextEditingController();
  final _reasonController = TextEditingController();
  FocusNode textSecondFocusNode = new FocusNode();
  FocusNode textthirdFocusNode = new FocusNode();
  FocusNode textfourthFocusNode = new FocusNode();
  final dateFormat = DateFormat("d MMMM");
  final timeFormat = DateFormat("h:mm a");
  final _formKey = GlobalKey<FormState>();
  String _radioValue = "1"; // half day from type
  String _radioValue1 = "1"; // half day to type
  bool visibilityFromHalf = false;
  bool visibilityToHalf = false;
  int _currentIndex = 0;
  int response;
  Widget mainWidget= new Container(width: 0.0,height: 0.0,);

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async{
    final prefs = await SharedPreferences.getInstance();
    mainWidget = loadingWidget();
    String empid = prefs.getString('employeeid')??"";
    String organization =prefs.getString('organization')??"";

    Employee emp = new Employee(employeeid: empid, organization: organization);

    //if(empid!='')
      //bool ish = await getAllPermission(emp);

    //getModulePermission("178","view");
    //getProfileInfo();
    //getReportingTeam();
    /*islogin().then((Widget configuredWidget) {
      setState(() {
        mainWidget = configuredWidget;
      });
    });*/
  }

  void _handleRadioValueChange(String value) {
    setState(() {
      _radioValue = value;
    });
  }

  void _handleRadioValueChange1(String value) {
    setState(() {
      _radioValue1 = value;
    });
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }

  requestleave(var leavefrom, var leaveto, var leavetypefrom, var leavetypeto, var halfdayfromtype, var halfdaytotype, var reason) async{
    setState(() {
      isServiceCalling = true;
    });
    print("----> service calling "+isServiceCalling.toString());
    final prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("employeeid")??"";
    String orgid = prefs.getString("organization")??"";
    Leave leave =new Leave(uid: uid, leavefrom: leavefrom, leaveto: leaveto, orgid: orgid, reason: reason, leavetypeid: leavetype, leavetypefrom: leavetypefrom, leavetypeto: leavetypeto, halfdayfromtype: halfdayfromtype, halfdaytotype: halfdaytotype);
    var islogin1 = await requestLeave(leave);
    print("---ss>"+islogin1);
    if(islogin1=="true"){
      showInSnackBar("Leave has been applied successfully.");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyLeave()), (Route<dynamic> route) => false,
      );
    }else if(islogin1=="false"){
      setState(() {
        isServiceCalling = false;
      });
      showInSnackBar("Leave is already applied for this date.");
    }else{
      setState(() {
        isServiceCalling = false;
      });
      showInSnackBar("Poor Network Connection");
    }
  }

/*  Future<Widget> islogin() async{
    final prefs = await SharedPreferences.getInstance();
    int response = prefs.getInt('response')??0;
    if(response==1){
      return mainScafoldWidget();
    }else{
      return new LoginPage();
    }

  }*/

  @override
  Widget build(BuildContext context) {
    mainWidget = mainScafoldWidget();
    return mainWidget;
  }


  Widget loadingWidget(){
    return Center(child:SizedBox(

      child:
      Text("Loading..", style: TextStyle(fontSize: 10.0,color: Colors.white),),
    ));
  }



  Widget mainScafoldWidget(){
    return  Scaffold(
        key: _scaffoldKey,
        backgroundColor:scaffoldBackColor(),
        endDrawer: new AppDrawer(),
        appBar: GradientAppBar(
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
        ),
        bottomNavigationBar:  new HomeNavigation(),
      /*  bottomNavigationBar:new Theme(
            data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: bottomNavigationColor(),
            ), // sets the inactive color of the `BottomNavigationBar`
            child:  BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (newIndex) {
                if (newIndex == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                  return;
                }
                if (newIndex == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TabbedApp()),
                  );
                  return;
                }
                if (newIndex == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TabbedApp()),
                  );
                  return;
                }else if (newIndex == 0) { Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TabbedApp()),
                );

                /* (admin_sts == '1')
                  ? Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Reports()),
              )
                  : Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );*/

                return;
                }

                setState(() {
                  _currentIndex = newIndex;
                });
              }, // this will be set when a new tab is tapped
              items: [
                BottomNavigationBarItem(

                  // icon:  new Image.asset("assets/repo.ico", height: 25.0, width: 30.0),

                  //   new Tab(icon: new Image.asset("assets/img/logo.png"), text: "Browse"),
                  /* icon: new Icon(
                    Icons.library_books,
                    color: Colors.white,
                  ),*/

                  icon: Icon(
                      Icons.description,
                      color: Colors.white,
                      size: 25.0),

                  title: new Text('Reports',style: TextStyle(color: Colors.white)),
                ),
                BottomNavigationBarItem(
                  /*   icon: new Icon(
                    Icons.home,
                    color: Colors.orangeAccent,
                  ),*/
                  icon:  new Image.asset("assets/Hom.png", height: 30.0, width: 30.0),

                  title: new Text('Home', style: TextStyle(color: Colors.orangeAccent)),

                ),
                BottomNavigationBarItem(
                  /*  icon:  new Image.asset("assets/approval.png",
                      height: 40.0,
                      width: 35.0),*/
                  icon: Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 25.0),
                  title: new Text('Approvals',style: TextStyle(color: Colors.white)),
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 25.0 ),
                    title: Text('Settings',style: TextStyle(color: Colors.white)))

              ],
            )),*/
        body:  ModalProgressHUD(
    inAsyncCall: isServiceCalling,
    opacity: 0.15,
    progressIndicator: SizedBox(
    child:new CircularProgressIndicator(
    valueColor: new AlwaysStoppedAnimation(Colors.green),
    strokeWidth: 5.0),
    height: 50.0,
    width: 50.0,
    ),
    child: homewidget()
        )

    );
  }

  Widget homewidget(){
    return Stack(
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
    child: Column( children: <Widget>[
    SizedBox(height: 20.0),
    Text('Request Leave',
    style: new TextStyle(fontSize: 22.0, color: Colors.teal)),
    new Divider(color: Colors.black54,height: 1.5,),
    new Expanded(child: ListView(
    //padding: EdgeInsets.symmetric(horizontal: 15.0),
    children: <Widget>[
    Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[


      getLeaveType_DD(),
    SizedBox(height: 20.0),
    //Enter date
    Row(
    children: <Widget>[
   new Expanded(
    child: Container(
     // margin: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
      height: 70.0,
      child:DateTimePickerFormField(

    firstDate: new DateTime.now(),
    initialDate: new DateTime.now(),

    dateOnly: true,
    format: dateFormat,
    controller: _dateController,
    decoration: InputDecoration(
    prefixIcon: Padding(
    padding: EdgeInsets.all(0.0),
    child: Icon(
    Icons.date_range,
    color: Colors.grey,
    ), // icon is 48px widget.
    ), // icon is 48px widget.
    labelText: 'From Date',
    ),
    validator: (date) {
    if (date==null){
    return 'Please enter Leave From date';
    }
    },
    onChanged: (dt) {
    setState(() {
    Date1 = dt;
    });
    print("----->Changed date------> "+Date1.toString());
    },
    ),
    ),

            ),
    SizedBox(width: 10.0),
    Expanded(
    child: new InputDecorator(
    decoration: InputDecoration(
   // labelText: 'Leave Type',

    prefixIcon: Padding(
    padding: EdgeInsets.all(0.0),
    child: Icon(
    Icons.tonality,
    color: Colors.grey,
    ), // icon is 48px widget.
    ),
      border: new UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white,
            width: 0.0, style: BorderStyle.none ),),
    ),
    //   isEmpty: _color == '',
    child:  new DropdownButton<String>(
    isDense: true,
    style: new TextStyle(
    fontSize: 15.0,
    color: Colors.black
    ),
    value: leavetimevalue,
    onChanged: (String newValue) {
    setState(() {
    leavetimevalue = newValue;
    if(leavetimevalue=="2"){
    visibilityFromHalf = true;
    }else{
    visibilityFromHalf = false;
    }
    });
    },
    items: leavetimeList.map((Map map) {
    return new DropdownMenuItem<String>(
    value: map["id"].toString(),

    child: new Text(
    map["name"],
    ),
    );
    }).toList(),
    ),
    ),
    ),
    ],
    ),
    (visibilityFromHalf)?Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
    new Radio(
    value: "1",
    groupValue: _radioValue,
    onChanged: _handleRadioValueChange,
    ),
    Text("First Half",style: TextStyle(fontSize: 16.0),),
    SizedBox(width: 30.0,),
    new Radio(
    value: "2",
    groupValue: _radioValue,
    onChanged: _handleRadioValueChange,
    ),
    Text("Second Half",style: TextStyle(fontSize: 16.0),)
    ],
    ):Container(),
    SizedBox(height: 10.0,),
    Row(
    children: <Widget>[
      new Expanded(
      child: Container(
          // margin: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
      height: 70.0,
     child:DateTimePickerFormField(
    firstDate: new DateTime.now(),
    initialDate: new DateTime.now(),
    dateOnly: true,
    format: dateFormat,
    controller: _dateController1,
    decoration: InputDecoration(
    prefixIcon: Padding(
    padding: EdgeInsets.all(0.0),
    child: Icon(
    Icons.date_range,
    color: Colors.grey,
    ), // icon is 48px widget.
    ), // icon is 48px widget.

    labelText: 'To Date',
    ),
    onChanged: (dt) {
    setState(() {
    Date2 = dt;
    });
    print("----->Changed date------> "+Date1.toString());
    },
    validator: (dt) {
    if (dt==null){
    return 'Please enter Leave to date';
    }
    if(Date2.isBefore(Date1)){
    print("Dat1 ---->"+Date1.toString());
    print("Date2---->"+Date2.toString());
    return '\"To Date\" can\'t be smaller.';
    }

    },
    ),
    ),
            ),
    SizedBox(width: 10.0),
    Expanded(
    child:new InputDecorator(
    decoration: InputDecoration(
   // labelText: 'Leave Type',
    prefixIcon: Padding(
    padding: EdgeInsets.all(0.0),
    child: Icon(
    Icons.tonality,
    color: Colors.grey,
    ), // icon is 48px widget.
    ),
    ),
    //   isEmpty: _color == '',
    child:  new DropdownButton<String>(
    isDense: true,
    style: new TextStyle(
    fontSize: 15.0,
    color: Colors.black
    ),
    value: leavetimevalue1,
    onChanged: (String newValue) {
    setState(() {
    leavetimevalue1 = newValue;
    if(leavetimevalue1=="2"){
    visibilityToHalf = true;
    }else{
    visibilityToHalf = false;
    }
    });
    },
    items: leavetimeList.map((Map map) {
    return new DropdownMenuItem<String>(
    value: map["id"].toString(),
    child: new Text(
    map["name"],
    ),
    );
    }).toList(),
    ),
    )
    ),


    ],
    ),

    (visibilityToHalf)?Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
    new Radio(
    value: "1",
    groupValue: _radioValue1,
    onChanged: _handleRadioValueChange1,
    ),
    Text("First Half",style: TextStyle(fontSize: 16.0),),
    SizedBox(width: 30.0,),
    new Radio(
    value: "2",
    groupValue: _radioValue1,
    onChanged: _handleRadioValueChange1,
    ),
    Text("Second Half",style: TextStyle(fontSize: 16.0),)
    ],
    ):Container(),

    TextFormField(
    controller: _reasonController,
    decoration: InputDecoration(
    labelText: 'Reason',
    prefixIcon: Padding(
    padding: EdgeInsets.all(0.0),
    child: Icon(
    Icons.event_note,
    color: Colors.grey,
    ), // icon is 48px widget.
    )
    ),
    validator: (value) {
    if (value.isEmpty) {
    return 'Please enter reason';
    }
    },
    onFieldSubmitted: (String value) {
    if (_formKey.currentState.validate()) {
    //requesttimeoff(_dateController.text ,_starttimeController.text,_endtimeController.text,_reasonController.text, context);
    }
    },
    maxLines: 3,
    ),
    ButtonBar(
    children: <Widget>[

      RaisedButton(
        child: isServiceCalling?Text('Processing',style: TextStyle(color: Colors.white),):Text('APPLY',style: TextStyle(color: Colors.white),),
        color: Colors.orangeAccent,
        onPressed: () {
          if (_formKey.currentState.validate()) {

            requestleave(_dateController.text, _dateController1.text ,leavetimevalue, leavetimevalue1, _radioValue, _radioValue1, _reasonController.text);
          }
        },
      ),
    FlatButton(
    shape: Border.all(color: Colors.black54),
    child: Text('CANCEL'),
    onPressed: () {
    Navigator.of(context).pop();
    },
    ),

    ],
    ),
    ],
    ),

    ],
    ),
    )
    ]
    )
    ),
    ),

    ),




      ],
    );
  }

  ////////////////common dropdowns
  Widget getLeaveType_DD() {
    String dc = "0";
    return new FutureBuilder<List<Map>>(
        future: getleavetype(0), //with -select- label
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new Container(
              //    width: MediaQuery.of(context).size.width*.45,
              padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Leave Type',


                  // icon is 48px widget.

                ),

                child:  new DropdownButton<String>(
                  isDense: true,
                  style: new TextStyle(
                      fontSize: 15.0,
                      color: Colors.black
                  ),
                  value: leavetype,
                  onChanged: (String newValue) {
                    setState(() {
                      leavetype =newValue;
                    });
                  },
                  items: snapshot.data.map((Map map) {
                    return new DropdownMenuItem<String>(
                      value: map["Id"].toString(),
                      child:  new SizedBox(
                          width: 200.0,
                          child: new Text(
                            map["Name"],
                          )
                      ),
                    );
                  }).toList(),

                ),
              ),
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          // return loader();
          return new Center(child: SizedBox(
            child: CircularProgressIndicator(strokeWidth: 2.2,),
            height: 20.0,
            width: 20.0,
          ),);
        });
  }
}
