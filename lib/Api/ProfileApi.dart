import 'package:RMart/Context/ApiContext.dart';
import 'package:RMart/Context/UserContext.dart';
import 'package:RMart/RemoteConfig/FirebaseRemoteConfig.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileApi {
  static var client = http.Client();
  static getBalance(data) async {
    var body = json.encode(data);
    var uriResponse = await client.post(ApiContext.profileURL + "/getBalance",
        headers: {
          "token": UserContext.user.token,
          "key": await FirebaseRempteConfig.getServerKey(),
          "Content-Type": "application/json",
        },
        body: body);
    Map result = json.decode(uriResponse.body);
    print("balance result = ${data} ${result}");
    return result["balance"];
  }
}
