import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:findly_admin/constants/constants.dart';
import 'package:findly_admin/screens/widgets/announcements_widget.dart';
import 'package:findly_admin/services/global_methods.dart';
import 'package:flutter/material.dart';
import '../constants/dates.dart';
import '../constants/reference_data.dart';
import '../constants/text_styles.dart';

class ReportedAnnouncement extends StatefulWidget {
  final String userID;

  const ReportedAnnouncement({
    super.key,
    required this.userID,
  });

  @override
  State<ReportedAnnouncement> createState() => _ReportedAnnouncement();
}

class _ReportedAnnouncement extends State<ReportedAnnouncement> {
  String searchText = '';
  DateTime? selectedDate;
  String? selectedCategory;
  String? selectedBuildingName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight:
            kToolbarHeight + MediaQuery.of(context).viewPadding.top + 32,
        flexibleSpace: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top,
          ),
          decoration: const BoxDecoration(
            gradient: kLinearGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Expanded(
                    child: Text(
                      "Reported announcements",
                      textAlign: TextAlign.center,
                      style: TextStyles.appBarTitleStyle,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.filter_alt_rounded,
                      color: Colors.white,
                    ),
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
                                    selectedDate =
                                        Dates.stringToDate(dropDownValue);
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
                                          (categoryName) =>
                                              DropdownMenuItem<String>(
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
                                  dropdownSearchDecoration:
                                      const InputDecoration(
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
                                  selectedDate = selectedCategory =
                                      selectedBuildingName = null;
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
              Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        hintText: ' Search found items...',
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
            ],
          ),
        ),
      ),

      //Stream builder to get a snapshot of the announcement collection to show it in the home screen
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("lostItem")
              .orderBy("annoucementDate", descending: true)
              .snapshots()
              .asBroadcastStream(),
          builder: (context, lostSnapshots) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("foundItem")
                  .orderBy("annoucementDate", descending: true)
                  .snapshots()
                  .asBroadcastStream(),
              builder: (context, foundSnapshots) {
                //if the connection state is "waiting", a progress indicatior will appear
                if (foundSnapshots.connectionState == ConnectionState.waiting ||
                    lostSnapshots.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                  //if the connection state is "active"
                } else if (foundSnapshots.connectionState ==
                        ConnectionState.active ||
                    lostSnapshots.connectionState == ConnectionState.active) {
                  //if the collection snapshot is not empty
                  final List reportedLost = lostSnapshots.data!.docs;
                  reportedLost.retainWhere(
                    (announcement) => announcement["reported"] == true,
                  );
                  final List reportedFound = foundSnapshots.data!.docs;
                  reportedFound.retainWhere(
                    (announcement) => announcement["reported"] == true,
                  );
                  List totalReported = [...reportedLost, ...reportedFound];
                  if (totalReported.isNotEmpty) {
                    List data = [...totalReported];
                    data = GlobalMethods.applyFilters(
                      data,
                      selectedDate,
                      selectedCategory,
                      selectedBuildingName,
                    );
                    if (searchText.isNotEmpty) {
                      data.retainWhere(
                        (element) => element['itemName']
                            .toString()
                            .toLowerCase()
                            .contains(
                              searchText.toLowerCase(),
                            ),
                      );
                    }
                    return data.isEmpty
                        ? const Center(
                            //if no announcement was uploaded
                            child: Text(
                              "No match found",
                              style: TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              // crossAxisSpacing: 16.0,
                              // mainAxisSpacing: 16.0,
                            ),
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Announcement(
                                //snapshot.data!.docs is a list of the announcements
                                //by pointing to the index of a specific announcement and fetching info
                                announcementID: data[index]['announcementID'],
                                itemName: data[index]['itemName'],
                                announcementType: data[index]
                                    ['announcementType'],
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
                                roomNumber: data[index]['roomnumber'],
                                floorNumber: data[index]['floornumber'],
                                reportsScreen: true,
                              );
                            },
                          );
                  } else {
                    return const Center(
                      //if no announcement was uploaded
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          "No Announcements has\nbeen reported yet!",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
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
              },
            );
          }),
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
