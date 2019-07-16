import 'package:flutter/material.dart';
import '../drawer.dart';
import '../graphs.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import '../global.dart';
import '../services/leave_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_page.dart';
import '../model/model.dart';
import 'myleave.dart';
import 'approval.dart';
import '../home.dart';
import '../profile.dart';
//import 'bottom_navigationbar.dart';
import '../b_navigationbar.dart';
import '../appbar.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class MyTeamLeave extends StatefulWidget {
  @override
  _MyTeamLeaveState createState() => _MyTeamLeaveState();
}

class _MyTeamLeaveState extends State<MyTeamLeave> {
  int _currentIndex = 0;
  int response;
  var profileimage;
  bool showtabbar ;
  String orgName="";

  bool _checkLoadedprofile = true;
  bool _checkwithdrawnleave = false;
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
    getOrgName();
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
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
        appBar: new AppHeader(profileimage,showtabbar,orgName),
        bottomNavigationBar:new HomeNavigation(),
        body:   homewidget()
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

            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex:48,
                          child:Column(
                              children: <Widget>[
                                // width: double.infinity,
                                //height: MediaQuery.of(context).size.height * .07,
                                SizedBox(height:MediaQuery.of(context).size.width*.02),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                          Icons.person,
                                          color: Colors.orange,
                                          size: 22.0 ),

                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => MyLeave()),
                                          );

                                        },
                                        child: const Text(
                                            'Self',
                                            style: TextStyle(fontSize: 18,color: Colors.orange,)
                                        ),
                                        // color: Colors.teal[50],
                                        /* splashColor: Colors.white,
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(0.0))*/
                                      ),
                                    ]
                                ),
                                SizedBox(height:MediaQuery.of(context).size.width*.03),
                              ]
                          ),
                        ),

                        Expanded(
                          flex:48,
                          child: Column(
                            // width: double.infinity,
                              children: <Widget>[
                                SizedBox(height:MediaQuery.of(context).size.width*.02),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                          Icons.group,
                                          color: Colors.orange,
                                          size: 22.0 ),
                                      GestureDetector(
                                        onTap: () {
                                          /* Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MyTeamAtt()),
                                  );*/
                                          false;
                                        },
                                        child: const Text(
                                            'Team',
                                            style: TextStyle(fontSize: 18,color: Colors.orange,fontWeight:FontWeight.bold)
                                        ),
                                        //color: Colors.teal[50],

                                        /* splashColor: Colors.white,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(0.0),

                                  /* side: BorderSide(
                                        color: Colors.blue,
                                        width: 1,

                                        style: BorderStyle.solid
                                    )*/
                                )*/
                                      ),
                                    ]),
                                SizedBox(height:MediaQuery.of(context).size.width*.03),
                                Divider(
                                  color: Colors.orange,
                                  height: 0.4,
                                ),
                                Divider(
                                  color: Colors.orange,
                                  height: 0.4,
                                ),
                                Divider(
                                  color: Colors.orange,
                                  height: 0.4,
                                ),
                              ]
                          ),
                        ),
                      ]
                  ),

                  Container(
                    padding: EdgeInsets.only(top:12.0),
                    child:Center(
                      child:Text('My Team Leave',
                          style: new TextStyle(fontSize: 18.0, color: Colors.black87,)),
                    ),
                  ),

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
                      child: new FutureBuilder<List<LeaveA>>(
                        future: getTeamApprovals(),
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
                                                        new Text(snapshot.data[index].applydate.toString(), style: TextStyle(fontWeight: FontWeight.bold),)
                                                      ],
                                                    )
                                                ),
                                              ),

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
                                                        new TextSpan(text: snapshot.data[index].Fdate.toString()+snapshot.data[index].Tdate.toString() +"  ",style: TextStyle(color: Colors.grey[600]), ),

                                                      ],
                                                    ),
                                                  )
                                              ),

                                              /*             new Expanded(
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
                                                            "Rejected") ? new Container(
                                                            height: 30.5,
                                                            margin: EdgeInsets.only(
                                                                left:25.0),
                                                            child: new OutlineButton(
                                                              child:new Icon(Icons.replay, size: 18.0,color:appStartColor(), ),
                                                              borderSide: BorderSide(color:appStartColor()),

                                                              //  color: Colors.orangeAccent,
                                                              onPressed: () {
                                                               *//* confirmWithdrawl(
                                                                    snapshot.data[index].leaveid.toString());*//*
                                                                },
                                                              shape: new CircleBorder(),
                                                            )
                                                        ) : Center()
                                                      ],
                                                    )
                                                ),
                                              ),*/
                                            ],
                                          ),

                                          snapshot.data[index].Reason.toString()!='-'?Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            padding: EdgeInsets.only(top:1.5,bottom: .5),
                                            margin: EdgeInsets.only(top: 4.0),
                                            child: Text('Reason: '+snapshot.data[index].Reason.toString(), style: TextStyle(color: Colors.black54),),
                                          ):Center(),

                                          /* snapshot.data[index].comment.toString() != '-' ? Container(
                                            width: MediaQuery .of(context).size .width * .90,
                                            padding: EdgeInsets.only( top: 0.0, bottom: 0.5),
                                            margin: EdgeInsets.only(top: 0.0),
                                            child: Text('Approver Comment: ' +  snapshot.data[index].comment.toString(),style: TextStyle(color: Colors.black54),),
                                          ): Center(),*/

                                          snapshot.data[index].Leavests.toString()!='-'?Container(
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
                                                  new TextSpan(text: snapshot.data[index].Leavests.toString(), style: TextStyle(color: snapshot.data[index].Leavests.toString()=='Approved'?appStartColor() :snapshot.data[index].Leavests.toString()=='Rejected' || snapshot.data[index].Leavests.toString()=='Cancel' ?Colors.red:snapshot.data[index].Leavests
                                                      .toString().startsWith('Pending')?Colors.orange[800]:Colors.blue[600], fontSize: 14.0),),
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
                              return new Center( child: Text('No Leave History'), );
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


                ]
            )

        ),



      ],
    );
  }



}
