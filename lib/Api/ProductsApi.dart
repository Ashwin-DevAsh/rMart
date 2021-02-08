import 'dart:convert';

import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Context/ProductsContext.dart';
import 'package:RMart/Context/UserContext.dart';
import 'package:RMart/Pages/ProductDetails.dart';
import 'package:http/http.dart' as http ;

class ProductsApi{
  static Future<List> getProducts() async{
    var client = http.Client();
     var uriResponse = await client.get(ApiContext.url+"/getAllProducts");
     Map result = json.decode(uriResponse.body);
     if(result["message"]!="success"){
       return [];
     }
     List allProduscts = result["allProducts"];
     print(result);
     return allProduscts;
  }

  static Future<List> getMerchants() async{
     var client = http.Client();
     var uriResponse = await client.get(ApiContext.profileUrl+"/getMerchants");
     var result = json.decode(uriResponse.body);  
     print(result);
     return result;
  }

  static getMyOrders() async{
     var client = http.Client();
     var uriResponse = await client.get(ApiContext.url+"/getMyOrders/"+UserContext.user.rpayId);
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
      ProductContext.merchantIDMap[ element["id"]]=element;
      ProductContext.merchants.add(element["id"]);
      data[element["id"]]={};
    });

    print("data"+data.toString());


    products.forEach((element) {
      try{
        print("Owenr id"+ element["ownerid"].toString());
        data[element["ownerid"]][element["category"]].add(element);
      }catch(e){
        try{
           data[element["ownerid"]][element["category"]]=[element];
        }catch(e){}

      }
    });

    ProductContext.data = data;
    ProductContext.init();
    print(data);    
  }
}