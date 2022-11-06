import 'package:findly_app/screens/login_screen.dart';
import 'package:findly_app/screens/registration_screen.dart';
import 'package:findly_app/screens/welcom_screen.dart';
import 'package:findly_app/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants/constants.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({
    required this.userName,
  });
  final String userName;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Flexible(
                    child: Image.network("https://www.iconsdb.com/icons/preview/white/contacts-xxl.png",)),
                SizedBox(height:20 ,),
                Flexible(
                  child: Text(
                     userName,
                    style:TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontStyle:FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              // borderRadius:BorderSide(BorderRadius.circular(15)), I want bottom angles to be circular
            ),
          ),
          SizedBox(height: 30,),
          _listTiles(
              label: "My announcements",
            icon:  Icons.history,
            fctn:  (){},
          ),
          _listTiles(
            label:"Profile",
            icon:  Icons.manage_accounts_rounded,
            fctn:  (){},
          ),
          _listTiles(
            label: "Use Guide",
            icon: Icons.question_mark_sharp,
            fctn: (){print(userName);},
          ),

          Divider(
            thickness: 1,
          ),
          _listTiles(
            label: "Log out",
            icon:  Icons.logout_outlined,
            fctn:  (){
              _logout(context);
            },
          ),


        ],
      ),
    );
  }
  void _logout (context){
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(context: context,
        builder: (context){
      return AlertDialog(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.logout_outlined,size: 30,color: Constants.darkBlue,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Log out",
              style: TextStyle(color: Constants.darkBlue,fontSize: 22, fontWeight: FontWeight.bold),),
            ),

          ],
        ),
        content: Text("Are you sure you want to log out?",maxLines: 2,
        style: TextStyle(color: Constants.darkBlue,fontSize: 20,fontStyle: FontStyle.italic),),
        actions: [
          TextButton(onPressed: (){
            Navigator.canPop(context)
                ?Navigator.pop(context)
                :null;
          }, child: Text("Cancel")),
          TextButton(onPressed: ()  async{
             await _auth.signOut();
            Navigator.canPop(context)?Navigator.pop(context):null;
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>UserState(), ));
             Fluttertoast.showToast(
                 msg: "You have been logged out successfully!",
                 toastLength: Toast.LENGTH_SHORT,
                 backgroundColor: Colors.blueGrey,
                 textColor: Colors.white,
                 fontSize: 16.0
             );
          }, child: Text("OK",style: TextStyle(color: Colors.red),))
        ],
      );
        });
  }
  Widget _listTiles ({required String label, required Function fctn, required IconData icon}){
    return ListTile(
        onTap: (){fctn();},
        leading:Icon(icon,color:Constants.darkBlue),
        title:Text(label,
          style: TextStyle(
            color: Constants.darkBlue,
            fontSize: 20,
            fontStyle: FontStyle.italic,
          ),
        ),
    );
  }
}
