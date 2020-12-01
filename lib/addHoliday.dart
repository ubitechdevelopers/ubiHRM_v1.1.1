import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/holiday.dart';
import 'package:ubihrm/services/attandance_services.dart';
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
          appBar: new AppHeader(profileimage,showtabbar,orgName),
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
                            SizedBox(height: 5.0,),
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
                            TextFormField(
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
                            SizedBox(height: 0.5,),
                            getDivision_DD(),
                            SizedBox(height: 0.5,),
                            getLocation_DD(),
                            SizedBox(height: 5.0,),
                            ButtonBar(
                              children: <Widget>[
                                RaisedButton(
                                  child: isServiceCalling?Text('Processing..',style: TextStyle(color: Colors.white),):Text('ADD',style: TextStyle(color: Colors.white),),
                                  color: Colors.orange[800],
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      if (_nameController.text.isEmpty) {
                                        showDialog(context: context, child:
                                        new AlertDialog(
                                          content: new Text("Please enter holiday name"),
                                        )
                                        );
                                      }else if(_fromController.text.isEmpty){
                                        showDialog(context: context, child:
                                        new AlertDialog(
                                          content: new Text("Please enter holiday from date"),
                                        )
                                        );
                                      }else if(_toController.text.isEmpty){
                                        showDialog(context: context, child:
                                        new AlertDialog(
                                          content: new Text("Please enter holiday to date"),
                                        )
                                        );
                                      }else if(Date2.isBefore(Date1)){
                                        showDialog(context: context, child:
                                        new AlertDialog(
                                          content: new Text("To date can't be smaller"),
                                        )
                                        );
                                      }else if(_desController.text.isEmpty){
                                        showDialog(context: context, child:
                                        new AlertDialog(
                                          content: new Text("Please enter description"),
                                        )
                                        );
                                      }else if(_myLocationIds.isEmpty){
                                        showDialog(context: context, child:
                                        new AlertDialog(
                                          content: new Text("Please select atleast one division"),
                                        )
                                        );
                                      }else if(_myLocations.isEmpty){
                                        showDialog(context: context, child:
                                        new AlertDialog(
                                          content: new Text("Please select atleast one location"),
                                        )
                                        );
                                      }else {
                                        var status = await addHoliday(
                                            _nameController.text.trim(),
                                            _fromController.text.trim(),
                                            _toController.text.trim(),
                                            _desController.text.trim(),
                                            _myDivisionIds,
                                            _myLocationIds,
                                        );
                                        if(status=='true'){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => Holiday()),
                                          );
                                          showDialog(context: context, child:
                                            new AlertDialog(
                                              content: new Text('Holiday added successfully.'),
                                            )
                                          );
                                        }else if(status =='alreadyexist'){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => Holiday()),
                                          );
                                          showDialog(context: context, child:
                                          new AlertDialog(
                                            content: new Text('Already Exist'),
                                          )
                                          );
                                        } else{
                                          showDialog(context: context, child:
                                          new AlertDialog(
                                            content: new Text('There is some problem while adding holiday'),
                                          )
                                          );
                                        }
                                      }
                                    }
                                  },
                                ),
                                FlatButton(
                                  shape: Border.all(color: Colors.orange[800]),
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