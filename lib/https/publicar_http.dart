import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:zonamotora/utils/cambiando_la_ip_dev.dart';
import 'package:zonamotora/globals.dart' as globals;

class PublicarHttp {

    String _apiPublic = 'apis/publicaciones';
    String _apiPublicFree = 'zm/publicaciones';


    /// Bloque Utilizado solo en modo developer para cambios de IP repentinos
    CambiandoLaIpDev gestionDeIp = CambiandoLaIpDev();
    String _uriBase = globals.uriBase;
    PublicarHttp() { if(globals.env == 'dev') { _getIpDev(); } }
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

   ///
  Future<http.Response> getLastPublicacion(Map<String, dynamic> credentialsUser) async {

    await _printAndRefreshIp('getLastPublicacion');
    Uri uri = Uri.parse('${this._uriBase}/$_apiPublic/${credentialsUser['u_id']}/get-last-publicacion/');

    final req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer ${credentialsUser['u_tokenServer']}';
    credentialsUser = null;
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> uploadFotoPublicacion(List<Map<String, dynamic>> fotos, Map<String, dynamic> credentialsUser) async {

    await _printAndRefreshIp('uploadFotoPublicacion');
    Uri uri = Uri.parse('${this._uriBase}/$_apiPublic/upload-foto-publicacion/');

    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer ${credentialsUser['u_tokenServer']}';
    List<String> camposFiles = new List();

    for (var i = 0; i < fotos.length; i++) {
      camposFiles.add('foto_${fotos[i]['id']}');
      req.files.add(
        http.MultipartFile.fromBytes(
          'foto_${fotos[i]['id']}', fotos[i]['img'], filename: '${fotos[i]['nombreAlt']}_${credentialsUser['u_id']}_${fotos[i]['id']}.${fotos[i]['ext']}',
          contentType: MediaType("image", fotos[i]['ext']),
        )
      );
    }

    req.fields['data'] = json.encode({'campos': camposFiles, 'user': credentialsUser['u_id']});
    fotos = null;
    credentialsUser = null;
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> deleteFotoPublicacion(String foto, Map<String, dynamic> credentialsUser) async {

    await _printAndRefreshIp('deleteFotoPublicacion');
    Uri uri = Uri.parse('${this._uriBase}/$_apiPublic/delete-foto-publicacion/');

    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer ${credentialsUser['u_tokenServer']}';
    
    req.fields['data'] = json.encode({'filename': foto, 'user': credentialsUser['u_id']});
    foto = null;
    credentialsUser = null;
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> sendDataByPublicacion(Map<String, dynamic> data, Map<String, dynamic> credentialsUser) async {

    await _printAndRefreshIp('sendDataByPublicacion');
    Uri uri = Uri.parse('${this._uriBase}/$_apiPublic/set-new-publicacion/');

    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer ${credentialsUser['u_tokenServer']}';
    data['user'] = credentialsUser['u_id'];
    req.fields['data'] = json.encode(data);
    data = null;
    credentialsUser = null;
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> getUnidades(int typeUnidad, int pag) async {

    await _printAndRefreshIp('getUnidades');
    Uri uri = Uri.parse('${this._uriBase}/$_apiPublicFree/$typeUnidad/$pag/get-all-publicaciones/');

    final req = http.MultipartRequest('GET', uri);
    return await http.Response.fromStream(await req.send());
  }

    ///
  Future<http.Response> getPublicacionById(int typeUnidad, int idPublic) async {

    await _printAndRefreshIp('getUnidades');
    Uri uri = Uri.parse('${this._uriBase}/$_apiPublicFree/$typeUnidad/$idPublic/get-publicacio-by-id/');

    final req = http.MultipartRequest('GET', uri);
    return await http.Response.fromStream(await req.send());
  }


}