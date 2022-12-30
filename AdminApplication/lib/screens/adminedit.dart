
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:findly_admin/screens/adminProfilePage.dart';
// import 'package:findly_admin/screens/adminedit.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'editbulding.dart';
import 'editcategory.dart';
import 'my_button2.dart';
import 'adimhomepage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class adminedit extends StatefulWidget {


  @override
  State<adminedit> createState() => _adminedit();
}
late String type;
late String Name;
final _eidtformkey = GlobalKey<FormState>();
var dropsownValue="";
class _adminedit extends State<adminedit> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override



  void cat(){

    Navigator.pushReplacement(
        context, MaterialPageRoute(
        builder: (context)=>editcategory()
    ));

  }
  void building(){

    Navigator.pushReplacement(
        context, MaterialPageRoute(
        builder: (context)=>editbulding()
    ));

  }

  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(leading: IconButton(
            onPressed: (){
              User? user = _auth.currentUser;
              String _uid = user!.uid;
              Navigator.pushReplacement(//back button
                  context, MaterialPageRoute(
                builder: (context)=>adminhomepage(userID:_uid ,)
                ,)
              );
            },
            icon:Icon(Icons.arrow_back_ios)
        )
          ,),
        body: Padding(  padding: const EdgeInsets.only(left:20,top: 210,right: 20,bottom: 20),child: Center(
          child: Column(children: [MyButton2(
              color: Colors.blue,
              title: "Add catgory",
              onPressed: (){
               cat();
              }),

            MyButton2(
                color: Colors.blue,
                title: "Add Bulding Name",
                onPressed: (){
building();

                }),

          ],),





        ),)
    );}}

