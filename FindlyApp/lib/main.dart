import 'package:findly_app/constants/reference_data.dart';
import 'package:findly_app/firebase_options.dart';
import 'package:findly_app/onboarding.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:findly_app/services/push_notif_wrapper.dart';
import 'package:findly_app/user_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

String uidUser = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Firebase.initializeApp(
    name: 'ksuMembersDatabase',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ReferenceData.instance.getReferenceData();
  final onboardUser = await GlobalMethods.onboardUser();
  runApp(
    MyApp(
      onboardUser: onboardUser,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    this.onboardUser = true,
  });

  final bool onboardUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GlobalMethods.unFocus(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Findly.',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.blue,
        ),
        // home: OnBoardingScreen(),
        home: onboardUser
            ? const OnBoardingScreen()
            : PushApplication(
                child: const UserState(),
              ),
        scrollBehavior: const ScrollBehavior().copyWith(
          //this removes the glow that appears while scrolling
          overscroll: false,
        ),
      ),
    );
  }
}
