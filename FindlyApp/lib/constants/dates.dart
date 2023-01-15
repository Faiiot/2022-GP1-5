import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Dates {
  static const String kLastWeek = 'Last Week';
  static const String kLastMonth = 'Last Month';
  static const String kLastTwoWeeks = 'Last 2 Weeks';

  //_now is a method  which returns current date and time
  static DateTime now() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime lastWeek() {
    return now().subtract(
      const Duration(days: 7),
    );
  }

  static DateTime lastTwoWeeks() {
    return now().subtract(
      const Duration(days: 14),
    );
  }

  static DateTime lastMonth() {
    return DateTime(
      now().year,
      now().month - 1,
      now().day,
    );
  }

  static DateTime? stringToDate(String? stringDate) {
    if (stringDate == kLastWeek) {
      return lastWeek();
    } else if (stringDate == kLastTwoWeeks) {
      return lastTwoWeeks();
    } else if (stringDate == kLastMonth) {
      return lastMonth();
    } else {
      return null;
    }
  }

  static String? dateToString(DateTime? date) {
    if (date == lastWeek()) {
      return kLastWeek;
    } else if (date == lastTwoWeeks()) {
      return kLastTwoWeeks;
    } else if (date == lastMonth()) {
      return kLastMonth;
    } else {
      return null;
    }
  }

  static DateTime parsedDate(Timestamp dbDate) {
    final parsedDate = dbDate.toDate();
    return DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
    );
  }
}
