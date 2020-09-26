import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zonamotora/globals.dart' as globals;
import 'package:zonamotora/utils/cambiando_la_ip_dev.dart';

class AppVariosHttp {

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
        print('Gastando datos -> AppVariosHttp::$metodo');
        return true;
      }());
    }
  /// End Bloque

  String _uriApi = 'zm/generales';

  ///
  Future<http.Response> getColonias(int idCiudad) async {

    await this._printAndRefreshIp('getColonias');

    Uri uri = Uri.parse('${this._uriBase}/${this._uriApi}/$idCiudad/get-colonias/');

    final req = http.MultipartRequest('GET', uri);
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> setColonia(Map<String, dynamic> colonia) async {

    await this._printAndRefreshIp('setColonia');

    Uri uri = Uri.parse('${this._uriBase}/${this._uriApi}/set-colonia/');

    final req = http.MultipartRequest('POST', uri);
    req.fields['colonia'] = json.encode(colonia);
    return await http.Response.fromStream(await req.send());
  }

  /*
   * @see SistemasRepository::getSistemas
  */
  Future<http.Response> getSistemas() async {

    await this._printAndRefreshIp('getSistemas');

    Uri uri = Uri.parse('${this._uriBase}/$_uriApi/get-sistemas-del-auto/');
    final req = http.MultipartRequest('GET', uri);
    return  await http.Response.fromStream(await req.send());
  }

  /*
   * @see SistemasRepository::getSistemas
  */
  Future<http.Response> getCiudades() async {

    await this._printAndRefreshIp('getCiudades');

    Uri uri = Uri.parse('${this._uriBase}/$_uriApi/get-ciudades/');
    final req = http.MultipartRequest('GET', uri);
    return  await http.Response.fromStream(await req.send());
  }

  /*
  * @see AutosRepository::getSetMarcasAndModelos
  */
  Future<http.Response> getMarcasAndModelos() async {

    await this._printAndRefreshIp('getMarcasAndModelos');

    Uri uri = Uri.parse('${this._uriBase}/registros/users/zm/get-marcas-y-modelos/');
    final req = http.MultipartRequest('GET', uri);
    return await http.Response.fromStream(await req.send());
  }

  /*
  * @see AppVariosRepository::getAllCategosFromServer
  */
  Future<http.Response> getAllCategosFromServer() async {

    await this._printAndRefreshIp('getAllCategos');

    Uri uri = Uri.parse('${this._uriBase}/${this._uriApi}/get-all-categos/');
    final req = http.MultipartRequest('GET', uri);
    return await http.Response.fromStream(await req.send());
  }

  /*
  * @see NotificsRepository::getConstraints
  */
  Future<http.Response> getConstraints(Map<String, dynamic> dataUser) async {

    await this._printAndRefreshIp('getConstraints');

    Uri uri = Uri.parse('${this._uriBase}/apis/socios/${dataUser['u_id']}/get-restricciones/');

    final req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer ${dataUser['u_tokenServer']}';
    dataUser = null;
    return await http.Response.fromStream(await req.send());
  }

}