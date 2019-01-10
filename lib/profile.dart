import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'global.dart';

class CollapsingTab extends StatefulWidget {
  @override
  _CollapsingTabState createState() => new _CollapsingTabState();
}

class _CollapsingTabState extends State<CollapsingTab> {
  ScrollController scrollController;
  double height = 0.0;
  double insideContainerHeight=350.0;

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

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
    scrollController.addListener(() => setState(() {}));
    scrollController.addListener(_scrollListener);
  }

  _scrollListener() {

    /*double scale;
    if (scrollController.hasClients) {
      scale = scrollController.offset / 300;
      scale = scale * 2;
      print(scale.toString());
      if (scale > 1) {
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
      }
    }*/

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        height=150.0;
        insideContainerHeight=450.0;
        print("reach the bottom "+height.toString());
      });
    }
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        height=0.0;
        insideContainerHeight=300.0;
        print("reach the top "+height.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    var flexibleSpaceWidget = new SliverAppBar(

      expandedHeight: 200.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(

        centerTitle: true,
        title:Column(children:<Widget>[
          SizedBox(height: 30.0,),
          Text(globalpersnalinfomap['FirstName'],
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
              SizedBox(height: 40.0,),
              Container(
                height: 100.0,
                width: 100.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                  image: new DecorationImage(
                    image: new ExactAssetImage("assets/avatar.png"),
                    fit: BoxFit.cover,
                  ),
                  //border:
                  //Border.all(color: Colors.black, width: 2.0),

                ),
              ),
              Text(globalpersnalinfomap['FirstName'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  )),
              SizedBox(height: 10.0,),
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
                Container(
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
                                Container(child:Text("Father:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                                Text(globalpersnalinfomap["FatherName"]),
                              ],),
                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                Container(child:Text("DOB:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                                Text(globalpersnalinfomap["DOB"]),
                              ],),
                              SizedBox(height: 10.0,),
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
                            'Reporting To',
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
                                          image: NetworkImage(globalcompanyinfomap['ReportingToProfilePic']) ,
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
                            'Company Info',
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                        content: new Container(
                          padding: new EdgeInsets.symmetric(horizontal: 9.0),
                          child: Column(
                            children: <Widget>[
                              // SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                Container(child:Text("Emp Code:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                                Text(globalcompanyinfomap["EmpCode"]),
                              ],),
                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                Container(child:Text("Company Email:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                                Text(globalcompanyinfomap["CompanyEmail"]),
                              ],),
                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                Container(child:Text("Designation:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                                Text(globalcompanyinfomap["Designation"]),
                              ],),
                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                Container(child:Text("Reporting To:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                                Text(globalcompanyinfomap["ReportingTo"]),
                              ],),
                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                Container(child:Text("Department:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                                Text(globalcompanyinfomap["Department"]),
                              ],),
                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                Container(child:Text("Location:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                                Text(globalcompanyinfomap["Location"]),
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
                                Container(child:Text("Phone:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                                Text(globalcontactusinfomap["Phone"]),
                              ],),
                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                Container(child:Text("Email:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                                Text(globalcontactusinfomap["Email"]),
                              ],),
                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                Container(child:Text("Address:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                                Text(globalcontactusinfomap["Address"]),
                              ],),
                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                Container(child:Text("Postal Code:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                                Text(globalcontactusinfomap["PostalCode"]),
                              ],),
                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                Container(child:Text("City:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
                                Text(globalcontactusinfomap["City"]),
                              ],),
                              SizedBox(height: 10.0,),
                              Row(children: <Widget>[
                                Container(child:Text("Country:",style: TextStyle(color: Colors.grey[600]),) ,
                                  width: 100.0,),
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
              ],),
              /////////

              //////// Team /////////

              Column(children: <Widget>[
                SizedBox(height: height),
                Container(
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
                          //color: Colors.grey[100],
                          padding: new EdgeInsets.symmetric(horizontal: 9.0),
                          alignment: Alignment.centerLeft,
                          child: new Text(
                            '',
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
                                          image: NetworkImage(globalcompanyinfomap['ReportingToProfilePic']) ,
                                        )
                                    ))
                                ),SizedBox(width: 20.0,),
                                Text(globalcompanyinfomap["ReportingTo"]),
                                Text("-"),
                                Text(globalcompanyinfomap["ReportingToDesignation"]),
                              ],),

                              SizedBox(height: 10.0,),

                              Row(children: <Widget>[
                                Container(child:Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(globalcompanyinfomap['ReportingToProfilePic']) ,
                                        )
                                    ))
                                ),SizedBox(width: 20.0,),
                                Text(globalcompanyinfomap["ReportingTo"]),
                                Text("-"),
                                Text(globalcompanyinfomap["ReportingToDesignation"]),
                              ],),

                              SizedBox(height: 10.0,),

                              Row(children: <Widget>[
                                Container(child:Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(globalcompanyinfomap['ReportingToProfilePic']) ,
                                        )
                                    ))
                                ),SizedBox(width: 20.0,),
                                Text(globalcompanyinfomap["ReportingTo"]),
                                Text("-"),
                                Text(globalcompanyinfomap["ReportingToDesignation"]),
                              ],),

                              SizedBox(height: 10.0,),

                              Row(children: <Widget>[
                                Container(child:Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(globalcompanyinfomap['ReportingToProfilePic']) ,
                                        )
                                    ))
                                ),SizedBox(width: 20.0,),
                                Text(globalcompanyinfomap["ReportingTo"]),
                                Text("-"),
                                Text(globalcompanyinfomap["ReportingToDesignation"]),
                              ],),

                              SizedBox(height: 10.0,),

                              Row(children: <Widget>[
                                Container(child:Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(globalcompanyinfomap['ReportingToProfilePic']) ,
                                        )
                                    ))
                                ),SizedBox(width: 20.0,),
                                Text(globalcompanyinfomap["ReportingTo"]),
                                Text("-"),
                                Text(globalcompanyinfomap["ReportingToDesignation"]),
                              ],),

                              SizedBox(height: 10.0,),

                              Row(children: <Widget>[
                                Container(child:Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(globalcompanyinfomap['ReportingToProfilePic']) ,
                                        )
                                    ))
                                ),SizedBox(width: 20.0,),
                                Text(globalcompanyinfomap["ReportingTo"]),
                                Text("-"),
                                Text(globalcompanyinfomap["ReportingToDesignation"]),
                              ],),

                              SizedBox(height: 10.0,),

                              Row(children: <Widget>[
                                Container(child:Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(globalcompanyinfomap['ReportingToProfilePic']) ,
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






                  ],),
                ),
              ],)



            ],
          ),
        ),
      ),
    );
  }

  showProfile() {
    Navigator.pushNamed(context, '/profile');
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
