import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class InAppNotifications {
  static Map<String, dynamic> buildInAppNotification(String notificationID,String message,
      String receiverId, String title, String notifyBy, String sourceId, String type,) {
    Map<String, dynamic> body = {
      'notificationID': notificationID,
      'type': type,
      'message': message,
      "source_id": sourceId,
      'is_seen': false,
      'notify_to': receiverId,
      'notify_by': notifyBy,
      'created_at':DateTime.now().millisecondsSinceEpoch,
      'title': title,
    };
    return body;
  }

  static sendInAppNotification(String key, Map<String, dynamic> body) async {
    await FirebaseFirestore.instance
        .collection("notifications")
        .doc(key)
        .set(body);
    log("******** Inapp sent: $body ********");
  }
}

class PushNotificationController {
  static String fcm = '';
  static Future<void> getUserAndSendPush(String body,String receiverId, String chatroomID) async {
    var current = FirebaseAuth.instance.currentUser;
    DocumentSnapshot receiver =
        await FirebaseFirestore.instance.collection("users").doc(receiverId).get();
    DocumentSnapshot sender =
    await FirebaseFirestore.instance.collection("users").doc(current!.uid).get();

    if (receiver.exists) {
      var receiverData = receiver.data() as Map;
      var senderData = sender.data() as Map;
      var title = (senderData['firstName'] ?? "") + " " + (senderData['LastName'] ?? "");
      log("User: ${receiver.data()}");
      String time = Timestamp.now().toString();
      await InAppNotifications.sendInAppNotification(
          time,
          InAppNotifications.buildInAppNotification(
              time,body, receiverId, title, current!.uid, chatroomID, "chat",));

      // final Map<String, dynamic> doc = sna.data as Map<String, dynamic>;

      if (receiverData['fcm'] != null) {
        sendPushNotification([receiverData["fcm"]], title, body);
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
