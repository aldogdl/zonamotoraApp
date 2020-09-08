import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/bds/data_base.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/https/app_varios_http.dart';
import 'package:zonamotora/https/errores_server.dart';
import 'package:zonamotora/https/usuarios_http.dart';

class NotificsRepository {

  AppVariosHttp variosHttp = AppVariosHttp();
  UsuariosHttp userHttp = UsuariosHttp();
  ErroresServer erroresServer = ErroresServer();

  BuildContext _context;
  Map<String, dynamic> result = {'abort':false, 'msg': 'ok', 'body': []};

  void setContext(BuildContext context) {
    this._context = context;
    context = null;
  }

  // Revisamos en el servidor si existen notificaciones guadadas.
  // esto se hace solo en el inicio de la APP.
  Future<bool> descargarNotificacionesBackUp() async {

    Map<String, dynamic> user = await this.dataUser();
    final notif = await userHttp.getNotificacionesInBackAup(user);
    user = null;
    if(notif.statusCode == 200) {
      this.result['body'] = new List<Map<String, dynamic>>.from(json.decode(notif.body));
      return true;
    }else{
      this.result = erroresServer.determinarError(notif);
    }
    return false;
  }

  ///
  Future<List<Map<String, dynamic>>> createObjectsFromSave(List<Map<String, dynamic>> notis) async {

    List<Map<String, dynamic>> newNotis = new List();
    if(notis.isNotEmpty){
      for (var i = 0; i < notis.length; i++) {
        newNotis.add(
          {
            'id'       : 0,
            'idServer' : notis[i]['ph_id'],
            'cant'     : notis[i]['ph_cant'],
            'tema'     : notis[i]['ph_tema'],
            'titulo'   : notis[i]['ph_titulo'],
            'page'     : notis[i]['ph_page'],
            'createdAt': json.encode(notis[i]['ph_createdAt'])
          }
        );
      }
    }
    return newNotis;
  }

  /// Respaldamos las notificaciaones que hay en dataShared hacia la BD.
  Future<List<Map<String, dynamic>>> makeBackupNotificaciones({has = false}) async {

    List<Map<String, dynamic>> notifs = Provider.of<DataShared>(this._context, listen: false).notifics;
    final db = await DBApp.db.abrir;

    if(notifs.isNotEmpty) {
      int idNoti = 1;
      bool reBuscar = false;

      if(db.isOpen){
        
        List<Map<String, dynamic>> hasnotis = new List<Map<String, dynamic>>.from(await db.query('notifics'));
        if(hasnotis.isNotEmpty){
          idNoti = hasnotis.length + 1;
        }else{
          reBuscar = true;
        }

        for (var i = 0; i < notifs.length; i++) {
          Map<String, dynamic> result = new Map();
          if(hasnotis.isNotEmpty && !reBuscar){
            result = hasnotis.firstWhere((element) => element['tema'] == notifs[i]['tema'], orElse: () => new Map());
          }else{
            if(hasnotis.isNotEmpty){
              result = hasnotis.firstWhere((element){
                return (element['tema'] == notifs[i]['tema']);
              }, orElse: () => new Map());
            }
          }
          Map<String, dynamic> notif = new Map<String, dynamic>.from(result);
          
          if(notif.isNotEmpty) {

            notif['cant'] = notif['cant'].toInt() + 1;
            notif['createdAt'] = notif['createdAt'];
            await db.update('notifics', notif, where: 'id = ?', whereArgs: [notif['id']]);

          }else{

            notif = {
              'id'       : idNoti,
              'idServer' : (notifs[i].containsKey('idServer')) ? notifs[i]['idServer'] : 0,
              'cant'     : 1,
              'tema'     : notifs[i]['tema'],
              'titulo'   : notifs[i]['titulo'],
              'page'     : notifs[i]['page'],
              'createdAt': notifs[i]['createdAt']
            };
            idNoti++;
            await db.insert('notifics', notif);
          }

          if(reBuscar){
            hasnotis.add(notif);
          }
          notif = null;
        }

        hasnotis = null;
      }

      Provider.of<DataShared>(this._context, listen: false).cleanNotifics;
    }

    if(db.isOpen){

      final lista = List<Map<String, dynamic>>.from(await db.query('notifics'));
      return (has) ? [{'has':lista.length}] : lista;
    }

    return new List();
  }

  /// Marcar las notificaciones como leidas.
  Future<bool> markComo(String campo, {int idPush = 0}) async {

    Map<String, dynamic> credentials = await dataUser();
    await userHttp.markComo(campo, idPush, credentials);
    return true;
  }

  ///
  Future<int> deleteTemaNotifById(int idNotif) async {

    int cantActu = Provider.of<DataShared>(this._context, listen: false).cantNotif;
    List<Map<String, dynamic>> newLista = new List();

    final db = await DBApp.db.abrir;
    if(db.isOpen){

      final List<dynamic> lista = await db.query('notifics');

      if(lista.length > 0){

        for (var i = 0; i < lista.length; i++) {
          if(lista[i]['id'] != idNotif){
            newLista.add(lista[i]);
          }
        }

        if(newLista.length > 0){
          Provider.of<DataShared>(this._context, listen: false).setCantNotif((cantActu -1));
          Provider.of<DataShared>(this._context, listen: false).setAllNotifics(newLista);
        }

        await db.delete('notifics');
      }
    }

    return newLista.length;
  }

  ///
  Future<void> hideIconNotif() async {

    Provider.of<DataShared>(this._context, listen: false).setCantNotif(0);
    Provider.of<DataShared>(this._context, listen: false).setShowNotif(false);
  }

  ///
  Future<Map<String, dynamic>> dataUser() async {

    Map<String, dynamic> userResult = new Map();
    final db = await DBApp.db.abrir;
    if(db.isOpen){
      List<dynamic> user = await db.query('user');
      if(user.isNotEmpty){
        userResult = new Map<String, dynamic>.from(user.first);
      }
    }
    return userResult;
  }

  ///
  Future<Map<String, dynamic>> getConstraints() async {

    Map<String, dynamic> user = await dataUser();
    final reServer = await variosHttp.getConstraints(user);
    user = null;
    if(reServer.statusCode == 200) {
      return new Map<String, dynamic>.from(json.decode(reServer.body));
    }else{
      this.result = erroresServer.determinarError(reServer);
    }
    return this.result;
  }
}