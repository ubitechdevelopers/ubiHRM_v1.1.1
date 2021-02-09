
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/all_approvals.dart';
import 'package:ubihrm/services/expense_services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
import '../model/model.dart';
import '../profile.dart';
import '../services/services.dart';


class SalaryExpenseApproval extends StatefulWidget {
  @override
  _SalaryExpenseApproval createState() => _SalaryExpenseApproval();
}

class _SalaryExpenseApproval extends State<SalaryExpenseApproval> {
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
    profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);
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
      //fontWeight: FontWeight.w500
      // color: 'red',
    );
    TextStyle unselectedLabel = new TextStyle(
      // fontWeight: FontWeight.w200
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

class ChoiceCard1 extends StatelessWidget {
  const ChoiceCard1({Key key, this.choice}) : super(key: key);
  final Choice choice;
  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return  Scaffold(
      backgroundColor:scaffoldBackColor(),
      body: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              //width: MediaQuery.of(context).size.width*0.9,
              decoration: new ShapeDecoration(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                color: Colors.white,
              ),
              child:Column(
                  children: <Widget>[
                    Text('Expense Applications',
                        style: new TextStyle(fontSize: 22.0, color: appStartColor())),
                    new Divider(height: 2,),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(height: 20.0,),
                        new Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left:15.0),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                              width: MediaQuery.of(context).size.width*0.80,
                              child:Text('Name',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.0,),
                        new Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(60.0, 0.0, 0.0, 0.0),
                            width: MediaQuery.of(context).size.width*0.20,
                            child:Text(' Applied on',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
                          ),
                        ),

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
                            child: new FutureBuilder<List<Expense>>(
                              future: getExpenseApprovals(choice.title),
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
                                                    //SizedBox(height: 20.0,),
                                                    new Expanded(
                                                      child: Container(
                                                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                                                        width: MediaQuery.of(context) .size.width * 0.80,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment .start,
                                                          children: <Widget>[
                                                            GestureDetector(
                                                              // When the child is tapped, show a snackbar
                                                              onTap: () {
                                                              },
                                                              child: Text(snapshot.data[index].name.toString(), style: TextStyle(
                                                                  color: Colors.black87,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 16.0),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    new Expanded(
                                                      child:Container(
                                                          margin: EdgeInsets.fromLTRB(50.0, 5.0, 0.0, 0.0),
                                                          width: MediaQuery .of(context) .size.width * 0.20,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment .center,
                                                            children: <Widget>[
                                                              Text(snapshot.data[index].applydate
                                                                  .toString()),
                                                            ],
                                                          )
                                                      ),
                                                    ),
                                                    Divider(color: Colors.black26,),
                                                  ],

                                                ),

                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                        width: MediaQuery.of(context) .size .width * 0.60,
                                                        //height: MediaQuery.of(context) .size .height * 0.03,
                                                        //padding: EdgeInsets.only(top:1.5),
                                                        //margin: EdgeInsets.only(top: 0.5),
                                                        margin: EdgeInsets.only(top: 4.0),
                                                        child: RichText(
                                                          text: new TextSpan(
                                                            style: new TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors.black,
                                                            ),
                                                            children: <TextSpan>[
                                                              new TextSpan(
                                                                  text: 'Expense Head: ',
                                                                  style: new TextStyle()),
                                                              new TextSpan(
                                                                text: snapshot.data[index].category.toString(),style: TextStyle(color: Colors.grey[600]),)
                                                            ],
                                                          ),
                                                        )
                                                    ),


                                                    snapshot.data[index].ests.toString() == 'Pending'
                                                        && snapshot.data[index].Psts.toString() == ""  ?
                                                    new Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                                                        child: Container(
                                                          //height: MediaQuery.of(context) .size .height * 0.04,
                                                          child: new OutlineButton(
                                                            onPressed: () {
                                                              _modalBottomSheet(context, snapshot.data[index].Id.toString());
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
                                                  ],
                                                ),

                                                new Row(
                                                  children: <Widget>[
                                                    Container(
                                                        width: MediaQuery.of(context) .size .width * 0.70,
                                                        //height: MediaQuery.of(context) .size .height * 0.03,
                                                        //padding: EdgeInsets.only(top:3.0),
                                                        margin: EdgeInsets.only(top: 4.0),
                                                        child: RichText(
                                                          text: new TextSpan(
                                                            style: new TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors.black,
                                                            ),
                                                            children: <TextSpan>[
                                                              new TextSpan(
                                                                  text: 'Description: ',
                                                                  style: new TextStyle()),
                                                              new TextSpan(
                                                                text: snapshot.data[index].desc.toString(),style: TextStyle(color: Colors.grey[600]),)
                                                            ],
                                                          ),
                                                        )
                                                    ),
                                                  ],
                                                ),

                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                        width: MediaQuery.of(context) .size .width * 0.70,
                                                        //height: MediaQuery.of(context) .size .height * 0.03,
                                                        //padding: EdgeInsets.only(top:3.0),
                                                        margin: EdgeInsets.only(top: 4.0),
                                                        child: RichText(
                                                          text: new TextSpan(
                                                            style: new TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors.black,
                                                            ),
                                                            children: <TextSpan>[
                                                              new TextSpan(
                                                                  text: 'Amount: ',
                                                                  style: new TextStyle()),
                                                              new TextSpan(
                                                                text: snapshot.data[index].currency.toString()+" "+snapshot.data[index].amt.toString(),style: TextStyle(color: Colors.grey[600]),)
                                                            ],
                                                          ),
                                                        )
                                                    ),
                                                  ],
                                                ),

                                                Row(
                                                  children: <Widget>[
                                                    snapshot.data[index].doc.toString()!='null'?Container(
                                                        width: MediaQuery.of(context) .size .width * 0.70,
                                                        //height: MediaQuery.of(context) .size .height * 0.03,
                                                        //padding: EdgeInsets.only(top:1.5),
                                                        //margin: EdgeInsets.only(top: 4.0),
                                                        child: Row(
                                                          children: <Widget>[
                                                            RichText(text: TextSpan(
                                                                style: new TextStyle(
                                                                  fontSize: 14.0,
                                                                  color: Colors.black,
                                                                ),
                                                                children: <TextSpan>[
                                                                  new TextSpan(
                                                                      text: 'Reciept: ',
                                                                      style: new TextStyle()),
                                                                ]
                                                            )),
                                                            new InkWell(
                                                                onTap: () {
                                                                  print(snapshot.data[index].doc.toString());
                                                                  launchMap(snapshot.data[index].doc.toString());
                                                                },
                                                                //child: Text("Attached Document", style: TextStyle(color: Colors.blueAccent, fontSize: 14.0, decoration: TextDecoration.underline),textAlign: TextAlign.start,),
                                                                child: Icon(Icons.file_download, color:Colors.green)
                                                            ),
                                                          ],
                                                        )
                                                      /*child: Row(
                                                          children: <Widget>[
                                                            Text("Reciept: ", style: TextStyle(color: Colors.black, fontSize: 13.0),),
                                                            new InkWell(
                                                              onTap: () {
                                                                print(snapshot.data[index].doc.toString());
                                                                launchMap(snapshot.data[index].doc.toString());
                                                              },
                                                              //child: Text("Attached Document", style: TextStyle(color: Colors.blueAccent, fontSize: 14.0, decoration: TextDecoration.underline),textAlign: TextAlign.start,),
                                                              child: Icon(Icons.file_download, color:Colors.green)
                                                            ),
                                                          ],
                                                        )*/
                                                    ):Center(),
                                                  ],
                                                ),
