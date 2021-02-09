// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/appbar.dart';
import 'package:ubihrm/drawer.dart';
import 'package:ubihrm/employees_list.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/home.dart';
import 'package:ubihrm/login_page.dart';
import 'package:ubihrm/profile.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/services/services.dart';
import 'package:ubihrm/view_employee.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model/model.dart';

class EditEmployee extends StatefulWidget {
  @override
  final String empid;
  final int sts;
  EditEmployee({Key key, this.empid, this.sts}) : super(key: key);

  /*static final kInitialPosition = LatLng(assign_lat, assign_long);
  static final apiKey = "AIzaSyDYh77SKpI6kAD1jiILwbiISZEwEOyJLtM";*/

  _EditEmployee createState() => _EditEmployee();
}

class _EditEmployee extends State<EditEmployee> {
  PickResult selectedPlace;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  final _formKey = GlobalKey<FormState>();
  final _deptFormKey = GlobalKey<FormState>();
  final _desgFormKey = GlobalKey<FormState>();
  final _locFormKey = GlobalKey<FormState>();
  final _divFormKey = GlobalKey<FormState>();
  final _shiftFormKey = GlobalKey<FormState>();
  final _gradeFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final timeFormat = DateFormat("H:mm");
  DateTime Date1 = new DateTime.now();
  DateTime Date2 = new DateTime.now();

  TextEditingController _empCode = new TextEditingController();
  TextEditingController _firstName = new TextEditingController();
  TextEditingController _lastName = new TextEditingController();
  TextEditingController _dob = new TextEditingController();
  TextEditingController _doj = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _contact = new TextEditingController();
  TextEditingController _contCode = new TextEditingController();
  TextEditingController _pwd = new TextEditingController();

  FocusNode __empCode = new FocusNode();
  FocusNode __firstName = new FocusNode();
  FocusNode __lastName = new FocusNode();
  FocusNode __email = new FocusNode();
  FocusNode __contact = new FocusNode();
  FocusNode __contCode = new FocusNode();
  FocusNode __pwd = new FocusNode();

  TextEditingController _deptCode = new TextEditingController();
  TextEditingController _deptName = new TextEditingController();
  TextEditingController _divCode = new TextEditingController();
  TextEditingController _divName = new TextEditingController();
  TextEditingController _desgCode = new TextEditingController();
  TextEditingController _desgName = new TextEditingController();
  TextEditingController _gradeCode = new TextEditingController();
  TextEditingController _gradeName = new TextEditingController();
  TextEditingController _locCode = new TextEditingController();
  TextEditingController _locArea = new TextEditingController();
  TextEditingController _shiftName = new TextEditingController();
  TextEditingController _shiftStartTimeController = new TextEditingController();
  TextEditingController _shiftEndTimeController = new TextEditingController();
  TextEditingController _breakStartTimeController = new TextEditingController();
  TextEditingController _breakEndTimeController = new TextEditingController();

  bool isloading = false;
  bool pageload = true;
  bool _obscureText = true;
  bool supervisor = true;
  bool _isButtonDisabled = false;
  bool _checkLoadedprofile = true;
  bool visibilityTag = false;
  bool _isServiceCalling = false;

  int adminsts = 0;
  int hrsts = 0;
  int divhrsts = 0;
  int response = 0;
  int _currentIndex = 2;

  String updatedcontact = '';
  String deptCode = '';
  String divCode = '';
  String desgCode = '';
  String locCode = '';
  String empCode = '';

  var arr;
  var lat; //These are user to store latitude got from javacode throughout the app
  var long;

  String emp = '0';
  String div = '0', dept = '0', desg = '0', loc = '0', shift = '0', shifttype = '0', grade = '0', empsts = '0', finalempsts = '0', gender = '0', finalgender = '0', nationality = '0';

