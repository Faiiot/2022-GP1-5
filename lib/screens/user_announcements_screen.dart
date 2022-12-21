import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/screens/user_dasboard_screen.dart';
import 'package:findly_app/screens/widgets/announcements_widget.dart';
import 'package:findly_app/screens/widgets/my_button.dart';
import 'package:findly_app/screens/widgets/user_announcements_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slidable_button/slidable_button.dart';

class UserAnnouncementsScreen extends StatefulWidget {
  final String userID;
  final String type;

  const UserAnnouncementsScreen({required this.userID, required this.type});

  @override
  State<UserAnnouncementsScreen> createState() => _UserAnnouncementsScreenState();
}

class _UserAnnouncementsScreenState extends State<UserAnnouncementsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  List <dynamic> userAnnouncementsIDs = [];
  late final DocumentSnapshot announcements;
  late final QuerySnapshot uA;


  @override
  void initState() {

    super.initState();


  }



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
                Navigator.canPop(context)?Navigator.pop(context):null;
                // Navigator.pushReplacement(
                //     context, MaterialPageRoute(
                //     builder: (context)=>UserDashboardScreen(userID: widget.userID)));
              },
            );
          },
        ),
        title: Center(child: Text('My announcements'),),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_rounded),
            onPressed: (){print(widget.type);},)
        ],
      ),

      // Stream builder to get a snapshot of the announcement collection to show it in the home screen
      body:Center(
        child: StreamBuilder<QuerySnapshot>(
          stream:FirebaseFirestore.instance.collection(widget.type=='Lost'?'lostItem':'foundItem').where('publishedBy', isEqualTo: widget.userID).snapshots() ,
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









    );
  }
}