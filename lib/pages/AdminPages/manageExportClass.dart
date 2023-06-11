import 'package:attendance/pages/AdminPages/ExportClassDefine.dart';
import 'package:attendance/pages/AppBar.dart';
import 'package:attendance/pages/NavBar.dart';
import 'package:attendance/pages/class/classcards.dart';
import 'package:attendance/services/adminDataService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ManageExportClass extends StatefulWidget {
  const ManageExportClass({Key? key , required this.users , required this.classList}) : super(key: key);
  final User users;
  final List<Map<dynamic,dynamic>> classList;
  @override
  State<ManageExportClass> createState() => _ManageExportClassState();
}

class _ManageExportClassState extends State<ManageExportClass> {
  late User user_info;
  late List<Map<dynamic,dynamic>> CList;
  @override
  void initState() {
    user_info = widget.users;
    CList = widget.classList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars(),
      drawer: NavBar(users: user_info, IsAdmin: true,),
      body: SingleChildScrollView(
        child: Column(
          children:CList!=null?
          CList.map((value) => InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExportClassDefine(classdata: value, users: user_info,)),
              );
            },
            child: CardClass(classdata: value,),
          )).toList():[],
        ),
      ),
    );
  }
}
