
class OportsSolicitudesSng {

  static OportsSolicitudesSng _oportsSolicitudesSng = OportsSolicitudesSng._();
  OportsSolicitudesSng._();
  factory OportsSolicitudesSng() {
    if(_oportsSolicitudesSng == null){
      _oportsSolicitudesSng = OportsSolicitudesSng._();
    }
    return _oportsSolicitudesSng;
  }

  ///
  dispose() {
    _oportsSolicitudesSng = null;
  }

  // List<Map<String, dynamic>> _lstOportunidades = new List();

}