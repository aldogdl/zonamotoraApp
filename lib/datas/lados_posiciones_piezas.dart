class LadosPosicionesPiezas {

  String _gen = 'm';
  List<Map<String, dynamic>> _ladosGrales = new List();
  List<Map<String, dynamic>> _opPosiciones = new List();

  LadosPosicionesPiezas(){
    this._ladosGrales.add({'icono': 'auto_ico_del', 'titulo': {'f':'Delantera', 'm':'Delantero'}});
    this._ladosGrales.add({'icono': 'auto_ico_lat', 'titulo': {'f':'Lateral', 'm':'Lateral'}});
    this._ladosGrales.add({'icono': 'auto_ico_tras','titulo': {'f':'Trasera', 'm':'Trasero'}});

    this._opPosiciones.add({'titulo' : {'f':'IZQUIERDA', 'm':'IZQUIERDO'}, 'valor' : 2, 'hermano': 1});
    this._opPosiciones.add({'titulo' : {'f':'DERECHA', 'm':'DERECHO'},     'valor' : 1, 'hermano': 2});
    this._opPosiciones.add({'titulo' : {'f':'SUPERIOR', 'm':'SUPERIOR'},   'valor' : 3, 'hermano': 4});
    this._opPosiciones.add({'titulo' : {'f':'INFERIOR', 'm':'INFERIOR'},   'valor' : 4, 'hermano': 3});
  }

  Map<String, dynamic> getLados = {
    'del' : {'nombre':'DELANTER', 'f':'A', 'm':'O'},
    'tras': {'nombre':'TRASER', 'f':'A', 'm':'O'},
    'lat' : {'nombre':'LATERA', 'f':'L', 'm':'L'},
    'der' : {'nombre':'DERECHO', 'f':'A', 'm':'O'},
    'izq' : {'nombre':'IZQUIERDO', 'f':'A', 'm':'O'},
    's'   : {'nombre':'SUPERIO', 'f':'R', 'm':'R'},
    'i'   : {'nombre':'INFERIO', 'f':'R', 'm':'R'},
  };

  /// Calculamos el String para determinar que genero tiene la pieza enviada
  void setGeneroByPieza(String pieza) {
    this._gen = 'm';
    if(pieza == null) return;
    if(pieza.length > 0){
      String val = pieza.trim().toLowerCase();
      bool gen = val.endsWith('a');
      if(gen){
        this._gen = 'f';
      }
    }
  }
  String get generoPieza => this._gen;
  ///
  List<Map<String, dynamic>> get lados => this._ladosGrales;
  ///
  String getLadoNombre(int lado) {
    return this._ladosGrales[lado]['titulo'][this._gen];
  }
  String changeGeneroNombreLado(String ladoSearch) {

    Map<String, dynamic> lado = this._ladosGrales.firstWhere((ld){
      String initTxt = ladoSearch.substring(0,6);
      return (ld['titulo'][this._gen].startsWith(initTxt));
    }, orElse: () => new Map());
    
    if(lado.isEmpty){
      return 'Delantero';
    }
    return lado['titulo'][this._gen];
  }
  ///
  String getPosicionNombre(int lado) {
    return this._opPosiciones[lado]['titulo'][this._gen];
  }
  ///
  int getPosicionValor(int lado) {
    return this._opPosiciones[lado]['valor'];
  }
  ///
  int getPosicionHermano(int lado) {
    return this._opPosiciones[lado]['hermano'];
  }
  String getPosicionesSeleccionadas(Set<int> valoresPosiciones) {
    String posiciones = '';
    valoresPosiciones.forEach((pos) {
      Map<String, dynamic> p = this._opPosiciones.firstWhere((posi) => posi['valor'] == pos, orElse: () => new Map());
      if(p.isNotEmpty){
        if(posiciones.length == 0) {
          posiciones = p['titulo'][this._gen];
        }else{
          posiciones = posiciones + ' - ' + p['titulo'][this._gen];
        }
      }
    });
    return posiciones;
  }
}