import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zonamotora/globals.dart' as globals;
import 'package:zonamotora/https/errores_server.dart';

class UsuariosHttp {

  ErroresServer erroresServer = ErroresServer();
  Map<String, dynamic> result = {'abort':false, 'msg' : 'ok', 'body':''};
  final String uriApiSocios = 'apis/socios';

  /*
  * @see LoginAsesorPage::autenticar
  * @see UserRepository::getTokenFromServer
  */
  Future<String> getToken(Map<String, dynamic> credentials) async {

    String token;
    Uri uri = Uri.parse('${globals.uriBase}/login/integrantes/login_check');
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

    Map<String, dynamic> res = new Map();
    Uri uri = Uri.parse('${globals.uriBase}/apis/usuarios-en-general/recovery-data-user/');
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

    List<Map<String, dynamic>> res = new List();
    Uri uri = Uri.parse('${globals.uriBase}/$uriApiSocios/get-ultimos-users-registrados/');
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

    Uri uri = Uri.parse('${globals.uriBase}/registros/users/zm/from-app/');
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
  * @see UserRepository::updateTokenDevice
  */
  Future<Map<String, dynamic>> updateTokenDevice(Map<String, dynamic> usuario) async {

    Uri uri = Uri.parse('${globals.uriBase}/registros/users/zm/from-app/');
    final req = http.MultipartRequest('POST', uri);
    req.fields['data'] = json.encode(usuario);
    http.Response reServer = await http.Response.fromStream(await req.send());
    if(reServer.statusCode == 200) {
      usuario = json.decode(reServer.body);
    }else{
      this.result = erroresServer.determinarError(reServer);
      return {'error':true};
    }
    return usuario;
  }

}