import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'admin_home_page.dart';
import 'edit_bulding.dart';
import 'edit_category.dart';
import 'my_button2.dart';

class AdminEdit extends StatefulWidget {
  const AdminEdit({super.key});

  @override
  State<AdminEdit> createState() => _AdminEdit();
}

class _AdminEdit extends State<AdminEdit> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void cat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCategory(),
      ),
    );
  }

  void building() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBulding(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                User? user = _auth.currentUser;
                String uid = user!.uid;
                Navigator.pushReplacement(
                    //back button
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminHomePage(
                        userID: uid,
                      ),
                    ));
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, top: 210, right: 20, bottom: 20),
          child: Center(
            child: Column(
              children: [
                MyButton2(
                    color: Colors.blue,
                    title: "Add category",
                    onPressed: () {
                      cat();
                    }),
                MyButton2(
                    color: Colors.blue,
                    title: "Add Building Name",
                    onPressed: () {
                      building();
                    }),
              ],
            ),
          ),
        ));
  }
}
