import 'package:RMart/Api/ProfileApi.dart';
import 'package:RMart/Api/RecoveryApi.dart';
import 'package:RMart/Api/RegistrationApi.dart';
import 'package:RMart/Api/TransactionApi.dart';
import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Models/UserModel.dart';
import 'package:RMart/Database/Databasehelper.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Models/User.dart';
import 'package:RMart/Pages/Registration/ChangePassword.dart';
import 'package:RMart/Pages/Transactions/AddMoneyResult.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sembast/sembast.dart';

import '../MainPage.dart';

class AddMoney extends StatefulWidget {
  @override
  _AddMoneyState createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  var otp = TextEditingController();
  var isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return;
        },
        child: Builder(builder: (context) {
          return SafeArea(
            child: isLoading
                ? Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.accentColor),
                          ),
                        ),
                      )
                    ],
                  )
                : Column(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            HelperWidgets.getHeader(
                                context, "", Navigator.of(context).pop),
                            SizedBox(height: 30),
                            getGreetings(),
                            SizedBox(height: 60),
                            getTextView()
                          ],
                        ),
                      ),
                      Expanded(child: Center()),
                      getFooter(context)
                    ],
                  ),
          );
        }),
      ),
    );
  }

  Widget getTextView() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            controller: otp,
            cursorColor: AppColors.accentColor,
            decoration: new InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.accentColor, width: 2),
                ),
                hintText: "₹ 0"),
          ),
        ],
      ),
    );
  }

  Widget getGreetings() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add Money",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Text(
                  "Amount once added cannot be withdrawn and shall only be utilized inside rMart.",
                  style: TextStyle(
                    height: 1.4,
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 17,
                  )),
            )
          ],
        ),
      ),
    );
  }

  next(context) async {
    if (isValidInput(context)) {
      setState(() {
        isLoading = true;
      });
      var amount = int.parse(otp.text);
      var data = {
        "amount": amount,
        "toMetadata": {
          "id": UserModel.getId,
          "name": UserModel.user.name,
          "number": UserModel.user.number,
          "email": UserModel.user.email
        }
      };
      var result = await TransactionApi.createAddMoneyOrder(data);
      print(result);
      if (result["message"] == "done") {
        var orderID = result["orderID"];
        var signature = result["signature"];
        var key = result["key_id"];
        razorpayCheckout(amount, orderID, signature, key);
      }
    }
  }

  var options = {
    'name': 'rMart',
    'description': 'by team initiators',
    'prefill': {'contact': UserModel.user.number, 'email': UserModel.user.email}
  };

  razorpayCheckout(amount, orderID, signature, key) {
    var razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    print("\n\norder id = " + orderID);
    try {
      options["amount"] = amount * 100;
      options["order_id"] = orderID;
      options["key"] = key;
      //  options["signature"] = signature;
      razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("\n\n external app = " + response.toString());
    setState(() {
      isLoading = false;
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      isLoading = false;
    });
    HelperFunctions.navigateReplace(
        context,
        AddMoneyResult(
          response: response,
          amount: otp.text,
        ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("\n\n failed = " + response.toString());
    setState(() {
      isLoading = false;
    });
  }

  isValidInput(context) {
    try {
      var amount = int.parse(otp.text);
      if (amount < 0) {
        throw Exception("Invalid Amount");
      }
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Invalid Amount"),
      ));
      return false;
    }
  }

  Widget getFooter(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Row(children: [
        SizedBox(width: 20),
        // Text(
        //   "forgot Password?",
        //   style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        // ),
        Expanded(child: Center()),
        GestureDetector(
          onTap: () {
            next(context);
          },
          child: Material(
            color: AppColors.accentColor,
            borderRadius: BorderRadius.circular(10),
            elevation: 10,
            child: Container(
              height: 50,
              width: 80,
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        )
      ]),
    );
  }
}
