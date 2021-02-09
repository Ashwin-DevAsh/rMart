import 'dart:convert';

import 'package:RMart/Context/ApiContext.dart';
import 'package:http/http.dart' as http ;

class RecoveryApi{

  static var client = http.Client();
   static Future<Map> verifyRecoveryOtp(data) async{
    var body = json.encode(data);
      var uriResponse = await client.post(ApiContext.profileURL+"/verifyRecoveryOtp",
          headers: {
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
            "Content-Type": "application/json",
          },
          body:body
      );
      Map result = json.decode(uriResponse.body);
      print(result);
      return result;
   }

   static Future<Map> changePassword(data) async{
    print(data);
    var body = json.encode(data);
      var uriResponse = await client.post(ApiContext.profileURL+"/changePassword",
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