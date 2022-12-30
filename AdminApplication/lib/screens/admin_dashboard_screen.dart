
// import 'package:admin/adminProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/screens/lost_items_screen.dart';
import 'package:findly_admin/screens/widgets/drawer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'edit.dart';

class AdminDashboardScreen extends StatefulWidget {
  //static const String screenRoute = 'home_screen';
 final String userID;


  //a constuctor tat requires the user ID to return to each user her home screen
 const AdminDashboardScreen({required this.userID,});


  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreen();
}

class _AdminDashboardScreen extends State<AdminDashboardScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String firstName="";
  String lost = "lost";

  @override
  void initState() {
    super.initState();

    getUserName();
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
        print('--------------------------------'+firstName+'----------------------------------');
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
  @override
  Widget build(BuildContext context) {

   return Scaffold(
     drawer: DrawerWidget(userName: firstName,),
     appBar: AppBar(

       title: Text('Admin Dashboard'),
       leading: Builder(
         builder: (ctx){
           return IconButton(
             icon: Icon(Icons.menu),
             onPressed: (){
               Scaffold.of(ctx).openDrawer();
             },
           );
         },
       ),
     ),
     body:Column(
       children: [
         Expanded(child: Row(children: [
         Expanded(

           child: Padding(

             padding: const EdgeInsets.only(left: 20, top:20, right: 20, bottom: 0),
             child: Container(

               child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [Icon(Icons.done_all,color: Colors.blue,),SizedBox(height: 10.0,),Text(' Total Announcement ',style:TextStyle( fontWeight: FontWeight.w500,color: Colors.black) ,),
                 SizedBox(height: 20.0,),
                 Text('500',style:TextStyle( color: Colors.blue))
                 ],

               ),
             decoration:BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
               BoxShadow(
                 color: Colors.grey.withOpacity(0.3),
                 spreadRadius: 5,
                 blurRadius: 7,
                 offset: Offset(0, 4),// changes position of shadow
               ),],
                 color:Color(0xfff8f8f8)
             ) ,
             ),
           ),
         ),
           Expanded(
             child: Padding(
               padding: const EdgeInsets.only(left: 20, top:20, right: 20, bottom: 0),
               child: Container(

                 child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [Icon(Icons.settings_backup_restore_rounded,color: Colors.blue,),SizedBox(height: 10.0,),Text('Returned Item ',style:TextStyle( fontWeight: FontWeight.w500,color: Colors.black) ,),
                   SizedBox(height: 20.0,),
                   Text('200',style:TextStyle( color: Colors.blue))
                 ],

                 ),
                 decoration:BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
                   BoxShadow(
                     color: Colors.grey.withOpacity(0.3),
                     spreadRadius: 5,
                     blurRadius: 7,
                     offset: Offset(0, 4),// changes position of shadow
                   ),],
                     color:Color(0xfff8f8f8)
                 ) ,),
             ),
           ),


         ],
         )
         
         ),
         Expanded(child: Row(children: [

           Expanded(
             child: Padding(
               padding: const EdgeInsets.only(left: 20, top:20, right: 20, bottom: 2),
               child: Container(


                 child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [Icon(Icons.supervised_user_circle_sharp,color: Colors.blue,),SizedBox(height: 10.0,),Text('Findly Users',style:TextStyle( fontWeight: FontWeight.w500,color: Colors.black) ),
                   SizedBox(height: 20.0,),
                   Text('600',style:TextStyle( color: Colors.blue) )
                 ],

                 ),
                 decoration:BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
    BoxShadow(
    color: Colors.grey.withOpacity(0.3),
    spreadRadius: 5,
    blurRadius: 7,
    offset: Offset(0, 4),// changes position of shadow
    ),],
                     color:Color(0xfff8f8f8)
                 ) ,),
             ),
           ),


         ],
         )

         ),
         Expanded(child: Row(children: [
           Expanded(

             child: Padding(

               padding: const EdgeInsets.only(left: 20, top:18, right: 20, bottom: 0),
               child: Container(

                 child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [
                   MaterialButton(onPressed:(){Navigator.pushReplacement(
                     context, MaterialPageRoute(
                       builder: (context) => LostItemsScreen(userID: widget.userID)));},
                       child: Text(' Lost Announcement ',textAlign: TextAlign.center,style:TextStyle( color: Colors.black))),
                   SizedBox(height: 10.0,),
                   Text('200',style:TextStyle( color: Colors.blue))
                 ],

                 ),
                 decoration:BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
                   BoxShadow(
                     color: Colors.grey.withOpacity(0.3),
                     spreadRadius: 5,
                     blurRadius: 7,
                     offset: Offset(0, 4), // changes position of shadow
                   ),
                 ],
                     color:Color(0xfff8f8f8)
                 ) ,),
             ),
           ),
           Expanded(
             child: Padding(
               padding: const EdgeInsets.only(left: 20, top:18, right: 20, bottom: 0),
               child: Container(

                 child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [MaterialButton(onPressed:(){},child: Text('Found Announcement', textAlign: TextAlign.center,style:TextStyle( color: Colors.black))),
                   SizedBox(height: 10.0,),
                   Text('150',style:TextStyle( color: Colors.blue))
                 ],

                 ),
                 decoration:BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
                   BoxShadow(
                     color: Colors.grey.withOpacity(0.3),
                     spreadRadius: 5,
                     blurRadius: 7,
                     offset: Offset(0, 4),// changes position of shadow
                   ),
                 ],
                     color:Color(0xfff8f8f8)
                 ) ,),
             ),
           ),


         ],
         )

         ),

         Expanded(child: Row(children: [

           Expanded(
             child: Padding(
               padding: const EdgeInsets.all(20.0),
               child: Container(

                 child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [Icon(Icons.create,color: Colors.blue,),
                   MaterialButton(onPressed:() {
                   // Navigator.pushReplacement(
                   //     context, MaterialPageRoute(
                   //     builder: (context)=>adminProfilePage()));

                 },child:Text('Edit',style: TextStyle(
                       fontSize: 20),)),

                 ],

                 ),
                 decoration:BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
                   BoxShadow(
    color: Colors.grey.withOpacity(0.3),
    spreadRadius: 5,
    blurRadius: 7,
    offset: Offset(0, 4),)
                 ],
                     color:Color(0xfff8f8f8)
                 ) ,),
             ),
           ),


         ],
         )

         ),
       ],
     ) ,

   );
  }
}