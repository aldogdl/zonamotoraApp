import 'package:intl/intl.dart';

import 'package:zonamotora/bds/data_base.dart';

class FavoritosRepository {

  String _nombreTabla = 'favs';

  ///
  Future<List<Map<String, dynamic>>> getAll() async {

    List favs = new List();
    final db = await DBApp.db.abrir;
    if(db.isOpen){
      favs = await db.query(this._nombreTabla);
    }
    return (favs.isNotEmpty) ? new List<Map<String, dynamic>>.from(favs) : new List();
  }

  ///
  Future<int> getCantFav() async {

    List favs = new List();
    final db = await DBApp.db.abrir;
    if(db.isOpen){
      favs = await db.query(this._nombreTabla);
    }
    return favs.length;
  }

  ///
  Future<bool> isInFavs(int id)  async {

    final db = await DBApp.db.abrir;
    if(db.isOpen){
      List fav = await db.query(this._nombreTabla, where: 'pbl_id = ?', whereArgs: [id]);
      return (fav.isEmpty) ? false : true;
    }
    return false;
  }

  ///
  Future<bool> deleteFav(int id)  async {

    final db = await DBApp.db.abrir;
    if(db.isOpen){
      int echo = await db.delete(this._nombreTabla, where: 'pbl_id = ?', whereArgs: [id]);
      return (echo == 0) ? false : true;
    }
    return false;
  }

  ///
  Future<bool> deleteAllFavs()  async {

    final db = await DBApp.db.abrir;
    if(db.isOpen){
      int echo = await db.delete(this._nombreTabla);
      return (echo == 0) ? false : true;
    }
    return false;
  }

  ///
  Future<bool> setInFav(Map<String, dynamic> publicacion)  async {

    final db = await DBApp.db.abrir;
    if(db.isOpen){
      publicacion = getJsonByPublicacion(publicacion);
      int cantSave = await db.insert(this._nombreTabla, publicacion);
      return (cantSave > 0) ? true : false;
    }
    return false;
  }

  ///
  Map<String, dynamic> getJsonByPublicacion(Map<String, dynamic> publicacion) {

    List<String> fotos = new List();
    if(publicacion['pbl_fotos'] != null) {
      if(publicacion['pbl_fotos'] != '0'){
        fotos = new List<String>.from(publicacion['pbl_fotos']);
      }
    }
    String descrip = publicacion['pbl_descripcion'].toString();
    if(descrip.length > 57) {
      descrip = descrip.substring(0, 57);
    }
    DateFormat dateFormat = DateFormat('d-MM-yyyy');
    DateTime hoy = DateTime.now();

    return {
      'pbl_id' : publicacion['pbl_id'],
      'u_id' : publicacion['u_id'],
      'cat_id' : publicacion['cat_id'],
      'sa_id' : publicacion['sa_id'],
      'pbl_queVendes' : publicacion['pbl_queVendes'],
      'pbl_descripcion' : descrip,
      'pbl_precio' : publicacion['pbl_precio'],
      'pbl_fotos' : (fotos.isEmpty) ? '0' : fotos[0],
      'createdAt' : dateFormat.format(hoy),
    };

  }

}