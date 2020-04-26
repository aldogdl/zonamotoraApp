import 'package:flutter/widgets.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:zonamotora/entity/pieza_entity.dart';
import 'package:zonamotora/repository/procc_roto_repository.dart';

class SolicitudSngt {

  static SolicitudSngt _solicitudSngt = SolicitudSngt._();
  SolicitudSngt._();
  factory SolicitudSngt() {

    if(_solicitudSngt == null) {
      _solicitudSngt = SolicitudSngt._();
    }
    return _solicitudSngt;
  }

  dispose() {
    _solicitudSngt = null;
  }

  /// --------------------------------------------------///
  
  ProccRotoRepository emProccRotos = ProccRotoRepository();
  
  int thubFachadaX = 533;
  int thubFachadaY = 300;
  int idAutoForEdit;
  int paginaVista = 0;
  double scrollEdit = 0.0;
  String fileNameSaved = '0';
  ///
  List<Map<String, dynamic>> _imagesDeSolicitud = new List();
  List<Map<String, dynamic>> get imagesDeSolicitud => this._imagesDeSolicitud;
  ///
  Map<String, dynamic> _autoEnJuego = {'indexAuto': null};
  Map<String, dynamic> get autoEnJuego => this._autoEnJuego;
  setAutoEnJuegoIndexAuto(int indexAuto) {
    this._autoEnJuego['indexAuto'] = indexAuto;
  }

  ///
  Color _indicadorColorCantPiezas;
  void setIndicadorColorCantPiezas(Color color) {
    this._indicadorColorCantPiezas = color;
  }
  Color get indicadorColorCantPiezas => this._indicadorColorCantPiezas;
  
  ///
  Map<String, dynamic> _user = new Map();
  Map<String, dynamic> get user => this._user;
  void setUser(Map<String, dynamic> user) => this._user = user;

  ///
  Map<String, dynamic> _processRecovery = new Map();
  void setProcessRecovery(Map<String, dynamic> data) => this._processRecovery = data;
  Map<String, dynamic> get processRecovery => this._processRecovery;

  ///
  List<Map<String, dynamic>> _autosSeleccionados = new List();
  void setAutoSeleccionado(Map<String, dynamic> auto) {
    Map<String, dynamic> hasAuto = this._autosSeleccionados.firstWhere((a){
      return (a['md_id'] == auto['md_id']);
    }, orElse: () => new Map());

    if(hasAuto.isEmpty){
      this._autosSeleccionados.add(auto);
    }
  }
  void resetAutos() {
    this._autosSeleccionados = new List();
  }
  void removeAuto(int idModelo) {
    this._autosSeleccionados.removeWhere((auto) => auto['md_id'] == idModelo);
  }
  List<Map<String, dynamic>> get autos => this._autosSeleccionados;
  void setAutosByRecoverDB(List<Map<String, dynamic>> autos) => this._autosSeleccionados = autos;

  ///
  Future<List<Map<String, dynamic>>> revisarAnios(Map<String, dynamic> anios) async {

    List<Map<String, dynamic>> errores = new List();
    anios.forEach((key, ctrl){
      String nomAuto = key.replaceAll('_', ' ').toUpperCase();
      String val = ctrl.text.toString();
      val = val.replaceAllMapped(RegExp(r'\s'), (Match m) => '');
      bool hasErro = false;

      if(val.length == 0){
        errores.add(
          {
            'titulo':'Para $nomAuto',
            'stitulo':'Es requerido que indiques el AÑO por favor.'
          }
        );
        hasErro = true;
      }
      if(!hasErro){
        if(val.length < 4 || val.length > 4){
          errores.add(
            {
              'titulo':'Para el AÑO de $key',
              'stitulo':'Se aceptan 4 números nada más.'
            }
          );
          hasErro = true;
        }
      }
      if(!hasErro) {
        RegExp patron = RegExp(r'\d', multiLine: true);
        if(patron.allMatches(val).length < 4){
          errores.add(
            {
              'titulo':'El AÑO de $key',
              'stitulo':'Coloca sólo números hasta 4 dígitos.'
            }
          );
          hasErro = true;
        }
      }
    });

    return errores;
  }

  ///
  Future<List<Map<String, dynamic>>> revisarContenido() async {

    List<Map<String, dynamic>> errores = new List();
    bool hasError = false;
    this._autosSeleccionados.forEach((auto){

      if(auto.containsKey('piezas')) {
        if(auto['piezas'].length == 0){ hasError = true; }
      }else{
        hasError = true;
      }
      if(hasError){
        errores.add({
          'titulo':'Para ${auto['md_nombre']}',
          'stitulo':'No se detectó ninguna pieza solicitada.'
        });
      }
      hasError = false;
      if(auto.containsKey('anio')){
        if(auto['anio'].length < 4) {
          errores.add({
            'titulo':'Para ${auto['md_nombre']}',
            'stitulo':'Indica el AÑO con 4 números.'
          });
        }
      }else{
        hasError = true;
      }
      if(hasError){
        errores.add({
          'titulo':'Para ${auto['md_nombre']}',
          'stitulo':'Es necesario que indiques su AÑO.'
        });
      }
    });

    return errores;
  }

