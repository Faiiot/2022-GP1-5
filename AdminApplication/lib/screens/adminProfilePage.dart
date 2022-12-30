import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/constants/constants.dart';
import 'package:findly_admin/screens/adimhomepage.dart';
import 'package:findly_admin/screens/widgets/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'editProfile.dart';

class adminProfilePage extends StatefulWidget {

  final String userID;

  // a constuctor tat requires the user ID to return to each user her home screen
  const adminProfilePage({required this.userID,});

  @override
  State<adminProfilePage> createState() => _adminProfilePage();
}

class _adminProfilePage extends State<adminProfilePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
   String FirstName ='';
   String LastName='';
   String ID='';
   String email='';
   String phoneNo='';
   String FullName='';

  @override
  void initState() {

    super.initState();
    getAdminInfo();
  }
  void getAdminInfo() async {
    _isLoading = true;
    try {
      print(widget.userID);
      final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance
          .collection('admin')
          .doc(widget.userID) // widget.userID is used because the var is defined outside the state class but under statefulwidget class
          .get();

      if (userDoc == null) {
        return;
      } else {
        setState(() {
          ID = userDoc.get('adminID');
          FullName = userDoc.get('fullName');
          phoneNo = userDoc.get('phoneNo');
          email = userDoc.get('Email');

        });
        print(ID+''+FullName+''+email);
      }
    }catch(error){
        print(error);
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      //back button
                      context,
                      MaterialPageRoute(
                        builder: (context) => adminhomepage(userID: widget.userID,),
                      ));
                },
                icon: Icon(Icons.arrow_back_ios))
         ,  centerTitle: true,title: Text('Profile Page',) ),

        body: Column(children: [
          Expanded(
              child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 25, top: 25, right: 25, bottom: 100),
                  child: Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30.0,
                          ),
                          Icon(
                            Icons.account_circle_outlined,
                            color: Colors.blue,
                            size: 50,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Divider(
                            color: Colors.blue,
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Row(
                            children: [
                              Text(
                                '  Name :',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              Text(' '+FullName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 16))
                            ],
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Row(
                            children: [
                              Text('  ID :',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text(' '+ID,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 16))
                            ],
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Row(
                            children: [
                              Text('  Email : ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text(' '+email,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 16))
                            ],
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Row(
                            children: [
                              Text('  Phone Number :',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text(' '+phoneNo,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 16))
                            ],
                          ),
                          SizedBox(height: 70,),
                          // Expanded(
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(
                          //         left: 100, top: 80, right: 100, bottom: 150),
                          //     child: Container(
                          //       child: Column(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Flexible(
                          //             child: MaterialButton(
                          //
                          //                 onPressed: () {
                          //                   Navigator.pushReplacement(
                          //                       context,
                          //                       MaterialPageRoute(
                          //                           builder: (context) =>
                          //                               editProfile()));
                          //                 },
                          //                 child: Text(
                          //                   'Edit Profile',
                          //                   style: TextStyle(
                          //                     color: Colors.white,
                          //                     fontSize: 20,
                          //                   ),
                          //                   textAlign: TextAlign.center,
                          //                 )),
                          //           ),
                          //         ],
                          //       ),
                          //       decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(10.0),
                          //           boxShadow: [
                          //             BoxShadow(
                          //               color: Colors.grey.withOpacity(0.3),
                          //               spreadRadius: 5,
                          //               blurRadius: 7,
                          //               offset: Offset(0, 4),
                          //             )
                          //           ],
                          //           color: Colors.blue),
                          //     ),
                          //   ),
                          // ),
                          MyButton(
                              color: Colors.blue,
                              title: 'Edit profile',
                              onPressed: (){
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    editProfile()));
                              })
                        ]),
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
          ))
        ]));
  }
}

