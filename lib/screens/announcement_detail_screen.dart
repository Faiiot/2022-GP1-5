import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/constants/constants.dart';
import 'package:findly_app/screens/found_items_screen.dart';
import 'package:findly_app/screens/lost_items_screen.dart';
import 'package:findly_app/screens/user_announcements_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AnnouncementDetailsScreen extends StatefulWidget {
  final String announcementID;
  final String itemName;
  final String announcementType;
  final String itemCategory;
  final Timestamp postDate;
  final String announcementImg;
  final String buildingName;
  final String contactChannel;
  final String theChannel;
  final String publishedBy;
  final String announcementDes;
  final bool profile;


  //constructor to require the announcement's information
  const AnnouncementDetailsScreen({
    required this.announcementID,
    required this.itemName,
    required this.announcementType,
    required this.itemCategory,
    required this.postDate,
    required this.announcementImg,
    required this.buildingName,
    required this.contactChannel,
    required this.theChannel,
    required this.publishedBy,
    required this.announcementDes,
    required this.profile,

});

  @override
  State<AnnouncementDetailsScreen> createState() => _AnnouncementDetailsScreenState();
}

class _AnnouncementDetailsScreenState extends State<AnnouncementDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              User? user = _auth.currentUser;
              String _uid = user!.uid;

              if(widget.profile){
                Navigator.pushReplacement(//back button
                    context, MaterialPageRoute(
                  builder: (context)=>UserAnnouncementsScreen(userID: _uid,type: widget.announcementType,)
                  ,)
                );
              }
              else if(widget.announcementType == 'lost'){
              Navigator.pushReplacement(//back button
                  context, MaterialPageRoute(
                builder: (context)=>LostItemsScreen(userID: _uid)
                ,)
              );
              }else{
                Navigator.pushReplacement(//back button
                    context, MaterialPageRoute(
                  builder: (context)=>FoundItemsScreen(userID: _uid)
                  ,)
                );
              }

            },
            icon:Icon(Icons.arrow_back_ios)
        ),
        title: Text('Announcement Details',),
        actions: [
          widget.profile?
        IconButton(onPressed: (){_delete(context);}, icon: Icon(Icons.delete_forever,size: 30,)):Text(widget.profile.toString())],
      ),
      body:SingleChildScrollView(
        child: Column(

          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 300,
                width: double.infinity,
                child:
                widget.announcementImg != ""
                ?
                Image.network(
                  widget.announcementImg,
                )
                :
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Icon(Icons.image, size: 120, color: Colors.grey,),
                      Text("No image was uploaded", style: TextStyle(fontSize: 18),)
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                )
              ),
            ),
            SizedBox(height: 14,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.blue[400],borderRadius: BorderRadius.circular(20)),
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    //announcement type
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Announcement type:  ${widget.announcementType}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    //item name
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Item name:  ${widget.itemName}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    //item category
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Item category:  ${widget.itemCategory}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    //building name
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Building Name:  ${widget.buildingName}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    //description
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Description: ',

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        child: Text(widget.announcementDes,
                          textAlign: TextAlign.start,style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Constants.darkBlue,
                            fontStyle: FontStyle.italic,
                          ),),
                      ),
                    ),
                    //publisher Name
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Text(

                        'Published by:  ${widget.publishedBy}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    //another contact channel based on the user's choice
                    widget.contactChannel == "Phone Number"
                        ?
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,


                      child: Text(
                        'Phone number:  ${widget.theChannel} ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                        :
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Email:  ${widget.theChannel}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),



    );
  }
  void _delete(context){

    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.delete,size: 30,color: Constants.darkBlue,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Delete Announcement",
                    style: TextStyle(color: Constants.darkBlue,fontSize: 22, fontWeight: FontWeight.bold),),
                ),

              ],
            ),


            //Delete confirmation message
            content: Text("Are you sure you want to delete ?",maxLines: 2,
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
                if(widget.announcementType=='lost') {
                  final DocumentSnapshot Doc = await FirebaseFirestore.instance.collection('lostItem').doc(widget.announcementID).get();
                  final found = Doc.get('found');
                  if(found) {
                    await FirebaseFirestore.instance.collection('lostItem').doc(
                        widget.announcementID).delete();
                  }else{

                  }
                }
                else{ await FirebaseFirestore.instance.collection('foundItem').doc(
                    widget.announcementID).delete();}

                Fluttertoast.showToast(
                  msg: "Announcement has been deleted successfully!",
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.blueGrey,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                if(widget.announcementType == 'lost'){
                  Navigator.pushReplacement(//back button
                      context, MaterialPageRoute(
                    builder: (context)=>UserAnnouncementsScreen(userID: widget.publishedBy,type: "lost",)
                    ,)
                  );
                }else{
                  Navigator.pushReplacement(//back button
                      context, MaterialPageRoute(
                    builder: (context)=>UserAnnouncementsScreen(userID:  widget.publishedBy,type: "found",)
                    ,)

                  );
                }
              }, child: Text("OK",style: TextStyle(color: Colors.red),))
            ],
          );
        });
  }
}
