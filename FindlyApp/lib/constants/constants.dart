import 'package:flutter/material.dart';

RegExp regexPassword = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*+=%~]).{8,}$');

//constant file for variables to use in the project
class Constants {
  static Color darkBlue = Colors.lightBlue[900]!;
  static double formPadding = 24;
}

const kInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(
    vertical: 10,
    horizontal: 20,
  ),
  border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
    Radius.circular(16),
  )),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 2,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(16),
      )),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: primaryColor,
        width: 2,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(16),
      )),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(16),
    ),
    borderSide: BorderSide(color: Colors.red),
  ),
);

const kLinearGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    secondaryColor,
    primaryColor,
  ],
);
const kSecondaryLinearGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    color1,
    color2,
  ],
);

const Color primaryColor = Color(0xFF035AA6);
const Color scaffoldColor = Color(0xFFDFECF7);
const Color secondaryColor = Color(0xFF60A5FA);
const Color color1 = Color(0xFF8EC7ED);
const Color color2 = Color(0x86CDEEFF);
