import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }


  getmainhomewidget() {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddHoliday()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
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
              Navigator.pop(context);
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
            Divider(),
            SizedBox(height: 5.0),
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
                        'Duration',
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
    );
  }

  getHolidayWidget() {
    return FutureBuilder<List<Holidays>>(
        future: getHolidaysList(),
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
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.height *0.12,
                      child:  Text(snapshot.data[index].Name.toString(), style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      width: MediaQuery.of(context).size.height * 0.12,
                      child:  Text(snapshot.data[index].DateFrom.toString(), style: TextStyle(fontSize: 14)),//16
                    ),
                    //SizedBox(width: 5,),
                    Container(
                      width: MediaQuery.of(context).size.height * 0.12,
                      child:  Text(snapshot.data[index].DateTo.toString(), style: TextStyle(fontSize: 14)),
                    ),
                    SizedBox(width: 15,),
                    Container(
                      //width: MediaQuery.of(context).size.height * 0.02,
                      child:  Text(snapshot.data[index].Duration.toString(), style: TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }
}
