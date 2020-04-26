import 'package:flutter/material.dart';
import 'package:zonamotora/singletons/solicitud_sngt.dart';


class FinalizarRegPiezasWidget extends StatelessWidget {

  final SolicitudSngt solicitudSngt = SolicitudSngt();

  @override
  Widget build(BuildContext context) {

    double alto = (MediaQuery.of(context).size.height <= 550) ?  0.65 : 0.723;

    return FutureBuilder(
      future: _finalizar(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasData && snapshot.data){
          Future.delayed(Duration(seconds: 1), (){
            Navigator.of(context).pushNamedAndRemoveUntil('lst_modelos_select_page', (Route rutas) => false);
          });

          return Container(
            height: MediaQuery.of(context).size.height * alto,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 5),
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
                SizedBox(
                  height: 2,
                  width: MediaQuery.of(context).size.width,
                  child: LinearProgressIndicator(),
                ),
                const SizedBox(height: 40),
                Container(
                  height: MediaQuery.of(context).size.width * 0.55,
                  width: MediaQuery.of(context).size.width * 0.55,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(100)
                  ),
                  child: Center(
                    child: Icon(Icons.cloud_done, size: 100, color: Colors.red[200]),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Registrando tus Piezas',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red[100],
                    fontSize: 28,
                    fontWeight: FontWeight.w300
                  ),
                ),
              ],
            )
          );
        }
        return SizedBox(height: 0);
      },
    );
  }

  ///
  Future<bool> _finalizar() async {
    solicitudSngt.paginaVista = 0;
    solicitudSngt.idAutoForEdit = null;
    // Revisar pedido
    return true;
  }
}