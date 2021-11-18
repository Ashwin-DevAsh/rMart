import 'package:RMart/Helpers/NotificationHelper.dart';
import 'package:RMart/Models/CartListModel.dart';
import 'package:RMart/Models/FavouriteListModel.dart';
import 'package:RMart/Models/OrdersListModel.dart';
import 'package:RMart/Models/UserModel.dart';
import 'package:RMart/Pages/SplashScreen.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.backgroundColor,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));
    NotificationHelper.init();
    return ChangeNotifierProvider(
      create: (context) => OrderListModel(),
      child: ChangeNotifierProvider(
        create: (context) => FavouriteListModel(),
        child: ChangeNotifierProvider(
          create: (context) => CartListModel(),
          child: ChangeNotifierProvider(
              create: (context) => UserModel(),
              child: MaterialApp(
                  theme: ThemeData(
                    colorScheme: ThemeData().colorScheme.copyWith(
                      secondary: AppColors.accentColor,
                      primary: AppColors.accentColor,
                      primaryVariant: AppColors.accentColor,
                    ),
                  ),

                  debugShowCheckedModeBanner: false,
                  home: SplashScreen())),
        ),
      ),
    );
  }
}
