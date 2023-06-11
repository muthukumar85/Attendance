import 'package:attendance/pages/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/authentication.dart';
import './home.dart';
import '../globals/globals.dart';
class loading extends StatefulWidget {
  const loading({Key? key}) : super(key: key);

  @override
  State<loading> createState() => _loadingState();
}

class _loadingState extends State<loading> {
  @override
  void initState() {
    super.initState();
    
    variable.isLoggedIn = false;
    Future.delayed(const Duration(seconds: 0),() async{
      
      dynamic data = await Authentication.initializeFirebase();
      // print(data);
      FirebaseAuth.instance
          .authStateChanges()
          .listen((User? user) {
        if (user == null) {
          variable.isLoggedIn = false;
          if(mounted) {
            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const home(),
              ),
                  (
                  route) => false, //if you want to disable back feature set to false
            );
          }
        } else {
          if(mounted) {
            variable.isLoggedIn = true;
            //LoginWithCredentials.signInWithGoogle(context: context);

            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const home(),
              ),
                  (
                  route) => false, //if you want to disable back feature set to false
            );
          }
        }
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars(),
      body:const Center(
        child: SpinKitCircle(
          color: Colors.purple,
          size: 100.0,
        ),
      )
    );
  }
}
