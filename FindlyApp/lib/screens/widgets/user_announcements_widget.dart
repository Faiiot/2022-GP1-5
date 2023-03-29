import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/screens/announcement_detail_screen.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:flutter/material.dart';

//Reusable announcement card widget code across the screens

class UserAnnouncement extends StatefulWidget {
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
  final String roomNumber;
  final String floorNumber;
  final bool reported;
  final int reportCount;

  // a constructor to get each announcement info
  const UserAnnouncement({
    super.key,
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
    required this.roomNumber,
    required this.floorNumber,
    required this.reported,
    required this.reportCount,
  });

  @override
  State<UserAnnouncement> createState() => _UserAnnouncementState();
}

class _UserAnnouncementState extends State<UserAnnouncement> {
  String firstName = "";
  String lastName = "";
  String fullName = "";
  String phoneNumber = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    getNeededPublisherInfo();
  }

  //Method to retrieve the publisher info
  void getNeededPublisherInfo() async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget
              .publisherID) // widget.publishedID is used because the var is defined outside the state class but under statefulwidget class
          .get();

      if (!mounted) return;
      setState(() {
        firstName = userDoc.get('firstName');
        lastName = userDoc.get('LastName');
        fullName = "$firstName $lastName";
        phoneNumber = userDoc.get('phoneNo');
        email = userDoc.get('Email');
      });
    } catch (error) {
      debugPrint(error.toString());
      GlobalMethods.showErrorDialog(error: error.toString(), context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                //send this announcement info to the details screen
                builder: (context) => AnnouncementDetailsScreen(
                  announcementID: widget.announcementID,
                  publisherID: widget.publisherID,
                  announcementType: widget.announcementType,
                  publishedBy: fullName,
                  phoneNumber: phoneNumber,
                  email: email,
                  profile: true,
                  reported: widget.reported,
                  reportCount: widget.reportCount,
                ),
              ));
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        leading: Container(
          padding: const EdgeInsets.only(
            right: 10,
          ),
          decoration:
              const BoxDecoration(border: Border(right: BorderSide(width: 2, color: Colors.grey))),
          width: 120,
          height: 120,
          child: widget.announcementImg != ""
              ? Image.network(
                  widget.announcementImg,
                  fit: BoxFit.fill,
                )
              : const Icon(
                  Icons.image,
                  size: 50,
                ),
        ),
        title: Text(
          "Item: ${widget.itemName}",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.linear_scale,
              color: Colors.blue.shade800,
            ),
            Text(
              "Category: ${widget.itemCategory}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Date: ${widget.postDate.toDate().day}/${widget.postDate.toDate().month}/${widget.postDate.toDate().year}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
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
