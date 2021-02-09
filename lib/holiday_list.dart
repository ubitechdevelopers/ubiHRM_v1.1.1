import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/appbar.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/model/model.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'addHoliday.dart';
import 'drawer.dart';

class Holiday extends StatefulWidget {
  @override
  _Holiday createState() => _Holiday();
}

class _Holiday extends State<Holiday> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var profileimage;
  bool showtabbar;
  String orgName = "";
  int adminsts = 0;
  TextEditingController _searchController;
  FocusNode searchFocusNode;
  String holiday = "";

  @override
  void initState() {
    super.initState();
    _searchController = new TextEditingController();
    searchFocusNode = FocusNode();
    profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);
    getOrgName();
  }

  getOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName = prefs.getString('orgname') ?? '';
      adminsts = prefs.getInt('adminsts') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }


  getmainhomewidget() {
    return RefreshIndicator(
      child: new Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddHoliday()),
            );
          },
          tooltip: 'Add Holiday',
          child: Icon(Icons.add),
          backgroundColor: Colors.orange[800],
        ),
        backgroundColor: scaffoldBackColor(),
        key: _scaffoldKey,
        appBar: AppHeader(profileimage,showtabbar,orgName),
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
            children: <Widget>[
              Center(
                child: Text(
                  'Holidays',
                  style: new TextStyle(
                    fontSize: 22.0,
                    color: appStartColor(),
                  ),
                ),
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
                      hintText: 'Search Holiday',
                      //labelText: 'Search Holiday',
                      suffixIcon: _searchController.text.isNotEmpty?IconButton(icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Holiday()),
                            );
                          }
                      ):null,
                      //focusColor: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        holiday = value;
                      });
                    },
                  ),
                ),
              ),
              //Divider(),
              //SizedBox(height: 5.0),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
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
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Container(
                        child: Text(
                          'From',
                          style: TextStyle(
                              color: appStartColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0), //15
                      child: Container(
                        child: Text(
                          'To',
                          style: TextStyle(
                              color: appStartColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0), //20
                      child: Container(
                        child: Text(
                          'Days',
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
                child: getHolidayWidget(),
              ),
            ],
          ),
        ),
      ),
      onRefresh: () async {
        Completer<Null> completer = new Completer<Null>();
        await Future.delayed(Duration(seconds: 1)).then((onvalue) {
          setState(() {
            _searchController.clear();
            holiday='';
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          });
          completer.complete();
        });
        return completer.future;
      },
    );
  }

  getHolidayWidget() {
    return FutureBuilder<List<Holi>>(
        future: getHolidaysList(holiday),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.height *0.12,
                      child:  Text(snapshot.data[index].name.toString(), style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                    ),
                    //SizedBox(width: 10,),
                    Container(
                      width: MediaQuery.of(context).size.height * 0.11,
                      child:  Text(snapshot.data[index].DateFrom.toString(), style: TextStyle(fontSize: 14)),//16
                    ),
                    //SizedBox(width: 5,),
                    Container(
                      width: MediaQuery.of(context).size.height * 0.11,
                      child:  Text(snapshot.data[index].DateTo.toString(), style: TextStyle(fontSize: 14)),
                    ),
                    SizedBox(width: 20,),
                    Container(
                      //width: MediaQuery.of(context).size.height * 0.02,
                      child:  Text(snapshot.data[index].Duration.toString(), style: TextStyle(fontSize: 14)),
                    ),
                  ],
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
              child:Text("No holiday found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
            ),
          );
        }
      } else if (snapshot.hasError) {
        return new Text("Unable to connect server");
      }
      return new Center(child: CircularProgressIndicator());
    });
  }
}
