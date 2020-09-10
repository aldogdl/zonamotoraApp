import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';

import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/notifics_repository.dart';
import 'package:zonamotora/services/bg_message_handler.dart' as messageHandle;

class ConfigGMSSngt {


  NotificsRepository emNotif = NotificsRepository();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  BuildContext _context;

  static ConfigGMSSngt _sngtConfigGMSG = ConfigGMSSngt._();
  ConfigGMSSngt._();
  factory ConfigGMSSngt() {
    if(_sngtConfigGMSG == null) {
      return ConfigGMSSngt._();
    }
    return _sngtConfigGMSG;
  }

  ///
  void dispose() {
    _sngtConfigGMSG = null;
  }

  ///
  void setContext(BuildContext context) {
    this._context = context;
    context = null;
    this._firebaseMessaging.requestNotificationPermissions();

    assert(this._context != null);
  }

  ///
  Future<void> initConfigGMS() async {

    this._firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // Cuando el dispositivo esta en Primer plano
        if(message['data']['tema'] == 'prueba'){
          await _procesarPushDePrueba(message);
        }else{
          await _procesarMensajesPush(new Map<String, dynamic>.from(message['data']), 'onMessage');
        }
      },
      onBackgroundMessage: messageHandle.myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {

        //Por Hacer
        
      },
      onResume: (Map<String, dynamic> message) async {

        // Cuando el dispositivo esta en Background y vuelve al frente
        if(message['data']['tema'] == 'prueba'){
          _procesarPushDePrueba(message);
        }else{
          Map<String, dynamic> messageData = {
            'tema'   : message['data']['tema'],
            'page'   : message['data']['page'],
            'titulo' : message['data']['titulo'],
            'createdAt': message['data']['createdAt'],
          };
          await _procesarMensajesPush(messageData, 'onResume');
        }

      },
    );

    assert((){
      print('::Configuracion de Google Notificaciones::');
      return true;
    }());
    
    _configNotiffLocales();
    Provider.of<DataShared>(this._context, listen: false).setIsCofigPush(true);
  }

  ///
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

  ///
  Future onSelectNotification(String payload) async {

    FlutterRingtonePlayer.playNotification();
    if (payload != null) {
      print('notification payload: ' + payload);
    }
    print('::Buena Configuracion::');
  }

  ///
  Future<void> _procesarMensajesPush(Map<String, dynamic> message, String from) async {

    assert((){
      print('sobre el::$from');
      return true;
    }());

    int cantAct = Provider.of<DataShared>(this._context, listen: false).cantNotif;
    Provider.of<DataShared>(this._context, listen: false).setNotifics(new Map<String, dynamic>.from(message));
    showNotificacionesIcon(cantAct+1);
  }

  ///
  Future<void> _procesarPushDePrueba(Map<String, dynamic> message) async {

    FlutterRingtonePlayer.playNotification();
    DataShared dataShared = Provider.of<DataShared>(this._context, listen: false);
    dataShared.setPrbaPush({'body':message['notification']['body']});
  }

  ///
  Future<String> getTokenDevice() async {
    return await this._firebaseMessaging.getToken();
  }

  ///
  void showNotificacionesIcon(int cantAct) {
    
    FlutterRingtonePlayer.playNotification();
    DataShared provedor = Provider.of<DataShared>(this._context, listen: false);
    provedor.setCantNotif(cantAct);
    provedor.setShowNotif(true);
    provedor = null;
  }

}