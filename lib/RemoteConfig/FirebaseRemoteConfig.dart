import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRempteConfig{
   static var server_key = null;

    static getServerKey()async{
      if(server_key==null || server_key=="null"){
        final RemoteConfig remoteConfig = await RemoteConfig.instance;
        final defaults = <String, dynamic>{'server_key': "null"};
        await remoteConfig.setDefaults(defaults);
        await remoteConfig.fetch(expiration: const Duration(hours: 1));
        await remoteConfig.activateFetched();
        server_key = remoteConfig.getString('server_key');
        return server_key;
      }else{
        return server_key;
      }

     }
  
}