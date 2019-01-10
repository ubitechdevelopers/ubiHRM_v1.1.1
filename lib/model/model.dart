class UserLogin {

  final String username;
  final String password;


  UserLogin({this.username,this.password});

  UserLogin.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'];

  Map<String, dynamic> toJson() =>
      {
        'username': username,
        'password': password,
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
  Team({this.Id, this.FirstName, this.LastName, this.Designation, this.DOB, this.Nationality, this.BloodGroup, this.CompanyEmail});
}
