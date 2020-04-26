import 'package:zonamotora/entity/perfil_entity.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AltaUserSngt {

  static AltaUserSngt _altaUserSngt = AltaUserSngt._();
  AltaUserSngt._();
  factory AltaUserSngt() {
    if(_altaUserSngt == null) { return AltaUserSngt._(); }
    return _altaUserSngt;
  }

  // ---------------------------------------------------------------//

  PerfilEntity     perfilEntity     = PerfilEntity();
  List<Map<String, dynamic>> redesSociales = [
    {'titulo':'Facebook', 'slug':'facebook', 'link':'https://facebook.com/'},
    {'titulo':'Instagram', 'slug':'instagram', 'link':'https://instagram.com/'},
    {'titulo':'Youtube', 'slug':'youtube', 'link':'https://youtube.com/'},
    {'titulo':'Otra Nueva', 'slug':'otra_nueva', 'link':'Ingresa el Link Completo'},
  ];
  List<Map<String, dynamic>> allPasosDelAltas = [
    {'titulo': 'ESPECIALISTAS EN SISTEMAS:', 'ruta': 'alta_sistema_page' },
    {'titulo': 'PALABRAS CLAVES:', 'ruta': 'alta_sistema_pc_page'},
    {'titulo': 'ESPECIALISTAS MARCAS:', 'ruta': 'alta_mksmds_page'},
    {'titulo': 'DATOS DEL NEGOCIO:', 'ruta': 'alta_perfil_contac_page'},
    {'titulo': 'MAPA, LOCALIDAD Y OTROS:', 'ruta': 'alta_perfil_otros_page'},
    {'titulo': 'REDES SOCIALES E INTERNET:', 'ruta': 'alta_perfil_pwrs_page'}
  ];

  /// 
  List<Map<String, dynamic>> crearMenuSegunRole() {

    List<Map<String, dynamic>> menu = new List();
    if(perfilEntity.role != null) {
      if(perfilEntity.role == 'ROLE_SOCIO') {
        menu.add(this.allPasosDelAltas[0]);
        menu.add(this.allPasosDelAltas[1]);
        menu.add(this.allPasosDelAltas[2]);
      }
      menu.add(this.allPasosDelAltas[3]);
      menu.add(this.allPasosDelAltas[4]);
      menu.add(this.allPasosDelAltas[5]);
    }
    return menu;
  }

  int          _ciudad;
  int          _userId;
  String       _usname;
  Asset        _fachada;

  Set<int> mrksSelect = new Set();
  Set<int> mdsSelect = new Set();
  List<Map<String, dynamic>> listSistemaSelect = new List();
  List<Map<String, dynamic>> lstSistemas = new List();
  List<Map<String, dynamic>> lstCiudades = new List();
  List<Map<String, dynamic>> lstColonias = new List();
  List<Map<String, dynamic>> lstPalClas  = new List();

  ///
  void setUserId(int id) => this._userId = id;
  int get userId => this._userId;

  ///
  void setRoles(String role) {
    perfilEntity.setRole(role);
  }
  String get roles => perfilEntity.role;

  ///
  void setCiudad(int ciudad) => this._ciudad = ciudad;
  int get ciudad => this._ciudad;
  String getNombreCiudadById() {
    Map<String, dynamic> ciudad = this.lstCiudades.firstWhere((ciudad){
      return (ciudad['c_id'] == this._ciudad);
    }, orElse: () => new Map());
    return (ciudad.isEmpty) ? 'ERROR Ciudad no encontrada' : 'CD.: ${ciudad['c_nombre']}';
  }

  ///
  void setColonia(int colonia) => perfilEntity.setColonia(colonia);
  int get colonia => perfilEntity.colonia;

  ///
  void setPaginaWeb(String pw) {
    if(pw != null) {
      pw = pw.toLowerCase();
      pw = pw.replaceAll(RegExp(r'(http:)(https:)\/\/'), '');
      pw = pw.replaceAll('www.', '');
    }
    perfilEntity.setPaginaWeb(pw);
  }
  String get paginaWeb => perfilEntity.paginaWeb;

  ///
  void setHasDelivery(bool delivery) => perfilEntity.setHasDelivery(delivery);
  bool get hasDelivery => perfilEntity.hasDelivery;

  ///
  void setPagoCard(bool pagoCard) => perfilEntity.setPagoCard(pagoCard);
  bool get pagoCard => perfilEntity.pagoCard;

  ///
  void setUsname(String usname) => this._usname = usname;
  String get usname => this._usname;

  ///
  void setEmail(String email) => perfilEntity.setEmail(email);
  String get email => perfilEntity.email;

  ///
  void setLatLng(String latLng) => perfilEntity.setLatLng(latLng);
  String get latLng => perfilEntity.latLng;

  ///
  void addNewLinkRS({String redSocial, String link}) {

    Map<String, dynamic> redSelect = this.redesSociales.firstWhere(
      (rs) => (rs['titulo'] == redSocial),
      orElse: () => new Map()
    );

    link = link.trim().toLowerCase();
    perfilEntity.setRedSocs(redSelect['slug'], link);
  }

  ///
  bool removeLinkRS({String redSocial, int indice}) {

    Map<String, dynamic> redSelect = this.redesSociales.firstWhere(
      (rs) => (rs['titulo'] == redSocial),
      orElse: () => new Map()
    );

    return perfilEntity.removeLinkRS(redSelect['slug'], indice);
  }
  
  ///
  Map<String, dynamic> get redSocs => perfilEntity.redsocs;

  ///
  String get direccionForMap => perfilEntity.direccionForMap;

  ///
  Future<void> setSistemSelect(Set<int> idSeleccionados) async {

    List<Map<String, dynamic>> listSistemaSelectTmp = (this.listSistemaSelect == null) ? new List() : this.listSistemaSelect;
    this.listSistemaSelect = new List();
    idSeleccionados.forEach((id) {
      Map<String, dynamic> sistema = listSistemaSelectTmp.firstWhere((s) => (s['sa_id'] == id), orElse: () => new Map());
      String palClas = '0';
      if(sistema.isEmpty) {
        sistema = this.lstSistemas.firstWhere((s) => (s['sa_id'] == id), orElse: () => new Map());
      }else{
        palClas = sistema['sa_palclas'];
      }
      this.listSistemaSelect.add({'sa_id':sistema['sa_id'], 'sa_palclas':palClas});
    });

    listSistemaSelectTmp = null;
  }

  ///
  Future<void> setPalClasToSistemSelect(int idSistema, String palClas) async {

    this.listSistemaSelect.forEach((sistema) {
      if(sistema['sa_id'] == idSistema) {
        sistema['sa_palclas'] = palClas;
      }
    });
  }

  /// Hidratamos la seccion de contactato del perfil del usuario
  void hidratarPerfilContacSgtn({
    String razonSocial,
    String nombreContacto,
    String domicilio,
    String telsContac
  }){

    List<String> tels = telsContac.split(',');
    nombreContacto = _toTitleFrase(nombreContacto);
    domicilio = _formatDomicilio(domicilio);
    razonSocial = razonSocial.toUpperCase();

    perfilEntity.hidratarPerfilContact(
      nombreContacto: nombreContacto.trim(),
      razonSocial: razonSocial.trim(),
      domicilio: domicilio.trim(),
      telsContac: tels
    );
  }

  /// Convertimos en txt en tipo Titulo, la primer letra en mayusculas
  String _toTitleFrase(String txt) {

    List<String> noms = txt.split(' ');
    for (var i = 0; i < noms.length; i++) {
      String nom = noms[i].trim();
      if(txt.length > 3 || i == 0) {
        noms[i] = _toTitle(nom);
      }
    }
    return noms.join(' ');
  }

  /// Convertimos en txt en tipo Titulo, la primer letra en mayusculas
  String _toTitle(String txt) {

    txt = txt.toLowerCase();
    String ini = txt.substring(0, 1);
    String rest = txt.substring(1, txt.length);
    txt = '${ini.toUpperCase()}$rest';
    return txt;
  }

  ///
  String _formatDomicilio(String txt) {

    String dom;
    List<String> domsNew = new List();
    txt = txt.toLowerCase();
    txt = txt.replaceAll('#', '');
    txt = txt.replaceAll('no.', '');
    List<String> doms = txt.split(' ');
    for (var i = 0; i < doms.length; i++) {
      dom = doms[i].trim();
      if(dom.length > 3 || i == 0) {
        dom = _toTitle(dom);
      }
      RegExp patron = RegExp(r'^[0-9]');
      bool res = patron.hasMatch(dom);
      if(res) {
        if(!dom.contains('no.')){
          dom = dom.toUpperCase();
          dom = 'No. $dom';
        }
      }
      dom = dom.trim();
      if(dom.length > 0){
        domsNew.add(dom);
      }
    }
    return domsNew.join(' ');
  }

  ///
  Map<String, dynamic> toJsonPerfilContact() => perfilEntity.toJsonPerfilContact();

  /// Regresamos todos los datos preparados para enviar al servidor.
  Map<String, dynamic> jsonToSend() {

    return {
      'user'  : {'id':this._userId, 'usname':this._usname},
      'perfil': perfilEntity.toJson(), 'sistemas' : this.listSistemaSelect,
      'marcas': this.mrksSelect.toList(), 'modelo' : this.mdsSelect.toList()
    };
  }

  ///
  void setFachada(Asset fachada) => this._fachada = fachada;
  Asset get fachada => this._fachada;

  ///
  void dispose() {
    perfilEntity.dispose();
    this._ciudad = null;
    this._usname = null;
    this.mrksSelect = new Set();
    this.mdsSelect  = new Set();
    this.listSistemaSelect = new List();
    this.lstSistemas = new List();
    this.lstCiudades = new List();
    this.lstColonias = new List();
    this.lstPalClas  = new List();
  }
}