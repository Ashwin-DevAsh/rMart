import 'dart:convert';

import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Models/UserModel.dart';
import 'package:RMart/RemoteConfig/FirebaseRemoteConfig.dart';
import 'package:http/http.dart' as http;

class OrderApi {
  static var client = http.Client();
  static Future<Map> makeOrderUsingRazorpay(data) async {
    var body = json.encode(data);
    var uriResponse = await client.post(ApiContext.martURL + "/makeOrder",
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

  static Future<Map> placeOrderUsingWallet(data) async {
    var body = json.encode(data);
    var uriResponse =
        await client.post(ApiContext.martURL + "/placeOrderUsingWallet",
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

  static Future<Map> verifyPayment(data) async {
    var body = json.encode(data);
    var uriResponse = await client.post(ApiContext.martURL + "/verifyPayment",
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

  static var month = {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "Jun",
    7: "Jul",
    8: "Aug",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Dec"
  };

  static var getDate = (String timestamp) {
    try {
      var date = timestamp.split(" ")[0];
      var time = timestamp.split(" ")[1];
      var formatTime = time.split(":")[0] + ":" + time.split(":")[1];
      var formatDate = date.split("-")[1] +
          " " +
          month[int.parse(date.split("-")[0])] +
          " " +
          date.split("-")[2];
      return formatDate + " " + formatTime;
    } catch (e) {
      print(e);
      return "";
    }
  };
}
