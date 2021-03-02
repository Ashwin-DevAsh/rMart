import 'package:RMart/Api/ProductsApi.dart';
import 'package:RMart/Api/RegistrationApi.dart';
import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Context/UserContext.dart';
import 'package:RMart/Database/Appdatabase.dart';
import 'package:RMart/Database/Databasehelper.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Models/CartListModel.dart';
import 'package:RMart/Models/FavouriteListModel.dart';
import 'package:RMart/Models/User.dart';
import 'package:RMart/Pages/Registration/Login.dart';
import 'package:RMart/RemoteConfig/FirebaseRemoteConfig.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'MainPage.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen(){
    
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));
  
  }
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void getDatabaseInstance() async {
    DataBaseHelper.db = await AppDatabase.instance.database;
    DataBaseHelper.store = StoreRef.main();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async{
    await ProductsApi.loadDatas();
    await getDatabaseInstance();
    await isUserExist();
  }

  void openHomePage(BuildContext context){
    loadContextData();
    Future.delayed(Duration(seconds: 0),(){
      HelperFunctions.navigateReplace(context,MainPage());
    });
  }

  void loadMerchants(){
    ProductContext.data.forEach((key, value) {
         ProductContext.merchants.add(key);
    });
  }

  void isUserExist() async {
    
    bool userExist = await DataBaseHelper.store.record("User").exists(DataBaseHelper.db);
  

    if(userExist){
       UserContext.user =  User.fromMap(await DataBaseHelper.store.record("User").get(DataBaseHelper.db));
       bool isValidKeys = (await RegistrationApi.checkKeys())["message"]=="success";
       if(isValidKeys){
           openHomePage(context);
       }else{
          await DataBaseHelper.store.record("User").delete(DataBaseHelper.db);
          await FirebaseRempteConfig.reloadKeys();
          Future.delayed(Duration(seconds: 0),(){
            HelperFunctions.navigateReplace(context, Login());
          }); 
       }
    }else{
        await DataBaseHelper.store.record("User").delete(DataBaseHelper.db);
        await FirebaseRempteConfig.reloadKeys();
        Future.delayed(Duration(seconds: 0),(){
           HelperFunctions.navigateReplace(context, Login());
        });
    }
  }

  loadContextData(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartListModel>(context,listen: false).init(UserContext.user.cart);
      Provider.of<FavouriteListModel>(context,listen: false).init(UserContext.user.favourite);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor  : AppColors.backgroundColor,
      body: SafeArea(
          child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Center()),
              Expanded(child: Center()),
              Expanded(child: Center()),
              Expanded(child: Center()),
              Center(child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                              child: Container(
                    height: 100,
                    width: 100,
                    child: Image(image: Image.asset("lib/assets/Images/mart2.png").image)),
              ),),
              //
              // Text("from",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 16),),
              // Text("INITIATORS",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600,fontSize: 18),),
              Expanded(child: Center()),
              Expanded(child: Center()),
              Expanded(child: Center()),
              Expanded(child: Center()),
              Expanded(child: Center()),
              Expanded(child: Center()),
              Image(image: Image.asset("lib/assets/Images/initiators1.png").image,width: 140,),
              SizedBox(height:40)


            ],


          ),
        ),
      ),
    );
  }
}