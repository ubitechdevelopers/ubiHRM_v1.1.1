import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubihrm/model/model.dart';
import 'package:ubihrm/global.dart';
import 'dart:convert';

Future<bool> checklogin(UserLogin user) async{
  final prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  FormData formData = new FormData.from({
    "user_name": user.username,
    "user_password": user.password
  });

  Response<String> response =
      await dio.post(path + "checklogin", data: formData);
  print(response.toString());
  if(response.statusCode==200){
    Map employeeMap = json.decode(response.data);
    if(employeeMap['response']==1){
      prefs.setInt("response", 1);
      prefs.setString("employeeid", employeeMap['employeeid']);
      prefs.setString("organization", employeeMap['organization']);
      return true;
    }else{
      return false;
    }
  }
}

