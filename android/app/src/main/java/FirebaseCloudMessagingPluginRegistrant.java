package com.buscomex.zonamotora;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;

public final class FirebaseCloudMessagingPluginRegistrant {

  public static void registerWith(final PluginRegistry registry) {

    if (alreadyRegisteredWith(registry)) {
      return;
    }
    FirebaseMessagingPlugin
        .registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
    FlutterLocalNotificationsPlugin
        .registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
  }

  private static boolean alreadyRegisteredWith(final PluginRegistry registry) {

    final String key = FirebaseCloudMessagingPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}