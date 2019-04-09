import 'package:flutter/material.dart';
import '../drawer.dart';
import '../graphs.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import '../global.dart';
import '../services/leave_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_page.dart';
import '../model/model.dart';
import 'requestleave.dart';
import 'approval.dart';
import '../home.dart';
import '../profile.dart';
//import 'bottom_navigationbar.dart';
import '../b_navigationbar.dart';
import '../appbar.dart';


class MyLeave extends StatefulWidget {
  @override
  _MyLeaveState createState() => _MyLeaveState();
}

class _MyLeaveState extends State<MyLeave> {
  int _currentIndex = 0;
  int response;
  var profileimage;
  bool showtabbar ;
  bool _checkLoadedprofile = true;
  var PerLeave;
  var PerApprovalLeave;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



  Widget mainWidget= new Container(width: 0.0,height: 0.0,);
  @override
  void initState() {
    super.initState();
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    profileimage.resolve(new ImageConfiguration()).addListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoadedprofile = false;
        });

      }
    });
    showtabbar=false;
  //  print(profileimage);
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
  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }

  withdrawlLeave(String leaveid) async{
    final prefs = await SharedPreferences.getInstance();

    String empid = prefs.getString('employeeid')??"";
   String orgid =prefs.getString('organization')??"";
    var leave = Leave(leaveid: leaveid, orgid: orgid, uid: empid, approverstatus: '5');
    var islogin = await withdrawLeave(leave);
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
        //title: new Text("Sorry!"),
        content: new Text("Leave could not be withdrawn."),
      )
      );
    }else{
      showDialog(context: context, child:
      new AlertDialog(
       // title: new Text("Sorry!"),
        content: new Text("Poor network connection."),
      )
      );
    }
  }

  confirmWithdrawl(String leaveid) async{
    showDialog(context: context, child:
    new AlertDialog(
      title: new Text("Withdraw  leave?"),
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
            child: Text('Withdraw',style: TextStyle(color: Colors.white),),
            color: Colors.orange[800],
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
        appBar: new AppHeader(profileimage,showtabbar),
/*        appBar: GradientAppBar(

          backgroundColorStart: appStartColor(),
          backgroundColorEnd: appEndColor(),
          automaticallyImplyLeading: false,
          // title: const Text('Approvals'),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                // When the child is tapped, show a snackbar
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CollapsingTab()),
                  );
                },
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        //image: AssetImage('assets/avatar.png'),
                        image: _checkLoadedprofile ? AssetImage('assets/avatar.png') : profileimage,
                      )
                  )),),
          new Expanded(
            child: Container(
                  padding: const EdgeInsets.all(5.0), child: Text('UBIHRM')
              ),),
            ],

          ),



          actions:<Widget>[
            new DropdownButton<String>(
              hint: new Text("My Leave" , style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              )),
              items: <String>['My Approvals', 'My Leave'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),

                );
              }).toList(),
              onChanged: (value) {
                value=value;
                switch(value) {
                  case "My Approvals" :
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TabbedApp()),
                    );
                    break;
                  case "My Leave" :
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyLeave()),
                    );
                    break;
                }},
            )


          ],
        *//*  backgroundColorStart: appStartColor(),
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

          ),*//*
        ),*/
        bottomNavigationBar:new HomeNavigation(),

        floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.orange[800],
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
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            //width: MediaQuery.of(context).size.width*0.9,
            decoration: new ShapeDecoration(
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
              color: Colors.white,
            ),
            child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('My Leave',
                   style: new TextStyle(fontSize: 22.0, color: appStartColor())),
                  //SizedBox(height: 10.0),

                  new Divider(color: Colors.black54,height: 1.5,),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 50.0,),
                     // SizedBox(width: MediaQuery.of(context).size.width*0.0),

                      new Expanded(
                        child: Container(
                        width: MediaQuery.of(context).size.width*0.45,
                        child:Text('Applied on',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                      ),),
                      /*  new Expanded(
                        child: Container(
                        width: MediaQuery.of(context).size.width*0.35,),),
                    SizedBox(height: 50.0,),
                      Container(
                        width: MediaQuery.of(context).size.width*0.25,
                        child:Text('From',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                      ),*/
                      //SizedBox(height: 50.0,),

                      new Expanded(
                        child: Container(
                        width: MediaQuery.of(context).size.width*0.20,
                          margin: EdgeInsets.only(left:22.0),
                        child:Text('Duration',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                      ),
        ),

                      new Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left:42.0),
                        width: MediaQuery.of(context).size.width*0.30,
                        child:Text('Action',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                      ),),
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
                        future: getLeaveSummary(),
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
                                   new Expanded(
                                     child: Container(
                                      width: MediaQuery .of(context).size .width * 0.35,
                                      child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                          new SizedBox(width: 5.0,),
                                          new Text(
                                          snapshot.data[index].attendancedate.toString(),
                                          style: TextStyle(
                                          fontWeight: FontWeight.bold),)
                                         /* (snapshot.data[index].withdrawlsts &&
                                           snapshot.data[index].approverstatus.toString() !='Withdraw' && snapshot.data[index].approverstatus.toString() !=
                                           "Rejected") ? new Container(
                                             height: 18.5,
                                             child: new RawMaterialButton(
                                               padding: EdgeInsets.all(1.0),
                                              //  color: Colors.orangeAccent,
                                                onPressed: () {
                                                confirmWithdrawl(
                                                snapshot.data[index].leaveid.toString());},child:new Icon(Icons.replay, size: 18.0,color:Colors.black,
                               ),
                              )
                                        ) : Center(),*/
                                        ],
                                        )),),


