import 'dart:convert';

import 'package:RMart/Api/OrderApi.dart';
import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Context/UserContext.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Pages/Explore.dart';
import 'package:RMart/Pages/MyOrders.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:RMart/assets/AppFonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckOutResult extends StatefulWidget {


  PaymentSuccessResponse response;
  String category;


  CheckOutResult({this.response,this.category});

  @override
  _CheckOutResultState createState() => _CheckOutResultState();
}

class _CheckOutResultState extends State<CheckOutResult> {

  var isLoading = true;
  var isSuccess = false;

  Future<bool> verifyPayment() async {

    var orderID = widget.response.orderId;
    var paymentID = widget.response.paymentId;

    var data = {
        "orderID":orderID,
        "paymentID":paymentID,
    };

    var result = await OrderApi.verifyPayment(data);
    print(result);

    if(result["message"]=="success"){
        setState(() {
          isLoading = false;
          isSuccess = true;
        });
        return true;
      }else{
        setState(() {
          isLoading = false;
          isSuccess = false;
        });
        return false;
      }
 
  }


  
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1),(){
      verifyPayment();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading){
      return loader();
    }else if(isSuccess){
      return getSuccessSheet(
          imagePath: "lib/assets/Images/done.png",
          titleFirstLine: "Thank you for",
          titleSecondLine: "your order",
          subtitle: getSubTitle(),
          buttonText: "Visit my orders",
          onButtonTap: (){
            HelperFunctions.navigateReplace(context, MyOrders());
          }
      );
    }else{
      return getSuccessSheet(
          imagePath: "lib/assets/Images/failed.png",
          titleFirstLine: "Sorry for the",
          titleSecondLine: "trouble",
          subtitle: "there might be an issues in\n our server",
          buttonText: "Try again",
          onButtonTap: (){
            setState(() {
              isLoading=true;
            });
            Future.delayed(Duration(seconds: 1),(){
              verifyPayment();
            });
          }
      );
    }
  }

  Widget loader(){
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentColor),
          ),
        ),
      ),
    );
  }


  Widget getSuccessSheet({imagePath,titleFirstLine,titleSecondLine,subtitle,buttonText,onButtonTap}){
    return Scaffold(
      bottomNavigationBar: getBottomSheet(buttonText,onButtonTap),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: Image.asset(imagePath).image,
                width: MediaQuery.of(context).size.width*0.5,
              ),
              SizedBox(height: 40,),
              Column(
                children: [
                  Text(titleFirstLine,
                    style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600,color: AppColors.accentColor,fontFamily: AppFonts.textFonts),),
                  Text(titleSecondLine,
                    style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600,color: AppColors.accentColor,fontFamily: AppFonts.textFonts),),
                  SizedBox(height: 30,),
                  Text(subtitle,
                    style: TextStyle(color: Colors.grey,fontFamily: AppFonts.textFonts,fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  String getSubTitle(){
    try{
      print("category "+widget.category.toString());
      switch(widget.category){
        case 'breakfast':{
          return "You may collect your order during breakfast\n or morning break.";
        }
        case 'lunch':{
          return "You may collect your order during lunch\n or afternoon break.";
        }
        case 'snacks':{
          return "You may collect your order during morning\n break or lunch or afternoon break";
        }
        default:{
          return "You can get further details in\n the orders section";
        }
      }
    }catch(e){
          print(e);
          return "You can get further details in\n the orders section";
    }

  }



  Widget getBottomSheet(buttonText,onButtonTap){
    return Container(
      height: 120,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            GestureDetector(
            onTap: (){
              onButtonTap();
                 },
              child: Material(
                elevation: 5,
                shadowColor: AppColors.accentColor,
                color: AppColors.accentColor,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  height:50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(buttonText,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColors.backgroundColor),),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width-40,
                ),
              )
            ),
            SizedBox(height:25),
            GestureDetector(
                onTap: (){
                  HelperFunctions.navigateReplace(context, Explore());
                },
                child: Text("Order something else",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
          ],
        ) ,
    );
  }
}
