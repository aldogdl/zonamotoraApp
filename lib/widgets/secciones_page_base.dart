import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/publicar_repository.dart';
import 'package:zonamotora/widgets/publicacion_widget.dart';

class SeccionesPageBase extends StatefulWidget {

  final int currentSeccion;
  final bool showResultados;
  final String setLastPage;
  final bool hasHeadAdicional;
  SeccionesPageBase({Key key, this.currentSeccion, this.showResultados, this.setLastPage, this.hasHeadAdicional}) : super(key: key);

  @override
  _SeccionesPageBaseState createState() => _SeccionesPageBaseState();
}

class _SeccionesPageBaseState extends State<SeccionesPageBase> {

  PublicarRepository emPublic = PublicarRepository();

  BuildContext _context;
  Size _screen;
  int _pagina = 1;
  int _pageFromServer = 0;
  List<Map<String, dynamic>> _categos = new List();
  List<Map<String, dynamic>> _unidades = new List();
 
  bool _isInit = false;
  bool _showMsgPublicarAqui = true;
  bool _showBtnPublicar = true;
  bool _fueAnalizadaLaPagina = false;

  String lastUri;
  String _username;
  String _role;
  List<String> secciones = ['Artículos', 'Autopartes', 'Vehículos', 'Servicios'];

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;

    if(!this._isInit){
      this._isInit = true;
      lastUri = Provider.of<DataShared>(this._context, listen: false).lastPageVisit;
      Provider.of<DataShared>(this._context, listen: false).setLastPageVisit(widget.setLastPage);
      this._username = Provider.of<DataShared>(this._context, listen: false).username;
      this._role = Provider.of<DataShared>(this._context, listen: false).role;
    }

    if(this._username == 'Anónimo') {
      this._showBtnPublicar = false;
      this._showMsgPublicarAqui = false;
    }else{

      if(!this._fueAnalizadaLaPagina){

        switch (this._role) {
          case 'ROLE_PART':
            this._showBtnPublicar = false;
            break;
          case 'ROLE_SOCIO':
            this._showBtnPublicar = ( widget.currentSeccion != 1) ? false : true;
            break;
          case 'ROLE_AUTOS':
            this._showBtnPublicar = ( widget.currentSeccion != 2) ? false : true;
            break;
          case 'ROLE_SERVS':
            this._showBtnPublicar = ( widget.currentSeccion != 3) ? false : true;
            break;  
          default:
            this._showBtnPublicar = false;
        }

        this._showMsgPublicarAqui = this._showBtnPublicar;
      }
    }

    return Container(
      width: this._screen.width,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView(
        addAutomaticKeepAlives: false,
        shrinkWrap: true,
        addRepaintBoundaries: false,
        padding: EdgeInsets.all(0),
        scrollDirection: Axis.vertical,
        children: [
          _buscador(),
          (this._showMsgPublicarAqui)
          ?
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                RotatedBox(
                  quarterTurns: 1,
                  child: Icon(Icons.subdirectory_arrow_left),
                ),
                Text(
                  'Aquí podrás PUBLICAR tus ${secciones[widget.currentSeccion]}',
                  textScaleFactor: 1,
                )
              ],
            ),
          )
          :
          const SizedBox(height: 0),
          (widget.showResultados)
          ?
          _resultados()
          :
          const SizedBox(height: 0),
          const SizedBox(height: 10),
        ],
      )
    );
  }

  ///
  Widget _btnPublicar() {

    if(!this._showBtnPublicar) {
      return const SizedBox(height: 0);
    }

    if(this._showMsgPublicarAqui) {
      Future.delayed(Duration(milliseconds: 5000), (){
        if(mounted){
          setState(() {
            this._fueAnalizadaLaPagina = true;
            this._showMsgPublicarAqui = false;
          });
        }
      });
    }

    return Padding(
      padding: EdgeInsets.only(right: 5),
      child: SizedBox(
        width: 70,
        height: 47,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
            side: BorderSide(
              color: Colors.grey[400]
            )
          ),
          padding: EdgeInsets.all(0),
          color: Colors.red,
          textColor: Colors.white,
          onPressed: (){
            Navigator.of(this._context).pushNamedAndRemoveUntil(
              'publicar_page', (route) => false,
              arguments: {'publicar': widget.currentSeccion}
            );
          },
          child: Text(
            'VENDER',
            textScaleFactor: 1,
          ),
        ),
      ),
    );
  }

  ///
  Widget _buscador() {

    double anchoBuscador = (this._showBtnPublicar) ? 0.75 : 0.935;
    if(this._username == 'Anónimo') {
      anchoBuscador = 0.935;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _btnPublicar(),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 3),
            padding: EdgeInsets.symmetric(horizontal: 3),
            width: this._screen.width * anchoBuscador,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                color: Colors.grey
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      
                      border: InputBorder.none,
                      hintText: ' ¿Qué Buscas?',
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(Icons.arrow_forward),
                    onPressed: (){},
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  ///
  Widget _resultados() {

    int alto = (this._username == 'Anónimo') ? 250 : 195;
    if(widget.hasHeadAdicional) {
      alto = alto + 50;
    }
    return Container(
      width: this._screen.width,
      height: this._screen.height - alto,
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
        runSpacing: 20,
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
      width: this._screen.width * 0.42,
      height: this._screen.height * 0.28,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue[100]
        ),
        gradient: LinearGradient(
          colors: [
            Colors.blue[100],
            Colors.white,
            Colors.blue[100],
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
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
        runSpacing: 20,
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
      this._pageFromServer = resultados['page'];
    }

  }


}