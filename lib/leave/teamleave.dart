import 'package:flutter/material.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../appbar.dart';
import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
import '../login_page.dart';
import '../services/leave_services.dart';
import 'myleave.dart';


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
  TextEditingController _searchController;
  FocusNode searchFocusNode;
  String empname = "";
  bool res = true;
  bool _checkLoadedprofile = true;
  bool _checkwithdrawnleave = false;
  var PerLeave;
  var PerApprovalLeave;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget mainWidget= new Container(width: 0.0,height: 0.0,);

  @override
  void initState() {
    _searchController = new TextEditingController();
    searchFocusNode = FocusNode();
    super.initState();
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoadedprofile = false;
        });
      }
    }));

    showtabbar=false;
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
    String empid = prefs.getString('employeeid')??"";
    String organization =prefs.getString('organization')??"";
  }

  @override
  Widget build(BuildContext context) {
    return mainScafoldWidget();
  }

  Future<bool> sendToHome() async{
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyLeave()), (Route<dynamic> route) => false,
    );
    return false;
  }

  mainScafoldWidget(){
    return new WillPopScope(
        onWillPop: ()=> sendToHome(),
        child: Scaffold(
            backgroundColor:scaffoldBackColor(),
            endDrawer: new AppDrawer(),
            appBar: new AppHeader(profileimage,showtabbar,orgName),
            bottomNavigationBar:new HomeNavigation(),
            body: homewidget()
        )
    );
  }

  homewidget(){
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
                          child:InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MyLeave()),
                              );

                            },
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
                                            color: Colors.orange[800],
                                            size: 22.0 ),

                                        GestureDetector(
                                          child: Text(
                                              'Self',
                                              style: TextStyle(fontSize: 18.0,color: Colors.orange[800],)
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
                                          color: Colors.orange[800],
                                          size: 22.0 ),
                                      GestureDetector(
                                        onTap: () {
                                          /* Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MyTeamAtt()),
                                  );*/
                                          false;
                                        },
                                        child: Text(
                                            'Team',
                                            style: TextStyle(fontSize: 18,color: Colors.orange[800],fontWeight:FontWeight.bold)
                                        ),
                                      ),
                                    ]),
                                SizedBox(height:MediaQuery.of(context).size.width*.03),
                                Divider(
                                  color: Colors.orange[800],
                                  height: 0.4,
                                ),
                                Divider(
                                  color: Colors.orange[800],
                                  height: 0.4,
                                ),
                                Divider(
                                  color: Colors.orange[800],
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
                      child:Text("Team's Leave",
                        style: new TextStyle(fontSize: 18.0, color: Colors.black87,),textAlign: TextAlign.center,),
                    ),
                  ),

                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
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
                          hintText: 'Search Employee',
                          //labelText: 'Search Employee',
                          suffixIcon: _searchController.text.isNotEmpty?IconButton(icon: Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                /*Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EmployeeList()),
                            );*/
                              }
                          ):null,
                          //focusColor: Colors.white,
                        ),
                        onChanged: (value) {
                          setState(() {
                            empname = value;
                            print("empname");
                            print(empname);
                            res = true;
                          });
                        },
                      ),
                    ),
                  ),

                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      // SizedBox(width: MediaQuery.of(context).size.width*0.0),
                      new Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.50,
                          child:Text('Name',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                        ),),
                      //SizedBox(height: 50.0,),
                      new Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left:32.0),
                          padding: EdgeInsets.only(right:12.0),
                          width: MediaQuery.of(context).size.width*0.50,
                          child:Text('Applied on',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),textAlign: TextAlign.right,),
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
                        future: getTeamApprovals(empname),
                        builder: (context, snapshot) {
                          print("empnamevanshika");
                          print(empname);
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
                                              //SizedBox(height: 40.0,),
                                              new Expanded(
                                                child: Container(
                                                  width: MediaQuery.of(context) .size.width * 0.60,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment .start,
                                                    children: <Widget>[
                                                      new Text(snapshot.data[index].name.toString(), style: TextStyle(
                                                          color: Colors.black87,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16.0),),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              new Expanded(
                                                child:Padding(
                                                  padding: const EdgeInsets.only(left:80.0),
                                                  child: Container(
                                                      width: MediaQuery.of(context).size.width * 0.40,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment .center,
                                                        children: <Widget>[
                                                          Text(snapshot.data[index].applydate.toString()),
                                                        ],
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ],

                                          ),

                                          new Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              new Expanded(
                                                child: Container(
                                                  //color:Colors.red,
                                                  //height: MediaQuery .of(context).size.height * 0.06,
                                                    width: MediaQuery .of(context).size.width * 0.70,
                                                    margin: EdgeInsets.only(top: 4.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        //     new SizedBox(width: 5.0,),
                                                        new Text("Duration: "+snapshot.data[index].Fdate.toString()+snapshot.data[index].Tdate.toString(),style: TextStyle(color: Colors.grey[600]),)
                                                      ],
                                                    )
                                                ),
                                              ),

                                              (snapshot.data[index].sts.toString() == 'true')?
                                              new Expanded(
                                                child: Container (
                                                  //color:Colors.yellow,
                                                    height: MediaQuery .of(context).size.height * 0.04,
                                                    margin: EdgeInsets.only(left:32.0),
                                                    padding: EdgeInsets.only(left:32.0),
                                                    width: MediaQuery.of(context).size.width * 0.30,
                                                    child: new OutlineButton(
                                                      onPressed: () {
                                                        if(snapshot.data[index].HRSts.toString()=='1') {
                                                          /*_modalBottomSheetHR(
                                                          context, snapshot.data[index].Id.toString(),snapshot.data[index].Ldays.toString(),snapshot.data[index].LeaveTypeId.toString());
                                                      getleavehistory(snapshot.data[index].LeaveTypeId.toString());
*/
                                                          showDialog(context: context, child:
                                                          new AlertDialog(
                                                            //title: new Text("Sorry!"),
                                                            content: new Text("Kindly check from the portal."),
                                                          )
                                                          );
                                                        }else{
                                                          _modalBottomSheet(
                                                              context, snapshot.data[index].Id.toString(), snapshot.data[index].Ldays.toString());

                                                        }
                                                      },
                                                      child:new Icon(
                                                        Icons.thumb_up,
                                                        size: 16.0,
                                                        color:appStartColor(),
                                                        //      textDirection: TextDirection.rtl,
                                                      ),
                                                      borderSide: BorderSide(color:appStartColor()),
                                                      shape: new CircleBorder(),
                                                      //         padding:EdgeInsets.all(5.0),
                                                    )
                                                ),
                                              ):Center(),
                                            ],
                                          ),

                                          Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            //padding: EdgeInsets.only(top:1.5,bottom: .5),
                                            margin: EdgeInsets.only(top: 4.0),
                                            child: Text('Leave Type: '+snapshot.data[index].LeaveType.toString(), style: TextStyle(color: Colors.black54),),
                                          ),

                                          snapshot.data[index].Reason.toString()!='-'?Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            //padding: EdgeInsets.only(top:1.5,bottom: .5),
                                            margin: EdgeInsets.only(top: 4.0),
                                            child: Text('Reason: '+snapshot.data[index].Reason.toString(), style: TextStyle(color: Colors.black54),),
                                          ):Center(),

                                          (snapshot.data[index].Leavests.toString()!='Pending' ) ?Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            //padding: EdgeInsets.only(top:.5,bottom: 1.5),
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
                                                  new TextSpan(text: 'Status: ',style:TextStyle(color: Colors.black54,), ),
                                                  new TextSpan(text: snapshot.data[index].Leavests.toString(), style: TextStyle(color: snapshot.data[index].Leavests.toString()=='Approved'?appStartColor() :snapshot.data[index].Leavests.toString()=='Rejected' || snapshot.data[index].Leavests.toString()=='Cancel' ?Colors.red:Colors.blue[600], fontSize: 14.0),),
                                                ],
                                              ),
                                            ),
                                          ):Center(
                                            // child:Text(snapshot.data[index].withdrawlsts.toString()),
                                          ),

                                          (snapshot.data[index].Leavests.toString()=='Pending' && snapshot.data[index].Psts.toString()!='') ?Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            //padding: EdgeInsets.only(top:.5,bottom: 1.5),
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
                                                  new TextSpan(text: 'Status: ',style:TextStyle(color: Colors.black54,), ),
                                                  new TextSpan(text: snapshot.data[index].Psts.toString(), style: TextStyle(color: Colors.orange[800], fontSize: 14.0),),
                                                ],
                                              ),
                                            ),
                                          ):Center(
                                            // child:Text(snapshot.data[index].withdrawlsts.toString()),
                                          ),

                                          Divider(),
                                        ]
                                    );
                                  }
                              );
                            }else
                              return new Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width*1,
                                  color: appStartColor().withOpacity(0.1),
                                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                  child:Text("No Leave History",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                                ),
                              );
                            //return new Center( child: Text('No Leave History'), );
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





  _modalBottomSheet(context,String leaveid,days) async{

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
                            fontFamily: "WorkSansSemiBold", fontSize: 15.0 ),
                      ),
                      maxLines: 3,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 0.0, left: 60.0, right: 7.0),
                    child:  ButtonTheme(
                        minWidth: 50.0,
                        //    height: 40.0,
                        child: new OutlineButton(
                          child: new Text('Approve',
                              style: new TextStyle(
                                color: Colors.green[700],
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,

                              )),
                          borderSide: BorderSide(color: Colors.green[700],),
                          onPressed: () async  {
                            //getApprovals(choice.title);
                            final sts= await ApproveLeave(leaveid,CommentController.text,2);
                            //  print("kk");
                            // print("kk"+sts);
                            if(sts=="true") {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (_) =>
                                  new AlertDialog(
                                    //title: new Text("Dialog Title"),
                                    content: new Text("Leave application approved successfully."),
                                  )
                              );
                              await new Future.delayed(const Duration(seconds: 2));
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MyTeamLeave()),
                              );
                            }else{
                              showDialog(
                                  context: context,
                                  builder: (_) =>
                                  new AlertDialog(
                                    //title: new Text("Dialog Title"),
                                    content: new Text("Leave application Could not be approved."),
                                  )
                              );
                            }
                          },
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0),),
                        )
                    ),),


                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 0.0, left: 7.0, right: 60.0),
                    child:  ButtonTheme(
                      minWidth: 50.0,
                      //      height: 40.0,
                      child: new OutlineButton(
                          child: new Text('Reject',
                              style: new TextStyle(
                                  color: Colors.red[700],
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold)),borderSide: BorderSide(color: Colors.red[700]),
                          onPressed: () async {
                            //getApprovals(choice.title);
                            var sts = await ApproveLeave(leaveid,CommentController.text,1);
                            print("ff"+sts);
                            if(sts=="true") {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (_) =>
                                  new AlertDialog(
                                    //title: new Text("Dialog Title"),
                                    content: new Text("Leave application rejected successfully."),
                                  )
                              );
                              await new Future.delayed(const Duration(seconds: 2));
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MyTeamLeave()),
                              );
                            }else{
                              showDialog(
                                  context: context,
                                  builder: (_) =>
                                  new AlertDialog(
                                    //title: new Text("Dialog Title"),
                                    content: new Text("Leave application could not be rejected."),
                                  )
                              );
                            }
                          },
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0))
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
}
