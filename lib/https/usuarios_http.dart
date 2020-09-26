import 'dart:convert';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'package:zonamotora/globals.dart' as globals;
import 'package:zonamotora/https/errores_server.dart';
import 'package:zonamotora/utils/cambiando_la_ip_dev.dart';

class UsuariosHttp {

  /// Bloque Utilizado solo en modo developer para cambios de IP repentinos
    CambiandoLaIpDev gestionDeIp = CambiandoLaIpDev();
    String _uriBase = globals.uriBase;
    Future<String> _getIpDev() async {
      String ip = await gestionDeIp.getIp();
      return this._uriBase.replaceFirst('${globals.ip}', ip);
    }
    Future<void> _printAndRefreshIp(String metodo) async {
      this._uriBase = (globals.env == 'dev') ? await _getIpDev() : globals.uriBase;
      assert((){
        print(this._uriBase);
        print('Gastando datos -> UsuariosHttp::$metodo');
        return true;
      }());
    }
  /// End Bloque
  
  ErroresServer erroresServer = ErroresServer();
  Map<String, dynamic> result = {'abort':false, 'msg' : 'ok', 'body':''};
  final String uriApiSocios = 'apis/socios';
  final String uriApiAsesor = 'apis/asesor';

  /*
   * @see UserRepository::buscarUserBy
  */
  Future<http.Response> buscarUserBy(String criterio, String tokenTmpAsesor) async {

    await this._printAndRefreshIp('buscarUserBy');
    Uri uri = Uri.parse('${this._uriBase}/${this.uriApiAsesor}/buscando-socios-by/');

    final httpSend = http.MultipartRequest('POST', uri);
    httpSend.headers['Authorization'] = 'Bearer $tokenTmpAsesor';
    httpSend.fields['criterio'] = criterio;
    return await http.Response.fromStream(await httpSend.send());
  }

  /*
   * @see UserRepository::hasSitioWebByIdPerfil
  */
  Future<http.Response> hasSitioWebByIdPerfil(int idPerfil, String tokenTmpAsesor) async {

    await this._printAndRefreshIp('hasSitioWebByIdPerfil');
    Uri uri = Uri.parse('${this._uriBase}/${this.uriApiAsesor}/has-sitio-web-by-id-perfil/');

    final httpSend = http.MultipartRequest('POST', uri);
    httpSend.headers['Authorization'] = 'Bearer $tokenTmpAsesor';
    httpSend.fields['idPerfil'] = '$idPerfil';
    return await http.Response.fromStream(await httpSend.send());
  }

  /*
   * @see UserRepository::checkSlugParaSitioWeb
  */
  Future<bool> checkSlugParaSitioWeb(String slug, int idPag, String tokentmpAsesor) async {

    await this._printAndRefreshIp('checkSlugParaSitioWeb');
    Uri uri = Uri.parse('${this._uriBase}/${this.uriApiAsesor}/$idPag/$slug/check-slug-para-sitio-web/');

    final httpSend = http.MultipartRequest('GET', uri);
    httpSend.headers['Authorization'] = 'Bearer $tokentmpAsesor';
    final response =  await http.Response.fromStream(await httpSend.send());
    if(response.statusCode == 200) {
      Map<dynamic, dynamic> res = json.decode(response.body);
      return res['has'];
    }
    return false;
  }

  /*
   * @see UserRepository::saveDataSitioWeb
  */
  Future<http.Response> saveDataSitioWeb(Map<String, dynamic> data, String tokenTmpAsesor) async {

    await this._printAndRefreshIp('saveDataSitioWeb');
    Uri uri = Uri.parse('${this._uriBase}/${this.uriApiAsesor}/save-data-sitio-web/');

    final httpSend = http.MultipartRequest('POST', uri);
    httpSend.headers['Authorization'] = 'Bearer $tokenTmpAsesor';
    httpSend.fields['data'] = json.encode(data);
    return await http.Response.fromStream(await httpSend.send());
  }

  /*
   * @see UserRepository::sendDataAndLogo
  */
  Future<http.Response> sendDataAndLogo(Map<String, dynamic> data, Map<String, dynamic> logo, String tokenTmpAsesor) async {

    await this._printAndRefreshIp('sendDataAndLogo');
    Uri uri = Uri.parse('${this._uriBase}/${this.uriApiAsesor}/save-logo-sitio-web/');

    final httpSend = http.MultipartRequest('POST', uri);
    httpSend.headers['Authorization'] = 'Bearer $tokenTmpAsesor';
    if(data['changeImg']){
      httpSend.files.add(
        http.MultipartFile.fromBytes(
          'logotipo', logo['img'], filename: '${data['slug']}-logotipo.${logo['ext']}',
          contentType: MediaType("image", logo['ext']),
        )
      );
    }
    httpSend.fields['data'] = json.encode(data);
    data = null; logo = null; tokenTmpAsesor = null;
    return await http.Response.fromStream(await httpSend.send());
  }

  /*
  * @see LoginAsesorPage::autenticar
  * @see UserRepository::getTokenFromServer
  */
  Future<String> getToken(Map<String, dynamic> credentials) async {

    await this._printAndRefreshIp('getToken');
    String token;
    Uri uri = Uri.parse('${this._uriBase}/login/integrantes/login_check');

    final req = http.MultipartRequest('POST', uri);
    req.fields['_usname'] = credentials['u_usname'];
    req.fields['_uspass'] = credentials['u_uspass'];
    http.Response reServer = await http.Response.fromStream(await req.send());
    if(reServer.statusCode == 200) {
      final res = json.decode(reServer.body);
      token = res['token'];
    }else{
      this.result = erroresServer.determinarError(reServer);
      return 'error';
    }
    return token;
  }

