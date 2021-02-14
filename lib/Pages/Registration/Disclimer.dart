

import 'package:RMart/assets/AppCololrs.dart';
import 'package:flutter/material.dart';
import 'package:RMart/Api/RegistrationApi.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Pages/Registration/Otp.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';


class Disclimer extends StatefulWidget {
  @override
  _DisclimerState createState() => _DisclimerState();
}

class _DisclimerState extends State<Disclimer> {
  var shouldHidePassword = true;

  var name = TextEditingController();
  var email = TextEditingController();
  var phoneNumber = TextEditingController();
  var collegeID = TextEditingController();
  var password = TextEditingController();

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: WillPopScope(
        onWillPop: (){
          if(isLoading){
            SystemNavigator.pop();
          }else{
            Navigator.of(context).pop();
          }
        },
              child: Builder(
          builder: (context) {
            return SafeArea(
                child: isLoading?Column(
                  children: [
                    Expanded(child: Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentColor),),),)
                  ],
                ):
                    Column(
                      children: [
                        Expanded(
                                                child: SingleChildScrollView(
                                                  physics: BouncingScrollPhysics(),

                            child: Column(
                              children: [
                              HelperWidgets.getHeader(context,"", (){Navigator.pop(context);}),
                              SizedBox(height:20),
                              getGreetings(),
                              getTextField(),
                              SizedBox(height: 30),

                            ],),

                          ),
                        ),
                              getFooter(context)

                      ],
                    ),

                 
            );
          }
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
              controller: name,
              
            ),
            SizedBox(height: 30),
          

            TextField(
              cursorColor: AppColors.accentColor,
              decoration: new InputDecoration(hintText: "Student ID / Staff ID"),
              controller: collegeID,
            ),
            SizedBox(height: 30),

            TextField(
              cursorColor: AppColors.accentColor,
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(hintText: "Email Address"),
              controller: email,
            ),
            SizedBox(height: 30),
            TextField(

              keyboardType: TextInputType.number,
              cursorColor: AppColors.accentColor,
              decoration: new InputDecoration(hintText: "Phone number"),
              controller: phoneNumber,
            ),
            SizedBox(height: 30),
            TextField(
              controller: password,
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
            SizedBox(
              height:MediaQuery.of(context).size.width/2
            )
        ],
      ),
    );
  }


  Widget getFooter(context) {
    return Container(
      color: AppColors.backgroundColor,
      // decoration: BoxDecoration(
      //                   borderRadius:BorderRadius.only(topLeft: Radius.circular(20)) ,
      //                   border: Border.all(color: Colors.grey.withAlpha(90),width: 0.5)
      //               ),
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Material(
      color: AppColors.backgroundColor,

        borderRadius: BorderRadius.only(topLeft:Radius.circular(20)),
          // elevation: 20,
              child: Row(children: [
                 SizedBox(width: 20),
        GestureDetector(
          onTap: (){
            try{
                  launch("mailto:rMart.support@rajalakshmi.edu.in?subject=rMart Help");
            }catch(e){}
          },
                  child: Text(
            "Need help?",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
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
      ),
    );
  }

  next(context) async{
    print("next");
   if(isValidInput(context)){

     setState(() {
       isLoading=true;
     });

      var dataGetOtp = {
        "email":email.text.trim(),
        "number":phoneNumber.text.trim()
      };


      var signUpData = {
        "email":email.text.trim(),
        "phoneNumber":phoneNumber.text.trim(),
        "name":name.text.trim(),
        "collegeID":collegeID.text.trim(),
        "password":password.text.trim()
      };

      var result = await RegistrationApi.getOtp(dataGetOtp);
      if(result["message"]=="done"){
          HelperFunctions.navigate(context, Otp(signUpdata:signUpData,email: email.text.trim(),number: phoneNumber.text.trim(),isRecoveryOtp: false,));
      }else{
        setState(() {
          isLoading=false;
        });
        Scaffold.of(context).showSnackBar(SnackBar(content:Text("Failed")));

      }

   }
  }

  bool isValidInput(context){

    if(name.text.isEmpty || collegeID.text.isEmpty || phoneNumber.text.isEmpty || password.text.isEmpty || email.text.isEmpty ){
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Invalid credientials"),));
      return false;
    }

    if(name.text.length<3){
       Scaffold.of(context).showSnackBar(SnackBar(content: Text("Invalid Name"),));
      return false;
    }


    if(email.text.length<5 || !email.text.contains("@") || !email.text.contains(".")){
       Scaffold.of(context).showSnackBar(SnackBar(content: Text("Invalid Email"),));
      return false;
    }

     if(collegeID.text.length<2){
       Scaffold.of(context).showSnackBar(SnackBar(content: Text("Invalid College ID"),));
      return false;
    }

    if(phoneNumber.text.length!=10 ){
       Scaffold.of(context).showSnackBar(SnackBar(content: Text("Invalid Phone Number"),));
      return false;
    }

    try{
      int.parse(phoneNumber.text);
    }catch(e){
       Scaffold.of(context).showSnackBar(SnackBar(content: Text("Invalid Phone Number"),));
    }

    // try{
    //   int.parse(collegeID.text);
    // }catch(e){
    //    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Invalid Phone Number"),));
    // }

    if(password.text.length<8){
       Scaffold.of(context).showSnackBar(SnackBar(content: Text("Password must be atleast 8 character"),));
       return false;
    }
    return true;
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