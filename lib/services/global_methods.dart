import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';


//Dart file with global methods user in the project
class GlobalMethods {
  static int userCount = 11;
  static validateEmail({required TextEditingController email}){
    final bool validEmail = EmailValidator.validate(email.text.trim());
    return validEmail;
  }
  static void showErrorDialog({required String error, required BuildContext context}){
    var pos = error.lastIndexOf(']');
    String result = (pos != -1)? error.substring(pos+2): error;
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Row(
              children: [
                Padding(padding: const EdgeInsets.all(8.0),
                  child:Icon(Icons.error, color: Colors.redAccent,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Error occured"),
                ),
              ],
            ),
            content: Text(
              result,
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.canPop(context)?
                  Navigator.pop(context) : null;
                },
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              )
            ],

          );
        });
  }
  static void addUser(){
    userCount = userCount + 1;
}
  static int returnUserCount (){
    return userCount;
  }
}