  bool showtabbar;
  var profileimage;
  String orgName = "";
  String uid = "";
  String orgid = "";
  String org_country = "";
  List datalist = new List();
  List<Map> _shifttype = [{"id":"0", "name":"-Select-"}, {"id":"1", "name":"Single Date"}, {"id":"2", "name":"Multi Date"}];
  List<Map> _myJson = [ { "ind": "0"      ,      "id": "2"  ,   "name": "Afghanistan"  ,   "countrycode": "+93"}    ,
    { "ind":"1"       ,      "id": "4"  ,   "name": "Albania"  ,   "countrycode": "+355"}    ,
    { "ind":"2"       ,      "id": "50"  ,   "name": "Algeria"  ,   "countrycode": "+213"}    ,
    { "ind":"3"       ,      "id": "5"  ,   "name": "American Samoa"  ,   "countrycode": "+1"}    ,
    { "ind":"4"       ,      "id": "6"  ,   "name": "Andorra"  ,   "countrycode": "+376"}    ,
    { "ind":"5"       ,      "id": "7"  ,   "name": "Angola"  ,   "countrycode": "+244"}    ,
    { "ind":"6"       ,      "id": "11"  ,   "name": "Anguilla"  ,   "countrycode": "+264"}      ,
    { "ind":"7"       ,      "id": "3"  ,   "name": "Antigua and Barbuda"  ,   "countrycode": "+1"}      ,
    { "ind":"8"       ,      "id": "160"  ,   "name": "Argentina"  ,   "countrycode": "+54"}      ,
    { "ind":"9"       ,      "id": "8"  ,   "name": "Armenia"  ,   "countrycode": "+374"}      ,
    { "ind":"10"     ,      "id": "9"  ,   "name": "Aruba"  ,   "countrycode": "+297"}      ,
    { "ind":"11"     ,      "id": "10"  ,   "name": "Australia"  ,   "countrycode": "+61"}      ,
    { "ind":"12"     ,      "id": "1"  ,   "name": "Austria"  ,   "countrycode": "+43"}      ,
    { "ind":"13"     ,       "id": "12"  ,   "name": "Azerbaijan"  ,   "countrycode": "+994"}      ,
    { "ind":"14"     ,      "id": "27"  ,   "name": "Bahamas"  ,   "countrycode": "+242"}      ,
    { "ind":"15"     ,      "id": "25"  ,   "name": "Bahrain"  ,   "countrycode": "+973"}      ,
    { "ind":"16"     ,      "id": "14"  ,   "name": "Bangladesh"  ,   "countrycode": "+880"}      ,
    { "ind":"17"     ,      "id": "15"  ,   "name": "Barbados"  ,   "countrycode": "+246"}      ,
    { "ind":"18"     ,      "id": "29"  ,   "name": "Belarus"  ,   "countrycode": "+375"}      ,
    { "ind":"19"     ,      "id": "13"  ,   "name": "Belgium"  ,   "countrycode": "+32"}      ,
    { "ind":"20"     ,      "id": "30"  ,   "name": "Belize"  ,   "countrycode": "+501"}      ,
    { "ind":"21"     ,      "id": "16"  ,   "name": "Benin"  ,   "countrycode": "+229"}      ,
    { "ind":"22"     ,      "id": "17"  ,   "name": "Bermuda"  ,   "countrycode": "+441"}      ,
    { "ind":"23"     ,      "id": "20"  ,   "name": "Bhutan"  ,   "countrycode": "+975"}      ,
    { "ind":"24"     ,      "id": "23"  ,   "name": "Bolivia"  ,   "countrycode": "+591"}      ,
    { "ind":"25"     ,      "id": "22"  ,   "name": "Bosnia and Herzegovina"  ,   "countrycode": "+387"}      ,
    { "ind":"26"     ,      "id": "161"  ,   "name": "Botswana"  ,   "countrycode": "+267"}      ,
    { "ind":"27"     ,      "id": "24"  ,   "name": "Brazil"  ,   "countrycode": "+55"}      ,
    { "ind":"28"     ,      "id": "28"  ,   "name": "British Virgin Islands"  ,   "countrycode": "+284"}      ,
    { "ind":"29"     ,      "id": "26"  ,   "name": "Brunei"  ,   "countrycode": "+673"}      ,
    { "ind":"30"     ,      "id": "19"  ,   "name": "Bulgaria"  ,   "countrycode": "+359"}      ,
    { "ind":"31"     ,      "id": "18"  ,   "name": "Burkina Faso"  ,   "countrycode": "+226"}      ,
    { "ind":"32"     ,      "id": "21"  ,   "name": "Burundi"  ,   "countrycode": "+257"}      ,
    { "ind":"33"     ,      "id": "101"  ,   "name": "Cambodia"  ,   "countrycode": "+855"}      ,
    { "ind":"34"     ,      "id": "32"  ,   "name": "Cameroon"  ,   "countrycode": "+237"}      ,
    { "ind":"35"     ,      "id": "34"  ,   "name": "Canada"  ,   "countrycode": "+1"}      ,
    { "ind":"36"     ,      "id": "43"  ,   "name": "Cape Verde"  ,   "countrycode": "+238"}      ,
    { "ind":"37"     ,      "id": "33"  ,   "name": "Cayman Islands"  ,   "countrycode": "+345"}      ,
    { "ind":"38"     ,      "id": "163"  ,   "name": "Central African Republic"  ,   "countrycode": "+236"}      ,
    { "ind":"39"     ,      "id": "203"  ,   "name": "Chad"  ,   "countrycode": "+235"}      ,
    { "ind":"40"     ,      "id": "165"  ,   "name": "Chile"  ,   "countrycode": "+56"}      ,
    { "ind":"41"     ,      "id": "205"  ,   "name": "China"  ,   "countrycode": "+86"}      ,
    { "ind":"42"     ,      "id": "233"  ,   "name": "Christmas Island"  ,   "countrycode": "+61"}      ,
    { "ind":"43"     ,      "id": "39"  ,   "name": "Cocos Islands"  ,   "countrycode": "+891"}      ,
    { "ind":"44"     ,      "id": "38"  ,   "name": "Colombia"  ,   "countrycode": "+57"}      ,
    { "ind":"45"     ,      "id": "40"  ,   "name": "Comoros"  ,   "countrycode": "+269"}      ,
    { "ind":"46"     ,      "id": "41"  ,   "name": "Cook Islands"  ,   "countrycode": "+682"}      ,
    { "ind":"47"     ,      "id": "42"  ,   "name": "Costa Rica"  ,   "countrycode": "+506"}      ,
    { "ind":"48"     ,      "id": "36"  ,   "name": "Cote dIvoire"  ,   "countrycode": "+225"}      ,
    { "ind":"49"     ,      "id": "90"  ,   "name": "Croatia"  ,   "countrycode": "+385"}      ,
    { "ind":"50"     ,      "id": "31"  ,   "name": "Cuba"  ,   "countrycode": "+53"}      ,
    { "ind":"51"     ,      "id": "44"  ,   "name": "Cyprus"  ,   "countrycode": "+357"}      ,
    { "ind":"52"     ,      "id": "45"  ,   "name": "Czech Republic"  ,   "countrycode": "+420"}      ,
    { "ind":"53"     ,      "id": "48"  ,   "name": "Denmark"  ,   "countrycode": "+45"}      ,
    { "ind":"54"     ,      "id": "47"  ,   "name": "Djibouti"  ,   "countrycode": "+253"}      ,
    { "ind":"55"     ,      "id": "226"  ,   "name": "Dominica"  ,   "countrycode": "+767"}      ,
    { "ind":"56"     ,      "id": "49"  ,   "name": "Dominican Republic"  ,   "countrycode": "+1"}      ,
    { "ind":"57"     ,      "id": "55"  ,   "name": "Ecuador"  ,   "countrycode": "+593"}      ,
    { "ind":"58"     ,      "id": "58"  ,   "name": "Egypt"  ,   "countrycode": "+20"}      ,
    { "ind":"59"     ,      "id": "57"  ,   "name": "El Salvador"  ,   "countrycode": "+503"}      ,
    { "ind":"60"     ,      "id": "80"  ,   "name": "Equatorial Guinea"  ,   "countrycode": "+240"}      ,
    { "ind":"60"     ,      "id": "56"  ,   "name": "Eritrea"  ,   "countrycode": "+291"}      ,
    { "ind":"62"     ,      "id": "60"  ,   "name": "Estonia"  ,   "countrycode": "+372"}      ,
    { "ind":"63"     ,      "id": "59"  ,   "name": "Ethiopia"  ,   "countrycode": "+251"}      ,
    { "ind":"64"     ,      "id": "62"  ,   "name": "Falkland Islands"  ,   "countrycode": "+500"}      ,
    { "ind":"65"     ,      "id": "63"  ,   "name": "Faroe Islands"  ,   "countrycode": "+298"}      ,
    { "ind":"66"     ,      "id": "65"  ,   "name": "Fiji"  ,   "countrycode": "+679"}      ,
    { "ind":"67"     ,      "id": "186"  ,   "name": "Finland"  ,   "countrycode": "+358"}      ,
    { "ind":"68"     ,      "id": "61"  ,   "name": "France"  ,   "countrycode": "+33"}      ,
    { "ind":"69"     ,      "id": "64"  ,   "name": "French Guiana"  ,   "countrycode": "+594"}      ,
    { "ind":"70"     ,      "id": "67"  ,   "name": "French Polynesia"  ,   "countrycode": "+689"}      ,
    { "ind":"71"     ,      "id": "69"  ,   "name": "Gabon"  ,   "countrycode": "+241"}      ,
    { "ind":"72"     ,      "id": "223"  ,   "name": "Gambia"  ,   "countrycode": "+220"}      ,
    { "ind":"73"     ,      "id": "70"  ,   "name": "Gaza Strip"  ,   "countrycode": "+970"}      ,
    { "ind":"74"     ,      "id": "77"  ,   "name": "Georgia"  ,   "countrycode": "+995"}      ,
    { "ind":"75"     ,      "id": "46"  ,   "name": "Germany"  ,   "countrycode": "+49"}      ,
    { "ind":"76"     ,      "id": "78"  ,   "name": "Ghana"  ,   "countrycode": "+233"}      ,
    { "ind":"77"     ,      "id": "75" ,"name": "Gibraltar"  ,   "countrycode": "+350"}      ,
    { "ind":"78"     ,      "id": "81"  ,   "name": "Greece"  ,   "countrycode": "+30"}      ,
    { "ind":"79"     ,      "id": "82"  ,   "name": "Greenland"  ,   "countrycode": "+299"}      ,
    { "ind":"80"     ,      "id": "228"  ,   "name": "Grenada"  ,   "countrycode": "+473"}      ,
    { "ind":"81"     ,      "id": "83"  ,   "name": "Guadeloupe"  ,   "countrycode": "+590"}      ,
    { "ind":"82"     ,      "id": "84"  ,   "name": "Guam"  ,   "countrycode": "+1"}      ,
    { "ind":"83"     ,      "id": "76"  ,   "name": "Guatemala"  ,   "countrycode": "+502"}      ,
    { "ind":"84"     ,      "id": "72"  ,   "name": "Guernsey"  ,   "countrycode": "+44"}      ,
    { "ind":"85"     ,      "id": "167"  ,   "name": "Guinea"  ,   "countrycode": "+224"}      ,
    { "ind":"86"     ,      "id": "79"  ,   "name": "Guinea-Bissau"  ,   "countrycode": "+245"}      ,
    { "ind":"87"     ,      "id": "85"  ,   "name": "Guyana"  ,   "countrycode": "+592"}      ,
    { "ind":"88"     ,      "id": "168"  ,   "name": "Haiti"  ,   "countrycode": "+509"}      ,
    { "ind":"89"     ,      "id": "218"  ,   "name": "Holy See"  ,   "countrycode": "+379"}      ,
    { "ind":"90"     ,      "id": "87"  ,   "name": "Honduras"  ,   "countrycode": "+504"}      ,
    { "ind":"91"     ,      "id": "89"  ,   "name": "Hong Kong"  ,   "countrycode": "+852"}      ,
    { "ind":"92"     ,      "id": "86"  ,   "name": "Hungary"  ,   "countrycode": "+36"}      ,
    { "ind":"93"     ,      "id": "97"  ,   "name": "Iceland"  ,   "countrycode": "+354"}      ,
    { "ind":"94"     ,      "id": "93"  ,   "name": "India"  ,   "countrycode": "+91"}      ,
    { "ind":"95"     ,      "id": "169"  ,   "name": "Indonesia"  ,   "countrycode": "+62"}      ,
    { "ind":"96"     ,      "id": "94"  ,   "name": "Iran"  ,   "countrycode": "+98"}      ,
    { "ind":"97"     ,      "id": "96"  ,   "name": "Iraq"  ,   "countrycode": "+964"}      ,
    { "ind":"98"     ,      "id": "95"  ,   "name": "Ireland"  ,   "countrycode": "+353"}      ,
    { "ind":"99"     ,      "id": "74"  ,   "name": "Isle of Man"  ,   "countrycode": "+44"}      ,
    { "ind":"100"     ,      "id": "92"  ,   "name": "Israel"  ,   "countrycode": "+972"}      ,
    { "ind":"101"     ,      "id": "91"  ,   "name": "Italy"  ,   "countrycode": "+39"}      ,
    { "ind":"102"     ,      "id": "99"  ,   "name": "Jamaica"  ,   "countrycode": "+876"}      ,
    { "ind":"103"     ,      "id": "98"  ,   "name": "Japan"  ,   "countrycode": "+81"}      ,
    { "ind":"104"     ,      "id": "73"  ,   "name": "Jersey"  ,   "countrycode": "+44"}      ,
    { "ind":"105"     ,      "id": "100"  ,   "name": "Jordan"  ,   "countrycode": "+962"}      ,
    { "ind":"106"     ,      "id": "102"  ,   "name": "Kazakhstan"  ,   "countrycode": "+7"}      ,
    { "ind":"107"     ,      "id": "52"  ,   "name": "Kenya"  ,   "countrycode": "+254"}      ,
    { "ind":"108"     ,      "id": "104"  ,   "name": "Kiribati"  ,   "countrycode": "+686"}      ,
    { "ind":"109"     ,      "id": "106"  ,   "name": "Kosovo"  ,   "countrycode": "+383"}      ,
    { "ind":"110"     ,      "id": "107"  ,   "name": "Kuwait"  ,   "countrycode": "+965"}      ,
    { "ind":"111"     ,      "id": "103"  ,   "name": "Kyrgyzstan"  ,   "countrycode": "+996"}      ,
    { "ind":"112"     ,      "id": "109"  ,   "name": "Laos"  ,   "countrycode": "+856"}      ,
    { "ind":"113"     ,      "id": "114"  ,   "name": "Latvia"  ,   "countrycode": "+371"}      ,
    { "ind":"114"     ,      "id": "171"  ,   "name": "Lebanon"  ,   "countrycode": "+961"}      ,
    { "ind":"115"     ,      "id": "112"  ,   "name": "Lesotho"  ,   "countrycode": "+266"}      ,
    { "ind":"116"     ,      "id": "111"  ,   "name": "Liberia"  ,   "countrycode": "+231"}      ,
    { "ind":"117"     ,      "id": "110"  ,   "name": "Libya"  ,   "countrycode": "+218"}      ,
    { "ind":"118"     ,      "id": "66"  ,   "name": "Liechtenstein"  ,   "countrycode": "+423"}      ,
    { "ind":"119"     ,      "id": "113"  ,   "name": "Lithuania"  ,   "countrycode": "+370"}      ,
    { "ind":"120"     ,      "id": "108"  ,   "name": "Luxembourg"  ,   "countrycode": "+352"}      ,
    { "ind":"121"     ,      "id": "117"  ,   "name": "Macau"  ,   "countrycode": "+853"}      ,
    { "ind":"122"     ,      "id": "125"  ,   "name": "Macedonia"  ,   "countrycode": "+389"}      ,
    { "ind":"123"     ,      "id": "172"  ,   "name": "Madagascar"  ,   "countrycode": "+261"}      ,
    { "ind":"124"     ,      "id": "132"  ,   "name": "Malawi"  ,   "countrycode": "+265"}      ,
    { "ind":"125"     ,      "id": "118"  ,   "name": "Malaysia"  ,   "countrycode": "+60"}      ,
    { "ind":"126"     ,      "id": "131"  ,   "name": "Maldives"  ,   "countrycode": "+960"}      ,
    { "ind":"127"     ,      "id": "173"  ,   "name": "Mali"  ,   "countrycode": "+223"}      ,
    { "ind":"128"     ,      "id": "115"  ,   "name": "Malta"  ,   "countrycode": "+356"}      ,
    { "ind":"129"     ,      "id": "124"  ,   "name": "Marshall Islands"  ,   "countrycode": "+692"}      ,
    { "ind":"130"     ,      "id": "119"  ,   "name": "Martinique"  ,   "countrycode": "+596"}      ,
    { "ind":"131"     ,      "id": "170"  ,   "name": "Mauritania"  ,   "countrycode": "+222"}      ,
    { "ind":"132"     ,      "id": "130"  ,   "name": "Mauritius"  ,   "countrycode": "+230"}      ,
    { "ind":"133"     ,      "id": "120"  ,   "name": "Mayotte"  ,   "countrycode": "+262"}      ,
    { "ind":"134"     ,      "id": "123"  ,   "name": "Mexico"  ,   "countrycode": "+52"}      ,
    { "ind":"135"     ,      "id": "68"  ,   "name": "Micronesia"  ,   "countrycode": "+691"}      ,
    { "ind":"136"     ,      "id": "122"  ,   "name": "Moldova"  ,   "countrycode": "+373"}      ,
    { "ind":"137"     ,      "id": "121"  ,   "name": "Monaco"  ,   "countrycode": "+377"}      ,
    { "ind":"138"     ,      "id": "127"  ,   "name": "Mongolia"  ,   "countrycode": "+976"}      ,
    { "ind":"139"     ,      "id": "126"  ,   "name": "Montenegro"  ,   "countrycode": "+382"}      ,
    { "ind":"140"     ,      "id": "128"  ,   "name": "Montserrat"  ,   "countrycode": "+664"}      ,
    { "ind":"141"     ,      "id": "116"  ,   "name": "Morocco"  ,   "countrycode": "+212"}      ,
    { "ind":"142"     ,      "id": "129"  ,   "name": "Mozambique"  ,   "countrycode": "+258"}      ,
    { "ind":"143"     ,      "id": "133"  ,   "name": "Myanmar"  ,   "countrycode": "+95"}      ,
    { "ind":"144"     ,      "id": "136"  ,   "name": "Namibia"  ,   "countrycode": "+264"}      ,
    { "ind":"145"     ,      "id": "137"  ,   "name": "Nauru"  ,   "countrycode": "+674"}      ,
    { "ind":"146"     ,      "id": "139"  ,   "name": "Nepal"  ,   "countrycode": "+977"}      ,
    { "ind":"147"     ,      "id": "142"  ,   "name": "Netherlands"  ,   "countrycode": "+31"}      ,
    { "ind":"148"     ,      "id": "135"  ,   "name": "Netherlands Antilles"  ,   "countrycode": "+599"}      ,
    { "ind":"149"     ,      "id": "138"  ,   "name": "New Caledonia"  ,   "countrycode": "+687"}      ,
    { "ind":"150"     ,      "id": "146"  ,   "name": "New Zealand"  ,   "countrycode": "+64"}      ,
    { "ind":"151"     ,      "id": "140"  ,   "name": "Nicaragua"  ,   "countrycode": "+505"}      ,
    { "ind":"152"     ,      "id": "174"  ,   "name": "Niger"  ,   "countrycode": "+227"}      ,
    { "ind":"153"     ,      "id": "225"  ,   "name": "Nigeria"  ,   "countrycode": "+234"}      ,
    { "ind":"154"     ,      "id": "141"  ,   "name": "Niue"  ,   "countrycode": "+683"}      ,
    { "ind":"155"     ,      "id": "144"  ,   "name": "North Korea"  ,   "countrycode": "+850"}      ,
    { "ind":"156"     ,      "id": "143"  ,   "name": "Northern Mariana Islands"  ,   "countrycode": "+1"}      ,
    { "ind":"157"     ,      "id": "134"  ,   "name": "Norway"  ,   "countrycode": "+47"}      ,
    { "ind":"158"     ,      "id": "147"  ,   "name": "Oman"  ,   "countrycode": "+968"}      ,
    { "ind":"159"     ,      "id": "153"  ,   "name": "Pakistan"  ,   "countrycode": "+92"}      ,
    { "ind":"160"     ,      "id": "150"  ,   "name": "Palau"  ,   "countrycode": "+680"}      ,
    { "ind":"161"     ,      "id": "149"  ,   "name": "Panama"  ,   "countrycode": "+507"}      ,
    { "ind":"162"     ,      "id": "155"  ,   "name": "Papua New Guinea"  ,   "countrycode": "+675"}      ,
    { "ind":"163"     ,      "id": "157"  ,   "name": "Paraguay"  ,   "countrycode": "+595"}      ,
    { "ind":"164"     ,      "id": "151"  ,   "name": "Peru"  ,   "countrycode": "+51"}      ,
    { "ind":"165"     ,      "id": "178"  ,   "name": "Philippines"  ,   "countrycode": "+63"}      ,
    { "ind":"166"     ,      "id": "152"  ,   "name": "Pitcairn Islands"  ,   "countrycode": "+64"}      ,
    { "ind":"167"     ,      "id": "154"  ,   "name": "Poland"  ,   "countrycode": "+48"}      ,
    { "ind":"168"     ,      "id": "148"  ,   "name": "Portugal"  ,   "countrycode": "+351"}      ,
    { "ind":"169"     ,      "id": "156"  ,   "name": "Puerto Rico"  ,   "countrycode": "+1"}      ,
    { "ind":"170"     ,      "id": "158"  ,   "name": "Qatar"  ,   "countrycode": "+974"}      ,
    { "ind":"171"     ,      "id": "164"  ,   "name": "Republic of the Congo"  ,   "countrycode": "+243"}      ,
    { "ind":"172"     ,      "id": "166"  ,   "name": "Reunion"  ,   "countrycode": "+262"}      ,
    { "ind":"173"     ,      "id": "175"  ,   "name": "Romania"  ,   "countrycode": "+40"}      ,
    { "ind":"174"     ,      "id": "159"  ,   "name": "Russia"  ,   "countrycode": "+7"}      ,
    { "ind":"175"     ,      "id": "182"  ,   "name": "Rwanda"  ,   "countrycode": "+250"}      ,
    { "ind":"176"     ,      "id": "88"  ,   "name": "Saint Helena"  ,   "countrycode": "+290"}      ,
    { "ind":"177"     ,      "id": "105"  ,   "name": "Saint Kitts and Nevis"  ,   "countrycode": "+869"}      ,
    { "ind":"178"     ,      "id": "229"  ,   "name": "Saint Lucia"  ,   "countrycode": "+758"}      ,
    { "ind":"179"     ,      "id": "191"  ,   "name": "Saint Martin"  ,   "countrycode": "+1"}      ,
    { "ind":"180"     ,      "id": "195"  ,   "name": "Saint Pierre and Miquelon"  ,   "countrycode": "+508"}      ,
    { "ind":"181"     ,      "id": "232"  ,   "name": "Saint Vincent and the Grenadines"  ,   "countrycode": "+784"}      ,
    { "ind":"182"     ,      "id": "230"  ,   "name": "Samoa"  ,   "countrycode": "+685"}      ,
    { "ind":"183"     ,      "id": "180"  ,   "name": "San Marino"  ,   "countrycode": "+378"}      ,
    { "ind":"184"     ,      "id": "197"  ,   "name": "Sao Tome and Principe"  ,   "countrycode": "+239"}      ,
    { "ind":"185"     ,      "id": "184"  ,   "name": "Saudi Arabia"  ,   "countrycode": "+966"}      ,
    { "ind":"186"     ,      "id": "193"  ,   "name": "Senegal"  ,   "countrycode": "+221"}      ,
    { "ind":"187"     ,      "id": "196"  ,   "name": "Serbia"  ,   "countrycode": "+381"}      ,
    { "ind":"188"     ,      "id": "200"  ,   "name": "Seychelles"  ,   "countrycode": "+248"}      ,
    { "ind":"189"     ,      "id": "224"  ,   "name": "Sierra Leone"  ,   "countrycode": "+232"}      ,
    { "ind":"190"     ,      "id": "187"  ,   "name": "Singapore"  ,   "countrycode": "+65"}      ,
    { "ind":"191"     ,      "id": "188"  ,   "name": "Slovakia"  ,   "countrycode": "+421"}      ,
    { "ind":"192"     ,      "id": "190"  ,   "name": "Slovenia"  ,   "countrycode": "+386"}      ,
    { "ind":"193"     ,      "id": "189"  ,   "name": "Solomon Islands"  ,   "countrycode": "+677"}      ,
    { "ind":"194"     ,      "id": "194"  ,   "name": "Somalia"  ,   "countrycode": "+252"}      ,
    { "ind":"195"     ,      "id": "179"  ,   "name": "South Africa"  ,   "countrycode": "+27"}      ,
    { "ind":"196"     ,      "id": "176"  ,   "name": "South Korea"  ,   "countrycode": "+82"}      ,
    { "ind":"197"     ,      "id": "51"  ,   "name": "Spain"  ,   "countrycode": "+34"}      ,
    { "ind":"198"     ,      "id": "37"  ,   "name": "Sri Lanka"  ,   "countrycode": "+94"}      ,
    { "ind":"299"     ,      "id": "198"  ,   "name": "Sudan"  ,   "countrycode": "+249"}      ,
    { "ind":"200"     ,      "id": "192"  ,   "name": "Suriname"  ,   "countrycode": "+597"}      ,
    { "ind":"201"     ,      "id": "199"  ,   "name": "Svalbard"  ,   "countrycode": "+47"}      ,
    { "ind":"202"     ,      "id": "185"  ,   "name": "Swaziland"  ,   "countrycode": "+268"}      ,
    { "ind":"203"     ,      "id": "183"  ,   "name": "Sweden"  ,   "countrycode": "+46"}      ,
    { "ind":"204"     ,      "id": "35"  ,   "name": "Switzerland"  ,   "countrycode": "+41"}      ,
    { "ind":"205"     ,      "id": "201"  ,   "name": "Syria"  ,   "countrycode": "+963"}      ,
    { "ind":"206"     ,      "id": "162"  ,   "name": "Taiwan"  ,   "countrycode": "+886"}      ,
    { "ind":"207"     ,      "id": "202"  ,   "name": "Tajikistan"  ,   "countrycode": "+992"}      ,
    { "ind":"208"     ,      "id": "53"  ,   "name": "Tanzania"  ,   "countrycode": "+255"}      ,
    { "ind":"209"     ,      "id": "204"  ,   "name": "Thailand"  ,   "countrycode": "+66"}      ,
    { "ind":"210"     ,      "id": "206"  ,   "name": "Timor-Leste"  ,   "countrycode": "+670"}      ,
    { "ind":"211"     ,      "id": "181"  ,   "name": "Togo"  ,   "countrycode": "+228"}      ,
    { "ind":"212"     ,      "id": "209"  ,   "name": "Tonga"  ,   "countrycode": "+676"}      ,
    { "ind":"213"     ,      "id": "211"  ,   "name": "Trinidad and Tobago"  ,   "countrycode": "+868"}      ,
    { "ind":"214"     ,      "id": "208"  ,   "name": "Tunisia"  ,   "countrycode": "+216"}      ,
    { "ind":"215"     ,      "id": "210"  ,   "name": "Turkey"  ,   "countrycode": "+90"}      ,
    { "ind":"216"     ,      "id": "207"  ,   "name": "Turkmenistan"  ,   "countrycode": "+993"}      ,
    { "ind":"217"     ,      "id": "212"  ,   "name": "Turks and Caicos Islands"  ,   "countrycode": "+1"}      ,
    { "ind":"218"     ,      "id": "213"  ,   "name": "Tuvalu"  ,   "countrycode": "+688"}      ,
    { "ind":"219"     ,      "id": "219"  ,   "name": "U.S. Virgin Islands"  ,   "countrycode": "+1"}      ,
    { "ind":"220"     ,      "id": "54"  ,   "name": "Uganda"  ,   "countrycode": "+256"}      ,
    { "ind":"221"     ,      "id": "214"  ,   "name": "Ukraine"  ,   "countrycode": "+380"}      ,
    { "ind":"222"     ,      "id": "215"  ,   "name": "United Arab Emirates"  ,   "countrycode": "+971"}      ,
    { "ind":"223"     ,      "id": "71" ,   "name": "United Kingdom" ,   "countrycode": "+44"}      ,
    { "ind":"224"    ,      "id": "216" ,   "name": "United States" ,   "countrycode": "+1"}      ,
    { "ind":"225"    ,      "id": "177" ,   "name": "Uruguay" ,   "countrycode": "+598"}      ,
    { "ind":"226"    ,      "id": "217" ,   "name": "Uzbekistan" ,   "countrycode": "+998"}      ,
    { "ind":"227"    ,      "id": "221" ,   "name": "Vanuatu" ,   "countrycode": "+678"}      ,
    { "ind":"228"    ,      "id": "235" ,   "name": "Venezuela" ,   "countrycode": "+58"}      ,
    { "ind":"229"    ,      "id": "220" ,   "name": "Vietnam" ,   "countrycode": "+84"}      ,
    { "ind":"230"    ,      "id": "222" ,   "name": "Wallis and Futuna" ,   "countrycode": "+681"}      ,
    { "ind":"231"    ,      "id": "227" ,   "name": "West Bank" ,   "countrycode": "+970"}      ,
    { "ind":"232"    ,      "id": "231" ,   "name": "Western Sahara" ,   "countrycode": "+212"}      ,
    { "ind":"233"    ,      "id": "234" ,   "name": "Yemen" ,   "countrycode": "+967"}      ,
    { "ind":"234"    ,      "id": "237" ,   "name": "Zaire" ,   "countrycode": "+243"}      ,
    { "ind":"235"    ,      "id": "236" ,   "name": "Zambia" ,   "countrycode": "+260"}      ,
    { "ind":"236"    ,      "id": "238" ,   "name": "Zimbabwe" ,   "countrycode": "+263"} ];

