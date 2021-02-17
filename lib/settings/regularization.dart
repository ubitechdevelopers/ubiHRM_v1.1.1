import 'dart:async';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:month_picker_strip/month_picker_strip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/appbar.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/drawer.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/services/regularization_sevices.dart';
import 'package:ubihrm/settings/settings.dart';


class RegularizationPage extends StatefulWidget {
  @override
  _RegularizationPageState createState() => _RegularizationPageState();
}

class _RegularizationPageState extends State<RegularizationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _regularizationFormKey = GlobalKey<FormState>();
  bool _isServiceCalling = false;
  bool _isButtonDisabled = false;
  bool showtabbar;

  var profileimage;
  String orgName = "";
  int hrsts=0;
  int adminsts=0;
  int divhrsts=0;

  DateTime selectedMonth;
  DateTime to;
  DateTime from;

  TextEditingController _timeinController = TextEditingController();
  TextEditingController _timeoutController = TextEditingController();
  TextEditingController _remarkController = TextEditingController();
  FocusNode textfirstFocusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    from = new DateTime.now();
    selectedMonth = new DateTime(from.year, from.month, 1);
    profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);
    getOrgName();
  }

  getOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName = prefs.getString('orgname') ?? '';
      hrsts =prefs.getInt('hrsts')??0;
      adminsts =prefs.getInt('adminsts')??0;
      divhrsts =prefs.getInt('divhrsts')??0;
    });
  }

  Widget build(BuildContext context) {
    return mainRegularizationWidget();
  }

  Future<bool> move() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AllSetting()), (
        Route<dynamic> route) => false,
    );
    return false;
  }

  mainRegularizationWidget() {
    return RefreshIndicator(
      child: WillPopScope(
        onWillPop: () => move(),
        child: new Scaffold(
          backgroundColor: scaffoldBackColor(),
          key: _scaffoldKey,
          appBar: AppHeader(profileimage,showtabbar,orgName),
          bottomNavigationBar: new HomeNavigation(),
          endDrawer: new AppDrawer(),
          body:ModalProgressHUD(
              inAsyncCall: _isServiceCalling,
              opacity: 0.15,
              progressIndicator: SizedBox(
                child:new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation(Colors.green),
                    strokeWidth: 5.0),
                height: 40.0,
                width: 40.0,
              ),
              child: getRegularizationWidget(),
          ),
        ),
      ),
      onRefresh: () async {
        Completer<Null> completer = new Completer<Null>();
        await Future.delayed(Duration(seconds: 1)).then((onvalue) {
          completer.complete();
        });
        return completer.future;
      },
    );
  }

  Widget getRegularizationWidget(){
    return Stack(
      children:[
        Container(
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          decoration: new ShapeDecoration(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              Center(
                  child: Text(
                    'Regularization',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: appStartColor(),
                    ),
                  )),
              SizedBox(height: 5.0,),
              Padding(
                padding: const EdgeInsets.only(top:10.0, bottom:5.0),
                child: new MonthStrip(
                  format: 'MMM yyyy',
                  from: fiscalStart==null?orgCreatedDate:fiscalStart,
                  to: selectedMonth,
                  initialMonth: selectedMonth,
                  height:  25.0,
                  viewportFraction: 0.25,
                  onMonthChanged: (v) {
                    setState(() {
                      selectedMonth = v;
                      print("selectedMonth");
                      print(selectedMonth);
                    });
                  },
                ),
              ),
              Divider(),
              Container(
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:15.0),
                      child: Container(
                        child: Text(
                          'Date',
                          style: TextStyle(
                            color: appStartColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                        ),
                      ),
                    ),

                    Container(
                      child: Text(
                        'Device',
                        style: TextStyle(
                          color: appStartColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right:15.0),
                      child: Container(
                        child: Text(
                          'Action',
                          style: TextStyle(
                            color: appStartColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              new Expanded(
                child: regularizationWidget(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget regularizationWidget() {
    return FutureBuilder<List<Regularization>>(
        future: getRegularization(formatter.format(selectedMonth)),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(snapshot.data[index].date.toString(),
                              style: TextStyle(fontSize: 14)),
                        ),

                        Container(
                          child: Text(snapshot.data[index].device.toString(),
                              style: TextStyle(fontSize: 14)),
                        ),

                        IconButton(
                          icon:Icon(FontAwesomeIcons.solidPaperPlane,color: appStartColor(), size: 20.0,),
                          onPressed: (){
                            _remarkController = new TextEditingController();
                            showAlertDialog(context,
                                snapshot.data[index].id.toString(),
                                snapshot.data[index].date.toString(),
                                snapshot.data[index].timein.toString(),
                                snapshot.data[index].timeout.toString()
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }else{
              return new Center(
                child: Container(
                  width: MediaQuery.of(context).size.width*1,
                  color: appStartColor().withOpacity(0.1),
                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                  child:Text("No missed time punches found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                ),
              );
            }
          } else if (snapshot.hasError) {
            return new Text("Unable to connect server");
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  showAlertDialog(BuildContext context, String id, String date, String timein, String timeout) async {
    _timeinController.text=timein;
    _timeoutController.text=timeout;
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Form(
              key: _regularizationFormKey,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child:Text(date,style: new TextStyle(fontSize: 22.0,color:appStartColor())),
                      ),
                      SizedBox(height: 10,),
                      Column(
                        children: [
                          new Container(
                            child:DateTimeField(
                              format: timeFormat,
                              controller: _timeinController,
                              readOnly: true,
                              onShowPicker: (context, currentValue) async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                );
                                return DateTimeField.convert(time);
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Icon(
                                      Icons.alarm,
                                      color: Colors.grey,
                                    ), // icon is 48px widget.
                                  ), // icon is 48px widget.
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                                  ),
                                  labelText: 'Time In',
                                  hintText: 'Time In'
                              ),
                              validator: (time) {
                                if (_timeinController.text=='00:00' || _timeinController.text.isEmpty) {
                                  return 'Please enter start time';
                                }
                                return null;
                              },
                            ),

                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Column(
                        children: [
                          new Container(
                            child:DateTimeField(
                              format: timeFormat,
                              controller: _timeoutController,
                              readOnly: true,
                              onShowPicker: (context, currentValue) async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                );
                                return DateTimeField.convert(time);
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Icon(
                                      Icons.alarm,
                                      color: Colors.grey,
                                    ), // icon is 48px widget.
                                  ), // icon is 48px widget.
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                                  ),
                                  labelText: 'Time Out',
                                  hintText: 'Time Out'
                              ),
                              validator: (time) {
                                if (_timeoutController.text=='00:00' || _timeoutController.text.isEmpty) {
                                  return 'Please enter start time';
                                }
                                var arr=_timeinController.text.split(':');
                                var arr1=_timeoutController.text.split(':');
                                final startTime = DateTime(2018, 6, 23,int.parse(arr[0]),int.parse(arr[1]),00,00);
                                final endTime = DateTime(2018, 6, 23,int.parse(arr1[0]),int.parse(arr1[1]),00,00);
                                if(endTime.isBefore(startTime)){
                                  return '\"To Time\" can\'t be smaller.';
                                }else if(startTime.isAtSameMomentAs(endTime)){
                                  return '\"To Time\" can\'t be equal.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Column(
                        children: [
                          new Container(
                            child:TextFormField(
                              controller: _remarkController,
                              focusNode: textfirstFocusNode,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                                  ),
                                  labelText: 'reason',
                                  hintText: 'reason',
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(bottom:0.0),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ), // icon is 48px widget.
                                  )
                              ),
                              validator: (String value) {
                                if (_remarkController.text.isEmpty){
                                  return "Please enter the reason";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            FlatButton(
                color: Colors.orange[800],
                child: _isServiceCalling?Text('Submit',style: TextStyle(color: Colors.white),):Text('Submit',style: TextStyle(color: Colors.white),),
                onPressed: () {
                  if (_regularizationFormKey.currentState.validate()) {
                    setState(() {
                      _isServiceCalling = true;
                      _isButtonDisabled = true;
                    });
                    OnSendRegularizeRequest(id, _timeinController.text, _timeoutController.text, _remarkController.text).then((res) {
                      if (res == 'true') {
                        Navigator.of(context, rootNavigator: true).pop(
                            'dialog');
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 3), () {
                                Navigator.of(context).pop(true);
                              });
                              return AlertDialog(
                                content: new Text(
                                    "Regularization request submitted successfully"),
                              );
                            });
                      } else if (res == 'false') {
                        Navigator.of(context, rootNavigator: true).pop(
                            'dialog');
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 3), () {
                                Navigator.of(context).pop(true);
                              });
                              return AlertDialog(
                                content: new Text(
                                    "Unable to submit regularization request"),
                              );
                            });
                      } else {
                        Navigator.of(context, rootNavigator: true).pop(
                            'dialog');
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 3), () {
                                Navigator.of(context).pop(true);
                              });
                              return AlertDialog(
                                content: new Text("Unable to connect server"),
                              );
                            });
                      }
                    });
                    setState(() {
                      _isServiceCalling = false;
                      _isButtonDisabled = false;
                    });
                  }
                }
            ),
            FlatButton(
              shape: Border.all(color: Colors.orange[800]),
              child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
          ],
        );
      },
    );
  }

}