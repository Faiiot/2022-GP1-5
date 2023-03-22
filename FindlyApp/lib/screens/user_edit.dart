import 'package:findly_app/screens/forgot_password_screen.dart';
import 'package:findly_app/screens/user_profile_page.dart';
import 'package:flutter/material.dart';

import 'edit_email.dart';
import 'edit_phone.dart';

class UserEdit extends StatefulWidget {
  const UserEdit({
    super.key,
    required this.userID,
  });

  final String userID;

  @override
  State<UserEdit> createState() => UserEditState();
}

class UserEditState extends State<UserEdit> {
  late String type;
  late String name;
  String dropDownValue = "";
  final editFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Edit Profile ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    //back button
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfilePage(userID: widget.userID)));
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, top: 150, right: 10, bottom: 30),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditEmail(userID: widget.userID),
                    ),
                  );
                },
                child: SizedBox(
                  height: 110,
                  width: 200,
                  child: Card(
                    elevation: 7,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.mail_outline_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Edit Email ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPhone(userID: widget.userID),
                      ));
                },
                child: SizedBox(
                  height: 110,
                  width: 200,
                  child: Card(
                    elevation: 7,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.phone_android,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Edit\nPhone Number ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ));
                },
                child: SizedBox(
                  height: 110,
                  width: 200,
                  child: Card(
                    elevation: 7,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.lock_reset,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Reset Password ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
        ));
  }
}
