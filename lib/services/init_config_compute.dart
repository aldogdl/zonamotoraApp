import 'package:flutter/foundation.dart';
import 'package:zonamotora/https/usuarios_http.dart';
import 'package:zonamotora/repository/user_repository.dart';

Future<bool> makeHilo(List<Map<String, dynamic>> toDo) async {

  toDo.forEach((tarea) async {

      switch (tarea['toDo']) {
        case 'user':
          /* */
          await compute(hacerLoginUserAndSeveNewTokenServer, 'nulo');
          break;
        case 'tokenDevice':
          /* */
          String token = tarea['params'][0];
          await compute(updateTokenDevice, token);
          break;
        default:
      }
  });

  return true;
}

/* */
Future<bool> hacerLoginUserAndSeveNewTokenServer(String nulo) async {

  UserRepository emUser = UserRepository();
  UsuariosHttp userHttp = UsuariosHttp();

  Map<String, dynamic> credentials = await emUser.getCredentials();
  String result = await userHttp.getToken(credentials);
  if(result != 'error'){
    //await emUser.setTokenServerInBD(result);
  }
  return true;
}

/* */
Future<bool> updateTokenDevice(String token) async {

  UserRepository emUser = UserRepository();
  await emUser.updateTokenDevice(token);
  return true;
}