import 'package:findly_app/screens/user_dashboard_screen.dart';
import 'package:findly_app/screens/user_profile_page.dart';
import 'package:findly_app/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/constants.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
    required this.drawerKey,
    required this.userName,
    required this.userId,
  });

  final String userName, userId;
  final GlobalKey<ScaffoldState> drawerKey;

  void onTap(
    BuildContext context,
    Widget newScreen,
  ) {
    drawerKey.currentState?.closeDrawer();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => newScreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return Drawer(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: boxConstraints.maxHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    UserAccountsDrawerHeader(
                      decoration: const BoxDecoration(
                        color: primaryColor,
                      ),
                      currentAccountPicture: Image.asset(
                        "assets/user_dp_placeholder.png",
                        color: Colors.white,
                      ),
                      accountName: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                        ),
                        child: Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      accountEmail: const Text(""),
                    ),
                    _listTiles(
                      label: "Dashboard",
                      icon: "menu",
                      onTap: () => onTap(
                        context,
                        UserDashboardScreen(
                          userID: userId,
                        ),
                      ),
                    ),
                    _listTiles(
                      label: "Profile",
                      icon: "user_outlined",
                      onTap: () => onTap(
                        context,
                        UserProfilePage(
                          userID: userId,
                        ),
                      ),
                    ),
                    _listTiles(
                      label: "About Us",
                      icon: "info",
                      onTap: () {
                        debugPrint("To be implemented");
                      },
                    ),
                    const Divider(thickness: 1),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 24.0,
                  ),
                  child: _listTiles(
                    label: "Log out",
                    icon: "exit",
                    isLogoutButton: true,
                    onTap: () {
                      _logout(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
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
                      color: Constants.darkBlue, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to log out?",
            maxLines: 2,
            style: TextStyle(color: Constants.darkBlue, fontSize: 20, fontStyle: FontStyle.italic),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () async {
                  //if the user click "OK" she will be logged out and redirected to log in screen
                  await auth.signOut().then(
                    (value) {
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const UserState(),
                      ));
                    },
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
                ))
          ],
        );
      },
    );
  }

  //Designing a reusable widget for the drawer options
  Widget _listTiles({
    required String label,
    required Function onTap,
    required String icon,
    bool isLogoutButton = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      onTap: () {
        onTap();
      },
      leading: Image.asset(
        "assets/$icon.png",
        color: isLogoutButton ? const Color(0xFFC43F3F) : null,
        width: 24,
        height: 24,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isLogoutButton ? const Color(0xFFC43F3F) : primaryColor,
        ),
      ),
    );
  }
}
