import 'package:flutter/material.dart';

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
    Radius.circular(10),
  )),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 2,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      )),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blueAccent,
        width: 2,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      )),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
    borderSide: BorderSide(color: Colors.red),
  ),
);
