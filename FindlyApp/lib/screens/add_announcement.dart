import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/screens/user_dashboard_screen.dart';
import 'package:findly_app/screens/widgets/my_button.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../constants/constants.dart';
import '../constants/reference_data.dart';

class AddAnnouncementScreen extends StatefulWidget {
  const AddAnnouncementScreen({super.key});

  @override
  State<AddAnnouncementScreen> createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  //Create a Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String annDesc;
  late String annType;
  late String itemName;
  late String annCategory;
  late String contactChanel;
  String imageUrl = '';
  String roomNumber = '';
  String floorNumber = '';
  String buildingName = '';
  String dropDownValue = '';

  late final TextEditingController _itemName = TextEditingController(text: '');
  late final TextEditingController _annDesc = TextEditingController(text: '');
  late final TextEditingController _floorNumber = TextEditingController(text: '');
  late final TextEditingController _roomNumber = TextEditingController(text: '');
  File? imgFile;

  final FocusNode _itemNameFocusNode = FocusNode();
  final FocusNode _buildingNameFocusNode = FocusNode();
  final FocusNode _annTypeFocusNode = FocusNode();
  final FocusNode _contactChannelFocusNode = FocusNode();
  final FocusNode _annDesFocusNode = FocusNode();
  final FocusNode _annCategoryFocusNode = FocusNode();
  final FocusNode _floorNumberFocusNode = FocusNode();
  final FocusNode _roomNumberFocusNode = FocusNode();

