import 'package:findly_app/constants/reference_data.dart';
import 'package:findly_app/firebase_options.dart';
import 'package:findly_app/onboarding.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:findly_app/services/push_notif_wrapper.dart';
import 'package:findly_app/user_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

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
  runApp(MyApp(onboardUser: onboardUser));
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
      child: ReactiveFormConfig(
        validationMessages: {
          ValidationMessage.required: (_) => "Field must not be empty",
          ValidationMessage.minLength: (_) => "Your password is less than 8 characters!",
          ValidationMessage.pattern: (_) => "Password does not match the conditions",
          ValidationMessage.mustMatch: (_) => "Passwords do not match",
          ValidationMessage.email: (_) => "Please enter a valid Email",
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Findly.',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: const MaterialColor(
              0xFF035AA6,
              {
                50: Color(0xFFe6eff6),
                100: Color(0xFFcddeed),
                200: Color(0xFFb3cee4),
                300: Color(0xFF9abddb),
                400: Color(0xFF81add3),
                500: Color(0xFF689cca),
                600: Color(0xFF4f8cc1),
                700: Color(0xFF357bb8),
                800: Color(0xFF1c6baf),
                900: Color(0xFF035aa6),
              },
            ),
            fontFamily: "Montserrat",
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
      ),
    );
  }
}
/*
***Credentials***
Member ID:
441201238
Password:
Fai123456789@
*/