  /*
  * @see UserRepository::getDataUserFromServer
  */
  Future<Map<String, dynamic>> getDataUserFromServer(Map<String, dynamic> credentials) async {

    await this._printAndRefreshIp('getDataUserFromServer');
    Map<String, dynamic> res = new Map();
    Uri uri = Uri.parse('${this._uriBase}/apis/usuarios-en-general/recovery-data-user/');

    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer ${credentials['u_tokenServer']}';
    req.fields['data'] = json.encode({
      'u_usname'       : credentials['u_usname'],
      'u_tokenDevices' : credentials['u_tokenDevices']
    });
    http.Response reServer = await http.Response.fromStream(await req.send());

    if(reServer.statusCode == 200) {
      res = json.decode(reServer.body);
    }else{
      this.result = erroresServer.determinarError(reServer);
      res = {'error':true};
    }
    return res;
  }

  /*
  * @see UserRepository::getUltimosUserRegistrados
  */
  Future<List<Map<String, dynamic>>> getUltimosUserRegistrados(String token) async {

    await this._printAndRefreshIp('getUltimosUserRegistrados');
    List<Map<String, dynamic>> res = new List();
    Uri uri = Uri.parse('${this._uriBase}/$uriApiSocios/get-ultimos-users-registrados/');

    final req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer $token';

    http.Response reServer = await http.Response.fromStream(await req.send());
    if(reServer.statusCode == 200) {
      res = new List<Map<String, dynamic>>.from(json.decode(reServer.body));
    }else{
      this.result = erroresServer.determinarError(reServer);
      res = [{'error':true}];
    }
    return res;
  }

  /*
  * @see LoginAsesorPage::autenticar
  */
  Future<Map<String, dynamic>> registrarNewUser(Map<String, dynamic> usuario) async {

    await this._printAndRefreshIp('registrarNewUser');
    Uri uri = Uri.parse('${this._uriBase}/registros/users/zm/from-app/');

    final req = http.MultipartRequest('POST', uri);
    req.fields['data'] = json.encode(usuario);
    http.Response reServer = await http.Response.fromStream(await req.send());
    if(reServer.statusCode == 200) {
      usuario = json.decode(reServer.body);
      if(usuario.containsKey('abort')){
        if(usuario['abort']) {
          this.result = erroresServer.determinarErrorSinCodigo(usuario['dev']);
          return {'error':true};
        }
      }
    }else{
      this.result = erroresServer.determinarError(reServer);
      return {'error':true};
    }
    return usuario;
  }

  /*
  * @see LoginAsesorPage::autenticar
  */
  Future<http.Response> getNotificacionesInBackAup(Map<String, dynamic> usuario) async {

    await this._printAndRefreshIp('getNotificacionesInBackAup');
    Uri uri = Uri.parse('${this._uriBase}/apis/usuarios-en-general/${usuario['u_id']}/get-pushes-saved/');

    final req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer ${usuario['u_tokenServer']}';
    usuario = null;
    return await http.Response.fromStream(await req.send());
  }

  /*
  * @see UserRepository::makeBackupNotificaciones
  */
  Future<void> markComo(String campo, int idPush, Map<String, dynamic> usuario) async {

    await this._printAndRefreshIp('markComo $campo');
    Uri uri = Uri.parse('${this._uriBase}/apis/usuarios-en-general/${usuario['u_id']}/$campo/$idPush/mark-pushes-como/');

    final req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer ${usuario['u_tokenServer']}';
    await http.Response.fromStream(await req.send());
    usuario = null;
  }

  /*
  * @see UserRepository::updateTokenDevice
  */
  Future<Map<String, dynamic>> updateTokenDevice(Map<String, dynamic> usuario) async {

    await this._printAndRefreshIp('updateTokenDevice');
    Uri uri = Uri.parse('${this._uriBase}/apis/usuarios-en-general/update-token-device/');

    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer ${usuario['u_tokenServer']}';
    Map<String, dynamic> sendData = {
      'u_id': usuario['u_id'],
      'u_usname': usuario['u_usname'],
      'u_tokenDevices': usuario['u_tokenDevices']
    };
    req.fields['data'] = json.encode(sendData);

    http.Response reServer = await http.Response.fromStream(await req.send());
    if(reServer.statusCode == 200) {
      usuario = json.decode(reServer.body);
    }else{
      this.result = erroresServer.determinarError(reServer);
      return {'error':true};
    }
    return null;
  }

  /// 
  Future<Map<String, dynamic>> hacerPruebaDeComunicacionPush(Map<String, dynamic>data) async {

    await this._printAndRefreshIp('hacerPruebaDeComunicacionPush');
    bool respuesta =false;
    Uri uri = Uri.parse('${this._uriBase}/apis/usuarios-en-general/hacer-prueba-de-comunicacion/');

    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer ${data['u_tokenServer']}';
    req.fields['data'] = json.encode({
      'u_id': data['u_id'],
      'u_usname': data['u_usname'],
      'u_tokenDevices': data['u_tokenDevices']
    });
    http.Response reServer = await http.Response.fromStream(await req.send());
    if(reServer.statusCode == 200){
      this.result = json.decode(reServer.body);
    }else{
      this.result = erroresServer.determinarError(reServer);
      respuesta = true;
    }
    return {'error':respuesta};
  }

  /// 
  Future<http.Response> getDatosUserByFile(int idUser, String username, String tokenAsesor) async {

    await this._printAndRefreshIp('getDatosUserByFile');
    Uri uri = Uri.parse('${this._uriBase}/${this.uriApiAsesor}/$idUser/$username/get-datos-user-by-file/');

    final req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer $tokenAsesor';
    return await http.Response.fromStream(await req.send());
  }
}