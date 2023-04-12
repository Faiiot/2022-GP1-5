import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/constants/constants.dart';
import 'package:findly_admin/screens/found_items_screen.dart';
import 'package:findly_admin/screens/lost_items_screen.dart';
import 'package:findly_admin/screens/reported_announcement.dart';
import 'package:findly_admin/screens/widgets/drawer_widget.dart';
import 'package:findly_admin/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/curved_app_bar.dart';
import '../constants/text_styles.dart';

class AdminDashboardScreen extends StatefulWidget {
  //static const String screenRoute = 'home_screen';
  final String userID;

  //a constuctor that requires the user ID to return to each user her home screen
  const AdminDashboardScreen({
    super.key,
    required this.userID,
  });

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboaredScreenn();
}

class _AdminDashboaredScreenn extends State<AdminDashboardScreen> {
  String lost = '';
  String firstName = "";
  late int productCount;
  String userCount = '';
  String lostCount = '';
  String foundCount = '';
  int returnedItems = 0;
  int reported = 0;

  @override
  void initState() {
    super.initState();
    getAdminName();
    getUsersCount();
    getLostItemsCount();
    getFoundItemsCount();
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

  void getAdminName() async {
    try {
      //Here we will fetch the users First name from the DB
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('admin')
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

  final GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
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
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        children: [
          // const Text(
          //   'Items found recently!',
          //   style: TextStyle(
          //     color: primaryColor,
          //     fontSize: 20,
          //     fontWeight: FontWeight.w800,
          //   ),
          // ),
          // Container(
          //   height: 150,
          //   margin: const EdgeInsets.symmetric(
          //     horizontal: 0.0,
          //     vertical: 16.0,
          //   ),
          //   padding: const EdgeInsets.only(
          //     top: 12.0,
          //     bottom: 12.0,
          //   ),
          //   decoration: BoxDecoration(
          //     color: primaryColor,
          //     borderRadius: BorderRadius.circular(16.0),
          //   ),
          //   child: StreamBuilder(
          //     stream: FirebaseFirestore.instance
          //         .collection("foundItem")
          //         .limit(5).orderBy('annoucementDate',descending: true)
          //         .snapshots()
          //         .asBroadcastStream(),
          //     builder: (context, snapshot) {
          //       final docs = snapshot.data?.docs;
          //       return ListView.builder(
          //         itemCount: docs?.length,
          //         scrollDirection: Axis.horizontal,
          //         itemBuilder: (context, index) {
          //           return Row(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               if (index == 0) const SizedBox(width: 16.0),
          //               GestureDetector(
          //                 onTap: () async {
          //                   final info = await getNeededPublisherInfo(docs?[index]["publishedBy"]);
          //                   if (mounted) {
          //                     Navigator.push(
          //                       context,
          //                       MaterialPageRoute(
          //                         builder: (context) => AnnouncementDetailsScreen(
          //                           announcementID: docs?[index]["announcementID"],
          //                           publisherID: docs?[index]["publishedBy"],
          //                           announcementType: docs?[index]["announcementType"],
          //                           publishedBy: info["name"],
          //                           phoneNumber: info["phone"],
          //                           email: info["email"],
          //                           profile: false,
          //                           reported: docs?[index]["reported"],
          //                           reportCount: docs?[index]["reportCount"],
          //                         ),
          //                       ),
          //                     );
          //                   }
          //                 },
          //                 child: Container(
          //                   width: size.width / 2.5,
          //                   margin: const EdgeInsets.only(right: 16.0),
          //                   padding: const EdgeInsets.all(8.0),
          //                   decoration: BoxDecoration(
          //                     color: Colors.white,
          //                     borderRadius: BorderRadius.circular(12.0),
          //                   ),
          //                   child: Column(
          //                     children: [
          //                       docs != null && docs[index]["url"] != ""
          //                           ? Expanded(
          //                         child: Image.network(
          //                           docs[index]["url"],
          //                         ),
          //                       )
          //                           : Expanded(
          //                         child: Image.asset(
          //                           "assets/Image_not_available.png",
          //                           fit: BoxFit.fill,
          //                         ),
          //                       ),
          //                       Text(
          //                         docs != null ? docs[index]["itemName"] : "",
          //                         overflow: TextOverflow.ellipsis,
          //                         style: const TextStyle(
          //                           color: primaryColor,
          //                           fontWeight: FontWeight.bold,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Image.asset("assets/users.png",height: 60,),
              ),
              Text("$userCount users are using Findly!",
              style: const TextStyle(
                fontWeight: FontWeight.w600
              ),)
            ],
          ),
          const SizedBox(height: 16,),
          Container(
            height: 1.0,
            decoration: const BoxDecoration(
              color: primaryColor,
              boxShadow: [
                BoxShadow(
                  color: primaryColor,

                  blurRadius: 6,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
          ),
          const SizedBox(height: 16,),
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
                  iconName: "category",
                  label: "Add category",
                  onTap: () {},
                ),
              ),
              const SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: dashboardButton(
                  iconName: "building",
                  label: "Add building",
                  onTap: () {},
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
                child:
            StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("lostItem")
                              .orderBy("annoucementDate", descending: true)
                              .snapshots()
                              .asBroadcastStream(),
                          builder: (context, lostSnapshots) {
                            return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("foundItem")
                                  .orderBy("annoucementDate", descending: true)
                                  .snapshots()
                                  .asBroadcastStream(),
                              builder: (context, foundSnapshots) {
                                int a = 0, b = 0;
                                if (lostSnapshots.data != null) {
                                  final List reportedLost = lostSnapshots.data!.docs;
                                  a = reportedLost
                                      .where(
                                        (announcement) => announcement["reported"] == true,
                                      )
                                      .length;
                                }
                                if (lostSnapshots.data != null) {
                                  final List reportedFound = foundSnapshots.data!.docs;
                                  b = reportedFound
                                      .where(
                                        (announcement) => announcement["reported"] == true,
                                      )
                                      .length;
                                }
                                reported = a + b;
                                debugPrint(reported.toString());
                                return Stack(
                                  alignment: AlignmentDirectional.topStart,
                                      children: [
                                        dashboardButton(
                                          iconName: "report",
                                          label: "Reported Announcement",
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ReportedAnnouncement(
                                                  userID: widget.userID,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        CircleAvatar(
                                          radius: 16.0,
                                          backgroundColor: Colors.white,
                                          child: Text(
                                            reported.toString(),
                                            style: const TextStyle(
                                              // color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
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
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
        ],
      ),

    );
  }

  void _logout(context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.logout_outlined,
                  size: 30,
                  color: Constants.darkBlue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Log out",
                  style: TextStyle(
                    fontSize: 22,
                    color: Constants.darkBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          //Log out confirmation message
          content: Text(
            "Are you sure you want to log out?",
            maxLines: 2,
            style: TextStyle(
              color: Constants.darkBlue,
              fontSize: 20,
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: [
            //Cancel button > back to the drawer
            TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text("Cancel")),
            TextButton(
              onPressed: () async {
                //if the user click "OK" she will be logged out and redurected to log in screen
                await auth.signOut();
                if (!mounted) return;
                Navigator.canPop(context) ? Navigator.pop(context) : null;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const UserState(),
                  ),
                );
                Fluttertoast.showToast(
                    msg: "You have been logged out successfully!",
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: Colors.blueGrey,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
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
          width: double.infinity,
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
