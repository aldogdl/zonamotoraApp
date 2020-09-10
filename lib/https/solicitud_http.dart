import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:zonamotora/globals.dart' as globals;
import 'package:zonamotora/singletons/cotizacion_sngt.dart';
import 'package:zonamotora/utils/cambiando_la_ip_dev.dart';

class SolicitudHttp {

  CotizacionSngt sngtCot = CotizacionSngt();

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
        print('Gastando datos -> SolicitudHttp::$metodo');
        return true;
      }());
    }
  /// End Bloque
  
  String _uriApis = 'apis/solicitudes';

  ///
  Future<http.Response> enviarDataSolicitud(Map<String, dynamic> data) async {

    await this._printAndRefreshIp('enviarDataSolicitud');

    String token = data['user']['u_tokenServer'];
    data['user'].remove('u_tokenServer');

    Uri uri = Uri.parse('${this._uriBase}/${this._uriApis}/set-nueva-solicitud/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $token';
    req.fields['solicitud'] = json.encode(data);

    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> enviarFotosSolicitud(Map<String, dynamic> data) async {

    await this._printAndRefreshIp('enviarFotosSolicitud');

    String token = data['user']['u_tokenServer'];
    String fileNameSaved = data['file'];
    List<String> prefix = fileNameSaved.split('.');
    List<Map<String, dynamic>> fotos = data['fotos'];
    Map<String, dynamic> infoFotos = new Map();
    List<Map<String, dynamic>> fotosSend = new List();
    data = null;

    Uri uri = Uri.parse('${this._uriBase}/${this._uriApis}/save-img-refacciones/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $token';
    token = null;

    // Organizamos la información
    for (var i = 0; i < fotos.length; i++) {
      bool addiciona = true;
      if (fotosSend.isEmpty) {
        infoFotos = {
          'idAuto': fotos[i]['idAuto'],
          'idPieza': fotos[i]['idPieza'],
          'exts': [fotos[i]['ext']],
          'fotos': [fotos[i]['foto']]
        };
      } else {
        // Revisar si existe el idFoto y el IdPieza en fotosSend.
        int indexFotosSend = fotosSend.indexWhere((fto) =>
            (fto['idAuto'] == fotos[i]['idAuto'] &&  fto['idPieza'] == fotos[i]['idPieza']));

        if (indexFotosSend > -1) {
          fotosSend[indexFotosSend]['exts'].add(fotos[i]['ext']);
          fotosSend[indexFotosSend]['fotos'].add(fotos[i]['foto']);
          addiciona = false;
        } else {
          infoFotos = {
            'idAuto': fotos[i]['idAuto'],
            'idPieza': fotos[i]['idPieza'],
            'exts': [fotos[i]['ext']],
            'fotos': [fotos[i]['foto']]
          };
        }
      }

      if (addiciona) {
        fotosSend.add(infoFotos);
      }
    }

    fotos = null;
    int numberFotos = 0;
    if (fotosSend.length > 0) {
      for (var i = 0; i < fotosSend.length; i++) {
        for (var f = 0; f < fotosSend[i]['fotos'].length; f++) {
          String fileName =
                'f${prefix[0]}_${f}_${fotosSend[i]['idAuto']}_${fotosSend[i]['idPieza']}.${fotosSend[i]['exts'][f]}'
                .toLowerCase();
          http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
            'foto_$numberFotos',
            fotosSend[i]['fotos'][f],
            filename: '$fileName',
            contentType: MediaType(
                "image", '${fotosSend[i]['exts'][f].toString().toLowerCase()}'
            ),
          );

          req.files.add(multipartFile);
          fotosSend[i]['fotos'][f] = fileName;
          numberFotos++;
        }
        fotosSend[i].remove('exts');
      }
    }
    req.fields['data'] = json.encode({
      'fileNameSaved': fileNameSaved,
      'cantFotos': numberFotos,
      'infoFotos': fotosSend
    });

    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> getCotizacionesToFilesFromServer(List<String> data, Map<String, dynamic> dataUser) async {

    await this._printAndRefreshIp('getCotizacionesToFilesFromServer');
    String token = dataUser['u_tokenServer'];

    Uri uri = Uri.parse('${this._uriBase}/${this._uriApis}/get-cotizaciones-to-file/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $token';
    token = null;
    req.fields['files'] = json.encode(data);
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> getPedidoParaCotizar(Map<String, dynamic> dataUser) async {
    
    await this._printAndRefreshIp('getPedidoParaCotizar');
    // Protegemos a base del singleton de cotizar para que no este gastando datos en e background
    if(sngtCot.hasDataPedidos){ return null; }

    Uri uri = Uri.parse('${this._uriBase}/apis/socios/get-pedidos-para-cotizar/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer ${dataUser['u_tokenServer']}';
    req.fields['data'] = json.encode({'u_id': dataUser['u_id']});
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> getDataPiezaFromServer(Map<String, dynamic> dataUser, Map<String, dynamic> dataSolicitud) async {

    await this._printAndRefreshIp('getDataPiezaFromServer');

    // Protegemos a base del singleton de cotizar para que no este gastando datos en e background
    if(sngtCot.hasDataPieza){ return null; }

    Uri uri =Uri.parse('${this._uriBase}/apis/socios/get-pedido-by-id/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer ${dataUser['u_tokenServer']}';
    dataSolicitud['u_id'] = dataUser['u_id'];
    req.fields['data'] = json.encode(dataSolicitud);
    dataUser = null;
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> setCotizacion(String tokenServer, Map<String, dynamic> cotiza) async {

    await this._printAndRefreshIp('setCotizacion');

    Uri uri = Uri.parse('${this._uriBase}/apis/socios/set-cotizacion/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';
    req.fields['data'] = json.encode(cotiza);
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> enviarFotosCotizacion(String tokenServer, int idInv, List<Map<String, dynamic>> fotos) async {

    await this._printAndRefreshIp('enviarFotosCotizacion');

    Uri uri = Uri.parse('${this._uriBase}/apis/socios/$idInv/set-fotos-de-cotizacion/');
    http.MultipartRequest req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';
    
    for (var i = 0; i < fotos.length; i++) {
      req.files.add(
        http.MultipartFile.fromBytes(
          'fotoCot$i', fotos[i]['data'], filename: fotos[i]['nombreFoto'],
          contentType: MediaType("image", fotos[i]['ext']),
        )
      );
    }

    fotos = null;

    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> getDataPasarelas() async {

    await this._printAndRefreshIp('getDataPasarelas');

    Uri uri = Uri.parse('${this._uriBase}/zm/generales/get-pasarelas/');
    final req = http.MultipartRequest('GET', uri);
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> getSolicitudesByidUser(Map<String, dynamic> dataUser) async {

    await this._printAndRefreshIp('getSolicitudesByidUser');

    final uri = Uri.parse('${this._uriBase}/${this._uriApis}/${dataUser['u_id']}/get-solicitudes-by-user/');

    final req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer ${dataUser['u_tokenServer']}';
    dataUser = null;
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> getPiezasDeLaSolicitud(List<int> idsSolicitudes, String tokenServer) async {

    await this._printAndRefreshIp('getPiezasDeLaSolicitud');

    final uri = Uri.parse('${this._uriBase}/${this._uriApis}/get-piezas-de-la-solicitud/');

    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';
    req.fields['data'] = json.encode(idsSolicitudes);
    idsSolicitudes = tokenServer = null;
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> getRespuestas(int refApps, String tokenServer) async {

    await this._printAndRefreshIp('getRespuestas');
    final uri = Uri.parse('${this._uriBase}/${this._uriApis}/$refApps/get-respuestas/');

    final req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';
    refApps = tokenServer = null;
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> getInventarioByIds(List<int> ids, String tokenServer) async {

    await this._printAndRefreshIp('getInventarioByIds');
    final uri = Uri.parse('${this._uriBase}/${this._uriApis}/get-inventario-by-ids/');

    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';
    req.fields['data'] = json.encode(ids);
    ids = tokenServer = null;
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> getPiezasBySocioAndStatus(Map<String, dynamic> dataUser, String status) async {

    await this._printAndRefreshIp('getPiezasBySocioAndStatus');

    final uri = Uri.parse('${this._uriBase}/apis/socios/${dataUser['u_id']}/$status/get-piezas-by-user-and-status/');

    final req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer ${dataUser['u_tokenServer']}';
    dataUser = null;
    return await http.Response.fromStream(await req.send());
  }

}
