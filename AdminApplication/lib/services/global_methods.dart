import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/dates.dart';
import '../constants/text_styles.dart';
import '../screens/widgets/dialog_button.dart';

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

  static String getMessage(String error) {
    var pos = error.lastIndexOf(']');
    String result = (pos != -1) ? error.substring(pos + 2) : error;
    return result;
  }

  static void showErrorDialog({
    required String error,
    required BuildContext context,
  }) {
    String message = getMessage(error);
    if(message == "The password is invalid or the user does not have a password."){
      message = "Admin ID or password is incorrect !";
    }
    if(message == "RangeError (index): Invalid value: Valid value range is empty: 0" ){
      message = "Could not find an account related to this admin ID !";
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text("Something went wrong!"),
          titleTextStyle: TextStyles.alertDialogueTitleTextStyle,
          backgroundColor: Colors.white,
          content: Text(
            message,
            style: TextStyles.alertDialogueMessageTextStyle,
          ),
          elevation: 7,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: DialogueButton(
                    choice: 1,
                    title: "OK",
                    onPressed: () {
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                    },
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
              ],
            ),
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
          return Dates.parsedDate(datum['annoucementDate'])
              .isAfter(selectedDate);
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

  // static Future<void> incrementDeleteItemCount() async {
  //   FirebaseFirestore.instance
  //       .collection(
  //         "deletedAnnouncements",
  //       )
  //       .doc("foundOrReturned")
  //       .update(
  //     {
  //       "count": FieldValue.increment(1),
  //     },
  //   );
  //   //Resetting the value before assigning it a new one
  //   ReferenceData.instance.returnedItems = 0;
  //
  //   QuerySnapshot lostItemSnapshot =
  //       await FirebaseFirestore.instance.collection('lostItem').get();
  //   ReferenceData.instance.returnedItems += lostItemSnapshot.docs
  //       .where(
  //         (e) => (e.data() as Map)["found"] == true,
  //       )
  //       .length;
  //   QuerySnapshot foundItemsSnapshot =
  //       await FirebaseFirestore.instance.collection('foundItem').get();
  //   ReferenceData.instance.returnedItems += foundItemsSnapshot.docs
  //       .where(
  //         (e) => (e.data() as Map)["returned"] == true,
  //       )
  //       .length;
  //   final data = await FirebaseFirestore.instance
  //       .collection('deletedAnnouncements')
  //       .doc("foundOrReturned")
  //       .get();
  //   int count = (data.data() as Map)["count"];
  //   ReferenceData.instance.returnedItems += count;
  // }

  // static Future<bool> onboardUser() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool? onboardUser = prefs.getBool('onboardUser');
  //   if (onboardUser == null) {
  //     await prefs.setBool('onboardUser', false);
  //     onboardUser = true;
  //   }
  //   return onboardUser;
  // }

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

  static Future<void> reAuthenticateUser(String password) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final credential = EmailAuthProvider.credential(
        email: currentUser?.email ?? "",
        password: password,
      );
      await currentUser?.reauthenticateWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  static void showCustomizedDialogue({
    Widget? content,
    required String title,
    String message = "",
    required String mainAction,
    required BuildContext context,
    required String secondaryAction,
    required VoidCallback? onPressedMain,
    required VoidCallback onPressedSecondary,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(title),
          titleTextStyle: TextStyles.alertDialogueTitleTextStyle,
          backgroundColor: Colors.white,
          content: content ??
              Text(
                message,
                style: TextStyles.alertDialogueMessageTextStyle,
              ),
          elevation: 7,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: DialogueButton(
                    choice: 1,
                    title: mainAction,
                    onPressed: onPressedMain,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Center(
                  child: DialogueButton(
                    choice: 2,
                    title: secondaryAction,
                    onPressed: onPressedSecondary,
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> showToast(String message) {
    return Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.blueGrey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static List quicksort(List arr) {
    if (arr.length <= 1) {
      return arr;
    }
    var pivot = arr[0];
    List left = [];
    List right = [];

    for (int i = 1; i < arr.length; i++) {
      if (arr[i]["lastMessageTime"] >= pivot["lastMessageTime"]) {
        left.add(arr[i]);
      } else {
        right.add(arr[i]);
      }
    }

    left = quicksort(left);
    right = quicksort(right);

    return [...left, pivot, ...right];
  }

  static List sortNotification (List notifications){
    if (notifications.length <= 1) {
      return notifications;
    }
    var pivot = notifications[0];
    List left = [];
    List right = [];

    for (int i = 1; i < notifications.length; i++) {
      if (notifications[i]["created_at"] >= pivot["created_at"]) {
        left.add(notifications[i]);
      } else {
        right.add(notifications[i]);
      }
    }

    left = sortNotification(left);
    right = sortNotification(right);

    return [...left, pivot, ...right];
  }

  static List quickSortAnnouncement(List data){
    if (data.length <= 1) {
      return data;
    }
    var pivot = data[0];
    List left = [];
    List right = [];

    for (int i = 1; i < data.length; i++) {
      if (data[i]["annoucementDate"] >= pivot["annoucementDate"]) {
        left.add(data[i]);
      } else {
        right.add(data[i]);
      }
    }

    left = sortNotification(left);
    right = sortNotification(right);

    return [...left, pivot, ...right];
  }

  // static List<DocumentSnapshot> sortDocumentsByTimestamp(List<DocumentSnapshot> documents, String timestampAttributeName, bool ascending) {
  //   return documents..sort((a, b) {
  //     Timestamp aTimestamp = a.data()?["timestampAttributeName"];
  //     Timestamp bTimestamp = b.data()?[timestampAttributeName];
  //     if (aTimestamp == null || bTimestamp == null) {
  //       return 0;
  //     }
  //     if (ascending) {
  //       return aTimestamp.compareTo(bTimestamp);
  //     } else {
  //       return bTimestamp.compareTo(aTimestamp);
  //     }
  //   });
  // }
}
