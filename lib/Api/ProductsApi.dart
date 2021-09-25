import 'dart:convert';

import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Context/UserContext.dart';
import 'package:RMart/RemoteConfig/FirebaseRemoteConfig.dart';
import 'package:http/http.dart' as http ;


class ProductsApi{

  static var categories = ['breakfast','lunch','snacks','others'];
  static var categoryTime = {
    "breakfast":"Collect during breakfast or morning break.",
    "lunch":"Collect during lunch or afternoon break.",
    "snacks":"Collect during lunch or any break.",
    "others":"Collect during breakfast, lunch or any break."
  };
  
  static Future<List> getProducts() async{
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