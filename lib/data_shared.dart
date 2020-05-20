import 'package:flutter/material.dart';

class DataShared with ChangeNotifier {

  /*
   * Utilizada para saber si el usuario ya completo todo lo que se necesita para el registro
   * y a su ves este valor evita que se reconfiguren cosas que ya fueron inicializadas en init_config_page
   * 
   * @see init_config_page::_checkConfigPush    -> Consumido
   * @see registro_user_page::_checkConfigPush  -> Asignado
  */
  int _segReg = 0;
  get segReg => _segReg;
  setsegReg(int segReg) {
    this._segReg = segReg;
  }

  /* 
   * Utilizada para verificar que el sistema esta configurado para recibir PUSH
   * fortalecemos el sistema para evitar doble configuracion de este servicio
   * 
   * @see ConfigGMSSngt::initConfigGMS       -> Asignado
   * @see init_config_page::_checkConfigPush -> Consumido
   * @see registro_user_page::_sendForm      -> Consumido
   * @see ConfigPage::_body                  -> Consumido
   */
  bool _isConfigPush = false;
  get isConfigPush => _isConfigPush;
  setIsCofigPush(bool configPush) {
    this._isConfigPush = configPush;
  }

  /*
   * @see registro_user_page::_sendForm  -> Asignan
   * @see InitConfigPage::_checkDataUser -> Asignan
   * @see index_page::_body              -> Consumido
   * @see index_page::_tableDeBtns       -> Consumido
   * @see index_page::_autorizadoComo    -> Consumido
   * @see MisAutosPage::_content         -> Consumido
   */
  String _username;
  get username => _username;
  setUsername(String username) {
    this._username = username;
    notifyListeners();
  }

  /*
   * @see InitConfigPage::_checkDataUser -> Asignan
   * @see index_page::_body              -> Consumido
   */
  String _role;
  get role => _role;
  setRole(String role) {
    this._role = role;
    notifyListeners();
  }

  /*
   * Utilizado temporalmente por el asesor que pueda realizar cosas privadas en el dispositivo
   * 
  */
  Map<String, String> _tokenAsesor;
  get tokenAsesor => this._tokenAsesor;
  void setTokenAsesor(Map<String, String> dataAsesor) {
    this._tokenAsesor = dataAsesor;
    notifyListeners();
  }

  /*  
   * Utilizado en toda la seccion administrativa para regresar a la pagina anterior
   * 
   * @see RegistroIndexPage::build  --> Asigno
   */
  String _lastPageVisit = 'alta_index_menu_page';
  get lastPageVisit => _lastPageVisit;
  setLastPageVisit(String lastPageVisit) {
    this._lastPageVisit = lastPageVisit;
  }

}