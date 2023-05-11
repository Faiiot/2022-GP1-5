import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/constants/constants.dart';
import 'package:findly_admin/services/global_methods.dart';
import 'package:flutter/material.dart';

import '../announcement_detail_screen.dart';

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
  final String roomNumber;
  final String floorNumber;
  final bool reported;
  final int reportCount;
  final bool reportsScreen;

  // a constructor to get each announcement info
  const Announcement({
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
    required this.reportsScreen,
  });

  @override
  State<Announcement> createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
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
          .doc(widget.publisherID)
          // widget.publishedID is used because the var is defined outside the state class but under statefulWidget class
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
    return GestureDetector(
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
              profile: widget.profile,
              reported: widget.reported,
              reportCount: widget.reportCount,
              reportsScreen: widget.reportsScreen,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: widget.announcementImg != ""
                      ? Image.network(
                          widget.announcementImg,
                        )
                      : const Icon(
                          Icons.image,
                        ),
                ),
              ),
              const SizedBox(
                height: 2.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.itemName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 1.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.itemCategory,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: primaryColor.withOpacity(0.9),
                  ),
                ),
              ),
              const SizedBox(
                height: 1.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.postDate.toDate().day}/${widget.postDate.toDate().month}/${widget.postDate.toDate().year}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
