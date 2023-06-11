
import 'package:attendance/pages/AppBar.dart';
import 'package:attendance/services/UserDataService.dart';
import 'package:attendance/services/adminDataService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ClassFriendsListData extends StatefulWidget {
  const ClassFriendsListData({Key? key , required this.users , required this.classdata}) : super(key: key);
  final User users;
  final Map classdata;
  @override
  State<ClassFriendsListData> createState() => _ClassFriendsListDataState();
}

class _ClassFriendsListDataState extends State<ClassFriendsListData>{
  bool isCallGoogle=true;
  bool isAdmin = false;
  late User user_info;
  late Map classdata;
  DateTime date = DateTime.now();
  late List<Map<dynamic,dynamic>> Lesson;
  late Map datas;
  late Map DayList;
  late String register;
  List datalist = [];
  @override
  void initState() {
    user_info = widget.users;
    classdata = widget.classdata;
    print(classdata);
    datas = classdata['Attendance_report'];

      date = DateFormat('dd-MM-yyyy').parse(date.toString());
      classdata['year'] = date.year.toString();
      classdata['month'] = date.month.toString();
      classdata['day'] = date.day.toString();
    GetAttendance();
    if(datas == null) {
      GetClassDrop();
    }
    super.initState();
  }
  GetClassDrop()async{
    setState(() {
      isCallGoogle = true;
    });
    classdata = await AdminService.GetClassMap(classdata: classdata) as Map;
    setState(() {
      classdata = classdata;
      datas = classdata['Attendance_report'];
      isCallGoogle = false;
    });
  }
  GetAttendance()async{
    setState(() {
      isCallGoogle = true;
    });
    datalist.clear();
    isAdmin = await AdminService.IsAdmin(users: user_info);
    if(!isAdmin) {
      register = await UserService.GetRegisterNumber(users: user_info);
    }
    else{
      register = 'skjdnfjkd';
    }
    // print(register);
    DayList = await UserService.GetClassdataStudents(classdata: classdata);
    setState(() {
      isCallGoogle =false;
    });
    // print('hello$DayList');
      makecards( lesson: DayList['students'] , regno: register);
  }

  ListTile makeListTile({required Map<dynamic, dynamic> listdata  , required String regno}) => ListTile(
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
        padding: const EdgeInsets.only(right: 12.0),
        decoration: const BoxDecoration(
            border: Border(
                right: BorderSide(width: 1.0, color: Colors.black26))),
        // child: Icon(Icons, color: Colors.black),

        child:
        const FaIcon(FontAwesomeIcons.users, color: Colors.green,)

    ),
    title: Text(
      listdata['name'],
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),


    subtitle: Row(
      children: <Widget>[
        // Expanded(
        //   flex: 1,
        //   child: Container(
        //     // tag: 'hero',
        //     child: listdata['period']>0.5?LinearProgressIndicator(
        //         backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
        //         value: listdata['d'],
        //         valueColor: AlwaysStoppedAnimation(Colors.green)):LinearProgressIndicator(
        //         backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
        //         value: listdata['ds'],
        //         valueColor: AlwaysStoppedAnimation(Colors.red)),
        //   ),
        // ),
        Expanded(
          flex: 4,
          child: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Text(listdata['registernumber'],
                  style: const TextStyle(color: Colors.black))),
        )
      ],
    ),
    trailing:isAdmin?InkWell(child: const FaIcon(FontAwesomeIcons.solidTrashCan , color: Colors.red, size:25),
    onTap: ()async{
      setState(() {
        isCallGoogle = true;
      });
      await AdminService.RemoveStudent(classdata: classdata, regno: listdata['registernumber']);
      await GetAttendance();
    },
    ):
    const Text('Friends' , style: TextStyle(color: Colors.green),),
    // Icon(Icons.qr_code_2, color: Colors.black, size: 30.0),
  );
  void makecards({required Map<dynamic,dynamic> lesson, required String regno}){

    lesson.forEach((key, value) {
      print('val$value');
      if(value['registernumber']==register){
        print('');
      }
      else {
        datalist.add(makeCard(lesson: value, regno: regno));
      }
    });
  }
  Card makeCard({required Map<dynamic,dynamic> lesson,  required String regno}) {

    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: makeListTile(   listdata: lesson , regno:regno),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if(isCallGoogle){
      return const Scaffold(
          body:SpinKitCircle(
            color: Colors.purple,
            size: 100,
          )
      );
    }
    else {
      return Scaffold(
        appBar: AppBars(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: datalist.length,
                          itemBuilder: (context, index) {
                            // return makeCard(DayList[index]); //{01: {01: {period: 01, session: false}}}
                            return datalist[index];
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

