import 'package:RMart/Api/RecoveryApi.dart';
import 'package:RMart/Context/UserContext.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  var number;
  var email;

   ChangePassword(this.number,this.email);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
    var shouldHidePassword = true;

  var password = TextEditingController();
  var confirmPassword = TextEditingController();

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: (){
     
            Navigator.of(context).pop();
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

               
            SizedBox(height: 30),
            TextField(
              controller: confirmPassword,
              obscureText: shouldHidePassword,
              keyboardType: TextInputType.visiblePassword,
              cursorColor: AppColors.accentColor,
              decoration: 
              new InputDecoration(hintText: "Confirm Password",
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
      child: Material(
        borderRadius: BorderRadius.only(topLeft:Radius.circular(20)),
              child: Row(children: [
                 SizedBox(width: 20),
        GestureDetector(
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
   if(isValidInput(context)){
      setState(() {
        isLoading=true;
      });
   
      var dataGetOtp = {
        "email":widget.email,
        "number":widget.number,
        "password":password.text.trim()
      };
         var result = await RecoveryApi.changePassword(dataGetOtp);
         if(result["message"]=="done"){
          setState(() {
            isLoading=false;
          });
           showDialog(
              barrierDismissible: false,
            context: context,
            child: new AlertDialog(
              title: const Text("Successfully Changed !"),
              content: Text("Dear user your password has been successfully changed"),
              actions: [
                new FlatButton(
                  child:  Text("Ok",style: TextStyle(color: AppColors.accentColor),),
                  onPressed: (){
                    Navigator.pop(context);
                    Future.delayed(Duration(milliseconds: 500),(){
                    Navigator.pop(context);

                    });
                    },
                ),
              ],
            ),
        );
          //  Future.delayed(Duration(seconds: 1),(){
             
          //  });
         }else{
          setState(() {
            isLoading=false;
          });
            Scaffold.of(context).showSnackBar(SnackBar(content:Text(result["message"])));
         }
  }
  }

  bool isValidInput(context){

    if(password.text.isEmpty || confirmPassword.text.isEmpty){
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Invalid credientials"),));
      return false;
    }

    if(password.text.length<8){
       Scaffold.of(context).showSnackBar(SnackBar(content: Text("Password must be atleast 8 character"),));
       return false;
    }

    if(confirmPassword.text != password.text){
       Scaffold.of(context).showSnackBar(SnackBar(content: Text("Password not match"),));
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
                  "Change Your",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                    Text(
                  "Password",
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