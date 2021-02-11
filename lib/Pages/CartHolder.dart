import 'package:RMart/Pages/Cart.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:flutter/material.dart';

class CartHolder extends StatefulWidget {
  @override
  _CartHolderState createState() => _CartHolderState();
}

class _CartHolderState extends State<CartHolder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Cart(isFromCartHolder: true,callBack: Navigator.of(context).pop,),
    );
  }
}