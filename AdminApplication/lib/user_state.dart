import 'package:findly_admin/screens/admin_home_page.dart';
import 'package:findly_admin/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends StatefulWidget {
  static const String screenRoute = 'user_state_screen';

  const UserState({super.key});

  @override
  State<UserState> createState() => _UserStateState();
}

class _UserStateState extends State<UserState> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.data == null) {
          return LoginScreen();
        } else if (userSnapshot.hasData) {
          final FirebaseAuth auth = FirebaseAuth.instance;
          final User? user = auth.currentUser;
          final uid = user!.uid;

          return AdminHomePage(userID: uid);
        } else if (userSnapshot.hasError) {
          return const Center(
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
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.login_sharp),
            ),
          ),
          body: const Center(
            child: Text(
              "Something went wrong",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ),
        );
      },
    );
  }
}
