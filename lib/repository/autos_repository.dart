import 'dart:convert';

import 'package:zonamotora/bds/data_base.dart';
import 'package:zonamotora/https/app_varios_http.dart';
import 'package:zonamotora/https/errores_server.dart';

class AutosRepository {

  AppVariosHttp appVariosHttp = AppVariosHttp();
  Map<String, dynamic> result = {'abort':false, 'msg' : 'ok', 'body':''};
  ErroresServer erroresServer = ErroresServer();
  
  /*
  * @see InitConfigPage::_checkMarcasAndModelos
  */
  Future<bool> hasMarcasAndModelos() async {

    bool hasAutos = false;
    final db = await DBApp.db.abrir;
    if(db.isOpen) {
      final autos = await db.query('autos');
      hasAutos = (autos.isEmpty) ? false : true;
    }

    return hasAutos;
  }

  /*
  * @see InitConfigPage::_checkMarcasAndModelos
  */
  Future<void> getSetMarcasAndModelos() async {

    final reServer = await appVariosHttp.getMarcasAndModelos();
    if(reServer.statusCode == 200) {
      List<Map<String, dynamic>> autos = new List<Map<String, dynamic>>.from(json.decode(reServer.body));
      if(autos.length > 10) {
        final db = await DBApp.db.abrir;
        if(db.isOpen) {
          autos.forEach((auto) async {
            await db.insert('autos', auto);
          });
        }
      }
    }
  }

  ///
  Future<List<Map<String, dynamic>>> getMarcas() async {

    List<Map<String, dynamic>> marcas = new List();
    final db = await DBApp.db.abrir;
    if(db.isOpen) {
      marcas = await db.query('autos', columns: ['mk_id', 'mk_nombre'], groupBy: 'mk_nombre');
    }
    return marcas;
  }

  ///
  Future<List<Map<String, dynamic>>> getModelos(int idMarca) async {

    List<Map<String, dynamic>> modelos = new List();
    final db = await DBApp.db.abrir;
    if(db.isOpen) {
      modelos = await db.query('autos', columns: ['md_id', 'md_nombre'], where: 'mk_id = ?', whereArgs: [idMarca]);
    }
    return modelos;
  }

  /*
  * @see SaveAutoPage::_getAutos
  */
  Future<List<Map<String, dynamic>>> getAllAutos() async {

    List<Map<String, dynamic>> autos = new List();
    final db = await DBApp.db.abrir;
    if(db.isOpen) {
      autos = await db.query('autos', orderBy: 'mk_nombre ASC');
    }
    return autos;
  }

  /*
  * @see seleccionar_anio_widget_page::_getAutoSeleccionado
  */
  Future<Map<String, dynamic>> getAutoByIdModelo(int idModelo) async {

    List<Map<String, dynamic>> autos = new List();
    final db = await DBApp.db.abrir;
    if(db.isOpen) {
      autos = await db.query('autos', where: 'md_id = ?', whereArgs: [idModelo]);
    }
    return autos.first;
  }

  /*
  * @see alta_save_resum_page::_showMarcasModelos
  */
  Future<List<Map<String, dynamic>>> getMarcaByIds(String idMarcas) async {

    List<Map<String, dynamic>> autos = new List();
    final db = await DBApp.db.abrir;
    if(db.isOpen) {
      final marcas = await db.rawQuery('SELECT * FROM autos WHERE mk_id IN ($idMarcas) GROUP BY mk_nombre ORDER BY mk_nombre ASC');
      if(marcas.isNotEmpty){
        marcas.forEach((mk){
          autos.add({
            'mk_id' : mk['mk_id'], 'mk_nombre' : mk['mk_nombre']
          });
        });
      }
    }
    return autos;
  }

  /*
  * @see alta_save_resum_page::_showMarcasModelos
  */
  Future<List<Map<String, dynamic>>> getModelosByIds(String idModelos) async {

    List<Map<String, dynamic>> autos = new List();
    final db = await DBApp.db.abrir;
    if(db.isOpen) {
      final marcas = await db.rawQuery('SELECT * FROM autos WHERE md_id IN ($idModelos) GROUP BY md_nombre ORDER BY md_nombre ASC');
      if(marcas.isNotEmpty){
        marcas.forEach((md){
          autos.add({
            'md_id' : md['md_id'], 'md_nombre' : md['md_nombre']
          });
        });
      }
    }
    return autos;
  }
}