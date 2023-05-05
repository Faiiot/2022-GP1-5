import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/constants/curved_app_bar.dart';
import 'package:findly_app/screens/announcement_detail_screen.dart';
import 'package:findly_app/screens/private_chat/private_chat_screen.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String itemName = "";
  String itemCategory = "";
  Timestamp postDate = Timestamp.fromDate(DateTime.now());
  String announcementImg = "";
  String buildingName = "";
  String contactChannel = "";
  String theChannel = "";
  String announcementDes = "";
  String roomNumber = "";
  String floorNumber = "";
  String publishedBy = "";
  String email = "";
  String phoneNumber = "";
  int reportCount = 0;
  bool reported = false;
  String firstName = "";
  String lastName = "";
  String fullName = "";

  Future<void> fetchAnnouncementDetails(
      String announcementID, String announcementType, String uid) async {
    final String collection =
        announcementType == "lost" ? "lostItem" : "foundItem";
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection(collection)
        .doc(announcementID)
        .get();

    final userDoc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (!mounted) return;
    setState(() {
      firstName = userDoc.get('firstName');
      lastName = userDoc.get('LastName');
      fullName = "$firstName $lastName";
      phoneNumber = userDoc.get('phoneNo');
      email = userDoc.get('Email');
      publishedBy = doc.get("publishedBy");
      itemName = doc.get("itemName");
      announcementType = doc.get("announcementType");
      itemCategory = doc.get("itemCategory");
      postDate = doc.get("annoucementDate");
      announcementImg = doc.get("url");
      buildingName = doc.get("buildingName");
      contactChannel = doc.get("contact");
      theChannel = contactChannel == "Phone Number" ? phoneNumber : email;
      announcementDes = doc.get("announcementDes");
      roomNumber = doc.get("roomnumber");
      floorNumber = doc.get("floornumber");
      reportCount = doc.get('reportCount');
      reported = doc.get('reported');
      print(fullName);
      print(phoneNumber);
      print(email);
    });
  }

  Future<void> updateNotification(String notificationID) async {
    await FirebaseFirestore.instance
        .collection("notifications")
        .doc(notificationID)
        .update({'is_seen': true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: CurvedAppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("notifications")
            .where("notify_to",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No notification found',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            List notifications = snapshot.data!.docs;
            notifications = GlobalMethods.sortNotification(notifications);
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: List.generate(
                    notifications.length ?? 0,
                    (index) => notifications[index]["is_seen"] == false
                        ? GestureDetector(
                            onTap: notifications[index]["type"] == "chat"
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PrivateChatScreen(
                                          notifications[index]["title"],
                                          notifications[index]["source_id"],
                                          peerId: notifications[index]
                                              ["notify_by"],
                                        ),
                                      ),
                                    );
                                    updateNotification(
                                        notifications[index]["notificationID"]);
                                  }
                                : () {
                                    fetchAnnouncementDetails(
                                        notifications[index]["source_id"],
                                        notifications[index]["type"],
                                        notifications[index]["notify_by"]);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AnnouncementDetailsScreen(
                                                announcementID:
                                                    notifications[index]
                                                        ["source_id"],
                                                publisherID:
                                                    notifications[index]
                                                        ["notify_by"],
                                                announcementType:
                                                    notifications[index]
                                                        ["type"],
                                                phoneNumber: phoneNumber,
                                                email: email,
                                                publishedBy: fullName,
                                                profile: false,
                                                reportCount: reportCount,
                                                reported: reported),
                                      ),
                                    );
                                    updateNotification(
                                        notifications[index]["notificationID"]);
                                  },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ListTile(
                                tileColor: primaryColor.withOpacity(0.25),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                leading: notifications[index]["type"] != "chat"
                                    ? const Icon(
                                        Icons.notifications_active_outlined,
                                        color: primaryColor,
                                        size: 36,
                                      )
                                    : const Icon(
                                        Icons.mark_chat_unread_outlined,
                                        color: primaryColor,
                                        size: 32,
                                      ),
                                title: Text(
                                  '${notifications[index]["title"]}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '${notifications[index]["message"]}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink()),
              ),
            );
          }
        },
      ),
    );
  }
}
