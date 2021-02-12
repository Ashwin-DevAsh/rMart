import 'dart:convert';

import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Context/UserContext.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http ;

class ProductsApi{

  static var categories = ['breakfast','lunch','snacks'];
  static var categoryTime = {
    "breakfast":"Collect from 7:30 AM to 9:50 AM",
    "lunch":"Collect from 1:30 AM to 2:05 PM",
    "snacks":"Collect from 9:30 AM - 2:05 PM"
  };
  
  static Future<List> getProducts() async{
    var client = http.Client();
     var uriResponse = await client.get(ApiContext.martURL+"/getAllProducts");
     Map result = json.decode(uriResponse.body);
     if(result["message"]!="success"){
       return [];
     }
     List allProduscts = result["allProducts"];
     print("All Produscts = "+result.toString());
     return allProduscts;
  }

  static Future<List> getMerchants() async{
     var client = http.Client();
     var uriResponse = await client.get(ApiContext.profileURL+"/getMerchants");
     var result = json.decode(uriResponse.body);  
     print(result);
     return result;
  }

  static getMyOrders() async{
     var client = http.Client();
     var uriResponse = await client.get(ApiContext.martURL+"/getMyOrders/rMart@"+UserContext.user.number);
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