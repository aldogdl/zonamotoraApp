
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zonamotora/globals.dart' as globals;

class CambiandoLaIpDev {

  SharedPreferences _session;

  ///
  Future<void> _setInstance() async {
    this._session = await SharedPreferences.getInstance();
  }

  ///
  Future<String> getIp() async {

    await this._setInstance();

    String ip = this._session.getString('ipDev');
    if(ip == null){
      ip = globals.ip;
      this._session.setString('ipDev', ip);
    }
    return ip;
  }

  ///
  Future<String> setIp(String ip) async {

    await this._setInstance();
    this._session.setString('ipDev', ip);
    return ip;
  }

  ///
  void dispose() {
    this._session = null;
  }
}