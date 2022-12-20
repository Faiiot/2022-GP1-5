import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/screens/user_dasboard_screen.dart';
import 'package:findly_app/screens/widgets/user_announcements_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAnnouncementsScreen extends StatefulWidget {
  final String userID;

  const UserAnnouncementsScreen({required this.userID,});

  @override
  State<UserAnnouncementsScreen> createState() => _UserAnnouncementsScreenState();
}

class _UserAnnouncementsScreenState extends State<UserAnnouncementsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  List <dynamic> userAnnouncementsIDs = [];
  late final DocumentSnapshot announcements;
  late final QuerySnapshot uA;
  //dependency injection
 // late final String announcementID;
 // late final String itemName;
 // late final String announcementType;
 // late final String itemCategory;
 // late final Timestamp postDate;
 // late final String announcementImg;
 // late final String buildingName;
 // late final String contactChannel;
 // late final String publisherID;
 // late final String announcementDes;

  @override
  void initState() {

    super.initState();
    getUserAnnouncements();

  }

  void getUserAnnouncements() async {
    _isLoading = true;
    try {

      final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID) // widget.userID is used because the var is defined outside the state class but under statefulwidget class
          .get();


      if (userDoc == null) {
        return;
      } else {
        setState(() async {
          userAnnouncementsIDs = userDoc.get('userAnnouncement');
          if(await myAnnouncement(userAnnouncementsIDs[0])){
          uA = await FirebaseFirestore.instance.collection('users')
              .where('announcementID', isEqualTo:userAnnouncementsIDs[0] ).get();

        }});
        print(userAnnouncementsIDs);
      }
    }catch(error){
      print(error);
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }
  // void getAnnouncementInfo (String announcementId) async{
  //
  //    final DocumentSnapshot announcement =
  //        await FirebaseFirestore
  //        .instance
  //        .collection('announcement')
  //        .doc(announcementID)
  //        .get();
  //    setState(() {
  //      announcementID= announcementId;
  //      itemName= announcement.get('itemName');
  //      announcementType = announcement.get('announcementType');
  //      itemCategory= announcement.get('itemCategory');
  //      postDate = announcement.get('annoucementDate');
  //      announcementImg= announcement.get('url');
  //      buildingName= announcement.get('buildingName');
  //      contactChannel= announcement.get('contact');
  //      publisherID = announcement.get('publishedBy');
  //      // i may delete this since it is her announcement
  //      announcementDes= announcement.get('announcementDes');
  //    });
  //
  // }
  Future<bool> myAnnouncement (annID) async {
    for( var i =0; i < userAnnouncementsIDs.length; i++){
      if(annID == userAnnouncementsIDs[i]){return true;}
    }
    return false;
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
                Navigator.pushReplacement(
                    context, MaterialPageRoute(
                    builder: (context)=>UserDashboardScreen(userID: widget.userID)));
              },
            );
          },
        ),
        title: Text("My announcements", textAlign: TextAlign.center,),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_rounded),
            onPressed: (){print(userAnnouncementsIDs);},)
        ],
      ),

      // Stream builder to get a snapshot of the announcement collection to show it in the home screen
      body:

      ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context ,int index) {
            return UserAnnouncement(
              announcementID: userAnnouncementsIDs[0],
            );
          })

      // StreamBuilder<QuerySnapshot>(
      //   stream:FirebaseFirestore.instance.collection('announcement').snapshots() ,
      //   builder: (context, snapshot){
      //     //if the connection state is "waiting", a progress indicatior will appear
      //     if(snapshot.connectionState == ConnectionState.waiting){
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //
      //       //if the connection state is "active"
      //     }else if (snapshot.connectionState == ConnectionState.active){
      //       //if the collection snapshot is empty
      //       if(snapshot.data!.docs.isNotEmpty){
      //         return ListView.builder(
      //             itemCount: snapshot.data!.docs.length,
      //             itemBuilder: (BuildContext context,int index){
      //               print(myAnnouncement(snapshot.data!.docs[index]['announcementID']));
      //               return UserAnnouncement(
      //                 //snapshot.data!.docs is a list of the announcements
      //                 //by pointing to the index of a specific announcement and fetching info
      //                 announcementID:snapshot.data!.docs[index][userAnnouncementsIDs[0]] ,
      //               );
      //             });
      //       }else{
      //         return Center(//if no announcement was uploaded
      //           child: Text("No Announcements has been uploaded yet!", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),),
      //         );
      //       }
      //     }
      //     return Center(//if something went wrong
      //       child: Text("Something went wrong", ),
      //     );
      //   },
      // ),





    );
  }
}