  String _country;
  String _tempcontry='';

  TextStyle _hintStyle = TextStyle(
    color: Colors.black45
  );

  @override
  void initState() {
    super.initState();
    print("in addedit initstate");
    _empCode = new TextEditingController();
    _firstName = new TextEditingController();
    _lastName = new TextEditingController();
    _dob = new TextEditingController();
    _doj = new TextEditingController();
    _email = new TextEditingController();
    _contact = new TextEditingController();
    _contCode = new TextEditingController();
    _pwd = new TextEditingController();
    widget.sts!=4?getEmployeeDetailById(widget.empid).then((data){
      if (mounted) {
        setState(() {
          datalist = data;
          print("datalist");
          print(datalist);
          print(datalist[0]["Id"]);
          _empCode.text = datalist[0]["EmployeeCode"];
          _firstName.text = datalist[0]["fname"];
          print(datalist[0]["fname"]);
          _lastName.text = datalist[0]["lname"];
          print(datalist[0]["lname"]);
          _dob.text = datalist[0]["DOB"];
          print(datalist[0]["DOB"]);
          _doj.text = datalist[0]["DOJ"];
          print(datalist[0]["DOJ"]);
          _contact.text = datalist[0]["Mobile"];
          print(datalist[0]["Mobile"]);
          _email.text = datalist[0]["Email"];
          print(datalist[0]["Email"]);
          div = datalist[0]["DivisionId"];
          print("div"+div);
          dept = datalist[0]["DepartmentId"];
          print("dept"+dept);
          desg = datalist[0]["DesignationId"];
          print("desg"+desg);
          loc = datalist[0]["LocationId"];
          print("loc"+loc);
          empsts = datalist[0]["EmployeeStatusId"];
          print("empsts"+empsts);
          finalempsts = datalist[0]["EmployeeStatusActualValue"];
          print("finalempsts"+finalempsts);
          gender = datalist[0]["GenderId"];
          print("gender"+gender);
          finalgender = datalist[0]["GenderActualValue"];
          print("finalgender"+finalgender);
          nationality = datalist[0]["NationalityId"];
          print("nationality"+nationality);
          grade = datalist[0]["GradeId"];
          print("grade"+grade);
          shift = datalist[0]["ShiftId"];
          print("shift"+shift);
          _tempcontry = datalist[0]["CountryId"];
          print("_tempcontry"+_tempcontry);
          if(datalist[0]["CountryCode"]=='') {
            print("if");
            for (int i = 0; i < _myJson.length; i++) {
              if (_tempcontry == _myJson[i]["id"]) {
                _country = _myJson[i]["ind"];
                _contCode.text = _myJson[i]['countrycode'];
              }
            }
          }else{
            print("else");
            _contCode.text = datalist[0]["CountryCode"];
          }
        });
      }
    }):null;
    profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    response = prefs.getInt('response') ?? 0;
    if (response == 1) {
      setState(() {
        uid = prefs.getString("employeeid")??"";
        orgid = prefs.getString("organization")??"";
        print("orgName");
        print(orgName);
        orgName = prefs.getString('orgname') ?? '';
        org_country = prefs.getString('countryid') ?? '';
        adminsts = prefs.getInt('adminsts') ?? 0;
        hrsts = prefs.getInt('hrsts')??0;
        divhrsts = prefs.getInt('divhrsts')??0;
      });
    }
    _pwd.text = '123456';
    widget.sts==4?_getCurrentLocation():null;
    widget.sts==4?getempcode():null;
    widget.sts==4?getdeptid():null;
    widget.sts==4?getdesgid():null;
    widget.sts==4?getlocid():null;
    widget.sts==4?getshiftid():null;
    widget.sts==4?getdivisionid():null;
  }

  getempcode(){
    getEmpCode().then((res) {
      setState(() {
        empCode = res;
        _empCode.text=empCode;
      });
    });
  }

  getdeptid() async{
    getDepartmentsList(0).then((onValue){
      for(int i = 0 ; i < onValue.length; i++){
        if(onValue[i]["Name"] == "Trial Department") {
          dept = onValue[i]["Id"];
        }
      }
    });
  }

  getdesgid() async{
    getDesignationsList(0).then((onValue) {
      for(int i = 0 ; i < onValue.length; i++){
        if(onValue[i]["Name"] == "Trial Designation") {
          desg = onValue[i]["Id"];
        }
      }
    });
  }

