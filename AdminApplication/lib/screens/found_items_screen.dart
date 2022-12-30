import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/screens/adimhomepage.dart';
import 'package:findly_admin/screens/widgets/announcements_widget.dart';
import 'package:flutter/material.dart';

class FoundItemsScreen extends StatefulWidget {
  final String userID;

  const FoundItemsScreen({
    required this.userID,
  });

  @override
  State<FoundItemsScreen> createState() => _FoundItemsScreenState();
}

class _FoundItemsScreenState extends State<FoundItemsScreen> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE4ECF4),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (ctx) {
            return IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => adminhomepage(userID: widget.userID)));
              },
            );
          },
        ),
        title: Card(
          child: TextField(
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search),
              hintText: ' Search Found items...',
            ),
            onChanged: (value) {
              setState(() {
                searchText = value.trim();
              });
            },
          ),
        ),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.search_rounded),
          //   onPressed: (){
          //     showSearch(context: context, delegate: FindlySearchDelegate());
          //   },),
          IconButton(
            icon: Icon(Icons.filter_alt_rounded),
            onPressed: () {},
          )
        ],
      ),

      //Stream builder to get a snapshot of the announcement collection to show it in the home screen
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('foundItem')
            .orderBy('annoucementDate', descending: true)
            .snapshots()
            .asBroadcastStream(),
        builder: (context, snapshot) {
          //if the connection state is "waiting", a progress indicatior will appear
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );

            //if the connection state is "active"
          } else if (snapshot.connectionState == ConnectionState.active) {
            //if the collection snapshot is empty
            if (snapshot.data!.docs.isNotEmpty) {
              final data = snapshot.data!.docs;

              if (searchText.isNotEmpty) {
                data.retainWhere(
                      (element) => element['itemName'].toString().toLowerCase().contains(
                    searchText.toLowerCase(),
                  ),
                );
              }

              return ListView.builder(
                  itemCount: data.length,
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
                    );
                  });
            } else {
              return Center(
                //if no announcement was uploaded
                child: Text(
                  "No Announcements has been uploaded yet!",
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
              );
            }
          }
          return Center(
            //if something went wrong
            child: Text(
              "Something went wrong",
            ),
          );
        },
      ),
    );
  }
}
