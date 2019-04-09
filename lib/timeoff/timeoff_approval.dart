
import 'package:flutter/material.dart';
import '../global.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import '../home.dart';
import '../services/services.dart';
import '../services/leave_services.dart';
import 'timeoff_summary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/model.dart';
import 'package:rounded_modal/rounded_modal.dart';
import '../profile.dart';
//import 'bottom_navigationbar.dart';
import '../b_navigationbar.dart';
import '../appbar.dart';
import '../drawer.dart';
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
  bool _checkLoadedprofile = true;
  String empid;
  String organization;  String hrsts;
  var PerLeave;
  var PerApprovalLeave;
  Employee emp;
  void initState() {
    super.initState();
    initPlatformState();
    showtabbar=true;
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    profileimage.resolve(new ImageConfiguration()).addListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoadedprofile = false;
        });

      }
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

        child: Scaffold(
          endDrawer: new AppDrawer(),
           appBar:new AppHeader(profileimage,showtabbar),
 /*         appBar:PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: GradientAppBar(

              backgroundColorStart: appStartColor(),
              backgroundColorEnd: appEndColor(),

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
                    child:Container(
                        width: 45.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              //image: AssetImage('assets/avatar.png'),
                              image: _checkLoadedprofile ? AssetImage('assets/avatar.png') : profileimage,
                            )
                        )),),
                  Container(
                      padding: const EdgeInsets.all(2.0), child: Text('Timeoff Approval')
                  )
                ],

              ),



              actions:  <Widget>[
                perA=='1'?    new DropdownButton<String>(
                  hint: new Text("My Approvals" , style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  )),
                  items: <String>['My Approvals', 'My Timeoff'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),

                    );
                  }).toList(),

                  onChanged: (value) {
                    value=value;
                    switch(value) {
                      case "My Timeoff" :
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TimeoffSummary()),
                        );
                        break;
                      case "My Approvals" :
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TimeOffApp()),
                        );
                        break;
                    }
                  },
                ):Center(),


              ],


              bottom: TabBar(
                labelStyle: label,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                unselectedLabelStyle: unselectedLabel,
                isScrollable: true,
                tabs: choices.map((Choice choice) {
                  return Tab(

                    text: choice.title,
                    // icon: Icon(choice.icon),
                  );
                }).toList(),
              ),
            ),),*/



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
      ),
    );
  }
}


