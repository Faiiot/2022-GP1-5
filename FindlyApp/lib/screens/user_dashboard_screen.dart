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
import '../services/global_methods.dart';
import 'announcement_detail_screen.dart';

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
      QuerySnapshot data =
          await FirebaseFirestore.instance.collection('users').get();
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
      QuerySnapshot data =
          await FirebaseFirestore.instance.collection('lostItem').get();
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
      QuerySnapshot data =
          await FirebaseFirestore.instance.collection('foundItem').get();
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
          // show number of unseen notifications
          SizedBox(
            width: 50,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                    child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("notifications")
                      .where("notify_to",isEqualTo: widget.userID)
                      .snapshots()
                      .asBroadcastStream(),
                      builder: (context,userNotifications){
                    int notificationsCount=0;
                    if(userNotifications.data!= null){
                      final List uNotifications = userNotifications.data!.docs;
                      notificationsCount = uNotifications.where(
                          (notification)=> notification["is_seen"] == false,
                      )
                          .length;
                    }
                    return Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        IconButton(onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationScreen(),
                            ),
                          );
                        },
                            icon: const Icon(
                              Icons.notifications_none,
                              size: 35,
                            ),),
                        const SizedBox(width: 6,),
                        notificationsCount != 0
                        ?CircleAvatar(
                          radius: 11.0,
                          backgroundColor: Colors.redAccent,
                          child: Text(
                            notificationsCount.toString(),
                            style: const TextStyle(
                              // color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Colors.white
                            ),
                          ),
                        )
                            :const SizedBox.shrink(),
                      ],
                    );
                      },
                )),
              ],
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
            'Items found recently!',
            style: TextStyle(
              color: primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w800,
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
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("foundItem")
                  .limit(5)
                  .orderBy('annoucementDate', descending: true)
                  .snapshots()
                  .asBroadcastStream(),
              builder: (context, snapshot) {
                final docs = snapshot.data?.docs;
                return ListView.builder(
                  itemCount: docs?.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (index == 0) const SizedBox(width: 16.0),
                        GestureDetector(
                          onTap: () async {
                            final info = await getNeededPublisherInfo(
                                docs?[index]["publishedBy"]);
                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AnnouncementDetailsScreen(
                                    announcementID: docs?[index]
                                        ["announcementID"],
                                    publisherID: docs?[index]["publishedBy"],
                                    announcementType: docs?[index]
                                        ["announcementType"],
                                    publishedBy: info["name"],
                                    phoneNumber: info["phone"],
                                    email: info["email"],
                                    profile: false,
                                    reported: docs?[index]["reported"],
                                    reportCount: docs?[index]["reportCount"],
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: size.width / 2.5,
                            margin: const EdgeInsets.only(right: 16.0),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              children: [
                                docs != null && docs[index]["url"] != ""
                                    ? Expanded(
                                        child: Image.network(
                                          docs[index]["url"],
                                        ),
                                      )
                                    : const Expanded(
                                        child: Icon(Icons.image,size: 60,color: Colors.grey,)
                                      ),
                                Text(
                                  docs != null ? docs[index]["itemName"] : "",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: dashboardButton(
                  iconName: "lost_icon_screen",
                  label: "Lost",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LostItemsScreen(userID: widget.userID),
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
                        builder: (context) =>
                            FoundItemsScreen(userID: widget.userID),
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
                  iconName: "my_announcements2",
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
                  iconName: "dialog",
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
                  iconName: "chatbotOutlined",
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

  Future<Map<String, dynamic>> getNeededPublisherInfo(String id) async {
    try {
      Map<String, dynamic> map = {};
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(id).get();
      map.addAll({
        "name": "${userDoc.get('firstName')} ${userDoc.get('LastName')}",
        "phone": userDoc.get('phoneNo'),
        "email": userDoc.get('Email'),
      });

      return map;
    } catch (error) {
      GlobalMethods.showErrorDialog(
        error: error.toString(),
        context: context,
      );
      return <String, dynamic>{};
    }
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