/*

                                            Row(
                                              children: <Widget>[
                                                snapshot.data[index].doc.toString()!=''?Container(
                                                  width: MediaQuery.of(context) .size .width * 0.70,
                                                  height: MediaQuery.of(context) .size .height * 0.03,
                                                  //padding: EdgeInsets.only(top:1.5),
                                                  margin: EdgeInsets.only(top: 0.5),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text("Reciept: ", style: TextStyle(color: Colors.black, fontSize: 14.0),),
                                                      new InkWell(
                                                        onTap: () {
                                                          print(snapshot.data[index].doc.toString());
                                                          launchMap(snapshot.data[index].doc.toString());
                                                        },
                                                        //child: Text("Attached Document", style: TextStyle(color: Colors.blueAccent, fontSize: 14.0, decoration: TextDecoration.underline),textAlign: TextAlign.start,),
                                                          child: Icon(Icons.file_download, color:Colors.green)                                                      ),
                                                    ],
                                                  )
                                                ):Center(),
                                              ],
                                            ),
*/

                                                snapshot.data[index].Psts.toString()!=''?Container(
                                                  width: MediaQuery.of(context).size.width*.90,
                                                  //padding: EdgeInsets.only(top:3.0),
                                                  //margin: EdgeInsets.only(top: 4.0),
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

                                                /*Row(
                                              children: <Widget>[
                                                Container(
                                                    width: MediaQuery.of(context) .size .width * 0.70,
                                                    height: MediaQuery.of(context) .size .height * 0.03,
                                                    padding: EdgeInsets.only(top:1.0,bottom: .5),
                                                    margin: EdgeInsets.only(top: .5),
                                                    child: RichText(
                                                      text: new TextSpan(
                                                        style: new TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                        ),
                                                        children: <TextSpan>[
                                                          new TextSpan(
                                                              text: 'Status: ',
                                                              style: new TextStyle()),
                                                          new TextSpan(
                                                            text: snapshot.data[index].ests.toString(),style: TextStyle(color: Colors.red),)
                                                        ],
                                                      ),
                                                    )
                                                ),
                                              ],
                                            ),*/

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
                  ]
              ),
            ),
          ]
      ),
    );
  }

  _modalBottomSheet(context,String expenseid) async{

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
                      topRight: const Radius.circular(0.0)
                  )
              ),
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
                        hintText: "Remarks",
                        hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold", fontSize: 15.0 ),
                      ),
                      maxLines: 3,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 0.0, left: 60.0, right: 15.0),
                        child:  ButtonTheme(
                          //minWidth: 50.0,
                          //height: 40.0,
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
                                final sts= await ApproveExpense(expenseid,CommentController.text,2);
                                print("kk");
                                print("kk"+sts);
                                if(sts=="true") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SalaryExpenseApproval()),
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 3), () {
                                        Navigator.of(context).pop(true);
                                      });
                                      return AlertDialog(
                                        content: new Text("Expense claim approved successfully."),
                                      );
                                    });
                                  /*showDialog(
                                      context: context,
                                      builder: (_) =>
                                      new AlertDialog(
                                        //title: new Text("Dialog Title"),
                                        content: new Text("Expense claim approved successfully."),
                                      )
                                  );*/
                                } else{
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SalaryExpenseApproval()),
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 3), () {
                                        Navigator.of(context).pop(true);
                                      });
                                      return AlertDialog(
                                        content: new Text("Expense claim could not be approved."),
                                      );
                                    });
                                  /*showDialog(
                                      context: context,
                                      builder: (_) =>
                                      new AlertDialog(
                                        //title: new Text("Dialog Title"),
                                        content: new Text("Expense claim could not be approved."),
                                      )
                                  );*/
                                }
                              },
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0),),
                            )
                        ),
                      ),


                      Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 0.0, left: 15.0, right: 60.0),
                        child:  ButtonTheme(
                          //minWidth: 60.0,
                          //height: 40.0,
                          child: new OutlineButton(
                              child: new Text('Reject',
                                  style: new TextStyle(
                                      color: Colors.red[700],
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),borderSide: BorderSide(color: Colors.red[700]),
                              onPressed: () async {
                                var sts = await ApproveExpense(expenseid,CommentController.text,1);
                                print("ff"+sts);
                                if(sts=="true") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SalaryExpenseApproval()),
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 3), () {
                                        Navigator.of(context).pop(true);
                                      });
                                      return AlertDialog(
                                        content: new Text("Expense claim rejected successfully."),
                                      );
                                    });
                                  /*showDialog(
                                      context: context,
                                      builder: (_) =>
                                      new AlertDialog(
                                        //title: new Text("Dialog Title"),
                                        content: new Text("Expense claim rejected successfully."),
                                      )
                                  );*/
                                } else{
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SalaryExpenseApproval()),
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        Future.delayed(Duration(seconds: 3), () {
                                          Navigator.of(context).pop(true);
                                        });
                                        return AlertDialog(
                                          content: new Text("Expense claim could not be rejected."),
                                        );
                                      });
                                  /*showDialog(
                                      context: context,
                                      builder: (_) =>
                                      new AlertDialog(
                                        //title: new Text("Dialog Title"),
                                        content: new Text("Expense claim could not be rejected."),
                                      )
                                  );*/

                                }
                              },
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

  launchMap(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print( 'Could not launch $url');
    }
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
            );
          }).toList(),
        ):null
    );
  }
  @override
  Size get preferredSize => new Size.fromHeight(showtabbar==true ? 100.0 : 60.0);

}

