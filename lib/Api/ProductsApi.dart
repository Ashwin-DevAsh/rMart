import 'dart:convert';

import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Context/UserContext.dart';
import 'package:RMart/RemoteConfig/FirebaseRemoteConfig.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http ;
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

class ProductsApi{

  static var categories = ['breakfast','lunch','snacks','others'];
  static var categoryTime = {
    "breakfast":"collect during breakfast or morning break",
    "lunch":"collect during lunch or afternoon break.",
    "snacks":"collect during lunch or break.",
    "others":"collect during breakfast, lunch or break"
  };
  
  static Future<List> getProducts() async{
     String signature = await SmsRetrieved.getAppSignature();
     print("App id = "+signature);
    var client = http.Client();
     var uriResponse = await client.get(ApiContext.martURL+"/getAllProducts",    
         headers: {
            "key": await FirebaseRempteConfig.getServerKey(),
            "Content-Type": "application/json",
          },
          );
     Map result = json.decode(uriResponse.body);
     if(result["message"]!="success"){
       return [];
     }
     List allProduscts = result["allProducts"];
     print("All Produscts = "+result.toString());
     print("ServerKey = ${await FirebaseRempteConfig.getServerKey()}\n\n");
     return allProduscts;
  }

  static Future<List> getMerchants() async{
     var client = http.Client();
     var uriResponse = await client.get(ApiContext.profileURL+"/getMerchants",
        headers: {
            "key": await FirebaseRempteConfig.getServerKey(),
            "Content-Type": "application/json",
          },);
     var result = json.decode(uriResponse.body);
     try{
       var _ = result["message"];
       return [];
     }  catch(e){}
     print(result);
     return result;
  }

  static getMyOrders() async{
     var client = http.Client();
     var uriResponse = await client.get(ApiContext.martURL+"/getMyOrders/rMart@"+UserContext.user.number, headers: {
            "key": await FirebaseRempteConfig.getServerKey(),
            "token":UserContext.user.token,
            "Content-Type": "application/json",
          },);
     Map result = json.decode(uriResponse.body);
     if(result["message"]!="success"){
       return [];
     }
     List orders = result["orders"];
     print(result);
     return orders;
  }

  static loadDatas() async{
    var data = {};
    var products = await getProducts();
    var merchants = await getMerchants();

    merchants.forEach((element) { 
      ProductContext.merchantIDMap[element["id"]]=element;
      ProductContext.merchants.add(element["id"]);
      data[element["id"]]={};
      categories.forEach((category) {
           data[element["id"]][category]=[];
      });
    });



    products.forEach((element) {
        if(categories.contains(element["category"])){
            data[element["ownerid"]][element["category"]] 
            .insert(0,element);
        }else{
          categories.forEach((category) {
             data[element["ownerid"]][category].add(element);
          });
        }
    });
    ProductContext.data = data;
    ProductContext.init();
  }
}