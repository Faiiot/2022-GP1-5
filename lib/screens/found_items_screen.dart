import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/screens/user_dasboard_screen.dart';
import 'package:findly_app/screens/widgets/announcements_widget.dart';
import 'package:findly_app/services/findly_search_delegate.dart';
import 'package:flutter/material.dart';

class FoundItemsScreen extends StatefulWidget {
  final String userID;

  const FoundItemsScreen({required this.userID,});

  @override
  State<FoundItemsScreen> createState() => _FoundItemsScreenState();
}

class _FoundItemsScreenState extends State<FoundItemsScreen> {
  String searchText = '';
  List<Map<String, dynamic>> _saerchResults = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE4ECF4),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (ctx){
            return IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: (){
                Navigator.pushReplacement(
                    context, MaterialPageRoute(
                    builder: (context)=>UserDashboardScreen(userID: widget.userID)));
              },
            );
          },
        ),
        title: Text('Found announcements'),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded),
            onPressed: (){
              showSearch(context: context, delegate: FindlySearchDelegate());
            },),
          IconButton(
            icon: Icon(Icons.filter_alt_rounded),
            onPressed: (){},)
        ],
      ),

      //Stream builder to get a snapshot of the announcement collection to show it in the home screen
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Card(
          //     child: TextField(
          //       decoration: InputDecoration(
          //         suffixIcon: Icon(Icons.search),
          //         hintText: '    Search Found items...',
          //
          //       ),
          //
          //       onChanged: (value){
          //         setState(() {
          //           searchText = value.trim();
          //         });
          //       },
          //     ),
          //   ),
          // ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
              FirebaseFirestore.instance.collection('foundItem').orderBy('annoucementDate', descending: true).snapshots()
             ,
              builder: (context, snapshot){
                //if the connection state is "waiting", a progress indicatior will appear
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                  //if the connection state is "active"
                }else if (snapshot.connectionState == ConnectionState.active){
                  //if the collection snapshot is empty
                  if(snapshot.data!.docs.isNotEmpty){

                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context,int index){
                          return Announcement(
                            //snapshot.data!.docs is a list of the announcements
                            //by pointing to the index of a specific announcement and fetching info
                            announcementID:snapshot.data!.docs[index]['announcementID'] ,
                            itemName: snapshot.data!.docs[index]['itemName'],
                            announcementType: snapshot.data!.docs[index]['announcementType'],
                            itemCategory: snapshot.data!.docs[index]['itemCategory'],
                            postDate: snapshot.data!.docs[index]['annoucementDate'],
                            announcementImg: snapshot.data!.docs[index]['url'],
                            buildingName: snapshot.data!.docs[index]['buildingName'],
                            contactChannel: snapshot.data!.docs[index]['contact'],
                            publisherID: snapshot.data!.docs[index]['publishedBy'],
                            announcementDes: snapshot.data!.docs[index]['announcementDes'],
                          );
                        });
                  }else{
                    return Center(//if no announcement was uploaded
                      child: Text("No Announcements has been uploaded yet!", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),),
                    );
                  }
                }
                return Center(//if something went wrong
                  child: Text("Something went wrong", ),
                );
              },
            ),
          ),
        ],
      ),





    );
  }
}
