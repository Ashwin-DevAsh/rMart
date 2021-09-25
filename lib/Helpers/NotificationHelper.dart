import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHelper{

 static FirebaseMessaging messaging;
 static NotificationSettings settings;
 

  static  init() async{
     messaging = FirebaseMessaging.instance;
     settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      await FirebaseMessaging.instance.subscribeToTopic('rMart');
      print('User granted permission: ${settings.authorizationStatus}');
      String token = await messaging.getToken();
      print("token = "+token);
  }




}