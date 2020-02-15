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


  Employee({this.employeeid,this.organization,this.userprofileid});

  Employee.fromJson(Map<String, dynamic> json)
      : employeeid = json['employeeid'],
        organization = json['organization'],
        userprofileid = json['userprofileid'];

  Map<String, dynamic> toJson() =>
      {
        'employeeid': employeeid,
        'organization': organization,
        'userprofileid': userprofileid,
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
  Team({this.Id, this.FirstName, this.LastName, this.Designation, this.DOB, this.Nationality, this.BloodGroup, this.CompanyEmail, this.ProfilePic});
}

class Leave{
  String uid,
      leavefrom,
      leaveto,
      orgid,
      reason,
      leavetypeid,
      leavetypefrom,
      leavetypeto,
      halfdayfromtype,
      halfdaytotype,
      leavedays,
      approverstatus,
      comment,
      attendancedate,
      leaveid,
      substituteemp,
      leavetype,
      compoffsts;
  bool withdrawlsts;
  Leave({this.uid,
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
    this.withdrawlsts,
    this.leavetype,
    this.substituteemp,
    this.compoffsts
  });
}


class Holi{
  String name;
  String date;
  String message;

  Holi({this.name, this.date, this.message});
}



///// For Attendance


/*class TimeOff{

  String timeoffdate;
  String starttime;
  String endtime;
  String reason;
  String empid;
  String orgid;

 TimeOff(this.timeoffdate,this.starttime,this.endtime,this.reason,this.empid, this.orgid);

  TimeOff.fromMap(Map map) {
    timeoffdate = map[timeoffdate];
    starttime = map[starttime];
    endtime = map[endtime];
    reason = map[reason];
    empid = map[empid];
    orgid = map[orgid];
  }

}*/

class TimeOff {
  String EmpId;
  String OrgId;
  String TimeOffId;
  String TimeofDate;
  String TimeFrom;
  String TimeTo;
  String hrs;
  String Reason;
  String ApprovalSts;
  String ApproverComment;
  bool withdrawlsts;
  TimeOff({this.TimeofDate,this.TimeFrom,this.TimeTo,this.hrs,this.Reason,this.ApprovalSts,this.ApproverComment,this.withdrawlsts, this.TimeOffId, this.EmpId, this.OrgId});
}



class Salary{
  String id;
  String name;
  String month;
  String paid_days;
  String EmployeeCTC;
  String Currency;

  Salary({this.id,this.name, this.month, this.paid_days,this.EmployeeCTC,this.Currency});
}

class Payroll{
  String id;
  String name;
  String month;
  String paid_days;
  String EmployeeCTC;
  String Currency;

  Payroll({this.id,this.name, this.month, this.paid_days,this.EmployeeCTC,this.Currency});
}

/*class Profile{
  String uid;
  String orgid;
  String mobile;
  String countryid;

  Profile(this.uid,this.orgid,this.mobile,this.countryid);
}

class Leave{
  String uid, leavefrom, leaveto, orgid, reason, leavetypeid, leavetypefrom, leavetypeto, halfdayfromtype, halfdaytotype, leavedays, approverstatus, comment, attendancedate, leaveid;
  bool withdrawlsts;
  Leave({this.uid, this.leavefrom, this.leaveto, this.orgid, this.reason, this.leavetypeid, this.leavetypefrom, this.leavetypeto, this.halfdayfromtype, this.halfdaytotype, this.leavedays, this.approverstatus, this.comment, this.attendancedate, this.leaveid, this.withdrawlsts});
}*/