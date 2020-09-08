import 'package:flutter/material.dart';

class MotivosWidget extends StatelessWidget {

  const MotivosWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange
            ),
            child: const Text(
              'MOTIVOS EXTRAORDINARIOS',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Colors.white
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: const Text(
              'Recuerda que nuestra PRIORIDAD es apoyarte por todos los medios a ' +
              'VENDER tus refacciones, tu trabajo y tu tiempo lo valoramos mucho, es por ello que:',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17
              ),
            ),
          ),
          const Text(
            'Tu Publicación aparte de ser enviada al Solicitante final, TAMBIÉN:',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold
            ),
          ),
          const Divider(),
          const Divider(),
          const Divider(),
          ListTile(
            leading: Icon(Icons.check_circle, size: 40, color: Colors.blue),
            title: const Text(
              'A tu Página Web',
              textScaleFactor: 1,
            ),
            subtitle: const Text(
              'Automáticamente se publicará en tu Web ZM',
              textScaleFactor: 1,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.check_circle, size: 40, color: Colors.blue),
            title: const Text(
              'Facebook',
              textScaleFactor: 1,
            ),
            subtitle: const Text(
              'Estará publicada en nuestra página FB',
              textScaleFactor: 1,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.check_circle, size: 40, color: Colors.blue),
            title: const Text(
              'App Zona Motora',
              textScaleFactor: 1,
            ),
            subtitle: const Text(
              'Se visualizará en la aplicación de ZM',
              textScaleFactor: 1,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.check_circle, size: 40, color: Colors.blue),
            title: const Text(
              'Tienda en Línea Zona Motora',
              textScaleFactor: 1,
            ),
            subtitle: const Text(
              'Los usuario de ZM, podrán verla a la venta en el portal',
              textScaleFactor: 1,
            ),
          )
        ],
      ),
    );
  }
}