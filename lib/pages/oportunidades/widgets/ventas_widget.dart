import 'package:flutter/material.dart';

class VentasWidget extends StatefulWidget {
  @override
  _VentasWidgetState createState() => _VentasWidgetState();
}

class _VentasWidgetState extends State<VentasWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Text('VENTAS'),
    );
  }
}