
import 'package:flutter/material.dart';
import 'global.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'home.dart';


class TabbedApp extends StatefulWidget {
  @override
  _TabState createState() => _TabState();
}

class _TabState extends State<TabbedApp> {

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: choices.length,

        child: Scaffold(

          appBar:PreferredSize(
            preferredSize: Size.fromHeight(100.0),
         child: GradientAppBar(

           backgroundColorStart: appStartColor(),
           backgroundColorEnd: appEndColor(),

           // title: const Text('Approvals'),
           title: Row(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               new Container(
                   width: 40.0,
                   height: 40.0,
                   decoration: new BoxDecoration(
                       shape: BoxShape.circle,
                       image: new DecorationImage(
                         fit: BoxFit.fill,
                         image: AssetImage('assets/avatar.png'),
                       )
                   )),
               Container(
                   padding: const EdgeInsets.all(8.0), child: Text('Approvals')
               )
             ],

           ),



actions:<Widget>[
 /* new Container(
      width: 65.0,
      height: 85.0,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            fit: BoxFit.fill,
            //  image: NetworkImage(globalcompanyinfomap['ProfilePic']),
           // image: _checkLoaded ? AssetImage('assets/avatar.png') : NetworkImage//(globalcompanyinfomap['ProfilePic']),
            image:AssetImage('assets/avatar.png'),
          )
      )),*/
    new DropdownButton<String>(
      hint: new Text("My Approvals" , style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      )),
      items: <String>['My Approvals', 'My Request'].map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value),

        );
      }).toList(),
      onChanged: (_) {},
    )


],
            bottom: TabBar(

              isScrollable: true,
              tabs: choices.map((Choice choice) {
                return Tab(
                  text: choice.title,
                 // icon: Icon(choice.icon),
                );
              }).toList(),
            ),
          ),),





          body: TabBarView(
            children: choices.map((Choice choice) {
              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: ChoiceCard(choice: choice),
              );
            }).toList(),
          ),




          bottomNavigationBar:new Theme(
              data: Theme.of(context).copyWith(
                // sets the background color of the `BottomNavigationBar`
                canvasColor: bottomNavigationColor(),
              ), // sets the inactive color of the `BottomNavigationBar`
              child:  BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (newIndex) {
                  if (newIndex == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                    return;
                  }
                  if (newIndex == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TabbedApp()),
                    );
                    return;
                  } else if (newIndex == 0) {
                    /* (admin_sts == '1')
                  ? Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Reports()),
              )
                  : Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );*/

                    return;
                  }

                  setState(() {
                    _currentIndex = newIndex;
                  });
                }, // this will be set when a new tab is tapped
                items: [
                  BottomNavigationBarItem(

                    icon:  new Image.asset("assets/repo.ico", height: 25.0, width: 30.0),

                    //   new Tab(icon: new Image.asset("assets/img/logo.png"), text: "Browse"),
                    /* icon: new Icon(
                    Icons.library_books,
                    color: Colors.white,
                  ),*/
                    title: new Text('Reports',style: TextStyle(color: Colors.white)),
                  ),
                  BottomNavigationBarItem(
                    /*   icon: new Icon(
                    Icons.home,
                    color: Colors.orangeAccent,
                  ),*/
                    icon:  new Image.asset("assets/Hom.png", height: 30.0, width: 30.0),

                    title: new Text('Home', style: TextStyle(color: Colors.orangeAccent)),

                  ),
                  BottomNavigationBarItem(
                    icon:  new Image.asset("assets/reporr.png", height: 30.0, width:                    30.0),
                    title: new Text('Approvals',style: TextStyle(color: Colors.white)),
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      title: Text('Settings',style: TextStyle(color: Colors.white)))
                ],
              )),
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'PENDING'),
  const Choice(title: 'APPROVED'),
  const Choice(title: 'REJECTED'),
 // const Choice(title: 'REJECTED', icon: Icons.directions_boat),

];

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

        margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        // width: MediaQuery.of(context).size.width*0.9,
        decoration: new ShapeDecoration(
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
          color: Colors.white,
        ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    ),]
    ),
    );
  }
}

