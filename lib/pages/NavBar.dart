import 'package:attendance/pages/AdminPages/createClass.dart';
import 'package:attendance/pages/AdminPages/getPremium.dart';
import 'package:attendance/pages/class/joinclass.dart';
import 'package:attendance/pages/mainHome.dart';
import 'package:attendance/pages/settings.dart';
import 'package:attendance/services/UserDataService.dart';
import 'package:attendance/services/adminDataService.dart';
import 'package:attendance/services/loginWithCredentials.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key, required this.users , required this.IsAdmin}) : super(key: key);
  final User users;
  final bool IsAdmin;
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late User user_info;
  late bool isAdmin;
    bool isCallGoogle = false;
    bool linkfound = false;
    String link = '';
  @override
  initState(){
   user_info= widget.users;
  isAdmin = widget.IsAdmin;
  GetLink();
  super.initState();
   AdminSet();
  }
  GetLink()async{
    DatabaseReference ref = FirebaseDatabase.instance.ref('WebLink');
    Stream<DatabaseEvent> stream =  ref.onValue;
    Map data  = {};
    stream.listen((event) {
      // print('Snapshot: ${event.snapshot.value}');
      data = event.snapshot.value as Map;
      setState(() {
        link = data['link'];
        linkfound = data['show'];
      });
    });
  }
AdminSet() async{
  setState(() {
    // print(isAdmin);
  });
}
  @override
  Widget build(BuildContext context) {
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
      return Drawer(
        child: ListView(
          // Remove padding
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('${user_info.displayName}'),
              accountEmail: Text('${user_info.email}'),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: user_info.photoURL != null ? Image.network(
                    user_info.photoURL.toString(),
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ) : Image.asset('assets/man.webp', fit: BoxFit.cover,
                    width: 90,
                    height: 90,),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/5442673.jpg'),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () =>
                  Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) =>
                        mainhome(users: user_info),
                  ),
                          (route) => false
                  ),
            ),

            const Divider(),
            isAdmin == true ? ListTile(
                leading: const Icon(Icons.class_),
                title: const Text('Manage Class'),
                onTap: () async {
                  setState(() {
                    isCallGoogle = true;
                  });
                  await AdminService.GetClassList(users: user_info, context: context);
                  // setState(() {
                  //   isCallGoogle = false;
                  // });
                }
            ) : ListTile(
              leading: const Icon(Icons.description),
              title: const Text('My Classes'),
              onTap: () async{
                setState(() {
                  isCallGoogle = true;
                });
                await UserService.GetClassList(users: user_info, context: context);
              }

                  // Navigator.pushAndRemoveUntil(
                  //     context, MaterialPageRoute<dynamic>(
                  //   builder: (BuildContext context) =>
                  //       MainClass(users: user_info),
                  // ),
                  //         (route) => false
                  // ),
            ),
            isAdmin == true ? ListTile(
              leading: const Icon(Icons.class_),
              title: const Text('Create Class'),
              onTap: () =>
                  Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) =>
                        createClass(users: user_info),
                  ),
                          (route) => false
                  ),
            ) : ListTile(
    leading: const Icon(Icons.class_),
    title: const Text('Join Class'),
    onTap: () =>
    Navigator.push(
    context, MaterialPageRoute<dynamic>(
    builder: (BuildContext context) =>
    Joinclass(users: user_info),
    ),
    ),),
            const Divider(),
            isAdmin == true ? ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Students'),
              onTap: () async{
                setState(() {
                  isCallGoogle = true;
                });
                await AdminService.GetFriendClassList(context: context, users: user_info);
              },
            ) : ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Friends'),
              onTap: ()async{
                setState(() {
                  isCallGoogle = true;
                });
                await UserService.GetFriendClassList(users: user_info, context: context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () async{
                    if(linkfound){
                      Clipboard.setData(ClipboardData(text: link));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
                          Text('Link Copied to ClipBoard')
                        ));
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
                      Text('Link Not Found At the Moment')
                      ));
                    }
              },
            ),
            isAdmin?ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Export'),
              onTap: () async{
                setState(() {
                  isCallGoogle = true;
                });
                await AdminService.GetClassExportList(users: user_info, context: context);
              },
            ):const SizedBox(),

            const Divider(),
            isAdmin?const SizedBox():ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context, MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) =>
                      Settings(users: user_info),
                ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.diamond),
              title: const Text('Get Premium'),
              onTap: () =>
                  Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) =>
                        premium(users: user_info),
                  ),
                          (route) => false
                  ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Log Out'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () async {
                const SpinKitCircle(
                  color: Colors.purple,
                  size: 100.0,
                );
                await LoginWithCredentials.SignOut(context: context);
              },
            ),
          ],
        ),
      );
    }
  }
}