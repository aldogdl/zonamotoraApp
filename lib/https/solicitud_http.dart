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
   
    Uri uri = Uri.parse('${ globals.uriBase }/${this._uriApis}/set-nueva-solicitud/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $token';
    req.fields['solicitud'] = json.encode(data);

    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> enviarFotosSolicitud(Map<String, dynamic> data) async {

    String token = data['user']['u_tokenServer'];
    String fileNameSaved = data['file'];
    List<String> prefix = fileNameSaved.split('.');
    List<Map<String, dynamic>> fotos = data['fotos'];
    Map<String, dynamic> infoFotos = new Map();
    List<Map<String, dynamic>> fotosSend = new List();
    data = null;

    Uri uri = Uri.parse('${ globals.uriBase}/${this._uriApis}/save-img-refacciones/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $token';
    token = null;

    // Organizamos la información
    for (var i = 0; i < fotos.length; i++) {
      bool addiciona = true;
      if(fotosSend.isEmpty) {
        infoFotos = {
          'idAuto' : fotos[i]['idAuto'],
          'idPieza': fotos[i]['idPieza'],
          'exts'   : [fotos[i]['ext']],
          'fotos'  : [fotos[i]['foto']]
        };
      }else{
        // Revisar si existe el idFoto y el IdPieza en fotosSend.
        int indexFotosSend = fotosSend.indexWhere((fto)
          => (fto['idAuto'] == fotos[i]['idAuto'] && fto['idPieza'] == fotos[i]['idPieza']));

        if(indexFotosSend > -1) {
          fotosSend[indexFotosSend]['exts'].add(fotos[i]['ext']);
          fotosSend[indexFotosSend]['fotos'].add(fotos[i]['foto']);
          addiciona = false;
        }else{
          infoFotos = {
            'idAuto' : fotos[i]['idAuto'],
            'idPieza': fotos[i]['idPieza'],
            'exts'   : [fotos[i]['ext']],
            'fotos'  : [fotos[i]['foto']]
          };
        }
      }

      if(addiciona){
        fotosSend.add(infoFotos);
      }
    }
    fotos = null;
    int numbreFotos = 0;
    if(fotosSend.length > 0){
      for (var i = 0; i < fotosSend.length; i++) {
        for (var f = 0; f < fotosSend[i]['fotos'].length; f++) {

          String fileName = '${prefix[0]}_${f}_${fotosSend[i]['idPieza']}.${fotosSend[i]['exts'][f]}'.toLowerCase();
          http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
            'foto_$numbreFotos', fotosSend[i]['fotos'][f], filename: '$fileName', contentType: MediaType("image", '${fotosSend[i]['exts'][f].toString().toLowerCase()}'),
          );

          req.files.add(multipartFile);
          fotosSend[i]['fotos'][f] = fileName;
          numbreFotos++;
        }
        fotosSend[i].remove('exts');
      }
    }
    req.fields['data'] = json.encode({'fileNameSaved': fileNameSaved, 'cantFotos':numbreFotos, 'infoFotos':fotosSend});

    return await http.Response.fromStream(await req.send());
  }
}