import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import 'package:zonamotora/bds/data_base.dart';
import 'package:zonamotora/https/solicitud_http.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/https/errores_server.dart';
import 'package:zonamotora/singletons/cotizacion_sngt.dart';


class SolicitudRepository {

  CotizacionSngt sngtCot = CotizacionSngt();
  UserRepository emUser = UserRepository();
  SolicitudHttp solicitudHttp = SolicitudHttp();
  ErroresServer erroresServer = ErroresServer();
  Map<String, dynamic> result = {'abort': false, 'msg': 'ok', 'body': ''};

  SolicitudRepository() {
    Intl.defaultLocale = 'es_MX';
  }

  ///
  Future<bool> enviarDataSolicitud(Map<String, dynamic> data) async {
    bool res = true;
    final result = await solicitudHttp.enviarDataSolicitud(data);

    if (result.statusCode == 200) {
      this.result = json.decode(result.body);
    } else {
      this.result = erroresServer.determinarError(result);
      res = false;
    }
    return res;
  }

  ///
  Future<bool> enviarFotosSolicitud(Map<String, dynamic> data) async {
    bool res = true;
    final result = await solicitudHttp.enviarFotosSolicitud(data);
    if (result.statusCode == 200) {
      this.result = json.decode(result.body);
    } else {
      this.result = erroresServer.determinarError(result);
      res = false;
    }

    return res;
  }

  ///
  Future<bool> setNewCotizacion(Map<String, dynamic> data) async {
    int res = 0;
    DateFormat format = DateFormat('d-MM-yyyy hh:m a');

    Database db = await DBApp.db.abrir;
    if (db.isOpen) {
      List<dynamic> has = await db.query('cotizaciones',
          where: 'filename == ?', whereArgs: [data['filename']]);
      if (has.isEmpty) {
        DateTime fecha = DateTime.parse(data['createdAt']['date']);
        data['createdAt'] = format.format(fecha);
        res = await db.insert('cotizaciones', data);
      }
    }

    return (res == 0) ? false : true;
  }

  /// Obtenemos los nombre de los archivos de las cotizaciones que
  /// se encuentran en la BD del dispositivo
  Future<List<Map<String, dynamic>>> getCotizacionesFromDb() async {

    List<Map<String, dynamic>> cots = new List();
    Database db = await DBApp.db.abrir;
    if (db.isOpen) {
      List<dynamic> hasCots = await db.query('cotizaciones');
      if (hasCots.isNotEmpty) {
        cots = new List<Map<String, dynamic>>.from(hasCots);
        hasCots = null;
      }
    }
    return cots;
  }

  /// Eliminamos las solicitudes atendidas.
  Future<void> deleteSolicitudesAtendidasinDbLocal(List solicitudesAtendidas) async {
    
    Database db = await DBApp.db.abrir;
    if (db.isOpen) {
      for (var i = 0; i < solicitudesAtendidas.length; i++) {
        await db.delete('cotizaciones', where: 'filename = ?', whereArgs: [solicitudesAtendidas[i]]);
      }
    }

  }

  /// Obtenemos las cotizaciones que se encuentran en archivos todavia desde el Servidor
  Future<Map<String, dynamic>> getCotizacionesToFilesFromServer(List<String> filesname) async {

    Map<String, dynamic> solcitudesFind = {'atendidas':[], 'pendientes':[]};
    Map<String, dynamic> reServer;
    Map<String, dynamic> dataUser = await emUser.getCredentials();

    final result = await solicitudHttp.getCotizacionesToFilesFromServer(filesname, dataUser);

    if (result.statusCode == 200) {
      reServer = json.decode(result.body);
      if(!reServer['abort']){
        List<Map<String, dynamic>> solicitudes = new List<Map<String, dynamic>>.from(reServer['body']);
        if(solicitudes.isNotEmpty) {
          for (var i = 0; i < filesname.length; i++) {

            Map<String, dynamic> existe = solicitudes.firstWhere((element) => ('${element['file']}.json' == filesname[i]), orElse: () =>  new Map());
            if(existe.isEmpty){
              solcitudesFind['atendidas'].add(filesname[i]);
            }else{
              solcitudesFind['pendientes'].add(existe);
            }
          }
        }
      }else{
        this.result = reServer;
      }
    } else {
      this.result = erroresServer.determinarError(result);
    }
    reServer = null;
    return solcitudesFind;
  }

  ///
  Future<Map<String, dynamic>> getPedidoParaCotizar() async {

    Map<String, dynamic> resultado =  {'acotizar': [], 'cantidades':{}, 'memory': false};

    // Protegemos a base del singleton de cotizar para que no este gastando datos en e background
    if(sngtCot.hasDataPedidos){
      resultado['memory'] = true;
      return resultado;
    }

    Map<String, dynamic> dataUser = await emUser.getCredentials();
    final result = await solicitudHttp.getPedidoParaCotizar(dataUser);

    if (result.statusCode == 200) {
      resultado =  new Map<String, dynamic>.from(json.decode(result.body));
    } else {
      this.result = erroresServer.determinarError(result);
      if (this.result['msg'].contains('EXPIRADO')) {
        Map<String, dynamic> newToken = await emUser.getTokenFromServer(dataUser: dataUser);
        if (newToken.containsKey('token')) {
          await emUser.setTokenServerInBD(newToken['token']);
          resultado['repeate'] = true;
        }
      }
    }
    dataUser = null;
    return resultado;
  }

