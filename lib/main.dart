import 'package:RMart/Models/CartListModel.dart';
import 'package:RMart/Models/FavouriteListModel.dart';
import 'package:RMart/Models/OrdersListModel.dart';
import 'package:RMart/Pages/SplashScreen.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
     statusBarIconBrightness: Brightness.dark,
  ));
    return ChangeNotifierProvider(
      create:(context)=> OrderListModel(),
          child: ChangeNotifierProvider(
        create: (context)=>FavouriteListModel(),
        child: ChangeNotifierProvider(
          create: (context)=>CartListModel(),
          child: MaterialApp(
             theme: new ThemeData(
              primaryColor: AppColors.accentColor,
              primaryColorDark: AppColors.accentColor,
            ),
            debugShowCheckedModeBanner: false,
            home:SplashScreen()
          ),
        ),
      ),
    );
  }
}