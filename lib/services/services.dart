import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/model/model.dart';
import 'package:dio/dio.dart';
import 'package:ubihrm/global.dart';
import 'dart:convert';

getAllPermission(Employee emp) async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  FormData formData = new FormData.from({
    "employeeid": emp.employeeid,
    "organization": emp.organization
  });

  Response<String> response =
  await dio.post(path + "getAllPermission", data: formData);
  print(response.toString());
  List responseJson = json.decode(response.data.toString());
  //print("1.  "+responseJson.toString());
  List<Permission> permlist = createPermList(responseJson);
  //print("3. "+permlist.toString());
  globalpermissionlist = permlist;
}

getProfileInfo() async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  Response<String> response =
  await dio.post(path + "getProfileInfo");
 // print(response.toString());
  Map responseJson = json.decode(response.data.toString());
  //print(responseJson);
  globalcontactusinfomap = responseJson['Contact'];
  globalpersnalinfomap = responseJson['Personal'];
  globalcompanyinfomap = responseJson['Company'];


}

getReportingTeam() async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  Response<String> response =
  await dio.post(path + "getReportingTeam");
  print(response.toString());
  List responseJson = json.decode(response.data.toString());
  print(responseJson);


}

List<Permission> createPermList(List data) {
  List<Permission> list = new List();
  for (int i = 0; i < data.length; i++) {
   // print(i.toString());
    //print(data[i]['module'].toString());
    List<Map<String,String>> permissionlist = new List();
    String moduleid = data[i]["module"];
    String view = data[i]["view"];
    String edit = data[i]["edit"];
    String delete = data[i]["delete"];
    String add = data[i]["add"];
    //print(moduleid +" " +view+" "+edit+" "+delete+" "+add);
    Map<String,String> viewpermission = {'view': view};
    Map<String,String> editpermission = {'edit': edit};
    Map<String,String> deletepermission = {'delete': delete};
    Map<String,String> addpermission = {'add': add};
    permissionlist.add(viewpermission);
    permissionlist.add(editpermission);
    permissionlist.add(deletepermission);
    permissionlist.add(addpermission);
   // print("2. "+permissionlist.toString());
    Permission p = new Permission(moduleid: moduleid,permissionlist: permissionlist);
    list.add(p);
  }
  return list;
}

getModulePermission(String moduleid, String permission_type){
  List<Permission> list = new List();
  list = globalpermissionlist;
  for (int i = 0; i < list.length; i++) {
    //print("permisstion list "+list[i].permissionlist.toString());
    if(list[i].moduleid==moduleid){
      for (int j = 0; j < list[i].permissionlist.length; j++) {

        //print(list[i].permissionlist[j].containsKey(permission_type));
        if(list[i].permissionlist[j].containsKey(permission_type)){
          return list[i].permissionlist[j][permission_type];
        }
      }
    }
  }

  return "0";
}

Future<List<Team>> getTeamList() async {

  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  Response<String> response =
  await dio.post(path + "getReportingTeam");
  List responseJson = json.decode(response.data.toString());
  //print("1.  "+responseJson.toString());
  List<Team> teamlist = createTeamList(responseJson);
  return teamlist;
}

List<Team> createTeamList(List data) {
  List<Team> list = new List();
  for (int i = 0; i < data.length; i++) {
    String diff = data[i]["lateby"];
    String timeAct = data[i]["timein"];
    String name = data[i]["name"];
    String shift = data[i]["shift"];
    String date = data[i]["date"];
    Team row = new Team();
    list.add(row);
  }
  return list;
}
