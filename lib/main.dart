import 'package:flutter/material.dart';
import './pages/loading.dart';
import './pages/home.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/':(context)=>const loading(),
      '/home':(context)=>const home(),
    },
  ));
}

