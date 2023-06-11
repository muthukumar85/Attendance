import 'package:attendance/pages/AppBar.dart';
import 'package:attendance/services/adminDataService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AttendanceList extends StatefulWidget {
  const AttendanceList({Key? key , required this.users , required this.classdata , required this.classflow}) : super(key: key);
  final User users;
  final Map classdata;
  final Map classflow;

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  List datalist = [];
  bool isCallPresent = false;
  bool change = true;
  bool isCallGoogle = true;
  late Map classdata;
  late User users;
  late Map classflow;
  late DateTime date;
  GetList(){
    setState(() {
      isCallGoogle  = true;
    });
      datalist = [];
      makecards(lesson: classdata['data']);
      setState(() {
        isCallGoogle = false;
      });
  }
  CallWave({required bool val}){
    setState(() {
      isCallPresent = val;
    });
  }
  ListTile makeListTile({required Map<dynamic, dynamic> listdata}) => ListTile(
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
        padding: const EdgeInsets.only(right: 12.0),
        decoration: const BoxDecoration(
            border: Border(
                right: BorderSide(width: 1.0, color: Colors.black26))),
        // child: Icon(Icons, color: Colors.black),

        child:listdata['present']?const FaIcon(FontAwesomeIcons.check, color: Colors.green,):const FaIcon(FontAwesomeIcons.xmark , color: Colors.red,size: 26,)

    ),
    title: Text(
      '${listdata['id']}',
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),


    subtitle: Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Text('${listdata['name']}',
                  style: const TextStyle(color: Colors.black))),
        ),
      ],
    ),
    trailing:
    CupertinoSwitch(
      value: listdata['present'],
      onChanged: (value) async{
        setState(() {
          CallWave(val: true);
        });
        if(value == false) {
          listdata['present'] = await AdminService.ChangePresent(
              classdata: classflow, regno: listdata['id'], attendance: value);
        }
        else{
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('You cannot Mark present for students')));

        }
          setState(() {
          CallWave(val: false);
          isCallPresent = false;
          GetList();
        });
      },
    ),
    onTap: () {

    },
  );
  void makecards({required Map<dynamic,dynamic> lesson}){

    lesson.forEach((key, value) {

      datalist.add(makeCard(lesson: value));
    });
  }
  Card makeCard({required Map<dynamic,dynamic> lesson}) {

    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: makeListTile(  listdata: lesson),
      ),
    );
  }
  @override
  void initState() {
    users = widget.users;
    classdata = widget.classdata;
    classflow = widget.classflow;
    // print(classdata);
    date = DateFormat('dd-MM-yyyy').parse(classflow['date']);
    classflow['year'] = date.year.toString();
    classflow['month'] = date.month.toString();
    classflow['day'] = date.day.toString();
    classflow['period'] = classdata['period'];
    // print(classflow );
    GetList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(isCallGoogle){
      return const Scaffold(
        body: SpinKitCircle(
          color: Colors.purple,
          size: 100,
        ),
      );
    }
    else {
      return Scaffold(
        appBar: AppBars(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isCallPresent?const SizedBox(height:30,child: SpinKitWave(color: Colors.purple,size: 30,)):const SizedBox(height: 30,),
                    SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.82,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: datalist.length,
                            itemBuilder: (context, index) {
                              return datalist[index];
                            }),
                      ),
                    ),

                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
