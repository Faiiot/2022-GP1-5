import 'package:findly_app/user_state.dart';
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
                Flexible(
                    child: Image.network(
                  "https://www.iconsdb.com/icons/preview/white/contacts-xxl.png",
                )),
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
            onTap: () {},
          ),
          _listTiles(
            label: "Profile",
            icon: Icons.manage_accounts_rounded,
            onTap: () {},
          ),
          _listTiles(
            label: "Use Guide",
            icon: Icons.question_mark_sharp,
            onTap: () {
              debugPrint(userName);
            },
          ),

          const Divider(
            thickness: 1,
          ),
          //Log out button
          _listTiles(
            label: "Log out",
            icon: Icons.logout_outlined,
            onTap: () {
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
              style:
                  TextStyle(color: Constants.darkBlue, fontSize: 20, fontStyle: FontStyle.italic),
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
        });
  }

  //Designing a reusable widget for the drawer options
  Widget _listTiles({required String label, required Function onTap, required IconData icon}) {
    return ListTile(
      onTap: () {
        onTap();
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