  final _addFormKey = GlobalKey<FormState>();

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
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, maxHeight: 1080, maxWidth: 1080);
    //to show the image to the user
    setState(() {
      imgFile = File(pickedFile!.path);
    });
  }

  //Method for picking announcement image using gallery
  void _pickImageUsingGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
    //to show the image to the user
    setState(() {
      imgFile = File(pickedFile!.path);
    });
  }

  //Method to add the announcement to the database
  void submitFormOnAdd() async {
    final User? user = _auth.currentUser;
    final String uid = user!.uid;
    final String uniqueImgID = DateTime.now().millisecondsSinceEpoch.toString();
    if (imgFile != null) {
      final ref = FirebaseStorage.instance.ref().child('images').child('$uniqueImgID.jpg');
      await ref.putFile(imgFile!);
      imageUrl = await ref.getDownloadURL();
    } else {
      imageUrl = "";
    }
    final isValid = _addFormKey.currentState!.validate();
    if (!mounted) return;
    FocusScope.of(context).unfocus();

    if (isValid) {
      final announcementID = const Uuid().v4();
      setState(() {
      });
      try {
        if (annType == 'lost') {
          await FirebaseFirestore.instance.collection('lostItem').doc(announcementID).set({
            'announcementID': announcementID,
            'publishedBy': uid,
            'itemName': itemName,
            'itemCategory': annCategory,
            'announcementDes': annDesc,
            'announcementType': annType,
            'contact': contactChanel,
            'url': imageUrl,
            'buildingName': buildingName,
            'annoucementDate': DateTime.now(),
            'roomnumber': roomNumber,
            'floornumber': floorNumber,
            'reported': false,
            'found': false
          });
        } else {
          await FirebaseFirestore.instance.collection('foundItem').doc(announcementID).set({
            'announcementID': announcementID,
            'publishedBy': uid,
            'itemName': itemName,
            'itemCategory': annCategory,
            'announcementDes': annDesc,
            'announcementType': annType,
            'contact': contactChanel,
            'url': imageUrl,
            'buildingName': buildingName,
            'annoucementDate': DateTime.now(),
            'roomnumber': roomNumber,
            'floornumber': floorNumber,
            'reported': false,
            'returned': false
          });
        }
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          "userAnnouncement": FieldValue.arrayUnion([announcementID])
        });
        if (!mounted) return;
        Navigator.canPop(context) ? Navigator.pop(context) : null;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserDashboardScreen(
              userID: uid,
            ),
          ),
        );
        //A confirmation message when the announcement is added
        Fluttertoast.showToast(
          msg: "Announcement has been added successfully!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (error) {
        setState(() {
        });
        //if an error occurs a pop-up message
        GlobalMethods.showErrorDialog(error: error.toString(), context: context);
        debugPrint("error occurred $error");
      }
    } else {
      debugPrint("form not valid!");
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Announcement Form',
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _addFormKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //Announcement type
              const Text(
                'Announcement type *',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              DropdownButtonFormField(
                  isExpanded: true,
                  decoration: kInputDecoration,
                  items: const [
                    DropdownMenuItem<String>(
                        value: '',
                        child: Text(
                          'Choose Announcment type',
                          style: TextStyle(color: Colors.grey),
                        )),
                    DropdownMenuItem<String>(
                      value: 'lost',
                      child: Text('Lost announcement'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'found',
                      child: Text('Found announcement'),
                    ),
                  ],
                  onChanged: (value) {
                    annType = value.toString(); //check iff it works
                    setState(() {
                      annType = value.toString(); //check iff it works
                    });
                    FocusScope.of(context).requestFocus(_itemNameFocusNode);
                  },
                  validator: (value) {
                    if (value == '') {
                      return 'You must choose';
                    }
                    return null;
                  },
                  value: dropDownValue),
              const SizedBox(
                height: 20,
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
                onEditingComplete: () => FocusScope.of(context).requestFocus(_annCategoryFocusNode),
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
                    Radius.circular(10),
                  )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
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

              // Categury
              const Text(
                'Item category *',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
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
                    // DropdownMenuItem<String>(child: Text('Electronic devices'), value: 'Electronic devices'),
                    // DropdownMenuItem<String>(child: Text('Electronic accessories'), value: 'Electronic accessories'),
                    // DropdownMenuItem<String>(child: Text('Jewelry'), value: 'Jewelry'),
                    // DropdownMenuItem<String>(child: Text('Medical equipments'), value: 'Medical equipments'),
                    // DropdownMenuItem<String>(child: Text('Personal accessories'), value: 'Personal accessories'),
                    const DropdownMenuItem<String>(
                      value: 'Others',
                      child: Text('Others'),
                    ),
                  ],
                  onChanged: (value) {
                    annCategory = value.toString();
                    setState(() {
                      annCategory = value.toString();
                    });
                    FocusScope.of(context).requestFocus(_buildingNameFocusNode);
                  },
                  validator: (value) {
                    if (value == '') {
                      return 'You must choose';
                    }
                    return null;
                  },
                  value: dropDownValue),
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
              // StreamBuilder<QuerySnapshot>(
              //     stream:FirebaseFirestore.instance.collection('location').snapshots(),
              //     builder: (context,snapshot){
              //       if(!snapshot.hasData){Text('Loading!');}
              //       else {
              //
              //         List<DropdownMenuItem> buildingNames=[];
              //         for(int i=0;i<snapshot.data!.docs.length;i++){
              //           DocumentSnapshot snap= snapshot.data!.docs[i];
              //           buildingNames.add(DropdownMenuItem(child: Text(snapshot.data!.docs[i]['buildingName'],),value: "${snapshot.data!.docs[i]['buildingName']}",));
              //         }
              //
              //       }
              //     }
              // ),
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
                  value: dropDownValue,
                  onChanged: (value) {
                    buildingName = value.toString();
                    setState(() {
                      buildingName = value.toString();
                    });

                    FocusScope.of(context).requestFocus(_annDesFocusNode);
                  }),

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
                onEditingComplete: () => FocusScope.of(context).requestFocus(_roomNumberFocusNode),
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
                    Radius.circular(10),
                  )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
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
                onEditingComplete: () => FocusScope.of(context).requestFocus(_annCategoryFocusNode),
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
                    Radius.circular(10),
                  )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
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
                onEditingComplete: () => FocusScope.of(context).requestFocus(_contactChannelFocusNode),
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
                    Radius.circular(10),
                  )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
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
                decoration: kInputDecoration,
                items: const [
                  DropdownMenuItem<String>(
                      value: '',
                      child: Text(
                        'Choose a channel',
                        style: TextStyle(color: Colors.grey),
                      )),
                  DropdownMenuItem<String>(
                    value: 'Phone Number',
                    child: Text('Phone Number'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Email',
                    child: Text('Email'),
                  )
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
                value: dropDownValue,
              ),
              const SizedBox(
                height: 25.0,
              ),
              imgFile == null
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 200,
                      width: 200,
                      child: const Icon(
                        Icons.hide_image_outlined,
                        size: 100,
                        color: Colors.blueGrey,
                      ))
                  : Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 3),
                      ),
                      child: Image.file(
                        imgFile!,
                        fit: BoxFit.cover,
                      ),
                    ),
              imgFile == null
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: ElevatedButton(
                          //Button to upload image
                          child: const Text('Upload item image'),
                          onPressed: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 200,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'Gallery',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
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
                                                    icon: const SizedBox(
                                                      height: 100,
                                                      width: 100,
                                                      child: CircleAvatar(
                                                        child: Icon(
                                                          Icons.photo_size_select_actual_outlined,
                                                          color: Colors.white,
                                                          size: 50,
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Camera',
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
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
                                                  icon: const SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: CircleAvatar(
                                                      child: Icon(
                                                        Icons.camera_alt_outlined,
                                                        color: Colors.white,
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
                              //Button to cancel the uploaded image
                              child: const Text('Cancel'),
                              onPressed: () {
                                setState(() {
                                  imgFile = null;
                                });
                                debugPrint(
                                  imgFile.toString(),
                                );
                              }))),
              //Add announcement button
              MyButton(
                  color: Colors.blue[700]!,
                  title: "Add announcement!",
                  onPressed: () {
                    submitFormOnAdd();
                  }),
              //Cancel button
              MyButton(
                  color: Colors.blue[700]!,
                  title: "Cancel",
                  onPressed: () {
                    User? user = _auth.currentUser;
                    String uid = user!.uid;

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDashboardScreen(userID: uid),
                        ));
                  }),
            ],
          )),
        ),
      ),
    );
  }
}
