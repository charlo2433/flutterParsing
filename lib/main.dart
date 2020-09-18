import 'package:flutter/material.dart';
import 'package:flutterapitut/view/dashboard.dart';
import 'package:flutterapitut/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final key = 'token';
  final value = prefs.get(key ) ?? null;
  runApp(MaterialApp(home: value == null ? LoginPage() : Dashboard(),));
}

class MyApp extends StatelessWidget {
  final String title='';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

    );
  }
}

