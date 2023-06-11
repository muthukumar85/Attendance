

import 'dart:math';

import 'package:attendance/pages/AdminPages/manageExportClass.dart';
import 'package:attendance/pages/class/classFriends.dart';
import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../pages/AdminPages/manageClass.dart';

class AdminService{
  static Future<dynamic> RegisterAdmindata({required User? userdata}) async{
    // print('data$userdata');
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/admin/${userdata!.uid}');
    await ref.once().then((events) async {
      if(events.snapshot.exists){

      }
      else{
        await ref.set({
          "id":userdata.uid,
          "name": userdata.displayName,
          "email": userdata.email,
          "role":'admin'
        });

      }
    });


  }
  static Future<bool> IsAdmin({required User users}) async{
    DatabaseReference adminref = FirebaseDatabase.instance.ref('users/admin/${users.uid}');
      return await adminref.once().then((adminevents) {
      if(adminevents.snapshot.exists){
        Map userinfo = adminevents.snapshot.value as Map;
        if(userinfo['role']=='admin'){
          return true;
        }
        else{
          return false;
        }
      }
      else{
        return false;
      }
    });
  }
  static Future<bool> IsPay({required User users , required role}) async{
    DatabaseReference ref= FirebaseDatabase.instance.ref('users/$role/${users.uid}');

    bool refer = await ref.once().then((value) {
      if(value.snapshot.exists){
        Map data = value.snapshot.value as Map;
        if(data['pay'] == true){
          // print('true');
          return true;
        }
        else{
          return false;
        }
      }
      else{
        return false;
      }
    });
    if(refer){
      return true;
    }
    else{
      return false;
    }
  }
  static Future<bool> SetPay({required User users , required role}) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/$role/${users.uid}');
    await ref.update({
      "pay":true
    });
    return true;
  }
  static Future<dynamic> CreateClass({
    required User users ,
    required String name,
    required String classname ,
    required String subjectname,
    required String semester,

  }) async{

    Future<String> getRandomString(int len) async{
      var r = Random();
      const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
    }
    Future<dynamic> updateClass({required String ran}) async{
    DatabaseReference refATClass = FirebaseDatabase.instance.ref('attendance/classes/$ran');
      await refATClass.update({
        "Attendance_report":{
          DateTime.now().year.toString():{
            DateTime.now().month.toString():""
          }
        },
        "id":ran,
        "subjectname":subjectname,
        "trainerID":users.uid,
        "trainername":name,
        "classname":classname,
        "semester":semester
      });
    }
    Future<dynamic> updatedata()async {
    var ran = await getRandomString(5);
    // print(ran);
    DatabaseReference ref = FirebaseDatabase.instance.ref('attendance/classes/$ran');
    DatabaseReference refClass = FirebaseDatabase.instance.ref('users/admin/${users.uid}/classes');
      await ref.once().then((value) async =>
      {
        if(value.snapshot.exists != true){
          await refClass.update({
            ran: {
              "id":ran,
              "subjectname":subjectname
            }
          }),
          await updateClass(ran: ran)
        }
        else
          {
            updatedata()
          }
      });
    }
    await updatedata();
  }

  static Future<dynamic> GetClassList({
    required BuildContext context,
  required User users
})async{
    List<Map<dynamic , dynamic>> ListClass=[];
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/admin/${users.uid}/classes');

      return await ref.once().then((value) {
        if (value.snapshot.exists) {
          Map<dynamic, dynamic> obj = value.snapshot.value as Map;
          // print(obj.keys.length);
          // print(value.snapshot.value);
          obj.forEach((key, value) async {
            DatabaseReference reference = FirebaseDatabase.instance.ref(
                'attendance/classes/$key');
            await reference.once().then((listvalue) {
              ListClass.add(listvalue.snapshot.value as Map);
              if (ListClass.length == obj.keys.length) {
                // print(ListClass);
                Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) =>
                      ManageClass(users: users, classList: ListClass,),
                ),
                        (route) => false
                );
              }
            });
          });
        }
        else{
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute<dynamic>(
            builder: (BuildContext context) =>
                ManageClass(users: users, classList: ListClass,),
          ),
                  (route) => false
          );
        }
      });
  }
  static Future<dynamic> GetFriendClassList({
    required BuildContext context,
    required User users
  })async{
    List<Map<dynamic , dynamic>> ListClass=[];
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/admin/${users.uid}/classes');

    return await ref.once().then((value) {
      if (value.snapshot.exists) {
        Map<dynamic, dynamic> obj = value.snapshot.value as Map;
        // print(obj.keys.length);
        // print(value.snapshot.value);
        obj.forEach((key, value) async {
          DatabaseReference reference = FirebaseDatabase.instance.ref(
              'attendance/classes/$key');
          await reference.once().then((listvalue) {
            ListClass.add(listvalue.snapshot.value as Map);
            if (ListClass.length == obj.keys.length) {
              // print(ListClass);
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute<dynamic>(
                builder: (BuildContext context) =>
                    MainFriendClass(users: users, classList: ListClass,),
              ),
                      (route) => false
              );
            }
          });
        });
      }
      else{
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>
              MainFriendClass(users: users, classList: ListClass,),
        ),
                (route) => false
        );
      }
    });
  }
  static Future<void> SetSession({required bool session , required Map classdata})async{
    // print('${classdata['day'].runtimeType}');
    DatabaseReference ref = FirebaseDatabase.instance.ref(
        'attendance/classes/${classdata['id']}/Attendance_report/${classdata['year']}/${classdata['month']}/${classdata['day']}/${classdata['period']}'
    );
    DatabaseReference refdata = FirebaseDatabase.instance.ref(
        'attendance/classes/${classdata['id']}/students'
    );
    var isfound = await ref.once();
    if(isfound.snapshot.exists){
      await ref.update({
        "session":session
      });
    }
    else{
      await ref.set({
        "period":classdata['period'],
        "session":session

      });
      var student = await refdata.once();
      Map data = student.snapshot.value as Map;
      data!=null?data.forEach((key, value) async{
        await ref.child('data').update({
          value['registernumber']:{
            "name":value['name'],
            "present":false,
            "id":value['registernumber'],
          }
        });
      }):print('');
    }
  }
  static Future<dynamic> GetClassExportList({
    required BuildContext context,
    required User users
  })async{
    List<Map<dynamic , dynamic>> ListClass=[];
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/admin/${users.uid}/classes');

    return await ref.once().then((value) {
      if (value.snapshot.exists) {
        Map<dynamic, dynamic> obj = value.snapshot.value as Map;
        // print(obj.keys.length);
        // print(value.snapshot.value);
        obj.forEach((key, value) async {
          DatabaseReference reference = FirebaseDatabase.instance.ref(
              'attendance/classes/$key');
          await reference.once().then((listvalue) {
            ListClass.add(listvalue.snapshot.value as Map);
            if (ListClass.length == obj.keys.length) {
              // print(ListClass);
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute<dynamic>(
                builder: (BuildContext context) =>
                    ManageExportClass(users: users, classList: ListClass,),
              ),
                      (route) => false
              );
            }
          });
        });
      }
      else{
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>
              ManageExportClass(users: users, classList: ListClass,),
        ),
                (route) => false
        );
      }
    });
  }
  static Future<Object?> GetClassdata({required Map classdata , required String year , required String month}) async{
      DatabaseReference ref = FirebaseDatabase.instance.ref('attendance/classes/${classdata['id']}/Attendance_report/$year/$month');
      var data = await ref.once();
      // print('${data.snapshot.value}');
      return data.snapshot.value;
  }
  static Future<Object?> GetClassMap({required Map classdata}) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref('attendance/classes/${classdata['id']}/');
    var data = await ref.once();
    // print('${data.snapshot.value}');
    return data.snapshot.value;
  }
  static Future<dynamic> RemoveStudent({required Map classdata , required String regno}) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref('attendance/classes/${classdata['id']}/students');
    await ref.child(regno).remove();
  }
  static Future<bool> ChangePresent({required Map classdata , required String regno , required bool attendance})async{
    DatabaseReference ref = FirebaseDatabase.instance.ref('attendance/classes/${classdata['id']}/Attendance_report/${classdata['year']}/${classdata['month']}/${classdata['day']}/${classdata['period']}/data/$regno');
    await ref.update({
      "present":attendance
    });
    var markAttendance = await ref.once();
    Map data = markAttendance.snapshot.value as Map;
    return data['present'];
  }
  static Future<Object?> GetClassMonth({required Map classdata , required String year}) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref('attendance/classes/${classdata['id']}/Attendance_report/$year');
    var data = await ref.once();
    // print('${data.snapshot.value}');
    return data.snapshot.value;
  }
  static Future<dynamic> GetList({required User users , required Map classdata})async{
    DatabaseReference reference = FirebaseDatabase.instance.ref('attendance/classes/${classdata['id']}/Attendance_report/${classdata['year']}/${classdata['month']}/${classdata['day']}/${classdata['period']}/data');
    Stream<DatabaseEvent> stream =  reference.onValue;
    Map data  = {};
    // print('hello');
    stream.listen((event) {
      // print('Event Type: ${event.type}'); // DatabaseEventType.value;
      // print('Snapshot: ${event.snapshot}');
      // print('Snapshot: ${event.snapshot.value}');
      data = event.snapshot.value as Map;
    });
    return data;
  }
}