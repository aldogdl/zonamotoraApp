import 'package:flutter/material.dart';
import 'package:zonamotora/pages/oportunidades/widgets/lista_piezas_widget.dart';

import 'package:zonamotora/widgets/sin_piezas_widget.dart';
import 'package:zonamotora/pages/oportunidades/widgets/titulo_tab_widget.dart';
import 'package:zonamotora/repository/solicitud_repository.dart';

class InventarioWidget extends StatefulWidget {
  @override
  _InventarioWidgetState createState() => _InventarioWidgetState();
}

class _InventarioWidgetState extends State<InventarioWidget> {

  SolicitudRepository emSol = SolicitudRepository();
  
  List<Map<String, dynamic>> _inventario = new List();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TituloTabWidget(titulo: 'Lista de piezas Publicada para la VENTA'),
        FutureBuilder(
          future: _getPiezasEnInventario(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData) {
              if(this._inventario.length == 0) {
                return SinPiezasWidget(
                  txt1: 'Por el momento no se encontraron refacciones publicadas',
                  txt2: 'Te recomendamos que comiences a VENDER tus refacciones en linea.',
                );
              } else {
                return ListaPiezasWidget(items: this._inventario);
              }
            }
            return Padding(
              padding: EdgeInsets.all(100),
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  ///
  Future<bool> _getPiezasEnInventario() async {

    bool retorno = false;
    if(this._inventario.length == 0) {
      bool resul = await emSol.getPiezasBySocioAndStatus('publica');
      if(resul){
        this._inventario = new List<Map<String, dynamic>>.from(emSol.result['body']);
        retorno = true;
      }
    }
    return retorno;
  }
}