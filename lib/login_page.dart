import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'theme.dart' as Theme;
import 'bubble_indication_painter.dart';
import 'home.dart';
import 'package:ubihrm/model/model.dart';
import 'package:ubihrm/services/checkLogin.dart' as login;
import 'package:ubihrm/services/checkLogin.dart';

//import 'package:ubihrm/services/checkloginn.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'global.dart';
import 'package:ubihrm/model/user.dart';
import 'attandance/forgot_password.dart';
import 'package:barcode_scan/barcode_scan.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  bool _isServiceCalling = false;
  final _formKey = GlobalKey<FormState>();
  final _formKeyKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();
  final FocusNode myFocusNodephone = FocusNode();
  final FocusNode myFocusNodecity = FocusNode();
  final FocusNode myFocusNodeCPN = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  //TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupPhoneController = new TextEditingController();
  TextEditingController CPNController = new TextEditingController();
  TextEditingController signupcityController = new TextEditingController();

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;
  bool _isButtonDisabled = false;
  bool _obscureText_old = true;
  bool _obscureText_new = true;
  String barcode = "";
  bool loader = false;

  void _toggle_new() {
    setState(() {
      _obscureText_new = !_obscureText_new;
    });
  }
  setLocal(var fname, var empid, var  orgid) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('fname',fname);
    await prefs.setString('empid',empid);
    await prefs.setString('orgid',orgid);
  }
  SharedPreferences prefs;
  Map<String, dynamic>res;
  List<Map> _myJson = [{"id":"0","name":"Country"},{"id":"2","name":"Afghanistan"},{"id":"4","name":"Albania"},{"id":"50","name":"Algeria"},{"id":"5","name":"American Samoa"},{"id":"6","name":"Andorra"},{"id":"7","name":"Angola"},{"id":"11","name":"Anguilla"},{"id":"3","name":"Antigua and Barbuda"},{"id":"160","name":"Argentina"},{"id":"8","name":"Armenia"},{"id":"9","name":"Aruba"},{"id":"10","name":"Australia"},{"id":"1","name":"Austria"},{"id":"12","name":"Azerbaijan"},{"id":"27","name":"Bahamas"},{"id":"25","name":"Bahrain"},{"id":"14","name":"Bangladesh"},{"id":"15","name":"Barbados"},{"id":"29","name":"Belarus"},{"id":"13","name":"Belgium"},{"id":"30","name":"Belize"},{"id":"16","name":"Benin"},{"id":"17","name":"Bermuda"},{"id":"20","name":"Bhutan"},{"id":"23","name":"Bolivia"},{"id":"22","name":"Bosnia and Herzegovina"},{"id":"161","name":"Botswana"},{"id":"24","name":"Brazil"},{"id":"28","name":"British Virgin Islands"},{"id":"26","name":"Brunei"},{"id":"19","name":"Bulgaria"},{"id":"18","name":"Burkina Faso"},{"id":"21","name":"Burundi"},{"id":"101","name":"Cambodia"},{"id":"32","name":"Cameroon"},{"id":"34","name":"Canada"},{"id":"43","name":"Cape Verde"},{"id":"33","name":"Cayman Islands"},{"id":"163","name":"Central African Republic"},{"id":"203","name":"Chad"},{"id":"165","name":"Chile"},{"id":"205","name":"China"},{"id":"233","name":"Christmas Island"},{"id":"39","name":"Cocos Islands"},{"id":"38","name":"Colombia"},{"id":"40","name":"Comoros"},{"id":"41","name":"Cook Islands"},{"id":"42","name":"Costa Rica"},{"id":"36","name":"Cote dIvoire"},{"id":"90","name":"Croatia"},{"id":"31","name":"Cuba"},{"id":"44","name":"Cyprus"},{"id":"45","name":"Czech Republic"},{"id":"48","name":"Denmark"},{"id":"47","name":"Djibouti"},{"id":"226","name":"Dominica"},{"id":"49","name":"Dominican Republic"},{"id":"55","name":"Ecuador"},{"id":"58","name":"Egypt"},{"id":"57","name":"El Salvador"},{"id":"80","name":"Equatorial Guinea"},{"id":"56","name":"Eritrea"},{"id":"60","name":"Estonia"},{"id":"59","name":"Ethiopia"},{"id":"62","name":"Falkland Islands"},{"id":"63","name":"Faroe Islands"},{"id":"65","name":"Fiji"},{"id":"186","name":"Finland"},{"id":"61","name":"France"},{"id":"64","name":"French Guiana"},{"id":"67","name":"French Polynesia"},{"id":"69","name":"Gabon"},{"id":"223","name":"Gambia"},{"id":"70","name":"Gaza Strip"},{"id":"77","name":"Georgia"},{"id":"46","name":"Germany"},{"id":"78","name":"Ghana"},{"id":"75","name":"Gibraltar"},{"id":"81","name":"Greece"},{"id":"82","name":"Greenland"},{"id":"228","name":"Grenada"},{"id":"83","name":"Guadeloupe"},{"id":"84","name":"Guam"},{"id":"76","name":"Guatemala"},{"id":"72","name":"Guernsey"},{"id":"167","name":"Guinea"},{"id":"79","name":"Guinea-Bissau"},{"id":"85","name":"Guyana"},{"id":"168","name":"Haiti"},{"id":"218","name":"Holy See"},{"id":"87","name":"Honduras"},{"id":"89","name":"Hong Kong"},{"id":"86","name":"Hungary"},{"id":"97","name":"Iceland"},{"id":"93","name":"India"},{"id":"169","name":"Indonesia"},{"id":"94","name":"Iran"},{"id":"96","name":"Iraq"},{"id":"95","name":"Ireland"},{"id":"74","name":"Isle of Man"},{"id":"92","name":"Israel"},{"id":"91","name":"Italy"},{"id":"99","name":"Jamaica"},{"id":"98","name":"Japan"},{"id":"73","name":"Jersey"},{"id":"100","name":"Jordan"},{"id":"102","name":"Kazakhstan"},{"id":"52","name":"Kenya"},{"id":"104","name":"Kiribati"},{"id":"106","name":"Kosovo"},{"id":"107","name":"Kuwait"},{"id":"103","name":"Kyrgyzstan"},{"id":"109","name":"Laos"},{"id":"114","name":"Latvia"},{"id":"171","name":"Lebanon"},{"id":"112","name":"Lesotho"},{"id":"111","name":"Liberia"},{"id":"110","name":"Libya"},{"id":"66","name":"Liechtenstein"},{"id":"113","name":"Lithuania"},{"id":"108","name":"Luxembourg"},{"id":"117","name":"Macau"},{"id":"125","name":"Macedonia"},{"id":"172","name":"Madagascar"},{"id":"132","name":"Malawi"},{"id":"118","name":"Malaysia"},{"id":"131","name":"Maldives"},{"id":"173","name":"Mali"},{"id":"115","name":"Malta"},{"id":"124","name":"Marshall Islands"},{"id":"119","name":"Martinique"},{"id":"170","name":"Mauritania"},{"id":"130","name":"Mauritius"},{"id":"120","name":"Mayotte"},{"id":"123","name":"Mexico"},{"id":"68","name":"Micronesia"},{"id":"122","name":"Moldova"},{"id":"121","name":"Monaco"},{"id":"127","name":"Mongolia"},{"id":"126","name":"Montenegro"},{"id":"128","name":"Montserrat"},{"id":"116","name":"Morocco"},{"id":"129","name":"Mozambique"},{"id":"133","name":"Myanmar"},{"id":"136","name":"Namibia"},{"id":"137","name":"Nauru"},{"id":"139","name":"Nepal"},{"id":"142","name":"Netherlands"},{"id":"135","name":"Netherlands Antilles"},{"id":"138","name":"New Caledonia"},{"id":"146","name":"New Zealand"},{"id":"140","name":"Nicaragua"},{"id":"174","name":"Niger"},{"id":"225","name":"Nigeria"},{"id":"141","name":"Niue"},{"id":"145","name":"Norfolk Island"},{"id":"144","name":"North Korea"},{"id":"143","name":"Northern Mariana Islands"},{"id":"134","name":"Norway"},{"id":"147","name":"Oman"},{"id":"153","name":"Pakistan"},{"id":"150","name":"Palau"},{"id":"149","name":"Panama"},{"id":"155","name":"Papua New Guinea"},{"id":"157","name":"Paraguay"},{"id":"151","name":"Peru"},{"id":"178","name":"Philippines"},{"id":"152","name":"Pitcairn Islands"},{"id":"154","name":"Poland"},{"id":"148","name":"Portugal"},{"id":"156","name":"Puerto Rico"},{"id":"158","name":"Qatar"},{"id":"164","name":"Republic of the Congo"},{"id":"166","name":"Reunion"},{"id":"175","name":"Romania"},{"id":"159","name":"Russia"},{"id":"182","name":"Rwanda"},{"id":"88","name":"Saint Helena"},{"id":"105","name":"Saint Kitts and Nevis"},{"id":"229","name":"Saint Lucia"},{"id":"191","name":"Saint Martin"},{"id":"195","name":"Saint Pierre and Miquelon"},{"id":"232","name":"Saint Vincent and the Grenadines"},{"id":"230","name":"Samoa"},{"id":"180","name":"San Marino"},{"id":"197","name":"Sao Tome and Principe"},{"id":"184","name":"Saudi Arabia"},{"id":"193","name":"Senegal"},{"id":"196","name":"Serbia"},{"id":"200","name":"Seychelles"},{"id":"224","name":"Sierra Leone"},{"id":"187","name":"Singapore"},{"id":"188","name":"Slovakia"},{"id":"190","name":"Slovenia"},{"id":"189","name":"Solomon Islands"},{"id":"194","name":"Somalia"},{"id":"179","name":"South Africa"},{"id":"176","name":"South Korea"},{"id":"51","name":"Spain"},{"id":"37","name":"Sri Lanka"},{"id":"198","name":"Sudan"},{"id":"192","name":"Suriname"},{"id":"199","name":"Svalbard"},{"id":"185","name":"Swaziland"},{"id":"183","name":"Sweden"},{"id":"35","name":"Switzerland"},{"id":"201","name":"Syria"},{"id":"162","name":"Taiwan"},{"id":"202","name":"Tajikistan"},{"id":"53","name":"Tanzania"},{"id":"204","name":"Thailand"},{"id":"206","name":"Timor-Leste"},{"id":"181","name":"Togo"},{"id":"209","name":"Tonga"},{"id":"211","name":"Trinidad and Tobago"},{"id":"208","name":"Tunisia"},{"id":"210","name":"Turkey"},{"id":"207","name":"Turkmenistan"},{"id":"212","name":"Turks and Caicos Islands"},{"id":"213","name":"Tuvalu"},{"id":"219","name":"U.S. Virgin Islands"},{"id":"54","name":"Uganda"},{"id":"214","name":"Ukraine"},{"id":"215","name":"United Arab Emirates"},{"id":"71","name":"United Kingdom"},{"id":"216","name":"United States"},{"id":"177","name":"Uruguay"},{"id":"217","name":"Uzbekistan"},{"id":"221","name":"Vanuatu"},{"id":"235","name":"Venezuela"},{"id":"220","name":"Vietnam"},{"id":"222","name":"Wallis and Futuna"},{"id":"227","name":"West Bank"},{"id":"231","name":"Western Sahara"},{"id":"234","name":"Yemen"},{"id":"237","name":"Zaire"},{"id":"236","name":"Zambia"},{"id":"238","name":"Zimbabwe"}];
  String _country="0";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height >= 775.0
                  ? MediaQuery.of(context).size.height
                  : 775.0,
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Color.fromRGBO(0, 166, 90,1.0).withOpacity(0.9),
                      Color.fromRGBO(0, 166, 90,1.0).withOpacity(0.2)
                      /*Theme.Colors.loginGradientEnd*/
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child:ModalProgressHUD(inAsyncCall: _isServiceCalling,opacity: 0.5,progressIndicator: SizedBox(
                child:
                new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation(Colors.green),
                    strokeWidth: 5.0),
                height: 50.0,
                width: 50.0,),child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
             child: new Container(
               width: 135.0,
               height: 132.0,
               decoration: new BoxDecoration(
                 color: const Color(0xff7c94b6),
                 image: new DecorationImage(
                   image:new AssetImage('assets/img/logohrmbg.png'),
                   fit: BoxFit.cover,
                 ),
                 borderRadius: new BorderRadius.all(new Radius.circular(77.0)),
                // border: new Border.all(
                  // color: Colors.red,
                   //width: 4.0,
                // ),
               ),
             ),

                    /* Container(
                 // width: 100.0,
                //  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    color: Colors.redAccent,
                  ),
                    child: new Image(
                        width: 130.0,
                        height: 125.0,
                        fit: BoxFit.fill,

                        image: new AssetImage('assets/img/logohrmbg.png')),
                  ),*/
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                  //  child: _buildMenuBar(context),
                  ),
                  Expanded(
                    flex: 2,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (i) {
                        if (i == 0) {
                          setState(() {
                            right = Colors.white;
                            left = Colors.black;
                          });
                        } else if (i == 1) {
                          setState(() {
                            right = Colors.black;
                            left = Colors.white;
                          });
                        }
                      },
                      children: <Widget>[
                        new ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _buildSignIn(context),
                        ),
                        new ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _buildSignUp(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              )
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
  }



  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  String token1="";
  String tokenn="";


  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );

    gettokenstate();


  }
  gettokenstate() async{
    final prefs = await SharedPreferences.getInstance();
    _firebaseMessaging.getToken().then((token){
      token1 = token;
      prefs.setString("token1", token1);
      // print(tokenn);

      print(token1);

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

 /* Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Existing",
                  style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "New",
                  style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child:Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: 370.0,
                    height: 350.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                top: 20.0, bottom: 0.0, left: 230.0, right: 10.0), child:GestureDetector(
                          onTap: () {
                            scan().then((onValue){
                              print("******************** QR value **************************");
                              print(onValue);
                              markAttByQR(onValue,context,token1);
                            });
                          },
                          child:  Image.asset(
                            'assets/qr.png', height: 35.0, width: 35.0, alignment: Alignment.bottomRight,
                          ),
                        )),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0.0, bottom: 10.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodeEmailLogin,
                            controller: loginEmailController,
                            keyboardType: TextInputType.emailAddress,
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context).requestFocus(myFocusNodePasswordLogin);
                            },
                            style: TextStyle(

                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.userAlt,
                                color: Colors.black,
                                size: 22.0,
                              ),
                              hintText: "Email / Phone",
                              hintStyle: TextStyle(
                                   fontSize: 14.0),
                            ),
                            /*validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Email or Phone no.';
                            }
                          },*/

                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 0.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodePasswordLogin,
                            controller: loginPasswordController,
                            obscureText: _obscureText_new,
                            style: TextStyle(

                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                size: 22.0,
                                color: Colors.black,
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  fontSize: 14.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggle_new,
                                child: Icon(
                                _obscureText_new ?Icons.visibility_off:Icons.visibility,
                                  size: 30.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),

                            onFieldSubmitted: (String value) {

                              if (loginEmailController.text.trim().isNotEmpty && loginPasswordController.text.trim().isNotEmpty) {

                                checklogin(loginEmailController.text,loginPasswordController.text);
                              }else{

                                if(loginEmailController.text.trim().isEmpty) {
                                  showDialog(context: context, child:
                                  new AlertDialog(

                                    content: new Text("Please enter Email or Phone no."),
                                  )
                                  );
                                }else if(loginPasswordController.text.trim().isEmpty){
                                  showDialog(context: context, child:
                                  new AlertDialog(

                                    content: new Text("Please enter Password."),
                                  )
                                  );
                                }
                              }
                            },
                          ),





                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Container(
                          //   margin: EdgeInsets.only(top: 170.0),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                              top: 0.0, bottom: 0.0, left: 170.0, right: 10.0),

                          child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPassword()),
                            );

                              },
                              child: Text(
                                "Forgot Password ?",
                                style: TextStyle(

                                    color:appStartColor(),
 fontSize: 14,
                                    ),
                              )
                          ),
                        ),

                        Container(
                       //   margin: EdgeInsets.only(top: 170.0),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                              top: 0.0, bottom: 0.0, left: 25.0, right: 25.0),
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            /*  boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.Colors.loginGradientStart,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                      BoxShadow(
                        color: Theme.Colors.loginGradientEnd,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                    ],*/
                            /*  gradient: new LinearGradient(
                        colors: [
                          Theme.Colors.loginGradientEnd,
                          Theme.Colors.loginGradientStart
                        ],
                        begin: const FractionalOffset(0.2, 0.2),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),*/
                          ),
                          child:  ButtonTheme(
                            minWidth: 200.0,
                            height: 40.0,
                            child: RaisedButton(
                            /*highlightColor: Colors.transparent,
                    splashColor: Theme.Colors.loginGradientEnd,*/
                              color: Color.fromRGBO(0, 166, 90,1.0),
                              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              /* shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),*/
                              child: Padding(
                                padding: const EdgeInsets.symmetric( vertical: 11.0, horizontal: 44.0),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (loginEmailController.text.trim().isNotEmpty && loginPasswordController.text.trim().isNotEmpty) {

                                  checklogin(loginEmailController.text.trim(),loginPasswordController.text.trim(),);
                                }else{

                                  if(loginEmailController.text.trim().isEmpty) {
                                    showDialog(context: context, child:
                                    new AlertDialog(

                                      content: new Text("Please enter Email or Phone no."),
                                    )
                                    );
                                  }else if(loginPasswordController.text.trim().isEmpty){
                                    showDialog(context: context, child:
                                    new AlertDialog(
                                      content: new Text("Please enter Password."),
                                    )
                                    );
                                  }
                                }


                              }
                          ),
                          ),
                        ),


              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(child: Container(
                   margin: EdgeInsets.only(left: 75.0,right:0.0,top: 10.0),

                        child:Text("Not registered ?", style: TextStyle(
                          color: appStartColor(),fontSize: 14,),),
                  ),),
                       Expanded(child: Container(
                          //margin: EdgeInsets.only(top: 250.0),
                            //width: MediaQuery.of(context).size.width,

                           padding: EdgeInsets.only(
                               top: 10.0, bottom: 0.0, left: 05.0, right: 25.0),
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              /*  boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.Colors.loginGradientStart,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                      BoxShadow(
                        color: Theme.Colors.loginGradientEnd,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                    ],*/
                              /*  gradient: new LinearGradient(
                        colors: [
                          Theme.Colors.loginGradientEnd,
                          Theme.Colors.loginGradientStart
                        ],
                        begin: const FractionalOffset(0.2, 0.2),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),*/
                            ),


                            child: new RaisedButton(
                             // color:appStartColor(),
                              color:Colors.orange,

                              child: new Text("Sign up", style: TextStyle(
                                color:  Colors.white,
                                fontSize: 16.0,),),
                                onPressed: _onSignUpButtonPress,
                            // borderSide: BorderSide(color:  appStartColor()),
                              /* shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))*/

                            )




                        ),),

]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

        /*Padding(
            padding: EdgeInsets.only(top: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white10,
                          Colors.white,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    "Or",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: "WorkSansMedium"),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white10,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
              ],
            ),
          ),*/
          /*Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0, right: 40.0),
                child: GestureDetector(
                  onTap: () => showInSnackBar("Facebook button pressed"),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.facebookF,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () => showInSnackBar("Google button pressed"),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.google,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
            ],
          ),*/
        ],
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
      /*margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      //width: MediaQuery.of(context).size.width*0.9,
      decoration: new ShapeDecoration(
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
        color: Colors.white,
      ),*/
      //padding: EdgeInsets.only(top: 0.0),
      child: Form(
        key: _formKeyKey,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  alignment: Alignment.topCenter,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Card(
                      elevation: 2.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        width: 370.0,
                        height: 500.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 7.0, bottom: 0.0, left: 25.0, right: 25.0),
                                    child: TextFormField(
                                      focusNode: myFocusNodeName,
                                      controller: signupNameController,
                                      keyboardType: TextInputType.text,
                                      textCapitalization: TextCapitalization.words,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                        // border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.solidBuilding,
                                          color: Colors.black,
                                        ),
                                        hintText: "Company ",
                                        hintStyle: TextStyle(
                                            fontSize: 14.0),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter company name';
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            /*Container(
                              width: 250.0,
                              height: 1.0,
                              color: Colors.grey[400],
                            ),*/
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 7.0, bottom: 0.0, left: 25.0, right: 25.0),
                                    child: TextFormField(
                                      focusNode: myFocusNodeCPN,
                                      controller: CPNController,
                                      keyboardType: TextInputType.text,
                                      textCapitalization: TextCapitalization.words,
                                      style: TextStyle(

                                          fontSize: 16.0,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                        //border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.userAlt,
                                          color: Colors.black,
                                        ),
                                        hintText: "Contact Person Name",
                                        hintStyle: TextStyle(
                                            fontSize: 14.0),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter contact person name';
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            /*Container(
                              width: 250.0,
                              height: 1.0,
                              color: Colors.grey[400],
                            ),*/
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 7.0, bottom: 0.0, left: 25.0, right: 25.0),
                                    child: TextFormField(
                                      focusNode: myFocusNodeEmail,
                                      controller: signupEmailController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(

                                          fontSize: 16.0,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                        // border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.solidEnvelope,
                                          color: Colors.black,
                                        ),
                                        hintText: "Email ",
                                        hintStyle: TextStyle(
                                            fontSize: 14.0),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter email';
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            /* Container(
                              width: 250.0,
                              height: 1.0,
                              color: Colors.grey[400],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 7.0, bottom:7.0, left: 25.0, right: 25.0),
                              child: TextField(
                                focusNode: myFocusNodePassword,
                                controller: signupPasswordController,
                                obscureText: _obscureTextSignup,
                                style: TextStyle(

                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    FontAwesomeIcons.lock,
                                    color: Colors.black,
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                       fontSize: 14.0),
                                  suffixIcon: GestureDetector(
                                    onTap: _toggleSignup,
                                    child: Icon(
                                      FontAwesomeIcons.eye,
                                      size: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),*/
                            /*Container(
                              width: 250.0,
                              height: 1.0,
                              color: Colors.grey[400],
                            ),*/
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 7.0, bottom: 0.0, left: 20.0, right: 25.0),
                                    child: TextFormField(
                                      focusNode: myFocusNodephone,
                                      controller: signupPhoneController,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        WhitelistingTextInputFormatter.digitsOnly,
                                      ],
                                      style: TextStyle(

                                          fontSize: 16.0,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                        //border: InputBorder.none,
                                        icon: Icon(
                                          Icons.phone,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                        hintText: "Phone",
                                        hintStyle: TextStyle(
                                            fontSize: 14.0),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter phone no.';
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            /*Container(
                              width: 250.0,
                              height: 1.0,
                              color: Colors.grey[400],
                            ),*/
                            //  Padding(
                            //   padding: EdgeInsets.only(
                            //      top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                            // child:
                            //Expanded(
                             // child:
                      Row(
                        children: <Widget>[
                          Container(
                            width: 350.0,
                            padding: EdgeInsets.only(
                                top: 0.0, bottom: 0.0, left: 25.0, right: 25.0),
                            child:new InputDecorator(
                              decoration: const InputDecoration(
                                //icon: const Icon(Icons.satellite,size: 15.0,),
                                //labelText: 'Country',
                                icon: Icon(
                                  FontAwesomeIcons.globeAsia,
                                  color: Colors.black,
                                ),
                              ),
                              //   isEmpty: _color == '',
                              child: DropdownButtonHideUnderline(
                                child:  new DropdownButton<String>(
                                  isDense: true,
                                  //    hint: new Text("Select"),
                                  value: _country,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _country = newValue;
                                    });
                                  },
                                  items: _myJson.map((Map map) {
                                    return new DropdownMenuItem<String>(
                                      value: map["id"].toString(),
                                      child: new Text(
                                        map["name"],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                            ),),
                        ],
                      ),
                           // ),

           // Expanded(
             // child:
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 7.0, bottom: 0.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          focusNode: myFocusNodecity,
                          controller: signupcityController,
                          //keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            //border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.city,
                              color: Colors.black,

                            ),
                            hintText: "City ",
                            hintStyle: TextStyle(
                                fontSize: 14.0),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter city name';
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                    //),
                            /*Container(
                              width: 250.0,
                              height: 1.0,
                              color: Colors.grey[400],
                            ),*/

                          ],
                        ),
                      ),
                    ),

                    Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            width: 190,
                    margin: EdgeInsets.only(top: 450.0),
                            padding: EdgeInsets.only(
                                top: 0.0, bottom: 0.0, left: 25.0, right: 15.0),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        /* boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Theme.Colors.loginGradientStart,
                            offset: Offset(1.0, 6.0),
                            blurRadius: 20.0,
                          ),
                          BoxShadow(
                            color: Theme.Colors.loginGradientEnd,
                            offset: Offset(1.0, 6.0),
                            blurRadius: 20.0,
                          ),
                        ],*/
                        /* gradient: new LinearGradient(
                            colors: [
                              Theme.Colors.loginGradientEnd,
                              Theme.Colors.loginGradientStart
                            ],
                            begin: const FractionalOffset(0.2, 0.2),
                            end: const FractionalOffset(1.0, 1.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),*/
                      ),
                      child: _isButtonDisabled?new RaisedButton(
                          color: Color.fromRGBO(0, 166, 90,1.0),
                          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                         /* shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),*/
                          textColor: Colors.white,
                          padding: EdgeInsets.all(10.0),
                          child: const Text('Please wait...',style: TextStyle(fontSize: 16.0),),
                          onPressed: (){

                          }
                      ): new ButtonTheme(
                            minWidth: 100.0,
                        child:RaisedButton(
                        //color: Colors.orange,
                        // textColor: Colors.white,
                          color: Color.fromRGBO(0,166, 90,1.0),
                          textColor: Colors.white,
                          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                         /* shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),*/
                          padding: EdgeInsets.all(5.0),
                          child: const Text('Register',style: TextStyle(fontSize: 16.0),),
                          onPressed: ()  {
                            if (_formKeyKey.currentState.validate()) {
                                if(_country=='0') {
                                  showDialog(context: context, child:
                                  new AlertDialog(
                                    //title: new Text("Alert"),
                                    content: new Text("Please select a country"),
                                  ));
                                  //FocusScope.of(context).requestFocus(myFocusNodephone);
                                }else{
                                  //requestleave(_dateController.text, _dateController1.text ,leavetimevalue, leavetimevalue1, _radioValue, _radioValue1, _reasonController.text.trim(), substituteemp);
                                  setState(() {
                                    _isButtonDisabled=true;
                                  });
                                  var url = path+"register_org";
                                  http.post(url, body: {
                                    "org_name": signupNameController.text.trim(),
                                    "name": CPNController.text.trim(),
                                    "phone": signupPhoneController.text.trim(),
                                    "email": signupEmailController.text.trim(),
                                    //"password": signupPasswordController.text,
                                    "city": signupcityController.text.trim(),
                                    "country": _country,
                                    "countrycode": '',
                                    "address": _country,
                                  }).then((response) {
                                    if (response.statusCode == 200) {
                                      print("-----------------> After Registration ---------------->");
                                      print(response.body.toString());
                                      // res = json.decode(response.body.toString());
                                      print("999");
                                      // print(res);
                                      if (response.body.toString().contains("1")) {
                                        // setLocal(res['f_name'],res['id'],res['org_id']);
                                        signupNameController.clear();
                                        CPNController.clear();
                                        signupPhoneController.clear();
                                        signupEmailController.clear();
                                        signupcityController.clear();
                                        _country="0";
                                        showDialog(context: context, child:
                                        new AlertDialog(
                                          //  title: new Text("UBIHRM"),
                                          content: new Text("Company is registered successfully. Please check your mail."),


                                          /* actions: <Widget>[
                                                new RaisedButton(
                                                  color: Colors.green,
                                                  textColor: Colors.white,
                                                  child: new Text('Start Trial'),
                                                  onPressed: () {
                                                    Navigator.of(context, rootNavigator: true).pop();
                                                  //  login(signupPhoneController.text, signupPasswordController.text, context);
                                                  },
                                                ),
                                              ],*/
                                        ));
                                        /*new Future.delayed(const Duration(seconds: 3));
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => LoginPage()),
                                          );*/
                                      } /*else if (res['sts'] == 'false1' ||
                                              res['sts'] == 'false3') {
                                            showDialog(context: context, child:
                                            new AlertDialog(
                                              title: new Text("ubiAttendance"),
                                              content: new Text(
                                                  "Email id is already registered"),
                                            ));
                                          } else if (res['sts'] == 'false2' ||
                                              res['sts'] == 'false4') {
                                            showDialog(context: context, child:
                                            new AlertDialog(
                                              title: new Text("ubiAttendance"),
                                              content: new Text(
                                                  "Phone id is already registered"),
                                            ));
                                          }*/
                                      else if(response.body.toString().contains("2")){
                                        showDialog(context: context, child:
                                        new AlertDialog(
                                          title: new Text("ubihrm"),
                                          content: new Text(
                                              "Oops! Email or Phone no already exist. Try later"),
                                        ));
                                      }
                                      else {
                                        showDialog(context: context, child:
                                        new AlertDialog(
                                          title: new Text("ubihrm"),
                                          content: new Text(
                                              "Oops! Company not registered. Try later"),
                                        ));
                                      }
                                      setState(() {
                                        _isButtonDisabled=false;
                                      });
                                    }
                                  }
                                  );
                                }
                            }
                            /*if(_isButtonDisabled)
                              return null;
                            //  showInSnackBar("SignUp button pressed");
                            if(signupNameController.text.trim()=='') {
                              showDialog(context: context, child:
                              new AlertDialog(
                               // title: new Text("Alert"),
                                content: new Text("Please enter the company name"),
                              ));
                              FocusScope.of(context).requestFocus(myFocusNodeName);
                            }
                            else if(CPNController.text.trim()=='') {
                              showDialog(context: context, child:
                              new AlertDialog(
                               // title: new Text("Alert"),
                                content: new Text("Please enter the Contact person name"),
                              ));
                              FocusScope.of(context).requestFocus(myFocusNodeCPN);
                            }
                            else if(signupEmailController.text.trim()=='') {
                              showDialog(context: context, child:
                              new AlertDialog(
                               // title: new Text("Alert"),
                                content: new Text("Please enter the Email"),
                              ));
                              FocusScope.of(context).requestFocus(myFocusNodeEmail);
                            }
                           /* else if(signupPasswordController.text=='') {
                              showDialog(context: context, child:
                              new AlertDialog(
                               // title: new Text("Alert"),
                                content: new Text("Please enter the password"),
                              ));
                              FocusScope.of(context).requestFocus(myFocusNodePassword);
                            }*/
                            else if(signupPhoneController.text.trim()=='') {
                              showDialog(context: context, child:
                              new AlertDialog(
                                //title: new Text("Alert"),
                                content: new Text("Please enter the Phone no."),
                              ));
                              FocusScope.of(context).requestFocus(myFocusNodephone);
                            }
                            else if(signupPhoneController.text.length<6) {
                              showDialog(context: context, child:
                              new AlertDialog(
                                // title: new Text("Alert"),
                                content: new Text("Please enter a valid Phone no."),
                              ));
                              FocusScope.of(context).requestFocus(myFocusNodephone);
                            }
                          /*  else if(signupPasswordController.text.length<6) {
                              showDialog(context: context, child:
                              new AlertDialog(
                                //title: new Text("Alert"),
                                content: new Text("Please enter a valid password \n (password must contain at least 6 characters)"),
                              ));
                              FocusScope.of(context).requestFocus(myFocusNodePassword);
                            }*/
                            else if(_country=='0') {
                              showDialog(context: context, child:
                              new AlertDialog(
                                //title: new Text("Alert"),
                                content: new Text("Please select a country"),
                              ));
                              FocusScope.of(context).requestFocus(myFocusNodephone);
                            }
                            else if(signupcityController.text.trim()=='') {
                              showDialog(context: context, child:
                              new AlertDialog(
                                //title: new Text("Alert"),
                                content: new Text("Please enter the city"),
                              ));
                              FocusScope.of(context).requestFocus(myFocusNodecity);
                            }
                            else {
                              setState(() {
                                _isButtonDisabled=true;

                              });
                              var url = path+"register_org";

                              http.post(url, body: {
                                "org_name": signupNameController.text.trim(),
                                "name": CPNController.text.trim(),
                                "phone": signupPhoneController.text.trim(),
                                "email": signupEmailController.text.trim(),
                                //"password": signupPasswordController.text,
                                "city": signupcityController.text.trim(),
                                "country": _country,
                                "countrycode": '',
                                "address": _country,
                              }) .then((response) {

                                if (response.statusCode == 200) {

                                  print("-----------------> After Registration ---------------->");
                                  print(response.body.toString());
                                   // res = json.decode(response.body.toString());
                                  print("999");
                                // print(res);
                                  if (response.body.toString().contains("1")) {
                                   // setLocal(res['f_name'],res['id'],res['org_id']);
                                    signupNameController.clear();
                                    CPNController.clear();
                                    signupPhoneController.clear();
                                    signupEmailController.clear();
                                    signupcityController.clear();
                                    _country="0";
                                    showDialog(context: context, child:
                                    new AlertDialog(
                                 //  title: new Text("UBIHRM"),
                                   content: new Text("Company is registered successfully. Please check your mail."),


                                            /* actions: <Widget>[
                                          new RaisedButton(
                                            color: Colors.green,
                                            textColor: Colors.white,
                                            child: new Text('Start Trial'),
                                            onPressed: () {
                                              Navigator.of(context, rootNavigator: true).pop();
                                            //  login(signupPhoneController.text, signupPasswordController.text, context);
                                            },
                                          ),
                                        ],*/
                                    ));
                                    /*new Future.delayed(const Duration(seconds: 3));
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginPage()),
                                    );*/
                                  } /*else if (res['sts'] == 'false1' ||
                                        res['sts'] == 'false3') {
                                      showDialog(context: context, child:
                                      new AlertDialog(
                                        title: new Text("ubiAttendance"),
                                        content: new Text(
                                            "Email id is already registered"),
                                      ));
                                    } else if (res['sts'] == 'false2' ||
                                        res['sts'] == 'false4') {
                                      showDialog(context: context, child:
                                      new AlertDialog(
                                        title: new Text("ubiAttendance"),
                                        content: new Text(
                                            "Phone id is already registered"),
                                      ));
                                    }*/
                                  else if(response.body.toString().contains("2")){
                                    showDialog(context: context, child:
                                    new AlertDialog(
                                      title: new Text("ubihrm"),
                                      content: new Text(
                                          "Oops! Email or Phone no already exist. Try later"),
                                    ));
                                  }
                                  else {
                                    showDialog(context: context, child:
                                    new AlertDialog(
                                      title: new Text("ubihrm"),
                                      content: new Text(
                                          "Oops! Company not registered. Try later"),
                                    ));
                                  }
                                  setState(() {
                                    _isButtonDisabled=false;

                                  });
                                } else {
                                  setState(() {
                                    _isButtonDisabled=false;

                                  });
                                  showDialog(context: context, child:
                                  new AlertDialog(
                                    title: new Text("Error"),
                                    // content: new Text("Unable to call service"),
                                    content: new Text("Response status: ${response
                                        .statusCode} \n Response body: ${response
                                        .body}"),
                                  )
                                  );

                                }
                                //   print("Response status: ${response.statusCode}");
                                //   print("Response body: ${response.body}");
                              }).catchError((onError) {
                                setState(() {
                                  _isButtonDisabled=false;
                                });
                                showDialog(context: context, child:
                                new AlertDialog(
                                  //title: new Text("Error"),
                                  content: new Text("Poor network connection."),
                                )
                                );
                              });
                            }*/
                          }

                      ),),

           ),
                          Expanded(child:  Container(
                            width: 190,
                        margin: EdgeInsets.only(top: 450.0),
                       padding: EdgeInsets.only(
                           top: 0.0, bottom: 0.0, left: 0.0, right: 25.0),
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            /*  boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Theme.Colors.loginGradientStart,
                              offset: Offset(1.0, 6.0),
                              blurRadius: 20.0,
                            ),
                            BoxShadow(
                              color: Theme.Colors.loginGradientEnd,
                              offset: Offset(1.0, 6.0),
                              blurRadius: 20.0,
                            ),
                          ],*/
                            /*  gradient: new LinearGradient(
                              colors: [
                                Theme.Colors.loginGradientEnd,
                                Theme.Colors.loginGradientStart
                              ],
                              begin: const FractionalOffset(0.2, 0.2),
                              end: const FractionalOffset(1.0, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),*/
                          ),

                           child: ButtonTheme(
                                //minWidth: 100.0,
                               // height: 100.0,
                          child: new OutlineButton(


                            child: new Text("Back",style:TextStyle( color: appStartColor(),)),
                            onPressed: _onSignInButtonPress,

                             borderSide: BorderSide(color:appStartColor()),
                            /* shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))*/

                          )),

                      ),
                      ),



  ]),
                  ],
                ),
              ),



            ],



          ),
        ),
      ),

    );
  }

  checklogin(String username, String pass) async{
    setState(() {
      _isServiceCalling = true;
    });
    Login dologin = Login();
    UserLogin user = new UserLogin(username: username,password: pass,token:token1);
    dologin.checklogin(user).then((res){
      if(res){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePageMain()), (Route<dynamic> route) => false,
        );
      }else{
        setState(() {
          _isServiceCalling = false;
        });
        showDialog(context: context, child:
        new AlertDialog(

          content: new Text("Invalid login credentials."),
        )
        );
      }
    }).catchError((exp){
      setState(() {
        _isServiceCalling=false;
      });
      showInSnackBar('Unable to connect server.');

    });;
  }


  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }
  markAttByQR(var qr, BuildContext context,token1) async{
    Login dologin = Login();
    setState(() {
      loader = true;
    });
    var islogin = await dologin.markAttByQR(qr,token1);
    print(islogin);
    if(islogin=="Success"){
      setState(() {
        loader = false;
      });
      showDialog(
          context : context,
          builder: (_) => new
          AlertDialog(
            //title: new Text("Dialog Title"),
            content: new Text("Successfull"
            ),
          )
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePageMain()), (Route<dynamic> route) => false,
      );
     /* Scaffold.of(context)
          .showSnackBar(
          SnackBar(content: Text("Attendance marked successfully.")));*/
    }else if(islogin=="failure"){
      setState(() {
        loader = false;
      });
      showDialog(
          context : context,
          builder: (_) => new
          AlertDialog(
            //title: new Text("Dialog Title"),
            content: new Text("Invalid login."
            ),
          )
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false,
      );

    /*  Scaffold.of(context)
          .showSnackBar(
          SnackBar(content: Text("Invalid login credentials")));*/
    }else if(islogin=="imposed"){
      setState(() {
        loader = false;
      });
      showDialog(
          context : context,
          builder: (_) => new
          AlertDialog(
            //title: new Text("Dialog Title"),
            content: new Text("Invalid login."
            ),
          )
      );
    }else{
      setState(() {
        loader = false;
      });
      /*Scaffold.of(context)
          .showSnackBar(
          SnackBar(content: Text("Attendance is already marked")));*/
    }
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      return barcode;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
        return "pemission denied";
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
        return "error";
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
      return "error";
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
      return "error";
    }
  }
}