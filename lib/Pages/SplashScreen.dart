import 'package:RMart/Api/ProductsApi.dart';
import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Context/UserContext.dart';
import 'package:RMart/Database/Appdatabase.dart';
import 'package:RMart/Database/Databasehelper.dart';
import 'package:RMart/Helpers/HelperFunctions.dart';
import 'package:RMart/Models/CartListModel.dart';
import 'package:RMart/Models/FavouriteListModel.dart';
import 'package:RMart/Models/Product.dart';
import 'package:RMart/Models/User.dart';
import 'package:RMart/Pages/Registration/Login.dart';
import 'package:RMart/assets/AppCololrs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'MainPage.dart';
import 'Products.dart';

class SplashScreen extends StatefulWidget {
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
    Future.delayed(Duration(seconds: 1),(){
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
      //  openHomePage(context);
        HelperFunctions.navigate(context, Login());
    }else{
      await getRPayAccess();
    }
  }

   getRPayAccess(){
      Future.delayed(Duration(seconds: 1),()async{
        var platform =  MethodChannel("NativeChannel");
        Map result = await platform.invokeMethod("getAccess");
        print(result);
        if(result["message"]=="Success"){
            UserContext.user = User(name:result["name"],number:result["number"],email: result["email"],cart: [],favourite: []);
            await DataBaseHelper.store.record("User").add(DataBaseHelper.db,  UserContext.user.toMap());
            openHomePage(context);
        }else if(result["message"]=="Failed"){
          Future.delayed(Duration(seconds: 1),(){
            SystemNavigator.pop();
          });
        }
      });
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
              Center(child: Container(
                  height:MediaQuery.of(context).size.height*0.6,
                  width: MediaQuery.of(context).size.width*0.6,
                  child: Image(image: Image.asset("lib/assets/Images/martLogo.png").image)),),
              //
              // Text("from",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 16),),
              // Text("INITIATORS",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600,fontSize: 18),),

            ],


          ),
        ),
      ),
    );
  }
}