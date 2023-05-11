import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/constants/constants.dart';
import 'package:findly_admin/screens/widgets/announcements_widget.dart';
import 'package:findly_admin/services/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../constants/dates.dart';
import '../constants/reference_data.dart';
import '../constants/text_styles.dart';

class LostItemsScreen extends StatefulWidget {
  final String userID;

  const LostItemsScreen({
    super.key,
    required this.userID,
  });

  @override
  State<LostItemsScreen> createState() => _LostItemsScreenState();
}

class _LostItemsScreenState extends State<LostItemsScreen> {
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
        toolbarHeight: kToolbarHeight + MediaQuery.of(context).viewPadding.top + 32,
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
                      "Lost items",
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
                                    cursorColor: primaryColor,
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
                  ),
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
                        hintText: ' Search lost items...',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('lostItem')
            .orderBy('annoucementDate', descending: true)
            .snapshots()
            .asBroadcastStream(),
        builder: (context, snapshot) {
          //if the connection state is "waiting", a progress indicatior will appear
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
            //if the connection state is "active"
          } else if (snapshot.connectionState == ConnectionState.active) {
            //if the collection snapshot is not empty
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
              if(data.isNotEmpty){
              return GridView.builder(
                itemCount: data.length,
                padding: const EdgeInsets.all(
                  8.0,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // crossAxisSpacing: 16.0,
                  // mainAxisSpacing: 16.0,
                ),
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
                    roomNumber: data[index]['roomnumber'],
                    floorNumber: data[index]['floornumber'],
                  );
                },
              );}
              else{
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    //if no announcement was uploaded
                    child: Text(
                      "No announcements match your search or filters!",
                      style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            } else {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  //if no announcement was uploaded
                  child: Text(
                    "No Announcements has been uploaded yet!",
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
          }
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              //if something went wrong
              child: Text(
                "Something went wrong",
              ),
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
          color: activeColor ? primaryColor : Colors.grey,
        ),
      ),
    );
  }
}