/*class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Approved'),
  const Choice(title: 'Pending'),
  const Choice(title: 'Rejected'),
  // const Choice(title: 'REJECTED', icon: Icons.directions_boat),

];*/

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {

    final TextStyle textStyle = Theme.of(context).textTheme.display1;

    return  Scaffold(
      backgroundColor:scaffoldBackColor(),
      body: Stack(
        // color: Colors.white,
          children: <Widget>[
            Container(
              // color: Colors.white,
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              //width: MediaQuery.of(context).size.width*0.9,
              decoration: new ShapeDecoration(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                color: Colors.white,
              ),

              // child: Center(
              child:Column(
                  children: <Widget>[
                    Text('Time off Applications',
                        style: new TextStyle(fontSize: 22.0, color: appStartColor())),
                    new Divider(color: Colors.black54,height: 1.5,),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // headingColor(),
                        SizedBox(height: 20.0,),
                        new Expanded(
                          child:   Container(

                            width: MediaQuery.of(context).size.width*0.22,
                            child:Text('    Name',style: TextStyle(color:  appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                          ),
                        ),
                        /*SizedBox(height: 30.0,),
                        new Expanded(
                          child: Container(
                            color: Colors.green,

                            width: MediaQuery.of(context).size.width*0.30,
                            child:Text(' ',style: TextStyle(color:  appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                          ), ),*/

                        SizedBox(height: 30.0,),
                        new Expanded(
                          child: Container(

                            width: MediaQuery.of(context).size.width*0.30,
                            child:Text('Applied on',style: TextStyle(color:  appStartColor(), fontWeight:FontWeight.bold,fontSize: 16.0),textAlign: TextAlign.center,),
                          ), ),

                      ],
                    ),



                    new Expanded(
                      child:Container(

                        // margin: const EdgeInsets.only(top: 55.0),
                        //  margin: EdgeInsets.fromLTRB(0.0, 55.0, 0.0, 0.0),
                        height: MediaQuery.of(context).size.height*0.6,
                        //   shape: Border.all(color: Colors.deepOrange),
                        child: new ListTile(
                          title:
                          Container( height: MediaQuery.of(context).size.height*.6,
                            width: MediaQuery.of(context).size.width*.99,
                            // color: Colors.white,
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
                                                  mainAxisAlignment: MainAxisAlignment .spaceAround,
                                                  children: <Widget>[
                                                    SizedBox(height: 40.0,),
                                                    new Expanded(

                                                      child: Container(
                                                        width: MediaQuery.of(context) .size.width * 0.90,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment  .start,
                                                          children: <Widget>[
                                                            GestureDetector(
                                                              // When the child is tapped, show a snackbar
                                                              onTap: () {
                                                                //  final snackBar = SnackBar(content: Text("Tap"));

                                                                //Scaffold.of(context).showSnackBar(snackBar);


                                                              },
                                                              child:   Text(snapshot.data[index].name.toString(), style: TextStyle(
                                                                  color: Colors.black87,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 16.0),),
                                                            ), ],
                                                        ),
                                                      ),  ),

                                                    new Expanded(
                                                      child:Container(

                                                          width: MediaQuery .of(context)  .size.width * 0.50,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment .center,
                                                            children: <Widget>[
                                                              Text("    "+snapshot.data[index].applydate
                                                                  .toString()),
                                                            ],
                                                          )

                                                      ),),

                                                    Divider(color: Colors.black26,),
                                                  ],

                                                ),



                                                new Row(
                                                  // mainAxisAlignment: MainAxisAlignment .spaceAround,
                                                  children: <Widget>[
                                                    //   SizedBox(height: 10.0,),

                                                    Container(
                                                        width: MediaQuery.of(context) .size .width * 0.70,
                                                        height: 10.0,
                                                        padding: const EdgeInsets.all(0.0),
                                                        child: RichText(
                                                          text: new TextSpan(
                                                            style: new TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors.black,
                                                            ),
                                                            children: <TextSpan>[
                                                              new TextSpan(
                                                                  text: 'Duration: ',
                                                                  style: new TextStyle()),
                                                              new TextSpan(
                                                                text: snapshot.data[index].Fdate.toString()+snapshot.data[index].Tdate.toString(),style: TextStyle(color: Colors.grey[600]), ),
                                                              /*   new TextSpan(text: " Days: "+snapshot.data[index].Ldays.toString(),style: TextStyle(color: Colors.black), ),*/
                                                            ],
                                                          ),
                                                        )


                                                    ),
                                                    snapshot.data[index].Timeoffsts.toString() == 'Pending'
                                                        && snapshot.data[index].Psts.toString() == ""  ?

                                                    new Expanded(

                                                      child: Container(

                                                        width: MediaQuery.of(context) .size .width * 0.30,
                                                        height: 28.0,
                                                        child: new OutlineButton(
                                                          onPressed: () {
                                                            //  confirmApprove(context,snapshot.data[index].Id.toString());
                                                        //    if(snapshot.data[index].HRSts.toString()=='1') {
                                                              /*   _modalBottomSheetHR(
                                                                  context, snapshot.data[index].Id.toString(),snapshot.data[index].Ldays.toString(),snapshot.data[index].LeaveTypeId.toString());
                                                           */   //getleavehistory(snapshot.data[index].LeaveTypeId.toString());
                                                        //    }else{
                                                                  _modalBottomSheet(
                                                                  context, snapshot.data[index].Id.toString());
                                                         //  }
                                                          },
                                                          child: new Icon(
                                                            Icons.thumb_up,
                                                            size: 17.0,
                                                            color: appStartColor(),
                                                          ),
                                                          borderSide: BorderSide(color:  appStartColor()),
                                                          padding:EdgeInsets.all(3.0),
                                                          shape: new CircleBorder(),
                                                        ),
                                                      ),
                                                    ): Center(),

                                                  ],),

                                                snapshot.data[index].Reason.toString() != '-'
                                                    ? Container(
                                                    width: MediaQuery.of(context).size.width * .90,
                                                    padding: EdgeInsets.only(top: 1.5),
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
                                                          new TextSpan(text: 'Reason: ' ,style: new TextStyle()),
                                                          new TextSpan(text: snapshot.data[index].Reason.toString(),style: TextStyle(color: Colors.grey[600])),

                                                        ],
                                                      ),
                                                    )
                                                ): Center(),

                                                snapshot.data[index].Psts.toString()!=''?Container(
                                                  width: MediaQuery.of(context).size.width*.90,
                                                  padding: EdgeInsets.only(top:1.5,bottom: .5),
                                                  margin: EdgeInsets.only(top: .5),
                                                  child: RichText(
                                                    text: new TextSpan(
                                                      // Note: Styles for TextSpans must be explicitly defined.
                                                      // Child text spans will inherit styles from parent
                                                      style: new TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                      ),
                                                      children: <TextSpan>[
                                                        new TextSpan(text: 'Status: ',style: new TextStyle()),
                                                        new TextSpan(text: ""+snapshot.data[index].Psts.toString(),style: TextStyle(color: Colors.orange[800]),),
                                                      ],
                                                    ),
                                                  ),
                                                ):Center(
                                                  // child:Text(snapshot.data[index].withdrawlsts.toString()),
                                                ),

                                                Divider(color: Colors.black45,),
                                              ] );
                                        }
                                    );
                                  }else{
                                    return new Center(
                                      child:Text("No Records"),
                                    );
                                  }
                                }
                                else if (snapshot.hasError) {
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
              /*child: Column(



          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),*/
              //),


            ),



          ]
      ),
    );

  }



