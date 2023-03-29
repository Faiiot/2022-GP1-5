import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/constants/constants.dart';
import 'package:findly_app/constants/curved_app_bar.dart';
import 'package:findly_app/screens/add_announcement.dart';
import 'package:findly_app/screens/dialogflow_chatbot_screen.dart';
import 'package:findly_app/screens/found_items_screen.dart';
import 'package:findly_app/screens/lost_items_screen.dart';
import 'package:findly_app/screens/notifications.dart';
import 'package:findly_app/screens/private_chat/user_chat_history_screen.dart';
import 'package:findly_app/screens/user_announcements_screen.dart';
import 'package:findly_app/screens/widgets/drawer_widget.dart';
import 'package:findly_app/services/push_notifications_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/text_styles.dart';

class UserDashboardScreen extends StatefulWidget {
  final String userID;

  const UserDashboardScreen({
    super.key,
    required this.userID,
  });

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  String firstName = "";
  String userCount = '';
  String lostCount = '';
  String foundCount = '';
  String returnedCount = "";
  int returnedItems = 0;
  String type = '';
  String test = '';

  @override
  void initState() {
    super.initState();
    getUserName();
    getUsersCount();
    getLostItemsCount();
    getFoundItemsCount();
    getReturnedItemsCount();
    updateFCM();
  }

  updateFCM() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      log("Updated FCM: ${PushNotificationController.fcm}");
      var cu = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(cu!.uid)
          .update({"fcm": PushNotificationController.fcm});
      log("Updated FCM: ${PushNotificationController.fcm}");
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    }
  }

  void getUserName() async {
    try {
      //Here we will fetch the users First name from the DB
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(
            widget.userID,
          ) // widget.userID is used because the var is defined outside the state class but under statefulWidget class
          .get();

      setState(() {
        firstName = userDoc.get('firstName');
      });
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  getUsersCount() async {
    try {
      QuerySnapshot data = await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        userCount = data.size.toString();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getReturnedItemsCount() async {
    try {
      //Here we will fetch the returned or found items counter from the DB
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('deletedAnnouncements')
          .doc(
            'foundOrReturned',
          )
          .get();

      setState(() {
        returnedItems = doc.get('count');
      });
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  getLostItemsCount() async {
    try {
      QuerySnapshot data = await FirebaseFirestore.instance.collection('lostItem').get();
      lostCount = data.size.toString();
      returnedItems += data.docs
          .where(
            (e) => (e.data() as Map)["found"] == true,
          )
          .length;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getFoundItemsCount() async {
    try {
      QuerySnapshot data = await FirebaseFirestore.instance.collection('foundItem').get();
      foundCount = data.size.toString();
      returnedItems += data.docs
          .where(
            (e) => (e.data() as Map)["returned"] == true,
          )
          .length;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  final GlobalKey<ScaffoldState> key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: key,
      backgroundColor: scaffoldColor,
      drawerEnableOpenDragGesture: false,
      drawer: DrawerWidget(
        drawerKey: key,
        userName: firstName,
        userId: widget.userID,
      ),
      appBar: CurvedAppBar(
        leading: IconButton(
          padding: const EdgeInsets.only(top: 16.0),
          icon: const Icon(Icons.menu),
          onPressed: () {
            key.currentState?.openDrawer();
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            "Hello $firstName!",
            style: TextStyles.appBarTitleStyle,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              right: 15.0,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.notifications_none,
                size: 32,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        children: [
          const Text(
            'Today',
            style: TextStyle(
              color: primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          Container(
            height: 150,
            margin: const EdgeInsets.symmetric(
              horizontal: 0.0,
              vertical: 16.0,
            ),
            padding: const EdgeInsets.only(
              top: 12.0,
              bottom: 12.0,
            ),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (index == 0) const SizedBox(width: 16.0),
                    Container(
                      width: size.width / 2.5,
                      margin: const EdgeInsets.only(right: 16.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset(
                              "assets/Image_not_available.png",
                            ),
                          ),
                          const Text(
                            "Testing",
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: dashboardButton(
                  iconName: "lost_item",
                  label: "Lost",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LostItemsScreen(userID: widget.userID),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: dashboardButton(
                  iconName: "found_item",
                  label: "Found",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoundItemsScreen(userID: widget.userID),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          Row(
            children: [
              Expanded(
                child: dashboardButton(
                  iconName: "add",
                  label: "New Announcement",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddAnnouncementScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: dashboardButton(
                  iconName: "found_item",
                  label: "My Announcement",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserAnnouncementsScreen(
                          userID: widget.userID,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          Row(
            children: [
              Expanded(
                child: dashboardButton(
                  iconName: "chat",
                  label: "My Chats",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserChatHistoryScreen(
                          userID: widget.userID,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: dashboardButton(
                  iconName: "chatbot",
                  label: "Need help?",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DialogflowChatBotScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget dashboardButton({
    required String iconName,
    required String label,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            gradient: kSecondaryLinearGradient,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  "assets/$iconName.png",
                  fit: BoxFit.fill,
                  color: primaryColor,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
