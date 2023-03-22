import 'package:cloud_firestore/cloud_firestore.dart';

//to insert the chatroom info into the collection to create it
class ChatMethods {
  createChatRoom(String chatroomID, chatroomMap) {
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatroomID)
        .set(chatroomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  // to generate the same chatroom id for the to users always to avid duplicate rooms for the same users
  String generateChatroomId(userID, peerID) {
    String chatID;
    if (userID.compareTo(peerID) > 0) {
      chatID = "$userID-$peerID";
    } else {
      chatID = "$peerID-$userID";
    }
    return chatID;
  }

  addChatMessages(String chatroomID, messageMap) {
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatroomID)
        .collection("messages")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addChatImageMessages(String chatroomID, String imageID, messageMap) {
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatroomID)
        .collection("messages")
        .doc(imageID)
        .set(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  updateChatImageMessageField(String chatroomID, String imageID, String imageUrl) {
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatroomID)
        .collection("messages")
        .doc(imageID)
        .update({"message": imageUrl});
  }

  Stream<dynamic> getChatMessages(String chatroomID) {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatroomID)
        .collection("messages")
        .orderBy("time", descending: true)
        .get()
        .asStream();
  }

  Stream<dynamic> getChatRooms(String userID) {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .where("users", arrayContains: userID)
        .get()
        .asStream();
  }

  getUsername(String userID) async {
    try {
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(userID).get();

      String firstName = userDoc.get('firstName');
      String lastName = userDoc.get('LastName');
      String fullName = '$firstName $lastName';

      print(userID + " " + fullName);
      return fullName;
    } catch (error) {
      print(error.toString());
    }
  }

  updateLastMessageOfChatroom(String message, String chatroomID) {
    FirebaseFirestore.instance.collection("chatRooms").doc(chatroomID).update(
      {
        "lastMessage": message,
      },
    );
  }
}