/*

  _modalBottomSheetHR(context,String leaveid,days,leavetypeid) async{

    final FocusNode myFocusNodeComment = FocusNode();
    final FocusNode myFocusNodeEntitle = FocusNode();
    final FocusNode myFocusNodeLOP = FocusNode();
    final FocusNode myFocusNodeCF = FocusNode();
    final FocusNode myFocusNodeAD= FocusNode();

    TextEditingController CommentController = new TextEditingController();
    TextEditingController EntitleController = new TextEditingController(text:days);
    TextEditingController LOPController = new TextEditingController();
    TextEditingController CFController = new TextEditingController();
    TextEditingController  ADController = new TextEditingController();


    showRoundedModalBottomSheet(
        context: context,
        //  radius: 190.0,
        //   radius: 190.0, // This is the default
        // color:Colors.lightGreen.withOpacity(0.9),
        color:Colors.grey[300],
        //   color:Colors.cyan[200].withOpacity(0.7),
        builder: (BuildContext bc){
          return new  Container(
            // padding: MediaQuery.of(context).viewInsets,
            //duration: const Duration(milliseconds: 100),
            // curve: Curves.decelerate,

            // child: new Expanded(
            //height: MediaQuery.of(context).size.height-100.0,
            height: 400.0,
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.teal.withOpacity(0.05),
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(0.0),
                      topRight: const Radius.circular(0.0))),
              alignment: Alignment.topCenter,
              child: Wrap(
                children: <Widget>[
                  /*    Padding(
                            padding: EdgeInsets.only(
                                top: 10.0, bottom: 10.0, left: 30.0, right: 30.0),
                            child:  ButtonTheme(
                              minWidth: 300.0,
                              height: 30.0,
                              child: RaisedButton(
                              onPressed: () {
                             showDialog(context: context,builder: (context) => _onTapImage(leavetypeid));
                                   },
                                color: Colors.white,
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)),
                                child: new Text('Leave History',
                                    style: new TextStyle(
                                      color: Colors.green,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),),*/
                  Padding(
                    padding: EdgeInsets.only(
                        top: 5.0, bottom: 0.0, left: 40.0, right: 50.0),
                    child:
                    Container(
                      height: MediaQuery.of(context).size.height*.1,
                      //width: MediaQuery.of(context).size.width*.99,

                      //decoration: new ShapeDecoration(
                      // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),),
                      color: Colors.transparent,
                      //  ),

                      child:  FutureBuilder<List<LeaveH>>(
                          future: getleavehistory(leavetypeid),
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
                                            new Container(
                                              width: MediaQuery.of(context).size.width * .99,

                                              child:Text("Leave History",style:TextStyle(
                                                // fontFamily: "WorkSansSemiBold",
                                                  fontSize: 18.0,
                                                  color: Colors.green), textAlign: TextAlign.center,                                           ),
                                            ),
                                            Divider(color: Colors.black26,),
                                            new Container(
                                                width: MediaQuery.of(context).size.width * .99,
                                                padding: EdgeInsets.only(
                                                  left: 12.0,),
                                                child: Row(
                                                    children: <Widget>[
                                                      new Expanded(
                                                          child: Container(width: MediaQuery.of(context).size.width * 0.07,
                                                            child: Text("Leave Type: "+snapshot.data[index].name .toString(),                                             style: TextStyle( color: Colors.black,                                                      fontSize: 16.0),),
                                                          )),  ] )),
                                            new Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[

                                                SizedBox(height: 10.0,),
                                                new Expanded(
                                                  child: Container( width: MediaQuery.of(context).size.width * 0.05,
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment .center,
                                                        children: <Widget>[
                                                          new Text("Entitle: "+snapshot.data[index].Entitle .toString(), style: TextStyle( color: Colors.black54, fontSize: 16.0),),
                                                          // shape: new CircleBorder(),
                                                          // borderSide: BorderSide(color: Colors.green),
                                                        ] ),


                                                  ),  ),

                                                new Expanded(
                                                  child:Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.10,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .center,
                                                        children: <Widget>[
                                                          Text("Used: "+snapshot.data[index].Used
                                                              .toString(), style: TextStyle( color: Colors.black54, fontSize: 16.0,),),
                                                        ],
                                                      )

                                                  ),),
                                                new Expanded(
                                                  child:Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.10,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .center,
                                                        children: <Widget>[
                                                          Text("Left: "+snapshot.data[index].Left
                                                              .toString(), style: TextStyle( color: Colors.black54, fontSize: 16.0),),
                                                        ],
                                                      )

                                                  ),),

                                                /*  new Expanded(
                                  child:Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.18,
                                      decoration: new ShapeDecoration(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius: new BorderRadius
                                                .circular(2.0)),
                                        color: snapshot.data[index].Leavests ==
                                            'Approved' ? Colors.green
                                            .withOpacity(0.75) : snapshot                                                    .data[index].Leavests
                                            .toString() == 'Rejected'  ? Colors
                                            .red.withOpacity(0.65) : snapshot                                                  .data[index].Leavests
                                            .toString().startsWith('Pending')
                                            ? Colors.orangeAccent
                                            : Colors.black12,
                                      ),


                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          Text(snapshot.data[index].Leavests
                                              .toString(),style: TextStyle(color: Colors.white),),
                                        ],
                                      )

                                  ),),*/
                                                Divider(color: Colors.black26,),
                                              ],

                                            ),  ] );
                                    }
                                );
                              }else{
                                return new Center(
                                  child:Text("No Records"),
                                );
                              }
                            }
                            else if (snapshot.hasError) {
                              return new Text("Unable to connect server");
                            }

                            // By default, show a loading spinner
                            return new Center(child: CircularProgressIndicator());
                          }
                      ),  ),),


                  Divider(color: Colors.black45,),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 20.0, left: 40.0, right: 50.0),
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
                          color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white, filled: true,
                        /* icon: Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 22.0,
                        ),*/
                        hintText: "Comment",
                        hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold", fontSize: 15.0),
                        suffixIcon: GestureDetector(
                          //onTap: _toggleLogin,
                          child: Icon(
                            Icons.edit,
                            size: 15.0,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      /*validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Email or Phone no.';
                            }
                          },*/

                    ),
                  ),
                  //if the user is hr////

                  new Wrap(children: <Widget>[

                    new Divider(color: Colors.black54, height: 1.5,),
                    new Container(
                      margin: const EdgeInsets.only(left: 50.0),
                      width: 120.0,
                      child: new TextFormField(
                        decoration: new InputDecoration(labelText: "Entitled"),
                        keyboardType: TextInputType.text,
                        focusNode: myFocusNodeEntitle,
                        controller: EntitleController,
                        // initialValue: "days",
                        onFieldSubmitted: (String value) {
                          FocusScope.of(context).requestFocus(myFocusNodeEntitle);
                        },
                      ),
                    ),

                    new Container(
                      margin: const EdgeInsets.only(left: 40.0),
                      width: 100.0,
                      child: new TextFormField(
                        decoration: new InputDecoration(labelText: "LOP"),
                        keyboardType: TextInputType.text,
                        focusNode: myFocusNodeLOP,
                        controller: LOPController,

                        onFieldSubmitted: (String value) {
                          FocusScope.of(context).requestFocus(myFocusNodeLOP);
                        },

                      ),
                    ),

                    new Container(
                      margin: const EdgeInsets.only(left: 50.0),
                      width: 120.0,
                      child: new TextFormField(
                        decoration: new InputDecoration(labelText: "Carried Forward"),
                        keyboardType: TextInputType.text,
                        focusNode: myFocusNodeCF,
                        controller: CFController,
                        onFieldSubmitted: (String value) {
                          FocusScope.of(context).requestFocus(myFocusNodeCF);
                        },
                      ),
                    ),

                    new Container(
                      margin: const EdgeInsets.only(left: 40.0),
                      width: 100.0,
                      child: new TextFormField(
                        decoration: new InputDecoration(labelText: "Advance"),
                        keyboardType: TextInputType.text,
                        focusNode: myFocusNodeAD,
                        controller: ADController,
                        onFieldSubmitted: (String value) {
                          FocusScope.of(context).requestFocus(myFocusNodeAD);
                        },
                      ),
                    ),
                  ])
                  ,
                  Row(
                      children: <Widget>[
                        new Expanded(
                          child:Container(
                            padding: EdgeInsets.only(
                                top: 10.0, bottom: 10.0, left: 30.0, right: 30.0),
                            child:  ButtonTheme(
                              minWidth: 120.0,
                              height: 40.0,
                              child: RaisedButton(
                                onPressed: () async {
                                  if(EntitleController.text==""){
                                    EntitleController.text="0";
                                  } if(LOPController.text==""){
                                    LOPController.text="0";
                                  } if(CFController.text==""){
                                    CFController.text="0";
                                  } if(ADController.text==""){
                                    ADController.text="0";
                                  }
                                  var LBD=EntitleController.text+","+LOPController.text+","+CFController.text+","+ADController.text;
                                  print(LBD);
                                  //getApprovals(choice.title);
                                  var sts= await ApproveLeaveByHr(leaveid,CommentController.text,2,LBD);

                                  if(sts=="true") {
                                    showDialog(
                                        context: context,
                                        builder: (_) =>
                                        new AlertDialog(
                                          //title: new Text("Dialog Title"),
                                          content: new Text("Approved succesfully."),
                                        )
                                    );
                                  }else{
                                    showDialog(
                                        context: context,
                                        builder: (_) =>
                                        new AlertDialog(
                                          //title: new Text("Dialog Title"),
                                          content: new Text("Some error."),
                                        )
                                    );
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => TabbedApp()),
                                  ); },
                                color: Colors.green,
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)),
                                child: new Text('Approve',
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),),),
                        new Expanded(
                          child:Container(

                            padding: EdgeInsets.only(
                                top: 10.0, bottom: 10.0, left: 30.0, right: 30.0),
                            child:  ButtonTheme(
                              minWidth: 120.0,
                              height: 40.0,
                              child: RaisedButton(
                                onPressed: () async
                                {
                                  //getApprovals(choice.title);
                                  var sts= await ApproveLeave(leaveid, CommentController.text, 1);
                                  if(sts=="true"){
                                    showDialog(
                                        context
                                            : context,
                                        builder: (_) => new
                                        AlertDialog(
                                          //title: new Text("Dialog Title"),
                                          content: new Text("Rejected succesfully."
                                          ),
                                        )
                                    );
                                  }
                                  else{
                                    showDialog(
                                        context
                                            : context,
                                        builder: (_) => new
                                        AlertDialog(
                                          //title: new Text("Dialog Title"),
                                          content: new Text("Some error."
                                          ),
                                        )
                                    );
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => TabbedApp()),
                                  );   },
                                color: Colors.red,
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)),
                                child: new Text('Reject',
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),),
                      ]),
                ],
              ),
            ),
          );

        }
    );
  }
