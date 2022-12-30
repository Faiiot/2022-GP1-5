import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/constants/constants.dart';
import 'package:findly_admin/screens/adminProfilePage.dart';
import 'package:findly_admin/screens/adminedit.dart';
import 'package:findly_admin/screens/found_items_screen.dart';
import 'package:findly_admin/screens/lost_items_screen.dart';
import 'package:findly_admin/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'editcategory.dart';

class adminhomepage extends StatefulWidget {
  //static const String screenRoute = 'home_screen';
  final String userID;

  //a constuctor tat requires the user ID to return to each user her home screen
  const adminhomepage({
    required this.userID,
  });

  @override
  State<adminhomepage> createState() => _adminhomepage();
}

class _adminhomepage extends State<adminhomepage> {
String lost = '';
late int productCount;


Future<void> getFoundCount() async {
  QuerySnapshot productCollection = await
  FirebaseFirestore.instance.collection('foundItem').get();
  productCount = productCollection.size;

  print(productCount);
}
Future<int> getCount() async {
  int count = await FirebaseFirestore.instance
      .collection('lostItem')
      .get()
      .then((value) => value.size);
  int f = count;
  print(count);
  print(f);
  return f;
}
// Future<void> getLostCount()async {
//   QuerySnapshot lostCollection = await
//   FirebaseFirestore.instance.collection('lostItem').get();
//   productCount = productCount + lostCollection.size;
// }
  @override
  void initState() {
    super.initState();
    getFoundCount();
    // getLostCount();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Admin DashBoard'),
      ),
      body: Column(
        children: [
          Expanded(
              child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 20, right: 20, bottom: 0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.done_all,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          ' Total Announcement ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text("100", style: TextStyle(color: Colors.blue))
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                        color: Color(0xfff8f8f8)),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 20, right: 20, bottom: 0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings_backup_restore_rounded,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Returned Item ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text('200', style: TextStyle(color: Colors.blue))
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                        color: Color(0xfff8f8f8)),
                  ),
                ),
              ),
            ],
          )),
          Expanded(
              child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 20, right: 20, bottom: 2),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.supervised_user_circle_sharp,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text('Findly Users',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text('600', style: TextStyle(color: Colors.blue))
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                        color: Color(0xfff8f8f8)),
                  ),
                ),
              ),
            ],
          )),
          Expanded(
              child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 18, right: 20, bottom: 0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context)=> LostItemsScreen(userID: widget.userID))
                              );
                            },
                            child: Text(' Lost Announcement ',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black))),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text('200', style: TextStyle(color: Colors.blue))
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                        color: Color(0xfff8f8f8)),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 18, right: 20, bottom: 0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context)=> FoundItemsScreen(userID: widget.userID))
                              );
                            },
                            child: Text('Found Announcement',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black))),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text('150', style: TextStyle(color: Colors.blue))
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                        color: Color(0xfff8f8f8)),
                  ),
                ),
              ),
            ],
          )),
          Expanded(
              child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 20, right: 20, bottom: 2),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.create,
                          color: Colors.blue,
                        ),
                        MaterialButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => adminedit()));
                            },
                            child: Text(
                              'Edit',
                              style: TextStyle(fontSize: 20),
                            )),
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 4),
                          )
                        ],
                        color: Color(0xfff8f8f8)),
                  ),
                ),
              ),
            ],
          )),
          Expanded(
              child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 18, right: 20, bottom: 2),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.report_outlined,
                          color: Colors.blue,
                        ),
                        MaterialButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => editcategory()));
                            },
                            child: Text(
                              'Reported Announcement ',
                              style: TextStyle(fontSize: 20),
                            )),
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 4),
                          )
                        ],
                        color: Color(0xfff8f8f8)),
                  ),
                ),
              ),
            ],
          )),
          Expanded(
              child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 10, right: 20, bottom: 12),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        MaterialButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => adminProfilePage(
                                            userID: widget.userID,
                                          )));
                            },
                            child: Text('Profile Page',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black))),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                        color: Color(0xfff8f8f8)),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 10, right: 20, bottom: 12),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        MaterialButton(
                            onPressed: () {
                              _logout(context);
                            },
                            child: Text('Log out',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black))),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                        color: Color(0xfff8f8f8)),
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout_outlined,
                    size: 30,
                    color: Constants.darkBlue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Log out",
                    style: TextStyle(
                        color: Constants.darkBlue,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            //Log out confirmation message
            content: Text(
              "Are you sure you want to log out?",
              maxLines: 2,
              style: TextStyle(
                  color: Constants.darkBlue,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
            actions: [
              //Cancel button > back to the drawer
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    //if the user click "OK" she will be logged out and redurected to log in screen
                    await _auth.signOut();
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => UserState(),
                    ));
                    Fluttertoast.showToast(
                        msg: "You have been logged out successfully!",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }
}
