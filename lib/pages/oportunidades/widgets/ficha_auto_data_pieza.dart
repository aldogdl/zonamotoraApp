import 'package:flutter/material.dart';

class FichaAutoDataPiezaWidget extends StatelessWidget {
  final String lado;
  final String posicion;
  final String pieza;
  final String descripcion;
  const FichaAutoDataPiezaWidget(
      {Key key, this.lado, this.posicion, this.pieza, this.descripcion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screen = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(7),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            child: Icon(Icons.extension),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: _screen.width * 0.70,
                child: Text(
                  '$pieza',
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: _screen.width * 0.70,
                child: Text(
                  '$lado - $posicion',
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.green[600],
                      fontWeight: FontWeight.normal,
                      fontSize: 14),
                ),
              ),
              SizedBox(
                width: _screen.width * 0.70,
                child: Text(
                  '$descripcion',
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                      fontSize: 13),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
