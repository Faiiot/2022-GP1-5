import 'package:findly_app/screens/home_screen.dart';
import 'package:findly_app/screens/login_screen.dart';
import 'package:findly_app/screens/welcom_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends StatelessWidget {
  static const String screenRoute = 'user_state_screen';


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot){
        if(userSnapshot.data == null){

          return LoginScreen();

        }else if(userSnapshot.hasData) {
          final FirebaseAuth _auth = FirebaseAuth.instance;
          final User? user = _auth.currentUser;
          final uid = user!.uid;
          return HomeScreen(userID: uid,);
        }else if(userSnapshot.hasError){
          return Center(
            child: Text("An error has occured",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 40,
            )
              ,),
          );
        }
        return Scaffold(
          body:Center(
          child: Text("somthing went wrong",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 40,
          )
          ),
          ),
        );
        });
  }
}