  ///
  Future<Map<String, dynamic>> getDataPiezaFromServer(Map<String, dynamic> dataSolicitud) async {

    Map<String, dynamic> data = new Map();
    Map<String, dynamic> dataUser = await emUser.getCredentials();
    final result = await solicitudHttp.getDataPiezaFromServer(dataUser, dataSolicitud);
    dataUser = null;
    // Protegemos a base del singleton de cotizar para que no este gastando datos en e background
    if(sngtCot.hasDataPieza){ return data; }

    if (result.statusCode == 200) {
      data = new Map<String, dynamic>.from(json.decode(result.body));
    } else {
      this.result = erroresServer.determinarError(result);
    }

    return data;
  }

  ///
  Future<bool> setCotizacion(Map<String, dynamic> cotiza) async {

    Map<String, dynamic> dataUser = await emUser.getCredentials();
    cotiza['isOtra'] = sngtCot.isOtra;
    cotiza['u_id'] = dataUser['u_id'];
    final resServer = await solicitudHttp.setCotizacion(dataUser['u_tokenServer'], cotiza);
    dataUser = null;
    if(resServer.statusCode == 200){
      this.result = json.decode(resServer.body);
      return true;
    }else{
      this.result = erroresServer.determinarError(resServer);
      return false;
    }
  }

  ///
  Future<Map<String, double>> getProporcionesPara(int maxTamNew, int originalX, int originalY, {isLandscape = false}) async {

    Map<String, double> tams = {'ancho':0, 'alto': 0};
    bool originalTam = false;
    double radio;

    if(isLandscape){
      if(originalX > maxTamNew) {
        radio = maxTamNew / originalX;
      }else{
        originalTam = true;
      }
    }else{
      if(originalY > maxTamNew) {
        radio = maxTamNew / originalY;
      }else{
        originalTam = true;
      }
    }
    if(originalTam){
      tams['ancho'] = originalX.toDouble();
      tams['alto'] = originalY.toDouble();
    }else{
      tams['ancho'] = originalX * radio;
      tams['alto'] = originalY * radio;
    }

    return tams;
  }

  ///
  Future<bool> sendFotoDeCotizacion(List<Map<String, dynamic>> fotosCotiza, int idInv) async {

    Map<String, dynamic> dataUser = await emUser.getCredentials();
    final resServer = await solicitudHttp.enviarFotosCotizacion(dataUser['u_tokenServer'], idInv, fotosCotiza);
    dataUser = null;

    if(resServer.statusCode == 200){
      this.result = json.decode(resServer.body);
      if(this.result['abort']){
        return false;
      }
      return true;
    }else{
      this.result = erroresServer.determinarError(resServer);
      return false;
    }
  }

  ///
  Future<void> getDataPasarelas() async {

    if(sngtCot.dataPasarelas.containsKey('conekta')) return false;

    final reServer = await solicitudHttp.getDataPasarelas();
    if(reServer.statusCode == 200){
      sngtCot.dataPasarelas = new Map<String, dynamic>.from(json.decode(reServer.body));
    }else{
      sngtCot.dataPasarelas = new Map();
    }
    
  }

  ///
  Future<bool> getSolicitudesByidUser()  async {

    bool respuesta = false;
    Map<String, dynamic> user = await emUser.getCredentials();
    final reServer = await solicitudHttp.getSolicitudesByidUser({'u_id':user['u_id'], 'u_tokenServer':user['u_tokenServer']});
    user = null;
    if(reServer.statusCode == 200) {
      this.result['abort'] = false;
      this.result['msg'] = 'ok';
      this.result['body'] = json.decode(reServer.body);
      respuesta = true;
    }else{
      this.result = erroresServer.determinarError(reServer);
    }
    return respuesta;
  }

  ///
  Future<bool> getPiezasDeLaSolicitud(List<int> idsSolicitudes)  async {

    bool respuesta = false;
    Map<String, dynamic> user = await emUser.getCredentials();
    final reServer = await solicitudHttp.getPiezasDeLaSolicitud(idsSolicitudes, user['u_tokenServer']);
    user = null;
    if(reServer.statusCode == 200) {
      this.result['abort'] = false;
      this.result['msg'] = 'ok';
      this.result['body'] = json.decode(reServer.body);
      respuesta = true;
    }else{
      this.result = erroresServer.determinarError(reServer);
    }
    return respuesta;
  }

  ///
  Future<bool> getRespuestas(int refApps) async {

    bool respuesta = false;
    Map<String, dynamic> user = await emUser.getCredentials();
    final reServer = await solicitudHttp.getRespuestas(refApps, user['u_tokenServer']);
    user = null;
    if(reServer.statusCode == 200) {
      this.result['abort'] = false;
      this.result['msg'] = 'ok';
      this.result['body'] = json.decode(reServer.body);
      respuesta = true;
    }else{
      this.result = erroresServer.determinarError(reServer);
    }
    return respuesta;
  }

  ///
  Future<bool> getPiezasBySocioAndStatus(String status) async {

    bool respuesta = false;
    Map<String, dynamic> user = await emUser.getCredentials();
    final reServer = await solicitudHttp.getPiezasBySocioAndStatus({'u_id':user['u_id'], 'u_tokenServer':user['u_tokenServer']}, status);
    user = null;
    if(reServer.statusCode == 200) {
      this.result['body'] = json.decode(reServer.body);
      respuesta = true;
    }else{
      this.result = erroresServer.determinarError(reServer);
    }
    return respuesta;
  }
}
