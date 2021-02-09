
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/all_approvals.dart';

import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
import '../model/model.dart';
import '../profile.dart';
import '../services/leave_services.dart';
import '../services/services.dart';


class TabbedApp extends StatefulWidget {
  @override
  _TabState createState() => _TabState();
}


class _TabState extends State<TabbedApp> {
  int idL;
  int _currentIndex = 0;
  var profileimage;
  bool _checkLoadedprofile = true;
  String empid;
  String organization;  String hrsts;
  var PerLeave;
  var PerApprovalLeave;
  bool showtabbar;
  String orgName="";

  Employee emp;


  void initState() {
    super.initState();
    initPlatformState();
    getOrgName();

    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoadedprofile = false;
        });
      }
    }));
    showtabbar=true;
  }
  initPlatformState() async{
    final prefs = await SharedPreferences.getInstance();

    empid = prefs.getString('employeeid')??"";
    organization =prefs.getString('organization')??"";

    emp = new Employee(employeeid: empid, organization: organization);
    getAllPermission(emp);
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName= prefs.getString('orgname') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {

    TextStyle label = new TextStyle(
      fontSize: 16.0, color: Colors.blue,
    );
    TextStyle unselectedLabel = new TextStyle(
      fontSize: 15.0, color: Colors.white
    );
    print(label);
    return MaterialApp(
      home: DefaultTabController(
        length: choices.length,
        child: RefreshIndicator(
          child: Scaffold(
            endDrawer: new AppDrawer(),
            appBar: new ApprovalAppHeader(profileimage,showtabbar,orgName),
              body: TabBarView(
                children: choices.map((Choice choice) {
                  return Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: ChoiceCard1(choice: choice),
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

class ChoiceCard1 extends StatelessWidget {
  const ChoiceCard1({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {

    final TextStyle textStyle = Theme.of(context).textTheme.display1;

    return  Scaffold(
      //appBar: new AppHeader(profileimage,showtabbar,orgName),
      backgroundColor:scaffoldBackColor(),
      body: Stack(

        // color: Colors.white,
          children: <Widget>[
            Container(
              // color: Colors.white,
              margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              //width: MediaQuery.of(context).size.width*0.9,
              decoration: new ShapeDecoration(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                color: Colors.white,
              ),
              // margin: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
              // padding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
              // width: MediaQuery.of(context).size.width*0.9,
              /*  decoration: new ShapeDecoration(
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0),),

        ),*/
              // child: Center(
              child:Column(
                  children: <Widget>[
                    Text('Leave Applications',
                        style: new TextStyle(fontSize: 22.0, color: appStartColor())),
                    new Divider(height: 2,),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // headingColor(),
                        SizedBox(height: 20.0,),
                        new Expanded(
                          child:   Container(

                            width: MediaQuery.of(context).size.width*0.22,
                            child:Text('    Name',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                          ),
                        ),
                        SizedBox(height: 30.0,),
                        new Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.30,
                            child:Text(' ',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                          ), ),

                        SizedBox(height: 30.0,),
                        new Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.30,
                            child:Text('Applied on',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                          ), ),

                      ],
                    ),



                    new Expanded(
                      child:Container(

                        // margin: const EdgeInsets.only(top: 55.0),
                        //  margin: EdgeInsets.fromLTRB(0.0, 55.0, 0.0, 0.0),
                        height: MediaQuery.of(context).size.height*0.6,
                        //   shape: Border.all(color: Colors.deepOrangeAccent),
                        child: new ListTile(
                          title:
                          Container( height: MediaQuery.of(context).size.height*.6,
                            width: MediaQuery.of(context).size.width*.99,
                            // color: Colors.white,
                            decoration: new ShapeDecoration(
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0),),
                              color: Colors.white,
                            ),//////////////////////////////////////////////////////////////////////---------------------------------
                            child: new FutureBuilder<List<LeaveA>>(
                            future: getApprovals(choice.title),
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
                                     //SizedBox(height: 40.0,),
                                       new Expanded(
                                           child: Container(
                                            width: MediaQuery.of(context) .size.width * 0.90,
                                             child: Column(
                                              crossAxisAlignment: CrossAxisAlignment  .start,
                                               children: <Widget>[
                                                 GestureDetector(
                                                  // When the child is tapped, show a snackbar
                                                  onTap: () {},
                                                   child:   Text(snapshot.data[index].name.toString(), style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0),),
                                                  ), ],
                                              ),
                                             ),
                                       ),

                                       new Expanded(
                                          child:Container(
                                            width: MediaQuery .of(context)  .size.width * 0.20,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment .center,
                                                children: <Widget>[
                                                 Text("         "+snapshot.data[index].applydate.toString()),
                                                ],
                                              )
                                          ),),
                                            Divider(color: Colors.black26,),
                                    ],

                                  ),
                                     SizedBox(height: 2.5,),
                                        new Row(
                                          // mainAxisAlignment: MainAxisAlignment .spaceAround,
                                          children: <Widget>[
                                            //   SizedBox(height: 10.0,),

                                            Container(
                                                width: MediaQuery.of(context) .size .width * 0.65,
                                                height: MediaQuery .of(context).size.height * 0.03,
                                                //height: MediaQuery.of(context) .size .height * 0.03,
                                                //padding: EdgeInsets.only(top: 1.5, bottom: .0),
                                                //margin: EdgeInsets.only(top: 0.5),
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

                                            snapshot.data[index].Leavests.toString() == 'Pending' && snapshot.data[index].Psts.toString() == ""  ?
                                            new Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(0.0,0.0,38.0,0.0),
                                                child: Container(
                                                  height: MediaQuery .of(context).size.height * 0.04,
                                                  //width: MediaQuery.of(context) .size .width * 0.30,
                                                  //height: MediaQuery.of(context) .size .height * 0.03,
                                                  //height: 28.0,
                                                  child: new OutlineButton(
                                                    onPressed: () {
                                                      //  confirmApprove(context,snapshot.data[index].Id.toString());
                                                      if(snapshot.data[index].HRSts.toString()=='1') {

                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            Future.delayed(Duration(seconds: 3), () {
                                                              Navigator.of(context).pop(true);
                                                            });
                                                            return AlertDialog(
                                                              content: new Text("Kindly check from the portal."),
                                                            );
                                                          });
                                                        /*showDialog(context: context, child:
                                                        new AlertDialog(
                                                          //title: new Text("Sorry!"),
                                                          content: new Text("Kindly check from the portal."),
                                                        )
                                                        );*/
                                                        /*_modalBottomSheetHR(
                                                            context, snapshot.data[index].Id.toString(),snapshot.data[index].Ldays.toString(),snapshot.data[index].LeaveTypeId.toString());
                         */                             getleavehistory(snapshot.data[index].LeaveTypeId.toString());
                                                      }else{
                                                        _modalBottomSheet(
                                                            context, snapshot.data[index].Id.toString(), snapshot.data[index].Ldays.toString());
                                                      }
                                                    },
                                                    child: new Icon(
                                                      Icons.thumb_up,
                                                      size: 16.0,
                                                      color:appStartColor(),
                                                    ),
                                                    borderSide: BorderSide(color:  appStartColor()),
                                                    shape: new CircleBorder(),
                                                    padding:EdgeInsets.all(3.0),
                                                  ),
                                                ),
                                              ),
                                            ): Center(),

                                          ],),

                                         Container(
                                             width: MediaQuery.of(context) .size .width * 0.70,
                                             //height: MediaQuery.of(context) .size .height * 0.03,
                                             //padding: EdgeInsets.only(top: 1.5, bottom: .0),
                                             //margin: EdgeInsets.only(top: 4.0),
                                             child: RichText(
                                               text: new TextSpan(
                                                 style: new TextStyle(
                                                   fontSize: 14.0,
                                                   color: Colors.black,
                                                 ),
                                                 children: <TextSpan>[
                                                   new TextSpan(
                                                       text: 'Leave Type: ',
                                                       style: new TextStyle()),
                                                   new TextSpan(
                                                     text: snapshot.data[index].LeaveType.toString(),style: TextStyle(color: Colors.grey[600]), ),
                                                   /*   new TextSpan(text: " Days: "+snapshot.data[index].Ldays.toString(),style: TextStyle(color: Colors.black), ),*/
                                                 ],
                                               ),
                                             )
                                         ),

                                        snapshot.data[index].Reason.toString() != '-'
                                            ? Container(
                                            width: MediaQuery.of(context).size.width * .90,
                                            //padding: EdgeInsets.only(top:1.0,bottom: .5),
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

                                        /*snapshot.data[index].Psts.toString() != ''
                                                      ? new TextSpan(text: "\n"+snapshot.data[index].Psts.toString(),style: TextStyle(color: Colors.orange[800],fontWeight:FontWeight.bold
                                                  ), ): new TextSpan(text: ""+snapshot.data[index].Psts.toString(),style: TextStyle(color: Colors.orange[800],fontWeight:FontWeight.bold), ),*/

                                                ],
                                              ),
                                            )
                                        ): Center(),

                                        snapshot.data[index].Psts.toString()!=''?Container(
                                          width: MediaQuery.of(context).size.width*.90,
                                          //padding: EdgeInsets.only(top:1.0,bottom: .5),
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
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*2,
                                    color: appStartColor().withOpacity(0.1),
                                    padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                    child:Text("No Records",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                                  ),
                                  //child:Text("No Records"),
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
            ),
          ]
      ),
    );

  }


  _modalBottomSheet(context,String leaveid,days) async{

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
                        /* icon: Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 22.0,
                        ),*/
                        hintText: "Comment",
                        hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold", fontSize: 15.0 ),
                        /*suffixIcon: GestureDetector(
                          //onTap: _toggleLogin,
                          child: Icon(
                            Icons.edit,
                            size: 15.0,
                            color: Colors.black,
                          ),
                        ),*/
                      ),

                      /*validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Email or Phone no.';
                            }
                          },*/
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
                            child: new OutlineButton(
                              child: new Text('Approve',
                                  style: new TextStyle(
                                    color: Colors.green[700],
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,

                                  )),
                              borderSide: BorderSide(color: Colors.green[700],
                              ),
                              onPressed: () async  {
                                //getApprovals(choice.title);
                                final sts= await ApproveLeave(leaveid,CommentController.text,2);
                                //  print("kk");
                                // print("kk"+sts);
                                if(sts=="true") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => TabbedApp()),
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 3), () {
                                        Navigator.of(context).pop(true);
                                      });
                                      return AlertDialog(
                                        content: new Text("Leave application approved successfully."),
                                      );
                                    });
                                  /*showDialog(
                                      context: context,
                                      builder: (_) =>
                                      new AlertDialog(
                                        //title: new Text("Dialog Title"),
                                        content: new Text("Leave application approved successfully."),
                                      )
                                  );*/
                                } else{
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        Future.delayed(Duration(seconds: 3), () {
                                          Navigator.of(context).pop(true);
                                        });
                                        return AlertDialog(
                                          content: new Text("Leave could not be approved. Try again!"),
                                        );
                                      });
                                  /*showDialog(
                                      context: context,
                                      builder: (_) =>
                                      new AlertDialog(
                                        //title: new Text("Dialog Title"),
                                        content: new Text("Leave could not be approved. Try again!"),
                                      )
                                  );*/
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TabbedApp()),
                                );
                                },
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0),),

                            )
                        ),),


                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 0.0, left: 15.0, right: 60.0),
                        child:  ButtonTheme(
                          minWidth: 50.0,
                          height: 40.0,
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
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 3), () {
                                        Navigator.of(context).pop(true);
                                      });
                                      return AlertDialog(
                                        content: new Text("Leave has been rejected successfully."),
                                      );
                                    });
                                  /*showDialog(
                                      context: context,
                                      builder: (_) =>
                                      new AlertDialog(
                                        //title: new Text("Dialog Title"),
                                        content: new Text("Leave has been rejected successfully."),
                                      )
                                  );*/
                                }
                                else{
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        Future.delayed(Duration(seconds: 3), () {
                                          Navigator.of(context).pop(true);
                                        });
                                        return AlertDialog(
                                          content: new Text("Leave could not be rejected. Try again!"),
                                        );
                                      });
                                  /*showDialog(
                                      context: context,
                                      builder: (_) =>
                                      new AlertDialog(
                                        //title: new Text("Dialog Title"),
                                        content: new Text("Leave could not be rejected. Try again!"),
                                      )
                                  );*/
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TabbedApp()),
                                ); },
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
    // print("--------->");
    // print(profileimage);
    //  print("--------->");
    //   print(_checkLoadedprofile);
    if (profileimage!=null) {
      _checkLoadedprofile = false;
      //    print(_checkLoadedprofile);
    };
    showtabbar= showtabbar1;
  }
  /*void initState() {
    super.initState();
 //   initPlatformState();
  }
*/
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

