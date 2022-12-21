import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/widgets/announcements_widget.dart';

class FindlySearchDelegate extends SearchDelegate{
  CollectionReference _announcements = FirebaseFirestore.instance.collection('foundItem');
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(onPressed: (){query='';}, icon: Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: (){Navigator.of(context).pop();},
        icon: Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _announcements.snapshots().asBroadcastStream(),
        builder:(BuildContext context , AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }else{
            if(snapshot.data!.docs
                .where((QueryDocumentSnapshot<Object?> element) => element['itemName']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase())).isEmpty){
              return Center(child: Text('No results were found!', style: TextStyle(fontSize: 18),),);
            }else{
              return ListView(
                children: [
                  ...snapshot.data!.docs
                      .where((QueryDocumentSnapshot<Object?> element) => element['itemName']
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase())).map((QueryDocumentSnapshot<Object?> data) {
                    final String announcementID = data['announcementID'];
                    final String itemName = data.get('itemName');
                    final String announcementType = data['announcementType'];
                    final String itemCategory = data['itemCategory'];
                    final Timestamp annoucementDate = data['annoucementDate'];
                    final String buildingName = data['buildingName'];
                    final String contact = data.get('contact');
                    final String publishedBy = data['publishedBy'];
                    final String announcementDes = data['announcementDes'];
                    final String announcementImg = data['url'];


                    return Announcement(
                        announcementID: announcementID,
                        itemName: itemName,
                        announcementType: announcementType,
                        itemCategory: itemCategory,
                        postDate: annoucementDate,
                        announcementImg: announcementImg,
                        buildingName: buildingName,
                        contactChannel: contact,
                        publisherID: publishedBy,
                        announcementDes: announcementDes);


                  })
                ],
              );
            }
            ///Fetch data here

            // return ListView.builder(
            //     itemCount: snapshot.data!.docs.length,
            //     itemBuilder: (BuildContext context,int index){
            //       return Announcement(
            //         //snapshot.data!.docs is a list of the announcements
            //         //by pointing to the index of a specific announcement and fetching info
            //         announcementID:snapshot.data!.docs[index]['announcementID'] ,
            //         itemName: snapshot.data!.docs[index]['itemName'],
            //         announcementType: snapshot.data!.docs[index]['announcementType'],
            //         itemCategory: snapshot.data!.docs[index]['itemCategory'],
            //         postDate: snapshot.data!.docs[index]['annoucementDate'],
            //         announcementImg: snapshot.data!.docs[index]['url'],
            //         buildingName: snapshot.data!.docs[index]['buildingName'],
            //         contactChannel: snapshot.data!.docs[index]['contact'],
            //         publisherID: snapshot.data!.docs[index]['publishedBy'],
            //         announcementDes: snapshot.data!.docs[index]['announcementDes'],
            //       );
            //     });

          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(child:Text("Type item names to search!"));
  }
}