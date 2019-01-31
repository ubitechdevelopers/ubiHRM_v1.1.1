import 'package:flutter/material.dart';
import 'drawer.dart';
import 'graphs.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'global.dart';
import 'services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'model/model.dart';
import 'requestleave.dart';

class MyLeave extends StatefulWidget {
  @override
  _MyLeaveState createState() => _MyLeaveState();
}

class _MyLeaveState extends State<MyLeave> {
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

    setState(() {
      mainWidget = loadingWidget();
    });
    String empid = prefs.getString('employeeid')??"";
    String organization =prefs.getString('organization')??"";
    islogin().then((Widget configuredWidget) {
      setState(() {
        mainWidget = configuredWidget;
      });
    });
  }

  withdrawlLeave(String leaveid) async{

    var leave = Leave(leaveid: leaveid, orgid: '10', uid: '4140', approverstatus: '5');
    var islogin = await withdrawLeave(leave);;
    print(islogin);
    if(islogin=="success"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyLeave()),
      );
      /*showDialog(context: context, child:
      new AlertDialog(
        title: new Text("Congrats!"),
        content: new Text("Your leave is withdrawl successfully!"),
      )
      );*/
    }else if(islogin=="failure"){
      showDialog(context: context, child:
      new AlertDialog(
        title: new Text("Sorry!"),
        content: new Text("Leave withdrawl failed."),
      )
      );
    }else{
      showDialog(context: context, child:
      new AlertDialog(
        title: new Text("Sorry!"),
        content: new Text("Poor network connection."),
      )
      );
    }
  }

  confirmWithdrawl(String leaveid) async{
    showDialog(context: context, child:
    new AlertDialog(
      title: new Text("Do you really want to withdraw your leave."),
      content:  ButtonBar(
        children: <Widget>[
          FlatButton(
            shape: Border.all(),
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          RaisedButton(
            child: Text('Withdraw'),
            color: Colors.teal,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              withdrawlLeave(leaveid);
            },
          ),
        ],
      ),
    )
    );
  }


  Future<Widget> islogin() async{
    final prefs = await SharedPreferences.getInstance();
    int response = prefs.getInt('response')??0;
    if(response==1){
      return mainScafoldWidget();
    }else{
      return new LoginPage();
    }

  }

  @override
  Widget build(BuildContext context) {

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
        bottomNavigationBar:new Theme(
            data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: bottomNavigationColor(),
            ), // sets the inactive color of the `BottomNavigationBar`
            child:  BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (newIndex) {
                if (newIndex == 2) {
                  /* Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              );*/
                  return;
                } else if (newIndex == 0) {
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
                  icon: new Icon(
                    Icons.library_books,
                    color: Colors.white,
                  ),
                  title: new Text('Reports',style: TextStyle(color: Colors.white)),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.home,
                    color: Colors.orangeAccent,
                  ),
                  title: new Text('Home',
                      style: TextStyle(color: Colors.orangeAccent)),
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    title: Text('Settings',style: TextStyle(color: Colors.white)))
              ],
            )),
        floatingActionButton: new FloatingActionButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RequestLeave()),
            );
          },
          tooltip: 'Request Leave',
          child: new Icon(Icons.add),
        ),
        body: homewidget()
    );
  }

  Widget homewidget(){
    return Stack(
      children: <Widget>[
        Container(
          //height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            //width: MediaQuery.of(context).size.width*0.9,
            decoration: new ShapeDecoration(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
              color: Colors.white,
            ),
            child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Leave History',
                      style: new TextStyle(fontSize: 22.0, color: Colors.teal)),
                  //SizedBox(height: 10.0),

                  new Divider(color: Colors.black54,height: 1.5,),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 50.0,),
                      SizedBox(width: MediaQuery.of(context).size.width*0.0),
                      Container(
                        width: MediaQuery.of(context).size.width*0.17,
                        child:Text('Details',style: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold,fontSize: 16.0),),
                      ),

                      SizedBox(height: 50.0,),
                      Container(
                        width: MediaQuery.of(context).size.width*0.25,
                        child:Text('From',style: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold,fontSize: 16.0),),
                      ),
                      SizedBox(height: 50.0,),
                      Container(
                        width: MediaQuery.of(context).size.width*0.24,
                        child:Text('To',style: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold,fontSize: 16.0),),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.22,
                        child:Text('Status',style: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold,fontSize: 16.0),),
                      ),
                    ],
                  ),
                  new Divider(),
            new Expanded(
                child: Container(
                    height: MediaQuery.of(context).size.height*.55,
                    width: MediaQuery.of(context).size.width*.99,
                    //padding: EdgeInsets.only(bottom: 15.0),
                    color: Colors.white,
                    //////////////////////////////////////////////////////////////////////---------------------------------
                    child: new FutureBuilder<List<Leave>>(
                      future: getLeaveSummary("4140"),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.length>0) {
                            return new ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return new Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            new Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.17,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    new SizedBox(width: 5.0,),
                                                    new Text(
                                                      "Day(s)\n" +
                                                          snapshot.data[index].leavedays
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold),),
                                                    (snapshot.data[index].withdrawlsts &&
                                                        snapshot.data[index]
                                                            .approverstatus.toString() !=
                                                            'Withdraw' &&
                                                        snapshot.data[index]
                                                            .approverstatus.toString() !=
                                                            "Rejected")
                                                        ? new Container(
                                                        height: 18.5,
                                                        child: new FlatButton(
                                                          padding: EdgeInsets.all(1.0),
                                                          color: Colors.orangeAccent,
                                                          onPressed: () {
                                                            confirmWithdrawl(
                                                                snapshot.data[index]
                                                                    .leaveid.toString());
                                                          },
                                                          child: Text("withdraw"),
                                                        )
                                                    )
                                                        : Center(),
                                                  ],
                                                )),

                                            new Container(
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.25,
                                              child: Text(
                                                  snapshot.data[index].leavefrom
                                                      .toString(), style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                            ),
                                            new Container(
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.25,
                                              child: Text(
                                                  snapshot.data[index].leaveto
                                                      .toString(), style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                            ),
                                            Container(
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.23,
                                              decoration: new ShapeDecoration(
                                                shape: new RoundedRectangleBorder(
                                                    borderRadius: new BorderRadius
                                                        .circular(2.0)),
                                                color: snapshot.data[index]
                                                    .approverstatus.toString() ==
                                                    'Approved' ? Colors.green
                                                    .withOpacity(0.75) : snapshot
                                                    .data[index].approverstatus
                                                    .toString() == 'Rejected' ||
                                                    snapshot.data[index].approverstatus
                                                        .toString() == 'Cancel' ? Colors
                                                    .red.withOpacity(0.65) : snapshot
                                                    .data[index].approverstatus
                                                    .toString().startsWith('Pending')
                                                    ? Colors.orangeAccent
                                                    : Colors.black12,
                                              ),

                                              //color: Colors.black12, // withdrawn
                                              //color: Colors.orangeAccent, // pending
                                              //color: Colors.red.withOpacity(0.65), // rejected,cancel
                                              // color: Colors.green.withOpacity(0.75), // approved
                                              padding: EdgeInsets.only(top: 1.5,
                                                  bottom: 1.5,
                                                  left: 8.0,
                                                  right: 8.0),
                                              margin: EdgeInsets.only(top: 4.0),
                                              child: Text(
                                                snapshot.data[index].approverstatus
                                                    .toString(), style: TextStyle(
                                                color: Colors.white, fontSize: 14.0,),
                                                textAlign: TextAlign.center,),
                                            ),
                                            /*  (snapshot.data[index].withdrawlsts && snapshot.data[index].ApprovalSts.toString()!='Withdraw' && snapshot.data[index].ApprovalSts.toString()!="Rejected")?Container(
                                  height: 25.0,
                                  width: 25.0,
                                  child: FittedBox(
                                      child:new  FloatingActionButton(
                                        backgroundColor: Colors.redAccent,
                                        onPressed: () {
                                          confirmWithdrawl(snapshot.data[index].TimeOffId.toString());
                                        },
                                        tooltip: 'Withdraw Timeoff',
                                        child: new Icon(Icons.refresh, size: 40.0,),
                                      )
                                  )
                              ): Container(),*/
                                            //Divider(),
                                          ],
                                        ),
                                        //SizedBox(width: 30.0,),

                                        snapshot.data[index].reason.toString() != '-'
                                            ? Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * .90,
                                          padding: EdgeInsets.only(
                                              top: 1.5, bottom: 1.5),
                                          margin: EdgeInsets.only(top: 4.0),
                                          child: RichText(
                                          text: new TextSpan(
                                          // Note: Styles for TextSpans must be explicitly defined.
                                          // Child text spans will inherit styles from parent
                                          style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                  new TextSpan(text: 'Reason: '
                                      ,style: new TextStyle(fontWeight: FontWeight.bold)),
                                  new TextSpan(text: snapshot.data[index].reason.toString(), ),
                                  ],
                                  ),
                                  )
                                        )
                                            : Center(),
                                        snapshot.data[index].comment.toString() != '-'
                                            ? Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * .90,
                                          padding: EdgeInsets.only(
                                              top: 1.5, bottom: 1.5),
                                          margin: EdgeInsets.only(top: 4.0),
                                          child: Text('Comment: ' +
                                              snapshot.data[index].comment.toString(),
                                            style: TextStyle(color: Colors.black54),),
                                        )
                                            : Center(),

                                        Divider(color: Colors.black45,),
                                      ]);
                                }
                            );
                          }else
                            return new Center(
                              child: Text('No Leave History'),
                            );
                        } else if (snapshot.hasError) {
                          return new Text("Unable to connect server");
                        }

                        // By default, show a loading spinner
                        return new Center( child: CircularProgressIndicator());
                      },
                    ),
                    //////////////////////////////////////////////////////////////////////---------------------------------
                  ),
            ),
                ])
        ),



      ],
    );
  }
}
