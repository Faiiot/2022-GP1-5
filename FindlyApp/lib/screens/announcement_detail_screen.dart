import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/constants/constants.dart';
import 'package:findly_app/screens/editAnnouncement.dart';
import 'package:findly_app/screens/private_chat/chatMethods.dart';
import 'package:findly_app/screens/private_chat/private_chat_screen.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AnnouncementDetailsScreen extends StatefulWidget {
  final String announcementID;
  final String publisherID;
  final String itemName;
  final String announcementType;
  final String itemCategory;
  final Timestamp postDate;
  final String announcementImg;
  final String buildingName;
  final String contactChannel;
  final String theChannel;
  final String publishedBy;
  final String announcementDes;
  final bool profile;
  final String roomNumber;
  final String floorNumber;
  final bool reported;
  final int reportCount;

  //constructor to require the announcement's information
  const AnnouncementDetailsScreen({
    super.key,
    required this.announcementID,
    required this.publisherID,
    required this.itemName,
    required this.announcementType,
    required this.itemCategory,
    required this.postDate,
    required this.announcementImg,
    required this.buildingName,
    required this.contactChannel,
    required this.theChannel,
    required this.publishedBy,
    required this.announcementDes,
    required this.profile,
    required this.reportCount,
    required this.reported,
    required this.roomNumber,
    required this.floorNumber,
  });

  @override
  State<AnnouncementDetailsScreen> createState() => _AnnouncementDetailsScreenState();
}

