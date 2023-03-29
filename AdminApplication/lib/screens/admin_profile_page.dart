import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'edit_email.dart';
import 'edit_phone.dart';
import 'forgot_password_screen.dart';

class AdminProfile extends StatefulWidget {
  final String userID;
  //A constructor that requires the user ID to return to each user her home screen
  const AdminProfile({
    super.key,
    required this.userID,
  });

  @override
  State<AdminProfile> createState() => _AdminProfile();
}

class _AdminProfile extends State<AdminProfile> {
  String id = '';
  String email = '';
  String phoneNo = '';
  String firstName = '';
  String lastName = '';
  String fullName = '';

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('admin')
          .doc(widget
              .userID) // widget.userID is used because the var is defined outside the state class but under statefulwidget class
          .get();

      setState(() {
        id = userDoc.get('adminID');
        fullName = userDoc.get('fullName');
        phoneNo = userDoc.get('phoneNo');
        email = userDoc.get('Email');
      });
      debugPrint('$id$fullName$email');
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          centerTitle: true,
          title: const Text(
            'Profile Page',
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, top: 25, right: 25, bottom: 100),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 4), // changes position of shadow
                            ),
                          ],
                          color: const Color(0xfff8f8f8)),
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                        const SizedBox(
                          height: 30.0,
                        ),
                        const Icon(
                          Icons.account_circle_outlined,
                          color: Colors.blue,
                          size: 50,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Divider(
                          color: Colors.blue,
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          children: [
                            const Text(
                              '  Name :',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(' $fullName',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.blue, fontSize: 16))
                          ],
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          children: [
                            const Text('  ID :',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            Text(' $id',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.blue, fontSize: 16))
                          ],
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('  Email : ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            Text(' $email',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.blue, fontSize: 16)),
                            IconButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditEmail(userID: widget.userID)));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          children: [
                            const Text('  Phone Number :',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            Text(' $phoneNo',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.blue, fontSize: 16)),
                            IconButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditPhone(userID: widget.userID)));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 70,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen(),
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
                        ),
                      ]),
                    ),
                  ),
                ),
              ],
            )
          ]),
        ));
  }
}