  ///
  Future<void> setAnio(int indexAuto, String anio) async {

    if(this._autosSeleccionados[indexAuto].containsKey('anio')) {
      this._autosSeleccionados[indexAuto]['anio'] = anio;
    }else{
      this._autosSeleccionados[indexAuto].putIfAbsent('anio', () => anio);
    }
  }

  ///
  Future<void> setVersion(int indexAuto, String version) async {

    if(this._autosSeleccionados[indexAuto].containsKey('version')) {
      this._autosSeleccionados[indexAuto]['version'] = version;
    }else{
      this._autosSeleccionados[indexAuto].putIfAbsent('version', () => version);
    }
  }

  ///
  Future<void> addMapParaAddPiezas() async {

    if(!this._autosSeleccionados[this.autoEnJuego['indexAuto']].containsKey('piezas')){

      List<Map<String, dynamic>> piezas = new List();
      Map<String, dynamic> otroAuto = new Map();
      otroAuto = Map<String, dynamic>.from(this._autosSeleccionados[this.autoEnJuego['indexAuto']]);
      otroAuto.putIfAbsent('piezas', () => piezas);
      this._autosSeleccionados[this.autoEnJuego['indexAuto']] = otroAuto;
    }
  }

  ///
  Future<bool> savePieza({@required String pieza, @required String lado, String posicion, int id = 0}) async {

    PiezaEntity piezaEntity = PiezaEntity();

    int indexPieza;
    piezaEntity.pieza = pieza;
    piezaEntity.lado  = lado;
    piezaEntity.posicion = posicion;

    if(id == 0){

      piezaEntity.cant = 1;
      piezaEntity.id = _determinarIdDePieza();
      piezaEntity.foto = null;
      this._autosSeleccionados[this._autoEnJuego['indexAuto']]['piezas'].add(piezaEntity.toJson());
    }else{

      piezaEntity.id = id;
      indexPieza = this._autosSeleccionados[this._autoEnJuego['indexAuto']]['piezas'].indexWhere((piezas) => (piezas['id'] == id));
      if(piezaEntity.foto != null){
        if(this._autosSeleccionados[this._autoEnJuego['indexAuto']]['piezas'][indexPieza].containsKey('foto')) {
          piezaEntity.foto.setFotoByJson(this._autosSeleccionados[this._autoEnJuego['indexAuto']]['piezas'][indexPieza]['foto']);
        }
      }
      piezaEntity.cant = this._autosSeleccionados[this._autoEnJuego['indexAuto']]['piezas'][indexPieza]['cant'];
      this._autosSeleccionados[this._autoEnJuego['indexAuto']]['piezas'][indexPieza] = piezaEntity.toJson();
    }

    return true;
  }

  ///
  int _determinarIdDePieza() {
    
    if(this._autosSeleccionados[this._autoEnJuego['indexAuto']]['piezas'].length == 0) {
      return 1;
    }
    List<int> idsActuales = new List();
    this._autosSeleccionados[this._autoEnJuego['indexAuto']]['piezas'].forEach((pieza){
      idsActuales.add(pieza['id']);
    });
    idsActuales.sort();
    return (idsActuales.last + 1);
  }

  ///
  Asset fotoFromJsonToAsset(int indexPieza){

    PiezaEntity piezaEntity = PiezaEntity();
    return piezaEntity.foto.toAsset(
      this._autosSeleccionados[this._autoEnJuego['indexAuto']]['piezas'][indexPieza]['foto']
    );
  }

  /// Realizamos el Backup en la base de datos para proteger el alta en
  /// caso de que la app se cierre por el proceso de incluir fotos.
  /// 
  /// @see FichasAutosSelectPage::_fichaDeRefaccion
  Future<bool> makeBackupInBd({
    @required int indexPieza,
    double scroll,
  }) async {

    Map<String, dynamic> metaData = {
      'seccion'   : 1,
      'indexAuto' : autoEnJuego['indexAuto'],
      'indexPieza': indexPieza,
      'scroll'    : scroll,
    };

    return await emProccRotos.makeBackupByAltaDeRefacciones(
      metadata: metaData,
      contents: autos
    );
  }

  ///
  Future<void> setFotoPieza(Asset foto, int indexAuto, int indexPieza) async {

    PiezaEntity piezaEntity = PiezaEntity();
    piezaEntity.foto.setFotoByAsset(foto, this.thubFachadaX, this.thubFachadaY);
    this._autosSeleccionados[indexAuto]['piezas'][indexPieza]['foto'] = piezaEntity.foto.toJson();
  }

