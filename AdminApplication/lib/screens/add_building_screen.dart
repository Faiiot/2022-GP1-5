import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/constants/constants.dart';
import 'package:findly_admin/screens/widgets/wide_button.dart';
import 'package:findly_admin/services/global_methods.dart';
import 'package:flutter/material.dart';
import '../constants/text_styles.dart';

class AddBuildingScreen extends StatefulWidget {
  const AddBuildingScreen({Key? key}) : super(key: key);

  @override
  State<AddBuildingScreen> createState() => _AddBuildingScreenState();
}

class _AddBuildingScreenState extends State<AddBuildingScreen> {
  final _addBuildingFormKey = GlobalKey<FormState>();
  final TextEditingController _buildingNameTextController =
      TextEditingController(text: '');
  bool _isLoading = false;
  String searchText = '';
  int buildingCount = 0;
  bool duplicate = false;
  @override
  void dispose() {
    _buildingNameTextController.dispose();
    super.dispose();
  }

  void isDuplicate() async {
    final duplicatedBuilding = await FirebaseFirestore.instance
        .collection("location")
        .where("buildingName",
            isEqualTo: _buildingNameTextController.text.trim())
        .get();

    if (duplicatedBuilding.size != 0) {
      setState(() {
        duplicate = true;
      });
    }
  }

  void addBuilding() async {
    isDuplicate();
    final isValid = _addBuildingFormKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        if (duplicate) {
          GlobalMethods.showErrorDialog(
              error: "Building name already exists!", context: context);
        } else {
          await FirebaseFirestore.instance
              .collection("location")
              .doc()
              .set({
            "buildingName": _buildingNameTextController.text.trim(),
          });
          setState(() {
            _isLoading = false;
          });

          GlobalMethods.showToast("Building has been added successfully!");
          _buildingNameTextController.clear();
        }
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
          "Add building",
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
                    key: _addBuildingFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 20),
                          child: Text(
                            "Current buildings",
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
                                .collection("location")
                                .orderBy("buildingName")
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
                                  buildingCount = data.length;
                                  if (searchText.isNotEmpty) {
                                    data.retainWhere(
                                      (element) => element['buildingName']
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
                                                    data[index]['buildingName'],
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
                              return "Please enter a building name..";
                            }
                            return null;
                          },
                          controller: _buildingNameTextController,
                          textAlign: TextAlign.start,
                          onChanged: (value) {
                            print(value);
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.category_outlined),
                            hintText: "Add building",
                            labelText: "Building name",
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
                                    backgroundColor: Colors.blue,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : WideButton(
                                width: double.infinity,
                                choice: 1,
                                title: "Add building",
                                onPressed: () {
                                  GlobalMethods.showCustomizedDialogue(
                                      title: "Add building",
                                      mainAction: "Yes",
                                      context: context,
                                      secondaryAction: "No",
                                      onPressedMain: () {
                                        addBuilding();
                                        Navigator.pop(context);
                                      },
                                      onPressedSecondary: () {
                                        Navigator.pop(context);
                                      });
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
