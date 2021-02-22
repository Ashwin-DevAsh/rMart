import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FirebaseRempteConfig{
    static var server_key = null;



    static getServerKey()async{
      final storage = new FlutterSecureStorage();
      server_key = await storage.read(key: "server_key");
      print("From aes "+server_key.toString());
      if(server_key==null || server_key=="null"){
        var keys = await FirebaseFirestore.instance.collection('keys').doc("zIVwOruoZVGecJhlSdc5").get();
        server_key = keys["server_key"];
        await storage.write(key: "server_key", value: server_key);
        return server_key;
      }else{
        return server_key;
      }

     }
  
    static reloadKeys()async{
        print("reloaded");
        final storage = new FlutterSecureStorage();
        var keys = await FirebaseFirestore.instance.collection('keys').doc("zIVwOruoZVGecJhlSdc5").get();
        server_key = keys["server_key"];
        await storage.delete(key: "server_key");
        await storage.write(key: "server_key", value: server_key);
        return server_key;
     }
}