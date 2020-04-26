import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:zonamotora/globals.dart' as globals;

class SolicitudHttp {

  String _uriApis = 'apis/solicitudes';

  ///
  Future<http.Response> enviarDataSolicitud(Map<String, dynamic> data) async {

    String token = data['user']['u_tokenServer'];
    data['user'].remove('u_tokenServer');

    Uri uri = Uri.parse('${ globals.uriBase}/${this._uriApis}/set-nueva-solicitud/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $token';
    req.fields['solicitud'] = json.encode(data);

    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> enviarFotosSolicitud(Map<String, dynamic> data) async {

    String token = data['user']['u_tokenServer'];
    String fileNameSaved = data['fileNameSaved'];
    List<Map<String, dynamic>> fotos = data['fotos'];
    data = null;

    Uri uri = Uri.parse('${ globals.uriBase}/${this._uriApis}/save-img-refacciones/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $token';
    List<String> prefix = fileNameSaved.split('.');

    for (var i = 0; i < fotos.length; i++) {
      
      String fileName = '${prefix[0]}_${fotos[i]['idPieza']}';
      http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
        'foto_$i', fotos[i]['foto'], filename: '$fileName.${fotos[i]['ext']}', contentType: MediaType("image", '${fotos[i]['ext']}'),
      );
      req.files.add(multipartFile);
    }

    req.fields['data'] = json.encode({'fileNameSaved': fileNameSaved, 'cantFotos':fotos.length});

    return await http.Response.fromStream(await req.send());
  }
}