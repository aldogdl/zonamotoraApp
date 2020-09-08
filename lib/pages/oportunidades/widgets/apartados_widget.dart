import 'package:flutter/material.dart';
import 'package:zonamotora/pages/oportunidades/widgets/lista_piezas_widget.dart';
import 'package:zonamotora/widgets/sin_piezas_widget.dart';
import 'package:zonamotora/pages/oportunidades/widgets/titulo_tab_widget.dart';
import 'package:zonamotora/repository/solicitud_repository.dart';

class ApartadosWidget extends StatefulWidget {
  @override
  _ApartadosWidgetState createState() => _ApartadosWidgetState();
}

class _ApartadosWidgetState extends State<ApartadosWidget> {

  SolicitudRepository emSol = SolicitudRepository();
  
  List<Map<String, dynamic>> _apartadas = new List();
  
  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        TituloTabWidget(titulo: 'Piezas seleccionadas para su posible venta'),
        FutureBuilder(
          future: _getPiezasApartadas(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData) {
              if(this._apartadas.length == 0) {
                return SinPiezasWidget(
                  txt1: 'Si haz enviado una contización, estate al pendiente.',
                  txt2: 'Recuerda que si tu Pieza no ha sido seleccionada por el Solicitante, se publicará para su VENTA y tu podrás visualizarlas en la sección de Inventario.',
                );
              } else {
                return ListaPiezasWidget(items: this._apartadas);
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
        ),
      ],
    );
  }

  ///
  Future<bool> _getPiezasApartadas() async {

    bool retorno = false;
    if(this._apartadas.length == 0) {
      bool resul = await emSol.getPiezasBySocioAndStatus('apartada');
      if(resul){
        this._apartadas = new List<Map<String, dynamic>>.from(emSol.result['body']);
        retorno = true;
      }
    }
    return retorno;
  }
}