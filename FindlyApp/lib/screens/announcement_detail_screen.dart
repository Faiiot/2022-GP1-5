import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/constants/constants.dart';
import 'package:findly_app/screens/editAnnouncement.dart';
import 'package:findly_app/screens/private_chat/chatMethods.dart';
import 'package:findly_app/screens/private_chat/private_chat_screen.dart';
import 'package:findly_app/screens/widgets/wide_button.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/dates.dart';
import '../constants/global_colors.dart';
import '../constants/text_styles.dart';

class AnnouncementDetailsScreen extends StatefulWidget {
  final String announcementID;
  final String publisherID;
  final String announcementType;
  final String phoneNumber;
  final String email;
  final String publishedBy;
  final bool profile;
  final bool reported;
  final int reportCount;

  //constructor to require the announcement's information
  const AnnouncementDetailsScreen({
    super.key,
    required this.announcementID,
    required this.publisherID,
    required this.announcementType,
    required this.phoneNumber,
    required this.email,
    required this.publishedBy,
    required this.profile,
    required this.reportCount,
    required this.reported,
  });

  @override
  State<AnnouncementDetailsScreen> createState() =>
      _AnnouncementDetailsScreenState();
}

class _AnnouncementDetailsScreenState extends State<AnnouncementDetailsScreen> {
  String itemName = "";
  String announcementType = "";
  String itemCategory = "";
  Timestamp postDate = Timestamp.fromDate(DateTime.now());
  String announcementImg = "";
  String buildingName = "";
  String contactChannel = "";
  String theChannel = "";
  String announcementDes = "";
  String roomNumber = "";
  String floorNumber = "";
  bool fetchingData = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  ChatMethods chatMethods = ChatMethods();

  bool sameUser() {
    if (widget.publisherID == _auth.currentUser!.uid.toString()) {
      return true;
    }
    return false;
  }

  void fetchAnnouncementDetails() async {
    final String collection =
        announcementType == "lost" ? "lostItem" : "foundItem";
    final doc = await FirebaseFirestore.instance
        .collection(collection)
        .where(
          "announcementID",
          isEqualTo: widget.announcementID,
        )
        .get();
    final announcement = doc.docs.first.data();
    itemName = announcement["itemName"];
    announcementType = announcement["announcementType"];
    itemCategory = announcement["itemCategory"];
    postDate = announcement["annoucementDate"];
    announcementImg = announcement["url"];
    buildingName = announcement['buildingName'];
    contactChannel = announcement['contact'];
    theChannel =
        contactChannel == "Phone Number" ? widget.phoneNumber : widget.email;
    announcementDes = announcement["announcementDes"];
    roomNumber = announcement["roomnumber"];
    floorNumber = announcement["floornumber"];
    setState(() {
      fetchingData = false;
    });
  }

  @override
  void initState() {
    super.initState();
    announcementType = widget.announcementType;
    fetchAnnouncementDetails();
  }

