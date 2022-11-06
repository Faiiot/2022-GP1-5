import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/screens/home_screen.dart';
import 'package:findly_app/screens/widgets/my_button.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddAnnouncementScreen extends StatefulWidget {


  @override
  State<AddAnnouncementScreen> createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String itemName;
  late String buildingName ="";
  late String annType;
  late String annCategory;
  late String contactChanel;
  late String imageUrl = '';
  late String annDesc;

  late TextEditingController _itemName = TextEditingController(text: '');
  late TextEditingController _annDesc = TextEditingController(text: '');
  File? imgFile;

  FocusNode _ItemNameFocusNode = FocusNode();
  FocusNode _buildingNameFocusNode = FocusNode();
  FocusNode _annTypeFocusNode = FocusNode();
  FocusNode _contactChannelFocusNode = FocusNode();
  FocusNode _annDesFocusNode = FocusNode();
  FocusNode _annCategoryFocusNode = FocusNode();



  final _addFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {//dispose from device memory so its performance isn't affected

    _itemName.dispose();
    _annDesc.dispose();
    _ItemNameFocusNode.dispose();
    _buildingNameFocusNode.dispose();
    _annTypeFocusNode.dispose();
    _contactChannelFocusNode.dispose();
    _annDesFocusNode.dispose();
    _annCategoryFocusNode.dispose();
    super.dispose();
  }

  //for picking announcement image using camera
  void _pickImageUsingCamera () async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera,
    maxHeight: 1080, maxWidth: 1080);
    //to show the image to the user
    setState(() {
      imgFile = File(pickedFile!.path);
    });
  }

  //for picking announcement image using gallery
  void _pickImageUsingGallery () async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery,
        maxHeight: 1080, maxWidth: 1080);
    //to show the image to the user
    setState(() {
      imgFile = File(pickedFile!.path);
    });
  }


  //Method to add the announcement to the database
  void submitFormOnAdd() async {
    final User? user = _auth.currentUser;
    final String _uid = user!.uid;
    final String uniqueImgID = DateTime.now()
        .millisecondsSinceEpoch
        .toString();
    if(imgFile != null) {

    final ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child(uniqueImgID.toString()+'.jpg');
    await ref.putFile(imgFile!);
    imageUrl = await ref.getDownloadURL();}
    else{
    imageUrl = "";}
    final isValid = _addFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(isValid){
      final announcementID = Uuid().v4();
      setState(() {
        _isLoading=true;
      });
      try{
        await FirebaseFirestore.instance.collection('announcement').doc(announcementID).set({
          'announcementID':announcementID,
          'publishedBy': _uid,
          'itemName': itemName,
          'itemCategory': annCategory,
          'announcementDes': annDesc,
          'announcementType': annType,
          'contact': contactChanel,
          'url': imageUrl,
          'buildingName': buildingName,
          'annoucementDate': DateTime.now()

        });
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_uid).update({"userAnnouncement": FieldValue.arrayUnion([announcementID])});
        
        Navigator.canPop(context)?Navigator.pop(context):null;
        Navigator.pushReplacement(
            context, MaterialPageRoute(
          builder: (context)=>HomeScreen(userID: _uid,)
          ,)
        );
        Fluttertoast.showToast(
            msg: "Announcement has been added successfully!",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 16.0,
          timeInSecForIosWeb: 2
        );
      } catch(error){
        setState(() {
          _isLoading=false;
        });
        GlobalMethods.showErrorDialog(error: error.toString(), context: context);
        print("error occured $error");
      }

    }else {
      print("form not valid!");
    }
    setState(() {
      _isLoading=false;
    });

  }

  @override
  Widget build(BuildContext context) {
    var dropsownValue="";
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Add Announcement Form',
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[700]),
      body: Form(
        key: _addFormKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Announcement type *',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  DropdownButtonFormField(

                      isExpanded: true,
                      decoration: InputDecoration(
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
                            child: Text(
                              'Choose Announcment type',
                              style: TextStyle(color: Colors.grey),
                            ),
                            value: ''),
                        DropdownMenuItem<String>(
                            child: Text('Lost announcement'), value: 'lost'),
                        DropdownMenuItem<String>(
                            child: Text('Found announcement'), value: 'found')
                      ],
                      onChanged: (value) {
                        annType = value.toString();//check iff it works
                        setState(() {
                          annType = value.toString();//check iff it works
                        });
                        FocusScope.of(context).requestFocus(_ItemNameFocusNode);

                      },
                      validator: (value) {
                        if (value == '') {
                          return 'You must choose';
                        }
                        return null;
                      },
                      value: dropsownValue),
                  SizedBox(height: 20,),
                  Text(
                    'Item name *',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    focusNode: _ItemNameFocusNode,
                    onEditingComplete: ()=>
                        FocusScope.of(context).requestFocus(_annCategoryFocusNode),
                    maxLength: 50,
                    controller: _itemName,
                    onFieldSubmitted: (String value) {
                      print(value);
                    },
                    onChanged: (value) {
                      itemName = value;
                      print(value);
                    },
                    decoration: InputDecoration(
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
                  SizedBox(height: 20,),

                  // categury
                  Text(
                    'Item category *',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  DropdownButtonFormField(
                    focusNode: _annCategoryFocusNode,

                      isExpanded: true,
                      decoration: InputDecoration(
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
                            child: Text(
                              'Choose Item category',
                              style: TextStyle(color: Colors.grey),
                            ),
                            value: ''),
                        DropdownMenuItem<String>(
                            child: Text('Electronic devices'), value: 'Electronic devices'),
                        DropdownMenuItem<String>(
                            child: Text('Electronic accessories'), value: 'Electronic accessories'),
                        DropdownMenuItem<String>(
                            child: Text('Jewelry'), value: 'Jewelry'),
                        DropdownMenuItem<String>(
                            child: Text('Medical equipments'), value: 'Medical equipments'),
                        DropdownMenuItem<String>(
                            child: Text('Personal accessories'), value: 'Personal accessories'),
                        DropdownMenuItem<String>(
                            child: Text('Others'), value: 'Others'),


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
                        //return null;
                      },
                      value: dropsownValue),
                  SizedBox(height: 20,),
                  Text(
                    'Bullding name',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  DropdownButtonFormField(
                    focusNode: _buildingNameFocusNode,
                      isExpanded: true,
                      decoration: InputDecoration(
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
                            child: Text(
                              'Choose Bullding name',
                              style: TextStyle(color: Colors.grey),
                            ),
                            value: ''),
                        DropdownMenuItem<String>(
                            child: Text(
                              'College of Education',
                              maxLines: 3,
                            ),
                            value: 'College of Education'),
                        DropdownMenuItem<String>(
                            child: Text('College of Arts', maxLines: 3),
                            value: 'College of Arts'),
                        DropdownMenuItem<String>(
                            child: Text(
                                'College of Tourism & Cultural Heritage',
                                maxLines: 3),
                            value: 'College of Tourism & Cultural Heritage'),
                        DropdownMenuItem<String>(
                            child: Text('College of Languages & Translation',
                                maxLines: 3),
                            value: 'College of Languages & Translation'),
                        DropdownMenuItem<String>(
                            child: Text('College of Law & Political Science',
                                maxLines: 3),
                            value: 'College of Law & Political Science'),
                        DropdownMenuItem<String>(
                            child: Text('College of Business Administration',
                                maxLines: 3),
                            value: 'College of Business Administration'),
                        DropdownMenuItem<String>(
                            child: Text('College of Nursing', maxLines: 3),
                            value: 'College of Nursing'),
                        DropdownMenuItem<String>(
                            child: Text('College of Pharmacy', maxLines: 3),
                            value: 'College of Pharmacy'),
                        DropdownMenuItem<String>(
                            child: Text('College of Medicine', maxLines: 3),
                            value: 'College of Medicine'),
                        DropdownMenuItem<String>(
                            child: Text('College of Applied Medical Sciences',
                                maxLines: 3),
                            value: 'College of Applied Medical Sciences'),
                        DropdownMenuItem<String>(
                            child: Text('College of Dentistry', maxLines: 3),
                            value: 'College of Dentistry'),
                        DropdownMenuItem<String>(
                            child: Text('College of science', maxLines: 3),
                            value: 'College of science'),
                        DropdownMenuItem<String>(
                            child: Text(
                                'College of Agricultural and Food Scinces',
                                maxLines: 3),
                            value:
                            'College of Agricultural and Food Scinces'),
                        DropdownMenuItem<String>(
                            child: Text(
                                'College of Computer & Information Scinces',
                                maxLines: 3),
                            value:
                            'College of Computer & Information Scinces'),
                        DropdownMenuItem<String>(
                            child: Text(
                                'College of Sport Scinces & Physical Activity',
                                maxLines: 3),
                            value:
                            'College of Sport Scinces & Physical Activity'),
                        DropdownMenuItem<String>(
                            child: Text('College of Architecture & Planning',
                                maxLines: 3),
                            value: 'ACollege of Architecture & PlanningP'),
                        DropdownMenuItem<String>(
                            child: Text('Gate#1', maxLines: 3),
                            value: 'Gate#1'),
                        DropdownMenuItem<String>(
                            child: Text('Gate#2', maxLines: 3),
                            value: 'Gate#2'),
                        DropdownMenuItem<String>(
                            child: Text('Gate#3', maxLines: 3),
                            value: 'Gate#3'),
                        DropdownMenuItem<String>(
                            child: Text('Gate#4', maxLines: 3),
                            value: 'Gate#4'),
                        DropdownMenuItem<String>(
                            child: Text(
                                'Kindergarten for Scientific Departments',
                                maxLines: 3),
                            value: 'Kindergarten for Scientific Departments'),
                        DropdownMenuItem<String>(
                            child: Text('Kindergarten for Human Departments',
                                maxLines: 3),
                            value: 'Kindergarten for Human Departments'),
                        DropdownMenuItem<String>(
                            child: Text('Festival Hall & Exhibition Building',
                                maxLines: 3),
                            value: 'Festival Hall & Exhibition Building'),
                        DropdownMenuItem<String>(
                            child: Text('Research Center & Common Halls',
                                maxLines: 3),
                            value: 'Research Center & Common Halls'),
                        DropdownMenuItem<String>(
                            child: Text('Prince Naif Research Center',
                                maxLines: 3),
                            value: 'Prince Naif Research Center'),
                        DropdownMenuItem<String>(
                            child: Text(
                                'Princess Sara Bint Abdullah Bin Faisal AlSaud Libraru',
                                maxLines: 3),
                            value:
                            'Princess Sara Bint Abdullah Bin Faisal AlSaud Libraru'),
                        DropdownMenuItem<String>(
                            child: Text('Special Needs Center', maxLines: 3),
                            value: 'Special Needs Center'),
                        DropdownMenuItem<String>(
                            child: Text('Accommodation of Faculty Members',
                                maxLines: 3),
                            value: 'Accommodation of Faculty Members'),
                        DropdownMenuItem<String>(
                            child:
                            Text('Female Student Housing', maxLines: 3),
                            value: 'Female Student Housing'),
                        DropdownMenuItem<String>(
                            child: Text(
                                'Female Student Housing Services Building',
                                maxLines: 3),
                            value:
                            'Female Student Housing Services Building'),
                        DropdownMenuItem<String>(
                            child: Text('Sport Club', maxLines: 3),
                            value: 'Sport Club'),
                        DropdownMenuItem<String>(
                            child: Text('Foyer & Central Plaza', maxLines: 3),
                            value: 'Foyer & Central Plaza'),
                        DropdownMenuItem<String>(
                            child: Text(
                                'Administration Building & Supporting Deanships',
                                maxLines: 3),
                            value:
                            'Administration Building & Supporting Deanships'),
                        DropdownMenuItem<String>(
                            child: Text('Student Clubs', maxLines: 3),
                            value: 'Student Clubs'),
                        DropdownMenuItem<String>(
                            child: Text('Main Restaurant', maxLines: 3),
                            value: 'Main Restaurant'),
                        DropdownMenuItem<String>(
                            child:
                            Text('Admission & Registration', maxLines: 3),
                            value: 'Admission & Registration'),
                        DropdownMenuItem<String>(
                            child:
                            Text('Student Services Center', maxLines: 3),
                            value: 'Student Services Center'),
                        DropdownMenuItem<String>(
                            child: Text('Operational ِAffairs', maxLines: 3),
                            value: 'Operational ِAffairs'),
                      ],
                      value: dropsownValue,
                      onChanged: (value) {
                        buildingName = value.toString();
                        setState(() {
                          buildingName = value.toString();
                        });

                            FocusScope.of(context).requestFocus(_annDesFocusNode);
                      }),

                  SizedBox(
                    height: 20.0,
                  ),

                  //description
                  Text(
                    'Announcement description *',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    focusNode: _annDesFocusNode,
                    onEditingComplete: ()=>
                        FocusScope.of(context).requestFocus(_contactChannelFocusNode),
                    controller: _annDesc,
                    minLines: 2,
                    maxLines: 5,
                    maxLength: 256,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
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
                    },
                  ), // for description
                  SizedBox(
                    height: 20.0,
                  ),
            imgFile == null
                ?
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 3),
                    borderRadius: BorderRadius.circular(20)
                ),
                height: 200,
                width: 200,
                child:
                Icon(Icons.hide_image_outlined, size: 100,color: Colors.blueGrey,)
              )
            :
            Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 3),
                    ),

                    child:
                        Image.file(imgFile!, fit: BoxFit.cover, ),
                  ),
                  imgFile == null
                  ?
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: ElevatedButton(
                        child: const Text('Upload item image') ,
                        onPressed: () {

                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 200,
                                color: Colors.grey[200],
                                child: Center(
                                  child:
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                                    Padding(
                                      padding: const EdgeInsets.all(9.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Gallery',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight
                                                  .bold,
                                            ),
                                          ),
                                          Container(
                                            height:100,
                                            width:100,
                                            child: IconButton(
                                                onPressed: ()  {
                                                  _pickImageUsingGallery();

                                                },
                                                icon: Container(
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
                                      children: [Text('Camera',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight
                                              .bold,
                                        ),),
                                        Container(
                                          height: 100,
                                          width: 100,
                                          child: IconButton(
                                              onPressed: ()  {
                                                _pickImageUsingCamera();

                                              },
                                              icon: Container(
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
                                  ],),
                                ),
                              );
                            },
                          );

                        },
                      ),
                    ),
                  )
                  :
                  Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                          child: ElevatedButton(
                              child: const Text('Cancel') ,
                              onPressed: () { setState(() {
                                imgFile = null;
                              }); print(imgFile); }
                          )
                      )
                  ),
                  Text(
                    'Another contact channel you prefer *',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  // contact
                  DropdownButtonFormField(
                    focusNode: _contactChannelFocusNode,
                      isExpanded: true,
                      decoration: InputDecoration(
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
                            child: Text(
                              'Choose  a channel',
                              style: TextStyle(color: Colors.grey),
                            ),
                            value: ''),
                        DropdownMenuItem<String>(
                            child: Text('Phone Number'),
                            value: 'Phone Number'),
                        DropdownMenuItem<String>(
                            child: Text('Email'), value: 'Email')
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
                      },
                      value: dropsownValue),
                  SizedBox(
                    height: 25.0,
                  ),

                  MyButton(
                      color: Colors.blue[700]!,
                      title: "Add announcement!",
                      onPressed: (){
                        submitFormOnAdd();

                      }),
                  MyButton(
                      color: Colors.blue[700]!,
                      title: "Cancel",
                      onPressed: (){
                        User? user = _auth.currentUser;
                        String _uid = user!.uid;

                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context)=>HomeScreen(userID: _uid)
                          ,)
                        );


                      }),
                ],
              )
          ),
        ),
      ),
    );
  }

}