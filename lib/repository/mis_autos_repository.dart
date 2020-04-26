import 'package:intl/intl.dart';
import 'package:zonamotora/bds/data_base.dart';
import 'package:zonamotora/https/mis_autos_http.dart';
import 'package:zonamotora/repository/autos_repository.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/myAutos_sngt.dart';

class MisAutosRepository {

  MyAutosSngt myAutosSngt = MyAutosSngt();
  UserRepository emUser = UserRepository();
  MisAutosHttp misAutosHttp = MisAutosHttp();
  AutosRepository emAutos = AutosRepository();

  MisAutosRepository() {
    Intl.defaultLocale = 'es_MX';
  }

  /*
   * @see SeleccionarAnioWidgetPage::_sendFrm
  */
  Future<Map<String, dynamic>> setNewMisAuto() async {

    String fecha;
    DateFormat f = DateFormat('yyyy-MM-d');
    Map<String, dynamic> credentials = await emUser.getCredentials();
    Map<String, dynamic> auto = new Map.from(await emAutos.getAutoByIdModelo(myAutosSngt.modSelecc));

    if(myAutosSngt.createdAt == null){
      DateTime hoy = DateTime.now();
      fecha = f.format(hoy);
    }else{
      fecha = f.format(myAutosSngt.createdAt);
    }
    auto['createdAt'] = fecha;
    auto['anio'] = myAutosSngt.anio;
    auto['user'] = credentials['u_id'];

    Map<String, dynamic> result = await misAutosHttp.setNewMisAuto(auto, credentials['u_tokenServer']);
    if(!result['abort']){
      auto['idReg'] = result['body'];
      final db = await DBApp.db.abrir;
      if(db.isOpen) {
        await db.insert('misAutos', fromAltaToJson(auto));
      }
    }
    return result;
  }

  /*
   * @see RecoveryCuentaPage::_getAutosRegFromServer
  */
  Future<void> setListAutos(List<Map<String, dynamic>> autos) async {

    DateFormat f = DateFormat('yyyy-MM-d');
    String fecha;
    final db = await DBApp.db.abrir;
    if(db.isOpen) {

      // eliminamos todo en caso de encotrar datos.
      List<dynamic> has = await db.query('misAutos');
      if(has.isNotEmpty) {
        await db.delete('misAutos');
      }

      autos.forEach((auto) async {
        DateTime fechaObj = DateTime.parse(auto['a_createdAt']['date']);
        fecha = f.format(fechaObj);
        auto['a_createdAt'] = fecha;

        await db.insert('misAutos', fromServerToJson(auto));
      });
    }
    return;
  }

  /*
   * @see MisAutosPage::_sendFrm
  */
  Future<List<Map<String, dynamic>>> getMisAutos() async {

    List<Map<String, dynamic>> autos = new List();
    final db = await DBApp.db.abrir;
    if(db.isOpen) {
      autos = await db.query('misAutos');
    }
    return new List<Map<String, dynamic>>.from(autos);
  }

  /*
   * @see RecoveryCuentaPage::_getAutosRegFromServer
  */
  Future<List<Map<String, dynamic>>> getMisAutosFromServer() async {

    Map<String, dynamic> credentials = await emUser.getCredentials();
    List<Map<String, dynamic>> autos = await misAutosHttp.getMisAutosFromServer(credentials);
    if(autos.length > 0){
      if(autos.first.containsKey('error')){
        return [misAutosHttp.result];
      }
    }
    return autos;
  }

  /*
   * @see RecoveryCuentaPage::_getAutosRegFromServer
  */
  Future<void> borrarAutosDeEsteDispositivo() async {

    return await setListAutos(new List());
  }

  /*
   * @see MisAutosPage::_eliminarAuto
  */
  Future<Map<String, dynamic>> deleteAutoParticularInServer(int idAuto) async {

    Map<String, dynamic> credentials = await emUser.getCredentials();
    Map<String, dynamic> result = await misAutosHttp.deleteAutoParticular(idAuto, credentials['u_tokenServer']);
    if(!result['abort']) {
      await deleteAutoParticularInBD(idAuto);
    }
    return result;
  }

  /*
   * @see this::deleteAutoParticular
  */
  Future<bool> deleteAutoParticularInBD(int idAuto) async {

    int hecho;
    final db = await DBApp.db.abrir;
    if(db.isOpen) {
      hecho = await db.delete('misAutos', where: 'idReg = ?', whereArgs: [idAuto]);
    }
    return (hecho > 0) ? true : false;
  }

  /* */
  Map<String, dynamic> fromAltaToJson(Map<String, dynamic> auto) {

    return {
      'idReg'    : auto['idReg'],
      'mdid'     : auto['md_id'],
      'mkid'     : auto['mk_id'],
      'mdNombre' : auto['md_nombre'],
      'mkNombre' : auto['mk_nombre'],
      'anio'     : auto['anio'],
      'createdAt': auto['createdAt'],
    };
  }

  /* Para convertir los datos recuperados del servidor a un json necesario para ls BD interna */
  Map<String, dynamic> fromServerToJson(Map<String, dynamic> auto) {

    return {
      'idReg'    : auto['a_id'],
      'mdid'     : auto['md_id'],
      'mkid'     : auto['mk_id'],
      'mdNombre' : auto['md_nombre'],
      'mkNombre' : auto['mk_nombre'],
      'anio'     : auto['a_anio'],
      'createdAt': auto['a_createdAt'],
    };
  }

}