import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:findly_app/constants/constants.dart';
import 'package:findly_app/screens/widgets/announcements_widget.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:flutter/material.dart';

import '../constants/dates.dart';
import '../constants/reference_data.dart';

class FoundItemsScreen extends StatefulWidget {
  final String userID;

  const FoundItemsScreen({
    super.key,
    required this.userID,
  });

  @override
  State<FoundItemsScreen> createState() => _FoundItemsScreenState();
}

class _FoundItemsScreenState extends State<FoundItemsScreen> {
  String searchText = '';
  DateTime? selectedDate;
  String? selectedCategory;
  String? selectedBuildingName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4ECF4),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (ctx) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        title: Card(
          child: TextField(
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.search),
              hintText: ' Search Found items...',
            ),
            onChanged: (value) {
              setState(() {
                searchText = value.trim();
              });
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_rounded),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return AlertDialog(
                    scrollable: true,
                    contentPadding: const EdgeInsets.all(24.0),
                    title: const Text("Filters"),
                    content: Column(
                      children: [
                        DropdownButtonFormField<String?>(
                          isExpanded: true,
                          value: Dates.dateToString(selectedDate),
                          decoration: kInputDecoration,
                          items: const [
                            DropdownMenuItem<String?>(
                              value: null,
                              child: Text(
                                'Date',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: Dates.kLastWeek,
                              child: Text(
                                Dates.kLastWeek,
                                maxLines: 3,
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: Dates.kLastTwoWeeks,
                              child: Text(
                                Dates.kLastTwoWeeks,
                                maxLines: 3,
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: Dates.kLastMonth,
                              child: Text(
                                Dates.kLastMonth,
                                maxLines: 3,
                              ),
                            ),
                          ],
                          onChanged: (dropDownValue) {
                            selectedDate = Dates.stringToDate(dropDownValue);
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField(
                          value: selectedCategory,
                          isExpanded: true,
                          decoration: kInputDecoration,
                          items: [
                            const DropdownMenuItem<String?>(
                                value: null,
                                child: Text(
                                  'Item category',
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
                          ],
                          onChanged: (value) {
                            selectedCategory = value;
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownSearch<String>(
                          mode: Mode.DIALOG,
                          showSelectedItems: true,
                          items: ReferenceData.instance.locations,
                          dropdownSearchDecoration: const InputDecoration(
                            hintText: "Building name",
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
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                          onChanged: (value) {
                            selectedBuildingName = value;
                          },
                          selectedItem: selectedBuildingName,
                          popupShape: const RoundedRectangleBorder(),
                          showSearchBox: true,
                          searchFieldProps: const TextFieldProps(
                            cursorColor: Colors.blue,
                            decoration: kInputDecoration,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      buildTextButton(
                        context,
                        "Reset",
                        false,
                        () {
                          selectedDate = selectedCategory = selectedBuildingName = null;
                          Navigator.pop(context);
                        },
                      ),
                      buildTextButton(
                        context,
                        "Apply",
                        true,
                        () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              ).then(
                (_) => setState(() {}),
              );
            },
          )
        ],
      ),
      //Stream builder to get a snapshot of the announcement collection to show it in the home screen
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('foundItem')
            .orderBy('annoucementDate', descending: true)
            .snapshots()
            .asBroadcastStream(),
        builder: (context, snapshot) {
          //if the connection state is "waiting", a progress indicator will appear
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
            //if the connection state is "active"
          } else if (snapshot.connectionState == ConnectionState.active) {
            //if the collection snapshot is empty
            if (snapshot.data!.docs.isNotEmpty) {
              List data = snapshot.data!.docs;
              data = GlobalMethods.applyFilters(
                data,
                selectedDate,
                selectedCategory,
                selectedBuildingName,
              );
              if (searchText.isNotEmpty) {
                data.retainWhere(
                  (element) => element['itemName'].toString().toLowerCase().contains(
                        searchText.toLowerCase(),
                      ),
                );
              }
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Announcement(
                      //snapshot.data!.docs is a list of the announcements
                      //by pointing to the index of a specific announcement and fetching info
                      announcementID: data[index]['announcementID'],
                      itemName: data[index]['itemName'],
                      announcementType: data[index]['announcementType'],
                      itemCategory: data[index]['itemCategory'],
                      postDate: data[index]['annoucementDate'],
                      announcementImg: data[index]['url'],
                      buildingName: data[index]['buildingName'],
                      contactChannel: data[index]['contact'],
                      publisherID: data[index]['publishedBy'],
                      announcementDes: data[index]['announcementDes'],
                      profile: false,
                      reported: data[index]['reported'],
                      reportCount: data[index]['reportCount'],
                      roomnumber: data[index]['roomnumber'],
                      floornumber: data[index]['floornumber'],
                    );
                  });
            } else {
              return const Center(
                //if no announcement was uploaded
                child: Text(
                  "No Announcements has been uploaded yet!",
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
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
        },
      ),
    );
  }

  TextButton buildTextButton(
    BuildContext context,
    String label,
    bool activeColor,
    Function()? onTap,
  ) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: activeColor ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}
