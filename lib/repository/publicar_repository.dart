import 'dart:convert';

import 'package:zonamotora/bds/data_base.dart';
import 'package:zonamotora/https/errores_server.dart';
import 'package:zonamotora/https/publicar_http.dart';
import 'package:zonamotora/repository/user_repository.dart';

class PublicarRepository {

  UserRepository emUSer = UserRepository();
  PublicarHttp publicHttp = PublicarHttp();
  ErroresServer erroresServer = ErroresServer();

  Map<String, dynamic> result = {'abort': false, 'msg': 'ok', 'body': []};

  ///
  Future<Map<String, dynamic>> getLastPublicacion() async {

    Map<String, dynamic> lastPublicacion = new Map();
    Map<String, dynamic> dataUser = await emUSer.getCredentials();
    final reServer = await publicHttp.getLastPublicacion(dataUser);
    dataUser = null;
    if(reServer.statusCode == 200) {
      return new Map<String, dynamic>.from(json.decode(reServer.body));
    }else{
      result = erroresServer.determinarError(reServer);
    }
    return lastPublicacion;
  }

  ///
  Future<bool> subirFotoByPublicacion(List<Map<String, dynamic>> fotos) async {

    Map<String, dynamic> dataUser = await emUSer.getCredentials();
    final reServer = await publicHttp.uploadFotoPublicacion(fotos, dataUser);
    dataUser = null;
    if(reServer.statusCode == 200) {
      Map<String, dynamic> res = new Map<String, dynamic>.from(json.decode(reServer.body));
      result = res;
      return (result['abort']) ? false : true;
    }else{
      result = erroresServer.determinarError(reServer);
      return false;
    }
  }

  ///
  Future<bool> deleteFotoByPublicacion(String foto) async {

    Map<String, dynamic> dataUser = await emUSer.getCredentials();
    final reServer = await publicHttp.deleteFotoPublicacion(foto, dataUser);
    dataUser = null;
    if(reServer.statusCode == 200) {
      Map<String, dynamic> res = new Map<String, dynamic>.from(json.decode(reServer.body));
      result = res;
      return (result['abort']) ? false : true;
    }else{
      result = erroresServer.determinarError(reServer);
      return false;
    }
  }

  ///
  Future<bool> sendDataByPublicacion(Map<String, dynamic> data) async {

    Map<String, dynamic> dataUser = await emUSer.getCredentials();
    final reServer = await publicHttp.sendDataByPublicacion(data, dataUser);
    dataUser = null;
    if(reServer.statusCode == 200) {
      Map<String, dynamic> res = new Map<String, dynamic>.from(json.decode(reServer.body));
      result = res;
      return (result['abort']) ? false : true;
    }else{
      result = erroresServer.determinarError(reServer);
      return false;
    }
  }

  ///
  Future<Map<String, dynamic>> getUnidades(int typeUnidad, int pag) async {

    Map<String, dynamic> unidades = new Map();
    final reServer = await publicHttp.getUnidades(typeUnidad, pag);
    if(reServer.statusCode == 200) {
     unidades = new Map<String, dynamic>.from(json.decode(reServer.body));
    }else{
      result = erroresServer.determinarError(reServer);
    }
    return unidades;
  }

  ///
  Future<Map<String, dynamic>> getPublicacionById(int typeUnidad, int idPublic) async {

    Map<String, dynamic> publicacion = new Map();
    final reServer = await publicHttp.getPublicacionById(typeUnidad, idPublic);
    if(reServer.statusCode == 200) {
     publicacion = new Map<String, dynamic>.from(json.decode(reServer.body));
    }else{
      result = erroresServer.determinarError(reServer);
    }
    return publicacion;
  }

  ///
  Future<List<Map<String, dynamic>>> getCategosLocal() async {

    final db = await DBApp.db.abrir;
    if(db.isOpen){
      List<dynamic> categos = await db.query('categos');
      if(categos.isNotEmpty){
        return new List<Map<String, dynamic>>.from(categos);
      }
    }

    return new List();
  }
}