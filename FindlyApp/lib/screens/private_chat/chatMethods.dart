import 'package:cloud_firestore/cloud_firestore.dart';

//to insert the chat room info into the collection to create it
class ChatMethods {
  createChatRoom(String chatroomID, chatroomMap) {
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatroomID)
        .set(chatroomMap)
        .catchError((e) {});
  }

  // to generate the same chat room id for the to users always to avid duplicate rooms for the same users
  String generateChatroomId(userID, peerID) {
    String chatID;
    if (userID.compareTo(peerID) > 0) {
      chatID = "$userID-$peerID";
    } else {
      chatID = "$peerID-$userID";
    }
    return chatID;
  }

  //to add text messages to the specific chat room
  Future<void> addChatMessages(String chatroomID, messageMap) async {
    await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatroomID)
        .collection("messages")
        .add(messageMap)
        .catchError((e) {});
  }

  //to add image messages to the specific chat room
  Future<void> addChatImageMessages(
    String chatroomID,
    String imageID,
    messageMap,
  ) async {
    await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatroomID)
        .collection("messages")
        .doc(imageID)
        .set(messageMap)
        .catchError((e) {});
  }

  //to update image url stored in database to be retrieved and shown to user
  Future<void> updateChatImageMessageField(
    String chatroomID,
    String imageID,
    String imageUrl,
  ) async {
    await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatroomID)
        .collection("messages")
        .doc(imageID)
        .update({"message": imageUrl});
  }

  //to load chat messages ordered
  Stream<dynamic> getChatMessages(String chatroomID) {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatroomID)
        .collection("messages")
        .orderBy("time", descending: true)
        .snapshots()
        .asBroadcastStream();
  }

  //to load chat rooms that a user is a party in
  Stream<dynamic> getChatRooms(String userID) {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .where("users", arrayContains: userID)
        .snapshots()
        .asBroadcastStream();
  }
//to get the user name
  Future<String> getUsername(String userID) async {
    try {
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(userID).get();

      String firstName = userDoc.get('firstName');
      String lastName = userDoc.get('LastName');
      String fullName = '$firstName $lastName';

      return fullName;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  //to update last message of a chat room
  updateLastMessageOfChatroom(String message, String chatroomID, int time) {
    FirebaseFirestore.instance.collection("chatRooms").doc(chatroomID).update(
      {
        "lastMessage": message,
        "lastMessageTime": time,
      },
    );
  }
}
