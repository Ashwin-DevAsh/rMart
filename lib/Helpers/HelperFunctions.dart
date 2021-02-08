import 'package:RMart/Pages/Merchant.dart';
import 'package:RMart/Widgets/ScaleRoute.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelperFunctions{
  static navigate(BuildContext context,Widget screen){
    // Navigator.push(context, ScaleRoute(page: screen));
      Navigator.push(context, CupertinoPageRoute(builder: (ctx)=>screen));
  }
  static navigateReplace(BuildContext context,Widget screen){
    Navigator.pushReplacement(context, ScaleRoute(page: screen));
  }
}