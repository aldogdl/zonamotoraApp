import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/solicitud_repository.dart';
import 'package:zonamotora/singletons/cotizacion_sngt.dart';

import 'package:zonamotora/globals.dart' as globals;
import 'package:zonamotora/widgets/sin_piezas_widget.dart';

class SolicitudesWidget extends StatefulWidget {

  final BuildContext context;
  SolicitudesWidget({this.context});

  @override
  _SolicitudesWidgetState createState() => _SolicitudesWidgetState();
}

class _SolicitudesWidgetState extends State<SolicitudesWidget> {

  CotizacionSngt cotizacionSngt = CotizacionSngt();
  SolicitudRepository emSols = SolicitudRepository();

  BuildContext _context;
  bool _modalPiezasIsOpen = false;
  List<Map<String, dynamic>> _lstSolicitudes = new List();
  
  int _cantAtendidas = 0;
  bool _showMsgAtendidas = false;
  bool _isResuelto = false;

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
      Provider.of<DataShared>(this._context, listen: false).setCantSolicitudesPendientes(0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
          decoration: BoxDecoration(
            color: Colors.yellow,
          ),
          child: Text(
            'Pendientes de Revisar por parte de Zona Motora',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12
            ),
          ),
        ),
        (this._showMsgAtendidas)
        ?
        Container(
          padding: EdgeInsets.all(5),
          color: Colors.white.withAlpha(200),
          child: Text(
            (this._cantAtendidas > 1)
            ?
            'Se encontraron que ${this._cantAtendidas} solicitudes tuyas, ya estan '+
            'siendo atendidas '
            :
            'Se encontró que UNA solicitud tuya, ya está '+
            'siendo atendida '
            + 'por nuestros asesores.\nESPERA PRONTO UNA COTIZACIÓN.',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13
            ),
          ),
        )
        :
        const SizedBox(height: 0),
        FutureBuilder(
          future: _getSolicitudes(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              if(this._lstSolicitudes.length > 0) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: this._lstSolicitudes.map((pedido) => _bagDelPedido(pedido)).toList(),
                    ),
                  ),
                );
              }else{
                String txt2 = 'Realiza una solicitud de Refacciones hoy mismo, te sorprenderán los costos y el servicio.';
                return SinPiezasWidget(txt1: 'Sin Solicitudes Pendientes', txt2: txt2);
              }
            }

            return Center(
              heightFactor: 3,
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
        )
      ],
    );
  }

  ///
  Widget _bagDelPedido(final pedido) {

    List<Map<String, dynamic>> autos = new List<Map<String, dynamic>>.from(pedido['solicitud']['solicitud']);

    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(150)
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${pedido['pedido']}',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600]
                ),
              ),
              Text(
                '20-05-2020',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600]
                ),
              )
            ],
          ),
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: autos.map((solicitud) => _tileDelAuto(solicitud)).toList(),
          )
        ],
      ),
    );
  }

  ///
  Widget _tileDelAuto(final auto) {
    
    List<Map<String, dynamic>> piezas = new List<Map<String, dynamic>>.from(auto['piezas']);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${auto['mk_nombre']} ${auto['md_nombre']} - ${auto['anio']}',
            textScaleFactor: 1,
            textAlign: TextAlign.start,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: piezas.map((pieza) => _tileDePiezas(pieza)).toList(),
          )
        ],
      ),
    );
  }

  ///
  Widget _tileDePiezas(Map<String, dynamic> pieza) {

    String detalles = pieza['detalles'];
    if(detalles.length != null){
      detalles = (detalles.length > 21) ? detalles.substring(0, 21) + '...' : detalles;
    }else{
      detalles = '0';
    }
    if(detalles == '0') {
      detalles = 'Posición: ${pieza['posicion']}';
    }

    return ListTile(
      leading: (pieza['fotos'] != '0')
      ?
      CircleAvatar(
        backgroundImage: NetworkImage('${globals.uriImgSolicitudes}/${pieza['fotos'][0]}'),
      )
      :
      CircleAvatar(
        child: Icon(Icons.camera, color: Colors.white),
      ),
      title: Text(
        '${pieza['nombre']} ${pieza['lado']}',
        textScaleFactor: 1,
      ),
      subtitle: Text(
        '$detalles',
        textScaleFactor: 1,
      ),
      onTap: null,
    );
  }

  ///
  Future<bool> _getSolicitudes() async {

    if(this._isResuelto) { return true;}
    this._isResuelto = true;
    Provider.of<DataShared>(this._context, listen: false).setCotizacPageView(0);
    List<Map<String, dynamic>> result = await emSols.getCotizacionesFromDb();

    if(result.isNotEmpty){
      List<String> fileNamesSolicitudesInDb = new List<String>.from( result.map((e) => e['filename']).toList() );
      result = null;
      Map<String, dynamic> solicitudes = await emSols.getCotizacionesToFilesFromServer(fileNamesSolicitudesInDb);
      this._lstSolicitudes = new List<Map<String, dynamic>>.from(solicitudes['pendientes']);
      if(solicitudes['atendidas'].isNotEmpty){
        setState(() {
          this._cantAtendidas = solicitudes['atendidas'].length;
          this._showMsgAtendidas = true;
        });
        emSols.deleteSolicitudesAtendidasinDbLocal(solicitudes['atendidas']);
      }else{
        setState(() {
          this._cantAtendidas = 0;
          this._showMsgAtendidas = false;
        });
      }
      Provider.of<DataShared>(this._context, listen: false).setCantSolicitudesPendientes(this._lstSolicitudes.length);
      return true;
    }else{
      this._lstSolicitudes = new List();
      return false;
    }

  }

}