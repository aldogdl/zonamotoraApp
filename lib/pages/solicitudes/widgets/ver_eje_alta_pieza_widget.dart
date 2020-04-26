import 'package:flutter/material.dart';

class VerEjemploAltaPiezaWidget extends StatelessWidget {

  const VerEjemploAltaPiezaWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      icon: Icon(Icons.help),
      color: Colors.red[200],
      label: Text(
        'Ayuda',
        textScaleFactor: 1,
        style: TextStyle(
          fontSize: 14
        ),
      ),
      onPressed: () => _alertHelp(context),
    );
  }

  ///
  void _alertHelp(BuildContext context) async {

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          titlePadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          title: Container(
            padding: EdgeInsets.all(0),
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)
                    ),
                    child: Image(
                      image: AssetImage('assets/images/refacciones.jpg'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'EJEMPLOS DE CAPTURA',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          BoxShadow(
                            blurRadius: 2,
                            offset: Offset(1, 2),
                            color: Colors.black
                          )
                        ]
                      ),
                    ),
                  )
                )
              ],
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(7),
                color: Colors.red[100],
                child: Text(
                  'Con el objetivo de organizar tu solicitud, te mostramos unos ejemplos de como los campos deben ser llenados.',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 17
                  ),
                ),
              ),
              Divider(),
              _ejemplos(context)
            ],
          ),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.close),
              label: Text(
                'CERRAR',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
            )
          ],
        );
      }
    );
  }

  ///
  Widget _ejemplos(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
            _machoteDeAyuda(
              numeroEjemplo: 1,
              pieza: 'CUARTO',
              posicion: 'Delantero - Derecho',
              instaladoEn: 'del Salpidaredo'
            ),
            Divider(),
            _machoteDeAyuda(
              numeroEjemplo: 2,
              pieza: 'CALAVERA',
              posicion: 'Trasera - Izquierda',
              instaladoEn: 'de Puerta Trasera'
            ),
            Divider(),
            _machoteDeAyuda(
              numeroEjemplo: 3,
              pieza: 'FARO DE NIEBLA',
              posicion: 'Delantero - Izquierdo',
              instaladoEn: 'de Defensa'
            ),
            Divider(),
            _machoteDeAyuda(
              numeroEjemplo: 4,
              pieza: 'COFRE',
              posicion: 'Delantero',
              instaladoEn: ''
            ),
            Divider(),
            _machoteDeAyuda(
              numeroEjemplo: 5,
              pieza: 'SALPICADERO',
              posicion: 'Delantero - Derecho',
              instaladoEn: ''
            ),
          ],
        ),
      ),
    );
  }

  ///
  Widget _machoteDeAyuda({
    @required numeroEjemplo,
    @required pieza,
    @required posicion,
    @required instaladoEn
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Ej. $numeroEjemplo',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 7),
        Text(
          '$pieza',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
        Text(
          '$posicion',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 15
          ),
        ),
        (instaladoEn.toString().isNotEmpty)
        ?
        Text(
          '$instaladoEn',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15
          ),
        )
        :
        const SizedBox(height: 0),
      ],
    );
  }

}