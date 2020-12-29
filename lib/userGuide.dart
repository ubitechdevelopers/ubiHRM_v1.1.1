
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/global.dart';

import 'drawer.dart';

void main() => runApp(new UserGuide());

class UserGuide extends StatefulWidget {
  @override
  _UserGuide createState() => _UserGuide();
}

class _UserGuide extends State<UserGuide> {
  String fname="";
  String lname="";
  String desination="";
  String profile="";
  String org_name="";

  final iconThumbnail =new Container(
    margin: new EdgeInsets.symmetric(
        vertical: 16.0
    ),
    alignment: FractionalOffset.centerLeft,
    child: new Image(
      image: new AssetImage("assets/icons/Dashboard_icon.png"),
      height: 92.0,
      width: 92.0,
    ),
  );
  final iconcard = Container(
    height: 150.0,
    decoration: new BoxDecoration(
      color: Colors.green[50],
      shape: BoxShape.rectangle,
      borderRadius: new BorderRadius.circular(8.0),
      boxShadow: <BoxShadow>[
        new BoxShadow(
          color: Colors.black12,
          blurRadius: 10.0,
          offset: new Offset(0.0, 10.0),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.only(left:8.0),
      child: SizedBox(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('View Dashboard',style: TextStyle(fontSize: 20.0,color: Colors.blue)),
            RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                          text: '1. Click on ', style: TextStyle(color: Colors.black)
                      ),
                      TextSpan(
                          text: '“Dashboard” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                      ),
                      TextSpan(
                          text: 'to view details like:', style: TextStyle(color: Colors.black)
                      ),
                    ]
                )
            ),
            //SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
            Text("    > Monthly Overtime/Undertime."),
            //SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
            Text("    > Monthly attendance summary."),
            //SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
            Text("    > Leave balance (Yearly basis)."),
            //SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
            Text("    > Upcoming holidays."),
          ],
        ),
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fname = prefs.getString('fname') ?? '';
      lname = prefs.getString('lname') ?? '';
      desination = prefs.getString('desination') ?? '';
      profile = prefs.getString('profile') ?? '';
      org_name = prefs.getString('org_name') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(org_name, style: new TextStyle(fontSize: 20.0)),
            ],
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: appStartColor(),
        ),
        endDrawer: new AppDrawer(),
        body: userWidget()
    );
  }

  userWidget(){
    return Container(
        margin: const EdgeInsets.all(10.0),
        width:  MediaQuery.of(context).size.width * 1,
        child:ListView(
            children: <Widget>[

              Center(child: Text('Explore ubiHRM (User)', style: new TextStyle(fontSize: 25.0, color: appStartColor(), fontWeight: FontWeight.bold))),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04,),

              Container(
                width: MediaQuery.of(context).size.width*1,
                color: Colors.white10,
                padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:5.0),
                      child: Image.asset('assets/icons/Dashboard_icon.png',height: 70, width: 70, alignment: Alignment.topLeft,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.68,
                        padding:EdgeInsets.only(top:8.0,bottom: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Text("Dashboard",style: TextStyle(fontSize: 24.0,color: appStartColor(),fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

              SizedBox(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('View Dashboard',style: TextStyle(fontSize: 20.0,color: Colors.blue)),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                    RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '1. Click on ', style: TextStyle(color: Colors.black)
                              ),
                              TextSpan(
                                  text: '“Dashboard” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                              ),
                              TextSpan(
                                  text: 'to view details like:', style: TextStyle(color: Colors.black)
                              ),
                            ]
                        )
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                    Text("    > Monthly Overtime/Undertime."),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                    Text("    > Monthly attendance summary."),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                    Text("    > Leave balance (Yearly basis)."),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                    Text("    > Upcoming holidays."),
                  ],
                ),
              ),

              SizedBox(height: 20.0,),
              Container(
                  width: MediaQuery.of(context).size.width*1,
                  color: Colors.white10,
                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Image.asset('assets/icons/profile_icon.png',height: 70, width: 70, alignment: Alignment.topLeft,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.68,
                          padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text("Profile",style: TextStyle(fontSize: 24.0,color: appStartColor(),fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
              SizedBox(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('How to view profile?',style: TextStyle(fontSize: 20.0,color: Colors.blue)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '1. Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Profile” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'icon from home screen.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '2. You can view your details in ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Self” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'tab like:', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("    > About"),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("    > Reporting to"),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("    > Contact info"),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '3. You can also view your team in ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Team” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'tab.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                    ],
                  )
              ),

              SizedBox(height: 20.0,),
              Container(
                  width: MediaQuery.of(context).size.width*1,
                  color: Colors.white10,
                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Image.asset('assets/icons/Attendance_icon.png',height: 70, width: 70, alignment: Alignment.topLeft,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.68,
                          padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text("Attendance",style: TextStyle(fontSize: 24.0,color: appStartColor(),fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
              SizedBox(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('How to punch Attendance?',style: TextStyle(fontSize: 20.0,color: Colors.blue)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '1. Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Attendance” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'icon from home screen.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '2. Current location will be shown. If it is incorrect then press ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Refresh Location” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      //Text("3. Click on “Time In” button."),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '3. Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Time In” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'button.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      //Text("4. Capture your Selfie and click on “OK” button to punch attendance."),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '4. Capture your Selfie and click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“OK” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'button to punch attendance.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("5. Time In will be punched successfully. Same process will be followed for Time Out."),
                    ],
                  )
              ),

              SizedBox(height: 20.0,),
              SizedBox(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('How to view Attendance log?',style: TextStyle(fontSize: 20.0,color: Colors.blue)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),

                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '1. Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Attendance” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'icon from home screen and then click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Check Attendance Log” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'link to check your past 30 days attendance logs in ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Self” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: "tab and team's past 30 days attendance logs in ", style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Team” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: "tab which includes:", style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("    > Date"),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("    > Time In with selfie"),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("    > Time Out with selfie"),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("    > Location"),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("    > Attendance status"),
                    ],
                  )
              ),

              SizedBox(height: 20.0,),
              Container(
                  width: MediaQuery.of(context).size.width*1,
                  color: Colors.white10,
                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Image.asset('assets/icons/leave_icon.png',height: 70, width: 70, alignment: Alignment.topLeft,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.68,
                          //color: appStartColor().withOpacity(0.1),
                          //color: Colors.green[50],
                          padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text("Leave",style: TextStyle(fontSize: 24.0,color: appStartColor(),fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
              SizedBox(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('How to apply for a Leave?',style: TextStyle(fontSize: 20.0,color: Colors.blue)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '1. Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Leave” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'icon from home screen.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '2. Click on add icon ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“+” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'to apply for a leave.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '3. Fill the request Leave form and click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Apply”.', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '4. Applied Leave history of ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Self & Team” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'can be viewed with the status.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                    ],
                  )
              ),

              SizedBox(height: 20.0,),
              Container(
                  width: MediaQuery.of(context).size.width*1,
                  color: Colors.white10,
                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Image.asset('assets/icons/Timeoff_icon.png',height: 70, width: 70, alignment: Alignment.topLeft,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.68,
                          //color: appStartColor().withOpacity(0.1),
                          //color: Colors.green[50],
                          padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text("Time Off",style: TextStyle(fontSize: 24.0,color: appStartColor(),fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
              SizedBox(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('How to apply for a Time Off?',style: TextStyle(fontSize: 20.0,color: Colors.blue)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '1. Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Time Off” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'from home screen.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '2. Click on add icon ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“+” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'to apply for a Time Off.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '3. Fill the request Time Off form and click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Apply” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '4. Applied Time Off history of ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Self & Team” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'can be viewed with the status.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                    ],
                  )
              ),
              SizedBox(height: 20.0,),
              Container(
                  width: MediaQuery.of(context).size.width*1,
                  color: Colors.white10,
                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Image.asset('assets/icons/visits_icon.png',height: 70, width: 70, alignment: Alignment.topLeft,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.68,
                          //color: appStartColor().withOpacity(0.1),
                          //color: Colors.green[50],
                          padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text("Visits",style: TextStyle(fontSize: 24.0,color: appStartColor(),fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  )
                //child:Text("Dashboard",style: TextStyle(fontSize: 22.0,color: appStartColor(),fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
              SizedBox(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('How to punch Visits?',style: TextStyle(fontSize: 20.0,color: Colors.blue)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("The visits feature is used for employees who visit clients/sites/offices:"),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("1. The field employees should ensure that the GPS is turned on."),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '2. Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Visits” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'from home screen.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '3. Click on add icon ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“+”', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: ', Add client name.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '4. To punch Visit start, click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Visit In”', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: ', click picture.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '5. For Visit End, click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Visit Out” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'and fill details about the Visit and click picture.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '6. Punched Visits history of ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Self & Team” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'can be viewed with the details.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                    ],
                  )
              ),

              SizedBox(height: 20.0,),
              Container(
                  width: MediaQuery.of(context).size.width*1,
                  color: Colors.white10,
                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Image.asset('assets/icons/Flexi_icon.png',height: 70, width: 70, alignment: Alignment.topLeft,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.68,
                          //color: appStartColor().withOpacity(0.1),
                          //color: Colors.green[50],
                          padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text("Flexi Time",style: TextStyle(fontSize: 24.0,color: appStartColor(),fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
              SizedBox(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('How to punch Flexi Time?',style: TextStyle(fontSize: 20.0,color: Colors.blue)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '1. Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Flexi Time” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'from home screen.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '2. Current location will be shown. If it is incorrect then press ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Refresh Location”.', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '3. Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Time In” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'button.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '4. Capture your Selfie and click on the ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“OK” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'button to punch attendance.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("5. Time In will be punched successfully. Same process will be followed for Time Out."),
                    ],
                  )
              ),

              SizedBox(height: 20.0,),
              Container(
                  width: MediaQuery.of(context).size.width*1,
                  color: Colors.white10,
                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Image.asset('assets/icons/Salary_icon.png',height: 70, width: 70, alignment: Alignment.topLeft,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.68,
                          padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text("Salary/Payroll",style: TextStyle(fontSize: 24.0,color: appStartColor(),fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
              SizedBox(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('How to view Salary/Payroll Slip?',style: TextStyle(fontSize: 20.0,color: Colors.blue)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '1. Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Salary/Payroll” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'Icon from the home screen to download the monthly Salary/Payroll Slip which includes:', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("    > Month"),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("    > Amount"),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("    > Paid Days"),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("    > Action to download Salary/Payroll slip in PDF format."),
                    ],
                  )
              ),

              SizedBox(height: 20.0,),
              Container(
                  width: MediaQuery.of(context).size.width*1,
                  color: Colors.white10,
                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Image.asset('assets/icons/Expense_icon.png',height: 70, width: 70, alignment: Alignment.topLeft,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.68,
                          padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text("Expense",style: TextStyle(fontSize: 24.0,color: appStartColor(),fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
              SizedBox(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('How to Reimburse Expenses?',style: TextStyle(fontSize: 20.0,color: Colors.blue)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                            // set the default style for the children TextSpans
                            //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                              children: [
                                TextSpan(
                                    text: '1. Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Expense” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'from home screen.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '2. Click on add icon ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“+”', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: ', to apply for Expense.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '3. Fill the request form and click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Submit” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'button.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '4. Applied ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Expense” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'history can be viewed with the status.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                    ],
                  )
              ),

              SizedBox(height: 30.0,),
              Center(child: Text('Explore ubiHRM (Admin)',style: TextStyle(fontSize: 25.0,color: appStartColor(), fontWeight: FontWeight.bold))),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
              Container(
                  width: MediaQuery.of(context).size.width*1,
                  color: Colors.white10,
                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Image.asset('assets/icons/graph_icon.png',height: 70, width: 70, alignment: Alignment.topLeft,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.68,
                          padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text("Report",style: TextStyle(fontSize: 24.0,color: appStartColor(),fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
              SizedBox(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('How to View Reports?',style: TextStyle(fontSize: 20.0,color: Colors.blue)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '1. Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Reports” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'from home screen.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("2. Employees various reports can be viewed under this which includes:"),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("    > Attendance"),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("    > Leave"),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      Text("    > Time Off"),
                    ],
                  )
              ),

              SizedBox(height: 10.0,),
              Container(
                  color: Colors.white10,
                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:0.0),
                        child: new Icon(Icons.check_circle_outline,color: Colors.green[100], size: 80,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:0.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.66,
                          padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text("Approvals",style: TextStyle(fontSize: 24.0,color: appStartColor(),fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('How to approve Leave, Time Off & Expense?',style: TextStyle(fontSize: 20.0,color: Colors.blue)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Approvals” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'from bottom navigation bar of home screen.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                      Text('Leave',style: TextStyle(fontSize: 18.0,color: Colors.blue)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '1. Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Leave” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: ', you can view the list of pending leave requests.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '2. Leave request can either be rejected or approved and you can see the list of approved and rejected leave requests in ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Approved” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: '& ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Rejected” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'tab respectively.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                      Text('Time Off',style: TextStyle(fontSize: 18.0,color: Colors.blue)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '1. Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Time Off” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: ', you can view the list of pending time off requests.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '2. Time Off request can either be rejected or approved and you can see the list of approved and rejected time off requests in ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Approved” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: '& ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Rejected” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'tab respectively.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                      Text('Expense',style: TextStyle(fontSize: 18.0,color: Colors.blue)),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '1. Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Expense” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: ', you can view the list of pending expense requests.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '2. Expense request can either be rejected or approved and you can see the list of approved and rejected expense requests in ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Approved” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: '& ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Rejected” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'tab respectively.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                    ],
                  )
              ),

              SizedBox(height: 10.0,),
              Container(
                  width: MediaQuery.of(context).size.width*1,
                  color: Colors.white10,
                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:0.0),
                        child: new Icon(Icons.settings,color: Colors.green[100], size: 80,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:0.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.66,
                          padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text("Settings",style: TextStyle(fontSize: 24.0,color: appStartColor(),fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  )
              ),

              SizedBox(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('How to Change Password?',style: TextStyle(fontSize: 20.0,color: Colors.blue)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '1. Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Settings” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'from bottom navigation bar of home screen.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '2. Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Change Password”.', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '3. Enter your ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Old Password” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: '& ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“New Password”.', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                              ]
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                      RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '4. Click on ', style: TextStyle(color: Colors.black)
                                ),
                                TextSpan(
                                    text: '“Submit” ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                                ),
                                TextSpan(
                                    text: 'button.', style: TextStyle(color: Colors.black)
                                ),
                              ]
                          )
                      ),
                    ],
                  )
              ),
            ]
        )
    );
  }
}