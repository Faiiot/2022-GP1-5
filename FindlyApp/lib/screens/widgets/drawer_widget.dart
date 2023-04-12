import 'package:findly_app/screens/auth_home_screen.dart';
import 'package:findly_app/screens/user_dashboard_screen.dart';
import 'package:findly_app/screens/user_profile_page.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                      label: "Profile",
                      icon: "user_outlined",
                      onTap: () => onTap(
                        context,
                        UserProfilePage(
                          userID: userId,
                        ),
                      ),
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
    GlobalMethods.showCustomizedDialogue(
      title: "Log out",
      message: "Are you sure you want to log out?",
      mainAction: "Ok",
      context: context,
      secondaryAction: "Cancel",
      onPressedSecondary: () {
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      },
      onPressedMain: () async {
        //if the user click "OK" she will be logged out and redirected to log in screen
        Navigator.pop(context);
        await auth.signOut().then(
          (value) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const AuthHomeScreen(),
              ),
              (_) => false,
            );
          },
        );
        GlobalMethods.showToast(
          "You have been logged out successfully!",
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
