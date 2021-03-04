import 'package:flutter/material.dart';

class AlertHelper{
  static showSuccessSnackBar(context,text){
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(text),backgroundColor: Colors.green,duration: Duration(milliseconds: 750),)
    );
  }
}