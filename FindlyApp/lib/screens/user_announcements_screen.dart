import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/constants/curved_app_bar.dart';
import 'package:findly_app/screens/widgets/announcements_widget.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class UserAnnouncementsScreen extends StatefulWidget {
  final String userID;

  const UserAnnouncementsScreen({
    super.key,
    required this.userID,
  });

  @override
  State<UserAnnouncementsScreen> createState() =>
      _UserAnnouncementsScreenState();
}

class _UserAnnouncementsScreenState extends State<UserAnnouncementsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: scaffoldColor,
        appBar: CurvedAppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('My announcements'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt_rounded),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 4.0),
            TabBar(
              labelColor: primaryColor,
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Lost",
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Found",
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _StreamBuilderWidget(
                    userID: widget.userID,
                    type: "lostItem",
                  ),
                  _StreamBuilderWidget(
                    userID: widget.userID,
                    type: "foundItem",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreamBuilderWidget extends StatelessWidget {
  const _StreamBuilderWidget({
    Key? key,
    required this.userID,
    required this.type,
  }) : super(key: key);

  final String userID;
  final String type;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(type)
          .where(
            'publishedBy',
            isEqualTo: userID,
          )
          .snapshots(),
      builder: (context, snapshot) {
        //if the connection state is "waiting", a progress indicatior will appear
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
          //if the connection state is "active"
        } else if (snapshot.connectionState == ConnectionState.active) {
          //if the collection snapshot is empty
          if (snapshot.data!.docs.isNotEmpty) {
            List data = snapshot.data!.docs;
            //
            // data = GlobalMethods.quickSortAnnouncement(data);
            return GridView.builder(
              itemCount: data.length,
              padding: const EdgeInsets.all(
                8.0,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Announcement(
                  //snapshot.data!.docs is a list of the announcements
                  //by pointing to the index of a specific announcement and fetching info
                  announcementID: data[index]['announcementID'],
                  itemName: data[index]['itemName'],
                  announcementType: data[index]['announcementType'],
                  itemCategory: data[index]['itemCategory'],
                  postDate: data[index]['annoucementDate'],
                  announcementImg: data[index]['url'],
                  buildingName: data[index]['buildingName'],
                  contactChannel: data[index]['contact'],
                  publisherID: data[index]['publishedBy'],
                  announcementDes: data[index]['announcementDes'],
                  profile: true,
                  reported: data[index]['reported'],
                  reportCount: data[index]['reportCount'],
                  roomNumber: data[index]['roomnumber'],
                  floorNumber: data[index]['floornumber'],
                );
              },
            );
          } else {
            return const Center(
              //if no announcement was uploaded
              child: Text(
                "No Announcements has\n been uploaded yet!",
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            );
          }
        }
        return const Center(
          //if something went wrong
          child: Text(
            "Something went wrong",
          ),
        );
      },
    );
  }
}