  getlocid() async{
    getLocationsList(0).then((onValue){
      for(int i = 0 ; i < onValue.length; i++){
        if(onValue[i]["Name"] == "Trial Location") {
          loc = onValue[i]["Id"];
        }
      }
    });
  }

  getshiftid() async{
    getShiftsList(0).then((onValue) {
      for(int i = 0 ; i < onValue.length; i++){
        if(onValue[i]["Name"] == "Trial Shift") {
          shift = onValue[i]["Id"];
        }
      }
    });
  }

  getdivisionid() async{
    getDivisionsList(0).then((onValue) {
      for(int i = 0 ; i < onValue.length; i++){
        if(onValue.length==2)
          div = onValue[i]["Id"];
        else
          div = '0';
      }
    });
  }

  _getCurrentLocation() {
    geolocator.getCurrentPosition(desiredAccuracy:LocationAccuracy.best).then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        SearchCountry(place.country);
      });
    } catch (e) {
      print(e);
    }
  }

  SearchCountry(String country) {
    for (int i=0; i < _myJson.length; i++) {
      if (country == _myJson[i]["name"]) {
        _country = _myJson[i]["ind"];
        _contCode.text = _myJson[i]['countrycode'];
        _tempcontry = _myJson[i]['id'];
      }
    }
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  Future<bool> move() async {
    if(widget.sts==1) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ViewEmployee(empid:widget.empid, sts: widget.sts)), (
          Route<dynamic> route) => false,
      );
    }else if(widget.sts==2) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ViewEmployee(empid:widget.empid, sts: widget.sts)), (
          Route<dynamic> route) => false,
      );
    }else if(widget.sts==3) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ViewEmployee(empid:widget.empid, sts: widget.sts)), (
          Route<dynamic> route) => false,
      );
    }else if(widget.sts==4) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => EmployeeList(sts: widget.sts)), (
          Route<dynamic> route) => false,
      );
    }
    return false;
  }

  getmainhomewidget() {
    return WillPopScope(
      onWillPop: () => move(),
      child: RefreshIndicator(
        child: Scaffold(
          backgroundColor:scaffoldBackColor(),
          key: _scaffoldKey,
          appBar: new AppHeader(profileimage,showtabbar,orgName),
          bottomNavigationBar: Container(
            height: 70.0,
            decoration: new BoxDecoration(
              color: Colors.white,
              boxShadow: [new BoxShadow(
                color: Colors.grey,
                blurRadius: 3.0,
              ),]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonBar(
                  children: <Widget>[
                    widget.sts==4?RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: (_isServiceCalling && _isButtonDisabled)
                          ? Text(
                        'Processing..',
                        style: TextStyle(color: Colors.white),
                      )
                          : Text(
                        'ADD',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.orange[800],
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _isServiceCalling = true;
                            _isButtonDisabled = true;
                          });
                          print(path + 'addEmployee?uid=$uid&orgid=$orgid&empcode=${_empCode.text.trim()}&div=$div&loc=$loc&grade=$grade&dept=$dept&desg=$desg&empsts=$finalempsts&shift=$shift&fname=${_firstName.text.trim()}&lname=${_lastName.text.trim()}&dob=${_dob.text.trim()}&gender=$finalgender&doj=${_doj.text.trim()}&nationality=$nationality&country=$_tempcontry&contcode=${_contCode.text}&contact=${_contact.text.trim()}&email=${_email.text.trim()}');
                          var url = path + "addEmployee";
                          http.post(url, body: {
                            "uid": uid,
                            "orgid": orgid,
                            "empcode": _empCode.text.trim(),
                            "div": div,
                            "loc": loc,
                            "grade": grade,
                            "dept": dept,
                            "desg": desg,
                            "empsts": finalempsts,
                            "shift": shift,
                            "fname": _firstName.text.trim(),
                            "lname": _lastName.text.trim(),
                            "dob": _dob.text.trim(),
                            "gender": finalgender,
                            "doj": _doj.text.trim(),
                            "nationality": nationality,
                            "country": _tempcontry,
                            "contcode": _contCode.text,
                            "contact": _contact.text.trim(),
                            "email": _email.text.trim(),
                          }).then((response) async {
                            if (response.statusCode == 200) {
                              Map data = json.decode(response.body);
                              if (data['status'] == 'true') {
                                final prefs = await SharedPreferences.getInstance();
                                plansts = prefs.getInt('plansts');
                                empcount = prefs.getInt('empcount');
                                attcount = prefs.getInt('attcount');

                                Employee emp = new Employee(
                                  employeeid: uid,
                                  organization: orgid,
                                );

                                await getProfileInfo(emp, context);

                                if((adminsts==1 || divhrsts==1 || hrsts==1) && (plansts==0 && empcount>1 && attcount==0))
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePageMain()),
                                  );
                                else
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EmployeeList()),
                                  );

                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 3), () {
                                        Navigator.of(context).pop(true);
                                      });
                                      return AlertDialog(
                                        content: new Text(
                                            "Employee added successfully"),
                                      );
                                    });
                              } else if (data['status'] == 'false1') {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 3), () {
                                        Navigator.of(context).pop(true);
                                      });
                                      return AlertDialog(
                                        content: new Text(
                                            "Email ID already exists"),
                                      );
                                    });
                              } else if (data['status'] == 'false2') {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 3), () {
                                        Navigator.of(context).pop(true);
                                      });
                                      return AlertDialog(
                                        content: new Text(
                                            "Contact already exists"),
                                      );
                                    });
                              } else if (data['status'] == 'false3') {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 3), () {
                                        Navigator.of(context).pop(true);
                                      });
                                      return AlertDialog(
                                        content: new Text(
                                            "Employee Code already exists"),
                                      );
                                    });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 3), () {
                                        Navigator.of(context).pop(true);
                                      });
                                      return AlertDialog(
                                        content: new Text(
                                            "There is some while adding employee"),
                                      );
                                    });
                              }
                              setState(() {
                                _isServiceCalling = false;
                                _isButtonDisabled = false;
                              });
                            }
                          }).catchError((exp) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  Future.delayed(Duration(seconds: 3), () {
                                    Navigator.of(context).pop(true);
                                  });
                                  return AlertDialog(
                                    content: new Text("Unable to connect server"),
                                  );
                                });
                            print(exp.toString());
                            setState(() {
                              _isServiceCalling = false;
                              _isButtonDisabled = false;
                            });
                          });
                        }
                      },
                    ):RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: (_isServiceCalling && _isButtonDisabled)
                          ? Text(
                        'Processing..',
                        style: TextStyle(color: Colors.white),
                      )
                          : Text(
                        'UPDATE',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.orange[800],
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _isServiceCalling = true;
                            _isButtonDisabled = true;
                          });
                          var url = path + "updateEmp";
                          http.post(url, body: {
                            "uid": uid,
                            "empid": widget.empid,
                            "orgid": orgid,
                            "empcode": _empCode.text.trim(),
                            "div": div,
                            "loc": loc,
                            "grade": grade,
                            "dept": dept,
                            "desg": desg,
                            "empsts": finalempsts,
                            "shift": shift,
                            "fname": _firstName.text.trim(),
                            "lname": _lastName.text.trim(),
                            "dob": _dob.text.trim(),
                            "gender": finalgender,
                            "doj": _doj.text.trim(),
                            "nationality": nationality,
                            "country": _tempcontry,
                            "contcode": _contCode.text,
                            "contact": _contact.text.trim(),
                            "email": _email.text.trim(),
                          }).then((response) {
                            if (response.statusCode == 200) {
                              Map data = json.decode(response.body);
                              print(response.body.toString());
                              if (data['status'] == 'true') {
                                if(widget.sts==2) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CollapsingTab()), (
                                      Route<dynamic> route) => false,
                                  );
                                }else {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EmployeeList()), (
                                      Route<dynamic> route) => false,
                                  );
                                }
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 3), () {
                                        Navigator.of(context).pop(true);
                                      });
                                      return AlertDialog(
                                        content: new Text(
                                            "Employee updated successfully"),
                                      );
                                    });
                              } else if (data['status'] == 'false1') {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 3), () {
                                        Navigator.of(context).pop(true);
                                      });
                                      return AlertDialog(
                                        content: new Text(
                                            "Email ID already exists"),
                                      );
                                    });
                              } else if (data['status'] == 'false2') {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 3), () {
                                        Navigator.of(context).pop(true);
                                      });
                                      return AlertDialog(
                                        content: new Text(
                                            "Contact already exists"),
                                      );
                                    });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 3), () {
                                        Navigator.of(context).pop(true);
                                      });
                                      return AlertDialog(
                                        content: new Text(
                                            "There is some while updating employee"),
                                      );
                                    });
                              }
                              setState(() {
                                _isServiceCalling = false;
                                _isButtonDisabled = false;
                              });
                            }
                          }).catchError((exp) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  Future.delayed(Duration(seconds: 3), () {
                                    Navigator.of(context).pop(true);
                                  });
                                  return AlertDialog(
                                    content: new Text("Unable to connect server"),
                                  );
                                });
                            print(exp.toString());
                            setState(() {
                              _isServiceCalling = false;
                              _isButtonDisabled = false;
                            });
                          });
                        }
                      },
                    ),
                    SizedBox(width: 10.0),
                    FlatButton(
                      shape: Border.all(color: Colors.orange[800]),
                      child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
                      onPressed: () {
                        //Navigator.pop(context);
                        if(widget.sts==1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ViewEmployee(empid:widget.empid, sts: widget.sts))
                          );
                        }else if(widget.sts==2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ViewEmployee(empid:widget.empid, sts: widget.sts))
                          );
                        }else if(widget.sts==3) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ViewEmployee(empid:widget.empid, sts: widget.sts))
                          );
                          print(widget.sts);
                        }else if(widget.sts==4) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EmployeeList())
                          );
                        }else{
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ViewEmployee(empid:widget.empid))
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          endDrawer: new AppDrawer(),
          body: ModalProgressHUD(
            inAsyncCall: _isServiceCalling,
            opacity: 0.15,
            progressIndicator: SizedBox(
              child:new CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation(Colors.green),
                strokeWidth: 5.0),
              height: 40.0,
              width: 40.0,
            ),
            child: mainbodyWidget()
          )
        ),
        onRefresh: () async {
          Completer<Null> completer = new Completer<Null>();
          await Future.delayed(Duration(seconds: 1)).then((onvalue) {
            setState(() {
              _empCode.clear();
              _firstName.clear();
              _lastName.clear();
              _dob.clear();
              _doj.clear();
              _email.clear();
              _contact.clear();
              _contCode.clear();
              _pwd.clear();
              div = '0';
              dept = '0';
              desg = '0';
              loc = '0';
              shift = '0';
              shifttype = '0';
              grade = '0';
              empsts = '0';
              finalempsts = '0';
              gender = '0';
              finalgender = '0';
              nationality = '0';
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            });
            completer.complete();
          });
          return completer.future;
        },
      ),
    );
  }

  checkalreadylogin() {
    if (response == 1) {
      return new IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          underdevelopment(),
          mainbodyWidget(),
        ],
      );
    } else {
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  loader() {
    return new Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            //Image.asset('assets/spinner.gif', height: 30.0, width: 30.0),
            CircularProgressIndicator()
          ]
        )
      ),
    );
  }

  underdevelopment() {
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.android,
                color: appStartColor(),
              ),
              Text(
                "Under development",
                style: new TextStyle(fontSize: 30.0, color: appStartColor()),
              )
            ]),
      ),
    );
  }

  mainbodyWidget() {
    //if (pageload == true) loader();
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      decoration: new ShapeDecoration(
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
        color: Colors.white,
      ),
      child: Center(
        child: Form(
          key: _formKey,
          child: SafeArea(
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0.0,bottom: 10.0),
                  child: Center(
                    child:Text(widget.sts==4?"Add Employee":"Edit Employee Details",style: new TextStyle(fontSize: 22.0,color:appStartColor())),
                  ),
                ),
                SizedBox(height: 10),
                new Expanded(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:10.0),
                        child: Row(
                          children: <Widget>[
                            new Text("COMPANY DETAILS",
                              //textAlign: TextAlign.center,
                              style: new TextStyle(fontWeight: FontWeight.bold, fontSize:14.0, color:Colors.black/*color: appStartColor()*/ ),
                            ),
                            //Spacer()
                          ],
                        ),
                      ),
                      globallabelinfomap['emp_code']!=''?Padding(
                        padding: const EdgeInsets.only(left:10.0,right:10.0,top:10.0),
                        child: TextFormField(
                          enabled: widget.sts!=4?false:true,
                          controller: _empCode,
                          focusNode: __empCode,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            UpperCaseTextFormatter(),
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                            //labelText: "Employee Code",
                            //hintText: "Employee Code",
                            labelText: globallabelinfomap['emp_code'],
                            hintText: globallabelinfomap['emp_code'],
                            hintStyle: TextStyle(
                                fontSize: 14.0),
                            prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black54,
                          ),
                          ),
                          validator: (value) {
                            if (value.trim().isEmpty || value.isEmpty || value=="") {
                              return 'Please enter employee code';
                            }
                            return null;
                          },
                          /*onFieldSubmitted: (String value) {
                            if (_formKey.currentState.validate()) {
                              FocusScope.of(context).requestFocus(__empCode);
                            }
                          },*/
                        ),
                      ):Center(),
                      if(globallabelinfomap['depart']!='')getDepartments_DD(),
                      if(globallabelinfomap['desig']!='')getDesignations_DD(),
                      if(globallabelinfomap['shift']!='')getShifts_DD(),
                      Padding(
                        padding: const EdgeInsets.only(left:10.0,top:10.0,bottom:0.0),
                        child: Container(
                          child: Text("PERSONAL DETAILS",
                            style: new TextStyle(fontWeight: FontWeight.bold, fontSize:14.0, color:Colors.black/*color: appStartColor()*/ ),
                          ),
                        ),
                      ),
                      /*Padding(
                        padding: const EdgeInsets.only(left:10.0, top:10.0),
                        child: Row(
                          children: <Widget>[
                            new Text("PERSONAL DETAILS",
                              //textAlign: TextAlign.center,
                              style: new TextStyle(fontWeight: FontWeight.bold, fontSize:16.0, color:Colors.black/*color: appStartColor()*/),
                            ),
                            //Spacer()
                          ],
                        ),
                      ),*/
                      globallabelinfomap['first_name']!=''?Padding(
                        padding: const EdgeInsets.only(left:10.0,right:10.0,top:10.0),
                        child: TextFormField(
                          controller: _firstName,
                          focusNode: __firstName,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          //initialValue: _firstName.text,
                          decoration: InputDecoration(
                            //isDense: true,
                            border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                            //labelText: "First Name",
                            //hintText: "First Name",
                            labelText: globallabelinfomap['first_name'],
                            hintText: globallabelinfomap['first_name'],
                            hintStyle: TextStyle(
                                fontSize: 14.0),
                            prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black54,
                          ),
                          ),
                          validator: (value) {
                            if (value.trim().isEmpty || value.isEmpty || value=="") {
                              return 'Please enter first name';
                            }
                            return null;
                          },
                          /*onFieldSubmitted: (String value) {
                            if (_formKey.currentState.validate()) {
                              FocusScope.of(context).requestFocus(__firstName);
                            }
                          },*/
                        ),
                      ):Center(),
                      globallabelinfomap['last_name']!=''?SizedBox(height: 15.0):Center(),
                      globallabelinfomap['last_name']!=''?Padding(
                        padding: const EdgeInsets.only(left:10.0,right:10.0),
                        child: TextFormField(
                          controller: _lastName,
                          focusNode: __lastName,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          //initialValue: _firstName.text,
                          decoration: InputDecoration(
                            //isDense: true,
                            border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                            //labelText: "Last Name",
                            //hintText: "Last Name",
                            labelText: globallabelinfomap['last_name'],
                            hintText: globallabelinfomap['last_name'],
                            hintStyle: TextStyle(
                                fontSize: 14.0),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black54,
                            ),
                          ),
                          validator: (value) {
                            if (value.trim().isEmpty || value.isEmpty || value=="") {
                              return 'Please enter last name';
                            }
                            return null;
                          },
                          /*onFieldSubmitted: (String value) {
                            if (_formKey.currentState.validate()) {
                              FocusScope.of(context).requestFocus(__lastName);
                            }
                          },*/
                        ),
                      ):Center(),
                      globallabelinfomap['dob']!=''?SizedBox(height: 15.0):Center(),
                      globallabelinfomap['dob']!=''?Padding(
                        padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                        child: Container(
                          child:DateTimeField(
                            format: dateFormat,
                            controller: _dob,
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1970),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100)
                              );
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                              //labelText: "Date Of Birth",
                              //hintText: "Date Of Birth",
                              labelText: globallabelinfomap['dob'],
                              hintText: globallabelinfomap['dob'],
                              hintStyle: TextStyle(
                                  fontSize: 14.0),
                              prefixIcon: Icon(
                                Icons.date_range,
                                color: Colors.black54,
                              ),
                            ),
                            onChanged: (date) {
                              setState(() {
                                Date1 = date;
                              });
                            },
                            validator: (value) {
                              if (_dob.text=="") {
                                return 'Please enter dob';
                              }
                              return null;
                            },
                          ),
                        ),
                      ):Center(),
                      if(globallabelinfomap['gender']!='')getGender_DD(),
                      globallabelinfomap['doj']!=''?SizedBox(height: 15.0):Center(),
                      globallabelinfomap['doj']!=''?Padding(
                        padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                        child: Container(
                          child:DateTimeField(
                            format: dateFormat,
                            controller: _doj,
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1970),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100)
                              );
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                              //labelText: "Date Of Joining",
                              //hintText: "Date Of Joining",
                              labelText: globallabelinfomap['doj'],
                              hintText: globallabelinfomap['doj'],
                              hintStyle: TextStyle(
                                  fontSize: 14.0),
                              prefixIcon: Icon(
                                Icons.date_range,
                                color: Colors.black54,
                              ),
                            ),
                            onChanged: (date) {
                              setState(() {
                                Date2 = date;
                              });
                            },
                            validator: (value) {
                              if (_doj.text=="") {
                                return 'Please enter doj';
                              }
                              return null;
                            },
                          ),
                        ),
                      ):Center(),
                      Padding(
                        padding: const EdgeInsets.only(left:10.0,top:10.0,bottom:10.0),
                        child: Container(
                            child: Text("CONTACT DETAILS",
                              style: new TextStyle(fontWeight: FontWeight.bold, fontSize:14.0, color:Colors.black/*color: appStartColor()*/ ),
                            ),
                        ),
                      ),
                      /*Padding(
                        padding: const EdgeInsets.only(left:10.0,top:10.0,bottom:10.0),
                        child: Row(
                          children: <Widget>[
                            new Text("CONTACT DETAILS",
                              style: new TextStyle(fontWeight: FontWeight.bold, fontSize:16.0, color:Colors.black/*color: appStartColor()*/ ),
                            ),
                          ],
                        ),
                      ),*/
                      getCountry_DD(),
                      globallabelinfomap['personal_no']!=''?SizedBox(height: 15.0):Center(),
                      globallabelinfomap['personal_no']!=''?Row(
                        children: <Widget>[
                          _country!=''?new Expanded(
                            flex: 16,
                            child:Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 0.0),
                                child: new TextFormField(
                                  enabled: false,
                                  textAlign: TextAlign.justify,
                                  style: new TextStyle(
                                    height: 1.25,
                                    color: Colors.black54,
                                  ),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                                  ),
                                  controller: _contCode,
                                  focusNode: __contCode,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly,
                                  ],
                                )
                            ),
                          ):Center(),
                          Expanded(
                            flex: 73,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: TextFormField(
                                controller: _contact,
                                focusNode: __contact,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                                    //labelText: "Phone",
                                    //hintText: "Phone",
                                    labelText: globallabelinfomap['personal_no'],
                                    hintText: globallabelinfomap['personal_no'],
                                    hintStyle: TextStyle(
                                        fontSize: 14.0),
                                    prefixIcon: Icon(
                                      Icons.call,
                                      color: Colors.black54,
                                      size: 25,
                                    )
                                ),
                                validator: (value) {
                                  if (value.isEmpty || value.trim().isEmpty){
                                    return 'Please enter phone no.';
                                  }
                                  if (value.length < 6){
                                    return 'Phone no. should contain greater than 6 \ndigit';
                                  }
                                  if (value.length > 15){
                                    return 'Phone no. should contain less than 15 \ndigit';
                                  }
                                  return null;
                                },
                                /*onFieldSubmitted: (String value) {
                                  if (_formKey.currentState.validate()) {
                                    FocusScope.of(context).requestFocus(__contact);
                                  }
                                },*/
                              ),
                            ),
                          ),
                        ],
                      ):Center(),
                      globallabelinfomap['current_email_id']!=''?SizedBox(height: 15.0):Center(),
                      globallabelinfomap['current_email_id']!=''?Padding(
                        padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                        child: TextFormField(
                          controller: _email,
                          focusNode: __email,
                          // initialValue: widget.email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            //isDense: true,
                            border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                            //labelText: "Email",
                            //hintText: "Email",
                            labelText: globallabelinfomap['current_email_id'],
                            hintText: globallabelinfomap['current_email_id'],
                            hintStyle: TextStyle(
                                fontSize: 14.0),
                              prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black54,
                              size: 25,
                            )
                          ),
                          validator: (value) {
                            Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            if (value.isNotEmpty && !regex.hasMatch(value)) {
                              return 'Enter valid email id';
                            }
                            return null;
                          },
                          /*onFieldSubmitted: (String value) {
                            if (_formKey.currentState.validate()) {
                              FocusScope.of(context).requestFocus(__email);
                            }
                          }*/
                        ),
                      ):Center(),
                      Padding(
                        padding: const EdgeInsets.only(left:10.0,top:10.0,bottom:10.0),
                        child: Container(
                          child: Text("ADDITIONAL DETAILS",
                            style: new TextStyle(fontWeight: FontWeight.bold, fontSize:14.0, color:Colors.black/*color: appStartColor()*/ ),
                          ),
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(left: 15.0, right: 2.0),
                        child:new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            visibilityTag == false?new InkWell(
                              onTap:() {
                                setState((){
                                  visibilityTag=true;
                                });
                              },
                              child:Text("Show Details",textAlign: TextAlign.justify,
                                style: new TextStyle(fontSize:18.0,color: appStartColor() ,
                                  decoration: TextDecoration.underline,
                                )
                              ),
                            ): new InkWell(
                              onTap:() {
                                setState(() {
                                  visibilityTag = false;
                                });
                                if(globallabelinfomap['division']!='')getDivisions_DD();
                                if(globallabelinfomap['location']!='')getLocations_DD();
                                if(globallabelinfomap['grade']!='')getGrades_DD();
                                if(globallabelinfomap['empsts']!='')getEmployeeStatus_DD();
                                if(globallabelinfomap['nationality']!='')getNationality_DD();
                              },
                              child:Text("Hide Details",textAlign: TextAlign.center,
                                style: new TextStyle( fontSize:18.0, color: appStartColor(),
                                  decoration: TextDecoration.underline,)
                              )
                            ),
                          ]
                        )
                      ),
                      if(globallabelinfomap['division']!='' && visibilityTag == true)getDivisions_DD(),
                      if(globallabelinfomap['location']!='' && visibilityTag == true)getLocations_DD(),
                      if(globallabelinfomap['grade']!='' && visibilityTag == true)getGrades_DD(),
                      if(globallabelinfomap['empsts']!='' && visibilityTag == true)getEmployeeStatus_DD(),
                      if(globallabelinfomap['nationality']!='' && visibilityTag == true)getNationality_DD(),
                    ],
                  ),
                ),
              ]
            )
          ),
        ),
      ),
    );
  }

  ///////////////////////common dropdowns/////////////////////
  Widget getDivisions_DD() {
    return new FutureBuilder<List<Map>>(
      future: getDivisionsList(0), //with -select- label
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:15.0, right:15.0, top:5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      globallabelinfomap['division'],
                      style: TextStyle(
                        fontSize:15.0,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w500,
                        //color: div=='0'?Colors.red[700]:Colors.black
                      ),
                    ),

                    widget.sts==4?InkWell(
                      child: Row(
                        children: <Widget>[
                          Tooltip(
                            message: "Add Division",
                            child: Icon(
                              Icons.add,
                              size: 24,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      onTap: (){
                        _divCode = new TextEditingController();
                        _divName = new TextEditingController();
                        getDivCode().then((res) {
                          setState(() {
                            divCode = res;
                            print(divCode);
                            _divCode.text=divCode;
                          });
                        });
                        _showDialogDiv(context);
                      },
                    ):Center(),
                  ],
                ),
              ),
              SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    child: new DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                          //labelText: "Division",
                          /*hintText: "Division",
                          hintStyle: TextStyle(
                              fontSize: 14.0),*/
                          prefixIcon: Icon(
                            Icons.home_work_outlined,
                            color: Colors.black54,
                            size: 25,
                          )
                      ),
                      isExpanded: true,
                      isDense: true,
                      style: new TextStyle(fontSize: 15.0, color: Colors.black),
                      value: div,
                      onChanged: (String newValue) {
                        setState(() {
                          div = newValue;
                          print("div");
                          print(div);
                        });
                      },
                      items: snapshot.data.map((Map map) {
                        return new DropdownMenuItem<String>(
                          value: map["Id"].toString(),
                          child:new Text(
                            map["Name"],
                          )
                        );
                      }).toList(),
                      validator: (String value) {
                        if (div == '0') {
                          return 'Please select a division';
                        }
                        return null;
                      }
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }
        // return loader();
        return new Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
            ),
            height: 20.0,
            width: 20.0,
          ),
        );
      }
    );
  }

  _showDialogDiv(context) async {
    await showDialog<String>(
      barrierDismissible: false,
      context: context,
      child: new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.all(15.0),
        content: Form(
          key: _divFormKey,
          child: Container(
            //height: MediaQuery.of(context).size.height*0.28,
            //width: MediaQuery.of(context).size.width*0.35,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //SizedBox(height: 5.0),
                Center(
                  child:Text("Add Division",style: new TextStyle(fontSize: 22.0,color:appStartColor())),
                ),
                SizedBox(height: 15.0),
                new TextFormField(
                  //enabled: false,
                  autofocus: false,
                  controller: _divCode,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Division Code',
                      hintStyle: _hintStyle
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty || value.isEmpty || value=="") {
                      return 'Please enter division code';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                new DropdownButtonHideUnderline(
                  child:  new DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                      ),
                    ),
                    isExpanded: true,
                    isDense: true,
                    hint: new Text("Select Country", style: TextStyle(fontSize: 14.0)),
                    value: _country,
                    onChanged: (String newValue) {
                      setState(() {
                        _country = newValue;
                        _tempcontry = _myJson[int.parse(newValue)]['id'];
                      });
                      print("_country");
                      print(_country);
                      print(_tempcontry);
                    },
                    items: _myJson.map((Map map) {
                      return new DropdownMenuItem<String>(
                        value: map["ind"].toString(),
                        child: new Text(
                          map["name"],
                        ),
                      );
                    }).toList(),
                    validator: (String value) {
                      if (_tempcontry.isEmpty) {
                        return 'Please select country';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                new TextFormField(
                  autofocus: false,
                  controller: _divName,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Division Name',
                      hintStyle: _hintStyle
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty || value.isEmpty || value=="") {
                      return 'Please enter division name';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: (_isServiceCalling && _isButtonDisabled)
                ? Text(
              'Adding..',
              style: TextStyle(color: Colors.white),
            )
                : Text(
              'ADD',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.orange[800],
            onPressed: () {
              if (_divFormKey.currentState.validate()) {
                setState(() {
                  _isServiceCalling = true;
                  _isButtonDisabled = true;
                });
                var url = path + "addDivision";
                http.post(url, body: {
                  "uid": uid,
                  "orgid": orgid,
                  "code": _divCode.text.trim(),
                  "contid": _tempcontry,
                  "name": _divName.text.trim(),
                }).then((response) {
                  print(path + 'addDivision?uid=$uid&orgid=$orgid&code=${_divCode.text}&contid=$_tempcontry&name=${_divName.text}');
                  print(response.body.toString());
                  if (response.statusCode == 200) {
                    Map data = json.decode(response.body);
                    print(response.body.toString());
                    print(data["sts"]);
                    if (data["sts"].contains("true")) {
                      divid = data["divid"];
                      div = divid;
                      Navigator.of(context, rootNavigator: true).pop();
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("Division added successfully"),
                            );
                          });
                    } else if (data["sts"].contains("alreadyexists")) {
                      divid = data["divid"];
                      div = divid;
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("Division Code or Name already exists"),
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("There is some problem while adding Division"),
                            );
                          });
                    }
                    setState(() {
                      _isServiceCalling = false;
                      _isButtonDisabled = false;
                    });
                  }
                });
              }
            },
          ),
          //SizedBox(width: 10.0),
          FlatButton(
            shape: Border.all(color: Colors.orange[800]),
            child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
            onPressed: () {
              _divCode.clear();
              _divName.clear();
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget getDepartments_DD() {
    return new FutureBuilder<List<Map>>(
      future: getDepartmentsList(0), //with -select- label
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          /*if(widget.sts==4) {
            for (int i = 0; i < snapshot.data.length; i++) {
              if (snapshot.data[i]["Name"] == "Trial Department") {
                dept = snapshot.data[i]["Id"];
              }
            }
          }*/
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:15.0, right:15.0, top:5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      globallabelinfomap['depart'],
                      style: TextStyle(
                        fontSize:15.0,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w500,
                        //color: dept=='0'?Colors.red[700]:Colors.black
                      ),
                    ),

                    widget.sts==4?InkWell(
                      child: Row(
                        children: <Widget>[
                          Tooltip(
                            message: "Add Department",
                            child: Icon(
                              Icons.add,
                              size: 24,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      onTap: (){
                        _deptCode = new TextEditingController();
                        _deptName = new TextEditingController();
                        getDeptCode().then((res) {
                          setState(() {
                            deptCode = res;
                            print("deptCode");
                            print(deptCode);
                            _deptCode.text=deptCode;
                          });
                        });
                        _showDialogDept(context);
                      },
                    ):Center(),
                  ],
                ),
              ),
              SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        child: new DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                              //labelText: "Department",
                              /*hintText: "Department",
                              hintStyle: TextStyle(
                                  fontSize: 14.0),*/
                              prefixIcon: Icon(
                                const IconData(0xe803, fontFamily: "CustomIcon"),
                                color: Colors.black54,
                                size: 25,
                              )
                          ),
                          isExpanded: true,
                          isDense: true,
                          style: new TextStyle(fontSize: 15.0, color: Colors.black),
                          value: dept,
                          onChanged: (String newValue) {
                            setState(() {
                              dept = newValue;
                              print("dept");
                              print(dept);
                            });
                          },
                          items: snapshot.data.map((Map map) {
                            return new DropdownMenuItem<String>(
                              value: map["Id"].toString(),
                              child: new Text(
                                map["Name"],
                              )
                            );
                          }).toList(),
                          validator: (String value) {
                            if (dept=='0') {
                              return 'Please select a department';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
            ],
          );
        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }
        // return loader();
        return new Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
            ),
            height: 20.0,
            width: 20.0,
          ),
        );
      }
    );
  }

  _showDialogDept(context) async {
    await showDialog<String>(
      barrierDismissible: false,
      context: context,
      child: new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.all(15.0),
        content: Form(
          key: _deptFormKey,
          child: Container(
            //height: MediaQuery.of(context).size.height*0.20,
            //width: MediaQuery.of(context).size.width*0.35,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //SizedBox(height: 5.0),
                Center(
                  child:Text("Add Department",style: new TextStyle(fontSize: 22.0,color:appStartColor())),
                ),
                SizedBox(height: 15.0),
                new TextFormField(
                  //enabled: false,
                  autofocus: false,
                  controller: _deptCode,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(),
                      ),
                      //labelText: 'Department Code',
                      hintText: 'Department Code',
                      hintStyle: _hintStyle
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty || value.isEmpty || value=="") {
                      return 'Please enter department code';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                new TextFormField(
                  autofocus: false,
                  controller: _deptName,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(),
                      ),
                      //labelText: 'Department Name',
                      hintText: 'Department Name',
                      hintStyle: _hintStyle
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty || value.isEmpty || value=="") {
                      return 'Please enter department name';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: (_isServiceCalling && _isButtonDisabled)
                ? Text(
              'Adding..',
              style: TextStyle(color: Colors.white),
            )
                : Text(
              'ADD',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.orange[800],
            onPressed: () {
              if (_deptFormKey.currentState.validate()) {
                setState(() {
                  _isServiceCalling = true;
                  _isButtonDisabled = true;
                });
                var url = path + "addDepartment";
                http.post(url, body: {
                  "uid": uid,
                  "orgid": orgid,
                  "code": _deptCode.text.trim(),
                  "name": _deptName.text.trim(),
                }).then((response) {
                  print(path + 'addDepartment?uid=$uid&orgid=$orgid&code=${_deptCode.text}&name=${_deptName.text}');
                  print(response.body.toString());
                  if (response.statusCode == 200) {
                    Map data = json.decode(response.body);
                    print(response.body.toString());
                    print(data["sts"]);
                    if (data["sts"].contains("true")) {
                      deptid = data["deptid"];
                      dept = deptid;
                      Navigator.of(context, rootNavigator: true).pop();
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("Department added successfully"),
                            );
                          });
                    } else if (data["sts"].contains("alreadyexists")) {
                      deptid = data["deptid"];
                      dept = deptid;
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("Department Code or Name already exists"),
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text(
                                  "There is some problem while adding department"),
                            );
                          });
                    }
                    setState(() {
                      _isServiceCalling = false;
                      _isButtonDisabled = false;
                    });
                  }
                });
              }
            },
          ),
          //SizedBox(width: 10.0),
          FlatButton(
            shape: Border.all(color: Colors.orange[800]),
            child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
            onPressed: () {
              _deptCode.clear();
              _deptName.clear();
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget getDesignations_DD() {
    return new FutureBuilder<List<Map>>(
      future: getDesignationsList(0),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          /*if(widget.sts==4) {
            for (int i = 0; i < snapshot.data.length; i++) {
              if (snapshot.data[i]["Name"] == "Trial Designation") {
                desg = snapshot.data[i]["Id"];
              }
            }
          }*/
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:15.0, right:15.0, top:5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      globallabelinfomap['desig'],
                      style: TextStyle(
                        fontSize:15.0,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w500,
                        //color: desg=='0'?Colors.red[700]:Colors.black
                      ),
                    ),

                    widget.sts==4?InkWell(
                      child: Row(
                        children: <Widget>[
                          Tooltip(
                            message: "Add Designation",
                            child: Icon(
                              Icons.add,
                              size: 24,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      onTap: (){
                        _desgCode = new TextEditingController();
                        _desgName = new TextEditingController();
                        getDesgCode().then((res) {
                          setState(() {
                            desgCode = res;
                            print("desgCode");
                            print(desgCode);
                            _desgCode.text=desgCode;
                          });
                        });
                        _showDialogDesg(context);
                      },
                    ):Center(),
                  ],
                ),
              ),
              SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    child: new DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                        //labelText: "Designation",
                        /*hintText: "Designation",
                        hintStyle: TextStyle(
                            fontSize: 14.0),*/
                        prefixIcon: Icon(
                            const IconData(0xe804, fontFamily: "CustomIcon"),
                            color: Colors.black54,
                            size: 25
                        ),
                      ),
                      isExpanded: true,
                      isDense: true,
                      style: new TextStyle(fontSize: 15.0, color: Colors.black),
                      value: desg,
                      onChanged: (String newValue) {
                        setState(() {
                          desg = newValue;
                        });
                      },
                      items: snapshot.data.map((Map map) {
                        return new DropdownMenuItem<String>(
                          value: map["Id"].toString(),
                          child: new Text(
                            map["Name"],
                          )
                        );
                      }).toList(),
                      validator: (String value) {
                        if (desg=='0') {
                          return 'Please select a designation';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }
        // return loader();
        return new Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
            ),
            height: 20.0,
            width: 20.0,
          ),
        );
      }
    );
  }

  _showDialogDesg(context) async {
    await showDialog<String>(
      barrierDismissible: false,
      context: context,
      child: new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.all(15.0),
        content: Form(
          key: _desgFormKey,
          child: Container(
            //height: MediaQuery.of(context).size.height*0.20,
            //width: MediaQuery.of(context).size.width*0.35,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //SizedBox(height: 5.0),
                Center(
                  child:Text("Add Designation",style: new TextStyle(fontSize: 22.0,color:appStartColor())),
                ),
                SizedBox(height: 15.0),
                new TextFormField(
                  //enabled: false,
                  autofocus: false,
                  controller: _desgCode,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(),
                      ),
                      //labelText: 'Designation Code',
                      hintText: 'Designation Code',
                      hintStyle: _hintStyle
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty || value.isEmpty || value=="") {
                      return 'Please enter department code';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                new TextFormField(
                  autofocus: false,
                  controller: _desgName,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(),
                      ),
                      //labelText: 'Designation Name',
                      hintText: 'Designation Name',
                      hintStyle: _hintStyle
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty || value.isEmpty || value=="") {
                      return 'Please enter designation name';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: (_isServiceCalling && _isButtonDisabled)
                ? Text(
              'Adding..',
              style: TextStyle(color: Colors.white),
            )
                : Text(
              'ADD',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.orange[800],
            onPressed: () {
              if (_desgFormKey.currentState.validate()) {
                setState(() {
                  _isServiceCalling = true;
                  _isButtonDisabled = true;
                });
                var url = path + "addDesignation";
                http.post(url, body: {
                  "uid": uid,
                  "orgid": orgid,
                  "code": _desgCode.text.trim(),
                  "name": _desgName.text.trim(),
                }).then((response) {
                  print(path + 'addDesignation?uid=$uid&orgid=$orgid&code=${_desgCode.text}&name=${_desgName.text}');
                  print(response.body.toString());
                  if (response.statusCode == 200) {
                    Map data = json.decode(response.body);
                    print(response.body.toString());
                    print(data["sts"]);
                    if (data["sts"].contains("true")) {
                      desgid = data["desgid"];
                      desg = desgid;
                      Navigator.of(context, rootNavigator: true).pop();
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("Designation added successfully"),
                            );
                          });
                    } else if (data["sts"].contains("alreadyexists")) {
                      desgid = data["desgid"];
                      desg = desgid;
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("Designation Code or Name already exists"),
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("There is some problem while adding Designation"),
                            );
                          });
                    }
                    setState(() {
                      _isServiceCalling = false;
                      _isButtonDisabled = false;
                    });
                  }
                });
              }
            },
          ),
          //SizedBox(width: 10.0),
          FlatButton(
            shape: Border.all(color: Colors.orange[800]),
            child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
            onPressed: () {
              _desgCode.clear();
              _desgName.clear();
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget getLocations_DD() {
    return new FutureBuilder<List<Map>>(
      future: getLocationsList(0),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          /*if(widget.sts==4) {
            if (snapshot.data.length > 0) {
              for (int i = 0; i < snapshot.data.length; i++) {
                if (snapshot.data[i]["Name"] == "Trial Location") {
                  loc = snapshot.data[i]["Id"];
                } else {
                  loc = "0";
                }
              }
            } else {
              loc = "0";
            }
          }*/
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:15.0, right:15.0, top:0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      globallabelinfomap['location'],
                      style: TextStyle(
                        fontSize:15.0,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w500,
                        //color: loc=='0'?Colors.red[700]:Colors.black
                      ),
                    ),

                    widget.sts==4?InkWell(
                      child: Row(
                        children: <Widget>[
                          Tooltip(
                            message: "Add Location",
                            child: Icon(
                              Icons.add,
                              size: 24,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      onTap: (){
                        _locCode = new TextEditingController();
                        _locArea = new TextEditingController();
                        getLocCode().then((res) {
                          setState(() {
                            locCode = res;
                            print("locCode");
                            print(locCode);
                            _locCode.text=locCode;
                          });
                        });
                        _showDialogLoc(context);
                      },
                    ):Center(),
                  ],
                ),
              ),
              SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    child: new DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                        //border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: Colors.black54,
                          size: 25,
                        ),
                        //labelText: "Location",
                        /*hintText: "Location",
                        hintStyle: TextStyle(
                            fontSize: 14.0),*/
                      ),
                      isExpanded: true,
                      isDense: true,
                      style: new TextStyle(fontSize: 15.0, color: Colors.black),
                      value: loc,
                      onChanged: (String newValue) {
                        setState(() {
                          loc = newValue;
                        });
                      },
                      items: snapshot.data.map((Map map) {
                        return new DropdownMenuItem<String>(
                          value: map["Id"].toString(),
                          child: new Text(
                            map["Name"],
                          )
                        );
                      }).toList(),
                      validator: (String value) {
                        if (loc=='0') {
                          return 'Please select a location';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }
        return new Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
            ),
            height: 20.0,
            width: 20.0,
          ),
        );
      }
    );
  }

  _showDialogLoc(context) async {
    await showDialog<String>(
      barrierDismissible: false,
      context: context,
      child: new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.all(15.0),
        content: Form(
          key: _locFormKey,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child:Text("Add Location",style: new TextStyle(fontSize: 22.0,color:appStartColor())),
                ),
                SizedBox(height: 15.0),
                new TextFormField(
                  //enabled: false,
                  autofocus: false,
                  controller: _locCode,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Location Code',
                      hintStyle: _hintStyle
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty || value.isEmpty || value=="") {
                      return 'Please enter location code';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                new TextFormField(
                  autofocus: false,
                  controller: _locArea,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Location Area',
                      hintStyle: _hintStyle
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty || value.isEmpty || value=="") {
                      return 'Please enter location area';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: (_isServiceCalling && _isButtonDisabled) ? Text('Adding..', style: TextStyle(color: Colors.white),
            ) : Text('ADD', style: TextStyle(color: Colors.white),),
            color: Colors.orange[800],
            onPressed: () {
              if (_locFormKey.currentState.validate()) {
                setState(() {
                  _isServiceCalling = true;
                  _isButtonDisabled = true;
                });
                var url = path + "addLocation";
                http.post(url, body: {
                  "uid": uid,
                  "orgid": orgid,
                  "code": _locCode.text.trim(),
                  "name": _locArea.text.trim(),
                }).then((response) {
                  print(path + 'addLocation?uid=$uid&orgid=$orgid&code=${_locCode.text}&name=${_locArea.text}');
                  print(response.body.toString());
                  if (response.statusCode == 200) {
                    Map data = json.decode(response.body);
                    print(response.body.toString());
                    print(data["sts"]);
                    if (data["sts"].contains("true")) {
                      locid = data["locid"];
                      loc = locid;
                      Navigator.of(context, rootNavigator: true).pop();
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("Location added successfully"),
                            );
                          });
                    } else if (data["sts"].contains("alreadyexists")) {
                      locid = data["locid"];
                      loc = locid;
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("Location Code or Area already exists"),
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("There is some problem while adding Location"),
                            );
                          });
                    }
                    setState(() {
                      _isServiceCalling = false;
                      _isButtonDisabled = false;
                    });
                  }
                });
              }
            },
          ),
          //SizedBox(width: 10.0),
          FlatButton(
            shape: Border.all(color: Colors.orange[800]),
            child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
            onPressed: () {
              _locCode.clear();
              _locArea.clear();
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget getShifts_DD() {
    return new FutureBuilder<List<Map>>(
      future: getShiftsList(0),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          /*if(widget.sts==4) {
            for (int i = 0; i < snapshot.data.length; i++) {
              if (snapshot.data[i]["Name"] == "Trial Shift") {
                shift = snapshot.data[i]["Id"];
              }
            }
          }*/
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:15.0, right:15.0, top:5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      globallabelinfomap['shift'],
                      style: TextStyle(
                        fontSize:15.0,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w500,
                        //color: shift=='0'?Colors.red[700]:Colors.black
                      ),
                    ),

                    widget.sts==4?InkWell(
                      child: Row(
                        children: <Widget>[
                          Tooltip(
                            message: "Add Shift",
                            child: Icon(
                              Icons.add,
                              size: 24,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      onTap: (){
                        shifttype='0';
                        _shiftName = new TextEditingController();
                        _shiftStartTimeController = new TextEditingController();
                        _shiftEndTimeController = new TextEditingController();
                        _showDialogShift(context);
                      },
                    ):Center(),
                  ],
                ),
              ),
              SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.only(left:10.0, right:10.0),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    child: new DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                        //border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.access_alarm,
                          color: Colors.black54,
                          size: 25,
                        ),
                      ),
                      isExpanded: true,
                      isDense: true,
                      style: new TextStyle(fontSize: 15.0, color: Colors.black),
                      value: shift,
                      onChanged: (String newValue) {
                        setState(() {
                          shift = newValue;
                        });
                      },
                      items: snapshot.data.map((Map map) {
                        return new DropdownMenuItem<String>(
                          value: map["Id"].toString(),
                          child: new Text(
                            map["Name"],
                          )
                        );
                      }).toList(),
                      validator: (String value) {
                        if (shift=='0') {
                          return 'Please select a shift';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }
        // return loader();
        return new Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
            ),
            height: 20.0,
            width: 20.0,
          ),
        );
      }
    );
  }

  _showDialogShift(context) async {
    await showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.all(15.0),
          content: Form(
            key: _shiftFormKey,
            child: Container(
              //height: MediaQuery.of(context).size.height*0.35,
              //width: MediaQuery.of(context).size.width*0.40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Text("Add Shift", style: new TextStyle(
                        fontSize: 22.0, color: appStartColor())),
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Shift starts and ends within",
                        style: TextStyle(fontWeight: FontWeight.w600),),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  new DropdownButtonHideUnderline(
                    child:  new DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                        ),
                      ),
                      isExpanded: true,
                      isDense: true,
                      //hint: new Text("Select Shift Type", style: TextStyle(fontSize: 14.0)),
                      value: shifttype,
                      onChanged: (String newValue) {
                        setState(() {
                          shifttype = newValue;
                        });
                        print("shifttype");
                        print(shifttype);
                      },
                      items: _shifttype.map((Map map) {
                        return new DropdownMenuItem<String>(
                          value: map["id"].toString(),
                          child: new Text(
                            map["name"],
                          ),
                        );
                      }).toList(),
                      validator: (String value) {
                        if (shifttype=='0') {
                          return 'Please select shift type';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  new TextFormField(
                    autofocus: false,
                    controller: _shiftName,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: new InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(),
                        ),
                        hintText: 'Shift Name',
                        hintStyle: _hintStyle
                    ),
                    validator: (value) {
                      if (value.trim().isEmpty || value.isEmpty || value=="") {
                        return 'Please enter shift name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Shift Hours",
                        style: TextStyle(fontWeight: FontWeight.w600),),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  new Row(
                    children: <Widget>[
                      Expanded(
                        child: DateTimeField(
                          format: timeFormat,
                          controller: _shiftStartTimeController,
                          readOnly: true,
                          onShowPicker: (context, currentValue) async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            return DateTimeField.convert(time);
                          },
                          decoration: new InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(),
                              ),
                              //labelText: 'From',
                              hintText: 'Start Time',
                              hintStyle: _hintStyle
                          ),
                          validator: (time) {
                            if (time == null) {
                              return "Please enter \nshift's start time";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Expanded(
                        child: DateTimeField(
                          //initialTime: new TimeOfDay.now(),
                          format: timeFormat,
                          controller: _shiftEndTimeController,
                          readOnly: true,
                          onShowPicker: (context, currentValue) async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            return DateTimeField.convert(time);
                          },
                          decoration: new InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(),
                              ),
                              //labelText: 'To',
                              hintText: 'End Time',
                              hintStyle: _hintStyle
                          ),
                          validator: (time) {
                            if (time == null) {
                              return "Please enter \nshift's end time";
                            }
                            var arr=_shiftStartTimeController.text.split(':');
                            var arr1=_shiftEndTimeController.text.split(':');
                            final startTime = DateTime(2018, 6, 23,int.parse(arr[0]),int.parse(arr[1]),00,00);
                            final endTime = DateTime(2018, 6, 23,int.parse(arr1[0]),int.parse(arr1[1]),00,00);
                            if(shifttype==1 && endTime.isBefore(startTime)){
                              return "Shift End time Can't \nbe earlier than shift start time";
                            }else if(startTime.isAtSameMomentAs(endTime)){
                              return "Shift start and end \ntime can't be same";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  /*SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Break Hours",style: TextStyle(fontWeight: FontWeight.w600),),
                  ],
                ),
                SizedBox(height: 5.0),
                new Row(
                  children: <Widget>[
                    Expanded(
                      child:DateTimeField(
                        format: timeFormat,
                        controller: _breakStartTimeController,
                        readOnly: true,
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.convert(time);
                        },
                        decoration: new InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(),
                            ),
                            labelText: 'From',
                            hintText: 'From',
                            hintStyle: _hintStyle
                        ),
                        validator: (time) {
                          if (time==null) {
                            return 'Please enter start time';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child:DateTimeField(
                        //initialTime: new TimeOfDay.now(),
                        format: timeFormat,
                        controller: _breakEndTimeController,
                        readOnly: true,
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.convert(time);
                        },
                        decoration: new InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(),
                            ),
                            labelText: 'To',
                            hintText: 'To',
                            hintStyle: _hintStyle
                        ),
                        validator: (time) {
                          if (time==null) {
                            return 'Please enter end time';
                          }
                          return null;
                          */ /*var arr=_starttimeController.text.split(':');
                          var arr1=_endtimeController.text.split(':');
                          final startTime = DateTime(2018, 6, 23,int.parse(arr[0]),int.parse(arr[1]),00,00);
                          final endTime = DateTime(2018, 6, 23,int.parse(arr1[0]),int.parse(arr1[1]),00,00);
                          if(endTime.isBefore(startTime)){
                            return '\"To Time\" can\'t be smaller.';
                          }else if(startTime.isAtSameMomentAs(endTime)){
                            return '\"To Time\" can\'t be equal.';
                          }*/ /*
                        },
                      ),
                    ),
                  ],
                ),*/
                ],
              ),
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: (_isServiceCalling && _isButtonDisabled)
                  ? Text(
                'Adding..',
                style: TextStyle(color: Colors.white),
              )
                  : Text(
                'ADD',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.orange[800],
              onPressed: () {
                if (_shiftFormKey.currentState.validate()) {
                  setState(() {
                    _isServiceCalling = true;
                    _isButtonDisabled = true;
                  });
                  var url = path + "addShift";
                  http.post(url, body: {
                    "uid": uid,
                    "orgid": orgid,
                    "shifttype": shifttype,
                    "name": _shiftName.text.trim(),
                    "shiftstart": _shiftStartTimeController.text.trim(),
                    "shiftend": _shiftEndTimeController.text.trim(),
                  }).then((response) {
                    print(path + 'addShift?uid=$uid&orgid=$orgid&shifttype=$shifttype&name=${_shiftName.text.trim()}&shiftstart=${_shiftStartTimeController.text.trim()}&shiftend=${_shiftEndTimeController.text.trim()}');
                    print(response.body.toString());
                    if (response.statusCode == 200) {
                      Map data = json.decode(response.body);
                      print(response.body.toString());
                      print(data["sts"]);
                      print(data["shiftid"]);
                      if (data["sts"].contains("true")) {
                        shiftid = data["shiftid"];
                        shift = shiftid;
                        Navigator.of(context, rootNavigator: true).pop();
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 3), () {
                                Navigator.of(context).pop(true);
                              });
                              return AlertDialog(
                                content: new Text("Shift added successfully"),
                              );
                            });
                      } else if (data["sts"].contains("alreadyexists")) {
                        shiftid = data["shiftid"];
                        shift = shiftid;
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 3), () {
                                Navigator.of(context).pop(true);
                              });
                              return AlertDialog(
                                content: new Text("Shift with this name already exists"),
                              );
                            });
                      } else if (data["sts"].contains("false1")) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 3), () {
                                Navigator.of(context).pop(true);
                              });
                              return AlertDialog(
                                content: new Text("Shift hours should be less than 20:00 hours"),
                              );
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 3), () {
                                Navigator.of(context).pop(true);
                              });
                              return AlertDialog(
                                content: new Text(
                                    "There is some problem while adding shift"),
                              );
                            });
                      }
                      setState(() {
                        _isServiceCalling = false;
                        _isButtonDisabled = false;
                      });
                    }
                  });
                }
              },
            ),
            //SizedBox(width: 10.0),
            FlatButton(
              shape: Border.all(color: Colors.orange[800]),
              child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
              onPressed: () {
                shifttype='0';
                _shiftName.clear();
                _shiftStartTimeController.clear();
                _shiftEndTimeController.clear();
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      }
    );
  }

  Widget getGrades_DD() {
    return new FutureBuilder<List<Map>>(
        future: getGradeList(0),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:15.0, right:15.0, top:5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        globallabelinfomap['grade'],
                        style: TextStyle(
                          fontSize:15.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      widget.sts==4?InkWell(
                        child: Row(
                          children: <Widget>[
                            Tooltip(
                              message: "Add Grade",
                              child: Icon(
                                Icons.add,
                                size: 24,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        onTap: (){
                          _gradeCode = new TextEditingController();
                          _gradeName = new TextEditingController();
                          getGradeCode().then((res) {
                            setState(() {
                              _gradeCode.text=res;
                            });
                          });
                          _showDialogGrade(context);
                        },
                      ):Center(),
                    ],
                  ),
                ),
                SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.only(left:10.0, right:10.0),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      child: new DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                          //border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.access_alarm,
                            color: Colors.black54,
                            size: 25,
                          ),
                          /*hintText: "Grade",
                          hintStyle: TextStyle(
                              fontSize: 14.0),*/
                        ),
                        isExpanded: true,
                        isDense: true,
                        style: new TextStyle(fontSize: 15.0, color: Colors.black),
                        value: grade,
                        onChanged: (String newValue) {
                          setState(() {
                            grade = newValue;
                          });
                        },
                        items: snapshot.data.map((Map map) {
                          return new DropdownMenuItem<String>(
                            value: map["Id"].toString(),
                            child: new Text(
                              map["Name"],
                            )
                          );
                        }).toList(),
                        validator: widget.sts==4?(String value) {
                          if (grade=='0') {
                            return 'Please select a grade';
                          }
                          return null;
                        }:null,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          // return loader();
          return new Center(
            child: SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
              ),
              height: 20.0,
              width: 20.0,
            ),
          );
        }
    );
  }

  _showDialogGrade(context) async {
    await showDialog<String>(
      barrierDismissible: false,
      context: context,
      child: new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.all(15.0),
        content: Form(
          key: _gradeFormKey,
          child: Container(
            //height: MediaQuery.of(context).size.height*0.20,
            //width: MediaQuery.of(context).size.width*0.35,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //SizedBox(height: 5.0),
                Center(
                  child:Text("Add Grade",style: new TextStyle(fontSize: 22.0,color:appStartColor())),
                ),
                SizedBox(height: 15.0),
                new TextFormField(
                  //enabled: false,
                  autofocus: false,
                  controller: _gradeCode,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(),
                      ),
                      //labelText: 'Department Code',
                      hintText: 'Grade Code',
                      hintStyle: _hintStyle
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty || value.isEmpty || value=="") {
                      return 'Please enter grade code';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                new TextFormField(
                  autofocus: false,
                  controller: _gradeName,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(),
                      ),
                      //labelText: 'Department Name',
                      hintText: 'Grade Name',
                      hintStyle: _hintStyle
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty || value.isEmpty || value=="") {
                      return 'Please enter grade name';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: (_isServiceCalling && _isButtonDisabled)
                ? Text(
              'Adding..',
              style: TextStyle(color: Colors.white),
            )
                : Text(
              'ADD',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.orange[800],
            onPressed: () {
              if (_gradeFormKey.currentState.validate()) {
                setState(() {
                  _isServiceCalling = true;
                  _isButtonDisabled = true;
                });
                var url = path + "addGrade";
                http.post(url, body: {
                  "uid": uid,
                  "orgid": orgid,
                  "code": _gradeCode.text.trim(),
                  "name": _gradeName.text.trim(),
                }).then((response) {
                  print(path + 'addGrade?uid=$uid&orgid=$orgid&code=${_gradeCode.text}&name=${_gradeName.text}');
                  print(response.body.toString());
                  if (response.statusCode == 200) {
                    Map data = json.decode(response.body);
                    print(response.body.toString());
                    print(data["sts"]);
                    if (data["sts"].contains("true")) {
                      gradeid = data["gradeid"];
                      grade = gradeid;
                      Navigator.of(context, rootNavigator: true).pop();
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("Grade added successfully"),
                            );
                          });
                    } else if (data["sts"].contains("alreadyexists")) {
                      gradeid = data["gradeid"];
                      grade = gradeid;
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text("Grade Code or Name already exists"),
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              content: new Text(
                                  "There is some problem while adding grade"),
                            );
                          });
                    }
                    setState(() {
                      _isServiceCalling = false;
                      _isButtonDisabled = false;
                    });
                  }
                });
              }
            },
          ),
          //SizedBox(width: 10.0),
          FlatButton(
            shape: Border.all(color: Colors.orange[800]),
            child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
            onPressed: () {
              _gradeCode.clear();
              _gradeName.clear();
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget getEmployeeStatus_DD() {
    return new FutureBuilder<List<Map>>(
        future: getEmpStatusList(0),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:15.0, right:15.0, top:5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        globallabelinfomap['empsts'],
                        style: TextStyle(
                          fontSize:15.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.only(left:10.0, right:10.0),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      child: new DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                          //border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.access_alarm,
                            color: Colors.black54,
                            size: 25,
                          ),
                        ),
                        isExpanded: true,
                        isDense: true,
                        style: new TextStyle(fontSize: 15.0, color: Colors.black),
                        value: empsts,
                        onChanged: (String newValue) {
                          setState(() {
                            empsts = newValue;
                            for(int i=0;i<snapshot.data.length;i++) {
                              if(snapshot.data[i]['Id'].toString()==newValue){
                                finalempsts= snapshot.data[i]['ActualValue'].toString();
                                print("finalempsts");
                                print(finalempsts);
                                break;
                              }
                              print(i);
                            }
                          });
                          print("empsts");
                          print(empsts);
                        },
                        items: snapshot.data.map((Map map) {
                          return new DropdownMenuItem<String>(
                              value: map["Id"].toString(),
                              child: Text(map["Name"])
                          );
                        }).toList(),
                        validator: (String value) {
                          if (empsts=='0') {
                            return 'Please select employee status';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          // return loader();
          return new Center(
            child: SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
              ),
              height: 20.0,
              width: 20.0,
            ),
          );
        }
    );
  }

  Widget getGender_DD() {
    return new FutureBuilder<List<Map>>(
        future: getGenderList(0),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:15.0, right:15.0, top:5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        globallabelinfomap['gender'],
                        style: TextStyle(
                          fontSize:15.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.only(left:10.0, right:10.0),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      child: new DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                          prefixIcon: Icon(
                            Icons.access_alarm,
                            color: Colors.black54,
                            size: 25,
                          ),
                        ),
                        isExpanded: true,
                        isDense: true,
                        style: new TextStyle(fontSize: 15.0, color: Colors.black),
                        value: gender,
                        onChanged: (String newValue) {
                          setState(() {
                            gender = newValue;
                            for(int i=0;i<snapshot.data.length;i++){
                              if(snapshot.data[i]['Id'].toString()==newValue){
                                finalgender= snapshot.data[i]['ActualValue'].toString();
                                print("finalgender");
                                print(finalgender);
                                break;
                              }
                              print(i);
                            }
                          });
                          print("gender");
                          print(gender);
                        },
                        items: snapshot.data.map((Map map) {
                          return new DropdownMenuItem<String>(
                              value: map["Id"].toString(),
                              child: Text(map["Name"])
                          );
                        }).toList(),
                        validator: (String value) {
                          if (gender=='0') {
                            return 'Please select gender';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          // return loader();
          return new Center(
            child: SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
              ),
              height: 20.0,
              width: 20.0,
            ),
          );
        }
    );
  }

  Widget getNationality_DD() {
    return new FutureBuilder<List<Map>>(
        future: getNationalityList(0),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:15.0, right:15.0, top:5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        globallabelinfomap['nationality'],
                        style: TextStyle(
                          fontSize:15.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.only(left:10.0, right:10.0),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      child: new DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                          //border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.access_alarm,
                            color: Colors.black54,
                            size: 25,
                          ),
                          /*hintText: "Nationality",
                          hintStyle: TextStyle(
                              fontSize: 14.0),*/
                        ),
                        isExpanded: true,
                        isDense: true,
                        style: new TextStyle(fontSize: 15.0, color: Colors.black),
                        value: nationality,
                        onChanged: (String newValue) {
                          setState(() {
                            nationality = newValue;
                          });
                        },
                        items: snapshot.data.map((Map map) {
                          return new DropdownMenuItem<String>(
                            value: map["Id"].toString(),
                            child: new Text(
                              map["Name"],
                            )
                          );
                        }).toList(),
                        validator: (String value) {
                          if (nationality=='0') {
                            return 'Please select nationality';
                          }
                          return null;
                        },

                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          // return loader();
          return new Center(
            child: SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
              ),
              height: 20.0,
              width: 20.0,
            ),
          );
        }
    );
  }

  Widget getCountry_DD() {
    return new FutureBuilder<List<Map>>(
        future: getNationalityList(0),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:15.0, right:15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Country",
                        style: TextStyle(
                          fontSize:15.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.only(left:10.0, right:10.0),
                  child: new DropdownButtonHideUnderline(
                    child:  new DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius:  new BorderRadius.circular(10.0)),
                        //border: InputBorder.none,
                        prefixIcon: Icon(
                          FontAwesomeIcons.globeAsia,
                          color: Colors.black54,
                          size: 25,
                        ),
                        /*hintText: "Country",
                        hintStyle: TextStyle(
                            fontSize: 14.0),*/
                      ),
                      isExpanded: true,
                      isDense: true,
                      hint: new Text("Select Country", style: TextStyle(fontSize: 14.0)),
                      value: _country,
                      onChanged: (String newValue) {
                        setState(() {
                          _country = newValue;
                          _contCode.text = _myJson[int.parse(newValue)]['countrycode'];
                          _tempcontry = _myJson[int.parse(newValue)]['id'];
                        });
                        print("_country");
                        print(_country);
                        print(_contCode.text);
                        print(_tempcontry);
                      },
                      items: _myJson.map((Map map) {
                        return new DropdownMenuItem<String>(
                          value: map["ind"].toString(),
                          child: new Text(
                            map["name"],
                          ),
                        );
                      }).toList(),
                      validator: (String value) {
                        if (_country.isEmpty) {
                          return 'Please select country';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          // return loader();
          return new Center(
            child: SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
              ),
              height: 20.0,
              width: 20.0,
            ),
          );
        }
    );
  }

  openWhatsApp(msg, number) async {
    var url = "https://wa.me/" + number + "?text=" + msg;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Maps';
    }
  }

  dialogwidget(msg, number) {
    showDialog(context: context,
      child: new AlertDialog(
        content: new Text('Do you want to notify user?'),
        actions: <Widget>[
          FlatButton(
            child: Text('Close'),
            shape: Border.all(),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          RaisedButton(
            child: Text(
              'Notify user',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.amber,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              openWhatsApp(msg, number);
            },
          ),
        ],
      )
    );
  }
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return false;
  else
    return true;
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}