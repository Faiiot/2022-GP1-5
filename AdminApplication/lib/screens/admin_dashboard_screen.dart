import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/constants/constants.dart';
import 'package:findly_admin/screens/add_building_screen.dart';
import 'package:findly_admin/screens/add_category_screen.dart';
import 'package:findly_admin/screens/found_items_screen.dart';
import 'package:findly_admin/screens/lost_items_screen.dart';
import 'package:findly_admin/screens/reported_announcement.dart';
import 'package:findly_admin/screens/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
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
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16,bottom: 8.0),
                child: Image.asset("assets/users.png",height: 70,),
              ),
              const SizedBox(height: 16,),
              Text("$userCount users are using Findly!",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16
              ),)
            ],
          ),
          const SizedBox(height: 36,),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const AddCategoryScreen(),
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
                  iconName: "building",
                  label: "Add building",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const AddBuildingScreen(),
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
                                if (foundSnapshots.data != null) {
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
                                        reported != 0
                                        ?CircleAvatar(
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
                                        )
                                            :const SizedBox.shrink(),
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
