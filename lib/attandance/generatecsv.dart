import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

getCsv(associateList, fname, name) async {
  //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.
  List<List<dynamic>> rows = List<List<dynamic>>();
  List<dynamic> row1 = List();

  if (name == 'lateComers') {
    row1.add('Name');
    row1.add('Shift');
    row1.add('Time In');
    row1.add('Late By');
    rows.add(row1);
    for (int i = 0; i < associateList.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add(associateList[i].name);
      row.add(associateList[i].shift);
      row.add(associateList[i].timeAct);
      row.add(associateList[i].diff);
      rows.add(row);
    }
  } else if(name == 'earlyLeavers'){
    row1.add('Name');
    row1.add('Shift');
    row1.add('Time Out');
    row1.add('Early By');
    rows.add(row1);
    for (int i = 0; i < associateList.length; i++) {
      //row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add(associateList[i].name);
      row.add(associateList[i].shift);
      row.add(associateList[i].timeAct);
      row.add(associateList[i].diff);
      rows.add(row);
    }
  } else if(name == 'visitlist') {
    row1.add('Name');
    row1.add('Client Name');
    row1.add('Visit In');
    row1.add('Visit In Location');
    row1.add('Visit Out');
    row1.add('Visit Out Location');
    row1.add('Remarks');
    rows.add(row1);
    for (int i = 0; i < associateList.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add(associateList[i].Emp);
      row.add(associateList[i].client);
      row.add(associateList[i].pi_time);
      row.add(associateList[i].pi_loc);
      row.add(associateList[i].po_time);
      row.add(associateList[i].po_loc);
      row.add(associateList[i].desc);
      rows.add(row);
    }
  } else if(name == 'outside') {
    row1.add('Name');
    row1.add('TimeIn');
    row1.add('TimeIn Location');
    row1.add('TimeOut');
    row1.add('TimeOut Location');
    rows.add(row1);
    for (int i = 0; i < associateList.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add(associateList[i].empname);
      row.add(associateList[i].timein);
      row.add(associateList[i].locationin);
      row.add(associateList[i].timeout);
      row.add(associateList[i].locationout);
      rows.add(row);
    }
  } else {
    row1.add('Name');
    if (name != 'absent') {
      row1.add('TimeIn');
      row1.add('TimeIn Location');
      row1.add('TimeOut');
      row1.add('TimeOut Location');
    }
    rows.add(row1);
    for (int i = 0; i < associateList.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add(associateList[i].Name);
      if (name != 'absent') {
        row.add(associateList[i].TimeIn);
        row.add(associateList[i].CheckInLoc);
        row.add(associateList[i].TimeOut);
        row.add(associateList[i].CheckOutLoc);
      }
      rows.add(row);
    }
  }


  PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  print(permission);
  Map<PermissionGroup, PermissionStatus> permissions;
  if(permission.toString()!='PermissionStatus.granted'){
    permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  }

  //PermissionStatus res = await SimplePermissions.requestPermission(Permission. WriteExternalStorage);
  /*final res = await SimplePermissions.requestPermission(
      Permission.WriteExternalStorage);
  bool checkPermission =
      await SimplePermissions.checkPermission(Permission.WriteExternalStorage);*/
  if (permission.toString() == "PermissionStatus.granted") {
//store file in documents folder
    String dir = (await getExternalStorageDirectory()).absolute.path;
    String file = "$dir/ubihrm_files/";
    await new Directory('$file').create(recursive: true);
    print(" FILE " + file);
    File f = new File(file + fname + ".csv");

// convert rows to String and write as csv file
    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
    return file + fname + ".csv";
  }
}

