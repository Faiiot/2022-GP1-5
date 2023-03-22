import 'package:findly_admin/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants/constants.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
    required this.userName,
  });

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            child: Column(
              children: [
                const Flexible(
                  child: Icon(
                    Icons.perm_identity_rounded,
                    size: 55,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Flexible(
                  child: Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          _listTiles(
            label: "My announcements",
            icon: Icons.history,
            fctn: () {},
          ),
          _listTiles(
            label: "Profile",
            icon: Icons.manage_accounts_rounded,
            fctn: () {},
          ),
          _listTiles(
            label: "Use Guide",
            icon: Icons.question_mark_sharp,
            fctn: () {
              debugPrint(userName);
            },
          ),
          const Divider(
            thickness: 1,
          ),
          _listTiles(
            label: "Log out",
            icon: Icons.logout_outlined,
            fctn: () {
              _logout(context);
            },
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
                  await auth.signOut();
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const UserState(),
                  ));
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

  Widget _listTiles({required String label, required Function fctn, required IconData icon}) {
    return ListTile(
      onTap: () {
        fctn();
      },
      leading: Icon(icon, color: Constants.darkBlue),
      title: Text(
        label,
        style: TextStyle(
          color: Constants.darkBlue,
          fontSize: 20,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
