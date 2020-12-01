import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/settings.dart';
import 'drawer.dart';

class Division extends StatefulWidget {
  @override
  _DivisionState createState() => _DivisionState();
}

class _DivisionState extends State<Division> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static const statuses =  ['Active', 'Inactive'];
  String orgName = "";
  int adminsts = 0;

  @override
  void initState() {
    super.initState();
    getOrgName();
  }

  getOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName = prefs.getString('orgname') ?? '';
      adminsts = prefs.getInt('adminsts') ?? 0;
    });
  }

  Widget build(BuildContext context) {
    return MainDevisionWidget();
  }
  Future<bool> move() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AllSetting()), (
        Route<dynamic> route) => false,
    );
    return false;
  }
  MainDevisionWidget() {
    return WillPopScope(
      onWillPop: () => move(),
      child: new Scaffold(
        backgroundColor: scaffoldBackColor(),
        key: _scaffoldKey,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(orgName, style: new TextStyle(fontSize: 20.0)),
            ],
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllSetting()),
                );
              }),
          backgroundColor: appStartColor(),
        ),
        bottomNavigationBar: new HomeNavigation(),
        endDrawer: new AppDrawer(),
        body: Container(
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          decoration: new ShapeDecoration(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Center(
                  child: Text(
                'Division',
                style: TextStyle(
                  fontSize: 22.0,
                  color: appStartColor(),
                ),
              )),
              Divider(),
              SizedBox(
                height: 5.0,
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Container(
                        child: Text(
                          'Name',
                          style: TextStyle(
                              color: appStartColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Container(
                        child: Text(
                          'Status',
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
                child: getDivisionWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getDivisionWidget() {
    return FutureBuilder<List<Div>>(
        future: getDivision(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("snapshot.data.length");
            print(snapshot.data.length);
            if (snapshot.data.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.height * 0.33,
                          child: Text(snapshot.data[index].div.toString(),
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          //width: MediaQuery.of(context).size.height * 0.10,
                          child: Text(snapshot.data[index].status.toString(),
                              style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      snapshot.data[index].status.toString() ==
                                              'Active'
                                          ? Colors.green
                                          : Colors.red)),
                        ),
                      ],
                    ),
                    onTap: () {
                      showAlertDialog(context, snapshot.data[index].id.toString(), snapshot.data[index].div.toString(),
                        snapshot.data[index].status.toString(),
                      );
                    },
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  showAlertDialog(BuildContext context, String id, String div, String status) async {
    print("status division");
    print(status);
    var Name = new TextEditingController();
    Name.text=div;
    Widget cancelButton = FlatButton(
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.5),
          width: 1,
        )),
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget updateButton = FlatButton(
      color: Colors.orange,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        "Update",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async {
        print("Shaifali");
        print(status);
        var sts = await updateDiv(status, id);
        if(sts.contains("1")){
          Navigator.of(context, rootNavigator: true).pop('dialog');
          showDialog(context: context, child:
          new AlertDialog(
            content: new Text('Division update successfully.'),
          )
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Division()),
          );
        }else{
          Navigator.of(context, rootNavigator: true).pop('dialog');
          showDialog(context: context, child:
          new AlertDialog(
            content: new Text('Error to update'),
          )
          );
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height*0.20,
        width: MediaQuery.of(context).size.width*0.32,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
               new Expanded(
                   child:  TextField(
                     enabled: false, //Disable a `TextField`
                     controller: Name,
                     decoration: new InputDecoration(
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(8),
                           borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                         ),
                         labelText: 'Division', hintText: 'Department Name'),
                   ),
               ),

              SizedBox(height: 10,),
              new Expanded(child:
                new InputDecorator(
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                    ),
                    labelText: 'Status',
                  ),
                  child:DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: status,
                      onChanged: (String newValue) {
                        print(status);
                        setState(() {
                          status=newValue;
                          Navigator.of(context, rootNavigator: true).pop('dialog'); // here I pop to avoid multiple Dialogs
                          showAlertDialog(context, id, div, status);
                        });
                        print("status");
                        print(status);
                      },
                      items: statuses.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
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
      actions: [
        cancelButton,
        updateButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
