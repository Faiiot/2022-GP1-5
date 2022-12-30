import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/screens/adimhomepage.dart';
import 'package:findly_admin/screens/admin_dashboard_screen.dart';
import 'package:findly_admin/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends StatefulWidget {
  static const String screenRoute = 'user_state_screen';

  @override
  State<UserState> createState() => _UserStateState();
}

class _UserStateState extends State<UserState> {



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
          final String? userEmail = user.email;

          return adminhomepage(userID: uid);

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
          appBar: AppBar(
            leading: IconButton(
              onPressed: () { Navigator.pushReplacement(
                  context, MaterialPageRoute(
                builder: (context)=>LoginScreen()
                ,)
              ); },
              icon: Icon(Icons.login_sharp),

            ),
          ),
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
