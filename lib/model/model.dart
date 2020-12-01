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


class User{

  String username;
  String password;
  String token;

  User(this.username, this.password, this.token);

  User.fromMap(Map map) {
    username = map[username];
    password = map[password];
    token = map[token];
  }

}


class Employee {
  final String employeeid;
  final String organization;
  final String userprofileid;
  int profiletype;
  int hrsts;
  int adminsts;
  int dataaccess;
  int SAPintegrationsts;
  int divhrsts;

  Employee({
    this.employeeid,
    this.organization,
    this.userprofileid,
    this.profiletype,
    this.hrsts,
    this.adminsts,
    this.dataaccess,
    this.SAPintegrationsts,
    this.divhrsts,
  });

  Employee.fromJson(Map<String, dynamic> json)
    : employeeid = json['employeeid'],
      organization = json['organization'],
      userprofileid = json['userprofileid'],
      profiletype = json['profiletype'],
      hrsts = json['hrsts'],
      adminsts = json['adminsts'],
      dataaccess = json['dataaccess'],
      SAPintegrationsts = json['SAPintegrationsts'],
      divhrsts = json['divhrsts'];

  Map<String, dynamic> toJson() => {
    'employeeid': employeeid,
    'organization': organization,
    'userprofileid': userprofileid,
    'profiletype': profiletype,
    'hrsts': hrsts,
    'adminsts': adminsts,
    'dataaccess': dataaccess,
    'SAPintegrationsts': SAPintegrationsts,
    'divhrsts': divhrsts,
  };

}


class Profile{
  String uid;
  String orgid;
  String mobile;
  String countryid;

  Profile(this.uid,this.orgid,this.mobile,this.countryid);
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
  String ParentId;
  List<dynamic> juniorlist;
  List<dynamic> superjuniorlist;
  List<dynamic> ultrasuperjuniorlist;

  Team({this.Id, this.FirstName, this.LastName, this.Designation, this.DOB, this.Nationality, this.BloodGroup, this.CompanyEmail, this.ProfilePic, this.ParentId, this.juniorlist, this.superjuniorlist, this.ultrasuperjuniorlist});
}


class Leave{
  String uid;
  String leavefrom; // timein or timeout
  String leaveto;
  String orgid;
  String reason;
  String leavetypeid;
  String leavetypefrom;
  String leavetypeto;
  String halfdayfromtype;
  String halfdaytotype;
  String leavedays;
  String approverstatus;
  String comment;
  String attendancedate;
  String leaveid;
  String substituteemp;
  String leavetype;
  String compoffsts;
  bool withdrawlsts;

  Leave({
    this.uid,
    this.leavefrom,
    this.leaveto,
    this.orgid,
    this.reason,
    this.leavetypeid,
    this.leavetypefrom,
    this.leavetypeto,
    this.halfdayfromtype,
    this.halfdaytotype,
    this.leavedays,
    this.approverstatus,
    this.comment,
    this.attendancedate,
    this.leaveid,
    this.leavetype,
    this.substituteemp,
    this.compoffsts,
    this.withdrawlsts
  });
}


class Holi{
  String name;
  String date;
  String message;

  Holi({this.name, this.date, this.message});
}


class TimeOff {
  String EmpId;
  String OrgId;
  String TimeOffId;
  String TimeofDate;
  String TimeFrom;
  String TimeTo;
  String StartTimeFrom;
  String StopTimeTo;
  String TimeOffSts;
  String hrs;
  String Reason;
  String ApprovalSts;
  String ApproverComment;
  bool withdrawlsts;
  bool starticonsts;
  bool stopiconsts;

  TimeOff({this.EmpId,this.OrgId,this.TimeOffId,this.TimeofDate,this.TimeFrom,this.TimeTo,this.StartTimeFrom,this.StopTimeTo,this.TimeOffSts,this.hrs,this.Reason,this.ApprovalSts,this.ApproverComment,this.withdrawlsts,this.starticonsts,this.stopiconsts});
}


