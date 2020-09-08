import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:zonamotora/bds/data_base.dart';
import 'package:zonamotora/https/errores_server.dart';
import 'package:zonamotora/https/solicitud_http.dart';
import 'package:zonamotora/repository/user_repository.dart';

class CarShopRepository {

  SolicitudHttp solicitudHttp = SolicitudHttp();
  UserRepository emUser = UserRepository();
  ErroresServer erroresServer = ErroresServer();
  
  Map<String, dynamic> result = {'abort': false, 'msg': 'ok', 'body': ''};


  ///
  Future<int> getCantActualInCarShop() async {

    int cant = 0;
    final db = await DBApp.db.abrir;
    if(db.isOpen) {

      List hasShop = await db.query('carshop');
      if(hasShop.isNotEmpty) {
        cant = hasShop.length;
      }
    }
    return cant;
  }

  ///
  Future<void> addPzaToCarShop(int idInventario) async {

    final db = await DBApp.db.abrir;
    if(db.isOpen){
      List hasInv = await db.query('carshop', where: 'idInv = ?', whereArgs: [idInventario]);

      if(hasInv.isEmpty){
        DateFormat dateFormat = DateFormat('d-MM-yyyy');
        DateTime hoy = DateTime.now();
        Map<String, dynamic> data = {
          'idInv' : idInventario,
          'createdAt' : dateFormat.format(hoy)
        };
        await db.insert('carshop', data);
      }
    }
  }

  ///
  Future<bool> existInCarShop(int idInventario) async {

    final db = await DBApp.db.abrir;
    if(db.isOpen){

      List hasInv = await db.query('carshop', where: 'idInv = ?', whereArgs: [idInventario]);

      if(hasInv.isNotEmpty){
        return true;
      }
    }
    return false;
  }

  ///
  Future<List<int>> getIdsInCarShop() async {

    List<int> ids = new List();
    final db = await DBApp.db.abrir;
    if(db.isOpen){

      List hasInv = await db.query('carshop');
      if(hasInv.isNotEmpty){
        hasInv.forEach((element) {
          ids.add(element['idInv']);
        });
      }
    }
    return ids;
  }
  
  ///
  Future<bool> quitarPiezaDelPedido(int idDel) async {

    final db = await DBApp.db.abrir;
    if(db.isOpen){

      int hecho = await db.delete('carshop', where: 'idInv = ?', whereArgs: [idDel]);
      if(hecho > 0){
        return true;
      }
    }
    return false;
  }

  ///
  Future<bool> getInventarioByIds(List<int> ids) async {

    bool respuesta = false;
    Map<String, dynamic> user = await emUser.getCredentials();
    final reServer = await solicitudHttp.getInventarioByIds(ids, user['u_tokenServer']);
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
}