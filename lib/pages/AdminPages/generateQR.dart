import 'dart:convert';

import 'package:attendance/pages/AppBar.dart';
import 'package:attendance/services/adminDataService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
class generateQR extends StatefulWidget {
  const generateQR({Key? key , required this.users , required this.class_info}) : super(key: key);
  final User users;
  final Map class_info;
  @override
  State<generateQR> createState() => _generateQRState();
}

class _generateQRState extends State<generateQR> with WidgetsBindingObserver{
  bool isCallGoogle = false;
  late User users;
  late Map class_info;
  late DateTime date;
  List<Map> students = [];
  @override
  void initState() {
    users = widget.users;
    class_info = widget.class_info;
    // print(class_info);
    class_info.remove('trainerID');
    class_info.remove('Attendance_report');
    // print(DateFormat('dd-MM-yyyy').parse(class_info['date']));
    date = DateFormat('dd-MM-yyyy').parse(class_info['date']);
    class_info['year'] = date.year.toString();
    class_info['month'] = date.month.toString();
    class_info['day'] = date.day.toString();
    if(class_info['day'] == "1"){
      class_info['day'] = "01";
    }
    if(class_info['period'] == "1"){
      class_info['period'] = "01";
    }

    students = [

    ];
    CreateSession(true);
    GetList();
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }
  GetList()async{
    try {
      DatabaseReference reference = FirebaseDatabase.instance.ref(
          'attendance/classes/${class_info['id']}/Attendance_report/${class_info['year']}/${class_info['month']}/${class_info['day']}/${class_info['period']}/data');
      var data = await reference.once();
      if (data.snapshot.exists) {
        Stream<DatabaseEvent> stream = reference.onValue;
        Map data = {};
        stream.listen((event) {
          // print('Event Type: ${event.type}'); // DatabaseEventType.value;
          // print('Snapshot: ${event.snapshot}');
          // print('Snapshot: ${event.snapshot.value}');
          data = event.snapshot.value as Map;
          students.clear();
          data != null ? data.forEach((key, value) {
            if (value['present'] == true) {
              students.add({
                "name": value['name'],
                "regno": value['id']
              });
            }
          }) : print('');
          setState(() {
            print('');
          });
        });
      }
    }catch(e){}
  }
  CreateSession(session)async{
    setState(() {
      isCallGoogle = true;
    });
    await AdminService.SetSession(session: session, classdata: class_info);

    setState(() {
      isCallGoogle = false;
    });
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.inactive || state == AppLifecycleState.detached) return;
    final isBackground = state == AppLifecycleState.paused;
    if(isBackground){
      AdminService.SetSession(session: false, classdata: class_info);
    }else{
      AdminService.SetSession(session: true, classdata: class_info);

    }
  }
  @override
  void deactivate(){
    AdminService.SetSession(session: false, classdata: class_info);
    super.deactivate();
  }
  @override
  void dispose(){
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(Map lesson) => ListTile(
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      leading: Container(
          padding: const EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
              border: Border(
                  right: BorderSide(width: 1.0, color: Colors.black26))),
          // child: Icon(Icons, color: Colors.black),

          child: const FaIcon(FontAwesomeIcons.check, color: Colors.green,)

      ),
      title: Text(
        lesson['regno'],
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),


      subtitle: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Text(lesson['name'],
                    style: const TextStyle(
                        color: Colors.black,
                      fontSize: 17
                    ))),
          )
        ],
      ),
      trailing:
          const FaIcon(FontAwesomeIcons.shieldCat,color: Colors.green,size: 25.0,),
      // Icon(Icons.calendar_month, color: Colors.black, size: 30.0),
      onTap: () {
      },
    );
    Card makeCard(Map lesson) => lesson!=null?Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: makeListTile(lesson),
      ),
    ):Card();
    if(isCallGoogle){
      return const Scaffold(
          body:Center(
            child: SpinKitCircle(
              color: Colors.purple,
              size: 100.0,
            ),
          ));
    }
    else {
      return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBars(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Colors.purple,
                                  width: 3.0,
                                  style: BorderStyle.solid),
                              right: BorderSide(color: Colors.purple,
                                  width: 3.0,
                                  style: BorderStyle.solid),
                              top: BorderSide(color: Colors.purple,
                                  width: 3.0,
                                  style: BorderStyle.solid),
                              bottom: BorderSide(color: Colors.purple,
                                  width: 3.0,
                                  style: BorderStyle.solid),
                            )
                        ),
                        child: QrImage(
                          data: jsonEncode(class_info),
                          version: QrVersions.auto,
                          size: 300,
                          gapless: true,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      const Divider(
                        height: 5,
                      ),
                      Text('Attendance List    ${students.length}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                      const SizedBox(height: 10,),

                      SingleChildScrollView(
                        child: SizedBox(
                          height: 340,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: students.length,
                              itemBuilder: (context, index) {
                                return makeCard(students[index]);
                              }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
  Future<bool> _onBackPressed() async {
    bool willLeave = false;
    await showDialog(
        context: context, builder: (context) {
      return AlertDialog(
        title: const Text('Are You Want to leave the session'),
        actions: [
          RaisedButton(
            elevation: 2.0,
              color: Colors.purple,
              onPressed: () {
                willLeave = true;
                Navigator.of(context).pop();
              },
              child: const Text('Leave' , style: TextStyle(color: Colors.white),)),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.purple),) ,)
        ],
      );
    });
    return willLeave;
  }
}
