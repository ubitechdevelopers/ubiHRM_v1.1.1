import 'package:flutter/material.dart';
//import 'package:pdf/widgets.dart' as prefix0;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'drawer.dart';
import 'settings.dart';

class ShiftList extends StatefulWidget {
  @override
  _ShiftList createState() => _ShiftList();
}

class _ShiftList extends State<ShiftList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _sts1 = 'Active';
  String orgName='';
  bool _isButtonDisabled = false;
  int adminsts=0;
  TextEditingController _searchController;
  FocusNode searchFocusNode;
  String shiftname = "";

  @override
  void initState() {
    super.initState();
    _searchController = new TextEditingController();
    searchFocusNode = FocusNode();
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
      adminsts= prefs.getInt('adminsts') ?? 0;
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
      child: Scaffold(
        backgroundColor: scaffoldBackColor(),
        key: _scaffoldKey,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(orgName, style: new TextStyle(fontSize: 20.0)),
            ],
          ),
          leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
            Navigator.pop(context);}),
          backgroundColor: appStartColor(),
        ),
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
                      labelText: 'Search Shift',
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
                      child: Text('Time in', style: TextStyle(color: appStartColor(),fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.15,
                      child: Text('Time out', style: TextStyle( color: appStartColor(),fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center),
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
                            editDept(context, snapshot.data[index].Name
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

  //////////edit department
  editDept(context,dept,sts,did) async {
    _sts1=sts;
    var new_dept = new TextEditingController();
    new_dept.text=dept;
    await showDialog<String>(
      context: context,
      // ignore: deprecated_member_use
      child: new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.all(16.0),
        content: Container(
          height: MediaQuery.of(context).size.height*0.20,
          child: Column(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: new_dept,
                  //    focusNode: f_dept,
                  autofocus: false,
                  //   controller: client_name,
                  decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                      ),
                      labelText: 'Shift', hintText: 'Shift Name'),
                ),
              ),
              new Expanded(
                child:  new InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
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
                          Navigator.of(context, rootNavigator: true).pop('dialog'); // here I pop to avoid multiple Dialogs
                          //print("this is set state"+_sts1);
                          editDept(context, dept, _sts1, did);
                        });
                      },
                      items: <String>['Active', 'Inactive'].map((String value) {
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
        actions: <Widget>[
          new FlatButton(
              shape: Border.all(color: Colors.black54),
              child: const Text('CANCEL',style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              }),
          new RaisedButton(
              color: Colors.orangeAccent,
              child: const Text('UPDATE',style: TextStyle(color: Colors.white),),
              onPressed: ()
              {
                if( new_dept.text==''){
                  //  FocusScope.of(context).requestFocus(f_dept);
                  //showInSnackBar('Input Shift Name');
                  showDialog(context: context, child:
                  new AlertDialog(
                    content: new Text("Enter shift name"),
                  ));
                }
                else {
                  if(_isButtonDisabled)
                    return null;
                  setState(() {
                    _isButtonDisabled=true;
                  });
                  updateShift(new_dept.text,_sts1,did).
                  then((res) {
                    if(res=='0') {
                      //showInSnackBar('Unable to update shift');
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
                      /*showDialog(context: context, child:
                      new AlertDialog(
                        content: new Text("Unable to update shift"),
                      ));*/
                    }else if(res=='-1') {
                      //showInSnackBar('Shift name already exist');
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("Shift name already exist"),
                            );
                          });
                      /*showDialog(context: context, child:
                      new AlertDialog(
                        content: new Text("Shift name already exist"),
                      ));*/
                    }else if(res=='-2') {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      //showInSnackBar('Shift name already exist');
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("Employees assigned to this shift therefore can't be updated"),
                            );
                          });
                      /*showDialog(context: context, child:
                      new AlertDialog(
                        content: new Text("Employees assigned to this shift therefore can't be updated"),
                      ));*/
                    }else {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      //showInSnackBar('Shift updated successfully');
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("Shift updated successfully"),
                            );
                          });
                      /*showDialog(context: context, child:
                      new AlertDialog(
                      content: new Text("Shift updated successfully"),
                      ));*/
                      getShiftWidget();
                      new_dept.text = '';
                      _sts1 = 'Active';
                    }
                    setState(() {
                      _isButtonDisabled=false;
                    });
                  }
                  );
                }

              }),
        ],
      ),
    );
  }
//////////edit department-end

}/////////mail class close
