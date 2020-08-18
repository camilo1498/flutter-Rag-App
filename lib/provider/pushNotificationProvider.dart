import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider{
  //TODO: instance
 FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
 //TODO: controller
 final _messageStreamController = StreamController<Map<String,dynamic>>.broadcast();

 Stream<Map<String, dynamic>> get messages => _messageStreamController.stream;

 initNotifications(){
   _firebaseMessaging.requestNotificationPermissions();

   _firebaseMessaging.getToken().then((token){
     print('=== FCM Token ===');
     print(token);
   });
   _firebaseMessaging.subscribeToTopic('all');

   _firebaseMessaging.configure(
       onMessage: (Map<String, dynamic> message) async {
         print("onMessage: $message");

         Map<String, dynamic> argument = {};
         if(Platform.isAndroid){
           argument = {"type": "onMessage", "content":message};
         }
         _messageStreamController.sink.add(argument);
       },
       onLaunch: (Map<String, dynamic> message) async {
         print("onLaunch: $message");
         Map<String, dynamic> argument = {};
         if(Platform.isAndroid){
           argument = {"type": "onLaunch", "content":message};
         }
         _messageStreamController.sink.add(argument);

       },
       onResume: (Map<String, dynamic> message) async {
         print("onResume: $message");
         Map<String, dynamic> argument = {};
         if(Platform.isAndroid){
           argument = {"type": "onResume", "content":message};
         }
         _messageStreamController.sink.add(argument);
       },
   );
 }
 dispose(){
   _messageStreamController?.close();
 }
}