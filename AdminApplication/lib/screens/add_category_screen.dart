import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/constants/constants.dart';
import 'package:findly_admin/constants/reference_data.dart';
import 'package:findly_admin/screens/widgets/wide_button.dart';
import 'package:findly_admin/services/global_methods.dart';
import 'package:flutter/material.dart';
import '../constants/text_styles.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _addCategoryFormKey = GlobalKey<FormState>();
  RegExp categoryName = RegExp(r'^[A-Z][a-zA-Z]+$');
  final TextEditingController _categoryNameController =
      TextEditingController(text: '');
  bool _isLoading = false;
  String searchText = '';
  bool duplicate = false;
  String category = '';

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  isDuplicate() async {
    final duplicatedCategory = FirebaseFirestore.instance
        .collection("category")
        .where("categoryName", isEqualTo: category)
        .get();
    List categoryList = [];


    String categoryNameHolder;
    FirebaseFirestore.instance.collection("category").get().then((cList) => {
          cList.docs.forEach((doc) => {
                categoryNameHolder = doc.get("categoryName"),
                categoryList.add(categoryNameHolder.toLowerCase()),
              }),
          if (categoryList.contains(category.toLowerCase()))
            {
              setState(() {
                duplicate = true;
                return;
              }),
              print(categoryList)
            }
        });
  }

  void addCategory() async {
    final bool isValid = _addCategoryFormKey.currentState!.validate();
    if (isValid) {

      try {
          setState(() {
            _isLoading = true;
          });
          await FirebaseFirestore.instance.collection("category").doc().set({
            "categoryName": _categoryNameController.text.trim(),
          });
          setState(() {
            _isLoading = false;
          });

          GlobalMethods.showToast("Category has been added successfully!");
          _categoryNameController.clear();

      } catch (error) {
        debugPrint(error.toString());
        GlobalMethods.showErrorDialog(
            error: "We are sorry,something went wrong!", context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Add category",
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
                    top: 40.0,
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
                    key: _addCategoryFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 20),
                          child: Text(
                            "Current categories",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                          ),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 10),
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: Icon(Icons.search),
                                  hintText: ' Search...',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    searchText = value.trim();
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("category")
                                .orderBy("categoryName")
                                .snapshots()
                                .asBroadcastStream(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                  height: size.height * 0.3,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: primaryColor,
                                    ),
                                  ),
                                );
                                //if the connection state is "active"
                              } else if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                //if the collection snapshot is empty
                                if (snapshot.data!.docs.isNotEmpty) {
                                  List data = snapshot.data!.docs;

                                  if (searchText.isNotEmpty) {
                                    data.retainWhere(
                                      (element) => element['categoryName']
                                          .toString()
                                          .toLowerCase()
                                          .contains(
                                            searchText.toLowerCase(),
                                          ),
                                    );
                                  }
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: SizedBox(
                                      height: size.height * 0.3,
                                      child: Card(
                                        color: const Color(0xFFC1DDEE),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemCount: data.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Column(
                                              children: [
                                                ListTile(
                                                  title: Text(
                                                    data[index]['categoryName'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                                  child: Divider(
                                                    thickness: 1,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                              return const Center(
                                //if something went wrong
                                child: Text(
                                  "Something went wrong",
                                ),
                              );
                            }),

                        TextFormField(
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () =>
                              FocusScope.of(context).unfocus(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a category..";
                            }
                            if (!categoryName.hasMatch(value)) {
                              return "Category name must start\nwith a capital letter";
                            }
                            return null;
                          },
                          controller: _categoryNameController,
                          textAlign: TextAlign.start,
                          onChanged: (value) {
                            setState(() {
                              category = value.trim();
                            });
                            isDuplicate();
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.category_outlined),
                            hintText: "Add category",
                            labelText: "Category",
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
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        //if the there are processes loading show an indicator
                        _isLoading
                            ? const Center(
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    backgroundColor: primaryColor,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : WideButton(
                                width: double.infinity,
                                choice: 1,
                                title: "Add category",
                                onPressed: () {
                                  final bool isValidForm = _addCategoryFormKey
                                      .currentState!
                                      .validate();
                                  if (isValidForm) {

                                    if (duplicate == true) {
                                      GlobalMethods.showErrorDialog(
                                          error:
                                              "The category you are trying to add already exists! ",
                                          context: context);
                                    }
                                    else{
                                      GlobalMethods.showCustomizedDialogue(
                                          title: "Add category",
                                          message:
                                          "Are you sure you want to add this category?",
                                          mainAction: "Yes",
                                          context: context,
                                          secondaryAction: "No",
                                          onPressedMain: () {
                                            Navigator.pop(context);
                                            addCategory();
                                          },
                                          onPressedSecondary: () {
                                            Navigator.pop(context);
                                          });
                                    }

                                  }
                                },
                              ),
                        _isLoading
                            ? const SizedBox.shrink()
                            : WideButton(
                                width: double.infinity,
                                choice: 2,
                                title: "Cancel",
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                      ],
                    ),
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
