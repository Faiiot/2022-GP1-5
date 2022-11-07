import 'package:findly_app/screens/home_screen.dart';
import 'package:findly_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// A file that checks the user's state
class UserState extends StatelessWidget {
  static const String screenRoute = 'user_state_screen';


  @override
  Widget build(BuildContext context) {
    //a stream builder for connection with Firebase
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot){
        //User is not logged in > redirected to log in screen
        if(userSnapshot.data == null){

          return LoginScreen();

        }//If the user is logged in she will be redirected to her homepage
        else if(userSnapshot.hasData) {
          final FirebaseAuth _auth = FirebaseAuth.instance;
          final User? user = _auth.currentUser;
          final uid = user!.uid;
          return HomeScreen(userID: uid,);
        }else if(userSnapshot.hasError){
          return Center(
            // if an error occure
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
          // if something went wrong during the run
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
