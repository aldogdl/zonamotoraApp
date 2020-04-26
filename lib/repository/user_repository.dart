
import 'package:zonamotora/bds/data_base.dart';
import 'package:zonamotora/entity/usuario_entity.dart';
import 'package:zonamotora/https/usuarios_http.dart';

class UserRepository {

  UsuariosHttp userHttp = UsuariosHttp();
  UsuarioEntity userEntity = UsuarioEntity();

  /* */
  Future<Map<String, dynamic>> getDataUser() async {

    Map<String, dynamic> user = new Map();

    final db = await DBApp.db.abrir;
    if(db.isOpen) {
      List<Map<String, dynamic>> data = await db.query('user');
      if(data.isNotEmpty) {
        user = data.first;
      }
    }
    return user;
  }

  /*
   * Obtenemos los datos para mostrarlos en la pagina de configuraciones
   * @see ConfigPage::_setSesion
  */
  Future<Map<String, dynamic>> getDataConfig() async {

    Map<String, dynamic> data = {
      'u_id'           : 0,
      'u_usname'       : 'Anónimo',
      'u_roles'        : 'GENERICA',
      'u_nombre'       : 'Anónimo',
      'u_tokenServer'  : '0',
      'u_tokenDevices' : '0'
    };

    final db = await DBApp.db.abrir;
    if(db.isOpen) {
      List<Map<String, dynamic>> user = await db.query('user');
      if(user.isNotEmpty) {
        data['u_id']           = user.first['u_id'];
        data['u_usname']       = user.first['u_usname'];
        data['u_roles']        = user.first['u_roles'];
        data['u_nombre']       = user.first['u_nombre'];

        int longTokens = 12;
        String tokenPrefix;
        String tokenSubfix;
        String token = user.first['u_tokenServer'];
        if(token.length > longTokens){
          tokenPrefix = token.substring(0, longTokens);
          tokenSubfix = token.substring(token.length - longTokens, token.length);
          data['u_tokenServer'] = '$tokenPrefix...$tokenSubfix';
        }
        token = user.first['u_tokenDevices'];
        if(token.length > longTokens){
          tokenPrefix = token.substring(0, longTokens);
          tokenSubfix = token.substring(token.length - longTokens, token.length);
          data['u_tokenDevices'] = '$tokenPrefix...$tokenSubfix';
        }
      }
    }

    return data;
  }

  /* */
  Future<Map<String, dynamic>> getCredentials() async {

    Map<String, dynamic> user = new Map();

    final db = await DBApp.db.abrir;
    if(db.isOpen) {
      List<Map<String, dynamic>> data = await db.query('user');
      if(data.isNotEmpty) {
        user['u_id']          = data.first['u_id'];
        user['u_usname']      = data.first['u_usname'];
        user['u_uspass']      = data.first['u_uspass'];
        user['u_tokenServer'] = data.first['u_tokenServer'];
      }
    }
    return user;
  }

  /* */
  Future<Map<String, dynamic>> registrarNewUser(Map<String, dynamic> usuario, String role) async {

    Map<String, dynamic> usuarioSaved = await userHttp.registrarNewUser(usuario);

    if(usuarioSaved.containsKey('error')){
      usuarioSaved = userHttp.result;
    }else{
      if(!usuarioSaved['abort']) {
        usuarioSaved = userEntity.fromJsontoDb(usuarioSaved['body']);

        // Si es el asesor quien esta dando de alta, los datos no se persistem.
        if(role == 'asesor') { return usuarioSaved; }

        final db = await DBApp.db.abrir;
        if(db.isOpen) {
          List<Map<String, dynamic>> data = await db.query('user');
          if(data.isNotEmpty) {
            await db.delete('user');
          }
          await db.insert('user', usuarioSaved);
        }

      }else{
        assert((){
          print('::ERROR DEL SERVIDOR::');
          print(usuarioSaved['dev']);
          return true;
        }());
      }
    }
    return usuarioSaved;
  }

  /*
   * Recupeeramos los ultimos socios registrados.
   * Se rquiere de acceso administrativo [TOKEN].
   */
  Future<List<Map<String, dynamic>>> getUltimosUserRegistrados(String tokenAut) async {

    List<Map<String, dynamic>> socios = await userHttp.getUltimosUserRegistrados(tokenAut);
    if(socios.length > 0){
      if(socios.first.containsKey('error')){
        socios = [userHttp.result];
      }
    }
    return socios;
  }

  /* */
  Future<void> setTokenServerInBD(String token) async {

    final db = await DBApp.db.abrir;
    if(db.isOpen) {
      await db.update('user', {'u_tokenServer' : token});
    }
  }

  /*
   * @see RecoveryCuentaPage::_getTokens
   * @see InitConfigPage::_checkDataUser
  */
  Future<Map<String, dynamic>> getTokenFromServer({Map<String, dynamic> dataUser}) async {
    if(dataUser == null) {
      dataUser = await getCredentials();
    }
    String token = await userHttp.getToken(dataUser);
    if(token == 'error'){
      return userHttp.result;
    }
    return {'token' : token};
  }

  /* */
  Future<Map<String, dynamic>> getDataUserFromServer(UsuarioEntity userEntiy) async {
    
    Map<String, dynamic> res = await userHttp.getDataUserFromServer(userEntiy.getJsonForRecoveryData());
    if(res.containsKey('error')){
      return userHttp.result;
    }
    return res['body'];
  }

  /*
   * Actualizamos los datos del usuario traidos desde el servidor dentro de la BD del dispositivo
   * @see RecoveryCuentaPage::_setCredentialsInDb
  */
  Future<int> updateDataUserInBd(Map<String, dynamic> newData) async {

    int saved = 0;
    final db = await DBApp.db.abrir;
    if(db.isOpen){
      List<dynamic> has = await db.query('user');
      if(has.isNotEmpty) {
        await db.delete('user');
      }
      saved = await db.insert('user', newData);
    }
    return saved;
  }

  /* */
  Future<void> updateTokenDevice(String tokenDeviceNuevo) async {

    print('::Actualizar token device :: Sin realizar');
  }

}