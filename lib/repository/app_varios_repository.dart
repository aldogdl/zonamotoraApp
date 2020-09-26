import 'dart:convert';

import 'package:zonamotora/bds/data_base.dart';
import 'package:zonamotora/https/app_varios_http.dart';
import 'package:zonamotora/https/asesores_http.dart';
import 'package:zonamotora/https/errores_server.dart';

class AppVariosRepository {

  AppVariosHttp appVariosHttp = AppVariosHttp();
  AsesoresHttp asesoresHttp = AsesoresHttp();
  ErroresServer erroresServer = ErroresServer();

  Map<String, dynamic> result = {'abort':false, 'msg':'ok', 'body':''};

  ///
  Future<List<Map<String, dynamic>>> getColonias(int idCiudad) async {

    List<Map<String, dynamic>> colonias = new List();
    final reServer = await appVariosHttp.getColonias(idCiudad);
    if(reServer.statusCode == 200) {
      colonias = new List<Map<String, dynamic>>.from(json.decode(reServer.body));
    }else{
      this.result = erroresServer.determinarError(reServer);
      return [{'error':true}];
    }
    return colonias;
  }

  /// @see AltaPerfilOtrosPage::_accionesFrmGestionColonias
  Future<Map<String, dynamic>> setColonia(Map<String, dynamic> colonia, String token) async {

    final reServer = await asesoresHttp.setColonia(colonia, token);
    if(reServer.statusCode == 200) {
      return json.decode(reServer.body);
    }else{
      this.result = erroresServer.determinarError(reServer);
    }
    return {'error':true};
  }

  /*
   * @see AltaSistemaPage::_getSistemas
  */
  Future<List<Map<String, dynamic>>> getSistemas() async {

    final reServer = await appVariosHttp.getSistemas();
    if(reServer.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(reServer.body));
    }else{
      this.result = erroresServer.determinarError(reServer);
    }
    return [{'error':true}];
  }

  /*
   * @see AltaSistemaPage::_getSistemas
  */
  Future<List<Map<String, dynamic>>> getCiudades() async {

    final reServer = await appVariosHttp.getCiudades();
    if(reServer.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(reServer.body));
    }else{
      this.result = erroresServer.determinarError(reServer);
    }
    return [{'error':true}];
  }

  /*
   * @see InitConfigPage::_checkCategos
  */
  Future<List<Map<String, dynamic>>> getAllCategosFromServer() async {

    final reServer = await appVariosHttp.getAllCategosFromServer();
    if(reServer.statusCode == 200) {

      List<Map<String, dynamic>> categos = List<Map<String, dynamic>>.from(json.decode(reServer.body));
      final db = await DBApp.db.abrir;
      if(db.isOpen){
        List hasCategos = await db.query('categos');
        if(hasCategos.isNotEmpty){
          await db.delete('categos');
        }
        categos.forEach((e) async {
          await db.insert('categos', e);
        });
        categos = null;
      }

    }else{
      this.result = erroresServer.determinarError(reServer);
    }
    return [{'error':true}];
  }

  /*
   * @see InitConfigPage::_checkCategos
  */
  Future<List<Map<String, dynamic>>> getCategosToLocal() async {

    List<Map<String, dynamic>> categos = new List();
    final db = await DBApp.db.abrir;
    if(db.isOpen){
      List cats = await db.query('categos');
      if(cats.isNotEmpty){
        categos = new List<Map<String, dynamic>>.from(cats);
      }
      cats = null;
    }
    return categos;
  }

}