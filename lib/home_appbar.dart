import 'package:flutter/material.dart';
import 'global.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'profile.dart';
import 'services/services.dart';
/*
void main() => runApp(new HeaderApp());
final mTitle = "HeaderApp";
class HeaderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppHeader(),
      //... another code
    );
  }
}
*/
/*class AppHeader extends StatefulWidget  implements PreferredSizeWidget{
  // code removed for brevity
  _AppHeaderState createState() => _AppHeaderState();
}*/
class HomeAppHeader extends StatelessWidget implements PreferredSizeWidget {
  bool _checkLoadedprofile = true;
  var profileimage;
  bool showtabbar;
  var orgname;
  HomeAppHeader(profileimage1,showtabbar1,orgname1){
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
                        image: _checkLoadedprofile ? AssetImage('assets/avatar.png') : profileimage,
                      )
                  )
              ),
            ),
            Container(
                padding: const EdgeInsets.all(8.0), child: Text(orgname)
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