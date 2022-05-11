import 'package:e_commerce_shop_app/utils/services/google_api_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert' show Encoding, json;
import 'package:http/http.dart' as http;

class FirebaseMessageServices {
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title// description
    importance: Importance.high,
  );

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<http.Response> sendAnNotification(
      String title, String content) async {
    AuthClient authToken = await GoogleApiServices.obtainAuthenticatedClient();
    String accessToken = authToken.credentials.accessToken.toJson()["data"];

    final Uri postUrl = Uri.parse(
        "https://fcm.googleapis.com/v1/projects/ecommerce-b1436/messages:send");
    final fcmToken = await FirebaseMessaging.instance.getToken();

    final headers = {
      'content-type': 'application/json',
      'Authorization': "Bearer $accessToken"
    };

    final body = {
      "message": {
        "token": fcmToken,
        "notification": {"body": content, "title": title}
      }
    };

    return await http.post(postUrl,
        body: json.encode(body),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);
  }
}
