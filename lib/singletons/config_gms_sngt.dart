import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';

import 'package:zonamotora/data_shared.dart';

import 'package:zonamotora/services/bg_message_handler.dart' as messageHandle;

class ConfigGMSSngt {

  static ConfigGMSSngt _sngtConfigGMSG = ConfigGMSSngt._();
  ConfigGMSSngt._();
  factory ConfigGMSSngt() {
    if(_sngtConfigGMSG == null) {
      return ConfigGMSSngt._();
    }
    return _sngtConfigGMSG;
  }

  dispose() {
    _sngtConfigGMSG = null;
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  BuildContext _context;

  void setContext(BuildContext context) {
    this._context = context;
    context = null;
    this._firebaseMessaging.requestNotificationPermissions();
    assert(this._context != null);
  }

  /* */
  Future<void> initConfigGMS() async {

    this._firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        FlutterRingtonePlayer.playNotification();
      },
      onBackgroundMessage: messageHandle.myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    assert((){
      print('::Configuracion de Google Notificaciones::');
      return true;
    }());
    _configNotiffLocales();
    Provider.of<DataShared>(this._context, listen: false).setIsCofigPush(true);
  }

  /* */
  Future<void> _configNotiffLocales() async {

    var initConfigAndroid = AndroidInitializationSettings('ico_notif');
    var initConfig = InitializationSettings(initConfigAndroid, null);
    await this._flutterLocalNotificationsPlugin.initialize(
      initConfig,
      onSelectNotification: onSelectNotification
    );


    assert((){
      print('::Configuracion de Local Notification::');
      return true;
    }());
  }

  /* */
  Future onSelectNotification(String payload) async {

    FlutterRingtonePlayer.playNotification();
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    print('::Buena Configuracion::');
  }

  /* */
  Future<String> getTokenDevice() async {
    return await this._firebaseMessaging.getToken();
  }
}