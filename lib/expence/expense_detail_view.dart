import 'package:flutter/material.dart';
import '../drawer.dart';
import '../global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/expense_services.dart';
import 'expenselist.dart';
import '../login_page.dart';
import '../global.dart';
import '../b_navigationbar.dart';
import '../appbar.dart';
import 'dart:async';
import 'dart:io';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ExpenseDetailView extends StatefulWidget {
  @override
  _ExpenseDetailViewState createState() => _ExpenseDetailViewState();
}

class _ExpenseDetailViewState extends State<ExpenseDetailView> {

  var profileimage;
  bool showtabbar ;
  String orgName="";

  bool _checkwithdrawnexpense = false;

  bool _checkLoadedprofile = true;

  @override

  Widget mainWidget= new Container(width: 0.0,height: 0.0,);
  @override
  void initState() {
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
    String id = prefs.getString('expenseid')??"";
    //String empid = prefs.getString('employeeid')??"";
    //String organization =prefs.getString('organization')??"";
    islogin().then((Widget configuredWidget) {
      setState(() {
        mainWidget = configuredWidget;
      });
    });
  }

  Widget loadingWidget(){
    return Center(child:SizedBox(
      child:
      Text("Loading..", style: TextStyle(fontSize: 10.0,color: Colors.white),),
    ));
  }

