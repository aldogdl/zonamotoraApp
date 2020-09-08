import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/solicitud_repository.dart';
import 'package:zonamotora/singletons/cotizacion_sngt.dart';
import 'package:zonamotora/widgets/ficha_tecnica_pza_widget.dart';
import 'package:zonamotora/globals.dart' as globals;
import 'package:zonamotora/widgets/sin_piezas_widget.dart';

class CotizacionesWidget extends StatefulWidget {

  final BuildContext context;
  CotizacionesWidget({this.context});

  @override
  _CotizacionesWidgetState createState() => _CotizacionesWidgetState();
}

class _CotizacionesWidgetState extends State<CotizacionesWidget> {

  CotizacionSngt cotizacionSngt = CotizacionSngt();
  SolicitudRepository emSols = SolicitudRepository();

  BuildContext _context;
  bool _modalPiezasIsOpen = false;
  bool _isInit = true;
  List<Map<String, dynamic>> _lstRespuestas = new List();
  List<Map<String, dynamic>> _lstPiezas = new List();
  String _tituloScreen = '';

  @override
  void dispose() {    
    if(this._modalPiezasIsOpen){
      Navigator.of(this._context).pop(true);
    }
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataShared>(this._context, listen: false).setCantCotiz(0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    this._context = widget.context;
    context = null;

    if(this._isInit) {
      this._isInit = false;
      Provider.of<DataShared>(this._context, listen: false).setCotizacPageView(1);
    }

    return FutureBuilder(
      future: _getSolicitudes(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          if(this._lstRespuestas.length > 0) {
            
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: this._lstRespuestas.map((resp) => _tileDeAuto(resp)).toList(),
                ),
              ),
            );
          }else{
            String txt2 = 'Si haz realizado una solicitud, por favor, estate al pendiente, pronto recibirás respuesta.';
            return SinPiezasWidget(txt1: 'Sin Cotizaciones Resueltas', txt2: txt2);
          }
        }
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(),
              ),
              const SizedBox(height: 20),
              Text(
                'Recuperando...',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12
                ),
              )
            ],
          ),
        );
      },
    );
  }

  ///
  Widget _tileDeAuto(Map<String, dynamic> respuesta) {
    
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.directions_car),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: Colors.black,
            child: Text(
              '${respuesta['piezas']}',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Piezas',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600]
            ),
          )
        ],
      ),
      title: Text(
        '${respuesta['md_nombre']}'
      ),
      subtitle: Text(
        'Marca: ${respuesta['mk_nombre']}'
      ),
      onTap: () => _verPiezas(respuesta['md_nombre'], respuesta['metadata']),
    );
  }

  ///
  Future<void> _verPiezas(String titulo, List metadata) async {

    this._modalPiezasIsOpen = true;
    final sheet = showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        )
      ),
      context: this._context,
      elevation: 5,
      builder: (_context) => _containerModalSheet(titulo, metadata)
    );

    sheet.then((value){
      this._modalPiezasIsOpen = false;
    });
  }

  ///
  Widget _containerModalSheet(String titulo, List metadata) {

    return Container(
      width: MediaQuery.of(this._context).size.width,
      child: FutureBuilder(
        future: _getPiezasByAuto(titulo, metadata),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            if(this._lstPiezas.length > 0) {
              return _createLstPiezas(titulo);
            }
          }
          return _cargandoPiezas(titulo);
        },
      ),
    );
  }
  
  ///
  Widget _cargandoPiezas(String titulo) {

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 50,
            child: Icon(Icons.cloud_download, size: 50),
          ),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(this._context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red.withAlpha(100),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  'Buscando piezas para el Automóvil...',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: LinearProgressIndicator(),
                ),
                Text(
                  '$titulo',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
  
  ///
  Widget _createLstPiezas(String titulo) {

    List<Widget> lst = this._lstPiezas.map((pieza) => _tileDePiezas(pieza)).toList();

    lst.add(_tituloInferiorContainesPiezas(titulo));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: lst,
    );
  }

  ///
  Widget _tituloInferiorContainesPiezas(String titulo) {

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange[800],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
        )
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5),
              child: Text(
              'PIEZAS para $titulo',
              textScaleFactor: 1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  BoxShadow(
                    blurRadius: 1,
                    offset: Offset(1, 1),
                    color: Colors.black,
                  )
                ]
              ),
            ),
          ),
          _btnClose()
        ],
      ),
    );
  }

  ///
  Widget _tileDePiezas(Map<String, dynamic> pieza) {

    String detalles = pieza['sol_requerimientos'];
    if(detalles.length != null){
      detalles = (detalles.length > 21) ? detalles.substring(0, 21) + '...' : detalles;
    }else{
      detalles = '0';
    }
    if(detalles == '0') {
      detalles = 'Posición: ${pieza['re_posicion']}';
    }

    return ListTile(
      leading: (pieza['sol_fotos'] != '0')
      ?
      CircleAvatar(
        backgroundImage: NetworkImage('${globals.uriImgSolicitudes}/${pieza['sol_fotos']}'),
      )
      :
      CircleAvatar(
        child: Icon(Icons.camera, color: Colors.white),
      )
      ,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(100)
            ),
            child: Text(
              'VER',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'costos',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600]
            ),
          )
        ],
      ),
      title: Text(
        '${pieza['pza_palabra']} ${pieza['re_lado']}',
        textScaleFactor: 1,
      ),
      subtitle: Text(
        '$detalles',
        textScaleFactor: 1,
      ),
      onTap: () => _verCotizacione(pieza),
    );
  }

  ///
  void _verCotizacione(Map<String, dynamic> pieza) {

    showDialog(
      barrierDismissible: false,
      useSafeArea: true,
      context: this._context,
      builder: (BuildContext context) {

        return FutureBuilder(
          future: _getRespuestas(pieza['ra_id']),
          builder: (BuildContext context, AsyncSnapshot snapshot) {

            if(snapshot.hasData) {
              if(snapshot.data.length > 0){

                return AlertDialog(
                  scrollable: true,
                  title: null,
                  buttonPadding: EdgeInsets.all(0),
                  backgroundColor: Colors.black.withAlpha(50),
                  titlePadding: EdgeInsets.all(0),
                  insetPadding: EdgeInsets.all(2),
                  contentPadding: EdgeInsets.all(0),
                  actionsPadding: EdgeInsets.all(7),
                  actions: [

                    RaisedButton.icon(
                      icon: Icon(Icons.close),
                      label: Text(
                        'SEGUIR',
                        textScaleFactor: 1,
                      ),
                      onPressed: (){},
                    ),

                    Consumer<DataShared>(
                      builder: (_, dataShared, __){
                        return Center(
                          widthFactor: (dataShared.txtCarShopBtn == 'CERRAR') ? 2.1 : 2,
                          child: RaisedButton.icon(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            color: dataShared.colorCarShopBtn,
                            textColor: Colors.white,
                            icon: Icon(dataShared.icoCarShopBtn),
                            label: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '${Provider.of<DataShared>(this._context, listen: false).txtCarShopBtn}',
                                textScaleFactor: 1,
                              ),
                            ),
                            onPressed: () {
                              if(Provider.of<DataShared>(this._context, listen: false).txtCarShopBtn == 'CERRAR') {
                                Navigator.of(this._context).pop();
                              }else{
                                Provider.of<DataShared>(context, listen: false).setCotizacPageView(2);
                                Navigator.of(this._context).pushNamedAndRemoveUntil('index_cotizacion_page', (route) => false);
                              }
                            },
                          ),
                        );
                      }

                    )
                  ],
                  content: FichaTecnicaPzaWidget(respuestas: snapshot.data),
                );
              }else{
                return _alertDialogo(false, 'No se encontraron Cotizaciones');
              }
            }

            return _alertDialogo(true, 'Recuperando Respuestas');
          },
        );
      }
    );
  }

  ///
  Widget _alertDialogo(bool isLoad, String txt) {

    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          (isLoad)
          ?
          SizedBox(
            height: 20, width: 20,
            child: CircularProgressIndicator(),
          )
          :
          Icon(Icons.warning, size: 50, color: Colors.orange),
          const SizedBox(height: 10),
          Text(
            '$txt',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600]
            ),
          )
        ],
      ),
      actions: [
        (isLoad)
        ?
        SizedBox(height: 0)
        :
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          color: Colors.blue,
          textColor: Colors.white,
          child: Text(
            'ENTENDIDO'
          ),
          onPressed: () => Navigator.of(this._context).pop(false),
        )
      ],
    );
  }

  /// idRa es el ID de la tabla de Refacciones y Aplicaciones
  Future<List<Map<String, dynamic>>> _getRespuestas(idRa) async {

    List<Map<String, dynamic>> listaRespuesas = new List();
    bool result = await emSols.getRespuestas(idRa);
    if(result) {
      listaRespuesas = List<Map<String, dynamic>>.from(emSols.result['body']);
    }
    
    return listaRespuesas;
  }

  ///
  Widget _btnClose() {

    return InkWell(
      onTap: () => Navigator.of(this._context).pop(),
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              offset: Offset(1, 1),
              color: Colors.black
            )
          ],
          border: Border.all(
            color: Colors.blueGrey[100],
            width: 1
          )
        ),
        child: Icon(Icons.close, color: Colors.white),
      ),
    );
  }

  ///
  Future<bool> _getSolicitudes() async {  

    print(Provider.of<DataShared>(this._context, listen: false).cotizacPageView);

    if(Provider.of<DataShared>(this._context, listen: false).cotizacPageView == 1) {

      bool result = await emSols.getSolicitudesByidUser();
      print('entra');
      if(result){
        this._lstRespuestas = new List<Map<String, dynamic>>.from(emSols.result['body']);
        Provider.of<DataShared>(this._context, listen: false).setCantCotiz(this._lstRespuestas.length);
        return true;
      }else{
        this._lstRespuestas = new List();
        return false;
      }
    }

    return false;
  }

  /// 
  Future<bool> _getPiezasByAuto(String titulo, List metadata) async {

    if(this._tituloScreen == titulo && this._lstPiezas.length > 0){
      return true;
    }

    List<int> idsSolicitud = new List();
    if(metadata.length > 0){
      for (var i = 0; i < metadata.length; i++) {
        idsSolicitud.add(metadata[i]['idSol']);
      }
    }

    bool result = await emSols.getPiezasDeLaSolicitud(idsSolicitud);

    if(result){

      this._lstPiezas = new List<Map<String, dynamic>>.from(emSols.result['body']);
      if(this._lstPiezas.length > 0) {
        for (var i = 0; i < this._lstPiezas.length; i++) {
          for (var a = 0; a < metadata.length; a++) {
            if(metadata[a]['idSol'] == this._lstPiezas[i]['sol_id']){
              this._lstPiezas[i]['metadata'] = metadata[a];
              this._lstPiezas[i]['titulo'] = titulo;
            }
          }
        }
      }

      this._tituloScreen = titulo;
      metadata = null;
      return true;

    }else{
      return false;
    }
  }

}