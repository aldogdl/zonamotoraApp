class CotizacionSngt {

  static final CotizacionSngt _cotizacionSngt = CotizacionSngt._();
  CotizacionSngt._();
  factory CotizacionSngt(){
    if(_cotizacionSngt == null){
      return CotizacionSngt._();
    }
    return _cotizacionSngt;
  }

  dispose(){
    hasDataPedidos = false;
    hasDataPieza = false;
    idCotizacion = 0;
    isRecovery = false;
    isOtra = false;
    fotos = new List();
  }

  ///
  bool isRecovery = false;
  ///
  bool isOtra = false;
  ///
  bool hasDataPedidos = false;
  ///
  bool hasDataPieza = false;
  ///
  int idCotizacion = 0;
  ///
  List<Map<String, dynamic>> fotos = new List();
  ///
  Map<String, dynamic> piezaEnProceso = new Map();
  ///
  Map<String, dynamic> dataPiezaEnProceso = new Map();
  ///
  Map<String, dynamic> dataPasarelas = new Map();
  ///
  Map<String, dynamic> cotizaciones = new Map();
}