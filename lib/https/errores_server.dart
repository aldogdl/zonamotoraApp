import 'dart:convert';

import 'package:http/http.dart' as http;

class ErroresServer {

  Map<String, dynamic> _result = {'abort':true, 'msg' : 'ok', 'body':''};

  /* */
  Map<String, dynamic> determinarError(http.Response error) {

    switch (error.statusCode) {
      case 500:
        _result['msg'] = 'ERROR 500 DEL SERVIDOR';
        if(error.reasonPhrase.contains('Internal')){
          _result['body'] = 'Ocurrió un Error inesperado, por favor inténtalo más tarde.';
        }else{
          _result['body'] = error.reasonPhrase;
        }
        break;
      case 401:
        final res = json.decode(error.body);
        if(res.containsKey('message')){
          if(res['message'].contains('Invalid')){
            _result['msg'] = 'ERROR EN CREDENCIALES';
            _result['body'] = 'Tus credenciales no son correctas, inténtalo nuevamente';
          }
          if(res['message'].contains('not found')){
            _result['msg'] = 'LLAVE DEL SERVIDOR';
            _result['body'] = 'El token para la comunicación hacia el servidor, no fué enviado';
          }
        }
        break;
      default:
        _result['msg'] = 'ERROR DESCONOCIDO';
        _result['body'] = error.reasonPhrase;
    }
    return this._result;
  }

  /* */
  Map<String, dynamic> determinarErrorSinCodigo(String error) {
    print('aca::$error');
    if(error.contains('Duplicate')) {
      _result['msg'] = 'DATOS DUPLICADOS';
      _result['body'] = 'El Nombre de Usuario o el Teléfono ya están registrados con ZonaMotora.';
      return _result;
    }
    return _result;
  }

  /* */
  void printErrDev(Map<String, dynamic> err) {
    assert((){
      if(err.containsKey('abort')){
      if(err['abort']){
        print(':::: ERROR DEl SERVIDOR ::::');
        print(err);
      }
    }
      return true;
    }());
  }
}