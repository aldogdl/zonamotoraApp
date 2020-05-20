import 'package:flutter/material.dart';

class CotizacionesWidget extends StatefulWidget {
  @override
  _CotizacionesWidgetState createState() => _CotizacionesWidgetState();
}

class _CotizacionesWidgetState extends State<CotizacionesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Text('Cotizaciones'),
    );
  }
}