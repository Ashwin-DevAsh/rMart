import 'package:RMart/Api/RecoveryApi.dart';
import 'package:RMart/Api/RegistrationApi.dart';
import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Context/UserContext.dart';
import 'package:RMart/Database/Databasehelper.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Models/User.dart';
import 'package:RMart/Pages/Registration/ChangePassword.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sembast/sembast.dart';

import '../MainPage.dart';


class Otp extends StatefulWidget {

  var signUpdata;
  var isRecoveryOtp = false;
  var number;
  var email;

  Otp({this.signUpdata,this.isRecoveryOtp,this.email,this.number});

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {

  var otp = TextEditingController();
  var isLoading = false;

  @override
  void initState() {
    if(widget.isRecoveryOtp){
      var dataGetOtp = {
        "email":widget.email,
        "number":widget.number
      };
      RecoveryApi.getRecoveryOtp(dataGetOtp);
      }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: WillPopScope(
        onWillPop: (){
          if(widget.isRecoveryOtp){
            Navigator.pop(context);
          }else{
             SystemNavigator.pop();
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
                ):Column(
                children: [
                  SingleChildScrollView(
                       child: Column(
                         children: [
                           HelperWidgets.getHeader(context,"", Navigator.of(context).pop),

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
          }
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
                               controller: otp,
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
                            Padding(
                              padding: const EdgeInsets.only(left:2.0),
                              child: Text(
                                      "Please enter the 4 digit otp which we sent to your email and phone number",
                                      style: TextStyle(
                                        height: 1.4,
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 17,
                                      )
                                      ),
                            )
                        ],
                      ),
                    ),
                  );
                }

  next(context)async{
   if(isValidInput(context)){
      setState(() {
        isLoading=true;
      });
      if(widget.isRecoveryOtp){
           var dataGetOtp = {
        "email":widget.email,
        "number":widget.number,
        "otp":otp.text.trim()
      };
         var result = await RecoveryApi.verifyRecoveryOtp(dataGetOtp);
         if(result["message"]=="done"){
           Future.delayed(Duration(seconds: 1),(){
             HelperFunctions.navigateReplace(context, ChangePassword(widget.number,widget.email));
           });
         }else{
          setState(() {
            isLoading=false;
          });
            Scaffold.of(context).showSnackBar(SnackBar(content:Text(result["message"])));
         }

      }else{
        widget.signUpdata["otp"]=otp.text.trim();
        var result = await RegistrationApi.signUp( widget.signUpdata);
        print(result);
        if(result["message"]=="done"){
         openHomePage(widget.signUpdata,result["token"]);
        }else{
          setState(() {
            isLoading=false;
          });
          Scaffold.of(context).showSnackBar(SnackBar(content:Text(result["message"])));
        }
      }

  
   }
  }

  openHomePage(result,token)async{
     UserContext.user = User(
       name:result["name"],
       number:result["phoneNumber"],
       email: result["email"],
       token:token,
       cart: [],favourite: []);
       print(UserContext.user.toMap());
     await StoreRef.main().record("User").add(DataBaseHelper.db,  UserContext.user.toMap());
        Future.delayed(Duration(seconds: 1),(){
   
      HelperFunctions.navigateReplace(context,MainPage(shouldShowDisclimer: true,));
    });
  }


  isValidInput(context){
    if(otp.text.length<4){
       Scaffold.of(context).showSnackBar(SnackBar(content: Text("Invalid Otp"),));
      return false;
    }

    return true;

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