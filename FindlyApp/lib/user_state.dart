import 'package:findly_app/screens/auth_home_screen.dart';
import 'package:findly_app/screens/user_dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// A file that checks the user's state
class UserState extends StatelessWidget {
  static const String screenRoute = 'user_state_screen';

  const UserState({super.key});

  @override
  Widget build(BuildContext context) {
    //a stream builder for connection with Firebase
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          //User is not logged in > redirected to log in screen
          if (userSnapshot.data == null) {
            return const AuthHomeScreen();
          } //If the user is logged in she will be redirected to her homepage
          else if (userSnapshot.hasData) {
            final FirebaseAuth auth = FirebaseAuth.instance;
            final User? user = auth.currentUser;
            final uid = user!.uid;
            return UserDashboardScreen(
              userID: uid,
            );
          } else if (userSnapshot.hasError) {
            return const Center(
              // if an error occurred
              child: Text(
                "An error has occurred",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            );
          }
          return const Scaffold(
            // if something went wrong during the run
            body: Center(
              child: Text("Something went wrong",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  )),
            ),
          );
        });
  }
}
