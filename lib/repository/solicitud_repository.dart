import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:zonamotora/https/solicitud_http.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/https/errores_server.dart';

class SolicitudRepository {

  UserRepository emUser = UserRepository();
  SolicitudHttp solicitudHttp = SolicitudHttp();
  ErroresServer erroresServer = ErroresServer();
  Map<String, dynamic> result = {'abort':false, 'msg' : 'ok', 'body':''};

  SolicitudRepository() {
    Intl.defaultLocale = 'es_MX';
  }

  ///
  Future<bool> enviarDataSolicitud(Map<String, dynamic> data) async {

    bool res = true;
    final result = await solicitudHttp.enviarDataSolicitud(data);

    if(result.statusCode == 200){
      this.result = json.decode(result.body);
    }else{
      this.result = erroresServer.determinarError(result);
      res = false;
    }
    return res;
  }

  ///
  Future<bool> enviarFotosSolicitud(Map<String, dynamic> data) async {

    bool res = true;
    final result = await solicitudHttp.enviarFotosSolicitud(data);
    if(result.statusCode == 200){
      this.result = json.decode(result.body);
    }else{
      this.result = erroresServer.determinarError(result);
      res = false;
    }
    return res;
  }
}