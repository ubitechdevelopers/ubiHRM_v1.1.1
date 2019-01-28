class UserLogin {

  final String username;
  final String password;
  final String token;


  UserLogin({this.username,this.password,this.token});

  UserLogin.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'], token = json['token'];

  Map<String, dynamic> toJson() =>
      {
        'username': username,
        'password': password,
        'token': token,
      };

}

class Employee {

  final String employeeid;
  final String organization;


  Employee({this.employeeid,this.organization});

  Employee.fromJson(Map<String, dynamic> json)
      : employeeid = json['employeeid'],
        organization = json['organization'];

  Map<String, dynamic> toJson() =>
      {
        'employeeid': employeeid,
        'organization': organization,
      };

}

class Permission {

  final String moduleid;
  final List<Map<String,String>> permissionlist;
  Permission({this.moduleid,this.permissionlist});

}

class Team {
  String Id;
  String FirstName; // timein or timeout
  String LastName;
  String Designation;
  String DOB;
  String Nationality;
  String BloodGroup;
  String CompanyEmail;
  String ProfilePic;
  Team({this.Id, this.FirstName, this.LastName, this.Designation, this.DOB, this.Nationality, this.BloodGroup, this.CompanyEmail, this.ProfilePic});
}

class Leave{
  String uid, leavefrom, leaveto, orgid, reason, leavetypeid, leavetypefrom, leavetypeto, halfdayfromtype, halfdaytotype, leavedays, approverstatus, comment, attendancedate, leaveid;
  bool withdrawlsts;
  Leave({this.uid, this.leavefrom, this.leaveto, this.orgid, this.reason, this.leavetypeid, this.leavetypefrom, this.leavetypeto, this.halfdayfromtype, this.halfdaytotype, this.leavedays, this.approverstatus, this.comment, this.attendancedate, this.leaveid, this.withdrawlsts});
}


class Holi{
  String name;
  String date;
  String message;


  Holi({this.name, this.date, this.message});
}