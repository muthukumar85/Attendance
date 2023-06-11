
import 'package:attendance/pages/class/mainClasses.dart';
import 'package:attendance/pages/mainHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../pages/class/classFriends.dart';

class UserService{
  static Future<dynamic> GetData({required User userdata}) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/students/${userdata.uid}');
    var data = await ref.once();
    return data.snapshot.value;
    // ref.once().then((snapshot) {
    //   print('Data : ${snapshot.snapshot.value}');
    // });
  }
  static Future<dynamic> GetGraphData({required User userdata , required String classdata}) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref('attendance/classes/$classdata');
    var data = await ref.once();
    return data.snapshot.value;
    // ref.once().then((snapshot) {
    //   print('Data : ${snapshot.snapshot.value}');
    // });
  }
  static Future<void> ChangeCredential({required BuildContext context ,
    required User users , required ,required String registernumber , required Map userdata,
    required String username , required bool credential})async{
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/students/${users.uid}');
    DatabaseReference refclass = FirebaseDatabase.instance.ref('attendance/classes');
    Map classdata = userdata['classes'];
    if(credential){

      classdata!=null?classdata.forEach((key, value) async {
      var classre = await refclass.child(key).child('students').child(registernumber).once();
        var data = classre.snapshot.value as Map;
      if(classre.snapshot.exists){
        if(data['email'] == users.email){
await ref.update({
"registernumber":registernumber
});
ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text('Register Number Updated Successfully')));
}
        else{
ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text('Register Number Already EXists')));
}

      }
      else{
await ref.update({
"registernumber":registernumber
});
refclass.child(key).child('students').child(registernumber).set({
  "name":users.displayName,
"registernumber":registernumber,
"email":users.email
});

}
      }):print('');


    }
    else{
      await ref.update({
        "name":username
      });
      classdata!=null?classdata.forEach((key, value) async{
await refclass.child(key).child('students').child(registernumber).update({
  "name":username
});
}):print('');
      await FirebaseAuth.instance.currentUser!.updateDisplayName(username);
      await FirebaseAuth.instance.currentUser!.reload();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User Name Updated Successfully')));

    }

  }
  static Future<dynamic> RegisterUserdata({required User userdata}) async{
    // print('data$userdata');
     DatabaseReference ref = FirebaseDatabase.instance.ref('users/students/${userdata.uid}');
    await ref.once().then((events) async {
      // print('Data : ${events.snapshot.exists}');
      if(events.snapshot.exists){
        Map userinfo = events.snapshot.value as Map;
        print(userinfo);
        FirebaseAuth.instance.currentUser;
        // DatabaseReference adminref = FirebaseDatabase.instance.ref('users/admin/${userdata.uid}');
        // await adminref.once().then((adminevents) {
        //
        // });
      }
      else{
        await ref.set({
          "id":userdata.uid,
          "name": userdata.displayName,
          "email": userdata.email,
          "role":'students'
        });
      }
    });

   }
   static Future<dynamic> RegisterNumber({required User users , required BuildContext context , required String regno})async{
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/students/${users.uid}');
    await ref.update({
      "registernumber":regno
    });
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => mainhome(users: users),
      ),
          (route) => false,//if you want to disable back feature set to false
    );
   }
   static Future<dynamic> JoinClass({required User users , required BuildContext context , required String classid})async{
    DatabaseReference ref = FirebaseDatabase.instance.ref('attendance/classes/$classid');
    DatabaseReference refstu = FirebaseDatabase.instance.ref('users/students/${users.uid}');
    await ref.once().then((value) async {
      if(value.snapshot.exists){
        var student = await refstu.once();
        Map studentData =  student.snapshot.value as Map;
        String regno = studentData['registernumber'];
        await refstu.child('classes').update({
            classid:{
              "id":classid
            }
        });
        await ref.child('students').child(regno).update({

              "name":users.displayName,
              "email":users.email,
              "registernumber":regno


        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Class Joined Successfully')));
        await GetClassList(context: context, users: users);
        // Navigator.pushAndRemoveUntil<dynamic>(
        //   context,
        //   MaterialPageRoute<dynamic>(
        //     builder: (BuildContext context) => MainClass(users: users),
        //   ),
        //       (route) => false,//if you want to disable back feature set to false
        // );
      }
      else{
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Class Not Found')));
      }
    });
   }
  static Future<dynamic> JoinClassQR({required User users , required BuildContext context , required String classid})async{
    DatabaseReference ref = FirebaseDatabase.instance.ref('attendance/classes/$classid');
    DatabaseReference refstu = FirebaseDatabase.instance.ref('users/students/${users.uid}');
    await ref.once().then((value) async {
      if(value.snapshot.exists){
        var student = await refstu.once();
        Map studentData =  student.snapshot.value as Map;
        String regno = studentData['registernumber'];
        await refstu.child('classes').update({
          classid:{
            "id":classid
          }
        });
        await ref.child('students').child(regno).update({

          "name":users.displayName,
          "email":users.email,
          "registernumber":regno


        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Class Joined Successfully')));
        // Navigator.pushAndRemoveUntil<dynamic>(
        //   context,
        //   MaterialPageRoute<dynamic>(
        //     builder: (BuildContext context) => MainClass(users: users),
        //   ),
        //       (route) => false,//if you want to disable back feature set to false
        // );
      }
      else{
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Class Not Found')));
      }
    });
  }
  static Future<dynamic> GetClassList({
    required BuildContext context,
    required User users
  })async{
    List<Map<dynamic , dynamic>> ListClass=[];
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/students/${users.uid}/classes');
    return await ref.once().then((value) {
      if (value.snapshot.exists) {
        Map<dynamic, dynamic> obj = value.snapshot.value as Map;
        obj.forEach((key, value) async {
          DatabaseReference reference = FirebaseDatabase.instance.ref(
              'attendance/classes/$key');
          await reference.once().then((listvalue) {
            ListClass.add(listvalue.snapshot.value as Map);
            if (ListClass.length == obj.keys.length) {
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute<dynamic>(
                builder: (BuildContext context) =>
                    MainClass(users: users, classList: ListClass,),
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
MainClass(users: users, classList: ListClass,),
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
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/students/${users.uid}/classes');

    await ref.once().then((value) {
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
  static Future<bool> PostAttendance({required User users ,required Map classdata , required BuildContext context}) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref(
        'attendance/classes/${classdata['id']}/Attendance_report/${classdata['year']}/${classdata['month']}/${classdata['day']}/${classdata['period']}'
    );
    DatabaseReference refstudent = FirebaseDatabase.instance.ref('users/students/${users.uid}');

    var stdata = await refstudent.child('classes').child(classdata['id']).once();
    var regst = await refstudent.once();
    var session = await ref.once();
    Map sessionVal = session.snapshot.value as Map;
    Map datas = stdata.snapshot.value as Map;
    Map register = regst.snapshot.value as Map;
    // print(datas);

    if(stdata.snapshot.exists){
      if(sessionVal['session']){
      await ref.child('data').child(register['registernumber']).update({
        "id":register['registernumber'],
        "name":users.displayName,
        "present":true
      });
      }
      else{
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('QR Code Not Active')));
      }
      return true;
    }
    else{
      return false;
    }
  }
  static Future<String> GetRegisterNumber({required User users})async{
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/students/${users.uid}');
    var data = await ref.once();
    Map student = data.snapshot.value as Map;
    return student['registernumber'];
  }
  static Future<Map> GetClassdataStudents({required Map classdata}) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref('attendance/classes/${classdata['id']}');
    var data = await ref.once();
    Map student = data.snapshot.value as Map;
    return student;
  }
}
