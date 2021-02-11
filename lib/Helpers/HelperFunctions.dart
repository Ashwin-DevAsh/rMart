import 'package:RMart/Models/CartListModel.dart';
import 'package:RMart/Models/CartProduct.dart';
import 'package:RMart/Pages/Merchant.dart';
import 'package:RMart/Widgets/AlertHelper.dart';
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


  static Future<bool> isSameCategory(context, CartListModel cart ,object,count)async{
    var lock = ["breakfast","lunch","snacks"];
    if(!lock.contains(object.category)){
      return true;
    }
    for(var i in cart.cart){
            if(lock.contains(i.product.category) && i.product.category!=object.category){
                if(await HelperFunctions.showWarning(context,object,i.product.category,object.category)){
                          Future.delayed(Duration(milliseconds: 500),()async{
                            await cart.clear();
                            await cart.addItem(CartProduct( object, count, object.price)); 
                            AlertHelper.showSuccessSnackBar(context, "Added Successfully !");
                          });
                        }
              return false;
            }
        }
       return true;
  }

  static showWarning(context,object,from,to){
       return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Oops !'),
                  content: Text("""Your cart contains dishes from $from section. Do you want to discard the selection and add dishes from $to section ?"""),
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