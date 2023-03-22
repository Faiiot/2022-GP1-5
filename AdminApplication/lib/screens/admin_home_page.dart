import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/constants/constants.dart';
import 'package:findly_admin/screens/admin_profile_page.dart';
import 'package:findly_admin/screens/admin_edit.dart';
import 'package:findly_admin/screens/found_items_screen.dart';
import 'package:findly_admin/screens/lost_items_screen.dart';
import 'package:findly_admin/screens/reported_announcement.dart';
import 'package:findly_admin/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminHomePage extends StatefulWidget {
  //static const String screenRoute = 'home_screen';
  final String userID;

  //a constuctor that requires the user ID to return to each user her home screen
  const AdminHomePage({
    super.key,
    required this.userID,
  });

  @override
  State<AdminHomePage> createState() => _AdminHomePage();
}

class _AdminHomePage extends State<AdminHomePage> {
  String lost = '';
  late int productCount;
  String userCount = '';
  String lostCount = '';
  String foundCount = '';
  int returnedItems = 0;
  int reported = 0;

  @override
  void initState() {
    super.initState();
    getUsersCount();
    getLostItemsCount();
    getFoundItemsCount();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Admin DashBoard'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: InkWell(
                        onTap: () {},
                        child: SizedBox(
                          height: 100,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 7,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xfff8f8f8),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Current Users',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14),
                                    ),
                                    const Spacer(),
                                    Text(
                                      userCount,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
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
                        onTap: () {},
                        child: SizedBox(
                          height: 100,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 7,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color(0xfff8f8f8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Returned items',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14),
                                    ),
                                    const Spacer(),
                                    Text(
                                      returnedItems.toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LostItemsScreen(userID: widget.userID),
                            ),
                          );
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
                              children: [
                                const Text(
                                  'Lost',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  lostCount,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoundItemsScreen(userID: widget.userID),
                            ),
                          );
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
                              children: [
                                const Text(
                                  'Found',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  foundCount,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminEdit(),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 7,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.edit,
                              size: 35,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
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
                  child: StreamBuilder(
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
                          return Card(
                            elevation: 7,
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              // height: 70,
                              width: double.infinity,
                              padding: const EdgeInsets.all(
                                16.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.report_gmailerrorred,
                                    size: 35,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'Reported Announcement',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2.0,
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
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminProfile(userID: widget.userID),
                            ),
                          );
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
                                  'Profile Page',
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
                        onTap: () => _logout(context),
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
                                  'Log Out',
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
        ),
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
}
