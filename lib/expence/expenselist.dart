import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/services/services.dart';

import '../b_navigationbar.dart';
import '../drawer.dart';
import '../global.dart';
import '../home.dart';
import '../login_page.dart';
import '../profile.dart';
import '../services/expense_services.dart';
import 'expense_detail_view.dart';
import 'request_expense.dart';


class MyExpence extends StatefulWidget {
  @override
  _MyExpenceState createState() => _MyExpenceState();
}

class _MyExpenceState extends State<MyExpence> {
  int _currentIndex = 0;
  int response;
  var profileimage;
  bool showtabbar ;
  String orgName="";

  bool _checkLoadedprofile = true;
  bool _checkwithdrawnexpense = false;
  var PerLeave;
  var PerApprovalLeave;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

  Future<bool> sendToHome() async{
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );*/
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePageMain()), (Route<dynamic> route) => false,
    );
    return false;
  }

  Widget mainScafoldWidget(){
    return  WillPopScope(
      onWillPop: ()=> sendToHome(),
      child: Scaffold(
        backgroundColor:scaffoldBackColor(),
        endDrawer: new AppDrawer(),
        appBar: new ExpenseAppHeader(profileimage,showtabbar,orgName),
        bottomNavigationBar:new HomeNavigation(),
        /*body:  ModalProgressHUD(
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
        ),*/
        body: homewidget(),
        floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.orange[800],
          onPressed: (){
          Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => RequestExpence()),
           );
          },
          tooltip: 'Expense Claim',
          child: new Icon(Icons.add),
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
                  //SizedBox(height: 5.0),
                  Text('My Expenses',
                      style: new TextStyle(fontSize: 22.0, color: appStartColor()),textAlign: TextAlign.center,),
                  //SizedBox(height: 10.0),
                  //new Divider(color: Colors.black54,height: 1.5,),
                  new Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height*.55,
                      width: MediaQuery.of(context).size.width*.99,
                      //padding: EdgeInsets.only(bottom: 15.0),
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------

                      child: new FutureBuilder<List<Expensedate>>(
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

                                                  /*Container(
                                                    child: Icon(Icons.keyboard_arrow_down,size: 40.0,),
                                                  ),*/
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
                                         expensebydatewidget(snapshot.data[index].Fdate.toString()),

                                     ]);
                                  }
                              );
                            }else
                              return new Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width*1,
                                  color: appStartColor().withOpacity(0.1),
                                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                  child:Text("No Expense History",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                                ),
                              );
                              /*return new Center(
                                child: Text('No Expense History'),
                              );*/
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

  Widget expensebydatewidget(Fdate){
    return Container(
      color: Colors.green[100],
     // height: MediaQuery.of(context).size.height*0.2,
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

        new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 40.0),
            //SizedBox(width: MediaQuery.of(context).size.width*0.10),
            new Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width*0.35,
                //margin: EdgeInsets.only(left:10.0),
                child:Text('  Category',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 14.0),),
              ),
            ),

            new Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width*0.35,
                margin: EdgeInsets.only(left:35.0),
                child:Text('Amount',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 14.0),),
              ),
            ),

            new Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width*0.35,
                margin: EdgeInsets.only(left:50.0),
                child:Text('Action',style: TextStyle(color: appStartColor(),fontWeight:FontWeight.bold,fontSize: 14.0),),
              ),
            ),
          ] ,
        ),

        new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                child: Container(
                 height: MediaQuery.of(context).size.height*0.10,
                  //width: MediaQuery.of(context).size.width*.99,
                  //padding: EdgeInsets.only(bottom: 15.0),
                  color: Colors.green[50],
                  child: new FutureBuilder<List<Expense>>(
                    future: getExpenselist(Fdate),
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
                                                  width: MediaQuery .of(context).size .width * 0.10,
                                                  margin: EdgeInsets.only(top:2.0,left:6.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      new SizedBox(width: 5.0,),
                                                      new Text(snapshot.data[index].category.toString(),
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold),)

                                                    ],
                                                  )
                                              ),
                                            ),

                                           /* new Expanded(
                                              child: Container(
                                                  width: MediaQuery .of(context).size .width * 0.10,
                                                  //margin: EdgeInsets.only(left:20.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      new SizedBox(width: 5.0,),
                                                      new Text(
                                                        snapshot.data[index].desc.toString(),
                                                        style: TextStyle(
                                                            ),)

                                                    ],
                                                  )
                                              ),
                                            ),*/
                                            new Expanded(
                                              child: Container(
                                                  width: MediaQuery .of(context).size .width * 0.10,
                                                  margin: EdgeInsets.only(left:20.0),
                                                  padding: EdgeInsets.only(left:15.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      new SizedBox(width: 5.0,),
                                                      new Text(
                                                       snapshot.data[index].currency.toString()+" "+snapshot.data[index].amt.toString(),textAlign: TextAlign.right,

                                                       //   snapshot.data[index].amt.toString() ,textAlign: TextAlign.right,

                                                      )

                                                    ],
                                                  )
                                              ),
                                            ),

                                            new Expanded(
                                              child: Container (
                                                //                   color:Colors.yellow,
                                                 height: MediaQuery .of(context).size.height * 0.03,
                                                 margin: EdgeInsets.only(left:12.0),
                                                  padding: EdgeInsets.only(left:12.0),
                                                  width: MediaQuery .of(context).size.width * 0.50,
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      print("Button pressed");
                                                      //getExpenseDetailById(snapshot.data[index].Id.toString());
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => ExpenseDetailView(expenseid: snapshot.data[index].Id.toString())),
                                                      );
                                                    },
                                                    child: Text("view", style: TextStyle(color: Colors.blueAccent, fontSize: 15.0, decoration: TextDecoration.underline),),
                                                    /*child: Icon(
                                                      Icons.remove_red_eye,
                                                      size: 20.0,
                                                      color:appStartColor(),
                                                    ),*/
                                                  ),
                                                  /*child: new FlatButton(
                                                    onPressed: () {
                                                      print("icon pressed");
                                                        *//*Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => ExpenseDetailView()),
                                                        );*//*
                                                    },
                                                    child:new Icon(
                                                      Icons.remove_red_eye,
                                                      size: 24.0,
                                                      color:appStartColor(),
                                                      //      textDirection: TextDirection.rtl,
                                                    ),
                                                    //         padding:EdgeInsets.all(5.0),
                                                  )*/
                                              ),
                                            )

                                          ],
                                        ),



                                      ////

                                      /*   snapshot.data[index].desc.toString()!='-'?Container(
                                          width: MediaQuery.of(context).size.width*.90,
                                          padding: EdgeInsets.only(top:1.5,bottom: .5),
                                          margin: EdgeInsets.only(top: 4.0),
                                          child: Text(snapshot.data[index].category.toString(), style: TextStyle(color: Colors.black54),),
                                        ):Center(),*/

                                      /*  snapshot.data[index].desc.toString()!='-'?Container(
                                          width: MediaQuery.of(context).size.width*.90,
                                          padding: EdgeInsets.only(top:1.5,bottom: 1.5),
                                          margin: EdgeInsets.only(top: 4.0,bottom: 1.5),
                                          child: Text('Description: '+snapshot.data[index].desc.toString(), style: TextStyle(color: Colors.black54),),
                                        ):Center(),*/



                                    ]);
                              }
                          );
                        }else
                          return new Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width*1,
                              color: appStartColor().withOpacity(0.1),
                              padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                              child:Text("No Expense History",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                            ),
                          );
                          /*return new Center(
                            child: Text('No Expense History'),
                          );*/
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
          ),
        ]
      )
    );
  }

}

class ExpenseAppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;
  ExpenseAppHeader(profileimage1,showtabbar1,orgname1){
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
                print("ICON PRESSED");
                //Navigator.pop(context,false);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageMain()), (Route<dynamic> route) => false,
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
                  padding: const EdgeInsets.all(8.0),
                  child: Text(orgname, overflow: TextOverflow.ellipsis,)
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