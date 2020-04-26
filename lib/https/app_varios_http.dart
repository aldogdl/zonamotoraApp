import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zonamotora/globals.dart' as globals;

class AppVariosHttp {

  String _uriApi = 'zm/generales';

  ///
  Future<http.Response> getColonias(int idCiudad) async {

    Uri uri = Uri.parse('${globals.uriBase}/${this._uriApi}/$idCiudad/get-colonias/');
    final req = http.MultipartRequest('GET', uri);
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> setColonia(Map<String, dynamic> colonia) async {

    Uri uri = Uri.parse('${globals.uriBase}/${this._uriApi}/set-colonia/');
    final req = http.MultipartRequest('POST', uri);
    req.fields['colonia'] = json.encode(colonia);
    return await http.Response.fromStream(await req.send());
  }

  /*
   * @see SistemasRepository::getSistemas
  */
  Future<http.Response> getSistemas() async {

    Uri uri = Uri.parse('${globals.uriBase}/$_uriApi/get-sistemas-del-auto/');
    final req = http.MultipartRequest('GET', uri);
    return  await http.Response.fromStream(await req.send());
  }

  /*
   * @see SistemasRepository::getSistemas
  */
  Future<http.Response> getCiudades() async {

    Uri uri = Uri.parse('${globals.uriBase}/$_uriApi/get-ciudades/');
    final req = http.MultipartRequest('GET', uri);
    return  await http.Response.fromStream(await req.send());
  }

  /*
  * @see AutosRepository::updateTokenDevice
  */
  Future<http.Response> getMarcasAndModelos() async {

    Uri uri = Uri.parse('${globals.uriBase}/registros/users/zm/get-marcas-y-modelos/');
    final req = http.MultipartRequest('GET', uri);
    return await http.Response.fromStream(await req.send());
  }

}