import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/appbar.dart';
import 'package:ubihrm/b_navigationbar.dart';
import 'package:ubihrm/global.dart';
import 'package:ubihrm/services/attandance_services.dart';
import 'package:ubihrm/settings/settings.dart';
import '../drawer.dart';

class Division extends StatefulWidget {
  @override
  _DivisionState createState() => _DivisionState();
}

class _DivisionState extends State<Division> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _divFormKey = GlobalKey<FormState>();
  static const statuses =  ['Active', 'Inactive'];
  String orgName = "";
  String uid = "";
  String orgid = "";
  bool _isButtonDisabled = false;
  bool _isServiceCalling = false;
  int hrsts=0;
  int adminsts=0;
  int divhrsts=0;
  TextEditingController _divCode = new TextEditingController();
  TextEditingController _divName = new TextEditingController();
  TextEditingController _searchController;
  FocusNode searchFocusNode;
  String divname = "";
  var profileimage;
  bool showtabbar;
  String div='0';
  String divCode = "";

  TextStyle _hintStyle = TextStyle(
      color: Colors.black45
  );

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
    { "ind":"77"     ,      "id": "75" ,   "name": "Gibraltar"  ,   "countrycode": "+350"}      ,
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

  @override
  void initState() {
    super.initState();
    _searchController = new TextEditingController();
    searchFocusNode = FocusNode();
    profileimage = new NetworkImage(globalcompanyinfomap['ProfilePic']);
    getOrgName();
  }

  getOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      orgName = prefs.getString('orgname') ?? '';
      hrsts =prefs.getInt('hrsts')??0;
      adminsts =prefs.getInt('adminsts')??0;
      divhrsts =prefs.getInt('divhrsts')??0;
      uid = prefs.getString("employeeid")??"";
      orgid = prefs.getString("organization")??"";
    });
  }

  Widget build(BuildContext context) {
    return mainDivisionWidget();
  }

  Future<bool> move() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AllSetting()), (
        Route<dynamic> route) => false,
    );
    return false;
  }

  mainDivisionWidget() {
    return WillPopScope(
      onWillPop: () => move(),
      child: RefreshIndicator(
        child: new Scaffold(
          backgroundColor: scaffoldBackColor(),
          key: _scaffoldKey,
          appBar: AppHeader(profileimage,showtabbar,orgName),
          bottomNavigationBar: new HomeNavigation(),
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
              child: Container(
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                decoration: new ShapeDecoration(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Center(
                        child: Text(
                          'Divisions',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: appStartColor(),
                          ),
                        )),
                    //Divider(),
                    SizedBox(height: 5.0,),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Container(
                              //width: MediaQuery.of(context).size.width*0.65,
                              child: Text(
                                'Name',
                                style: TextStyle(
                                    color: appStartColor(),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Container(
                              child: Text(
                                'Status',
                                style: TextStyle(
                                    color: appStartColor(),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    new Expanded(
                      child: getDivisionWidget(),
                    ),
                  ],
                ),
              ),
          ),
          floatingActionButton: (adminsts==1||hrsts==1||divhrsts==1)?new FloatingActionButton(
            backgroundColor: Colors.orange[800],
            onPressed: (){
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
              /*showDialog(
                context: context,
                builder: (context) {
                  Future.delayed(Duration(seconds: 3), () {
                    Navigator.of(context).pop(true);
                  });
                  return AlertDialog(
                    content: new Text("To Add a new Division, login to the web panel"),
                  );
                });*/
            },
            tooltip: 'Add Division',
            child: new Icon(Icons.add),
          ):Center(),
        ),
        onRefresh: () async {
          Completer<Null> completer = new Completer<Null>();
          await Future.delayed(Duration(seconds: 1)).then((onvalue) {
            /*setState(() {
              _searchController.clear();
            });*/
            completer.complete();
          });
          return completer.future;
        },
      ),
    );
  }

  getDivisionWidget() {
    return FutureBuilder<List<Div>>(
      future: getDivision(divname),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("snapshot.data.length");
          print(snapshot.data.length);
          if (snapshot.data.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Text(snapshot.data[index].div.toString(),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        //width: MediaQuery.of(context).size.height * 0.10,
                        child: Text(snapshot.data[index].status.toString(),
                            style: TextStyle(
                                fontSize: 14,
                                color: snapshot.data[index].status.toString() ==
                                            'Active'
                                        ? Colors.green
                                        : Colors.red)),
                      ),
                    ],
                  ),
                  onTap: () {
                    showAlertDialog(context, snapshot.data[index].id.toString(), snapshot.data[index].div.toString(),
                      snapshot.data[index].status.toString(),
                    );
                  },
                );
              },
            );
          }else{
            return new Center(
              child: Container(
                width: MediaQuery.of(context).size.width*1,
                color: appStartColor().withOpacity(0.1),
                padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                child:Text("No division found",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return new Text("Unable to connect server");
        }
        return Center(child: CircularProgressIndicator());
      });
  }

  showAlertDialog(BuildContext context, String id, String div, String status) async {
    var name = new TextEditingController();
    name.text=div;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.all(15.0),
          content: Container(
            height: MediaQuery.of(context).size.height*0.22,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child:Text("Update Division",style: new TextStyle(fontSize: 22.0,color:appStartColor())),
                  ),
                  SizedBox(height: 15.0),
                  new Container(
                    child: TextFormField(
                      enabled: false, //Disable a `TextField`
                      controller: name,
                      decoration: new InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                        ),
                        labelText: 'Division', hintText: 'Division Name'),
                      validator: (value) {
                        if (name.text.trim().isEmpty || name.text.isEmpty) {
                          return 'Please enter division name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  new DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      decoration:  InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.0), width: 1,),
                        ),
                        labelText: 'Status',
                      ),
                      value: status,
                      onChanged: (String newValue) {
                        print(status);
                        setState(() {
                          status=newValue;
                          Navigator.of(context, rootNavigator: true).pop('dialog'); // here I pop to avoid multiple Dialogs
                          showAlertDialog(context, id, div, status);
                          _isButtonDisabled=true;
                        });
                        print("status");
                        print(status);
                      },
                      items: statuses.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            RaisedButton(
            color: Colors.orange[800],
              child: _isServiceCalling?Text("Updating..",
                style: TextStyle(color: Colors.white),
              ):Text("UPDATE",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if(_isButtonDisabled==false)
                  return showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          content: new Text("No changes found"),
                        );
                      });
                setState(() {
                  _isServiceCalling=true;
                  _isButtonDisabled=true;
                });
                var sts = await updateDiv(status, id);
                if(sts.contains("1")){
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          content: new Text("Division is updated successfully"),
                        );
                      });
                  getDivisionWidget();
                }else if(sts.contains("2")){
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          content: new Text("This division can't be updated. Employees are already assigned to it."),
                        );
                      });
                }else if(sts.contains("3")){
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          content: new Text("This Division can't be updated. Only Division found"),
                        );
                      });
                }else{
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          content: new Text("Unable to update division"),
                        );
                      });
                }
                setState(() {
                  _isServiceCalling=false;
                  _isButtonDisabled=false;
                });
              },
            ),
            FlatButton(
            shape: Border.all(color: Colors.orange[800]),
            child: Text('CANCEL',style: TextStyle(color: Colors.black87),),
            onPressed: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
            },
            ),
          ],
        );
      },
    );
  }

  _showDialogDiv(BuildContext context) async {
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
            child: _isServiceCalling ? Text(
              'Adding..',
              style: TextStyle(color: Colors.white),
            ): Text(
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