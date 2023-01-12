import 'package:findly_app/constants/reference_data.dart';
import 'package:findly_app/firebase_options.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:findly_app/user_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Firebase.initializeApp(
    name: 'ksuMembersDatabase',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ReferenceData.instance.getReferenceData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        home: const UserState(),
        //this removes the glow that appears while scrolling
        scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
      ),
    );
  }
}
