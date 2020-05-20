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
  int _prefixAutosNuevos = 7000;
  int indexAutoIsEditing = -1;
  String editAutoPage;
  bool addOtroAuto = false;
  String filenameInServer;
  ///
  Map<String, dynamic> _autoEnJuego = {'indexAuto': null, 'indexPieza': null, 'idPieza': null};
  Map<String, dynamic> get autoEnJuego => this._autoEnJuego;
  setAutoEnJuegoIndexAuto(int indexAuto) => this._autoEnJuego['indexAuto'] = indexAuto;
  setAutoEnJuegoIndexPieza(int indexPieza) => this._autoEnJuego['indexPieza'] = indexPieza;
  setAutoEnJuegoIdPieza(int idPieza) => this._autoEnJuego['idPieza'] = idPieza;

  ///
  Map<String, dynamic> _user = new Map();
  Map<String, dynamic> get user => this._user;
  void setUser(Map<String, dynamic> user) => this._user = user;
  Map<String, dynamic> getIdUser() {

    Map<String, dynamic> newUser = Map<String, dynamic>.from(this.user);
    newUser.remove('u_uspass');
    newUser.remove('u_usname');
    return newUser;
  }

  ///
  List<Map<String, dynamic>> _autosSeleccionados = new List();
  void setAutoSeleccionado(Map<String, dynamic> auto) => this._autosSeleccionados.add(auto);
  Future<void> editarAuto(Map<String, dynamic> newAuto) async {
    Map<String, dynamic> hasAuto = new Map<String, dynamic>.of(this._autosSeleccionados[this.indexAutoIsEditing]);
    if(hasAuto.isNotEmpty) {
      newAuto['piezas'] = hasAuto['piezas'];
      this._autosSeleccionados.removeAt(this.indexAutoIsEditing);
      setAutoSeleccionado(newAuto);
    }
  }
  void resetAutosSeleccionados() {
    this._autosSeleccionados = new List();
  }
  void removeAutoByIndex(int index) {
    this._autosSeleccionados.removeAt(index);
  }
  void removeAutoByIdModelo(int idModelo) {
    this._autosSeleccionados.removeWhere((auto) => auto['md_id'] == idModelo);
  }
  List<Map<String, dynamic>> get autos => this._autosSeleccionados;

  /// Seccion de Recuperación
  bool _isRecovery = false;
  get isRecovery => this._isRecovery;
  setIsRecovery(bool isRecovery) => this._isRecovery = isRecovery;
  void setAutosByRecoverDB(List<Map<String, dynamic>> autos) => this._autosSeleccionados = autos;
  void setProcessRecovery(Map<String, dynamic> data){
    this._autoEnJuego = data;
  }
  List<Asset> recoveryFotos() {

    List<Asset> fotosRecovery = new List();
    List fotos = this._autosSeleccionados[this._autoEnJuego['indexAuto']]['piezas'][this._autoEnJuego['indexPieza']]['fotos'];
    fotos = (fotos == null) ? new List() : fotos;
    PiezaEntity piezaEntity = PiezaEntity();

    if(fotos.length > 0) {
      fotos.forEach((foto){
        fotosRecovery.add(piezaEntity.foto.toAsset(foto));
      });
    }
    return fotosRecovery;
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
  Future<int> determinarIdDePieza() async {
    
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
  Future<int> determinarIdDelNuevoAuto() async {

    if(this._autosSeleccionados.length == 0) {
      return this._prefixAutosNuevos;
    }
    List<int> idsActuales = new List();
    this._autosSeleccionados.forEach((auto){
      if(auto['md_id'] >= this._prefixAutosNuevos){
        idsActuales.add(auto['md_id']);
      }
    });
    if(idsActuales.length == 0){
      return this._prefixAutosNuevos;
    }
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

  ///
  Future<bool> makeBackup(Map<String, dynamic> piezaScreen) async {

    bool resetAutoEnjuego = false;
    // Buscar la piezas en el auto en juego.
    int indexPieza = this._autosSeleccionados[this._autoEnJuego['indexAuto']]['piezas'].indexWhere(
      (pieza) => (pieza['id'] == piezaScreen['id']));

    if(indexPieza > -1) {
      this.setAutoEnJuegoIdPieza(piezaScreen['id']);
      this.setAutoEnJuegoIndexPieza(indexPieza);
      await this.editPieza(piezaScreen);
      resetAutoEnjuego = true;
    }else{
      await this.addPieza(piezaScreen);
    }

    bool res = await emProccRotos.makeBackupByAltaDeRefacciones(metadata: this._autoEnJuego, contents: this._autosSeleccionados);
    if(resetAutoEnjuego){
      this.setAutoEnJuegoIdPieza(null);
      this.setAutoEnJuegoIndexPieza(null);
    }

    return res;
  }

  ///
  Future<void> addPieza(Map<String, dynamic> pieza) async {
    this._autosSeleccionados[this._autoEnJuego['indexAuto']]['piezas'].add(pieza);
  }

  ///
  Future<void> editPieza(Map<String, dynamic> pieza) async {
    this._autosSeleccionados[this._autoEnJuego['indexAuto']]['piezas'][this._autoEnJuego['indexPieza']] = pieza;
  }

  ///
  Future<List<Map<String, dynamic>>> setFotosPieza(List<Asset> fotos) async {

    int x;
    int y;
    PiezaEntity piezaEntity = PiezaEntity();
    List<Map<String, dynamic>> fotosMaps = new List();

    fotos.forEach((foto){
      if(foto.isPortrait){
        x = this.thubFachadaY;
        y = this.thubFachadaX;
      }else{  
        x = this.thubFachadaX;
        y = this.thubFachadaY;
      }
      piezaEntity.foto.setFotoByAsset(foto, x, y);
      fotosMaps.add(piezaEntity.foto.toJson());
    });
    return fotosMaps;
  }

  ///
  void limpiarSingleton() {

    this.indexAutoIsEditing = -1;
    this.editAutoPage = null;
    this.addOtroAuto = false;
    this._autoEnJuego = {'indexAuto': null, 'indexPieza': null, 'idPieza': null};
    this._user = new Map();
    this._autosSeleccionados = new List();
    this._isRecovery = false;
    emProccRotos.deleteProcesosRotosByAltaDeRefaccs();
    dispose();
  }
}