  //create chat room, then send the user to the conversation or chat screen to exchange messages
  void createChatRoomAndSendUserToConvScreen() async {
    //get the current user id
    User? user = _auth.currentUser;
    String uid = user!.uid.toString();
    //users id list in the form of String
    List<String> users = [uid, widget.publisherID];
    //users names
    String myName = await chatMethods.getUsername(uid);
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
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivateChatScreen(
          widget.publishedBy,
          chatroomID,
          peerId: widget.publisherID,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: primaryColor,
          ),
        ),
        title: Text(
          "Announcement Details",
          style: TextStyles.appBarTitleStyle.copyWith(color: primaryColor),
        ),
        actions: [
          if (widget.profile)
            IconButton(
                onPressed: () {
                  _delete(context);
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.redAccent,
                )),
          if (!sameUser())
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () async {
                  GlobalMethods.showCustomizedDialogue(
                      title:
                          "Are you sure you want to report this item announcement?",
                      mainAction: "Yes",
                      context: context,
                      secondaryAction: "No",
                      onPressedMain: () async {
                        await report();
                      },
                      onPressedSecondary: () {
                        Navigator.pop(context);
                      });
                },
                child: CircleAvatar(
                  backgroundColor: Colors.red.shade100,
                  radius: 18,
                  foregroundImage: const AssetImage(
                    "assets/report.png",
                  ),
                ),
              ),
            ),
          widget.profile
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditAnnouncement(
                          announcementID: widget.announcementID,
                          itemName: itemName,
                          announcementType: announcementType,
                          itemCategory: itemCategory,
                          postDate: postDate,
                          announcementImg: announcementImg,
                          buildingName: buildingName,
                          contactChannel: contactChannel,
                          theChannel: theChannel,
                          publishedBy: widget.publishedBy,
                          announcementDes: announcementDes,
                          roomNumber: roomNumber,
                          floorNumber: floorNumber,
                        ),
                      ),
                    ).then((value) => fetchAnnouncementDetails());
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: primaryColor,
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
      body: fetchingData
          ? const Center(
              child: CircularProgressIndicator(
                backgroundColor: primaryColor,
                color: Colors.white,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: announcementImg != ""
                          ? Image.network(
                              announcementImg,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.blue, width: 3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: Icon(
                                        Icons.image,
                                        size: 120,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "No image was uploaded",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black54,
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: GlobalColors.extraColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${announcementType.toUpperCase()} ITEM",
                              style:
                                  TextStyles.alertDialogueMainButtonTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 16.0,
                      ),
                      child: Text(
                        itemName,
                        style: TextStyles.secondButtonTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.category_outlined,
                                color: GlobalColors.mainColor,
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    itemCategory,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: GlobalColors.mainColor,
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "$buildingName, $floorNumber, $roomNumber",
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.date_range_outlined,
                                color: GlobalColors.mainColor,
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    Dates.parsedDate(postDate)
                                        .toString()
                                        .substring(0, 10),
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.account_box,
                                color: GlobalColors.mainColor,
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    widget.publishedBy,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Icon(
                                contactChannel == "Phone Number"
                                    ? Icons.phone
                                    : Icons.email,
                                color: GlobalColors.mainColor,
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    theChannel,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Card(
                            margin: const EdgeInsets.only(top: 16, bottom: 16),
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: GlobalColors.mainColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      "Description:",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      announcementDes,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
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
                    if (!sameUser()) ...[
                      Center(
                        child: WideButton(
                          choice: 1,
                          width: double.infinity,
                          title: "Chat!",
                          onPressed: () {
                            createChatRoomAndSendUserToConvScreen();
                          },
                        ),
                      ),
                      Center(
                        child: WideButton(
                          choice: 2,
                          width: double.infinity,
                          title: contactChannel == "Phone Number"
                              ? "Call Now"
                              : "Send an Email",
                          onPressed: () {
                            contactChannel == "Phone Number"
                                ? GlobalMethods.makePhoneCall(theChannel)
                                : GlobalMethods.sendEmail(theChannel);
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _delete(context) async {
    GlobalMethods.showCustomizedDialogue(
      context: context,
      title: "Delete Announcement",
      message: "Are you sure you want to delete $itemName?",
      mainAction: "OK",
      secondaryAction: "Cancel",
      onPressedMain: () async {
        Navigator.pop(context);
        if (announcementType == 'lost') {
          GlobalMethods.showCustomizedDialogue(
            context: context,
            title: "Update Status",
            message: "Did you find $itemName?",
            mainAction: "Yes",
            secondaryAction: "No",
            onPressedMain: () async {
              await GlobalMethods.incrementDeleteItemCount();
              await deletedDbAnnouncement("lostItem");
            },
            onPressedSecondary: () async {
              await deletedDbAnnouncement("lostItem");
            },
          );
        } else {
          GlobalMethods.showCustomizedDialogue(
            context: context,
            title: "Update States",
            message: "Did you return $itemName to her owner?",
            mainAction: "Yes",
            secondaryAction: "No",
            onPressedMain: () async {
              await GlobalMethods.incrementDeleteItemCount();
              await deletedDbAnnouncement("foundItem");
            },
            onPressedSecondary: () async {
              await deletedDbAnnouncement("foundItem");
            },
          );
        }
      },
      onPressedSecondary: () {
        Navigator.pop(context);
      },
    );
  }

  Future<void> deletedDbAnnouncement(String collection) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(widget.announcementID)
        .delete();
    if (!mounted) return;
    Navigator.pop(context);
    Navigator.pop(context);
    GlobalMethods.showToast(
      "Announcement has been deleted successfully!",
    );
  }

  Future<void> report() async {
    if (widget.reported != true) {
      var count = widget.reportCount;
      count++;
      debugPrint(count.toString());
      if (widget.reportCount == 2) {
        // await FirebaseFirestore.instance.collection('reportedItem').doc(widget.announcementID).set({
        //   'announcementID': widget.announcementID,
        //   'publishedBy': widget.publishedBy,
        //   'itemName': itemName,
        //   'itemCategory': itemCategory,
        //   'announcementDes': announcementDes,
        //   'announcementType': announcementType,
        //   'contact': theChannel,
        //   'url': announcementImg,
        //   'buildingName': buildingName,
        //   'annoucementDate': postDate,
        //   'roomnumber': roomNumber,
        //   'floornumber': floorNumber,
        //   'reported': true,
        //   'reportCount': count,
        // });
        if (announcementType == 'lost') {
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
        if (announcementType == 'lost') {
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
    GlobalMethods.showToast(
      "Announcement has been reported successfully!\nFindly team thanks you!",
    );
  }
}