getMonthlyCSV(associateList, fname, name) async {
  //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.

  List<List<dynamic>> rows = List<List<dynamic>>();
  List<dynamic> row1 = List();

  if(name == 'present' || name == 'absent' || name == 'late' || name == 'early'){
    row1.add('Date');
    row1.add('Name');
    if (name != 'absent') {
      row1.add('TimeIn');
      row1.add('TimeOut');
    }
    rows.add(row1);
    for (int i = 0; i < associateList.length; i++) {
  //row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add(associateList[i].EntryImage);
      row.add(associateList[i].Name);
      if (name != 'absent') {
        row.add(associateList[i].TimeIn);
        row.add(associateList[i].TimeOut);
      }
      rows.add(row);
    }
  }

  PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  print(permission);
  Map<PermissionGroup, PermissionStatus> permissions;
  if(permission.toString()!='PermissionStatus.granted'){
    permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  }

  //PermissionStatus res = await SimplePermissions.requestPermission(Permission. WriteExternalStorage);
  /*final res = await SimplePermissions.requestPermission(
      Permission.WriteExternalStorage);
  bool checkPermission =
      await SimplePermissions.checkPermission(Permission.WriteExternalStorage);*/
  if (permission.toString() == "PermissionStatus.granted") {
//store file in documents folder
    String dir = (await getExternalStorageDirectory()).absolute.path;
    String file = "$dir/uibhrm_files/";
    await new Directory('$file').create(recursive: true);
    print(" FILE " + file);
    File f = new File(file + fname + ".csv");

// convert rows to String and write as csv file
    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
    return file + fname + ".csv";
  }
}


getCsvAll(associateListP,associateListA,associateListL,associateListE, fname, name) async {
  //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.
  List<List<dynamic>> rows = List<List<dynamic>>();
  List<dynamic> row1 = List();

  row1.add('Name');
  row1.add('TimeIn');
  row1.add('TimeIn Location');
  row1.add('TimeOut');
  row1.add('TimeOut Location');
  rows.add(row1);

  row1 = List();

  row1.add("Present");
  row1.add("  ");
  row1.add("  ");
  row1.add("  ");
  row1.add("  ");
  rows.add(row1);

  for (int i = 0; i < associateListP.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
    List<dynamic> row = List();
    row.add(associateListP[i].Name);
    row.add(associateListP[i].TimeIn);
    row.add(associateListP[i].CheckInLoc);
    row.add(associateListP[i].TimeOut);
    row.add(associateListP[i].CheckOutLoc);

    rows.add(row);
  }

  row1 = List();
  rows.add(row1);

  row1 = List();
  row1.add("Absent");
  row1.add("  ");
  row1.add("  ");
  row1.add("  ");
  row1.add("  ");
  rows.add(row1);
  for (int i = 0; i < associateListA.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
    List<dynamic> row = List();
    row.add(associateListA[i].Name);
    row.add('-');
    row.add('-');
    row.add('-');
    row.add('-');
    rows.add(row);
  }

  row1 = List();
  rows.add(row1);

  row1 = List();
  row1.add("Late Comers");
  row1.add("  ");
  row1.add("  ");
  row1.add("  ");
  row1.add("  ");
  rows.add(row1);
  for (int i = 0; i < associateListL.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
    List<dynamic> row = List();
    row.add(associateListL[i].Name);
    row.add(associateListL[i].TimeIn);
    row.add(associateListL[i].CheckInLoc);
    row.add(associateListL[i].TimeOut);
    row.add(associateListL[i].CheckOutLoc);
    rows.add(row);
  }

  row1 = List();
  rows.add(row1);

  row1 = List();
  row1.add("Early Leavers");
  row1.add("  ");
  row1.add("  ");
  row1.add("  ");
  row1.add("  ");
  rows.add(row1);

  for (int i = 0; i < associateListE.length; i++){
//row refer to each column of a row in csv file and rows refer to each row in a file
    List<dynamic> row = List();
    row.add(associateListE[i].Name);
    row.add(associateListE[i].TimeIn);
    row.add(associateListE[i].CheckInLoc);
    row.add(associateListE[i].TimeOut);
    row.add(associateListE[i].CheckOutLoc);
    rows.add(row);
  }

  PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  print(permission);
  Map<PermissionGroup, PermissionStatus> permissions;
  if(permission.toString()!='PermissionStatus.granted'){
    permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  }

  //PermissionStatus res = await SimplePermissions.requestPermission(Permission. WriteExternalStorage);
  /*final res = await SimplePermissions.requestPermission(
      Permission.WriteExternalStorage);
  bool checkPermission =
      await SimplePermissions.checkPermission(Permission.WriteExternalStorage);*/
  if (permission.toString() == "PermissionStatus.granted") {
//store file in documents folder
    String dir = (await getExternalStorageDirectory()).absolute.path;
    String file = "$dir/ubihrm_files/";
    await new Directory('$file').create(recursive: true);
    print(" FILE " + file);
    File f = new File(file + fname + ".csv");

// convert rows to String and write as csv file
    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
    return file + fname + ".csv";
  }
}