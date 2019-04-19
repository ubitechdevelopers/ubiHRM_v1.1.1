import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'global.dart';
import 'model/model.dart';
import 'services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'b_navigationbar.dart';


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
  Employee emp;
  var reporttoprofileimage;
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
                image: AssetImage('assets/avatar.png'),
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

     emp = new Employee(employeeid: empid, organization: organization);
//print("-1111111111111"+emp.employeeid);
//print ("22222222222222"+empid);
   // if(empid!='')
     // bool ish = await getAllPermission(emp);

    reporttoprofileimage = new NetworkImage( globalcompanyinfomap['ReportingToProfilePic']);
    reporttoprofileimage.resolve(new ImageConfiguration()).addListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoaded = false;
        });

      }
    });


   // profilepic =prefs.getString('profilepic')??"";
   // profileimage = new NetworkImage(profilepic);
    profileimage = new NetworkImage( globalcompanyinfomap['ProfilePic']);
  //  print("ABC"+profileimage);
    profileimage.resolve(new ImageConfiguration()).addListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoadedprofile = false;
        });

      }
    });
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
      automaticallyImplyLeading: false,
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
/*
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                       image: new DecorationImage(
                          fit: BoxFit.fill,
                          image:AssetImage('assets/spinner.gif'),
                        )
                    )*/
                    ):Container(
                margin: EdgeInsets.only(
                    top: 30.0),
                height: 100.0,
                width: 100.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: new DecorationImage(
                    //image: new ExactAssetImage("assets/avatar.png"),

                    fit: BoxFit.fill,
                    //image: NetworkImage(globalcompanyinfomap['ProfilePic']),
                    image: _checkLoadedprofile ? AssetImage('assets/avatar.png') : profileimage,
                   // fit: BoxFit.cover,
                  ),
                  //border:
                  //Border.all(color: Colors.black, width: 2.0),

                ),
              ),
      ),
            /*  new Positioned(
              left: MediaQuery.of(context).size.width*.11,
                top: MediaQuery.of(context).size.height*.09,
                child: new RawMaterialButton(
                  onPressed: () {
                   // controller.close();
                    showBottomNavigation();
                  },
                  child: new Icon(
                    Icons.camera_alt,
                    size: 18.0,
                  ),
                  shape: new CircleBorder(),
                  elevation: 0.5,
                  fillColor: Colors.teal,
                  padding: const EdgeInsets.all(1.0),
                ),
              ),*/


        ]),

             Text(globalpersnalinfomap["FirstName"]+" "+globalpersnalinfomap["LastName"],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  )),
              SizedBox(height: 5.0,),
              Text(globalcompanyinfomap['CompanyEmail'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  )),
              Text(globalcompanyinfomap['Designation'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ))

            ]),

      ),
      /*actions: <Widget>[
        new Padding(
          padding: EdgeInsets.all(5.0),
          child: _buildActions(),
        ),
      ],*/
    );

    return Scaffold(
  key: _scaffoldKey,
      body: new DefaultTabController(
       length: 3,
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
                          icon: Icon(Icons.account_box),
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
                  width: 400.0,
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
                          height: 50.0,
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
                             // SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                Container(child:Text("Name:",style: TextStyle(color: Colors.grey[600]),) ,
                                width: 100.0,),
                                Text(globalpersnalinfomap["FirstName"]+" "+globalpersnalinfomap["LastName"]),
                              ],),

                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                Container(child:Text("DOB:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                                Text(globalpersnalinfomap["DOB"]),
                              ],),

                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                  Container(child:Text("Emp Code:",style: TextStyle(color: Colors.grey[600]),) ,
                                    width: 100.0,),

                                Text(globalcompanyinfomap["EmpCode"]),
                              ],),
                              /* SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                new Expanded(
                                  child:Container(child:Text("Email:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),),
                                Text(globalcompanyinfomap["CompanyEmail"]),
                              ],),*/
                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                //new Expanded(
                                 Container(child:Text("Designation:",style: TextStyle(color: Colors.grey[600]),) ,
                                    width: 100.0,),
                                //),
                                Text(globalcompanyinfomap["Designation"]),
                              ],),
                              /*  SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                new Expanded(
                                  child:Container(child:Text("Reporting To:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),),
                                Text(globalcompanyinfomap["ReportingTo"]),
                              ],),*/
                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[

                                  Container(child:Text("Department:",style: TextStyle(color: Colors.grey[600]),) ,
                                    width: 100.0,),
                                Text(globalcompanyinfomap["Department"]),
                              ],),
                            /*  SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                Container(child:Text("Blood Group:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                                Text(globalpersnalinfomap["BloodGroup"]),
                              ],),
                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                Container(child:Text("Nationality:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                                Text(globalpersnalinfomap["Nationality"]),
                              ],),
                              SizedBox(height: 10.0,),*/

                            ],
                          ),
                        ),
                      ),
                    ),

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
                          height: 50.0,
                          color: Colors.grey[100],
                          padding: new EdgeInsets.symmetric(horizontal: 9.0),
                          alignment: Alignment.centerLeft,
                          child: new Text(
                            'Reporting to',
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
                                        //  image: NetworkImage(globalcompanyinfomap['ReportingToProfilePic']) ,
                                          image: _checkLoaded ? AssetImage('assets/avatar.png') : reporttoprofileimage,
                                        )
                                    ))
                                ),SizedBox(width: 20.0,),
                                Text(globalcompanyinfomap["ReportingTo"]),
                                Text("-"),
                                Text(globalcompanyinfomap["ReportingToDesignation"]),
                              ],),

                              SizedBox(height: 10.0,),

                            ],
                          ),
                        ),
                      ),
                    ),


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
                          height: 50.0,
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
                              // SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                               // new Expanded(
                                    Container(child:Text("Phone:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                               // ),
                                Text(globalcontactusinfomap["Phone"]),
                              ],),
                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                              //  new Expanded(child:
                                Container(child:Text("Email:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                                  //),
                                Text(globalcontactusinfomap["Email"]),
                              ],),
                         /*     SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                new Expanded(
                                  child: Container(child:Text("Address:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),),
                                Text(globalcontactusinfomap["Address"]),
                              ],),
                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                new Expanded(
                                  child: Container(child:Text("Postal Code:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),),
                                Text(globalcontactusinfomap["PostalCode"]),
                              ],),*/

                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                               // new Expanded( child:
                                  Container(child:Text("City:",style: TextStyle(color: Colors.grey[600]),) ,
                                    width: 100.0,),
                                //),
                                Text(globalcontactusinfomap["City"]),
                              ],),
                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                               // new Expanded(child:
                                Container(child:Text("Country:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                                //),
                                Text(globalcontactusinfomap["Country"]),
                              ],),
                              SizedBox(height: 10.0,),

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
                          return new ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.length,

                          itemBuilder: (BuildContext context, int index) {toreportprofileimage = new NetworkImage( snapshot.data[index].ProfilePic);
                                /*toreportprofileimage.resolve(new ImageConfiguration()).addListener((_, __) {
                                  if (mounted) {
                                    setState(() {
                                      _checkLoadedr = false;
                                    });
                                  }
                                });*/



                            return new Row(
                              children: <Widget>[
                                 new Container(child:Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: new BoxDecoration(
                                        color:Colors.grey[300],
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,

                                          // image: NetworkImage(snapshot.data[index].ProfilePic) ,

                                         image:  toreportprofileimage,
                                   //      image: _checkLoadedr ? AssetImage('assets/avatar.png') : toreportprofileimage,
                                          )
                                      ))
                                  ),SizedBox(width: 20.0,),
                                  Text(snapshot.data[index].FirstName+" "+snapshot.data[index].LastName),
                                  //Text("-"),
                                 // Text(snapshot.data[index].Designation),


                                ],

                            );

                              }
                          );
                        }else{
                          return new Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width*1,
                              color: Colors.teal.withOpacity(0.1),
                              padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                              child:Text("No Team Found ",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
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
      bottomNavigationBar:new HomeNavigation(),);
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
                          fillColor: Colors.teal[100],
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
                          fillColor: Colors.teal[100],
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
                          fillColor: Colors.teal[100],
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
                  color: Colors.teal.withOpacity(0.15),
                  child:Column(
                    children: <Widget>[
                      Center(
                          child:FlatButton(child:Text("Cancel"),onPressed: (){
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
    bool isupdate = await ns.updateProfilePhoto(uploadtype,empid,organization);
    // bool isupdate = true;
    if(isupdate){
      setState(() {
        _isProfileUploading = false;
      });
      if(uploadtype==3){
        setState(() {
          _checkLoadedr = true;
        });
      }
      showDialog(context: context, child:
      new AlertDialog(
        content: new Text("Profile image has been changed."),
      )
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CollapsingTab()),
      );
    }else{
      setState(() {
        _isProfileUploading = false;
      });
      showDialog(context: context, child:
      new AlertDialog(
        //title: new Text("Congrats!"),
        content: new Text("Couldn't load this photo, Please try again."),
      )
      );
    }
  }

  updateProfile(String mobile, String countryid) async{
    var profile = Profile(empid, organization, mobile, countryid);
    profileup ns = profileup();
    var islogin = await ns.updateProfile(profile);
    //print(islogin);
    if(islogin=="success"){
      getProfileInfo(emp);
      setState(() {
        _isButtonDisabled=false;
      });
      /* Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );*/
      showDialog(context: context, child:
      new AlertDialog(
        title: new Text("Congrats!"),
        content: new Text("Your Profile is updated."),
      )
      );
    }else if(islogin=="failure"){
      setState(() {
        _isButtonDisabled=false;
      });
      showDialog(context: context, child:
      new AlertDialog(
        title: new Text("Sorry!"),
        content: new Text("Phone no. already exists"),
      )
      );
    }else{
      setState(() {
        _isButtonDisabled=false;
      });
      showDialog(context: context, child:
      new AlertDialog(
        title: new Text("Sorry!"),
        content: new Text("Poor network connection."),
      )
      );
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
