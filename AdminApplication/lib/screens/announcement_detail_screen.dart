import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/screens/reported_announcement.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/constants.dart';

class AnnouncementDetailsScreen extends StatefulWidget {
  final String announcementID;
  final String publisherID;
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
  final String roomNumber;
  final String floorNumber;
  final bool reported;
  final int reportCount;

  //constructor to require the announcement's information
  const AnnouncementDetailsScreen({
    super.key,
    required this.announcementID,
    required this.publisherID,
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
    required this.reportCount,
    required this.reported,
    required this.roomNumber,
    required this.floorNumber,
  });

  @override
  State<AnnouncementDetailsScreen> createState() => _AnnouncementDetailsScreenState();
}

class _AnnouncementDetailsScreenState extends State<AnnouncementDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool sameUser() {
    return widget.publisherID == _auth.currentUser!.uid.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (widget.profile) {
                Navigator.pop(context);
              } else if (widget.announcementType == 'lost') {
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: const Text(
          'Announcement Details',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: widget.announcementImg != ""
                      ? Image.network(
                          widget.announcementImg,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.image,
                                size: 120,
                                color: Colors.grey,
                              ),
                              Text(
                                "No image was uploaded",
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        )),
            ),
            const SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration:
                    BoxDecoration(color: Colors.blue[400], borderRadius: BorderRadius.circular(20)),
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    //announcement type
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Announcement type:  ${widget.announcementType}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    //item name
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Item name:  ${widget.itemName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    //item category
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Item category:  ${widget.itemCategory}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    //building name
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Location:\n   Building: ${widget.buildingName}\n   Floor: ${widget.floorNumber}\n   Room: ${widget.roomNumber}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    //description
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: const Text(
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
                            color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.announcementDes,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Constants.darkBlue,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    //publisher Name
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Published by:  ${widget.publishedBy}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    //another contact channel based on the user's choice
                    widget.contactChannel == "Phone Number"
                        ? Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Phone number:  ${widget.theChannel} ',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Email:  ${widget.theChannel}',
                              style: const TextStyle(
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
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: InkWell(
                    onTap: () {
                      _delete(context);
                    },
                    child: SizedBox(
                      height: 100,
                      child: Card(
                        elevation: 7,
                        color: const Color(0xfff8f8f8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: InkWell(
                    onTap: () {
                      _decline(context);
                    },
                    child: SizedBox(
                      height: 100,
                      child: Card(
                        elevation: 7,
                        color: const Color(0xfff8f8f8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Decline',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _delete(context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete,
                    size: 30,
                    color: Constants.darkBlue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Delete Announcement",
                    style: TextStyle(
                        color: Constants.darkBlue, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            //Log out confirmation message
            content: Text(
              "Are you sure you want to delete ${widget.itemName} ?",
              maxLines: 2,
              style:
                  TextStyle(color: Constants.darkBlue, fontSize: 20, fontStyle: FontStyle.italic),
            ),
            actions: [
              //Cancel button > back to the drawer
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    //if the user click "OK" she will be logged out and redirected to log in screen
                    if (widget.announcementType == 'lost') {
                      await FirebaseFirestore.instance
                          .collection('lostItem')
                          .doc(widget.announcementID)
                          .delete();
                      await FirebaseFirestore.instance
                          .collection('reportedItem')
                          .doc(widget.announcementID)
                          .delete();
                    } else {
                      await FirebaseFirestore.instance
                          .collection('foundItem')
                          .doc(widget.announcementID)
                          .delete();
                      await FirebaseFirestore.instance
                          .collection('reportedItem')
                          .doc(widget.announcementID)
                          .delete();
                    }
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  Future<void> _decline(context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete,
                    size: 30,
                    color: Constants.darkBlue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Decline Announcement",
                    style: TextStyle(
                        color: Constants.darkBlue, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            //Log out confirmation message
            content: Text(
              "Are you sure you want to decline ${widget.itemName} ?",
              maxLines: 2,
              style:
                  TextStyle(color: Constants.darkBlue, fontSize: 20, fontStyle: FontStyle.italic),
            ),
            actions: [
              //Cancel button > back to the drawer
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    //if the user click "OK" she will be logged out and redirected to log in screen

                    declineProcess();
                    Fluttertoast.showToast(
                      msg: "Announcement has been declined successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.blueGrey,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportedAnnouncement(userID: widget.publishedBy),
                        ));
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  void declineProcess() async {
    if (widget.announcementType == 'lost') {
      await FirebaseFirestore.instance
          .collection('reportedItem')
          .doc(widget.announcementID)
          .delete();
      await FirebaseFirestore.instance.collection('lostItem').doc(widget.announcementID).update({
        'reported': false,
        'reportCount': 0,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('reportedItem')
          .doc(widget.announcementID)
          .delete();
      await FirebaseFirestore.instance.collection('foundItem').doc(widget.announcementID).update({
        'reported': false,
        'reportCount': 0,
      });
    }
  }
}
