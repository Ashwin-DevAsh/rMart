import 'dart:convert';

import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Context/UserContext.dart';
import 'package:RMart/RemoteConfig/FirebaseRemoteConfig.dart';
import 'package:http/http.dart' as http ;

class RegistrationApi{

  static var client = http.Client();
   static Future<Map> signUp(data) async{
    var body = json.encode(data);
      var uriResponse = await client.post(ApiContext.profileURL+"/signup",
        headers: {
            "key": await FirebaseRempteConfig.getServerKey(),
            "Content-Type": "application/json",
        },
          body:body
      );
      Map result = json.decode(uriResponse.body);
      print(result);
      return result;
   }

   static Future<Map> checkKeys() async{
      var uriResponse = await client.post(ApiContext.profileURL+"/checkKeys",
          headers: {
            "token": UserContext.user!=null? UserContext.user.token:"",
            "key": await FirebaseRempteConfig.getServerKey(),
            "Content-Type": "application/json",
          },
      );
      Map result = json.decode(uriResponse.body);
      print(result);
      return result;
   }

   static Future<Map> getOtp(data) async{
    print(data);
    var body = json.encode(data);
      var uriResponse = await client.post(ApiContext.profileURL+"/getOtp",
         headers: {
            "key": await FirebaseRempteConfig.getServerKey(),
            "Content-Type": "application/json",
          },
          body:body
      );
      Map result = json.decode(uriResponse.body);
      print(result);
      return result;
   }


   static Future<Map> getRecoveryOtp(data) async{
    print(data);
    var body = json.encode(data);
      var uriResponse = await client.post(ApiContext.profileURL+"/getRecoveryOtp",
          headers: {
            "key": await FirebaseRempteConfig.getServerKey(),
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
      var uriResponse = await client.post(ApiContext.profileURL+"/login",
          headers: {
            "key": await FirebaseRempteConfig.getServerKey(),
            "Content-Type": "application/json",
          },
          body:body
      );
      Map result = json.decode(uriResponse.body);
      print(result);
      return result;
   }

   static Future<Map> canLogin(data) async{
    print(data);
    var body = json.encode(data);
      var uriResponse = await client.post(ApiContext.profileURL+"/canLogin",
        headers: {
            "key": await FirebaseRempteConfig.getServerKey(),
            "Content-Type": "application/json",
          },
          body:body
      );
      Map result = json.decode(uriResponse.body);
      print(result);
      return result;
   }


}