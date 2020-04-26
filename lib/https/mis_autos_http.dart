import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zonamotora/globals.dart' as globals;
import 'package:zonamotora/https/errores_server.dart';

class MisAutosHttp {

  ErroresServer erroresServer = ErroresServer();
  Map<String, dynamic> result = {'abort':false, 'msg' : 'ok', 'body':''};
  String _uriApis = 'apis/autos_particulares';

  /* */
  Future<Map<String, dynamic>> setNewMisAuto(Map<String, dynamic> auto, String tokenServer) async {

    Map<String, dynamic> res = Map();
    Uri uri = Uri.parse('${globals.uriBase}/${this._uriApis}/set-new-auto-particular/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';
    req.fields['data'] = json.encode(auto);
    http.Response reServer = await http.Response.fromStream(await req.send());
    res = json.decode(reServer.body);
    if(reServer.statusCode == 200) {
      erroresServer.printErrDev(res);
    }else{
      this.result = erroresServer.determinarError(reServer);
    }
    return res;
  }

  /*
   * @see MisAutosRepository::getMisAutosFromServer
   */
  Future<List<Map<String, dynamic>>> getMisAutosFromServer(Map<String, dynamic> credentials) async {

    Uri uri = Uri.parse('${globals.uriBase}/${this._uriApis}/${credentials['u_id']}/get-all-autos-del-user/');
    final req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer ${credentials['u_tokenServer']}';
    http.Response reServer = await http.Response.fromStream(await req.send());
    if(reServer.statusCode == 200) {
      return new List<Map<String, dynamic>>.from(json.decode(reServer.body));
    }else{
      this.result = erroresServer.determinarError(reServer);
      return [{'error':true}];
    }
  }

  /* */
  Future<Map<String, dynamic>> deleteAutoParticular(int idAuto, String tokenServer) async {

    Map<String, dynamic> res = Map();
    Uri uri = Uri.parse('${globals.uriBase}/${this._uriApis}/$idAuto/borrar-auto-particular/');
    final req = http.MultipartRequest('DELETE', uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';
    http.Response reServer = await http.Response.fromStream(await req.send());
    res = json.decode(reServer.body);
    if(reServer.statusCode == 200) {
      erroresServer.printErrDev(res);
    }else{
      this.result = erroresServer.determinarError(reServer);
    }
    return res;
  }
}