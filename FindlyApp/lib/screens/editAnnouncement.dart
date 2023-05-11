import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/constants/reference_data.dart';
import 'package:findly_app/screens/dialogflow_chatbot_screen.dart';
import 'package:findly_app/screens/widgets/wide_button.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:findly_app/services/push_notifications_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/constants.dart';
import '../constants/global_colors.dart';
import '../constants/text_styles.dart';

class EditAnnouncement extends StatefulWidget {
  final String announcementID;
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
  final String roomNumber;
  final String floorNumber;

  //constructor to require the announcement's information
  const EditAnnouncement({
    super.key,
    required this.announcementID,
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
    required this.roomNumber,
    required this.floorNumber,
  });

  @override
  State<EditAnnouncement> createState() => _EditAnnouncement();
}

class _EditAnnouncement extends State<EditAnnouncement> {
  //Create a Firebase Authentication instance

  late String itemName = widget.itemName;
  late String buildingName = widget.buildingName;
  late String annType = widget.announcementType;
  late String annCategory = widget.itemCategory;
  late String oldCategory = widget.itemCategory;
  late String newCategory = widget.itemCategory;
  late String contactChanel = widget.contactChannel;
  late String imageUrl = widget.announcementImg;
  late String annDesc = widget.announcementDes;
  late String floorNumber = widget.floorNumber;
  late String roomNumber = widget.roomNumber;

  late final TextEditingController _itemName =
      TextEditingController(text: widget.itemName);
  late final TextEditingController _annDesc =
      TextEditingController(text: widget.announcementDes);
  late final TextEditingController _floorNumber =
      TextEditingController(text: widget.floorNumber);
  late final TextEditingController _roomNumber =
      TextEditingController(text: widget.roomNumber);

  File? imgFile;

  final FocusNode _itemNameFocusNode = FocusNode();
  final FocusNode _buildingNameFocusNode = FocusNode();
  final FocusNode _annTypeFocusNode = FocusNode();
  final FocusNode _contactChannelFocusNode = FocusNode();
  final FocusNode _annDesFocusNode = FocusNode();
  final FocusNode _annCategoryFocusNode = FocusNode();
  final FocusNode _floorNumberFocusNode = FocusNode();
  final FocusNode _roomNumberFocusNode = FocusNode();
  final _editFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String dropDownValue = '';
  final FirebaseAuth _auth =FirebaseAuth.instance;

  @override
  void dispose() {
    //dispose from device memory so its performance isn't affected
    _itemName.dispose();
    _annDesc.dispose();
    _itemNameFocusNode.dispose();
    _buildingNameFocusNode.dispose();
    _annTypeFocusNode.dispose();
    _contactChannelFocusNode.dispose();
    _annDesFocusNode.dispose();
    _annCategoryFocusNode.dispose();
    _floorNumber.dispose();
    _roomNumber.dispose();
    _floorNumberFocusNode.dispose();
    _roomNumberFocusNode.dispose();
    super.dispose();
  }

