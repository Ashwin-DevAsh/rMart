import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Pages/Registration/Otp.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:flutter/material.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  var shouldHidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              SingleChildScrollView(

                child: Column(
                  children: [
                  HelperWidgets.getHeader("", (){Navigator.pop(context);}),
                  SizedBox(height:20),
                  getGreetings(),
                  getTextField(),
                ],),

              ),
              Expanded(child: Center()),
              getFooter(context)

            ],
          ),
      ),
    );
  }


  Widget getTextField(){
    return Padding(
      padding: const EdgeInsets.only(left:20,right:20,top:40),
      child: Column(
        children: [
            TextField(
              cursorColor: AppColors.accentColor,
              decoration: new InputDecoration(hintText: "Name"),
              
            ),
            SizedBox(height: 30),
            TextField(
              cursorColor: AppColors.accentColor,
              decoration: new InputDecoration(hintText: "Email address"),
            ),
            SizedBox(height: 30),
            TextField(
              cursorColor: AppColors.accentColor,
              decoration: new InputDecoration(hintText: "Phone number"),
            ),
            SizedBox(height: 30),
            TextField(
              obscureText: shouldHidePassword,
              keyboardType: TextInputType.visiblePassword,
              cursorColor: AppColors.accentColor,
              decoration: 
              new InputDecoration(hintText: "Password",
              suffixIcon: IconButton(icon:Icon(shouldHidePassword?Icons.visibility_off:Icons.visibility),onPressed: (){
                setState(() {
                  shouldHidePassword= !shouldHidePassword;
                });
              },)),
            ),
        ],
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

  Widget getGreetings(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left:20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                Text(
                  "Create New",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                    Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}