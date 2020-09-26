import 'package:flutter/material.dart';

class DataShared with ChangeNotifier {

  /*
   * Utilizada para saber si el usuario ya completo all lo que se necesita para el registro
   * y a su ves este valor evita que se reconfiguren cosas que ya fueron inicializadas en init_config_page
   * 
   * @see init_config_page::_checkConfigPush    -> Consumido
   * @see registro_user_page::_checkConfigPush  -> Asignado
  */
  int _segReg = 0;
  get segReg => _segReg;
  setSegReg(int segReg) {
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

  /*  
   * Utilizado para la prueba de cominucacion vilateral
   * 
   * @see ConfigGMSSngt::initConfigGMS  --> Asigno
   * @see PrbaPush::_msgDeRespuesta     --> Consumido
   */
  Map<String, dynamic> _prbaPush = new Map();
  Map<String, dynamic> get prbaPush => _prbaPush;
  setPrbaPush(Map<String, dynamic> prbaPush) {
    this._prbaPush = prbaPush;
    notifyListeners();
  }

  /*  
  * Utilizado para mostrar el Icono de notificaciones
  * 
  * @see ConfigGMSSngt::initConfigGMS  --> Asigno
  * @see IcoNotifWidget::build     --> Consumido
  */
  bool _showNotif = false;
  bool get showNotif => _showNotif;
  setShowNotif(bool showNotif) {
    this._showNotif = showNotif;
    notifyListeners();
  }

  /*  
  * Utilizado para mostrar la cantidad de notificaciones
  * 
  * @see ConfigGMSSngt::initConfigGMS  --> Asigno
  * @see IcoNotifWidget::build     --> Consumido
  */
  int _cantNotif = 0;
  int get cantNotif => _cantNotif;
  setCantNotif(int cantNotif) {
    this._cantNotif = cantNotif;
    notifyListeners();
  }

  /*
  * Utilizado para mostrar la cantidad de solicitudes a Cotizar
  *
  * @see ACotizarWidget::_getPedidoParaCotizar  --> Asigno
  * @see OportunidadesPage::build     --> Consumido
  */
  int _opVtasAcotizar = 0;
  int get opVtasAcotizar => this._opVtasAcotizar;
  setOpVtasAcotizar(int aCotizar) {
    this._opVtasAcotizar = aCotizar;
    notifyListeners();
  }

  /*
  * Utilizado para mostrar la cantidad de solicitudes Apartadas
  *
  * @see ACotizarWidget::_getPedidoParaCotizar  --> Asigno
  * @see OportunidadesPage::build     --> Consumido
  */
  int _opVtasApartadas = 0;
  int get opVtasApartadas => this._opVtasApartadas;
  setOpVtasApartadas(int apartadas) {
    this._opVtasApartadas = apartadas;
    notifyListeners();
  }

  /*
  * Utilizado para mostrar la cantidad de solicitudes a Cotizar
  *
  * @see ACotizarWidget::_getPedidoParaCotizar  --> Asigno
  * @see OportunidadesPage::build     --> Consumido
  */
  int _opVtasInventario = 0;
  int get opVtasInventario => this._opVtasInventario;
  setIpVtasInventario(int inventario) {
    this._opVtasInventario = inventario;
    notifyListeners();
  }

  /*
  * Utilizado para saber que pagina mostrar en la seccion de oportunidades de venta.
  * Cotizar | Apartadas | Inventario
  *
  * @see OportunidadesPage::build     --> Consumido
  */
  int _opsVtasPageView = 0;
  int get opsVtasPageView => this._opsVtasPageView;
  setOpsVtasPageView(int pageView) => this._opsVtasPageView = pageView;

  /*
  * Utilizado para saber que pagina mostrar en la seccion de Revisar Solicitudes -> cotizaciones.
  * Pedientes | Cotizadas | Carrito
  *
  * @see IndexCotizaPage::_verCotizacione  --> Consumido
  */
  int _cotizacPageView = 0;
  int get cotizacPageView => this._cotizacPageView;
  setCotizacPageView(int pageView) => this._cotizacPageView = pageView;

  /*  
  * Utilizado para mostrar el Icono de notificaciones
  * 
  * @see ConfigGMSSngt::initConfigGMS  --> Asigno
  * @see IcoNotifWidget::build     --> Consumido
  */
  List<Map<String, dynamic>> _notifics = new List();
  List<Map<String, dynamic>> get notifics => _notifics;
  setNotifics(Map<String, dynamic> notific) => this._notifics.add(notific);
  setAllNotifics(List<Map<String, dynamic>> notifics) {
    if(this._notifics.length > 0) {
      for (var i = 0; i < this._notifics.length; i++) {
        this._notifics.add(notifics[i]);
      }
    }else{
      this._notifics = notifics;
    }
  }
  void get cleanNotifics => _notifics = new List();

  /// :: Usada en la seccion de cotizaciones(pestañas) y menu inferior.
  int _cantInCarrito = 0;
  IconData icoCarShopBtn = Icons.close;
  Color colorCarShopBtn = Colors.red;
  String txtCarShopBtn = 'CERRAR';
  get cantInCarrito => this._cantInCarrito;
  void setCantInCarrito() {
    this._cantInCarrito = this._cantInCarrito + 1;
    txtCarShopBtn = 'CONTINUAR';
    colorCarShopBtn = Colors.blue;
    icoCarShopBtn = Icons.shopping_cart;
    notifyListeners();
  }
  void delCantInCarrito() {
    this._cantInCarrito = this._cantInCarrito - 1;
    if(this._cantInCarrito < 0) {
      this._cantInCarrito = 0;
    }
    if(this._cantInCarrito == 0){
      icoCarShopBtn = Icons.close;
      colorCarShopBtn = Colors.red;
      txtCarShopBtn = 'CERRAR';
    }
    notifyListeners();
  }
  void setCantTotalInCarrito(int cant) {
    this._cantInCarrito = cant;
    notifyListeners();
  }

  /// Cantidad de Solicitudes :: Usada en la seccion de cotizaciones(pestañas).
  int _cantSolicitudesPendientes = 0;
  get cantSolicitudesPendientes => this._cantSolicitudesPendientes;
  void setCantSolicitudesPendientes(int newCant) {
    this._cantSolicitudesPendientes = newCant;
    notifyListeners();
  }
  /// Cantidad de Cotizaciones :: Usada en la seccion de cotizaciones(pestañas).
  int _cantCotiz = 0;
  get cantCotiz => this._cantCotiz;
  void setCantCotiz(int newCant) {
    this._cantCotiz = newCant;
    notifyListeners();
  }

  //Plugin propio para tomar una imganen desde el dispositivo
  int _refreshWidget = -1;
  get refreshWidget => this._refreshWidget;
  void setRefreshWidget(int refresh){
    this._refreshWidget = refresh;
    notifyListeners();
  }
  void setRefreshWidgetNotifFalse(int refresh){
    this._refreshWidget = refresh;
  }
  
  /// -------- seccion de FAVORITOS --------
  int _cantFavServs = 0;
  int get cantFavServs => this._cantFavServs;
  void setCantFavServs(int cant){
    this._cantFavServs = cant;
    notifyListeners();
  }

  int _cantFavRedacs = 0;
  int get cantFavRefacs => this._cantFavRedacs;
  void setCantFavRefacs(int cant){
    this._cantFavRedacs = cant;
    notifyListeners();
  }

  int _cantFavAutos = 0;
  int get cantFavAutos => this._cantFavAutos;
  void setCantFavAutos(int cant){
    this._cantFavAutos = cant;
    notifyListeners();
  }
}