  //Method for picking announcement image using camera
  void _pickImageUsingCamera() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxHeight: 1080, maxWidth: 1080);
    //to show the image to the user
    setState(() {
      imgFile = File(pickedFile!.path);
    });
  }

  //Method for picking announcement image using gallery
  void _pickImageUsingGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
    //to show the image to the user
    setState(() {
      imgFile = File(pickedFile!.path);
    });
  }

  //Method to update the announcement in the database
  void submitFormOnUpdate() async {
    final User? user = _auth.currentUser;
    final String uid = user!.uid;
    final String uniqueImgID = DateTime.now().millisecondsSinceEpoch.toString();
    if (imgFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('$uniqueImgID.jpg');
      await ref.putFile(imgFile!);
      imageUrl = await ref.getDownloadURL();
    }
    // else {
    //   imageUrl = "";
    // }
    final isValid = _editFormKey.currentState!.validate();
    if (mounted) FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        if (annType == 'lost') {
          await FirebaseFirestore.instance
              .collection('lostItem')
              .doc(widget.announcementID)
              .update({
            'itemName': itemName,
            'itemCategory': annCategory,
            'announcementDes': annDesc,
            'announcementType': annType,
            'contact': contactChanel,
            'url': imageUrl,
            'buildingName': buildingName,
            'roomnumber': roomNumber,
            'floornumber': floorNumber
          });

          if(newCategory != oldCategory){
            try{List<String> publishers =
            await getPublishers(isLost: true, cat: annCategory);
            if (publishers.isNotEmpty) {
              log("all Publishers:  ${publishers.toString()}");
              List<String> fcms = [];
              await Future.forEach(publishers, (element) async {
                var user = allUsers.firstWhere((user) => user['id'] == element,
                    orElse: () => {});
                if (user == {}) {
                  throw Exception("User Not found");
                }
                log("\n\nUser: $user\n\n");
                String userFcm = user['fcm'] ?? "";
                if (userFcm.isNotEmpty) {
                  fcms.add(userFcm);
                }
                String notificationTime = Timestamp.now().toString();
                if (element != uid) {
                  await InAppNotifications.sendInAppNotification(
                      notificationTime,
                      InAppNotifications.buildInAppNotification(
                        notificationTime,
                        "Hi, I have lost $itemName in $annCategory",
                        element,
                        "Lost item",
                        uid,
                        widget.announcementID,
                        "lost",
                      ));
                }
              });
              log("All FCMs: ${fcms.length}");
              await Future.delayed(const Duration(seconds: 1));
              if (fcms.isNotEmpty) {
                await PushNotificationController.sendPushNotification(
                    fcms, "Item Lost", "Hi, I Lost $itemName in $annCategory");
              }
            }}
                catch(e){
              log("message${e.toString()}");
            }
          }
        } else {
          await FirebaseFirestore.instance
              .collection('foundItem')
              .doc(widget.announcementID)
              .update({
            'itemName': itemName,
            'itemCategory': annCategory,
            'announcementDes': annDesc,
            'announcementType': annType,
            'contact': contactChanel,
            'url': imageUrl,
            'buildingName': buildingName,
            'roomnumber': roomNumber,
            'floornumber': floorNumber
          });

          if(newCategory != oldCategory){
            try {
              List<String> publishers =
              await getPublishers(isLost: false, cat: annCategory);
              if (publishers.isNotEmpty) {
                log("all Publishers:  ${publishers.toString()}");
                List<String> fcms = [];
                await Future.forEach(publishers, (element) async {
                  var user = allUsers.firstWhere((user) => user['id'] == element,
                      orElse: () => {});
                  if (user == {}) {
                    throw Exception("User Not found");
                  }
                  log("\n\nUser: $user\n\n");
                  String userFcm = user['fcm'] ?? "";
                  if (userFcm.isNotEmpty) {
                    fcms.add(userFcm);
                  }
                  String notificationTime = Timestamp.now().toString();
                  if (element != uid) {
                    await InAppNotifications.sendInAppNotification(
                        notificationTime,
                        InAppNotifications.buildInAppNotification(
                          notificationTime,
                          " Hi, I have found $itemName in $annCategory",
                          element,
                          "Found item",
                          uid,
                          widget.announcementID,
                          "found",
                        ));
                  }
                });
                log("All FCMs: ${fcms.length}");
                await Future.delayed(const Duration(seconds: 1));
                if (fcms.isNotEmpty) {
                  PushNotificationController.sendPushNotification(fcms,
                      "Item Found", " Hi, I have found $itemName in $annCategory");
                }
              }
            } catch (e) {
              log("message${e.toString()}");
            }
          }
        }
        if (mounted) Navigator.canPop(context) ? Navigator.pop(context) : null;
        //A confirmation message when the announcement is updated
        GlobalMethods.showToast(
          "Announcement has been updated successfully!",
        );
      } catch (error) {
        setState(() {});
        setState(() {
          _isLoading = false;
        });
        //if an error occurs a pop-up message
        GlobalMethods.showErrorDialog(
            error: error.toString(), context: context);
        debugPrint("error occurred $error");
      }
    } else {
      debugPrint("form not valid!");
    }
    setState(() {});
  }

  List<Map<String, dynamic>> allUsers = [];
  getAllUsers() async {
    QuerySnapshot qs =
    await FirebaseFirestore.instance.collection("users").get();

    allUsers = qs.docs.map((e) => e.data() as Map<String, dynamic>).toList();
    log("All Users: $allUsers");
  }

  Future<List<String>> getPublishers({required bool isLost, cat}) async {
    String collection = isLost ? "foundItem" : "lostItem";
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where("itemCategory", isEqualTo: annCategory)
        .get();
    return snapshot.docs
        .map(
            (e) => (e.data() as Map<String, dynamic>)['publishedBy'].toString())
        .toSet()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: scaffoldColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Edit Announcement",
          style: TextStyles.appBarTitleStyle,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height / 2,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.0),
                  bottomRight: Radius.circular(24.0),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 24.0,
                    top: 100.0,
                    right: 24.0,
                    bottom: 24.0,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: kElevationToShadow[3],
                  ),
                  child: Form(
                    key: _editFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        //Announcement type

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
                                  "${widget.announcementType.toUpperCase()} ITEM",
                                  style: TextStyles
                                      .alertDialogueMainButtonTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        //Item name
                        const Text(
                          'Item name *',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          focusNode: _itemNameFocusNode,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_annCategoryFocusNode),
                          maxLength: 50,
                          controller: _itemName,
                          onFieldSubmitted: (String value) {
                            debugPrint(value);
                          },
                          onChanged: (value) {
                            itemName = value;
                            debugPrint(value);
                          },
                          decoration: const InputDecoration(
                            hintText: "Enter Item name ",
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            )),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                )),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'You must fill this field';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Category
                        Row(
                          children:  [
                            const Text(
                              'Item category *',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4,),
                            const Text(" Need help? "),
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DialogflowChatBotScreen(),
                                  ),
                                );
                              },
                              child: AnimatedAlign(duration:const Duration(minutes: 2),curve:Curves.bounceIn,alignment:Alignment.centerLeft,child: Image.asset("assets/chatbot.png",width: MediaQuery.of(context).size.width*0.08,)),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        DropdownButtonFormField(
                            focusNode: _annCategoryFocusNode,
                            isExpanded: true,
                            decoration: kInputDecoration,
                            items: [
                              const DropdownMenuItem<String>(
                                  value: '',
                                  child: Text(
                                    'Choose Item category',
                                    style: TextStyle(color: Colors.grey),
                                  )),
                              ...ReferenceData.instance.categories
                                  .map(
                                    (categoryName) => DropdownMenuItem<String>(
                                      value: categoryName,
                                      child: Text(
                                        categoryName,
                                        maxLines: 3,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              // const DropdownMenuItem<String>(
                              //   value: 'Others',
                              //   child: Text('Others'),
                              // ),
                            ],
                            onChanged: (value) {
                              annCategory = value.toString();
                              setState(() {
                                annCategory = value.toString();
                                newCategory = annCategory;
                              });
                              FocusScope.of(context)
                                  .requestFocus(_buildingNameFocusNode);
                            },
                            validator: (value) {
                              if (value == '') {
                                return 'You must choose';
                              }
                              return null;
                            },
                            value: widget.itemCategory),
                        const SizedBox(
                          height: 20,
                        ),
                        //Building name
                        const Text(
                          'Building name',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        DropdownButtonFormField(
                          focusNode: _buildingNameFocusNode,
                          isExpanded: true,
                          decoration: kInputDecoration,
                          items: [
                            const DropdownMenuItem<String>(
                              value: '',
                              child: Text(
                                'Choose Building name',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            ...ReferenceData.instance.locations
                                .map(
                                  (buildingName) => DropdownMenuItem<String>(
                                    value: buildingName,
                                    child: Text(
                                      buildingName,
                                      maxLines: 3,
                                    ),
                                  ),
                                )
                                .toList(),
                          ],
                          value: widget.buildingName,
                          onChanged: (value) {
                            buildingName = value.toString();
                            setState(() {
                              buildingName = value.toString();
                            });

                            FocusScope.of(context)
                                .requestFocus(_annDesFocusNode);
                          },
                        ),

                        const SizedBox(
                          height: 20.0,
                        ),
                        const Text(
                          'Floor number ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          focusNode: _floorNumberFocusNode,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_roomNumberFocusNode),
                          maxLength: 5,
                          controller: _floorNumber,
                          onFieldSubmitted: (String value) {
                            debugPrint(value);
                          },
                          onChanged: (value) {
                            floorNumber = value;
                            debugPrint(value);
                          },
                          decoration: const InputDecoration(
                            hintText: "Enter Floor number ",
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            )),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                )),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text(
                          'Room number ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          focusNode: _roomNumberFocusNode,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_annCategoryFocusNode),
                          maxLength: 5,
                          controller: _roomNumber,
                          onFieldSubmitted: (String value) {
                            debugPrint(value);
                          },
                          onChanged: (value) {
                            roomNumber = value;
                            debugPrint(value);
                          },
                          decoration: const InputDecoration(
                            hintText: "Enter Room number ",
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            )),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                )),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        //Announcement description
                        const Text(
                          'Announcement description *',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          focusNode: _annDesFocusNode,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_contactChannelFocusNode),
                          controller: _annDesc,
                          minLines: 2,
                          maxLines: 5,
                          maxLength: 256,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.description_outlined),
                            hintText: "Maximum 256 character",
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            )),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                )),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                          onChanged: (value) {
                            annDesc = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'You must enter some description of the item ';
                            }
                            return null;
                          },
                        ),
                        // for description
                        const SizedBox(
                          height: 20.0,
                        ),

                        //Contact channel
                        const Text(
                          'Another contact channel you prefer *',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        DropdownButtonFormField(
                            focusNode: _contactChannelFocusNode,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              )),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16),
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                            items: const [
                              DropdownMenuItem<String>(
                                  value: '',
                                  child: Text(
                                    'Choose  a channel',
                                    style: TextStyle(color: Colors.grey),
                                  )),
                              DropdownMenuItem<String>(
                                  value: 'Phone Number',
                                  child: Text('Phone Number')),
                              DropdownMenuItem<String>(
                                  value: 'Email', child: Text('Email'))
                            ],
                            onChanged: (value) {
                              contactChanel = value.toString();
                              setState(() {
                                contactChanel = value.toString();
                              });
                            },
                            validator: (value) {
                              if (value == '') {
                                return 'You must choose';
                              }
                              return null;
                            },
                            value: widget.contactChannel),
                        const SizedBox(
                          height: 25.0,
                        ),

                        if (imageUrl == '' && imgFile == null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryColor, width: 3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            height: 200,
                            width: 200,
                            child: const Icon(
                              Icons.hide_image_outlined,
                              size: 100,
                              color: Colors.blueGrey,
                            ),
                          )
                        else if (imageUrl != '' && imgFile == null)
                          Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: primaryColor,
                                  width: 3,
                                ),
                              ),
                              child: Image.network(
                                imageUrl,
                              ))
                        else if (imageUrl == '' && imgFile != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryColor, width: 3),
                            ),
                            child: Image.file(
                              imgFile!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        imageUrl == '' && imgFile == null
                            ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                        primaryColor.withOpacity(0.8),
                                      ),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    //Button to upload image
                                    child: const Text('Upload item image'),
                                    onPressed: () async {
                                      showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: 200,
                                            color: Colors.grey[200],
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            9.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Text(
                                                          'Gallery',
                                                          style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 100,
                                                          width: 100,
                                                          child: IconButton(
                                                              onPressed: () {
                                                                //pick by gallery
                                                                _pickImageUsingGallery();
                                                              },
                                                              icon:
                                                                  const SizedBox(
                                                                height: 100,
                                                                width: 100,
                                                                child:
                                                                    CircleAvatar(
                                                                  child: Icon(
                                                                    Icons
                                                                        .photo_size_select_actual_outlined,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 50,
                                                                  ),
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                        'Camera',
                                                        style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 100,
                                                        width: 100,
                                                        child: IconButton(
                                                            onPressed: () {
                                                              //pick by camera
                                                              _pickImageUsingCamera();
                                                            },
                                                            icon:
                                                                const SizedBox(
                                                              height: 100,
                                                              width: 100,
                                                              child:
                                                                  CircleAvatar(
                                                                child: Icon(
                                                                  Icons
                                                                      .camera_alt_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 50,
                                                                ),
                                                              ),
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                        primaryColor.withOpacity(0.8),
                                      ),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    //Button to cancel the uploaded image
                                    child: const Text('Cancel image'),
                                    onPressed: () {
                                      setState(
                                        () {
                                          imageUrl = '';
                                          imgFile = null;
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                //edit announcement button
                _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              backgroundColor: primaryColor,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                        ),
                        child: WideButton(
                          choice: 1,
                          width: double.infinity,
                          title: "Edit announcement!",
                          onPressed: () {
                            final isValid = _editFormKey.currentState!
                              .validate();
                          if (!mounted) return;
                          FocusScope.of(context).unfocus();
                          if (isValid) {
                              GlobalMethods.showCustomizedDialogue(
                                  title:
                                  "Edit Announcement",
                                  message: "Are you sure you want to edit this announcement?",
                                  mainAction: "Yes",
                                  context: context,
                                  secondaryAction: "No",
                                  onPressedMain: () {
                                    submitFormOnUpdate();
                                    Navigator.pop(context);
                                  },
                                  onPressedSecondary: () {
                                    Navigator.pop(context);
                                  });
                          }
                          else {
                            debugPrint("form not valid!");
                          }},
                        ),
                      ),
                //Cancel button
                _isLoading
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 0,
                        ),
                        child: WideButton(
                          choice: 2,
                          width: double.infinity,
                          title: "Cancel",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
