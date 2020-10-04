import 'package:flutter/material.dart';

class TituloTabWidget extends StatelessWidget {

  final String titulo;
  const TituloTabWidget({this.titulo, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(7),
      color: Colors.grey[300],
      child: Text(
        titulo,
        textScaleFactor: 1,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black
        ),
      ),
    );
  }
}