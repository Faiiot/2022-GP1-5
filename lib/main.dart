import 'package:findly_app/screens/forgot_password_screen.dart';
import 'package:findly_app/screens/home_screen.dart';
import 'package:findly_app/screens/login_screen.dart';
import 'package:findly_app/screens/registration_screen.dart';
import 'package:findly_app/screens/welcom_screen.dart';
import 'package:findly_app/user_state.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Findly.',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
       home: UserState(),

    );
  }
}