class _AnnouncementDetailsScreenState extends State<AnnouncementDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ChatMethods chatMethods = ChatMethods();

  bool sameUser() {
    if (widget.publisherID == _auth.currentUser!.uid.toString()) {
      return true;
    }
    return false;
  }

  //create chat room, then send the user to the conversation or chat screen to exchange messages
  void createChatRoomAndSendUserToConvScreen() {
    //get the current user id
    User? user = _auth.currentUser;
    String uid = user!.uid.toString();
    //users id list in the form of String
    List<String> users = [uid, widget.publisherID];
    //users names
    String myName = chatMethods.getUsername(uid);
    String peerName = widget.publishedBy;
    String usersNames = "${myName}_$peerName";
    //generating the chatroom id
    String chatroomID = chatMethods.generateChatroomId(uid, widget.publisherID);
    //chatroom info
    Map<String, dynamic> chatroomMap = {
      "users": users,
      "chatroomID": chatroomID,
      "usersNames": usersNames,
      "lastMessage": "",
    };
    chatMethods.createChatRoom(chatroomID, chatroomMap);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PrivateChatScreen(chatroomID, peerId: widget.publisherID)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (widget.profile) {
                Navigator.pop(context);
              } else if (widget.announcementType == 'lost') {
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: const Text(
          'Announcement Details',
        ),
        actions: [
          if (widget.profile)
            IconButton(
                onPressed: () {
                  _delete(context);
                },
                icon: const Icon(
                  Icons.delete_forever,
                  size: 30,
                )),
          if (!sameUser())
            IconButton(
                onPressed: () {
                  report();
                },
                icon: const Icon(
                  Icons.report,
                  size: 30,
                )),
          widget.profile
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                        //back button
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditAnnouncement(
                            announcementID: widget.announcementID,
                            itemName: widget.itemName,
                            announcementType: widget.announcementType,
                            itemCategory: widget.itemCategory,
                            postDate: widget.postDate,
                            announcementImg: widget.announcementImg,
                            buildingName: widget.buildingName,
                            contactChannel: widget.contactChannel,
                            theChannel: widget.theChannel,
                            publishedBy: widget.publishedBy,
                            announcementDes: widget.announcementDes,
                            roomNumber: widget.roomNumber,
                            floorNumber: widget.floorNumber,
                          ),
                        ));
                  },
                  icon: const Icon(Icons.edit))
              : const Text('')
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: widget.announcementImg != ""
                      ? Image.network(
                          widget.announcementImg,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.image,
                                size: 120,
                                color: Colors.grey,
                              ),
                              Text(
                                "No image was uploaded",
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        )),
            ),
            const SizedBox(
              height: 14,
            ),
            sameUser() == false
                ? GestureDetector(
                    onTap: () {
                      createChatRoomAndSendUserToConvScreen();
                    },
                    child: Center(
                      child: Container(
                        width: 130,
                        decoration: BoxDecoration(
                          color: Constants.darkBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          children: const [
                            Text(
                              "Message",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.chat,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const Text(""),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration:
                    BoxDecoration(color: Colors.blue[400], borderRadius: BorderRadius.circular(20)),
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    //announcement type
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Announcement type:  ${widget.announcementType}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    //item name
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Item name:  ${widget.itemName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    //item category
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Item category:  ${widget.itemCategory}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    //building name
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Location:\n   Building: ${widget.buildingName}\n   Floor: ${widget.floorNumber}\n   Room: ${widget.roomNumber}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    //description
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Description: ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.announcementDes,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Constants.darkBlue,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    //publisher Name
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Published by:  ${widget.publishedBy}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    //another contact channel based on the user's choice
                    widget.contactChannel == "Phone Number"
                        ? Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Phone number:  ${widget.theChannel} ',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Email:  ${widget.theChannel}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _delete(context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(24.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete,
                size: 30,
                color: Constants.darkBlue,
              ),
              const SizedBox(width: 8.0),
              Flexible(
                child: Text(
                  "Delete Announcement",
                  style: TextStyle(
                      color: Constants.darkBlue, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          //Log out confirmation message
          content: Text(
            "Are you sure you want to delete ${widget.itemName} ?",
            maxLines: 2,
            style: TextStyle(color: Constants.darkBlue, fontSize: 20, fontStyle: FontStyle.italic),
          ),
          actions: [
            //Cancel button > back to the drawer
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                if (widget.announcementType == 'lost') {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.update_sharp,
                                size: 30,
                                color: Constants.darkBlue,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Update Status",
                                style: TextStyle(
                                    color: Constants.darkBlue,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        content: Text(
                          "Did you find ${widget.itemName}?",
                          maxLines: 2,
                          style: TextStyle(
                            color: Constants.darkBlue,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              await GlobalMethods.incrementDeleteItemCount();
                              await deletedDbAnnouncement("lostItem");
                            },
                            child: const Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await deletedDbAnnouncement("lostItem");
                            },
                            child: const Text(
                              "NO",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.update_sharp,
                                size: 30,
                                color: Constants.darkBlue,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Update States",
                                style: TextStyle(
                                    color: Constants.darkBlue,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        content: Text(
                          "Did you return ${widget.itemName} to her owner?",
                          maxLines: 2,
                          style: TextStyle(
                            color: Constants.darkBlue,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              await GlobalMethods.incrementDeleteItemCount();
                              await deletedDbAnnouncement("foundItem");
                            },
                            child: const Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await deletedDbAnnouncement("foundItem");
                            },
                            child: const Text(
                              "NO",
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> deletedDbAnnouncement(String collection) async {
    await FirebaseFirestore.instance.collection(collection).doc(widget.announcementID).delete();

    if (!mounted) return;
    Navigator.pop(context);
    Navigator.pop(context);
    Fluttertoast.showToast(
      msg: "Announcement has been deleted successfully!",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.blueGrey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> report() async {
    //print(count);
    if (widget.reported != true) {
      var count = widget.reportCount;
      count++;
      debugPrint(count.toString());
      if (widget.reportCount == 2) {
        await FirebaseFirestore.instance.collection('reportedItem').doc(widget.announcementID).set({
          'announcementID': widget.announcementID,
          'publishedBy': widget.publishedBy,
          'itemName': widget.itemName,
          'itemCategory': widget.itemCategory,
          'announcementDes': widget.announcementDes,
          'announcementType': widget.announcementType,
          'contact': widget.theChannel,
          'url': widget.announcementImg,
          'buildingName': widget.buildingName,
          'annoucementDate': widget.postDate,
          'roomnumber': widget.roomNumber,
          'floornumber': widget.floorNumber,
          'reported': true,
          'reportCount': count,
        });
        if (widget.announcementType == 'lost') {
          await FirebaseFirestore.instance
              .collection('lostItem')
              .doc(widget.announcementID)
              .update({
            'reported': true,
            'reportCount': count,
          });
        } else {
          await FirebaseFirestore.instance
              .collection('foundItem')
              .doc(widget.announcementID)
              .update({
            'reported': true,
            'reportCount': count,
          });
        }
      } else {
        if (widget.announcementType == 'lost') {
          await FirebaseFirestore.instance
              .collection('lostItem')
              .doc(widget.announcementID)
              .update({'reportCount': count++});
        } else {
          await FirebaseFirestore.instance
              .collection('foundItem')
              .doc(widget.announcementID)
              .update({'reportCount': count++});
        }
      }
    }
    if (mounted) Navigator.pop(context);

//A confirmation message when the announcement is added
    Fluttertoast.showToast(
      msg: "Announcement has been reported successfully!\nFindly team thanks you!",
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.blueGrey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
