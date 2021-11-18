import 'package:RMart/Api/ProfileApi.dart';
import 'package:RMart/Api/RegistrationApi.dart';
import 'package:RMart/Models/UserModel.dart';
import 'package:RMart/Database/Databasehelper.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Models/User.dart';
import 'package:RMart/Pages/MainPage.dart';
import 'package:RMart/Pages/Registration/Otp.dart';
import 'package:RMart/Pages/Registration/SignUp.dart';
import 'package:RMart/Widgets/HelperWidgets.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sembast/sembast.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var isLoding = false;
  var isButtonLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void login(context) async {
    if (isValidInput(context)) {
      setState(() {
        isButtonLoading = true;
      });

      var canLogin = await RegistrationApi.canLogin({
        "phoneNumber": email.text.trim().toLowerCase(),
        "email": email.text.trim()
      });

      if (canLogin["message"] != "done") {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(canLogin["message"])));
        setState(() {
          isButtonLoading = false;
        });
        return;
      }

      setState(() {
        isButtonLoading = false;

        isLoading = true;
      });

      var logindata = {
        "email": email.text.trim().toLowerCase(),
        "phoneNumber": email.text.trim(),
        "password": password.text.trim()
      };

      var result = await RegistrationApi.login(logindata);
      if (result["message"] == "done") {
        openHomePage(result["user"], result["token"]);
      } else {
        setState(() {
          isLoading = false;
        });
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Failed")));
      }
    }
  }

  openHomePage(result, token) async {
    UserModel.user = User(
        name: result["name"],
        number: result["number"],
        email: result["email"],
        token: token,
        cart: [],
        favourite: []);
    UserModel.user.balance =
        (await ProfileApi.getBalance({"id": UserModel.getId})).toString();
    await StoreRef.main()
        .record("User")
        .add(DataBaseHelper.db, UserModel.user.toMap());
    Future.delayed(Duration(seconds: 1), () {
      HelperFunctions.navigateReplace(
          context,
          MainPage(
            shouldShowDisclimer: true,
          ));
    });
  }

  isValidInput(context) {
    try {
      int.parse(email.text.toLowerCase().trim());
      if (email.text.trim().length != 10) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Invalid Phone Number"),
        ));
        return false;
      }
    } catch (e) {
      if (email.text.trim().length < 5) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Invalid credientials"),
        ));
        return false;
      }
    }

    if (password.text.length < 8) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Invalid Password"),
      ));
      return false;
    }
    return true;
  }

  void loginSuccess(admin, token) async {}

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () {
          SystemNavigator.pop();
        },
        child: SafeArea(
          child: Builder(builder: (context) {
            return isLoading
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
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        getHeader(),
                        Expanded(child: Center()),
                        getLoginComponents(),
                        Expanded(child: Center()),
                        Expanded(child: Center()),
                        getFooter(context)
                      ],
                    ),
                  );
          }),
        ),
      ),
    );
  }

  bool isValidNumberOrEmail(context) {
    try {
      int.parse(email.text.toLowerCase());
      if (email.text.length != 10) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please enter valid email or phone number"),
        ));
        return false;
      }
    } catch (e) {
      if (email.text.length < 5) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please enter valid email or phone number"),
        ));
        return false;
      }
    }

    return true;
  }

  Widget getFooter(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Row(children: [
        SizedBox(width: 20),
        GestureDetector(
          onTap: () async {
            if (isValidNumberOrEmail(context)) {
              setState(() {
                isButtonLoading = true;
              });
              var canLogin = await RegistrationApi.canLogin({
                "phoneNumber": email.text.trim(),
                "email": email.text.trim()
              });

              if (canLogin["message"] != "done") {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(canLogin["message"])));
                setState(() {
                  isButtonLoading = false;
                });
                return;
              }

              setState(() {
                isButtonLoading = false;
              });
              HelperFunctions.navigate(
                  context,
                  Otp(
                    isRecoveryOtp: true,
                    number: email.text.trim(),
                    email: email.text.trim(),
                  ));
            }
          },
          child: Text(
            "forgot Password?",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Center()),
        GestureDetector(
          onTap: () {
            login(context);
          },
          child: Material(
            color: AppColors.accentColor,
            borderRadius: BorderRadius.circular(10),
            elevation: 10,
            child: Container(
              height: 50,
              width: 80,
              child: isButtonLoading
                  ? Center(
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    )
                  : Icon(
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

  Widget getHeader() {
    return Container(
      height: 75,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 7.5),
                Container(width: 45, height: 2, color: AppColors.accentColor)
              ],
            ),
            SizedBox(width: 40),
            GestureDetector(
              onTap: () {
                HelperFunctions.navigate(context, SignUp());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign up",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 7.5),
                  Container(width: 50, height: 2)
                ],
              ),
            ),

            Expanded(child: Center()),
            //  Image(image:  AssetImage("lib/src/Assets/Images/appIcon512.png"),height: 50,)
          ],
        ),
      ),
    );
  }

  Widget getLoginComponents() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 32,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Again !",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 80),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: email,
                    cursorColor: AppColors.accentColor,
                    decoration: new InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.accentColor, width: 2),
                        ),
                        hintText: "Email or phone number"),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    controller: password,
                    cursorColor: AppColors.accentColor,
                    decoration: new InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.accentColor, width: 2),
                        ),
                        hintText: "Password"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
