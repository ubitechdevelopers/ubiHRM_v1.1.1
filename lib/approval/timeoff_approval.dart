
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'all_approvals.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
import '../model/model.dart';
import '../profile.dart';
import '../services/services.dart';
import '../services/timeoff_services.dart';


class TimeOffApp extends StatefulWidget {
  @override
  _TimeOffApp createState() => _TimeOffApp();
}


class _TimeOffApp extends State<TimeOffApp> {
  int idL;
  int _currentIndex = 0;
  var profileimage;
  bool showtabbar;
  String orgName="";


  bool _checkLoadedprofile = true;
  String empid;
  String organization;  String hrsts;
  var PerLeave;
  var PerApprovalLeave;
  Employee emp;
  void initState() {
    super.initState();
    initPlatformState();
    getOrgName();
    showtabbar=true;
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoadedprofile = false;
        });
      }
    }));
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
  }

  initPlatformState() async{
    final prefs = await SharedPreferences.getInstance();

    empid = prefs.getString('employeeid')??"";
    organization =prefs.getString('organization')??"";

    emp = new Employee(employeeid: empid, organization: organization);
    getAllPermission(emp);
  }
  @override
  Widget build(BuildContext context) {

    TextStyle label = new TextStyle(
      fontSize: 16.0, color: Colors.blue,
      //fontWeight: FontWeight.w500
      // color: 'red',

    );
    TextStyle unselectedLabel = new TextStyle(
      // fontWeight: FontWeight.w200
        fontSize: 15.0, color: Colors.white
    );
    //print(label);
    return MaterialApp(
      home: DefaultTabController(
        length: choices.length,
        child: RefreshIndicator(
          child: Scaffold(
            endDrawer: new AppDrawer(),
            appBar:new ApprovalAppHeader(profileimage,showtabbar,orgName),
            body: TabBarView(
              children: choices.map((Choice choice) {
                return Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ChoiceCard(choice: choice),
                );
              }).toList(),
            ),
            bottomNavigationBar:new HomeNavigation(),
          ),
          onRefresh: () async {
            Completer<Null> completer = new Completer<Null>();
            await Future.delayed(Duration(seconds: 1)).then((onvalue) {
              completer.complete();
            });
            return completer.future;
          },
        ),
      ),
    );
  }
}

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return  Scaffold(
      backgroundColor:scaffoldBackColor(),
      body: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              decoration: new ShapeDecoration(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                color: Colors.white,
              ),

              child:Column(
                  children: <Widget>[
                    Text('Time Off Applications',
                        style: new TextStyle(fontSize: 22.0, color: appStartColor())),
                    new Divider(height: 2,),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(height: 20.0,),
                        new Expanded(
                          child:   Container(
                            width: MediaQuery.of(context).size.width*0.22,
                            child:Text('    Name',style: TextStyle(color:  appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                          ),
                        ),

                        SizedBox(height: 30.0,),
                        new Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.30,
                            child:Text('      Applied on',style: TextStyle(color:  appStartColor(), fontWeight:FontWeight.bold,fontSize: 16.0),textAlign: TextAlign.center,),
                          ), ),
                      ],
                    ),

                    new Expanded(
                      child:Container(
                        height: MediaQuery.of(context).size.height*0.6,
                        child: new ListTile(
                          title:
                          Container( height: MediaQuery.of(context).size.height*.6,
                            width: MediaQuery.of(context).size.width*.99,
                            decoration: new ShapeDecoration(
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0),),
                              color: Colors.white,
                            ),//////////////////////////////////////////////////////////////////////---------------------------------
                            child: new FutureBuilder<List<TIMEOFFA>>(
                              future: getTimeoffapproval(choice.title),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if(snapshot.data.length>0) {
                                    return new ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return new Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                new Row(
                                                  children: <Widget>[
                                                   Container(
                                                        width: MediaQuery.of(context) .size.width * 0.50,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment  .start,
                                                          children: <Widget>[
                                                              Text(snapshot.data[index].name.toString(), style: TextStyle(
                                                                  color: Colors.black87,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 16.0),),
                                                            ],
                                                        ),
                                                      ),

                                                    Container(
                                                          width: MediaQuery .of(context)  .size.width * 0.30,
                                                          child: Column(
                                                            children: <Widget>[
                                                              Text(snapshot.data[index].applydate
                                                                  .toString()),
                                                            ],
                                                          )
                                                      ),
                                                    Divider(color: Colors.black54,),
                                                  ],
                                                ),

                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: MediaQuery.of(context).size.width*.55,
                                                      //padding: EdgeInsets.only(top:1.5,bottom: .5),
                                                      margin: EdgeInsets.only(top: 4.0),
                                                      child: RichText(
                                                        text: new TextSpan(
                                                          style: new TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                          ),
                                                          children: <TextSpan>[
                                                            new TextSpan(text: 'Time Off Date: ' ,style: new TextStyle()),
                                                            new TextSpan(text: snapshot.data[index].TimeofDate.toString(),style: TextStyle(color: Colors.grey[600])),
                                                          ],
                                                        ),
                                                      )
                                                    ),

                                                    snapshot.data[index].Timeoffsts.toString() == 'Pending' && snapshot.data[index].Psts.toString() == ""  ?
                                                    new Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                                                        child: Container(
                                                          child: new OutlineButton(
                                                            onPressed: () {
                                                              _modalBottomSheet(
                                                                  context, snapshot.data[index].Id.toString());
                                                            },
                                                            child: new Icon(
                                                              Icons.thumb_up,
                                                              size: 20.0,
                                                              color: appStartColor(),
                                                            ),
                                                            borderSide: BorderSide(color:  appStartColor()),
                                                            padding:EdgeInsets.all(3.0),
                                                            shape: new CircleBorder(),
                                                          ),
                                                        ),
                                                      ),
                                                    ): Center(),
                                                  ],
                                                ),

                                                new Row(
                                                  children: <Widget>[
                                                    Container(
                                                        //width: MediaQuery.of(context) .size .width * 0.70,
                                                        margin: EdgeInsets.only(top: 4.0),
                                                        child: RichText(
                                                          text: new TextSpan(
                                                            style: new TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors.black,
                                                            ),
                                                            children: <TextSpan>[
                                                              new TextSpan(
                                                                  text: 'Requested Duration: ',
                                                                  style: new TextStyle()),
                                                              new TextSpan(
                                                                text: snapshot.data[index].Fdate.toString()+" - "+snapshot.data[index].Tdate.toString(),style: TextStyle(color: Colors.grey[600]), ),
                                                            ],
                                                          ),
                                                        )
                                                    ),
                                                  ],),

                                                snapshot.data[index].Reason.toString() != '-' ? Container(
                                                    width: MediaQuery.of(context).size.width * .70,
                                                    margin: EdgeInsets.only(top: 4.0),
                                                    child: RichText(
                                                    overflow: TextOverflow.ellipsis,
                                                      text: new TextSpan(
                                                        style: new TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                        ),
                                                        children: <TextSpan>[
                                                          new TextSpan(text: 'Reason: ' ,style: new TextStyle()),
                                                          new TextSpan(text: snapshot.data[index].Reason.toString(),style: TextStyle(color: Colors.grey[600],)),
                                                        ],
                                                      ),
                                                    )
                                                ): Center(),

                                                snapshot.data[index].StartTimeFrom.toString()!='-'?Container(
                                                    //width: MediaQuery.of(context).size.width*.70,
                                                    //padding: EdgeInsets.only(top:1.5,bottom: 0.5),
                                                    margin: EdgeInsets.only(top: 4.0),
                                                    //child: Text('Actual Duration: '+snapshot.data[index].StartTimeFrom.toString()+' - '+snapshot.data[index].StopTimeTo.toString(), style: TextStyle(color: Colors.black54),),
                                                    child: Row(
                                                      children: <Widget>[
                                                        snapshot.data[index].StopTimeTo.toString()=='-'?Text('Actual Time Off Start: ', style: TextStyle(fontSize: 13.5,
                                                          color: Colors.black,),):Text('Actual Duration: ', style: TextStyle(fontSize: 13.5,
                                                          color: Colors.black,),),
                                                        RichText(
                                                            text: TextSpan(
                                                                children: [
                                                                  snapshot.data[index].StopTimeTo.toString()=='-'?
                                                                  TextSpan(
                                                                      text: snapshot.data[index].StartTimeFrom.toString(), style: TextStyle(color: Colors.black54)
                                                                  ) :
                                                                  TextSpan(
                                                                      text: snapshot.data[index].StartTimeFrom.toString()+' - '+snapshot.data[index].StopTimeTo.toString(), style: TextStyle(color: Colors.black54)
                                                                  )
                                                                ]
                                                            )
                                                        ),
                                                      ],
                                                    )
                                                ):Center(),

                                                Container(
                                                  //width: MediaQuery.of(context).size.width*.70,
                                                  //padding: EdgeInsets.only(top:1.5,bottom: 0.5),
                                                  margin: EdgeInsets.only(top: 4.0),
                                                  child: RichText(
                                                    text: new TextSpan(
                                                      style: new TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                      ),
                                                      children: <TextSpan>[
                                                        new TextSpan(text: 'Time Off Status: ' ,style: new TextStyle()),
                                                        new TextSpan(text: snapshot.data[index].TimeOffSts.toString(),style: TextStyle(color: Colors.grey[600])),
                                                      ],
                                                    ),
                                                  )
                                                ),

                                                snapshot.data[index].Psts.toString()!=''?Container(
                                                  //width: MediaQuery.of(context).size.width*.70,
                                                  margin: EdgeInsets.only(top: 4.0),
                                                  child: RichText(
                                                    text: new TextSpan(
                                                      style: new TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                      ),
                                                      children: <TextSpan>[
                                                        new TextSpan(text: 'Approval Status: ',style: new TextStyle()),
                                                        new TextSpan(text: ""+snapshot.data[index].Psts.toString(),style: TextStyle(color: Colors.orange[800]),),
                                                      ],
                                                    ),
                                                  ),
                                                ):Center(),

                                                snapshot.data[index].ApproverComment.toString()!='-'?Container(
                                                  //width: MediaQuery.of(context).size.width*.70,
                                                  margin: EdgeInsets.only(top: 4.0),
                                                    child: RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      text: new TextSpan(
                                                        style: new TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                        ),
                                                        children: <TextSpan>[
                                                          new TextSpan(text: 'Comment: ' ,style: new TextStyle()),
                                                          new TextSpan(text: snapshot.data[index].ApproverComment.toString(),style: TextStyle(color: Colors.grey[600],)),
                                                        ],
                                                      ),
                                                    )
                                                ):Center(),
                                                Divider(color: Colors.black45,),
                                              ] );
                                        }
                                    );
                                  }else{
                                    return new Center(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width*2,
                                        color: appStartColor().withOpacity(0.1),
                                        padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                        child:Text("No Records",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                                      ),
                                    );
                                  }
                                } else if (snapshot.hasError) {
                                  return new Text("Unable to connect server");
                                }
                                // By default, show a loading spinner
                                return new Center(child: CircularProgressIndicator());
                              },
                            ),
                            //////////////////////////////////////////////////////////////////////---------------------------------
                          ),
                        ),

                      ),
                    ),
                  ]),
            ),
          ]
      ),
    );

  }

  _modalBottomSheet(context,String timeoffid) async{

    final FocusNode myFocusNodeComment = FocusNode();
    TextEditingController CommentController = new TextEditingController();

    showRoundedModalBottomSheet(
        context: context,
        color:Colors.grey[100],
        builder: (BuildContext bc){
          return new  Container(
            height: 200.0,
            child: new Container(
              decoration: new BoxDecoration(
                  color: appStartColor().withOpacity(0.1),
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(0.0),
                      topRight: const Radius.circular(0.0))),
              alignment: Alignment.topCenter,
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20.0, bottom: 20.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      focusNode: myFocusNodeComment,
                      controller: CommentController,
                      keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (String value) {
                        FocusScope.of(context).requestFocus(myFocusNodeComment);
                      },
                      style: TextStyle(
                          fontFamily: "WorkSansSemiBold",
                          fontSize: 16.0,
                          height: 1.0,
                          color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white, filled: true,
                        hintText: "Comment",
                        hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold", fontSize: 15.0),
                      ),
                      maxLines: 3,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 0.0, left: 60.0, right: 15.0),
                        child:  ButtonTheme(
                          minWidth: 50.0,
                          height: 40.0,

                          child: OutlineButton(
                            onPressed: () async  {
                              //getApprovals(choice.title);
                              final sts= await ApproveTimeoff(timeoffid,CommentController.text,2);
                              //  print("kk");
                              // print("kk"+sts);
                              if(sts=="true") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TimeOffApp()),
                                );
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    Future.delayed(Duration(seconds: 3), () {
                                      Navigator.of(context).pop(true);
                                    });
                                    return AlertDialog(
                                      content: new Text("Time Off application approved successfully."),
                                    );
                                  });
                                /*showDialog(
                                    context: context,
                                    builder: (_) =>
                                    new AlertDialog(
                                      //title: new Text("Dialog Title"),
                                      content: new Text("Time Off application approved successfully."),
                                    )
                                );*/
                              }else{
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TimeOffApp()),
                                );
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    Future.delayed(Duration(seconds: 3), () {
                                      Navigator.of(context).pop(true);
                                    });
                                    return AlertDialog(
                                      content: new Text("Time Off application could not be approved."),
                                    );
                                  });
                                /*showDialog(
                                    context: context,
                                    builder: (_) =>
                                    new AlertDialog(
                                      //title: new Text("Dialog Title"),
                                      content: new Text("Time Off application could not be approved."),
                                    )
                                );*/
                              }

                              },
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0)),
                            child: new Text('Approve',
                                style: new TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                )),borderSide: BorderSide(color:Colors.green[700]),

                          ),
                        ),),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 0.0, left: 15.0, right: 60.0),
                        child:  ButtonTheme(
                          minWidth: 50.0,
                          height: 40.0,
                          child: OutlineButton(
                              onPressed: () async {
                                //getApprovals(choice.title);
                                var sts = await ApproveTimeoff(timeoffid,CommentController.text,1);
                                if(sts=="true") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => TimeOffApp()),
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 3), () {
                                        Navigator.of(context).pop(true);
                                      });
                                      return AlertDialog(
                                        content: new Text("Time Off application rejected successfully."),
                                      );
                                    });
                                  /*showDialog(
                                      context: context,
                                      builder: (_) =>
                                      new AlertDialog(
                                        //title: new Text("Dialog Title"),
                                        content: new Text("Time Off application rejected successfully."),
                                      )
                                  );*/
                                }else{
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => TimeOffApp()),
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 3), () {
                                        Navigator.of(context).pop(true);
                                      });
                                      return AlertDialog(
                                        content: new Text("Time Off application could not be rejected."),
                                      );
                                    });
                                  /*showDialog(
                                      context: context,
                                      builder: (_) =>
                                      new AlertDialog(
                                        //title: new Text("Dialog Title"),
                                        content: new Text("Time Off application could not be rejected."),
                                      )
                                  );*/
                                }
                                },

                              child: new Text('Reject',
                                  style: new TextStyle(
                                      color: Colors.red[700],
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),borderSide: BorderSide(color: Colors.red[700]),
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0))
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );

        }
    );

  }
}


class ApprovalAppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;
  ApprovalAppHeader(profileimage1,showtabbar1,orgname1){
    profileimage = profileimage1;
    orgname = orgname1;
    if (profileimage!=null) {
      _checkLoadedprofile = false;
    };
    showtabbar= showtabbar1;
  }

  @override
  Widget build(BuildContext context) {
    return new GradientAppBar(
        backgroundColorStart: appStartColor(),
        backgroundColorEnd: appEndColor(),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(icon:Icon(Icons.arrow_back),
              onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllApprovals()),
                );
              },),
            GestureDetector(
              // When the child is tapped, show a snackbar
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CollapsingTab()),
                );
              },
              child:Container(

                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        // image: AssetImage('assets/avatar.png'),
                        image: _checkLoadedprofile ? AssetImage('assets/default.png') : profileimage,
                      )
                  )
              ),
            ),
            Flexible(
              child: Container(
                  padding: const EdgeInsets.all(8.0), child: Text(orgname,overflow: TextOverflow.ellipsis)
              ),
            )
          ],
        ),
        bottom:
        showtabbar==true ? TabBar(
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: choices.map((Choice choice) {
            return Tab(
              text: choice.title,
              //   unselectedLabelColor: Colors.white70,
              //   indicatorColor: Colors.white,
              //   icon: Icon(choice.icon),
            );
          }).toList(),
        ):null
    );
  }
  @override
  Size get preferredSize => new Size.fromHeight(showtabbar==true ? 100.0 : 60.0);

}
