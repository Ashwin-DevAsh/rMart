import 'dart:convert';

import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Context/UserContext.dart';
import 'package:http/http.dart' as http ;
class OrderApi{
  static var client = http.Client();
   static Future<Map> makeOrder(data) async{
    var body = json.encode(data);
      var uriResponse = await client.post(ApiContext.martURL+"/makeOrder",
          headers: {
            "token":UserContext.user.token,
            "Content-Type": "application/json",
          },
          body:body
      );
      Map result = json.decode(uriResponse.body);
      print(result);
      return result;
   }

   static Future<Map> verifyPayment(data) async{
    var body = json.encode(data);
      var uriResponse = await client.post(ApiContext.martURL+"/verifyPayment",
          headers: {
            "token":UserContext.user.token,
            "Content-Type": "application/json",
          },
          body:body
      );
      Map result = json.decode(uriResponse.body);
      print(result);
      return result;
   }
}