/* new Container(
   width: MediaQuery.of(context).size.width * 0.25,
                 child: Text(
                            snapshot.data[index].leavefrom
                              .toString(), style: TextStyle(
                                  fontWeight: FontWeight.bold)),
                                   ),
                                     new Container(
                                   width: MediaQuery .of(context) .size .width * 0.25, child: Text(snapshot.data[index].leaveto .toString(), style: TextStyle(
                       fontWeight: FontWeight.bold)),
                            ),*/


                                   new Container(
                                       child: RichText(
                                         text: new TextSpan(
                                           style: new TextStyle(
                                             fontSize: 14.0,
                                             color: Colors.black,
                                           ),
                                           children: <TextSpan>[
                                             new TextSpan(text: ''
                                                 ,style: new TextStyle(fontWeight: FontWeight.bold)),
                                             new TextSpan(text: snapshot.data[index].leavefrom.toString()+snapshot.data[index].leaveto.toString() +"  ",style: TextStyle(color: Colors.grey[600]), ),

                                           ],
                                         ),
                                       )
                                   ),

                                   new Expanded(
                                     child: Container(
                                      width: MediaQuery .of(context).size.width * 0.30,
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: <Widget>[
                                             new SizedBox(width: 5.0,),
                                             new Text(
                                               "",
                                             style: TextStyle(
                                                 fontWeight: FontWeight.bold),),
                                             (snapshot.data[index].withdrawlsts &&
                                              snapshot.data[index].approverstatus.toString() !='Withdrawn' && snapshot.data[index].approverstatus.toString() !=
                                                 "Rejected"&& snapshot.data[index].approverstatus.toString() !="Approved") ? new Container(
                                                 height: 30.5,
                                                 margin: EdgeInsets.only(
                                                 left:25.0),
                                                 child: new OutlineButton(
                                                 child:new Icon(Icons.replay, size: 18.0,color:appStartColor(), ),
                                                borderSide: BorderSide(color:appStartColor()),

                                                   //  color: Colors.orangeAccent,
                                                 onPressed: () {
                                                 confirmWithdrawl(
                                                 snapshot.data[index].leaveid.toString());},
                                                 shape: new CircleBorder(),
                                                 )
                                             ) : Center()
                                           ],
                                         )
                              //  decoration: new ShapeDecoration(
                               //   shape: new RoundedRectangleBorder(
                                  // borderRadius: new BorderRadius
                                   //   .circular(2.0)),
                                       /* color: snapshot.data[index]
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
                                                    : Colors.black12,*/
                                               // ),

                                                //color: Colors.black12, // withdrawn
                                                //color: Colors.orangeAccent, // pending
                                                //color: Colors.red.withOpacity(0.65), // rejected,cancel
                                                // color: Colors.green.withOpacity(0.75), // approved
                        /*  padding: EdgeInsets.only(top: 1.5,
                                                   bottom: 1.5,
                                                   left: 8.0,
                                                    right: 8.0),
                         margin: EdgeInsets.only(top: 4.0, bottom: 1.5,),
                         child: Text( snapshot.data[index].approverstatus .toString(), style: TextStyle( color: snapshot.data[index] .approverstatus.toString() =='Approved' ? Colors.green.withOpacity(0.75) : snapshot.data[index].toString() == 'Rejected' || snapshot.data[index].approverstatus .toString() == 'Cancel' ? Colors.red.withOpacity(0.65) : snapshot.data[index].approverstatus
   .toString().startsWith('Pending') ? Colors.deepOrange[300] : Colors.black12, fontSize: 14.0,),
                              textAlign: TextAlign.center,),*/



                                     ),),



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

                                         /* SizedBox(width: 20.0,),
                                          new Container(
                                              child: RichText(
                                                text: new TextSpan(
                                                  style: new TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                  ),
                                                  children: <TextSpan>[
                                                    new TextSpan(text: 'Duration: '
                                                        ,style: new TextStyle(fontWeight: FontWeight.bold)),
                                                    new TextSpan(text: snapshot.data[index].leavefrom.toString()+snapshot.data[index].leaveto.toString(),style: TextStyle(color: Colors.grey[600]), ),

                                                  ],
                                                ),
                                              )
                                          ),*/
                                          snapshot.data[index].reason.toString()!='-'?Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            padding: EdgeInsets.only(top:1.5,bottom: .5),
                                            margin: EdgeInsets.only(top: 4.0),
                                            child: Text('Reason: '+snapshot.data[index].reason.toString(), style: TextStyle(color: Colors.black54),),
                                          ):Center(),





                                          snapshot.data[index].comment.toString() != '-' ? Container(
                                            width: MediaQuery .of(context).size .width * .90,
                                            padding: EdgeInsets.only( top: 0.0, bottom: 0.5),
                                            margin: EdgeInsets.only(top: 0.0),
                                            child: Text('Approver Comment: ' +  snapshot.data[index].comment.toString(),style: TextStyle(color: Colors.black54),),
                                          ): Center(),



                                          snapshot.data[index].approverstatus.toString()!='-'?Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            padding: EdgeInsets.only(top:.5,bottom: 1.5),
                                            margin: EdgeInsets.only(top: 1.0),
                                            child: RichText(
                                              text: new TextSpan(
                                                // Note: Styles for TextSpans must be explicitly defined.
                                                // Child text spans will inherit styles from parent
                                                style: new TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black,
                                                ),
                                                children: <TextSpan>[
                                                  new TextSpan(text: 'Status: ',style:TextStyle(color: Colors.black54,), ),
                                                  new TextSpan(text: snapshot.data[index].approverstatus.toString(), style: TextStyle(color: snapshot.data[index].approverstatus.toString()=='Approved'?appStartColor() :snapshot.data[index].approverstatus.toString()=='Rejected' || snapshot.data[index].approverstatus.toString()=='Cancel' ?Colors.red:snapshot.data[index].approverstatus.toString().startsWith('Pending')?Colors.orange[800]:Colors.blue[600], fontSize: 14.0),),
                                                ],
                                              ),
                                            ),
                                          ):Center(
                                            // child:Text(snapshot.data[index].withdrawlsts.toString()),
                                          ),

                                          Divider(color: Colors.grey,),
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
