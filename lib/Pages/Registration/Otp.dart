import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:flutter/material.dart';


class Otp extends StatefulWidget {
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
                 child: Column(
                   children: [
                     HelperWidgets.getHeader("", (){}),

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
                    ),
                  );
                }
              
              
                Widget getTextView(){
                  return Padding(
                    padding: const EdgeInsets.only(left:20,right: 20),
                    child: Column(
                      children: [
                             TextField(
                              cursorColor: AppColors.accentColor,
                              decoration: new InputDecoration(hintText: "0 0 0 0"),
                            ),
                      ],
                    ),
                  );
                }
              
                Widget getGreetings(){
                  return Padding(
                    padding: const EdgeInsets.only(left:20,right:20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                               Text(
                                    "Otp Verification",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold
                                    )
                                    ),
                                    SizedBox(height: 30),
                            Text(
                                    "Please enter the 4 digit otp which we sent to your email and phone number",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 17,
                                    )
                                    )
                        ],
                      ),
                    ),
                  );
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
            HelperFunctions.navigate(context, Otp());
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