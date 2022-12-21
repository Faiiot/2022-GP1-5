
import 'package:findly_app/screens/forgot_password_screen.dart';
import 'package:findly_app/screens/userProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'editEmail.dart';
import 'editphone.dart';
class userEdit extends StatefulWidget {

  final String userID;

  // a constuctor tat requires the user ID to return to each user her home screen
  const userEdit({required this.userID,});

  @override
  State<userEdit> createState() => _userEdit();
}
late String type;
late String Name;
final _eidtformkey = GlobalKey<FormState>();
var dropsownValue="";
class _userEdit extends State<userEdit> {
  @override



  // void cat(){
  //
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(
  //       builder: (context)=>userEdit(userID: widget.userID)
  //   ));
  //
  // }
  // void building(){
  //
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(
  //       builder: (context)=>userEdit(userID: widget.userID)
  //   ));
  //
  // }

  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(centerTitle: true,
          title: Text(
            'Edit Profile ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),leading: IconButton(
            onPressed: (){

              Navigator.pushReplacement(//back button
                  context, MaterialPageRoute(
                builder: (context)=>userProfilePage(userID: widget.userID))
              );
            },
            icon:Icon(Icons.arrow_back_ios)
        )
          ,),
        body: Padding(  padding: const EdgeInsets.only(left: 10,top: 150,right: 10,bottom: 30),child: Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>editEmail(userID: widget.userID)
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
                      Icon(Icons.mail_outline_rounded, color: Colors.white,size: 30,),
                      SizedBox(height: 10,),
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
              SizedBox(height: 10,),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>editPhone(userID: widget.userID)
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
                        Icon(Icons.phone_android, color: Colors.white,size: 30,),
                        SizedBox(height: 10,),
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
              SizedBox(height: 10,),
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
              )],
            )




        ),)
    );}}

