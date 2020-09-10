import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:zonamotora/singletons/solicitud_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/dialog_ver_fotos.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/globals.dart' as globals;

class LstPiezasPage extends StatefulWidget {

  @override
  _LstPiezasPageState createState() => _LstPiezasPageState();
}

class _LstPiezasPageState extends State<LstPiezasPage> {

  AlertsVarios alertsVarios = AlertsVarios();
  MenuInferior menuInferior = MenuInferior();
  SolicitudSngt solicitudSgtn = SolicitudSngt();

  Size _screen;
  bool _isInit = false;
  BuildContext _context;
  List<Widget> _fichas = new List();
  GlobalKey<ScaffoldState> _skfKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    if(!this._isInit){
      this._isInit = true;
      this._context = context;
      this._screen = MediaQuery.of(context).size;
      context = null;
    }

    String titulo = solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['md_nombre'];
    return Scaffold(
      key: this._skfKey,
      appBar: AppBar(
        backgroundColor: Color(0xff7C0000),
        title: Text(
          'Piezas para $titulo',
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 16
          ),
        ),
        elevation: 5,
      ),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: _body(),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  Widget _body() {

    _crearListaDePiezas();

    return Container(
      width: this._screen.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red,
            Colors.black,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        )
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          _cabecera(),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: this._fichas
            ),
          )
        ],
      )
    );
  }

  ///
  Widget _cabecera() {

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: (solicitudSgtn.onlyRead) ? MainAxisAlignment.center : MainAxisAlignment.spaceAround,
          children: <Widget>[
            (solicitudSgtn.onlyRead) ? const SizedBox(width: 0) : _btnAddMasPiezas(),
            _btnTerminar(titulo: (solicitudSgtn.onlyRead) ? 'Regresar Lista de cotizaciones' : 'Terminar')
          ],
        ),
      ],
    );
  }

  ///
  Widget _btnAddMasPiezas() {

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      onPressed: (){
        solicitudSgtn.setAutoEnJuegoIndexPieza(null);
        solicitudSgtn.setAutoEnJuegoIdPieza(null);
        Navigator.of(this._context).pushReplacementNamed('alta_piezas_page');
      },
      icon: Icon(Icons.add_circle, color: Colors.blue),
      color: Colors.black87,
      textColor: Colors.white,
      label: Text(
        'Agregar más',
        textScaleFactor: 1,
      ),
    );
  }

  ///
  Widget _btnTerminar({String titulo}) {

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      onPressed: (){
        solicitudSgtn.setAutoEnJuegoIndexPieza(null);
        solicitudSgtn.setAutoEnJuegoIdPieza(null);
        solicitudSgtn.setAutoEnJuegoIndexAuto(null);
        Navigator.of(this._context).pushReplacementNamed('lst_modelos_select_page');
      },
      color: Colors.white,
      icon: Icon(Icons.check_circle, color: Colors.red),
      label: Text(
        titulo,
        textScaleFactor: 1,
      ),
    );
  }
  
  ///
  void _crearListaDePiezas() {

    this._fichas = new List();
    List<Map<String, dynamic>> piezas = new List();
    if(solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']].containsKey('piezas')){
      piezas = new List<Map<String, dynamic>>.from(solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas']);
    }

    if(piezas.length > 0) {  

      // Comenzamos con la lista
      piezas.forEach((pieza){

        this._fichas.add(
          Dismissible(
            key: Key(pieza['id'].toString()),
            background: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.red[100],
                      child: Icon(Icons.delete),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'BORRAR',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ],
                )
              ],
            ),
            secondaryBackground: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.red[100],
                      child: Icon(Icons.edit),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'EDITAR',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 15),
              ],
            ),
            child: _ficha(pieza),
            confirmDismiss: (DismissDirection direccion) async {
              if(direccion.index == 3){
                return await _eliminarPieza(pieza['id']);
              }else{
                await _editarPieza(pieza['id']);
                return true;
              }
            },
          )
        );

      });

    }else{

      this._fichas.add(const SizedBox(height: 0));
    }

  }

  ///
  Widget _ficha(Map<String, dynamic> pieza) {

    if(!pieza.containsKey('fotos')){
      pieza.putIfAbsent('fotos', () => new List());
    }

    return Container(
      padding: EdgeInsets.only(top: 10, right: 10, bottom: 0, left: 10),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withAlpha(0),
            Colors.white.withAlpha(50)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 2
          )
        )
      ),
      width: this._screen.width,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              (pieza['fotos'].length == 0) 
              ?
              CircleAvatar(
                radius: 29,
                child: Icon(Icons.monochrome_photos, size: 35, color: Colors.red[200]),
              )
              :
              Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  (!solicitudSgtn.onlyRead) ? printImgLocal(pieza) : printImgFromServer(pieza),
                  Positioned(
                    top: -5,
                    left: -5,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 10,
                      child: Text(
                        '${ pieza['fotos'].length }',
                        textScaleFactor: 1,
                        style: TextStyle(
                          color: Colors.black87
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${ pieza['cant'] } ${ pieza['nombre'].toString().toUpperCase() }',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: this._screen.width,
                      child: Text(
                        (pieza['detalles'] != '0') ? '${ pieza['detalles'] }' : 'Sin Detalles...',
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 13
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.black, height: 1),
          Divider(color: Colors.red[200], height: 1),
          (solicitudSgtn.onlyRead) ? _accionesOnlyRead(pieza) :_accionesNormales(pieza)
        ],
      ),
    );
  }


  Widget printImgLocal(pieza) {

    return InkWell(
      child: CircleAvatar(
        radius: 26,
        backgroundImage: AssetThumbImageProvider(
          Asset(pieza['fotos'][0]['identifier'], pieza['fotos'][0]['nombre'], pieza['fotos'][0]['width'], pieza['fotos'][0]['height']),
          width: pieza['fotos'][0]['width'],
          height: pieza['fotos'][0]['height']
        ),
      ),
      onTap: (){
        showDialog(
          context: this._context,
          builder: (BuildContext context) {
            return DialogVerFotosWidget(fotos: pieza['fotos'], typeFoto: 'solicitudes');
          }
        );
      },
    );
  }

  ///
  Widget printImgFromServer(pieza) {

    List<Map<String, dynamic>> fotosObject = new List();

    pieza['fotos'].forEach((element) {
      fotosObject.add({'nombre':element});
    });
    
    return InkWell(
      child: CircleAvatar(
        radius: 26,
        backgroundImage: NetworkImage('${globals.uriImgSolicitudes}/${pieza['fotos'][0]}'),
      ),
      onTap: (){

        showDialog(
          context: this._context,
          builder: (BuildContext context) {
            return DialogVerFotosWidget(fotos: fotosObject, typeFoto: 'solicitudes');
          }
        );
      },
    );
  }

  ///
  Widget _accionesOnlyRead(Map<String, dynamic> pieza) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _btnVerCotizaciones(),
        _btnVerDataPieza(pieza)
      ],
    );
  }

  ///
  Widget _accionesNormales(Map<String, dynamic> pieza) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton.icon(
          textColor: Colors.grey[300],
          padding: EdgeInsets.all(0),
          icon: Icon(Icons.delete, color: Colors.amber[100]),
          label: Text(
            'Borrar',
            textScaleFactor: 1,
          ),
          onPressed: () => _eliminarPieza(pieza['id']),
        ),
        FlatButton.icon(
          textColor: Colors.grey[300],
          padding: EdgeInsets.all(0),
          icon: Icon(Icons.edit, color: Colors.lightBlue),
          label: Text(
            'Cambiar',
            textScaleFactor: 1,
          ),
          onPressed: () => _editarPieza(pieza['id']),
        ),
        _btnVerDataPieza(pieza)
      ],
    );
  }
  
  ///
  Widget _btnVerDataPieza(Map<String, dynamic> pieza) {

    return FlatButton.icon(
      textColor: Colors.grey[300],
      padding: EdgeInsets.all(0),
      icon: Icon(Icons.remove_red_eye, color: Colors.lightBlue),
      label: Text(
        'VER',
        textScaleFactor: 1,
      ),
      onPressed: () {
        this._skfKey.currentState.showBottomSheet(
          (BuildContext context) => _verDatosPieza(pieza),
          elevation: 5
        );
      }
    );
  }

  ///
  Widget _verDatosPieza(Map<String, dynamic> pieza) {

    return Container(
      padding: EdgeInsets.all(7),
      width: this._screen.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: this._screen.width,
            child: Stack(
              children: <Widget>[
                (pieza['fotos'].length > 0) ? _verFoto(List<Map<String, dynamic>>.from(pieza['fotos'])) : _sinFoto(),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: CircleAvatar(
                      child: InkWell(
                        child: Icon(Icons.close),
                        onTap: () => Navigator.of(this._context).pop(false),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: (this._screen.height * 0.23) - 25,
                  right: 10,
                  child: Text(
                    ' ID: ${ pieza['id'] } ',
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      backgroundColor: Colors.black
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          _machoteInfoPieza(
            '${ pieza['cant'] } .- ${ pieza['nombre'].toString().toUpperCase() }',
            size: 18, negrita: true
          ),
          Divider(height: 2, color: Colors.grey[400]),
          _machoteInfo('Nombre de la Pieza'),
          const SizedBox(height: 10),
          _machoteInfoPieza(
            '${ pieza['lado'] } - ${ pieza['posicion'] }',
            size: 15
          ),
          Divider(height: 2, color: Colors.grey[400]),
          _machoteInfo('Lado y Posición'),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${ pieza['detalles'] }',
              textScaleFactor: 1,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16
              ),
            ),
          ),
          Divider(height: 2, color: Colors.grey[400]),
          _machoteInfo('Detalles o Características'),
          const SizedBox(height: 10),
          
          (solicitudSgtn.onlyRead) ?
          Center(
            widthFactor: this._screen.width,
            child: _btnVerCotizaciones(),
          )
          : _accionesVerDetallesNormales(pieza),
          const SizedBox(height: 10),
        ]
      )
    );
  }

  ///
  Widget _accionesVerDetallesNormales(Map<String, dynamic> pieza) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton.icon(
          color: Colors.red,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          icon: const Icon(Icons.delete),
          label: const Text(
            'Borrar Pieza',
            textScaleFactor: 1,
          ),
          onPressed: (){
            Navigator.of(this._context).pop(false);
            _eliminarPieza(pieza['id']);
          },
        ),
        FlatButton.icon(
          color: Colors.blue,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          icon: const Icon(Icons.edit),
          label: const Text(
            'Cambiar Datos',
            textScaleFactor: 1,
          ),
          onPressed: (){
            Navigator.of(this._context).pop(false);
            _editarPieza(pieza['id']);
          },
        )
      ],
    );
  }
  
  ///
  Widget _btnVerCotizaciones() {

    return FlatButton.icon(
      color: Colors.black,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      icon: const Icon(Icons.format_list_numbered, color: Colors.blue),
      label: const Text(
        'Revisar Cotizaciones',
        textScaleFactor: 1,
      ),
      onPressed: (){},
    );
  }

  ///
  Widget _machoteInfoPieza(String titulo, {double size, bool negrita = false}) {

    return SizedBox(
      width: this._screen.width,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          titulo,
          textScaleFactor: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: (negrita) ? FontWeight.bold : FontWeight.normal,
            fontSize: size
          ),
        ),
      ),
    );
  }

  ///
  Widget _machoteInfo(String titulo) {

    return Text(
      titulo,
      textScaleFactor: 1,
      style: TextStyle(
        color: Colors.green,
        fontSize: 14
      ),
    );
  }

  ///
  Widget _verFoto(List<Map<String, dynamic>> fotos) {

    return SizedBox(
      width: this._screen.width,
      height: this._screen.height * 0.23,
      child: InkWell(
        child: Image(
          image: AssetThumbImageProvider(
            Asset(fotos[0]['identifier'], fotos[0]['nombre'], fotos[0]['width'], fotos[0]['height']),
            width: fotos[0]['width'],
            height: fotos[0]['height']
          ),
        ),
        onTap: (){
          showDialog(
            context: this._context,
            builder: (BuildContext context) {
              return DialogVerFotosWidget(fotos: fotos, typeFoto: 'solicitudes');
            }
          );
        },
      ),
    );
  }

  ///
  Widget _sinFoto() {

    return SizedBox(
      width: this._screen.width,
      height: this._screen.height * 0.23,
      child: Image(
        image: AssetImage('assets/images/refacs_sin_foto.jpg'),
        fit: BoxFit.cover,
      ),
    );
  }

  ///
  Future<bool> _eliminarPieza(int idPieza) async {

    String body = '¿Estás Segur@ de quitar de tu lista la refacción seleccionada?';
    bool res = await alertsVarios.aceptarCancelar(this._context, titulo: 'BORRAR PIEZA', body: body);

    if(res){
      int indexPieza = solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'].indexWhere((pieza) => pieza['id'] == idPieza);
      if(indexPieza > -1) {
        solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'].removeAt(indexPieza);

        if(solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'].length == 0) {
          _redireccionarAltaPieza();
          solicitudSgtn.setAutoEnJuegoIdPieza(null);
          solicitudSgtn.setAutoEnJuegoIndexPieza(null);
          return false;
        }
        setState((){});
      }else{
        res = false;
      }
    }

    return res;
  }

  ///
  Future<void> _editarPieza(int idPieza) async {

    solicitudSgtn.setAutoEnJuegoIdPieza(idPieza);
    int indexPieza = solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'].indexWhere((pieza) => pieza['id'] == idPieza);
    solicitudSgtn.setAutoEnJuegoIndexPieza(indexPieza);
    _redireccionarAltaPieza();
  }

  ///
  void _redireccionarAltaPieza() {

    Navigator.of(this._context).pushReplacementNamed('alta_piezas_page');
  }

}