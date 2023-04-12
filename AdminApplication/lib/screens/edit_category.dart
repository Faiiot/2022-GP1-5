import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/screens/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
// import 'admin_dashboard_screen.dart';

class EditCategory extends StatefulWidget {
  @override
  State<EditCategory> createState() => _EditCategory();
}

class _EditCategory extends State<EditCategory> {
  String type = "";
  String name = "";
  final editFormKey = GlobalKey<FormState>();
  String dropDownValue = "";

  void submitFormOnAdd() async {
    final isValid = editFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      final categoryID = const Uuid().v4();
      setState(() {});
      try {
        await FirebaseFirestore.instance
            .collection('category')
            .doc(categoryID)
            .set({'categoryName': name});

        Fluttertoast.showToast(
          msg: "Category has been added successfully!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        if (!mounted) return;
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        debugPrint("error occurred $error");
        setState(() {});
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
          title: const Text('Add category'),
        ),
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
                        ' Name *',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        // controller: _categoryNameController,
                        maxLength: 50,
                        onFieldSubmitted: (String value) {
                          setState(() {
                            name = value;
                          });
                        },
                        onChanged: (value) {
                          name = value;
                          debugPrint(value);
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter the name ",
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

                      MyButton(color: Colors.blue, title: 'Add', onPressed: submitFormOnAdd),
                      MyButton(
                          color: Colors.blue,
                          title: 'Cancel',
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ])))));
  }
}
