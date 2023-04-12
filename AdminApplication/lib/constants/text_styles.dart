import 'package:flutter/material.dart';

import 'constants.dart';

class TextStyles {
  static TextStyle appBarTitleTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: "Montserrat",
    color: Colors.white,
    fontSize: 35,
  );

  static TextStyle buttonTextStyle = const TextStyle(
    fontFamily: "Montserrat",
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static TextStyle secondButtonTextStyle = const TextStyle(
    fontFamily: "Montserrat",
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static TextStyle alertDialogueTitleTextStyle = const TextStyle(
    fontFamily: "Montserrat",
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color.fromRGBO(10, 59, 102, 100),
  );
  static TextStyle alertDialogueMessageTextStyle = const TextStyle(
    fontFamily: "Montserrat",
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color.fromRGBO(3, 90, 166, 85),
  );

  static TextStyle alertDialogueMainButtonTextStyle = const TextStyle(
    fontFamily: "Montserrat",
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static TextStyle alertDialogueSecondaryButtonTextStyle = const TextStyle(
    fontFamily: "Montserrat",
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color.fromRGBO(3, 90, 166, 100),
  );

  static TextStyle h2 = const TextStyle(
    fontFamily: "Montserrat",
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Color.fromRGBO(3, 90, 166, 100),
  );

  static const TextStyle announcementTypeTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
    color: Color.fromRGBO(3, 90, 166, 100),
  );

  static const appBarTitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
}
