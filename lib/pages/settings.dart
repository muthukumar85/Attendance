
import 'package:attendance/pages/AppBar.dart';
import 'package:attendance/pages/changeCredentials.dart';
import 'package:attendance/services/UserDataService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key , required User this.users}) : super(key: key);
  final User users;
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late User user_info;
  late Map user_data = {};
  @override
  void initState() {
    user_info = widget.users;
    GetData();
    super.initState();
  }
  void GetData()async{


      user_data = await UserService.GetData(userdata: user_info) as Map;
      setState(() {

      });
      print(user_data);
  }
  @override
  Widget build(BuildContext context) {
    return user_data!= {}
        ? Scaffold(
      appBar: AppBars(),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Account' , style: TextStyle(color: Colors.black),),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.person),
                title: Text('Username'),
                trailing: Icon(Icons.chevron_right),
                onPressed: (context){
                  Navigator.push(
                    context, MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) =>
                        ChangeCredential(users: user_info, credential: false, userdata: user_data , ),
                  ),
                  );
                },
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.app_registration),
                title: Text('Register number'),
                trailing: Icon(Icons.chevron_right),
                onPressed: (context){
                  Navigator.push(
                    context, MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) =>
                        ChangeCredential(users: user_info, credential: true, userdata: user_data , ),
                  ),
                  );
                },
              ),

            ],
          ),
        ],
      ),
    ): Scaffold(appBar: AppBars(),body: Center(
      child: SpinKitCircle(
        size: 70,
        color: Colors.purple,
      ),
    ),);
  }
}
