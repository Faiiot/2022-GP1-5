import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/screens/admin_profile_page.dart';
import 'package:findly_admin/screens/widgets/my_button.dart';

import 'package:flutter/material.dart';

class EditPhone extends StatefulWidget {
  //A constructor tat requires the user ID to return to each user her home screen
  const EditPhone({
    super.key,
    required this.userID,
  });

  final String userID;

  @override
  State<EditPhone> createState() => EditPhoneState();
}

class EditPhoneState extends State<EditPhone> {
  String id = '';
  String email = '';
  String phoneNo = '';
  String firstName = '';
  String lastName = '';
  String fullName = '';
  String dropDownValue = "";

  final editFormKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNoFocusNode = FocusNode();
  final TextEditingController _phoneNoController = TextEditingController(text: '');
  final TextEditingController _emailTextController = TextEditingController(text: '');

  @override
  void dispose() {
    //dispose from device memory so its performance isn't affected
    _emailTextController.dispose();
    _phoneNoController.dispose();
    _emailFocusNode.dispose();
    _phoneNoFocusNode.dispose();
    super.dispose();
  }

  void cancel() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AdminProfile(userID: widget.userID),
      ),
    );
  }

  void getUserInfo() async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(
            widget.userID,
          ) // widget.userID is used because the var is defined outside the state class but under statefulWidget class
          .get();

      setState(() {
        id = userDoc.get('memberID');
        firstName = userDoc.get('firstName');
        lastName = userDoc.get('LastName');
        fullName = '$firstName $lastName';
        phoneNo = userDoc.get('phoneNo');
        email = userDoc.get('Email');
      });
      debugPrint('$id$fullName$email');
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      setState(() {});
    }
  }

  void submitFormOnAdd() async {
    final isValid = editFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {});
      try {
        debugPrint('l');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userID)
            .update({'phoneNo': _phoneNoController.text});
        _phoneNoController.text = '';
        if (!mounted) return;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminProfile(userID: widget.userID),
            ));
      } catch (error) {
        setState(() {});
        //if an error occurs a pop-up message
        //GlobalMethods.showErrorDialog(error: error.toString(), context: context);
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
            centerTitle: true,
            title: const Text('Update Email'),
            leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      //back button
                      context,
                      MaterialPageRoute(builder: (context) => AdminProfile(userID: widget.userID)));
                },
                icon: const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.blue,
                ))),
        body: Form(
            key: editFormKey,
            child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      //Announcement type
                      const Text(
                        ' Phone Number *',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        focusNode: _phoneNoFocusNode,
                        onEditingComplete: () => FocusScope.of(context).requestFocus(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Field can not be empty!";
                          } else if (value.length < 10 || value.length > 14) {
                            return "Can't be less than 10 or more than 14 digits!";
                          }
                          return null;
                        },
                        controller: _phoneNoController,
                        keyboardType: TextInputType.phone,
                        textAlign: TextAlign.start,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          labelText: "Phone number *",
                          hintText: "Phone number",
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
                          errorBorder:
                              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      MyButton(color: Colors.blue, title: 'Update', onPressed: submitFormOnAdd),
                      MyButton(color: Colors.blue, title: 'Cancel', onPressed: cancel),
                    ])))));
  }
}
