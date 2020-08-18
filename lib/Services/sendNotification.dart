import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ragapp/utils/keys.dart';

// ignore: camel_case_types
class postNotification{

  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future sendNotificationOnBackground({@required title, image, docId, url, body, isPost, hasUrl, uid}) async {
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$FIREBASE_MESSAGING_KEY', // Constant string
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "docId": docId != null ? docId : null,
            "collapse_key": "com.rag.ragapp",
            "title": title,
            "body": body,
            "image": image != null ? image : null,
            "isPost": isPost,
            "hasUrl": hasUrl,
            "url": url != null ? url : null,
            "uid": uid
          },
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "docId": docId != null ? docId : null,
          "collapse_key": "com.rag.ragapp",
          "title": title,
          "body": body,
          "image": image != null ? image : null,
          "isPost": isPost,
          "hasUrl": hasUrl,
          "url": url != null ? url : null,
          "uid": uid,
          "android":{
            "priority":"high"
          },
          "apns":{
            "headers":{
              "apns-priority":"5"
            }},
          'priority': 'high',
          'data': <String, dynamic>{
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "docId": docId != null ? docId : null,
            "collapse_key": "com.rag.ragapp",
            "title": title,
            "body": body,
            "image": image != null ? image : null,
            "isPost": isPost,
            "hasUrl": hasUrl,
            "url": url != null ? url : null,
            "uid": uid
          },
          'to': '/topics/all'
        },
      ),
    );
  }

}