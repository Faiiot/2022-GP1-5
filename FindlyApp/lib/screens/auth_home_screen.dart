import 'package:findly_app/screens/login_screen.dart';
import 'package:findly_app/screens/registration_screen.dart';
import 'package:findly_app/screens/widgets/my_button.dart';
import 'package:flutter/material.dart';

import '../constants/curved_app_bar.dart';
import '../constants/constants.dart';

class AuthHomeScreen extends StatelessWidget {
  const AuthHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: const CurvedAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
              ),
              child: Image.asset(
                "assets/findly.png",
                color: Colors.black,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 16,
              ),
              child: Divider(
                height: 1,
                thickness: 5,
                color: primaryColor,
              ),
            ),
            Image.asset(
              "assets/ksu_black_logo.jpeg",
              width: MediaQuery.of(context).size.width * 0.75,
            ),
            const SizedBox(height: 48),
            MyButton(
              color: primaryColor,
              title: "Log in",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),
            MyButton(
              color: primaryColor,
              title: "Sign Up!",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistrationScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}