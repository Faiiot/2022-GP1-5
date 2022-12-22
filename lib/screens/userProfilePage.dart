import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/constants/constants.dart';
import 'package:findly_app/screens/editEmail.dart';
import 'package:findly_app/screens/editphone.dart';
import 'package:findly_app/screens/forgot_password_screen.dart';
import 'package:findly_app/screens/userEidt.dart';
import 'package:findly_app/screens/widgets/my_button.dart';
import 'package:findly_app/screens/user_dasboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'editProfile.dart';

class userProfilePage extends StatefulWidget {

  final String userID;

  // a constuctor tat requires the user ID to return to each user her home screen
  const userProfilePage({required this.userID,});

  @override
  State<userProfilePage> createState() => _userProfilePage();
}

class _userProfilePage extends State<userProfilePage> {

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
    getUserInfo();
  }
  void getUserInfo() async {
    _isLoading = true;
    try {

      final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID) // widget.userID is used because the var is defined outside the state class but under statefulwidget class
          .get();

      if (userDoc == null) {
        return;
      } else {
        setState(() {
          ID = userDoc.get('memberID');
          FirstName = userDoc.get('firstName');
          LastName = userDoc.get('LastName');
          FullName = FirstName+' '+LastName;
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
                        builder: (context) => UserDashboardScreen(userID: widget.userID,),
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
                                      color: Colors.blue, fontSize: 16)),
                              SizedBox(width: 8,),
                              IconButton(
                                  onPressed: (){
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                editEmail(userID: widget.userID)));
                                  },
                                  icon: Icon(Icons.edit, color: Colors.blue,))
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
                                      color: Colors.blue, fontSize: 16)),
                              SizedBox(width: 8,),
                              IconButton(
                                  onPressed: (){
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                editPhone(userID: widget.userID)));
                                  },
                                  icon: Icon(Icons.edit, color: Colors.blue,))
                            ],
                          ),
                          SizedBox(height: 70,),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context)=>ForgotPasswordScreen()
                                ,)
                              );
                            },
                            child: Container(
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
                                  children: [
                                    Icon(Icons.lock_reset, color: Colors.white,size: 30,),
                                    SizedBox(height: 10,),
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
                          // MyButton(
                          //     color: Colors.blue,
                          //     title: 'Edit profile',
                          //     onPressed: (){
                          //       Navigator.pushReplacement(
                          //           context,
                          //           MaterialPageRoute(
                          //           builder: (context) =>
                          //           userEdit(userID: widget.userID)));
                          //
                          //     }),
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