  withdrawlLeave(String Id) async{
    setState(() {
      _checkwithdrawnexpense = true;
    });
    print("----> withdrawn service calling "+_checkwithdrawnexpense.toString());
    final prefs = await SharedPreferences.getInstance();
    //String id = prefs.getString('expenseid')??"";
    //String empid = prefs.getString('employeeid')??"";
    //String orgid =prefs.getString('organization')??"";
    var expense = Expense(Id: Id);
    var islogin = await withdrawExpense(expense);
    print(islogin);
    if(islogin=="success"){
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyExpence()),
      );
      showDialog(context: context, child:
      new AlertDialog(
        //  title: new Text("Congrats!"),
        content: new Text("Your expense is withdrawn successfully!"),
      )
      );
    }else if(islogin=="failure"){
      showDialog(context: context, child:
      new AlertDialog(
        //title: new Text("Sorry!"),
        content: new Text("Expense could not be withdrawn."),
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


  confirmWithdrawl(String Id) async{
    showDialog(context: context, child:
    new AlertDialog(
      title: new Text("Withdraw  Expense?"),
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
              setState(() {
                _checkwithdrawnexpense = true;
              });
              Navigator.of(context, rootNavigator: true).pop();
              withdrawlLeave(Id);
            },
          ),
        ],
      ),
    )
    );
  }

  Future<bool> sendToExpenseList() async{
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyExpence()), (Route<dynamic> route) => false,
    );
    return false;
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

  Widget build(BuildContext context) {
    return mainWidget;
  }



  Widget mainScafoldWidget(){
    return WillPopScope(
        onWillPop: ()=> sendToExpenseList(),
      child: Scaffold(
        backgroundColor:scaffoldBackColor(),
        endDrawer: new AppDrawer(),
        appBar: new AppHeader(profileimage,showtabbar,orgName),
        bottomNavigationBar:new HomeNavigation(),
        body:  ModalProgressHUD(
            inAsyncCall: _checkwithdrawnexpense,
            opacity: 0.15,
            progressIndicator: SizedBox(
              child:new CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation(Colors.green),
                  strokeWidth: 5.0),
              height: 50.0,
              width: 50.0,
            ),
            child: homewidget()
        ),
      ),
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
    /*           child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Expense Detail',
                      style: new TextStyle(fontSize: 22.0, color: appStartColor())),
                  //SizedBox(height: 10.0),

                  new Divider(),
                  new Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height*.55,
                      width: MediaQuery.of(context).size.width*.99,
                      //padding: EdgeInsets.only(bottom: 15.0),
                      color: Colors.white,
                      child: Container(
                        child: new Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.height*.55,
                            width: MediaQuery.of(context).size.width*.99,
                            //       margin: EdgeInsets.only(top: 4.0),
                            //padding: EdgeInsets.only(bottom: 15.0),
                            color: Colors.white,
                            //////////////////////////////////////////////////////////////////////---------------------------------
                            child: new FutureBuilder<List<Expense>>(
                              future: getExpenseDetail(),
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
                                                        //     color:Colors.red,
                                                          height: MediaQuery .of(context).size.height * 0.04,
                                                          width: MediaQuery .of(context).size.width * 0.50,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              //     new SizedBox(width: 5.0,),
                                                             // new Text(snapshot.data[index].attendancedate.toString(), style: TextStyle(fontWeight: FontWeight.bold),)
                                                            ],
                                                          )
                                                      ),
                                                    ),

                                                    //(snapshot.data[index].withdrawlsts && snapshot.data[index].approverstatus.toString() !='Withdrawn' && snapshot.data[index].approverstatus.toString() !="Rejected")?
                                                    new Expanded(
                                                      child: Container (
                                                        //                   color:Colors.yellow,
                                                          height: MediaQuery .of(context).size.height * 0.04,
                                                          margin: EdgeInsets.only(left:115.0),
                                                          //padding: EdgeInsets.only(left:32.0),
                                                          width: MediaQuery .of(context).size.width * 0.50,
                                                          child: new OutlineButton(
                                                            onPressed: () {
                                                              *//*confirmWithdrawl(
                                                                  snapshot.data[index].leaveid.toString());*//*
                                                            },
                                                            child:new Icon(
                                                              Icons.replay,
                                                              size: 20.0,
                                                              color:appStartColor(),
                                                              //      textDirection: TextDirection.rtl,
                                                            ),
                                                            borderSide: BorderSide(color:appStartColor()),
                                                            shape: new CircleBorder(),
                                                            //         padding:EdgeInsets.all(5.0),
                                                          )
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                Container(
                                                  width: MediaQuery.of(context).size.width*.90,
                                                  padding: EdgeInsets.only(top:1.5,bottom: .5),
                                                  margin: EdgeInsets.only(top: 4.0),
                                                  //child: Text('Duration: '+snapshot.data[index].leavefrom.toString()+snapshot.data[index].leaveto.toString() +"  ",style: TextStyle(color: Colors.grey[600])),
                                                ),

                                                *//*snapshot.data[index].reason.toString()!='-'?Container(
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
                                                ),*//*

                                                Divider(),
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
                      ),

                      //////////////////////////////////////////////////////////////////////---------------------------------

                     *//* child: new FutureBuilder<List<Expensedate>>(
                        future: getExpenselistbydate(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.start,

                                        children: <Widget>[
                                          new RaisedButton(
                                            //   shape: BorderDirectional(bottom: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1),top: BorderSide(color: Colors.green[900],style: BorderStyle.solid,width: 1)),
                                            //   shape: RoundedRectangleBorder(side: BorderSide(color: appStartColor(),style: BorderStyle.solid,width: 1),borderRadius: new BorderRadius.circular(5.0)),
                                            //   shape: RoundedRectangleBorder(side: BorderSide(color:appStartColor(),style: BorderStyle.solid,width: 1)),
                                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                            child: Container(
                                              padding: EdgeInsets.only(left:  0.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  SizedBox(width: 15.0),
                                                  Expanded(

                                                    child: Container(
                                                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                                        child: Text(snapshot.data[index].dates.toString(),textAlign:TextAlign.left,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),)
                                                    ),


                                                  ),

                                                  *//**//*Container(
                                                    child: Icon(Icons.keyboard_arrow_down,size: 40.0,),
                                                  ),*//**//*
                                                ],
                                              ),
                                            ),
                                            color: Colors.white,
                                            elevation: 4.0,
                                            textColor: Colors.black,
                                            onPressed: () {
                                              //     expensebydatewidget();
                                              // Navigator.push(
                                              //   context,
                                              //    MaterialPageRoute(builder: (context) => LeaveReports()),
                                              //  );
                                            },
                                          ),
                                          //expensebydatewidget(snapshot.data[index].Fdate.toString()),

                                        ]);
                                  }
                              );
                            }else
                              return new Center(
                                child: Text('No Expense History'),
                              );
                          } else if (snapshot.hasError) {
                            return new Text("Unable to connect server");
                          }

                          // By default, show a loading spinner
                          return new Center( child: CircularProgressIndicator());
                        },
                      ),*//*
                      //////////////////////////////////////////////////////////////////////---------------------------------
                    ),
                  ),
                ])*/
        ),



      ],
    );
  }
}
