import 'dart:convert';

import 'package:RMart/Context/ApiContext.dart';
import 'package:http/http.dart' as http ;

class RegistrationApi{

  static var client = http.Client();
   static Future<Map> signUp(data) async{
    var body = json.encode(data);
      var uriResponse = await client.post(ApiContext.registretionUrl+"/signup",
          headers: {
            "Content-Type": "application/json",
            
          },
          body:body
      );
      Map result = json.decode(uriResponse.body);
      print(result);
      return result;
   }

   static Future<Map> getOtp(data) async{
    print(data);
    var body = json.encode(data);
      var uriResponse = await client.post(ApiContext.registretionUrl+"/getOtp",
          headers: {
            "Content-Type": "application/json",
          },
          body:body
      );
      Map result = json.decode(uriResponse.body);
      print(result);
      return result;
   }

   static Future<Map> login(data) async{
    print(data);
    var body = json.encode(data);
      var uriResponse = await client.post(ApiContext.registretionUrl+"/login",
          headers: {
            "Content-Type": "application/json",
          },
          body:body
      );
      Map result = json.decode(uriResponse.body);
      print(result);
      return result;
   }


}