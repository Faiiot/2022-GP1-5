import 'package:findly_app/screens/login_screen.dart';
import 'package:findly_app/screens/registration_screen.dart';
import 'package:findly_app/screens/widgets/my_button.dart';
import 'package:findly_app/screens/widgets/wide_button.dart';
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
                bottom: 6
              ),
              child: Image.asset(
                "assets/FindlyBlue.png",
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
              "assets/ksu_masterlogo_colour_rgb.png",
              width: MediaQuery.of(context).size.width * 0.75,
            ),
            const SizedBox(height: 48),
            WideButton(
              choice: 1,
              width: double.infinity,
              title: "Log in!",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),
            WideButton(
              choice: 2,
              width: double.infinity,
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
