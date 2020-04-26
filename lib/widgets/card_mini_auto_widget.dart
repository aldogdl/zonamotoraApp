import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget printCard({
  int idAuto,
  @required markMod,
  int anio, DateTime fechReg,
  @required showAcc,
  Function(int) fncEliminar,
  Function fncEditar,
  Function fncVender,
}) {

  Intl.defaultLocale = 'es_MX';
  DateFormat f = DateFormat('d-MM-yyyy');

  String anioString = (anio == null) ? '----' : '$anio';
  String fecha;
  if(fechReg == null) {
    DateTime now = DateTime.now();
    fecha = 'Hoy es: ${f.format(now)}';
  }else{
    fecha = 'Registro: ${f.format(fechReg)}';
  }

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 7),
    padding: EdgeInsets.all(7),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10)
    ),
    child: Column(
      children: <Widget>[

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 30,
                width: 30,
                child: Image(
                  image: AssetImage('assets/images/auto.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$markMod',
                    textScaleFactor: 1,
                    softWrap: true,
                  ),
                  Divider(height: 2),
                  Text(
                    'Año: $anioString,  $fecha',
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        (showAcc)
        ?
        _acciones(idAuto, eliminar: fncEliminar)
        :
        const SizedBox(height: 0)
      ],
    )
  );
}

/* */
Widget _acciones(int idAuto, {Function eliminar}) {

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      FlatButton.icon(
        icon: Icon(Icons.close, size: 14, color: Colors.green),
        label: Text(
          'Eliminar',
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 13,
            color: Colors.red
          ),
        ),
        onPressed: () async => eliminar(idAuto),
      ),
      FlatButton.icon(
        icon: Icon(Icons.edit, size: 14, color: Colors.green),
        label: Text(
          'Editar',
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 13,
            color: Colors.blue
          ),
        ),
        onPressed: (){},
      ),
      FlatButton.icon(
        icon: Icon(Icons.shopping_basket, size: 14, color: Colors.green),
        label: Text(
          'Vender',
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 13,
            color: Colors.blueGrey
          ),
        ),
        onPressed: (){},
      )
    ],
  );
}