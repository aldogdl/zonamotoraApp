import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:zonamotora/globals.dart' as globals;
import 'package:zonamotora/https/errores_server.dart';
import 'package:zonamotora/utils/cambiando_la_ip_dev.dart';

class AsesoresHttp {
  
  /// Bloque Utilizado solo en modo developer para cambios de IP repentinos
    CambiandoLaIpDev gestionDeIp = CambiandoLaIpDev();
    String _uriBase = globals.uriBase;
    AsesoresHttp() { if(globals.env == 'dev') { _getIpDev(); } }
    Future<String> _getIpDev() async {
      String ip = await gestionDeIp.getIp();
      return this._uriBase.replaceFirst('${globals.ip}', ip);
    }
    Future<void> _printAndRefreshIp(String metodo) async {
      this._uriBase = (globals.env == 'dev') ? await _getIpDev() : globals.uriBase;
      assert((){
        print(this._uriBase);
        print('Gastando datos -> AsesoresHttp::$metodo');
        return true;
      }());
    }
  /// End Bloque

  ErroresServer erroresServer = ErroresServer();
  Map<String, dynamic> result = {'abort':false, 'msg' : 'ok', 'body':''};
  String _apiAsoser = 'apis/asesor';

  /*
  * @see LoginAsesorPage::getAsesores
  */
  Future<List<Map<String, dynamic>>> getAsesores() async {

    await this._printAndRefreshIp('getAsesores');
    List<Map<String, dynamic>> asesores = new List();
    Uri uri = Uri.parse('${this._uriBase}/asesores/get-asesores/');

    final req = http.MultipartRequest('GET', uri);
    http.Response reServer = await http.Response.fromStream(await req.send());
    if(reServer.statusCode == 200) {
      List<dynamic> res = json.decode(reServer.body);
      asesores = List<Map<String, dynamic>>.from(res);
    }else{
      // Crear una clase para tratar todos los tipos de errores.
    }
    return asesores;
  }

  /*
  * @see LoginAsesorPage::autenticar
  */
  Future<String> autenticar(String username, String pass) async {

    await this._printAndRefreshIp('autenticar');
    String token;
    Uri uri = Uri.parse('${this._uriBase}/login/integrantes/login_check');

    final req = http.MultipartRequest('POST', uri);
    req.fields['_usname'] = username;
    req.fields['_uspass'] = pass;
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
  * @see LoginAsesorPage::autenticar
  */
  Future<List<Map<String, dynamic>>> getTiposDeSocios() async {

    await this._printAndRefreshIp('getTiposDeSocios');

    List<dynamic> tipos;
    Uri uri = Uri.parse('${this._uriBase}/asesores/get-tipos-socios/');

    final req = http.MultipartRequest('GET', uri);
    http.Response reServer = await http.Response.fromStream(await req.send());
    if(reServer.statusCode == 200) {
      tipos = json.decode(reServer.body);
    }else{
      // Crear una clase para tratar todos los tipos de errores.
    }
    return new List<Map<String, dynamic>>.from(tipos);
  }

  /*
  * @see AppVariosRepository::setColonia
  */
  Future<http.Response> setColonia(Map<String, dynamic> colonia, token) async {

    await this._printAndRefreshIp('setColonia');

    Uri uri = Uri.parse('${this._uriBase}/$_apiAsoser/set-colonias/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $token';
    req.fields['colonia'] = json.encode(colonia);
    return await http.Response.fromStream(await req.send());
  }

  /// Guardamos en el servidor los datos en bruto del nuevo usuario
  /// 
  /// @see AltaSaveResumPage::build
  Future<Map<String, dynamic>> saveAltaNuevoUser(Map<String, dynamic> data, String tokenAsesor) async {

    await this._printAndRefreshIp('saveAltaNuevoUser');

    Uri uri = Uri.parse('${this._uriBase}/${this._apiAsoser}/save-alta-nuevo-user/');
    print(data);
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $tokenAsesor';
    req.fields['data'] = json.encode(data);
    http.Response  reServer = await http.Response.fromStream(await req.send());

    if(reServer.statusCode == 200) {
      final res = json.decode(reServer.body);
      return new Map<String, dynamic>.from(res);
    }else{
      this.result = erroresServer.determinarError(reServer);
    }
    return new Map();
  }

  /// Guardamos en el servidor los datos en bruto del nuevo usuario
  /// 
  /// @see AltaSaveResumPage::build
  Future<bool> saveFachada(int idUser, Map<String, dynamic> fachada, String tokenAsesor) async {

    await this._printAndRefreshIp('saveFachada');

    Uri uri = Uri.parse('${this._uriBase}/${this._apiAsoser}/save-fachada/');

    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $tokenAsesor';

    http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
      'fachada', fachada['img'], filename: '${idUser}_zonamotora.jpg', contentType: MediaType("image", fachada['ext']),
    );
    req.files.add(multipartFile);
    fachada = null;
    http.Response  reServer = await http.Response.fromStream(await req.send());
    if(reServer.statusCode == 200) {
      final res = json.decode(reServer.body);
      return res['abort'];
    }else{
      this.result = erroresServer.determinarError(reServer);
    }
    
    return false;
  }

  /*
  * @see ProccRotoRepository::_recoveryLogotipoSocio
  */
  Future<Map<String, dynamic>> recoveryDataPagWebById(int idUser) async {

    await this._printAndRefreshIp('recoveryDataPagWebById');
    
    Uri uri = Uri.parse('${this._uriBase}/asesores/$idUser/recovery-data-pageweb-by-user/');

    final req = http.MultipartRequest('GET', uri);
    http.Response reServer = await http.Response.fromStream(await req.send());
    if(reServer.statusCode == 200) {
      return new Map<String, dynamic>.from(json.decode(reServer.body));
    }
    return new Map();
  }
}