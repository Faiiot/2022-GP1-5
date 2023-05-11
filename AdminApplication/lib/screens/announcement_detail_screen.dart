import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/constants/constants.dart';
import 'package:findly_admin/screens/widgets/wide_button.dart';
import 'package:findly_admin/services/global_methods.dart';
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
  final bool reportsScreen;

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
    required this.reportsScreen,
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
  String floor ="";
  String room = "";
  bool fetchingData = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

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

    floor =floorNumber;
    room = roomNumber;
    if (floorNumber.isNotEmpty){
      setState(() {
        floor = ", Floor: $floor";
      });

      if(roomNumber.isNotEmpty){
        setState(() {
          room = ", Room: $room";
        });
      }
    }else{setState(() {
      room = "";
    });}

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
                      height: 400,
                      width: double.infinity,
                      child: announcementImg != ""
                          ? Image.network(
                              announcementImg,
                              fit: BoxFit.fill,
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
                          buildingName.isNotEmpty?
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
                                    "$buildingName $floor $room",
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          )
                              :
                          const SizedBox.shrink(),
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
                    const SizedBox(
                      height: 16,
                    ),
                    widget.reportsScreen?
                    Container(
                      height: 1.0,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor,

                            blurRadius: 6,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    )
                    :
                        const SizedBox.shrink(),
                    const SizedBox(
                      height: 16,
                    ),
                    widget.reportsScreen?
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFA44237),
                                    Colors.redAccent,
                                  ],
                                ),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  GlobalMethods.showCustomizedDialogue(
                                      title: "Delete announcement",
                                      message:
                                          "Are you sure you want to delete this announcement?",
                                      mainAction: "Yes",
                                      context: context,
                                      secondaryAction: "No",
                                      onPressedMain: () {
                                        _adminDelete();
                                        Navigator.pop(context);
                                        GlobalMethods.showToast(
                                            "Announcement has been deleted successfuly!");
                                        Navigator.pop(context);
                                      },
                                      onPressedSecondary: () =>
                                          Navigator.pop(context));
                                },
                                minWidth: double.infinity,
                                height: 48,
                                child: Text(
                                  "Delete",
                                  style: TextStyles.buttonTextStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        WideButton(
                            choice: 1,
                            title: "Decline",
                            onPressed: () {
                              GlobalMethods.showCustomizedDialogue(
                                  title: "Decline reports",
                                  message:
                                      "Are you sure you want to decline reports on this announcement?",
                                  mainAction: "Yes",
                                  context: context,
                                  secondaryAction: "No",
                                  onPressedMain: () {
                                    _decline();
                                    Navigator.pop(context);
                                    GlobalMethods.showToast(
                                        "Reports on this announcement has been declined");
                                    Navigator.pop(context);
                                  },
                                  onPressedSecondary: () =>
                                      Navigator.pop(context));
                            },
                            width: double.infinity),
                      ],
                    )
                        :
                        const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
    );
  }

  void _adminDelete(){
    String collection = announcementType == "lost" ? "lostItem" : "foundItem";
    FirebaseFirestore.instance
        .collection(collection)
        .doc(widget.announcementID)
        .delete();
    String notificationID;
       final doc = FirebaseFirestore.instance
        .collection("notifications")
        .where('source_id', isEqualTo: widget.announcementID).get().then((value) async => {
          value.docs.forEach((element) {
            notificationID = element['notificationID'].toString();
             FirebaseFirestore.instance
            .collection("notifications")
            .doc(notificationID)
            .delete();
          })
    });
    if (!mounted) return;
  }

  void _decline() {
    String collection = announcementType == "lost" ? "lostItem" : "foundItem";
    FirebaseFirestore.instance
        .collection(collection)
        .doc(widget.announcementID)
        .update({
      'reported': false,
      'reportCount': 0,
    });
  }
}
