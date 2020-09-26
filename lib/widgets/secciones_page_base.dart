import 'package:flutter/material.dart';
import 'package:zonamotora/repository/publicar_repository.dart';
import 'package:zonamotora/widgets/publicacion_widget.dart';

class SeccionesPageBase extends StatefulWidget {

  final int currentSeccion;
  final bool showResultados;
  SeccionesPageBase({Key key, this.currentSeccion, this.showResultados}) : super(key: key);

  @override
  _SeccionesPageBaseState createState() => _SeccionesPageBaseState();
}

class _SeccionesPageBaseState extends State<SeccionesPageBase> {

  PublicarRepository emPublic = PublicarRepository();
  BuildContext _context;
  Size _screen;
  int _pagina = 1;
  int _pageFromServer = 0;
  int _totPags= 0;
  int _totResl= 0;
  List<Map<String, dynamic>> _categos = new List();
  List<Map<String, dynamic>> _unidades = new List();
  Map<int, dynamic> secciones = {
    1: 'refac_index_page',
    2: 'autos_index_page',
    3: 'servs_index_page'
  };

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: this._screen.width,
      child: Column(
        children: [
          _buscador(),
          (widget.showResultados)
          ?
          _resultados()
          :
          SizedBox(height: 0),
          
        ],
      )
    );
  }

  ///
  Widget _buscador() {

    List<IconData> iconos = [
      Icons.extension, Icons.directions_car, Icons.build
    ];
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '¿Qué estas Buscando?'
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.search),
                  onPressed: (){},
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: this._screen.width,
          height: 38,
          child: FutureBuilder(
            future: _getCategosFromLocal(),
            builder: (_, AsyncSnapshot snapshot){
              if(snapshot.connectionState == ConnectionState.done) {
                if(this._categos.isNotEmpty){

                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: this._categos.length,
                    itemBuilder: (_, index){

                      return Padding(
                        padding: EdgeInsets.only(right: 10, bottom: 5),
                        child: RaisedButton(
                          color: (this._categos[index]['cat_id'] == widget.currentSeccion) ? Colors.grey[300] : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          onPressed: () => Navigator.of(this._context).pushReplacementNamed(this.secciones[this._categos[index]['cat_id']]),
                          child: Row(
                            children: [
                              Icon(iconos[index]),
                              const SizedBox(width: 5),
                              Text(
                                '${this._categos[index]['cat_catego']}',
                                textScaleFactor: 1,
                              )
                            ],
                          ),
                        ),
                      );

                    },
                  );
                }
              }

              return Center(
                child: Text('Cargando Filtro'),
              );
            },
          ),
        )
      ],
    );
  }

  ///
  Widget _resultados() {

    double alto = (widget.showResultados && widget.currentSeccion != 1) ? 0.623 : 0.55;

    return Container(
      width: this._screen.width,
      height: this._screen.height * alto,
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: _getUnidades(),
          builder: (_, AsyncSnapshot snapshot) {
            
            if(snapshot.connectionState == ConnectionState.done){
              if(this._unidades.isNotEmpty){
                return _printPublicaciones();
              }
            }
            return _placeHolderPublic();
          },
        ),
      ),
    );
  }
  
  ///
  Widget _placeHolderPublic() {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Wrap(
        runAlignment: WrapAlignment.start,
        alignment: WrapAlignment.spaceBetween,
        direction: Axis.horizontal,
        runSpacing: 10,
        children: [
          _cajaBacia(),
          _cajaBacia(),
          _cajaBacia(),
          _cajaBacia(),
        ],
      ),
    );
  }

  ///
  Widget _cajaBacia() {

    return Container(
      width: this._screen.width * 0.45,
      height: this._screen.height * 0.28,
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(
          color: Colors.grey
        ),
        gradient: LinearGradient(
          colors: [
            Colors.grey[300],
            Colors.grey,
            Colors.grey[300],
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.repeated
        )
      ),
    );
  }

  ///
  Widget _printPublicaciones() {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Wrap(
        runAlignment: WrapAlignment.start,
        alignment: WrapAlignment.spaceBetween,
        direction: Axis.horizontal,
        runSpacing: 10,
        children: _createListaUnidades()
      ),
    );
  }

  ///
  List<Widget> _createListaUnidades() {

    return this._unidades.map((unidad) {
      return PublicacionWidget(
        contextSend: this._context,
        dataPublic: unidad,
        tamWid: 0.46,
      );
    }).toList();
  }

  ///
  Future<bool> _getUnidades() async {

    assert((){
      print(this._totPags);
      print(this._totResl);
      return true;
    }());
    
    await _getCategosFromLocal();
    
    switch (widget.currentSeccion) {
      case 1:
        return await _getRefacciones();
        break;
      case 2:
        return await _getAutos();
        break;
      case 3:
        return await _getServicios();
        break;
      default:
        return false;
    }
  }

  ///
  Future<void> _getCategosFromLocal() async {

    if(this._categos.isEmpty){
      this._categos = await emPublic.getCategosLocal();
    }
  }

  ///
  Future<bool> _getRefacciones() async {

    await _getUnidadSeleccionada();
    return true;
  }

  ///
  Future<bool> _getServicios() async {

    await _getUnidadSeleccionada();
    return true;
  }

  ///
  Future<bool> _getAutos() async {

    await _getUnidadSeleccionada();
    return true;
  }

  ///
  Future<void> _getUnidadSeleccionada() async {

    if(this._pageFromServer != this._pagina){
      Map<String, dynamic> resultados = await emPublic.getUnidades(widget.currentSeccion, this._pagina);
      this._unidades = (resultados['results'].length > 0) ? new List<Map<String, dynamic>>.from(resultados['results']) : new List();
      this._totPags  = resultados['totPag'];
      this._totResl  = resultados['totResl'];
      this._pageFromServer = resultados['page'];
    }

  }
}