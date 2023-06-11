import 'package:attendance/pages/AppBar.dart';
import 'package:attendance/pages/NavBar.dart';
import 'package:attendance/pages/class/classFriendDefine.dart';
import 'package:attendance/pages/class/classcards.dart';
import 'package:attendance/services/adminDataService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class MainFriendClass extends StatefulWidget {
  const MainFriendClass({Key? key , required User this.users , required this.classList}) : super(key: key);
  final User? users;
  final List<Map<dynamic,dynamic>> classList;
  @override
  State<MainFriendClass> createState() => _MainFriendClassState();
}

class _MainFriendClassState extends State<MainFriendClass> {
  late User current_user;
  late List<Map<dynamic,dynamic>> classlist;
  bool isAdmin = false;
  @override
  void initState(){
    current_user = widget.users!;
    classlist = widget.classList;
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
                  builder: (BuildContext context) => ClassFriendsListData(users:current_user, classdata: value,),
                ),
                );
              },
              child: CardClass(classdata: value,),
          )
          ).toList():[],

        ),
      ),
    );
  }
}
