
import 'package:attendance/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class Authentication {
  static Future<FirebaseApp> initializeFirebase() async {

    WidgetsFlutterBinding.ensureInitialized();
    FirebaseApp firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return firebaseApp;
  }
}
