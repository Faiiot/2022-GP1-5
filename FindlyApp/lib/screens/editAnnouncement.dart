import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/screens/widgets/my_button.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

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
  late String contactChanel = widget.contactChannel;
  late String imageUrl = widget.announcementImg;
  late String annDesc = widget.announcementDes;
  late String floorNumber = widget.floorNumber;
  late String roomNumber = widget.roomNumber;

  late final TextEditingController _itemName = TextEditingController(text: widget.itemName);
  late final TextEditingController _annDesc = TextEditingController(text: widget.announcementDes);
  late final TextEditingController _floorNumber = TextEditingController(text: widget.floorNumber);
  late final TextEditingController _roomNumber = TextEditingController(text: widget.roomNumber);

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
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera, maxHeight: 1080, maxWidth: 1080);
    //to show the image to the user
    setState(() {
      imgFile = File(pickedFile!.path);
    });
  }

  //Method for picking announcement image using gallery
  void _pickImageUsingGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
    //to show the image to the user
    setState(() {
      imgFile = File(pickedFile!.path);
    });
  }

  //Method to add the announcement to the database
  void submitFormOnAdd() async {
    final String uniqueImgID = DateTime.now().millisecondsSinceEpoch.toString();
    if (imgFile != null) {
      final ref = FirebaseStorage.instance.ref().child('images').child('$uniqueImgID.jpg');
      await ref.putFile(imgFile!);
      imageUrl = await ref.getDownloadURL();
    } else {
      imageUrl = "";
    }
    final isValid = _addFormKey.currentState!.validate();
    if (mounted) FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {});
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
        }
        if (mounted) Navigator.canPop(context) ? Navigator.pop(context) : null;
        //A confirmation message when the announcement is added
        Fluttertoast.showToast(
          msg: "Announcement has been updated successfully!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (error) {
        setState(() {});
        //if an error occurs a pop-up message
        GlobalMethods.showErrorDialog(error: error.toString(), context: context);
        debugPrint("error occurred $error");
      }
    } else {
      debugPrint("form not valid!");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Announcement Form',
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
              Text(
                'Announcement type is ${widget.announcementType} announcement',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
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
              // Category
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
                decoration: const InputDecoration(
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
                items: const [
                  DropdownMenuItem<String>(
                      value: '',
                      child: Text(
                        'Choose Item category',
                        style: TextStyle(color: Colors.grey),
                      )),
                  DropdownMenuItem<String>(
                      value: 'Electronic devices', child: Text('Electronic devices')),
                  DropdownMenuItem<String>(
                      value: 'Electronic accessories', child: Text('Electronic accessories')),
                  DropdownMenuItem<String>(value: 'Jewelry', child: Text('Jewelry')),
                  DropdownMenuItem<String>(
                      value: 'Medical equipments', child: Text('Medical equipments')),
                  DropdownMenuItem<String>(
                      value: 'Personal accessories', child: Text('Personal accessories')),
                  DropdownMenuItem<String>(value: 'Others', child: Text('Others')),
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
                value: widget.itemCategory,
              ),
              const SizedBox(
                height: 20,
              ),
              //Building name
              const Text(
                'Bullding name',
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
                  decoration: const InputDecoration(
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
                  items: const [
                    DropdownMenuItem<String>(
                        value: '',
                        child: Text(
                          'Choose Bullding name',
                          style: TextStyle(color: Colors.grey),
                        )),
                    DropdownMenuItem<String>(
                        value: 'College of Education',
                        child: Text(
                          'College of Education',
                          maxLines: 3,
                        )),
                    DropdownMenuItem<String>(
                        value: 'College of Arts', child: Text('College of Arts', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'College of Tourism & Cultural Heritage',
                        child: Text('College of Tourism & Cultural Heritage', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'College of Languages & Translation',
                        child: Text('College of Languages & Translation', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'College of Law & Political Science',
                        child: Text('College of Law & Political Science', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'College of Business Administration',
                        child: Text('College of Business Administration', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'College of Nursing',
                        child: Text('College of Nursing', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'College of Pharmacy',
                        child: Text('College of Pharmacy', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'College of Medicine',
                        child: Text('College of Medicine', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'College of Applied Medical Sciences',
                        child: Text('College of Applied Medical Sciences', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'College of Dentistry',
                        child: Text('College of Dentistry', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'College of science',
                        child: Text('College of science', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'College of Agricultural and Food Scinces',
                        child: Text('College of Agricultural and Food Scinces', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'College of Computer & Information Scinces',
                        child: Text('College of Computer & Information Scinces', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'College of Sport Scinces & Physical Activity',
                        child: Text('College of Sport Scinces & Physical Activity', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'ACollege of Architecture & PlanningP',
                        child: Text('College of Architecture & Planning', maxLines: 3)),
                    DropdownMenuItem<String>(value: 'Gate#1', child: Text('Gate#1', maxLines: 3)),
                    DropdownMenuItem<String>(value: 'Gate#2', child: Text('Gate#2', maxLines: 3)),
                    DropdownMenuItem<String>(value: 'Gate#3', child: Text('Gate#3', maxLines: 3)),
                    DropdownMenuItem<String>(value: 'Gate#4', child: Text('Gate#4', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'Kindergarten for Scientific Departments',
                        child: Text('Kindergarten for Scientific Departments', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'Kindergarten for Human Departments',
                        child: Text('Kindergarten for Human Departments', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'Festival Hall & Exhibition Building',
                        child: Text('Festival Hall & Exhibition Building', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'Research Center & Common Halls',
                        child: Text('Research Center & Common Halls', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'Prince Naif Research Center',
                        child: Text('Prince Naif Research Center', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'Princess Sara Bint Abdullah Bin Faisal AlSaud Libraru',
                        child: Text('Princess Sara Bint Abdullah Bin Faisal AlSaud Libraru',
                            maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'Special Needs Center',
                        child: Text('Special Needs Center', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'Accommodation of Faculty Members',
                        child: Text('Accommodation of Faculty Members', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'Female Student Housing',
                        child: Text('Female Student Housing', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'Female Student Housing Services Building',
                        child: Text('Female Student Housing Services Building', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'Sport Club', child: Text('Sport Club', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'Foyer & Central Plaza',
                        child: Text('Foyer & Central Plaza', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'Administration Building & Supporting Deanships',
                        child: Text('Administration Building & Supporting Deanships', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'Student Clubs', child: Text('Student Clubs', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'Main Restaurant', child: Text('Main Restaurant', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'Admission & Registration',
                        child: Text('Admission & Registration', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'Student Services Center',
                        child: Text('Student Services Center', maxLines: 3)),
                    DropdownMenuItem<String>(
                        value: 'Operational ِAffairs',
                        child: Text('Operational ِAffairs', maxLines: 3)),
                  ],
                  value: widget.buildingName,
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
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_contactChannelFocusNode),
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
                  decoration: const InputDecoration(
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
                  items: const [
                    DropdownMenuItem<String>(
                        value: '',
                        child: Text(
                          'Choose  a channel',
                          style: TextStyle(color: Colors.grey),
                        )),
                    DropdownMenuItem<String>(value: 'Phone Number', child: Text('Phone Number')),
                    DropdownMenuItem<String>(value: 'Email', child: Text('Email'))
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
                      border: Border.all(color: Colors.blue, width: 3),
                      borderRadius: BorderRadius.circular(20)),
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
                      border: Border.all(color: Colors.blue, width: 3),
                    ),
                    child: Image.network(
                      imageUrl,
                    ))
              else if (imageUrl == '' && imgFile != null)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 3),
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
                                  imageUrl = '';
                                  imgFile = null;
                                });
                              }))),
              //Add announcement button
              MyButton(
                  color: Colors.blue[700]!,
                  title: "Update announcement!",
                  onPressed: () {
                    submitFormOnAdd();
                  }),
              //Cancel button
              MyButton(
                  color: Colors.blue[700]!,
                  title: "Cancel",
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          )),
        ),
      ),
    );
  }
}
