import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
//import 'package:pdf/widgets.dart' as prefix0;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/appbar.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/services/attandance_services.dart';
import '../drawer.dart';
import 'settings.dart';

class ShiftList extends StatefulWidget {
  @override
  _ShiftList createState() => _ShiftList();
}

class _ShiftList extends State<ShiftList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _shiftFormKey = GlobalKey<FormState>();
  String _sts1 = 'Active';
  String orgName='';
  String uid='';
  String orgid='';
  bool _isButtonDisabled = false;
  bool _isServiceCalling = false;
  int hrsts=0;
  int adminsts=0;
  int divhrsts=0;
  TextEditingController _shiftName = new TextEditingController();
  TextEditingController _shiftStartTimeController = new TextEditingController();
  TextEditingController _shiftEndTimeController = new TextEditingController();
  TextEditingController _breakStartTimeController = new TextEditingController();
  TextEditingController _breakEndTimeController = new TextEditingController();
  TextEditingController _searchController;
  FocusNode searchFocusNode;
  String shiftname = "";
  String shifttype = '0';
  List<Map> _shifttype = [{"id":"0", "name":"-Select-"}, {"id":"1", "name":"Single Date"}, {"id":"2", "name":"Multi Date"}];
  var profileimage;
  bool showtabbar;
  String shift='0';

  TextStyle _hintStyle = TextStyle(
      color: Colors.black45
  );


  @override
  void initState() {
    super.initState();
    _searchController = new TextEditingController();
    searchFocusNode = FocusNode();
    profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);
    getOrgName();
  }

  formatTime(String time){
    if(time.contains(":")){
      var a=time.split(":");
      return a[0]+":"+a[1];
    }
    else return time;
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
      hrsts =prefs.getInt('hrsts')??0;
      adminsts =prefs.getInt('adminsts')??0;
      divhrsts =prefs.getInt('divhrsts')??0;
      uid = prefs.getString("employeeid")??"";
      orgid = prefs.getString("organization")??"";
    });
  }
  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  Future<bool> sendToHome() async{
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AllSetting()), (Route<dynamic> route) => false,
    );
    return false;
  }

  getmainhomewidget() {
    return new WillPopScope(
      onWillPop: ()=> sendToHome(),
      child: RefreshIndicator(
        child: Scaffold(
          backgroundColor: scaffoldBackColor(),
          key: _scaffoldKey,
          appBar: AppHeader(profileimage,showtabbar,orgName),
          bottomNavigationBar:new HomeNavigation(),

          endDrawer: new AppDrawer(),
          body: Container(
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            decoration: new ShapeDecoration(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              color: Colors.white,
            ),
            //   padding: EdgeInsets.only(left: 2.0, right: 2.0),
            child: Column(
              children: <Widget>[
                Center(
                  child: Text('Shifts',
                    style: new TextStyle(fontSize: 22.0, color: appStartColor(),),),
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
                        hintText: 'Search Shift',
                        //labelText: 'Search Shift',
                        suffixIcon: _searchController.text.isNotEmpty?IconButton(icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ShiftList()),
                              );
                            }
                        ):null,
                        //focusColor: Colors.white,
                      ),
                      onChanged: (value) {
                        setState(() {
                          shiftname = value;
                        });
                      },
                    ),
                  ),
                ),
                //Divider(height: 1.5,),
                //Divider(),
                //SizedBox(height: 5.0),
                Container(
                  padding: EdgeInsets.only(bottom:10.0,top: 0.0, left:15.0, right: 10.0),
                  width: MediaQuery.of(context).size.width*.9,
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width*0.35,
                        child: Text('Shifts', style: TextStyle(color: appStartColor(),fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.15,
                        child: Text('Time In', style: TextStyle(color: appStartColor(),fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.15,
                        child: Text('Time Out', style: TextStyle( color: appStartColor(),fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.15,
                        child: Text('Status', style: TextStyle(color: appStartColor(),fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                ),
                Divider(height: 0.2,),
                new Expanded(
                  child: getShiftWidget(),
                ),
              ],
            ),
          ),
          floatingActionButton: (adminsts==1||hrsts==1||divhrsts==1)?new FloatingActionButton(
            backgroundColor: Colors.orange[800],
            onPressed: (){
              _shiftName = new TextEditingController();
              _shiftStartTimeController = new TextEditingController();
              _shiftEndTimeController = new TextEditingController();
              _showDialogShift(context);
              /*showDialog(
                  context: context,
                  builder: (context) {
                    Future.delayed(Duration(seconds: 3), () {
                      Navigator.of(context).pop(true);
                    });
                    return AlertDialog(
                      content: new Text("To Add a new Shift, login to the web panel"),
                    );
                  });*/
            },
            tooltip: 'Add Shift',
            child: new Icon(Icons.add),
          ):Center(),
        ),
        onRefresh: () async {
          Completer<Null> completer = new Completer<Null>();
          await Future.delayed(Duration(seconds: 1)).then((onvalue) {
            setState(() {
              _searchController.clear();
              shiftname='';
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            });
            completer.complete();
          });
          return completer.future;
        },
      ),
    );
  }

  getShiftWidget() {
    return new FutureBuilder<List<Shift>>(
      future: getShifts(shiftname),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return new ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Column(
                      children: <Widget>[
                        new FlatButton(
                          child: new Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.35,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      new Text(snapshot.data[index].Name
                                          .toString(),style: TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.bold)),
                                      new Text('(' + snapshot.data[index].Type
                                          .toString() + ')', style: TextStyle(
                                          color: Colors.grey)),
                                    ],
                                  )
                              ),
                              new Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.15,
                                child: new Text(formatTime(
                                    snapshot.data[index].TimeIn.toString()),
                                  textAlign: TextAlign.center,),
                              ),
                              new Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.15,
                                child: new Text(formatTime(
                                    snapshot.data[index].TimeOut.toString()),
                                  textAlign: TextAlign.center,),
                              ),
                              new Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.15,
                                child: new Text(
                                  snapshot.data[index].Status.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: snapshot.data[index].Status
                                          .toString() != 'Active' ? Colors
                                          .red : Colors.green),
                                  textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                          onPressed: () {
                            //return null;
                            editShift(context, snapshot.data[index].Name
                                .toString(), snapshot.data[index].Status
                                .toString(), snapshot.data[index].Id
                                .toString());
                          },),
                      ]
                  );
                }
            );
          }else{
            return new Center(
              child: Container(
                width: MediaQuery.of(context).size.width*1,
                color: appStartColor().withOpacity(0.1),
                padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                child:Text("No shift found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
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

  editShift(BuildContext context,String dept,String sts,String did) async {
    var new_shift = new TextEditingController();
    new_shift.text=dept;
    _sts1=sts;
    return showDialog(
      context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.all(15.0),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.20,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Text("Update Shift", style: new TextStyle(
                          fontSize: 22.0, color: appStartColor())),
                    ),
                    SizedBox(height: 15.0),
                    new Expanded(
                      child: new TextFormField(
                        enabled: false,
                        controller: new_shift,
                        autofocus: false,
                        decoration: new InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey
                                  .withOpacity(0.0), width: 1,),
                            ),
                            labelText: 'Shift', hintText: 'Shift Name'),
                        validator: (value) {
                          if (new_shift.text
                              .trim()
                              .isEmpty || new_shift.text.isEmpty) {
                            return 'Please enter shift name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    new Expanded(
                      child: new InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.withOpacity(
                                0.0), width: 1,),
                          ),
                          labelText: 'Status',
                        ),
                        isEmpty: _sts1 == '',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            value: _sts1,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                _sts1 = newValue;
                                Navigator.of(context, rootNavigator: true).pop(
                                    'dialog'); // here I pop to avoid multiple Dialogs
                                editShift(context, dept, _sts1, did);
                                _isButtonDisabled = true;
                              });
                            },
                            items: <String>['Active', 'Inactive'].map((
                                String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              new RaisedButton(
                  color: Colors.orange[800],
                  child: _isServiceCalling?Text("Updating..",
                    style: TextStyle(color: Colors.white),
                  ):Text("UPDATE",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (_isButtonDisabled == false)
                      return showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(Duration(seconds: 3), () {
                            Navigator.of(context).pop(true);
                          });
                          return AlertDialog(
                            content: new Text("No changes found"),
                          );
                        });
                    setState(() {
                      _isServiceCalling = true;
                      _isButtonDisabled = true;
                    });
                    updateShift(new_shift.text, _sts1, did).
                    then((res) {
                      if (res == '1') {
                        Navigator.of(context, rootNavigator: true).pop('dialog');
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 3), () {
                                Navigator.of(context).pop(true);
                              });
                              return AlertDialog(
                                content: new Text("Shift is updated successfully"),
                              );
                            });
                        getShiftWidget();
                        new_shift.text = '';
                        _sts1 = 'Active';
                      } else if (res == '2') {
                        Navigator.of(context, rootNavigator: true).pop('dialog');
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 3), () {
                                Navigator.of(context).pop(true);
                              });
                              return AlertDialog(
                                content: new Text(
                                    "This shift can't be updated. Employees are already assigned to it."),
                              );
                            });
                      } else if (res == '3') {
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 3), () {
                                Navigator.of(context).pop(true);
                              });
                              return AlertDialog(
                                content: new Text("This Shift can't be updated. Only Shift found"),
                              );
                            });
                      } else {
                        Navigator.of(context, rootNavigator: true).pop('dialog');
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 3), () {
                                Navigator.of(context).pop(true);
                              });
                              return AlertDialog(
                                content: new Text("Unable to update shift"),
                              );
                            });
                      }
                      setState(() {
                        _isServiceCalling=false;
                        _isButtonDisabled=false;
                      });
                    }
                    );
                  }),
              new FlatButton(
                shape: Border.all(color: Colors.orange[800]),
                child: Text(
                  'CANCEL', style: TextStyle(color: Colors.black87),),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                }),
            ],
          );
        }
    );
  }

  _showDialogShift(BuildContext context) async {
    await showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.all(15.0),
            content: Form(
              key: _shiftFormKey,
              child: Container(
                //height: MediaQuery.of(context).size.height*0.35,
                //width: MediaQuery.of(context).size.width*0.40,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Text("Add Shift", style: new TextStyle(
                          fontSize: 22.0, color: appStartColor())),
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Shift starts and ends within",
                          style: TextStyle(fontWeight: FontWeight.w600),),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    new DropdownButtonHideUnderline(
                      child:  new DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                          ),
                        ),
                        isExpanded: true,
                        isDense: true,
                        //hint: new Text("Select Shift Type", style: TextStyle(fontSize: 14.0)),
                        value: shifttype,
                        onChanged: (String newValue) {
                          setState(() {
                            shifttype = newValue;
                          });
                          print("shifttype");
                          print(shifttype);
                        },
                        items: _shifttype.map((Map map) {
                          return new DropdownMenuItem<String>(
                            value: map["id"].toString(),
                            child: new Text(
                              map["name"],
                            ),
                          );
                        }).toList(),
                        validator: (String value) {
                          if (shifttype=='0') {
                            return 'Please select shift type';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    new TextFormField(
                      autofocus: false,
                      controller: _shiftName,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: new InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(),
                          ),
                          hintText: 'Shift Name',
                          hintStyle: _hintStyle
                      ),
                      validator: (value) {
                        if (value.trim().isEmpty || value.isEmpty || value=="") {
                          return 'Please enter shift name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Shift Hours",
                          style: TextStyle(fontWeight: FontWeight.w600),),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    new Row(
                      children: <Widget>[
                        Expanded(
                          child: DateTimeField(
                            format: timeFormat,
                            controller: _shiftStartTimeController,
                            readOnly: true,
                            onShowPicker: (context, currentValue) async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    currentValue ?? DateTime.now()),
                              );
                              return DateTimeField.convert(time);
                            },
                            decoration: new InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(),
                                ),
                                //labelText: 'From',
                                hintText: 'Start Time',
                                hintStyle: _hintStyle
                            ),
                            validator: (time) {
                              if (time == null || _shiftStartTimeController.text.isEmpty || _shiftStartTimeController.text=='00:00') {
                                return "Please enter \nshift's start time";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Expanded(
                          child: DateTimeField(
                            //initialTime: new TimeOfDay.now(),
                            format: timeFormat,
                            controller: _shiftEndTimeController,
                            readOnly: true,
                            onShowPicker: (context, currentValue) async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    currentValue ?? DateTime.now()),
                              );
                              return DateTimeField.convert(time);
                            },
                            decoration: new InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(),
                                ),
                                //labelText: 'To',
                                hintText: 'End Time',
                                hintStyle: _hintStyle
                            ),
                            validator: (time) {
                              if (time == null  || _shiftEndTimeController.text.isEmpty || _shiftEndTimeController.text=='00:00') {
                                return "Please enter \nshift's end time";
                              }
                              var arr=_shiftStartTimeController.text.split(':');
                              var arr1=_shiftEndTimeController.text.split(':');
                              final startTime = DateTime(2018, 6, 23,int.parse(arr[0]),int.parse(arr[1]),00,00);
                              final endTime = DateTime(2018, 6, 23,int.parse(arr1[0]),int.parse(arr1[1]),00,00);
                              if(endTime.isBefore(startTime) && shifttype=='1'){
                                return "Shift End time can't \nbe earlier than shift start time";
                              }else if(startTime.isAtSameMomentAs(endTime)){
                                return "Shift start and end \ntime can't be same";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    /*SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Break Hours",style: TextStyle(fontWeight: FontWeight.w600),),
                  ],
                ),
                SizedBox(height: 5.0),
                new Row(
                  children: <Widget>[
                    Expanded(
                      child:DateTimeField(
                        format: timeFormat,
                        controller: _breakStartTimeController,
                        readOnly: true,
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.convert(time);
                        },
                        decoration: new InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(),
                            ),
                            labelText: 'From',
                            hintText: 'From',
                            hintStyle: _hintStyle
                        ),
                        validator: (time) {
                          if (time==null) {
                            return 'Please enter start time';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child:DateTimeField(
                        //initialTime: new TimeOfDay.now(),
                        format: timeFormat,
                        controller: _breakEndTimeController,
                        readOnly: true,
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.convert(time);
                        },
                        decoration: new InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(),
                            ),
                            labelText: 'To',
                            hintText: 'To',
                            hintStyle: _hintStyle
                        ),
                        validator: (time) {
                          if (time==null) {
                            return 'Please enter end time';
                          }
                          return null;
                          */ /*var arr=_starttimeController.text.split(':');
                          var arr1=_endtimeController.text.split(':');
                          final startTime = DateTime(2018, 6, 23,int.parse(arr[0]),int.parse(arr[1]),00,00);
                          final endTime = DateTime(2018, 6, 23,int.parse(arr1[0]),int.parse(arr1[1]),00,00);
                          if(endTime.isBefore(startTime)){
                            return '\"To Time\" can\'t be smaller.';
                          }else if(startTime.isAtSameMomentAs(endTime)){
                            return '\"To Time\" can\'t be equal.';
                          }*/ /*
                        },
                      ),
                    ),
                  ],
                ),*/
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: _isServiceCalling? Text(
                  'Adding..',
                  style: TextStyle(color: Colors.white),
                ): Text(
                  'ADD',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.orange[800],
                onPressed: () {
                  /*FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }*/
                  if (_shiftFormKey.currentState.validate()) {
                    setState(() {
                      _isServiceCalling = true;
                      _isButtonDisabled = true;
                    });
                    var url = path + "addShift";
                    http.post(url, body: {
                      "uid": uid,
                      "orgid": orgid,
                      "shifttype": shifttype,
                      "name": _shiftName.text.trim(),
                      "shiftstart": _shiftStartTimeController.text.trim(),
                      "shiftend": _shiftEndTimeController.text.trim(),
                    }).then((response) {
                      print(path + 'addShift?uid=$uid&orgid=$orgid&shifttype=$shifttype&name=${_shiftName.text.trim()}&shiftstart=${_shiftStartTimeController.text.trim()}&shiftend=${_shiftEndTimeController.text.trim()}');
                      print(response.body.toString());
                      if (response.statusCode == 200) {
                        Map data = json.decode(response.body);
                        print(response.body.toString());
                        print(data["sts"]);
                        print(data["shiftid"]);
                        if (data["sts"].contains("true")) {
                          shiftid = data["shiftid"];
                          shift = shiftid;
                          Navigator.of(context, rootNavigator: true).pop();
                          showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(Duration(seconds: 3), () {
                                  Navigator.of(context).pop(true);
                                });
                                return AlertDialog(
                                  content: new Text("Shift added successfully"),
                                );
                              });
                        } else if (data["sts"].contains("alreadyexists")) {
                          shiftid = data["shiftid"];
                          shift = shiftid;
                          showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(Duration(seconds: 3), () {
                                  Navigator.of(context).pop(true);
                                });
                                return AlertDialog(
                                  content: new Text("Shift with this name already exists"),
                                );
                              });
                        } else if (data["sts"].contains("false1")) {
                          setState(() {
                            _isServiceCalling = false;
                          });
                          showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(Duration(seconds: 3), () {
                                  Navigator.of(context).pop(true);
                                });
                                return AlertDialog(
                                  content: new Text("Shift hours should be less than 20:00 hours"),
                                );
                              });
                        } else {
                          setState(() {
                            _isServiceCalling = false;
                          });
                          showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(Duration(seconds: 3), () {
                                  Navigator.of(context).pop(true);
                                });
                                return AlertDialog(
                                  content: new Text(
                                      "There is some problem while adding shift"),
                                );
                              });
                        }
                        setState(() {
                          _isServiceCalling = false;
                          _isButtonDisabled = false;
                        });
                      }
                    });
                  }
                },
              ),
              //SizedBox(width: 10.0),
              FlatButton(
                shape: Border.all(color: Colors.orange[800]),
                child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
                onPressed: () {
                  shifttype='0';
                  _shiftName.clear();
                  _shiftStartTimeController.clear();
                  _shiftEndTimeController.clear();
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          );
        }
    );
  }
}/////////mail class close
