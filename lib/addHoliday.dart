import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/holiday_list.dart';
import 'package:ubihrm/profile.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/services/services.dart';
import 'package:ubihrm/settings.dart';
import 'all_approvals.dart';
import 'b_navigationbar.dart';
import 'drawer.dart';


class AddHoliday extends StatefulWidget {
  @override
  final String id;
  final String nameController;
  final String fromController;
  final String toController;
  final String desController;
  AddHoliday({Key key, this.id, this.nameController, this.fromController, this.toController, this.desController,}): super(key:key);
  _AddHolidayState createState() => _AddHolidayState();
}

class _AddHolidayState extends State<AddHoliday> {
  bool isServiceCalling = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List _myDivisions;
  String _myDivisionIds;
  List _myLocations;
  String _myLocationIds;
  final formKey = new GlobalKey<FormState>();
  bool isloading = false;
  String division='0';
  String location='0';
  DateTime Date1 = new DateTime.now();
  DateTime Date2 = new DateTime.now();
  final _nameController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _desController = TextEditingController();
  FocusNode textFirstFocusNode = new FocusNode();
  FocusNode textSecondFocusNode = new FocusNode();
  FocusNode textthirdFocusNode = new FocusNode();
  FocusNode textfourthFocusNode = new FocusNode();
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
    _nameController.text=widget.nameController;
    _fromController.text=widget.fromController;
    _toController.text=widget.toController;
    _desController.text=widget.desController;
    super.initState();
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    showtabbar=false;
    getOrgName();
    _myLocations = new List();
    _myDivisions = new List();
  }

  String _radioValue ='1'; //Initial definition of radio button value
  String choice;

  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case '1':
          print("value1");
          print(value);
          choice = value;
          break;
        case '2':
          print("value2");
          print(value);
          choice = value;
          break;
        default:
          choice = null;
      }
      debugPrint(choice); //Debug the choice in console
    });
  }

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
    print("-------> back button pressed");
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
          appBar: new AddHolidayAppHeader(profileimage,showtabbar,orgName),