*/




  _modalBottomSheet(context,String timeoffid) async{

    final FocusNode myFocusNodeComment = FocusNode();
    TextEditingController CommentController = new TextEditingController();

    showRoundedModalBottomSheet(
        context: context,
        //  radius: 190.0,
        //   radius: 190.0, // This is the default
        // color:Colors.lightGreen.withOpacity(0.9),
        color:Colors.grey[100],
        //   color:Colors.cyan[200].withOpacity(0.7),
        builder: (BuildContext bc){
          return new  Container(
            // padding: MediaQuery.of(context).viewInsets,
            //duration: const Duration(milliseconds: 100),
            // curve: Curves.decelerate,

            // child: new Expanded(
            //height: MediaQuery.of(context).size.height-100.0,
            height: 400.0,
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(0.0),
                      topRight: const Radius.circular(0.0))),


              alignment: Alignment.topCenter,
              child: Wrap(
                children: <Widget>[
                  /*    new Container(
                    width: MediaQuery.of(context).size.width * .20,
                    child:Text(psts,style:TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 18.0,
                        color: Colors.black)),

                  ),
                  Divider(color: Colors.black45,),*/
                  Padding(
                    padding: EdgeInsets.only(
                        top: 80.0, bottom: 20.0, left: 40.0, right: 50.0),
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
                          color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white, filled: true,
                        /* icon: Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 22.0,
                        ),*/
                        hintText: "Comment",
                        hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold", fontSize: 15.0),
                        suffixIcon: GestureDetector(
                          //onTap: _toggleLogin,
                          child: Icon(
                            Icons.edit,
                            size: 15.0,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      /*validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Email or Phone no.';
                            }
                          },*/

                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 30.0, right: 30.0),
                    child:  ButtonTheme(
                      minWidth: 300.0,
                      height: 40.0,
                      child: RaisedButton(
                        onPressed: () async  {
                          //getApprovals(choice.title);
                          final sts= await ApproveTimeoff(timeoffid,CommentController.text,2);
                          //  print("kk");
                          // print("kk"+sts);
                          if(sts=="true") {
                            showDialog(
                                context: context,
                                builder: (_) =>
                                new AlertDialog(
                                  //title: new Text("Dialog Title"),
                                  content: new Text("Approved"),
                                )
                            );
                          }
                          else{
                            showDialog(
                                context: context,
                                builder: (_) =>
                                new AlertDialog(
                                  //title: new Text("Dialog Title"),
                                  content: new Text("Could not be approved. Try again."),
                                )
                            );
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TimeOffApp()),
                          ); },
                        color: Colors.green,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: new Text('Approve',
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 0.0, left: 30.0, right: 30.0),
                    child:  ButtonTheme(
                      minWidth: 300.0,
                      height: 40.0,
                      child: RaisedButton(
                        onPressed: () async {
                          //getApprovals(choice.title);
                          var sts = await ApproveTimeoff(timeoffid,CommentController.text,1);
                          print("ff"+sts);
                          if(sts=="true") {
                            showDialog(
                                context: context,
                                builder: (_) =>
                                new AlertDialog(
                                  //title: new Text("Dialog Title"),
                                  content: new Text("Application for timeoff is rejected"),
                                )
                            );
                          }
                          else{
                            showDialog(
                                context: context,
                                builder: (_) =>
                                new AlertDialog(
                                  //title: new Text("Dialog Title"),
                                  content: new Text("Could not be rejected"),
                                )
                            );
                          }



                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TimeOffApp()),
                          ); },
                        color: Colors.red,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: new Text('Reject',
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

        }
    );

  }


/*
  _onTapImage(leavetypeid) {
    return new
    Container(
      //  height: MediaQuery.of(context).size.height*.02,
      //width: MediaQuery.of(context).size.width*.99,
      // color: Colors.white,
      decoration: new ShapeDecoration(
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0),),
        color: Colors.white,
      ),

      child:  FutureBuilder<List<LeaveH>>(
          future: getleavehistory(leavetypeid),
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
                            new Container(
                              width: MediaQuery.of(context).size.width * .99,
                              child:Text("Leave History",style:TextStyle(
                                // fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0,
                                  color: Colors.black), textAlign: TextAlign.center,),

                            ),
                            new Container(
                                width: MediaQuery.of(context).size.width * .99,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: <Widget>[Text(snapshot.data[index].name .toString(),                               style: TextStyle( color: Colors.grey[500], fontSize: 16.0),),

                                    ]  )),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[

                                SizedBox(height: 10.0,),
                                new Expanded(
                                  child: Container( width: MediaQuery.of(context).size.width * 0.05,

                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          new Text("Entitle: "+snapshot.data[index].Entitle .toString(), style: TextStyle( color: Colors.grey[500], fontSize: 16.0),),
                                          // shape: new CircleBorder(),
                                          // borderSide: BorderSide(color: Colors.green),
                                        ] ),


                                    *//*  child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[
                                         Text("Entitle: "+snapshot.data[index].Entitle .toString(), style: TextStyle( color: Colors.black87, // fontWeight: FontWeight.bold,
                                                fontSize: 16.0),),
                                          ],
                                      ),*//*
                                  ),  ),

                                new Expanded(
                                  child:Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.10,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          Text("Used: "+snapshot.data[index].Used
                                              .toString(), style: TextStyle( color: Colors.grey[500], fontSize: 16.0),),
                                        ],
                                      )

                                  ),),
                                new Expanded(
                                  child:Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.10,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          Text("Left: "+snapshot.data[index].Left
                                              .toString(), style: TextStyle( color: Colors.grey[500], fontSize: 16.0),),
                                        ],
                                      )

                                  ),),

                                *//*  new Expanded(
                                  child:Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.18,
                                      decoration: new ShapeDecoration(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius: new BorderRadius
                                                .circular(2.0)),
                                        color: snapshot.data[index].Leavests ==
                                            'Approved' ? Colors.green
                                            .withOpacity(0.75) : snapshot                                                    .data[index].Leavests
                                            .toString() == 'Rejected'  ? Colors
                                            .red.withOpacity(0.65) : snapshot                                                  .data[index].Leavests
                                            .toString().startsWith('Pending')
                                            ? Colors.orangeAccent
                                            : Colors.black12,
                                      ),


                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          Text(snapshot.data[index].Leavests
                                              .toString(),style: TextStyle(color: Colors.white),),
                                        ],
                                      )

                                  ),),*//*
                                Divider(color: Colors.black26,),
                              ],

                            ),  ] );
                    }
                );
              }else{
                return new Center(
                  child:Text("No Records"),
                );
              }
            }
            else if (snapshot.hasError) {
              return new Text("Unable to connect server");
            }

            // By default, show a loading spinner
            return new Center(child: CircularProgressIndicator());
          }
      ),  );
  }*/

}

