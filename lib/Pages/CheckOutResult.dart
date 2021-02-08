import 'dart:convert';

import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Context/UserContext.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Pages/Explore.dart';
import 'package:RMart/Pages/MyOrders.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:RMart/assets/AppFonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;

class CheckOutResult extends StatefulWidget {

  @required
  var products;
  @required
  var amount;
  @required
  var paymentMethod;


  CheckOutResult({this.products, this.amount, this.paymentMethod});

  @override
  _CheckOutResultState createState() => _CheckOutResultState();
}

class _CheckOutResultState extends State<CheckOutResult> {

  var isLoading = true;
  var isSuccess = false;



  Future<bool> placeOrder() async {

    var client = http.Client();
    try {
      Map data = {
        "products":widget.products,
        "amount":widget.amount.toString(),
        "transactionData":{
          "amount" :widget.amount.toString(),
          "to": {
            "id":   UserContext.user.rmartId,
            "name":   "rMart",
            "number": UserContext.user.number,
            "email":   UserContext.user.email
          },
          "from" : {
            "id" : "rpay@${widget.paymentMethod["number"]}",
            "number" :  widget.paymentMethod["number"],
            "name" :  widget.paymentMethod["name"],
            "email":  widget.paymentMethod["email"]
          }
        }
      };
      var body = json.encode(data);
      print(widget.paymentMethod["token"]);
      var uriResponse = await client.post(ApiContext.url+"/makeOrder",
          headers: {
            "Content-Type": "application/json",
            "token":widget.paymentMethod["token"]
          },
          body:body
      );
      Map result = json.decode(uriResponse.body);
      print(result);
      if(result["message"]=="done"){
        widget.paymentMethod["token"]="";
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
    } catch(e) {
      print(e);
      client.close();
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
      placeOrder();
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
          subtitle: "You can get further details in\n the orders section",
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
              placeOrder();
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
