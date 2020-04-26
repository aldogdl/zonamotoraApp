import 'package:flutter/material.dart';
import 'package:zonamotora/widgets/dibujo_adorno_inf.dart';

class BgAltasStack {

  BuildContext _context;
  double altoContainer;

  ///
  void setBuildContext(BuildContext context) {
    this._context = context;
    altoContainer = (MediaQuery.of(this._context).size.height < 400) ? 0.32 : 0.35;
    context = null;
  }

  ///
  Widget stackWidget({
    String titulo,
    String subtitulo,
    double altoMax,
    double altoMin,
    Widget widgetTraslapado_1,
    Widget widgetTraslapado_2  
  }) {
    altoMax = (altoMax == null) ? 0.35 : altoMax;
    altoMin = (altoMin == null) ? 0.28 : altoMin;
    double altoBG = (MediaQuery.of(this._context).size.height < 550) ? altoMax : altoMin;

    widgetTraslapado_2 = (widgetTraslapado_2 == null) ? SizedBox(height: 0) : widgetTraslapado_2;

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        // Background
        Container(
          height: MediaQuery.of(this._context).size.height * altoBG,
          width: MediaQuery.of(this._context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.red,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
          ),
          child: CustomPaint(
            painter: DibujarAdornoInf(topDraw: (altoMax > 0.15) ? null : 0.0),
          ),
        ),
        (titulo.length == 0)
        ?
        SizedBox(height: 0)
        :
        Positioned(
          top: 10,
          width: MediaQuery.of(this._context).size.width,
          child: Text(
            titulo,
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),
          ),
        ),
        Positioned(
          top: 35,
          width: MediaQuery.of(this._context).size.width,
          child: Text(
            subtitulo,
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 15
            ),
          ),
        ),
        widgetTraslapado_1,
        widgetTraslapado_2,
      ],
    );
  }
}