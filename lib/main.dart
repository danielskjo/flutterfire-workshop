import 'package:flutter/material.dart';

import './screens/dashboard_screen.dart';
import './screens/login_screen.dart';
import './screens/registration_screen.dart';

void main() => runApp(MaterialApp(
  initialRoute: "/login",
  routes: {
    "/login": (context) => LoginScreen(),
    "/register": (context) => RegistrationScreen(),
    "/dashboard": (context) => DashboardScreen(),
  }
));