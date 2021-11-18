import 'dart:convert';

import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Models/UserModel.dart';
import 'package:RMart/RemoteConfig/FirebaseRemoteConfig.dart';
import 'package:http/http.dart' as http;

class TransactionApi {
  static var client = http.Client();
  static Future<Map> createAddMoneyOrder(data) async {
    var body = json.encode(data);
    var uriResponse =
        await client.post(ApiContext.martURL + "/createAddMoneyOrder",
            headers: {
              "token": UserModel.user.token,
              "key": await FirebaseRempteConfig.getServerKey(),
              "Content-Type": "application/json",
            },
            body: body);
    Map result = json.decode(uriResponse.body);
    print(result);
    return result;
  }

  static Future<Map> addMoney(data) async {
    var body = json.encode(data);
    var uriResponse = await client.post(ApiContext.martURL + "/addMoney",
        headers: {
          "token": UserModel.user.token,
          "key": await FirebaseRempteConfig.getServerKey(),
          "Content-Type": "application/json",
        },
        body: body);
    Map result = json.decode(uriResponse.body);
    print(result);
    return result;
  }
}
