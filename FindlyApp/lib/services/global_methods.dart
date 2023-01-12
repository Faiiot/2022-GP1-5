import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../constants/dates.dart';

//Dart file with global methods user in the project
class GlobalMethods {
  // static int userCount = 11;

  //If the user taps anywhere on the screen, the keyboard will be dismissed through this function
  static void unFocus() {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
  }

  static validateEmail({required TextEditingController email}) {
    final bool validEmail = EmailValidator.validate(email.text.trim());
    return validEmail;
  }

  static void showErrorDialog({required String error, required BuildContext context}) {
    var pos = error.lastIndexOf(']');
    String result = (pos != -1) ? error.substring(pos + 2) : error;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.error,
                  color: Colors.redAccent,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Error occured"),
              ),
            ],
          ),
          content: Text(
            result,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 20,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  // static void addUser() {
  //   userCount = userCount + 1;
  // }
  //
  // static int returnUserCount() {
  //   return userCount;
  // }

  static List applyFilters(
    List data,
    DateTime? selectedDate,
    String? selectedCategory,
    String? selectedBuildingName,
  ) {
    if (selectedDate != null) {
      data.retainWhere(
        (datum) {
          return Dates.parsedDate(datum['annoucementDate']).isAfter(selectedDate);
        },
      );
    }
    if (selectedCategory != null) {
      data.retainWhere(
        (datum) => datum['itemCategory'] == selectedCategory,
      );
    }
    if (selectedBuildingName != null) {
      data.retainWhere(
        (datum) => datum['buildingName'] == selectedBuildingName,
      );
    }
    return data;
  }
}
