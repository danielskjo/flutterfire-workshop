import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './screens/dashboard_screen.dart';
import './screens/login_screen.dart';
import './screens/registration_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'My App', initialRoute: "/login", routes: {
      "/login": (context) => const LoginScreen(),
      "/register": (context) => const RegistrationScreen(),
      "/dashboard": (context) => const DashboardScreen(),
    });
  }
}