  /// creamos un Slug del String enviado
  String toSlug(String nombreModelo) {

    Map<String, String> sinAc = {'á':'a', 'é':'e', 'í':'i', 'ó':'o', 'ú':'u'};
    nombreModelo = nombreModelo.toLowerCase();
    nombreModelo = nombreModelo.replaceAll(RegExp(r'[\s]+'), '_');
    nombreModelo = nombreModelo.replaceAllMapped(RegExp(r'[áéíóú]'), (Match m){
      return sinAc[m.group(0)];
    });
    return nombreModelo;
  }

  /// Traducimos de numeros a Texto los lados Seleccionados
  String traslateLados(String nombrePieza, List<Map<String, dynamic>> lados, Set ladSelec) {

    String traslate = '';
    String gen = trasladeGeneroPieza(nombrePieza);

    ladSelec.forEach((ladoSeleccionado){
      Map<String, dynamic> lado = lados.firstWhere((ld){
        return (ld['valor'] == ladoSeleccionado);
      }, orElse: () => new Map());
      
      if(lado.isNotEmpty) {
        if(traslate.isEmpty) {
          traslate = lado['titulo'][gen];
        }else{
          traslate = '$traslate - ${ lado['titulo'][gen] }';
        }
      }
    });

    return (traslate.isEmpty) ? traslate : ', $traslate';
  }

  /// Calculamos el String para determinar que genero tiene la pieza enviada
  String trasladeGeneroPieza(String pieza) {

    String generoPieza = 'o';
    if(pieza.length > 0){
      String val = pieza.trim().toLowerCase();
      bool gen = val.endsWith('a');
      if(gen){
        generoPieza = 'a';
      }
    }
    return generoPieza;
  }

  /// Convertimos el String Guardado en el set necesario para visualizar en pantalla.
  List<dynamic> trasladeSubLadosFromStringToSet(String nombrePieza, List<Map<String, dynamic>> lados, String lado) {

    List<dynamic> results = new List();
    List<String> pedazos = lado.split(',');
    String gen = trasladeGeneroPieza(nombrePieza);
    // Agregamos el lado principal
    results.add(pedazos[0].trim());

    if(pedazos.length > 1){

      Set<int> ladosSeleccionados = new Set();
      String ladosActuales = pedazos[1].trim();

      pedazos = ladosActuales.split('-');
      pedazos.forEach((ld){
        Map<String, dynamic> lado = lados.firstWhere((lds){
          return (lds['titulo'][gen] == ld.trim());
        }, orElse: () => new Map());
        if(lado.isNotEmpty){
          ladosSeleccionados.add(lado['valor']);
        }
      });
      results.add(ladosSeleccionados);
    }else{
      results.add(new Set<int>());
    }
    return results;
  }

  ///
  Map<String, dynamic> getIdUser() {

    Map<String, dynamic> newUser = Map<String, dynamic>.from(this.user);
    newUser.remove('u_uspass');
    newUser.remove('u_usname');
    return newUser;
  }

  ///
  Map<String, dynamic> getDataDeSolicitud() {

    Map<String, dynamic> data = new Map();
    data.putIfAbsent('user', () => getIdUser());
    data.putIfAbsent('solicitud',() => new List());
    List<Map<String, dynamic>> bolsa = new List();
    this._imagesDeSolicitud = new List();

    this._autosSeleccionados.forEach((auto){
      List<Map<String, dynamic>> piezas = new List();
      Map<String, dynamic> carro = new Map<String, dynamic>.from(auto)..addAll({'copy':1});
      carro.remove('md_nombre');
      carro.remove('mk_nombre');
      if(carro.containsKey('version')){
        if(carro['version'].length == 0) {
          carro.remove('version');
        }
      }

      int piezasCant = (carro['piezas'] != null) ? carro['piezas'].length : 0;
      if(piezasCant > 0){
        // Un ciclo para las piezas
        carro['piezas'].forEach((pieza){

          if(pieza.containsKey('foto')){
            this._imagesDeSolicitud.add({
              'idPieza': pieza['id'],
              'foto': pieza['foto']
            });
            pieza.remove('foto');
          }
          if(pieza.containsKey('posicion')){
            if(pieza['posicion'].isEmpty) {
              pieza.remove('posicion');
            }
          }
          piezas.add(pieza);

        });
      }
      carro.remove('piezas');
      bolsa.add({'auto':carro, 'piezas':piezas});
    });

    data['solicitud'] = bolsa;
    return data;
  }

  ///
  Future<bool> limpiarSolicitudSgtn() async {

    this.idAutoForEdit = null;
    this.paginaVista = null;
    this.scrollEdit = 0;
    this.fileNameSaved = '0';
    this._imagesDeSolicitud = new List();
    this._autoEnJuego = null;
    this._indicadorColorCantPiezas = null;
    this._user = new Map();
    this._processRecovery = new Map();
    this._autosSeleccionados = new List();
    await emProccRotos.deleteProcesosRotosByAltaDeRefaccs();
    dispose();
    return true;
  }

}