
import 'dart:math';

import 'package:attendance/pages/AdminPages/AttendanceList.dart';
import 'package:attendance/pages/AdminPages/QRactionbutton.dart';
import 'package:attendance/pages/AdminPages/generateQR.dart';
import 'package:attendance/pages/AppBar.dart';
import 'package:attendance/services/adminDataService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
class AdminClassDefine extends StatefulWidget {
  const AdminClassDefine({Key? key , required this.users , required this.classdata}) : super(key: key);
  final User users;
  final Map classdata;
  @override
  State<AdminClassDefine> createState() => _AdminClassDefineState();
}

class _AdminClassDefineState extends State<AdminClassDefine>{
  bool isCallGoogle=true;
  late User user_info;
  late Map classdata;
  DateTime date = DateTime.now();
  late String dropyear = date.year.toString();
  late String dropmonth = date.month.toString();
  late List<Map<dynamic,dynamic>> Lesson;
  late Map datas;
  late Map DayList;
  List datalist = [];
  List months = [];
  List year = [];
  @override
  void initState() {
    user_info = widget.users;
    classdata = widget.classdata;
    // print(classdata);
    // print(dropmonth);
    // print(date.month.toString());
    datas = classdata['Attendance_report'];
    if(classdata['date'] != null) {
      date = DateFormat('dd-MM-yyyy').parse(classdata['date']);
      classdata['year'] = date.year.toString();
      classdata['month'] = date.month.toString();
      classdata['day'] = date.day.toString();
    }
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
    DayList = await AdminService.GetClassdata(classdata: classdata  , year: dropyear , month: dropmonth) as Map<dynamic , dynamic>;
    if(DayList == null){
      GetClassDrop();
      dropmonth = months.reduce((curr, next) => curr > next? curr: next).toString();
      dropyear = year.reduce((curr, next) => curr > next? curr: next).toString();
      // print('drop$dropmonth');
      datalist.clear();
      DayList = await AdminService.GetClassdata(classdata: classdata  , year: dropyear , month: dropmonth) as Map<dynamic , dynamic>;
      DayList.forEach((key, value) {
        // print('hes$value');
        makecards(lesson: value, day: key);
      });
    }
    else{
      DayList.forEach((key, value) {
        // print('hes$value');
        makecards(lesson: value, day: key);
      });
    }
    setState(() {
      isCallGoogle =false;
    });
    // print('hello$DayList');


  }
  List<DropdownMenuItem<String>> get yeardropdownItems{
    if(datas!=null) {
      List<DropdownMenuItem<String>> yearit = [];
      datas.forEach((key, value) {
        year.add(int.parse(key));
        yearit.add(DropdownMenuItem(child: Text(key.toString(),
          style: const TextStyle(
              fontSize: 18,
              color: Colors.purple
          ),
        ), value: key.toString()));
      });
      List<DropdownMenuItem<String>> ymenuItems = yearit.toList();
      // print(ymenuItems);
      return ymenuItems;
    }else{return [];}
  }
  List<DropdownMenuItem<String>> get monthdropdownItems{
    if(datas!=null) {
      Map newmonth = datas[dropyear];
      List<DropdownMenuItem<String>> monthit = [];
      // print('month${newmonth.keys}');
      newmonth.forEach((key, value) {
        months.add(int.parse(key));
        // print(key);
        monthit.add(DropdownMenuItem(child: Text(key.toString(),
          style: const TextStyle(
              fontSize: 18,
              color: Colors.purple
          ),
        ), value: key.toString()));
      });

      // print(monthit);
      return monthit;
    }
    else{
      return [];
    }
  }
  ListTile makeListTile({required Map<dynamic, dynamic> listdata , required String day}) => ListTile(
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
        padding: const EdgeInsets.only(right: 12.0),
        decoration: const BoxDecoration(
            border: Border(
                right: BorderSide(width: 1.0, color: Colors.black26))),
        // child: Icon(Icons, color: Colors.black),

        child:const FaIcon(FontAwesomeIcons.idBadge, color: Colors.green,)

    ),
    title: Text(
      'Day ${int.parse(day)}',
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
              child: Text('Period ${int.parse(listdata['period'])}',
                  style: const TextStyle(color: Colors.black))),
        )
      ],
    ),
    trailing:
    InkWell(
        onTap: (){
          Map classqrdetails  = {};
          classqrdetails['date'] = '$day-$dropmonth-$dropyear';
          classqrdetails['subjectname'] = classdata['subjectname'];
          classqrdetails['classname'] = classdata['classname'];
          classqrdetails['trainername'] = classdata['trainername'];
          classqrdetails['id'] = classdata['id'];
          classqrdetails['semester'] = classdata['semester'];
          classqrdetails['period'] = listdata['period'];

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => generateQR(users: user_info, class_info: classqrdetails)));

        },
        child: const Icon(Icons.qr_code_2, color: Colors.black, size: 30.0)
    ),
    onTap: () {
      Map classlistdetails  = {};
      classlistdetails['date'] = '$day-$dropmonth-$dropyear';
      classlistdetails['id'] = classdata['id'];
      Navigator.push(context, MaterialPageRoute(builder: (context)=>AttendanceList(classdata: listdata, users: user_info, classflow: classlistdetails,)));
      },
  );
  void makecards({required Map<dynamic,dynamic> lesson, required String day}){

      lesson.forEach((key, value) {

        datalist.add(makeCard(lesson: value, day: day));
      });
  }
  Card makeCard({required Map<dynamic,dynamic> lesson, required String day}) {

    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: makeListTile(  day: day, listdata: lesson),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBars(),
        body: datas!=null?SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Filters',
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        DropdownButton(
                          items: yeardropdownItems,
                          onChanged: (values) {
                            setState(() {
                            dropyear = values.toString();
                            GetAttendance();
                            });
                          },
                          value: dropyear,
                        ),
                        DropdownButton(
                          items: monthdropdownItems,
                          onChanged: (value) {
                            setState(() {
                              dropmonth = value.toString();
                              GetAttendance();

                            });
                          },
                          value: dropmonth,
                        ),
                        IconButton(
                          onPressed: () async {
                            setState(() {
                              isCallGoogle = true;
                            });
                          classdata = await AdminService.GetClassMap(classdata: classdata) as Map;
                          print(classdata);
                          setState(() {
                            classdata = classdata;
                            datas = classdata['Attendance_report'];
                            isCallGoogle = false;
                            GetAttendance();
                          });
                          },
                          icon: const Icon(Icons.autorenew),
                          iconSize: 30.0,
                          color: Colors.purple,
                        )
                      ],
                    ),
                    isCallGoogle?
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                          child: SpinKitWave(
                            color: Colors.purple,
                            size: 50,
                          ),
                        ):
                    Container(
                      height: MediaQuery.of(context).size.height * 0.82,
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
        ):SizedBox(),
        floatingActionButton: QRFloatButton(
          classdata: classdata, users: user_info,),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    }
  }

