import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
import 'package:url_launcher/url_launcher.dart';

class ExpenseDetailView extends StatefulWidget {
  @override
  final String expenseid;
  ExpenseDetailView({Key key,  this.expenseid}) : super(key: key);
  _ExpenseDetailViewState createState() => _ExpenseDetailViewState();
}

class _ExpenseDetailViewState extends State<ExpenseDetailView> {

  var profileimage;
  bool showtabbar ;
  String orgName="";
  int checkProcessing = 0;
  bool isServiceCalling = false;
  bool _isButtonDisabled = false;
  bool _checkwithdrawnexpense = false;



  bool _checkLoadedprofile = true;
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

  withdrawlExpense(String Id) async{
    setState(() {
      _checkwithdrawnexpense = true;
    });
    print("----> withdrawn service calling "+_checkwithdrawnexpense.toString());
    final prefs = await SharedPreferences.getInstance();
    //String id = prefs.getString('expenseid')??"";
    //String empid = prefs.getString('employeeid')??"";
    //String orgid =prefs.getString('organization')??"";
    var expense = Expense(Id: Id, ests: '5');
    var islogin = await withdrawExpense(expense);
    print(islogin);
    if(islogin=="success"){
      setState(() {
        _isButtonDisabled=false;
      });
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
      setState(() {
        _isButtonDisabled=false;
      });
      showDialog(context: context, child:
      new AlertDialog(
        //title: new Text("Sorry!"),
        content: new Text("Expense could not be withdrawn."),
      )
      );
    }else{
      setState(() {
        _isButtonDisabled=false;
      });
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
      title: new Text("Withdraw expense?"),
      content:  ButtonBar(
        children: <Widget>[
          RaisedButton(
            child: _checkwithdrawnexpense?Text('Processing..',style: TextStyle(color: Colors.white),):Text('Withdraw',style: TextStyle(color: Colors.white),),
            color: Colors.orange[800],
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              withdrawlExpense(widget.expenseid);
            },
          ),
          FlatButton(
            shape: Border.all(color: Colors.orange[800]),
            child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
            onPressed: () {
              setState(() {
                _isButtonDisabled=false;
              });
              Navigator.of(context, rootNavigator: true).pop();
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

  @override
  Widget build(BuildContext context) {
    return mainScafoldWidget();
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

  Widget mainScafoldWidget(){
    return  WillPopScope(
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
              height: 40.0,
              width: 40.0,
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
              child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Expense Details',
                        style: new TextStyle(fontSize: 22.0, color: appStartColor())),
                    //SizedBox(height: 10.0),

                    new Divider(),
                    new Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height*.55,
                        width: MediaQuery.of(context).size.width*.99,
                        //padding: EdgeInsets.only(bottom: 15.0),
                        color: Colors.white,
                        //////////////////////////////////////////////////////////////////////---------------------------------
                        child: new FutureBuilder<List<Expense>>(
                          future: getExpenseDetailById(widget.expenseid),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                                return new ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return new Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[

                                          Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            padding: EdgeInsets.only(top:1.5,bottom: .5),
                                            margin: EdgeInsets.only(top: 4.0),
                                            child: Text(snapshot.data[index].category.toString()+"  ",style: TextStyle(color: Colors.orange[800],fontWeight:FontWeight.bold,fontSize: 20.0),textAlign: TextAlign.center,),
                                          ),

                                          /*snapshot.data[index].category.toString()!='-'?Container(
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
                                                  new TextSpan(text: 'Category: ',style:TextStyle(color: Colors.grey[600],fontSize: 16.0), ),
                                                  new TextSpan(text: snapshot.data[index].category.toString(),style: TextStyle(color: Colors.grey[600],fontSize: 16.0)),

                                                  //new TextSpan(text: snapshot.data[index].ests.toString(), style: TextStyle(color: Colors.orange,fontWeight:FontWeight.bold,fontSize: 16.0,),)
                                                ],

                                              ),
                                            ),
                                          ):Center(),*/
                                          SizedBox(height: 15,),
                                          Row(
                                            children: <Widget>[
                                              snapshot.data[index].applydate.toString()!='-'?Container(
                                                width: MediaQuery.of(context).size.width*.60,
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
                                                      new TextSpan(text: 'Apply Date: ',style:TextStyle(color: Colors.black,fontSize: 17.0), ),
                                                      new TextSpan(text: snapshot.data[index].applydate.toString(),style: TextStyle(color: Colors.grey[600],fontSize: 16.0)),

                                                      //new TextSpan(text: snapshot.data[index].ests.toString(), style: TextStyle(color: Colors.orange,fontWeight:FontWeight.bold,fontSize: 16.0,),)
                                                    ],

                                                  ),
                                                ),
                                              ):Center(),

                                              snapshot.data[index].doc.toString()!='null'?Container(
                                                //width: MediaQuery.of(context).size.width*.30,
                                                padding: EdgeInsets.only(top:.5,bottom: 1.5),
                                                margin: EdgeInsets.only(top: 1.0 ),
                                                child: Container(
                                                  width: MediaQuery.of(context) .size .width * 0.27,
                                                  //margin: EdgeInsets.only(left:0.0),
                                                  height: 28.0,
                                                  child: new OutlineButton(
                                                    onPressed: () {
                                                      print(snapshot.data[index].doc.toString());
                                                      launchMap(snapshot.data[index].doc.toString());
                                                      //   launchMap(" https://ubiattendance.ubihrm.com/");
                                                    },
                                                    child: new Icon(
                                                      Icons.file_download,
                                                      size: 20.0,
                                                      color: appStartColor(),
                                                    ),
                                                    borderSide: BorderSide(color: appStartColor()),
                                                    padding:EdgeInsets.all(3.0),
                                                    shape: new CircleBorder(),
                                                  ),
                                                ),
                                                /*child: RichText(
                                              text: new TextSpan(
                                                // Note: Styles for TextSpans must be explicitly defined.
                                                // Child text spans will inherit styles from parent
                                                style: new TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black,
                                                ),
                                                children: <TextSpan>[
                                                  new TextSpan(text: 'Document: ',style:TextStyle(color: Colors.black,fontSize: 17.0), ),
                                                  //new TextSpan(text: snapshot.data[index].doc.toString(), ),


                                                  //new TextSpan(text: snapshot.data[index].ests.toString(), style: TextStyle(color: Colors.orange,fontWeight:FontWeight.bold,fontSize: 16.0,),)
                                                ],

                                              ),
                                            ),*/
                                              ):Center(),
                                            ],
                                          ),
                                         /* Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            padding: EdgeInsets.only(top:1.5,bottom: .5),
                                            margin: EdgeInsets.only(top: 4.0),
                                            child: Text('Apply Date: '+snapshot.data[index].applydate.toString()+"  ",style: TextStyle(color: Colors.grey[600],fontSize: 16.0)),
                                          ),*/


                                          SizedBox(height: 10,),
                                          /*Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            padding: EdgeInsets.only(top:1.5,bottom: .5),
                                            margin: EdgeInsets.only(top: 4.0),
                                            child: Text('Description: '+snapshot.data[index].desc.toString()+"  ",style: TextStyle(color: Colors.grey[600],fontSize: 16.0)),
                                          ),*/

                                          snapshot.data[index].desc.toString()!='-'?Container(
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
                                                  new TextSpan(text: 'Description: ',style:TextStyle(color: Colors.black,fontSize: 17.0), ),
                                                  new TextSpan(text: snapshot.data[index].desc.toString(),style: TextStyle(color: Colors.grey[600],fontSize: 16.0)),

                                                  //new TextSpan(text: snapshot.data[index].ests.toString(), style: TextStyle(color: Colors.orange,fontWeight:FontWeight.bold,fontSize: 16.0,),)
                                                ],

                                              ),
                                            ),
                                          ):Center(),
                                          SizedBox(height: 10,),

                                          /*Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            padding: EdgeInsets.only(top:1.5,bottom: .5),
                                            margin: EdgeInsets.only(top: 4.0),
                                            child: Text('Amount: '+snapshot.data[index].amt.toString()+ "  "+snapshot.data[index].currency.toString(),style: TextStyle(color: Colors.grey[600],fontSize: 16.0)),
                                          ),*/

                                          snapshot.data[index].amt.toString()!='-'?Container(
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
                                                  new TextSpan(text: 'Amount: ',style:TextStyle(color: Colors.black,fontSize: 17.0), ),
                                                  new TextSpan(text: snapshot.data[index].amt.toString()+" "+snapshot.data[index].currency.toString(),style: TextStyle(color: Colors.grey[600],fontSize: 16.0)),

                                                  //new TextSpan(text: snapshot.data[index].ests.toString(), style: TextStyle(color: Colors.orange,fontWeight:FontWeight.bold,fontSize: 16.0,),)
                                                ],

                                              ),
                                            ),
                                          ):Center(),
                                          SizedBox(height: 10,),
                                         /* Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            padding: EdgeInsets.only(top:1.5,bottom: .5),
                                            margin: EdgeInsets.only(top: 4.0),
                                            child: Text('Status '+snapshot.data[index].ests.toString()+"  ",style: TextStyle(color: Colors.grey[600],fontWeight:FontWeight.bold,fontSize: 16.0)),
                                          ),*/
                                          snapshot.data[index].ests.toString()!='null'?Container(
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
                                                  new TextSpan(text: 'Status: ',style:TextStyle(color: Colors.black,fontSize: 17.0), ),
                                                  new TextSpan(text: snapshot.data[index].ests.toString(), style: TextStyle(color: snapshot.data[index].ests.toString()=='Approved'?appStartColor() :snapshot.data[index].ests.toString()=='Rejected' || snapshot.data[index].ests.toString()=='Withdrawn' ?Colors.red:snapshot.data[index].ests.toString().startsWith('Pending')?Colors.orange[800]:Colors.blue[600], fontSize: 16.0),),

                                                  //new TextSpan(text: snapshot.data[index].ests.toString(), style: TextStyle(color: Colors.orange,fontWeight:FontWeight.bold,fontSize: 16.0,),)
                                                ],

                                              ),
                                            ),
                                          ):Center(),
                                          SizedBox(height: 20,),

                                          /*snapshot.data[index].doc.toString()!='-'?Container(
                                            width: MediaQuery.of(context).size.width*.90,
                                            padding: EdgeInsets.only(top:.5,bottom: 1.5),
                                            margin: EdgeInsets.only(top: 1.0),
                                              child: Container(
                                                width: MediaQuery.of(context) .size .width * 0.30,
                                                //margin: EdgeInsets.only(left:0.0),
                                                height: 28.0,
                                                child: new OutlineButton(
                                                  onPressed: () {
                                                    print(snapshot.data[index].doc.toString());
                                                    launchMap(snapshot.data[index].doc.toString());
                                                    //   launchMap(" https://ubiattendance.ubihrm.com/");
                                                  },
                                                  child: new Icon(
                                                    Icons.file_download,
                                                    size: 17.0,
                                                    color: appStartColor(),
                                                  ),
                                                  borderSide: BorderSide(color:  appStartColor()),
                                                  padding:EdgeInsets.all(3.0),
                                                  shape: new CircleBorder(),
                                                ),
                                              ),
                                            *//*child: RichText(
                                              text: new TextSpan(
                                                // Note: Styles for TextSpans must be explicitly defined.
                                                // Child text spans will inherit styles from parent
                                                style: new TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black,
                                                ),
                                                children: <TextSpan>[
                                                  new TextSpan(text: 'Document: ',style:TextStyle(color: Colors.black,fontSize: 17.0), ),
                                                  //new TextSpan(text: snapshot.data[index].doc.toString(), ),


                                                  //new TextSpan(text: snapshot.data[index].ests.toString(), style: TextStyle(color: Colors.orange,fontWeight:FontWeight.bold,fontSize: 16.0,),)
                                                ],

                                              ),
                                            ),*//*
                                          ):Center(),*/

                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              (snapshot.data[index].ests.toString()!="Approved" && snapshot.data[index].ests.toString() !='Withdrawn' && snapshot.data[index].ests.toString() !="Rejected")?
                                              ButtonBar(
                                                children: <Widget>[
                                                  RaisedButton(
                                                    child: isServiceCalling?Text('Processing..',style: TextStyle(color: Colors.white),):Text('Withdraw',style: TextStyle(color: Colors.white),),
                                                    color: Colors.orange[800],
                                                    onPressed: () {
                                                      if(_isButtonDisabled)
                                                        return null;
                                                      setState(() {
                                                        _isButtonDisabled=true;
                                                        checkProcessing = index;
                                                      });
                                                      confirmWithdrawl(widget.expenseid);
                                                    },
                                                  ),
                                                ],
                                              ):Center(),

                                              ButtonBar(
                                                children: <Widget>[
                                                  FlatButton(
                                                    shape: Border.all(color: Colors.orange[800]),
                                                    child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => MyExpence()),
                                                      );
                                                    },
                                                  ),
                                                ],

                                              ),


                                            ],

                                          ),

                                        ],
                                      );
                                    }
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
  launchMap(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print( 'Could not launch $url');
    }
  }

}
