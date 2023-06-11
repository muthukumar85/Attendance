
import 'package:attendance/pages/AppBar.dart';
import 'package:attendance/pages/NavBar.dart';
import 'package:attendance/pages/class/classcards.dart';
import 'package:attendance/pages/class/listclassdetails.dart';
import 'package:attendance/services/adminDataService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainClass extends StatefulWidget {
  const MainClass({Key? key , required User this.users , required this.classList}) : super(key: key);
  final User? users;
  final List<Map<dynamic,dynamic>> classList;
  @override
  State<MainClass> createState() => _MainClassState();
}

class _MainClassState extends State<MainClass> {
  late User current_user;
  late List<Map<dynamic,dynamic>> classlist;
  // dynamic i = 0;
  bool isAdmin = false;
  @override
  void initState(){
    current_user = widget.users!;
    classlist = widget.classList;
    // print(classlist);
    // int len = (classlist.length/2) as int;
    super.initState();
    AdminCheck();
  }
  AdminCheck()async{
    isAdmin = await AdminService.IsAdmin(users: current_user);
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars(),
      drawer: NavBar(users: current_user, IsAdmin: isAdmin , ),
      body: SingleChildScrollView(
        child: Column(
          children:
            classlist!=null?
            classlist.map((value) => InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute<dynamic>(
                  // builder: (BuildContext context) => ClassDefine(users: current_user),
                  builder: (BuildContext context) => ClassListData(users:current_user, classdata: value,),
                ),
                );
              },
                child: CardClass(classdata: value,),
            )
            ).toList():[

            ],

        ),
      ),
    );
  }
}
