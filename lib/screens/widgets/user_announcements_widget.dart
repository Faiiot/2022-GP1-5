import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/screens/announcement_detail_screen.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//Reusable announcement card widget code across the screens

class UserAnnouncement extends StatefulWidget {
  //dependency injection
  final String announcementID;


  // a constructor to get each announcement info
  const UserAnnouncement(
      {
        required this.announcementID,
      }
      );

  @override
  State<UserAnnouncement> createState() => _UserAnnouncementState();
}

class _UserAnnouncementState extends State<UserAnnouncement> {

final FirebaseAuth _auth = FirebaseAuth.instance;
String firstName ="";
String lastName ="";
String fullName ="";
String theChannel="";
//try
late final String itemName;
late final String announcementType;
late final String itemCategory;
late final Timestamp postDate;
late final String announcementImg;
late final String buildingName;
late final String contactChannel;
late final String publisherID;
late final String announcementDes;
bool _isLoading = false;

// a function to retrieve the user's first an last name to form her full name
// it also get the users phone number or email based on the contactChannel

  @override
  void initState() {

    super.initState();
    getAnnouncementInfo();


  }

Future<void> getAnnouncementInfo () async {
  final DocumentSnapshot announcement =
         await FirebaseFirestore
         .instance
         .collection('announcement')
         .doc(widget.announcementID)
         .get();
if(announcement==null){
  return;
}else{
     setState(() {
       itemName= announcement.get('itemName');
       announcementType = announcement.get('announcementType');
       itemCategory= announcement.get('itemCategory');
       postDate = announcement.get('annoucementDate');
       announcementImg= announcement.get('url');
       buildingName= announcement.get('buildingName');
       contactChannel= announcement.get('contact');
       publisherID = announcement.get('publishedBy');
       // i may delete this since it is her announcement
       announcementDes= announcement.get('announcementDes');
       print(announcementImg);
     });
}}

  //Method to retrieve the puplisher info
void getNeededPublisherInfo() async{
  try {
    _isLoading = true;

    final DocumentSnapshot userDoc =
    await FirebaseFirestore.instance
        .collection('users')
        .doc(publisherID)// widget.publishedID is used because the var is defined outside the state class but under statefulwidget class
        .get();

    if(userDoc == null){
      return;
    } else{

      setState(() {
        firstName = userDoc.get('firstName');
        lastName = userDoc.get('LastName');
        fullName = "$firstName $lastName";
        if (contactChannel == "Phone Number") {
          theChannel = userDoc.get('phoneNo');
        } else if (contactChannel == "Email") {
          theChannel = userDoc.get('Email');
        }
      });

    }
  }catch(error){
    print(error);
    GlobalMethods.showErrorDialog(error: error.toString(), context: context);
  }
}
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: (){

          Navigator.pushReplacement(
              context, MaterialPageRoute(

            //send this announcement info to the details screen
            builder: (context)=> AnnouncementDetailsScreen(
                announcementID: widget.announcementID,
                itemName: itemName,
                announcementType: announcementType,
                itemCategory: itemCategory,
                postDate: postDate,
                announcementImg: announcementImg,
                buildingName: buildingName,
                contactChannel:contactChannel,
                publishedBy: fullName,
                announcementDes: announcementDes,
                theChannel: theChannel,
            )
            ,)
          );
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        leading: Container(
          padding: EdgeInsets.only(right: 10,),

          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
              width: 2,
                color: Colors.grey

            )
            )
          ),
          child: announcementImg != ""
          ?
          Image.network(
            announcementImg,
            fit: BoxFit.fill ,
          )
          :
          Icon(Icons.image, size: 50,),
          width: 120,
          height: 120,
        ),
        title: Text(
          "Item: ${itemName}",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ) ,
        subtitle:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.linear_scale,
              color: Colors.blue.shade800,
            ),
            Text(
              "Type: ${announcementType}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
            ),),
            SizedBox(height: 8,),
            Text(
              "Category: ${itemCategory}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
              ),),
            SizedBox(height:8,),
            Text(
              "Date: ${postDate.toDate().day}/${postDate.toDate().month}/${postDate.toDate().year}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
              ),),
          ],
        ) ,
        trailing: Icon(
            Icons.keyboard_arrow_right,
        size: 30,
        color: Colors.blue.shade800,),
      ),
    );
  }
}
