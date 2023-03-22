import 'package:cloud_firestore/cloud_firestore.dart';

class ReferenceData {
  static final _instance = ReferenceData._internal();

  static ReferenceData get instance {
    return _instance;
  }

  ReferenceData._internal();

  static final List<String> _categories = [];
  static final List<String> _locations = [];

  Future<void> _getDbCategories() async {
    _categories.addAll(
      await _getData(
        collection: "category",
        fieldName: "categoryName",
      ),
    );
    if (_categories.isNotEmpty) _categories.add("Others");
  }

  Future<void> _getDbLocations() async {
    _locations.addAll(
      await _getData(collection: "location", fieldName: "buildingName"),
    );
  }

  Future<List<String>> _getData({
    required String collection,
    required String fieldName,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(collection).get();
    final dbData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final List<String> data = [];
    for (final dbDatum in dbData) {
      data.add((dbDatum as Map)[fieldName]);
    }
    return data;
  }

  Future<void> getReferenceData() async {
    await _getDbCategories();
    await _getDbLocations();
  }

  List<String> get categories {
    return _categories;
  }

  List<String> get locations {
    return _locations;
  }
}
