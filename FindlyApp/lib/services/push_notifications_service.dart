import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class InAppNotifications {
  static Map<String, dynamic> buildInAppNotification(String message,
      String receiverId, String title, String notifyBy, String postId) {
    Map<String, dynamic> body = {
      'message': message,
      "post_id": postId,
      'is_seen': false,
      'notify_to': receiverId,
      'notify_by': notifyBy,
      'created_at': Timestamp.now(),
      'title': title
    };
    return body;
  }

  static sendInAppNotification(String key, Map<String, dynamic> body) async {
    await FirebaseFirestore.instance
        .collection("notifications")
        .doc(key)
        .set(body);
    log("Inapp sent: $body");
  }
}

class PushNotificationController {
  static String fcm = '';
  static Future<void> getUserAndSendPush(String body, String userId) async {
    var current = FirebaseAuth.instance.currentUser;
    DocumentSnapshot sna =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    if (sna.exists) {
      var a = sna.data() as Map;
      var title = (a['firstName'] ?? "") + " " + (a['LastName'] ?? "");
      log("User: ${sna.data()}");
      await InAppNotifications.sendInAppNotification(
          Timestamp.now().toString(),
          InAppNotifications.buildInAppNotification(
              body, userId, title, current!.uid, ""));

      // final Map<String, dynamic> doc = sna.data as Map<String, dynamic>;

      if (a['fcm'] != null) {
        sendPushNotification([a["fcm"]], title, body);
      }
    }
  }

  static Future<void> sendPushNotification(
      List<String> fcmTokens, String title, String body) async {
    await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAANktGGIo:APA91bHpt2rxrrk2YIO_3dNKM83_1RY7i-RMtJmMN1Cx6fndYmQ_efvplu-YRKcRMfP0wi33MC77ezIk3_jVReuh2RooL4O9eZJ7srilEuh0zoLJYUNAQelFq8V2i-plb6uPK0Ga72Wq',
      },
      body: jsonEncode(
        <String, dynamic>{
          'registration_ids': fcmTokens,
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'data': <String, dynamic>{
            'screen': 'specific_screen',
            'post_id': 123,
          },
        },
      ),
    );
  }
}
