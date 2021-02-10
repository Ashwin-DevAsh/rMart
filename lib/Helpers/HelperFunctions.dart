import 'package:RMart/Pages/Merchant.dart';
import 'package:RMart/Widgets/ScaleRoute.dart';
import 'package:RMart/assets/AppCololrs.dart';
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


  static bool isSameCategory(cart,object){
        for(var i in cart){
                            if(i.product.category!=object.category){
                              return false;
                            }
                          }

                return true;
  }

  static showWarning(context,cart,object){
       return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Oops !'),
                  content: Text("""You have choosed item from another category are you sure thet you want remove the existing item from the cart"""),
                  actions: <Widget>[
                    new FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // dismisses only the dialog and returns false
                      },
                      child: Text('No',style: TextStyle(color: AppColors.accentColor),),
                    ),
                    FlatButton(
                      onPressed: () {
                           Navigator.of(context).pop(true);
                                       
                      },

                      child: Text('Yes',style: TextStyle(color: AppColors.accentColor)),
                    ),
                  ],
                );
              },
      );
  }

   static showAlertDialog(context,title,subtitle){
       return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(title),
                  content: Text(subtitle),
                  actions: <Widget>[
                  
                    FlatButton(
                      onPressed: () {
                           Navigator.of(context).pop(true);
                                       
                      },

                      child: Text('OK',style: TextStyle(color: AppColors.accentColor)),
                    ),
                  ],
                );
              },
      );
  }

}