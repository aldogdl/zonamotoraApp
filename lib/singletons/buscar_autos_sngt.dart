
class BuscarAutosSngt {

  static final BuscarAutosSngt _buscarAutosSngt = BuscarAutosSngt._();
  BuscarAutosSngt._();
  factory BuscarAutosSngt() {
    if(_buscarAutosSngt == null) {
      return BuscarAutosSngt._();
    }
    return _buscarAutosSngt;
  }

  int _idMarca;
  int get idMarca => this._idMarca;
  setIdMarca(int idMarca) => this._idMarca = idMarca;
  ///
  String _nombreMarca;
  String get nombreMarca => this._nombreMarca;
  setNombreMarca(String nombreMarca) => this._nombreMarca = nombreMarca;
  ///
  int _idModelo;
  int get idModelo => this._idModelo;
  setIdModelo(int idModelo) => this._idModelo = idModelo;
  ///
  String _nombreModelo;
  String get nombreModelo => this._nombreModelo;
  setNombreModelo(String nombreModelo) => this._nombreModelo = nombreModelo;
  ///
  List<Map<String, dynamic>> _autosNews = new List();
  setAutoNew(Map<String, dynamic> autoNew) => this._autosNews.add(autoNew);
  List<Map<String, dynamic>> get autosNews => this._autosNews;
  ///
  Future<void> limpiarBuscarMarcaSngt() async {

    this._idMarca = null;
    this._nombreMarca = null;
    this._autosNews = new List();
  }
}