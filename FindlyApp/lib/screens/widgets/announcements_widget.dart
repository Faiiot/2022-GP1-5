import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/screens/announcement_detail_screen.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//Reusable announcement card widget code across the screens

class Announcement extends StatefulWidget {
  //dependency injection
  final String announcementID;
  final String itemName;
  final String announcementType;
  final String itemCategory;
  final Timestamp postDate;
  final String announcementImg;
  final String buildingName;
  final String contactChannel;
  final String publisherID;
  final String announcementDes;
  final bool profile;
  final String roomnumber;
  final String floornumber;
  final bool reported;
  final int reportCount;

  // a constructor to get each announcement info
  const Announcement({
    required this.announcementID,
    required this.itemName,
    required this.announcementType,
    required this.itemCategory,
    required this.postDate,
    required this.announcementImg,
    required this.buildingName,
    required this.contactChannel,
    required this.publisherID,
    required this.announcementDes,
    required this.profile,
    required this.roomnumber,
    required this.floornumber,
    required this.reported,
    required this.reportCount,
  });

  @override
  State<Announcement> createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String firstName = "";
  String lastName = "";
  String fullName = "";
  String theChannel = "";
  bool _isLoading = false;

// a function to retrieve the user's first an last name to form her full name
// it also get the users phone number or email based on the contactChannel

  @override
  void initState() {
    super.initState();
    getNeededPublisherInfo();
  }

  //Method to retrieve the puplisher info
  void getNeededPublisherInfo() async {
    try {
      _isLoading = true;

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget
          .publisherID) // widget.publishedID is used because the var is defined outside the state class but under statefulwidget class
          .get();

      if (userDoc == null) {
        return;
      } else {
        if (!mounted) return;
        setState(() {
          firstName = userDoc.get('firstName');
          lastName = userDoc.get('LastName');
          fullName = "$firstName $lastName";
          if (widget.contactChannel == "Phone Number") {
            theChannel = userDoc.get('phoneNo');
          } else if (widget.contactChannel == "Email") {
            theChannel = userDoc.get('Email');
          }
        });
      }
    } catch (error) {
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
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                //send this announcement info to the details screen
                builder: (context) => AnnouncementDetailsScreen(
                  announcementID: widget.announcementID,
                  publisherID: widget.publisherID,
                  itemName: widget.itemName,
                  announcementType: widget.announcementType,
                  itemCategory: widget.itemCategory,
                  postDate: widget.postDate,
                  announcementImg: widget.announcementImg,
                  buildingName: widget.buildingName,
                  contactChannel: widget.contactChannel,
                  publishedBy: fullName,
                  announcementDes: widget.announcementDes,
                  theChannel: theChannel,
                  profile: false,
                  reported: widget.reported,
                  reportCount: widget.reportCount,
                  roomNumber: widget.roomnumber,
                  floorNumber: widget.floornumber,
                ),
              ));
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        leading: Container(
          padding: EdgeInsets.only(
            right: 10,
          ),
          decoration: BoxDecoration(border: Border(right: BorderSide(width: 2, color: Colors.grey))),
          child: widget.announcementImg != ""
              ? Image.network(
            widget.announcementImg,
            fit: BoxFit.fill,
          )
              : Icon(
            Icons.image,
            size: 50,
          ),
          width: 120,
          height: 120,
        ),
        title: Text(
          "Item: ${widget.itemName}",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.linear_scale,
              color: Colors.blue.shade800,
            ),

            SizedBox(
              height: 8,
            ),
            Text(
              "Category: ${widget.itemCategory}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Date: ${widget.postDate.toDate().day}/${widget.postDate.toDate().month}/${widget.postDate.toDate().year}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.blue.shade800,
        ),
      ),
    );
  }
}
