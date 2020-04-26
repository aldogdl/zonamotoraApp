import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:zonamotora/globals.dart' as globals;
import 'package:zonamotora/https/errores_server.dart';

class AsesoresHttp {

  ErroresServer erroresServer = ErroresServer();
  Map<String, dynamic> result = {'abort':false, 'msg' : 'ok', 'body':''};
  String _apiAsoser = 'apis/asesor';

  /*
  * @see LoginAsesorPage::getAsesores
  */
  Future<List<Map<String, dynamic>>> getAsesores() async {

    List<Map<String, dynamic>> asesores = new List();
    Uri uri = Uri.parse('${globals.uriBase}/asesores/get-asesores/');
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

    String token;
    Uri uri = Uri.parse('${globals.uriBase}/login/integrantes/login_check');
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

    List<dynamic> tipos;
    Uri uri = Uri.parse('${globals.uriBase}/asesores/get-tipos-socios/');
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

    Uri uri = Uri.parse('${globals.uriBase}/$_apiAsoser/set-colonias/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $token';
    req.fields['colonia'] = json.encode(colonia);
    return await http.Response.fromStream(await req.send());
  }

  /// Guardamos en el servidor los datos en bruto del nuevo usuario
  /// 
  /// @see AltaSaveResumPage::build
  Future<bool> saveAltaNuevoUser(Map<String, dynamic> data, String tokenAsesor) async {

    Uri uri = Uri.parse('${globals.uriBase}/${this._apiAsoser}/save-alta-nuevo-user/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $tokenAsesor';
    req.fields['data'] = json.encode(data);
    http.Response  reServer = await http.Response.fromStream(await req.send());
    if(reServer.statusCode == 200) {
      final res = json.decode(reServer.body);
      return res['abort'];
    }else{
      this.result = erroresServer.determinarError(reServer);
    }
    return false;
  }

  /// Guardamos en el servidor los datos en bruto del nuevo usuario
  /// 
  /// @see AltaSaveResumPage::build
  Future<bool> saveFachada(int idUser, ByteData fachada, String tokenAsesor) async {

    Uri uri = Uri.parse('${globals.uriBase}/${this._apiAsoser}/save-fachada/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $tokenAsesor';

    List<int> imageData = fachada.buffer.asUint8List();
    http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
      'fachada', imageData, filename: '${idUser}_zonamotora.jpg', contentType: MediaType("image", "jpg"),
    );
    req.files.add(multipartFile);

    http.Response  reServer = await http.Response.fromStream(await req.send());
    if(reServer.statusCode == 200) {
      final res = json.decode(reServer.body);
      return res['abort'];
    }else{
      this.result = erroresServer.determinarError(reServer);
    }
    return false;
  }
}