//          appBar: AppHeader(profileimage,showtabbar,orgName),
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
                  //SizedBox(height: 5.0),
                  Text('Add Holiday',
                      style: new TextStyle(fontSize: 22.0, color: appStartColor())),
                  new Divider(color: Colors.black54,height: 1.5,),
                  new Expanded(
                    child: ListView(
                      //padding: EdgeInsets.symmetric(horizontal: 15.0),
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 5.0),
                            TextFormField(
                              controller: _nameController,
                              focusNode: textFirstFocusNode,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                  labelText: 'Holiday',
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(bottom:0.0),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ), // icon is 48px widget.
                                  )
                              ),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              controller: _desController,
                              focusNode: textfourthFocusNode,
                              decoration: InputDecoration(
                                  labelText: 'Description',
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(bottom:0.0),
                                    child: Icon(
                                      Icons.event_note,
                                      color: Colors.grey,
                                    ), // icon is 48px widget.
                                  )
                              ),
                              maxLines: 1,
                            ),
                            Container(
                              child:DateTimeField(
                                format: dateFormat,
                                controller: _fromController,
                                focusNode: textSecondFocusNode,
                                readOnly: true,
                                onShowPicker: (context, currentValue) {
                                  print("current value1");
                                  print(currentValue);
                                  print(DateTime.now());
                                  return showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      initialDate: currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100)
                                  );
                                },

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
                                onChanged: (date) {
                                  setState(() {
                                    Date1 = date;
                                  });
                                  print("----->Changed date------> "+Date1.toString());
                                },
                              ),
                            ),
                            //SizedBox(height: 5.0,),
                            Container(
                              child:DateTimeField(
                                format: dateFormat,
                                controller: _toController,
                                focusNode: textthirdFocusNode,
                                readOnly: true,
                                onShowPicker: (context, currentValue) {
                                  print("current value");
                                  print(currentValue);
                                  return showDatePicker(
                                      context: context,
                                      initialDate: currentValue ?? DateTime.now(),
                                      firstDate: DateTime.now(),
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
                                  labelText: 'To Date',
                                ),
                                onChanged: (dt) {
                                  setState(() {
                                    Date2 = dt;
                                  });
                                  print("----->Changed date------> "+Date2.toString());
                                },
                              ),
                            ),
                            SizedBox(height: 5.0,),
                            //***************************
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 70.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Radio(
                                                value: '1',
                                                groupValue: _radioValue,
                                                onChanged: radioButtonChanges,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text("OR"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5.0,),
                                Padding(
                                  padding: const EdgeInsets.only(right:70.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Radio(
                                                value: '2',
                                                groupValue: _radioValue,
                                                onChanged: radioButtonChanges,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text("AND",),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(height: 0.5,),
                            getDivision_DD(),
                            SizedBox(height: 0.5,),
                            getLocation_DD(),
                            SizedBox(height: 5.0,),
                            ButtonBar(
                              children: <Widget>[
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: isServiceCalling?Text('Processing..',style: TextStyle(color: Colors.white),):Text('ADD',style: TextStyle(color: Colors.white),),
                                  color: Colors.orange[800],
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      if (_nameController.text.isEmpty) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 3), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              content: new Text("Please enter the holiday's name"),
                                            );
                                          });
                                        /*showDialog(context: context, child:
                                        new AlertDialog(
                                          content: new Text("Please enter holiday name"),
                                        )
                                        );*/
                                      }else if(_fromController.text.isEmpty){
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 3), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              content: new Text("Please enter the holiday's start date"),
                                            );
                                          });
                                        /*showDialog(context: context, child:
                                        new AlertDialog(
                                          content: new Text("Please enter holiday from date"),
                                        )
                                        );*/
                                      }else if(_toController.text.isEmpty){
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 3), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              content: new Text("Please enter the holiday's end date"),
                                            );
                                          });
                                        /*showDialog(context: context, child:
                                        new AlertDialog(
                                          content: new Text("Please enter holiday to date"),
                                        )
                                        );*/
                                      }else if(Date2.isBefore(Date1)){
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 3), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              content: new Text("End date can't be earlier than the start date"),
                                            );
                                          });
                                        /*showDialog(context: context, child:
                                        new AlertDialog(
                                          content: new Text("To date can't be smaller"),
                                        )
                                        );*/
                                      }else if(_radioValue=='2' && _myDivisions.isEmpty){
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 3), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              content: new Text("Please select atleast one Division"),
                                            );
                                          });
                                      }else if(_radioValue=='2' && _myLocations.isEmpty){
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 3), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              content: new Text("Please select atleast one Location"),
                                            );
                                          });
                                      }else if(_radioValue=='1' && ((_myLocations.isNotEmpty || _myDivisions.isEmpty) && (_myLocations.isEmpty || _myDivisions.isNotEmpty) && (_myLocations.isEmpty || _myDivisions.isEmpty) ) ){
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 3), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              content: new Text("Please select either Division or Location"),
                                            );
                                          });
                                      }else {
                                        var status = await addHoliday(
                                          _nameController.text.trim(),
                                          _fromController.text.trim(),
                                          _toController.text.trim(),
                                          _desController.text.trim(),
                                          _radioValue,
                                          _myDivisionIds,
                                          _myLocationIds,
                                        );
                                        if(status=='true'){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => Holiday()),
                                          );
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              Future.delayed(Duration(seconds: 3), () {
                                                Navigator.of(context).pop(true);
                                              });
                                              return AlertDialog(
                                                content: new Text("Holiday added successfully"),
                                              );
                                            });
                                          /*showDialog(context: context, child:
                                            new AlertDialog(
                                              content: new Text('Holiday added successfully.'),
                                            )
                                          );*/
                                        }else if(status =='alreadyexist'){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => Holiday()),
                                          );
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              Future.delayed(Duration(seconds: 3), () {
                                                Navigator.of(context).pop(true);
                                              });
                                              return AlertDialog(
                                                content: new Text("Holiday already exists"),
                                              );
                                            });
                                        }else{
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              Future.delayed(Duration(seconds: 3), () {
                                                Navigator.of(context).pop(true);
                                              });
                                              return AlertDialog(
                                                content: new Text("There is some problem while adding holiday"),
                                              );
                                            });
                                        }
                                      }
                                    }
                                  },
                                ),
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide( color: Colors.orange[800].withOpacity(0.5), width: 1,),
                                  ),
                                  child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Holiday()),
                                    );
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

  //////////////// Division dropdown /////////
  Widget getDivision_DD() {
    return new FutureBuilder<List<Map>>(
        future: getDivForDropDown(), //with -select- label
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new  MultiSelectFormField(
              autovalidate: false,
              chipBackGroundColor: Colors.blue[300],
              chipLabelStyle: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),
              dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
              checkBoxActiveColor: Colors.blue,
              checkBoxCheckColor: Colors.white,
              dialogShapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              title: Text(
                "Select Division",
                style: TextStyle(fontSize: 14,color: Colors.black54),
              ),
              dataSource: snapshot.data.map((data){
                return {'display': data["Name"], 'value': data['Id']};
              }).toList(),
              textField: 'display',
              valueField: 'value',
              okButtonLabel: 'OK',
              cancelButtonLabel: 'CANCEL',
              hintWidget: Text('Please choose one or more division'),
              initialValue: _myDivisions,
              onSaved: (value) {
                if (value == null) return;
                setState(() {
                  _myDivisions = value;
                  _myDivisionIds = _myDivisions.join(',');
                });
              },
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          return new Center(child: SizedBox(
            child: CircularProgressIndicator(strokeWidth: 2.2,),
            height: 20.0,
            width: 20.0,
          ),);
        });
  }

  //////////////// Location dropdown /////////
  Widget getLocation_DD() {
    return new FutureBuilder<List<Map>>(
        future: getLocForDropDown(), //with -select- label
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Map<String, dynamic>> datasource;
            return new  MultiSelectFormField(
              autovalidate: false,
              chipBackGroundColor: Colors.blue[300],
              chipLabelStyle: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),
              dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
              checkBoxActiveColor: Colors.blue,
              checkBoxCheckColor: Colors.white,
              dialogShapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              title: Text(
                "Select Location",
                style: TextStyle(fontSize: 14,color: Colors.black54),
              ),
              dataSource: snapshot.data.map((data){
                return {'display': data["Name"], 'value': data['Id']};
              }).toList(),
              textField: 'display',
              valueField: 'value',
              okButtonLabel: 'OK',
              cancelButtonLabel: 'CANCEL',
              hintWidget: Text('Please choose one or more location'),
              initialValue: _myLocations,
              onSaved: (value) {
                if (value == null) return;
                setState(() {
                  _myLocations = value;
                  _myLocationIds = _myLocations.join(',');
                });
              },
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          return new Center(child: SizedBox(
            child: CircularProgressIndicator(strokeWidth: 2.2,),
            height: 20.0,
            width: 20.0,
          ),);
        });
  }


}
class AddHolidayAppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;
  AddHolidayAppHeader(profileimage1,showtabbar1,orgname1){
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
                  MaterialPageRoute(builder: (context) => Holiday()), (Route<dynamic> route) => false,
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