import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/dates.dart';
import '../constants/reference_data.dart';

//Dart file with global methods used in the project
class GlobalMethods {
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

  static Future<void> incrementDeleteItemCount() async {
    FirebaseFirestore.instance
        .collection(
          "deletedAnnouncements",
        )
        .doc("foundOrReturned")
        .update(
      {
        "count": FieldValue.increment(1),
      },
    );
    //Resetting the value before assigning it a new one
    ReferenceData.instance.returnedItems = 0;

    QuerySnapshot lostItemSnapshot = await FirebaseFirestore.instance.collection('lostItem').get();
    ReferenceData.instance.returnedItems += lostItemSnapshot.docs
        .where(
          (e) => (e.data() as Map)["found"] == true,
        )
        .length;
    QuerySnapshot foundItemsSnapshot =
        await FirebaseFirestore.instance.collection('foundItem').get();
    ReferenceData.instance.returnedItems += foundItemsSnapshot.docs
        .where(
          (e) => (e.data() as Map)["returned"] == true,
        )
        .length;
    final data = await FirebaseFirestore.instance
        .collection('deletedAnnouncements')
        .doc("foundOrReturned")
        .get();
    int count = (data.data() as Map)["count"];
    ReferenceData.instance.returnedItems += count;
  }

  static Future<bool> onboardUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? onboardUser = prefs.getBool('onboardUser');
    if (onboardUser == null) {
      await prefs.setBool('onboardUser', false);
      onboardUser = true;
    }
    return onboardUser;
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  static Future<void> sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: "mailto",
      path: email,
    );
    await launchUrl(launchUri);
  }
}
