import 'dart:convert';

import 'package:RMart/Api/OrderApi.dart';
import 'package:RMart/Api/ProfileApi.dart';
import 'package:RMart/Api/TransactionApi.dart';
import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Context/UserContext.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Pages/Explore.dart';
import 'package:RMart/Pages/Orders/MyOrders.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:RMart/assets/AppFonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AddMoneyResult extends StatefulWidget {
  var response;
  var amount;

  AddMoneyResult({this.response, this.amount});

  @override
  _AddMoneyResultState createState() => _AddMoneyResultState();
}

class _AddMoneyResultState extends State<AddMoneyResult> {
  var isLoading = true;
  var isSuccess = false;

  Future<bool> verifyRazorpayPayment() async {
    var orderID = widget.response.orderId;
    var paymentID = widget.response.paymentId;

    var data = {
      "orderID": orderID,
      "paymentID": paymentID,
    };

    var result = await TransactionApi.addMoney(data);
    print(result);
    UserContext.user.balance =
        (await ProfileApi.getBalance({"id": UserContext.getId})).toString();
    if (result["message"] == "success") {
      setState(() {
        isLoading = false;
        isSuccess = true;
      });
      return true;
    } else {
      setState(() {
        isLoading = false;
        isSuccess = false;
      });
      return false;
    }
  }

  Future<bool> verifyRmartPayment() async {
    if (widget.response["message"] == "success") {
      setState(() {
        isLoading = false;
        isSuccess = true;
      });
      return true;
    } else {
      setState(() {
        isLoading = false;
        isSuccess = false;
      });
      return false;
    }
  }

  verifyPayment() {
    Future.delayed(Duration(seconds: 1), () {
      verifyRazorpayPayment();
    });
  }

  @override
  void initState() {
    verifyPayment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loader();
    } else if (isSuccess) {
      return getSuccessSheet(
          imagePath: "lib/assets/Images/done.png",
          titleFirstLine: "Congratulations",
          subtitle: getSubTitle(),
          buttonText: "Done",
          onButtonTap: () {
            Navigator.of(context).pop();
          });
    } else {
      return getSuccessSheet(
          imagePath: "lib/assets/Images/failed.png",
          titleFirstLine: "Failed",
          subtitle:
              "Kindly recheck after 5-10 minutes if the amount got deducted from the bank",
          buttonText: "Try again",
          onButtonTap: () {
            setState(() {
              isLoading = true;
            });
            verifyPayment();
          });
    }
  }

  Widget loader() {
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

  Widget getSuccessSheet(
      {imagePath,
      titleFirstLine,
      titleSecondLine,
      subtitle,
      buttonText,
      onButtonTap}) {
    return Scaffold(
      bottomNavigationBar: getBottomSheet(buttonText, onButtonTap),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: Image.asset(imagePath).image,
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              SizedBox(
                height: 40,
              ),
              Column(
                children: [
                  Text(
                    titleFirstLine,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentColor,
                        fontFamily: AppFonts.textFonts),
                  ),
                  titleSecondLine == null
                      ? Center()
                      : Text(
                          titleSecondLine,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentColor,
                              fontFamily: AppFonts.textFonts),
                        ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: AppFonts.textFonts,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String getSubTitle() {
    return "Amount of Rs. ${widget.amount} has been successful added in your rMart wallet.";
  }

  Widget getBottomSheet(buttonText, onButtonTap) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          GestureDetector(
              onTap: () {
                onButtonTap();
              },
              child: Material(
                elevation: 5,
                shadowColor: AppColors.accentColor,
                color: AppColors.accentColor,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        buttonText,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.backgroundColor),
                      ),
                    ],
                  ),
                  width: 160,
                ),
              )),
          SizedBox(height: 25),
          // GestureDetector(
          //     onTap: () {
          //       HelperFunctions.navigateReplace(context, Explore());
          //     },
          //     child: Text(
          //       "Order something else",
          //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          //     )),
        ],
      ),
    );
  }
}
