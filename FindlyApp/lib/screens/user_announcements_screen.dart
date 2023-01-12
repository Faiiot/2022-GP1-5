import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/screens/widgets/user_announcements_widget.dart';
import 'package:flutter/material.dart';

class UserAnnouncementsScreen extends StatefulWidget {
  final String userID;

  const UserAnnouncementsScreen({
    super.key,
    required this.userID,
  });

  @override
  State<UserAnnouncementsScreen> createState() => _UserAnnouncementsScreenState();
}

class _UserAnnouncementsScreenState extends State<UserAnnouncementsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFE4ECF4),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: Builder(
            builder: (ctx) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
          title: const Center(
            child: Text('My announcements'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt_rounded),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
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
        ),
        body: TabBarView(
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
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return UserAnnouncement(
                  //snapshot.data!.docs is a list of the announcements
                  //by pointing to the index of a specific announcement and fetching info
                  announcementID: snapshot.data!.docs[index]['announcementID'],
                  itemName: snapshot.data!.docs[index]['itemName'],
                  announcementType: snapshot.data!.docs[index]['announcementType'],
                  itemCategory: snapshot.data!.docs[index]['itemCategory'],
                  postDate: snapshot.data!.docs[index]['annoucementDate'],
                  announcementImg: snapshot.data!.docs[index]['url'],
                  buildingName: snapshot.data!.docs[index]['buildingName'],
                  contactChannel: snapshot.data!.docs[index]['contact'],
                  publisherID: snapshot.data!.docs[index]['publishedBy'],
                  announcementDes: snapshot.data!.docs[index]['announcementDes'],
                  profile: true,
                  reportCount: snapshot.data!.docs[index]['reportCount'],
                  reported: snapshot.data!.docs[index]['reported'],
                  roomNumber: snapshot.data!.docs[index]['roomnumber'],
                  floorNumber: snapshot.data!.docs[index]['floornumber'],
                );
              },
            );
          } else {
            return const Center(
              //if no announcement was uploaded
              child: Text(
                "No Announcements has been uploaded yet!",
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
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
