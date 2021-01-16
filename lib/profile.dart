import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'b_navigationbar.dart';
import 'global.dart';
import 'home.dart';
import 'model/model.dart';
import 'services/services.dart';


class CollapsingTab extends StatefulWidget {
  @override
  _CollapsingTabState createState() => new _CollapsingTabState();
}

class _CollapsingTabState extends State<CollapsingTab> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PersistentBottomSheetController controller;
  //bool _checkLoaded = true;
  bool _isButtonDisabled= false;
  //bool _isProfileUploading= false;
  ScrollController scrollController;
  double height = 0.0;
  double insideContainerHeight=300.0;
  String empid;
  String organization;
  String countryid;
  Employee emp;
  var reporttoprofileimage;
  var juniorprofileimage;
  bool _checkLoaded = true;
  var profileimage;
  bool _checkLoadedprofile = true;
  bool _isProfileUploading= false;
  var toreportprofileimage;
  bool _checkLoadedr = true;
  var profilepic;

  Widget _buildActions() {
    Widget profile = new GestureDetector(

        child: new Container(
            width: 90.0,
            height: 90.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/default.png'),
                )
            ))
    );

    double scale;

    if (scrollController.hasClients) {
      scale = scrollController.offset / 300;
      scale = scale * 2;
      print(scale.toString());
      if (scale > 1) {
        scale = 1.0;
      }
    } else {
      scale = 0.0;
    }

    return new Transform(
      transform: new Matrix4.identity()..scale(scale, scale),
      alignment: Alignment.center,
      child: profile,
    );
  }

  Widget appBarHeading() {

    Widget profile = new GestureDetector(
      child: new Column(
        children: <Widget>[
          Text(globalcompanyinfomap['Designation'] , style: new TextStyle(fontSize: 16.0,color: Colors.white)),
          SizedBox(height: 20.0,),
          Text(globalcompanyinfomap['CompanyEmail'] , style: new TextStyle(fontSize: 16.0,color: Colors.white)),
        ],
      ),
    );

    double scale;

    if (scrollController.hasClients) {
      scale = scrollController.offset / 300;
      scale = scale * 2;
      if (scale > 1) {
        scale = 0.0;
      }
    } else {
      scale = 1.0;
    }

    return new Transform(
      transform: new Matrix4.identity()..scale(scale, scale),
      alignment: Alignment.center,
      child: profile,
    );
  }

  /* @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }*/

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
    scrollController.addListener(() => setState(() {}));
    scrollController.addListener(_scrollListener);
    initPlatformState();
  }

  initPlatformState() async{
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('employeeid')??"";
    organization =prefs.getString('organization')??"";
    countryid =prefs.getString('countryid')??"";
    emp = new Employee(employeeid: empid, organization: organization);
    await getProfileInfo(emp, context);
    reporttoprofileimage = new NetworkImage( globalcompanyinfomap['ReportingToProfilePic']);
    reporttoprofileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoaded = false;
        });
      }
    }));


    // profilepic =prefs.getString('profilepic')??"";
    // profileimage = new NetworkImage(profilepic);
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
    //  print("ABC"+profileimage);
    profileimage.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoadedprofile = false;
        });

      }
    }));
  }


  _scrollListener() {
    double scale;
    double scale1;
    double scale2=150.0;
    if (scrollController.hasClients) {
      scale1 = scrollController.offset/2;
      scale2 = 150.0 - scrollController.offset/2;
      print(scale2);
      setState(() {
        height=scale1;
        insideContainerHeight = 450.0 - scale2;
        print("this is cont height"+insideContainerHeight.toString());
      });
      scale = scrollController.offset / 300;
      scale = scale * 2;
      //print(scale1);
      //print(scale.toString());

      /*if (scale > 1) {
        //scale = 1.0;
       // print(scale);
        setState(() {
          height=150.0;
          insideContainerHeight=500.0;
          print("scale is greater than one");
        });

        print(height);
        print(insideContainerHeight);
      }else if(scale==0.0){
        setState(() {
          height=0.0;
          insideContainerHeight=350.0;
          print("scale is greater than one");
        });
        print("bottom");
        print(scale);
      }*/
    }

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        height=150.0;
        insideContainerHeight=450.0;
        //print("reach the bottom "+height.toString());
      });
    }
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        height=0.0;
        insideContainerHeight=300.0;
        //print("reach the top "+height.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var flexibleSpaceWidget = new SliverAppBar(
      automaticallyImplyLeading: true,
      //  key: _scaffoldKey,
      expandedHeight: 200.0,
      pinned: true,
      // backgroundColor: Color.fromRGBO(0,102,153,1.0),
      backgroundColor: appStartColor(),

      flexibleSpace: FlexibleSpaceBar(

        centerTitle: true,
        title:Column(children:<Widget>[
          SizedBox(height: 30.0,),
          Text(globalpersnalinfomap["FirstName"]+" "+globalpersnalinfomap["LastName"],
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              )),
          //appBarHeading()
        ]), /*Column(
            children:<Widget>[
            Text("Monika Rai",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              )),
            //appBarHeading()
          ]),*/

        background: Column(
          children:<Widget>[
            Stack(
                children: <Widget>[
                  SizedBox(height: 50.0,),
                  new GestureDetector(
                    onTap: (){
                      showBottomNavigation();
                    },
                    child:_isProfileUploading?new Container(
                      margin: EdgeInsets.only(
                          top: 40.0),
                      height: 40.0,
                      width: 40.0,
                      child: new CircularProgressIndicator(),
                    ):Container(
                      margin: EdgeInsets.only(
                          top: 30.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius:BorderRadius.circular(100)
                          ),
                          //child: Icon(Icons.camera_alt,color: Colors.white,size: 20),
                          child: SizedBox(
                            width:35,
                            height: 35,
                            child: Tooltip(
                              message: 'Change Profile',
                              child: IconButton(
                                padding: new EdgeInsets.all(0.0),
                                icon: Icon(Icons.camera_alt,size: 20,color:const Color(0xFFFFFFFF),),
                                onPressed: () {
                                  showBottomNavigation();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: new DecorationImage(
                          //image: new ExactAssetImage("assets/avatar.png"),
                          fit: BoxFit.fill,
                          //image: NetworkImage(globalcompanyinfomap['ProfilePic']),
                          image: _checkLoadedprofile ? AssetImage('assets/avatar.png') : profileimage, // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ]),
            SizedBox(height: 10.0,),
            Text(globalpersnalinfomap["FirstName"]+" "+globalpersnalinfomap["LastName"],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              )),
            SizedBox(height: 5.0,),
            Text(globalcompanyinfomap['CompanyEmail'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              )),
            SizedBox(height: 5.0,),
            Text(globalcompanyinfomap['Designation'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ))
          ]),
      ),
    );

    Future<bool> sendToHome() async{
      print("-------> back button pressed");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePageMain()), (Route<dynamic> route) => false,
      );
      return false;
    }

    return WillPopScope(
      onWillPop: ()=> sendToHome(),
      child: Scaffold(
        key: _scaffoldKey,
        body: new DefaultTabController(
          length: 2,
          child: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                flexibleSpaceWidget,
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.black26,
                      tabs: [
                        Tab(
                            icon: Icon(Icons.person),
                            text: "Profile"
                        ),
                        Tab(icon: Icon(Icons.group), text: "Team"),
                      ],
                    ),

                  ),
                  pinned: true,
                ),

              ];
            },
            body: new TabBarView(
              children: <Widget>[
                Column(children: <Widget>[
                  SizedBox(height: height),
                  new Expanded(
                    child:Container(
                      height: insideContainerHeight,
                      //width: 400.0,
                      width: MediaQuery.of(context).size.width*1,
                      //color: Colors.green[50],
                      child: ListView(children: <Widget>[
                        Container(
                          //height: MediaQuery.of(context).size.height,
                          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          //width: MediaQuery.of(context).size.width*0.9,
                          decoration: new ShapeDecoration(
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                            color: Colors.grey[100],
                          ),
                          child:
                          StickyHeader(
                            header: new Container(
                              //height: 50.0,
                              height: MediaQuery.of(context).size.height*0.06,
                              color: Colors.grey[100],
                              padding: new EdgeInsets.symmetric(horizontal: 9.0),
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                'About',
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                            content: new Container(
                              padding: new EdgeInsets.symmetric(horizontal: 9.0),
                              child: Column(
                                children: <Widget>[
                                  (globallabelinfomap['emp_code']!="" && globalcompanyinfomap["EmpCode"]!="")?
                                  Row(children: <Widget>[
                                    Container(child:Text(globallabelinfomap['emp_code'],style: TextStyle(fontWeight: FontWeight.w600),) ,
                                      width: 150.0,),
                                    Text(globalcompanyinfomap["EmpCode"],style: TextStyle(color: Colors.grey[600])),
                                  ],):Center(),

                                  (globallabelinfomap['first_name']!="" && globalpersnalinfomap["FirstName"]!="")?SizedBox(height: 10.0,):Center(),
                                  (globallabelinfomap['first_name']!="" && globalpersnalinfomap["FirstName"]!="")?
                                  Row(children: <Widget>[
                                    Container(child:Text(globallabelinfomap['first_name'],style: TextStyle(fontWeight: FontWeight.w600),) ,
                                      width: 150.0,),
                                    Flexible(child: Text(globalpersnalinfomap["FirstName"]+" "+globalpersnalinfomap["LastName"],style: TextStyle(color: Colors.grey[600]))),
                                  ],):Center(),

                                  (globallabelinfomap['doj']!="" && globalpersnalinfomap["DOJ"]!="")?SizedBox(height: 10.0,):Center(),
                                  (globallabelinfomap['doj']!="" && globalpersnalinfomap["DOJ"]!="")?
                                  Row(children: <Widget>[
                                    Container(child:Text(globallabelinfomap["doj"],style: TextStyle(fontWeight: FontWeight.w600),) ,
                                      width: 150.0,),
                                    Text(globalpersnalinfomap["DOJ"],style: TextStyle(color: Colors.grey[600])),
                                  ],):Center(),

                                  (globallabelinfomap['division']!="" && globalcompanyinfomap["Division"]!="")?SizedBox(height: 10.0,):Center(),
                                  (globallabelinfomap['division']!="" && globalcompanyinfomap["Division"]!="")?
                                  Row(children: <Widget>[
                                    Container(child: Text(globallabelinfomap["division"],style: TextStyle(fontWeight: FontWeight.w600),),
                                      width: 150.0,),
                                    Flexible(child: Text(globalcompanyinfomap["Division"],
                                        style: TextStyle(color: Colors.grey[600]))),
                                  ],):Center(),

                                  (globallabelinfomap['location']!="" && globalcompanyinfomap["Location"]!="")?SizedBox(height: 10.0,):Center(),
                                  (globallabelinfomap['location']!="" && globalcompanyinfomap["Location"]!="")?
                                  Row(children: <Widget>[
                                    Container(child: Text(globallabelinfomap["location"],style: TextStyle(fontWeight: FontWeight.w600),),
                                      width: 150.0,),
                                    Flexible(child: Text(globalcompanyinfomap["Location"],
                                        style: TextStyle(color: Colors.grey[600]))),
                                  ],):Center(),

                                  (globallabelinfomap['depart']!="" && globalcompanyinfomap["Department"]!="")?SizedBox(height: 10.0,):Center(),
                                  (globallabelinfomap['depart']!="" && globalcompanyinfomap["Department"]!="")?
                                  Row(children: <Widget>[
                                    Container(child:Text(globallabelinfomap["depart"],style: TextStyle(fontWeight: FontWeight.w600),) ,
                                      width: 150.0,),
                                    Flexible(child: Text(globalcompanyinfomap["Department"],
                                        style: TextStyle(color: Colors.grey[600]))),
                                  ],):Center(),

                                  (globallabelinfomap['desig']!="" && globalcompanyinfomap["Designation"]!="")?SizedBox(height: 10.0,):Center(),
                                  (globallabelinfomap['desig']!="" && globalcompanyinfomap["Designation"]!="")?
                                  Row(children: <Widget>[
                                    Container(child:Text(globallabelinfomap["desig"],style: TextStyle(fontWeight: FontWeight.w600),),
                                      width: 150.0,),
                                    Flexible(child: Text(globalcompanyinfomap["Designation"],style: TextStyle(color: Colors.grey[600]))),
                                  ],):Center(),

                                  (globallabelinfomap['shift']!="" && globalcompanyinfomap["Shift"]!="")?SizedBox(height: 10.0,):Center(),
                                  (globallabelinfomap['shift']!="" && globalcompanyinfomap["Shift"]!="")?
                                  Row(children: <Widget>[
                                    Container(child:Text(globallabelinfomap["shift"],style: TextStyle(fontWeight: FontWeight.w600)) ,
                                      width: 150.0,),
                                    Flexible(child: Text(globalcompanyinfomap["Shift"],style: TextStyle(color: Colors.grey[600]))),
                                  ],):Center(),

                                  SizedBox(height: 15.0,),

                                ],
                              ),
                            ),
                          ),
                        ),

                        (globallabelinfomap['reporting_to']!="" && globalcompanyinfomap["ReportingTo"]!="")? Container(
                          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          decoration: new ShapeDecoration(
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                            color: Colors.grey[100],
                          ),
                          child:
                          StickyHeader(
                            header: new Container(
                              //height: 50.0,
                              height: MediaQuery.of(context).size.height*0.06,
                              color: Colors.grey[100],
                              padding: new EdgeInsets.symmetric(horizontal: 9.0),
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                globallabelinfomap["reporting_to"],
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                            content: new Container(
                              padding: new EdgeInsets.symmetric(horizontal: 9.0),
                              child: Column(
                                children: <Widget>[
                                  // SizedBox(height: 10.0,),
                                  Row(children: <Widget>[
                                    Container(child:Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: _checkLoaded ? AssetImage('assets/default.png') : reporttoprofileimage,
                                            )
                                        ))
                                    ),SizedBox(width: 20.0,),
                                    Flexible(child: Text(globalcompanyinfomap["ReportingTo"]+"\n("+globalcompanyinfomap["ReportingToDesignation"]+")")),
                                  ],),
                                  SizedBox(height: 10.0,),
                                ],
                              ),
                            ),
                          ),
                        ):Center(),


                        Container(
                          //height: MediaQuery.of(context).size.height,
                          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          //width: MediaQuery.of(context).size.width*0.9,
                          decoration: new ShapeDecoration(
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                            color: Colors.grey[100],
                          ),
                          child:
                          StickyHeader(
                            header: new Container(
                              //height: 50.0,
                              height: MediaQuery.of(context).size.height*0.06,
                              color: Colors.grey[100],
                              padding: new EdgeInsets.symmetric(horizontal: 9.0),
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                'Contact Info',
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                            content: new Container(
                              padding: new EdgeInsets.symmetric(horizontal: 9.0),
                              child: Column(
                                children: <Widget>[
                                  (globallabelinfomap['personal_no']!="" && globalcontactusinfomap["Phone"]!="")?
                                  Row(children: <Widget>[
                                    Container(child:Text(globallabelinfomap["personal_no"],style: TextStyle(fontWeight: FontWeight.w600)) ,
                                      width: 150.0,),
                                    Text(globalcontactusinfomap["Phone"],style: TextStyle(color: Colors.grey[600])),
                                  ],):Center(),

                                  (globallabelinfomap['current_email_id']!="" && globalcompanyinfomap["CompanyEmail"]!="")?SizedBox(height: 10.0,):Center(),
                                  (globallabelinfomap['current_email_id']!="" && globalcompanyinfomap["CompanyEmail"]!="")?Row(children: <Widget>[
                                    Container(child:Text(globallabelinfomap["current_email_id"],style: TextStyle(fontWeight: FontWeight.w600)) ,
                                      width: 150.0,),
                                    Flexible(child: Text(globalcompanyinfomap["CompanyEmail"],style: TextStyle(color: Colors.grey[600])))
                                  ],):Center(),

                                  (globallabelinfomap['current_city']!="" && globalcontactusinfomap["City"]!="")?SizedBox(height: 10.0,):Center(),
                                  (globallabelinfomap['current_city']!="" && globalcontactusinfomap["City"]!="")?
                                  Row(children: <Widget>[
                                    Container(child:Text(globallabelinfomap["current_city"],style: TextStyle(fontWeight: FontWeight.w600),) ,
                                      width: 150.0,),
                                    Text(globalcontactusinfomap["City"],style: TextStyle(color: Colors.grey[600])),
                                  ],):Center(),

                                  (globallabelinfomap['current_country']!="" && globalcontactusinfomap["Country"]!="")?SizedBox(height: 10.0,):Center(),
                                  (globallabelinfomap['current_country']!="" && globalcontactusinfomap["Country"]!="")?
                                  Row(children: <Widget>[
                                    Container(child:Text(globallabelinfomap["current_country"],style: TextStyle(fontWeight: FontWeight.w600),) ,
                                      width: 150.0,),
                                    Text(globalcontactusinfomap["Country"],style: TextStyle(color: Colors.grey[600])),
                                  ],):Center(),

                                  SizedBox(height: 15.0,),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ],),
                    ),
                  ),  ],),
                /////////

                //////// Team /////////

                Column(children: <Widget>[

                  SizedBox(height: height),
                  new Expanded(
                    child: Container(
                        height: insideContainerHeight,
                        width: 400.0,
                        //color: Colors.green[50],
                        child: FutureBuilder<List<Team>>(
                          future: getTeamList(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if(snapshot.data.length>0) {
                                print("snapshot.data.length");
                                print(snapshot.data.length);
                                return new ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      toreportprofileimage = new NetworkImage(snapshot.data[index].ProfilePic);
//                                      if(snapshot.data[index].juniorlist==null)
                                        return ListTile(
                                          leading: new Container(child:Padding(
                                            padding: const EdgeInsets.only(top:0.0),
                                            child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                decoration: new BoxDecoration(
                                                    color:Colors.grey[300],
                                                    shape: BoxShape.circle,
                                                    image: new DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image:  toreportprofileimage,
                                                    )
                                                )),
                                          )
                                          ),
                                          title:Text(snapshot.data[index].FirstName+" "+(snapshot.data[index].LastName.toString()!="null"?snapshot.data[index].LastName.toString():"")),
                                        );
                                      //print("snapshot.data[index].juniorlist.length");
                                      //print(snapshot.data[index].juniorlist.length.toString());
/*                                      return ExpansionTile(
                                        leading: Container(
                                            width: 50.0,
                                            height: 50.0,
                                            decoration: new BoxDecoration(
                                                color:Colors.grey[300],
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  //image: NetworkImage(snapshot.data[index].ProfilePic) ,
                                                  image:  toreportprofileimage,
                                                  //image: _checkLoadedr ? AssetImage('assets/avatar.png') : toreportprofileimage,
                                                )
                                            )
                                        ),
                                        title:Text(snapshot.data[index].FirstName+" "+(snapshot.data[index].LastName.toString()!="null"?snapshot.data[index].LastName.toString():"")),
                                        children: <Widget>[
                                          Container(
                                              margin: EdgeInsets.only(top: 5, left: 50, right: 0, bottom: 5),
                                              height: MediaQuery.of(context).size.height*0.2,
                                              child: ListView.builder(
                                                  itemCount: snapshot.data[index].juniorlist.length,
                                                  itemBuilder: (BuildContext context, int juniorIndex){
                                                    //print("juniorIndex");
                                                    //print(juniorIndex);
                                                    return ListTile(
                                                      leading: new Container(child:Padding(
                                                        padding: const EdgeInsets.only(top:0.0),
                                                        child: Container(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            decoration: new BoxDecoration(
                                                                color:Colors.grey[300],
                                                                shape: BoxShape.circle,
                                                                image: new DecorationImage(
                                                                  fit: BoxFit.fill,
                                                                  image: NetworkImage(snapshot.data[index].juniorlist[juniorIndex]["ProfilePic"]) ,
                                                                )
                                                            )),
                                                      )
                                                      ),
                                                      title:Text(snapshot.data[index].juniorlist[juniorIndex]["FirstName"].toString()+" "+(snapshot.data[index].juniorlist[juniorIndex]["LastName"].toString()!="null"?snapshot.data[index].juniorlist[juniorIndex]["LastName"].toString():"")),
                                                    );
                                                  }
                                              )
                                          ),
                                        ],
                                      );*/
                                    }
                                );
                              }else{
                                return new Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*1,
                                    color: appStartColor().withOpacity(0.1),
                                    padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                    child:Text("No Team Found",style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                                  ),
                                );
                              }
                            }
                            else if (snapshot.hasError) {
                              return new Text("Unable to connect server");
                            }

                            // By default, show a loading spinner
                            return new Center( child: CircularProgressIndicator());
                          },
                        )
                    ),
                  ),],)
              ],
            ),
          ),
        ),
        bottomNavigationBar:new HomeNavigation(),),
    );
  }

  showProfile() {
    Navigator.pushNamed(context, '/profile');
  }

  void showBottomNavigation() {
    controller = _scaffoldKey.currentState
        .showBottomSheet<Null>((BuildContext context) {
      //  showRoundedModalBottomSheet(
      // context: context,
      //  radius: 190.0,
      //   radius: 190.0, // This is the default
      // color:Colors.lightGreen.withOpacity(0.9),
      // color:Colors.grey[300],
      //   color:Colors.cyan[200].withOpacity(0.7),
      //  builder: (BuildContext bc){
      return new Container(
          color: Colors.green.withOpacity(0.2),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Update profile photo", style: TextStyle(fontWeight: FontWeight.bold),)
                ],),
              SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        new RawMaterialButton(
                          onPressed: () {
                            controller.close();
                            updatePhoto(1);
                          },
                          child: new Icon(
                            Icons.photo,
                            size: 18.0,
                          ),
                          shape: new CircleBorder(),
                          elevation: 0.5,
                          fillColor: appEndColor(),
                          padding: const EdgeInsets.all(1.0),
                        ),
                        Text("Gallery\n")
                      ]
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        new RawMaterialButton(
                          onPressed: () {
                            controller.close();
                            updatePhoto(2);
                          },
                          child: new Icon(
                            Icons.camera_alt,
                            size: 18.0,
                          ),
                          shape: new CircleBorder(),
                          elevation: 0.5,
                          fillColor: appEndColor(),
                          padding: const EdgeInsets.all(1.0),
                        ),
                        Text("Camera\n")
                      ]
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        new RawMaterialButton(
                          onPressed: () {
                            controller.close();
                            updatePhoto(3);
                          },
                          child: new Icon(
                            Icons.delete,
                            size: 18.0,
                          ),
                          shape: new CircleBorder(),
                          elevation: 0.5,
                          fillColor: appEndColor(),
                          padding: const EdgeInsets.all(1.0),
                        ),
                        Text("Remove\n photo")
                      ]
                  )
                ],
              ),
              SizedBox(height: 20.0,),
              Divider(color: Colors.black,height: 3.0,),
              Container(
                  color: appStartColor().withOpacity(0.15),
                  child:Column(
                    children: <Widget>[
                      Center(
                          child:FlatButton(
                            shape: Border.all(color: Colors.orange[800]),
                            child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
                            onPressed: (){
                              controller.close();
                            },)
                      )
                    ],
                  )
              )

            ],
          ));
    }
    );
    //  }
    // );
  }

  updatePhoto(int uploadtype) async{
    setState(() {
      _isProfileUploading = true;
    });
    profileup ns = profileup();
    String isupdate = await ns.updateProfilePhoto(uploadtype,empid,organization);
    if(isupdate=="true"){
      if(uploadtype==3){
        setState(() {
          _checkLoadedprofile = true;
        });
        print("Profile image has been removed successfully");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CollapsingTab()),
        );
        showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: new Text(
                  "Profile image has been removed successfully"),
            );
          });
      }else{
        setState(() {
          _isProfileUploading = false;
        });
        print("Profile image has been changed successfully");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CollapsingTab()),
        );
        showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: new Text("Profile image has been changed successfully"),
            );
          });
      }
    }else if(isupdate=="1"){
      setState(() {
        _isProfileUploading = false;
      });
      print("No found to remove");
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            content: new Text("No image found to remove"),
          );
        });
    }else{
      setState(() {
        _isProfileUploading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CollapsingTab()),
      );
      print("error in changing profile image");
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            content: new Text("No image has been selected, Please try again"),
          );
        });
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
