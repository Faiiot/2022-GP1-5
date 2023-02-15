import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

//to insert the chatroom info into the collection to create it
class ChatMethods{
  createChatRoom(String chatroomID, chatroomMap){
    FirebaseFirestore.instance.collection("chatRooms")
        .doc(chatroomID).set(chatroomMap).catchError((e){
          print(e.toString());
    });
  }

  // to generate the same chatroom id for the to users always to avid duplicate rooms for the same users
  String generateChatroomId(userID, peerID){
    String chatID;
    if(userID.compareTo(peerID)>0)
    {
      chatID = "$userID-$peerID";
    }else{
      chatID = "$peerID-$userID";
    }
    return chatID;
  }


  addChatMessages(String chatroomID, messageMap){
    FirebaseFirestore.instance.collection("chatRooms")
        .doc(chatroomID)
        .collection("messages")
        .add(messageMap).catchError((e){print(e.toString());});
  }

  getChatMessages(String chatroomID) async{
    return await FirebaseFirestore.instance.collection("chatRooms")
        .doc(chatroomID)
        .collection("messages")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userID) async{
    return await FirebaseFirestore.instance
        .collection("chatRooms")
        .where("users", arrayContains: userID)
        .snapshots();
  }

   getUsername(String userID) async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID) // widget.userID is used because the var is defined outside the state class but under statefulwidget class
          .get();

      String firstName = userDoc.get('firstName');
      String lastName = userDoc.get('LastName');
      String fullName = '$firstName $lastName';

      print(userID+" "+fullName);
      return fullName;
    } catch (error) {
      print(error.toString());
  }
  }
}