import 'dart:convert';

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
}