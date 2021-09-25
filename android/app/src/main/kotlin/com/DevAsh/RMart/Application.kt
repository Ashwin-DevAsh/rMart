package com.DevAsh.RMart

import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin;


class Application : FlutterApplication(), PluginRegistrantCallback {
  
  override fun onCreate() {
    super.onCreate();
    FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
  }

  override fun registerWith(registry:PluginRegistry) {
    // GeneratedPluginRegistrant.registerWith(registry as FlutterEngine);
  }
}
