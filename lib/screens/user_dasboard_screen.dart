import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/constants/constants.dart';
import 'package:findly_app/screens/add_announcement.dart';
import 'package:findly_app/screens/found_items_screen.dart';
import 'package:findly_app/screens/lost_items_screen.dart';
import 'package:findly_app/screens/userProfilePage.dart';
import 'package:findly_app/screens/user_announcements_screen.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:findly_app/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserDashboardScreen extends StatefulWidget {

  final String userID;



  const UserDashboardScreen({required this.userID,});
  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String firstName="";
  bool _isLoading = false;
  String userCount = '';
  String type = '';

  @override
  void initState() {
    super.initState();
    getUserName();
    getUsersCount();
  }

  void getUserName() async{
    _isLoading = true;

    try {//Here we will fetch the users First name from the DB
      final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)// widget.userID is used because the var is defined outside the state class but under statefulwidget class
          .get();

      if(userDoc == null){
        return;
      } else{

        setState(() {
          firstName = userDoc.get('firstName');


        });
        User? user = _auth.currentUser;
        String _uid = user!.uid;

      }
    }catch(error){
      print(error);
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

    getUsersCount() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final int documents = await users.snapshots().length;
    userCount = documents.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Results',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          height: 100,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 7,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xfff8f8f8),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 15,vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Current User',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14),
                                    ),
                                    Spacer(),
                                    Text(
                                      userCount,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          height: 100,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 7,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color(0xfff8f8f8)
                              ),
                              child: Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 15,vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Returned items',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14),
                                    ),
                                    Spacer(),
                                    Text(
                                      '20',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(
                              builder: (context)=>LostItemsScreen(userID: widget.userID)));
                        },
                        child: Container(
                          height: 100,
                          child: Card(
                            elevation: 7,
                            color: Color(0xfff8f8f8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Lost',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  '10',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(
                              builder: (context)=>FoundItemsScreen(userID: widget.userID)));
                        },
                        child: Container(
                          height: 100,
                          child: Card(
                            elevation: 7,
                            color: Color(0xfff8f8f8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Found',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  '10',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),



                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(
                              builder: (context)=>userProfilePage(userID: widget.userID)));
                        },
                        child: Container(
                          height: 100,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 7,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xfff8f8f8),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 15,vertical: 12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.person,color: Colors.blue,size: 35,),
                                    SizedBox(height: 8,),
                                    Text(
                                      'Profile',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          height: 100,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 7,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color(0xfff8f8f8)
                              ),
                              child: Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 15,vertical: 12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.adb,color: Colors.blue,size: 35,),
                                    SizedBox(height: 8,),
                                    Text(
                                      'Chatbot',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: (){
                 showDialog(
                 context: context,
                 builder: (context)=> AlertDialog(
                      elevation: 7,
                      title: Row(
                        children: [
                          Padding(padding: const EdgeInsets.all(8.0),
                            child:Icon(FontAwesomeIcons.handPointer, color: Colors.blue,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Announcements type"),
                          ),
                        ],
                      ),
                      content: Text(
                        "Select announcement type",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: (){
                                setState(() {
                                  type = 'Lost';
                                });
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(
                                    builder: (context)=>UserAnnouncementsScreen(userID: widget.userID, type: type,)));
                              },
                              color: Colors.blue,
                              child: Text(
                                "Lost",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width:10,),
                            MaterialButton(
                              onPressed: (){
                                setState(() {
                                  type = 'Found';
                                });
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(
                                    builder: (context)=>UserAnnouncementsScreen(userID: widget.userID, type: type,)));
                              },
                              color:Colors.blue,
                              child: Text(
                                "Found",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],

                    ));

                  },
                  child: Card(
                    elevation: 7,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:Color(0xfff8f8f8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'My Announcements',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(width: 20,),
                          Icon(Icons.post_add_rounded,size:35,color: Colors.blue,),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                InkWell(
                  onTap: (){
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(
                      builder: (context)=> AddAnnouncementScreen()
                      ,)
                    );

                  },
                  child: Card(
                    elevation: 7,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:Color(0xfff8f8f8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Add Announcements',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(width: 20,),
                          Icon(Icons.add_circle_outline_rounded,size:35,color: Colors.blue,),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                InkWell(
                  onTap: ()=>_logout(context),
                  child: Card(
                    elevation: 7,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(width: 20,),
                            Icon( Icons.logout_outlined, size:35, color: Colors.white,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
            
            
            //Log out confirmation message
            content: Text("Are you sure you want to log out?",maxLines: 2,
              style: TextStyle(color: Constants.darkBlue,fontSize: 20,fontStyle: FontStyle.italic),),
            actions: [
              //Cancel button > back to the drawer
              TextButton(onPressed: (){
                Navigator.canPop(context)
                    ?Navigator.pop(context)
                    :null;
              }, child: Text("Cancel")),
              TextButton(onPressed: ()  async{
                //if the user click "OK" she will be logged out and redurected to log in screen
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
}
