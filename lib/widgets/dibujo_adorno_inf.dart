import 'package:flutter/material.dart';

class DibujarAdornoInf extends CustomPainter {

  final topDraw;

  DibujarAdornoInf({this.topDraw});

  @override
  void paint(Canvas canvas, Size size) {

    double topDrawInt = (this.topDraw == null) ? 15.0 : this.topDraw;

    Path path = Path();
    double yy = size.height - topDrawInt;
    path.moveTo(0, yy);
    path.lineTo(size.width, yy);
    path.lineTo(size.width, yy + 40);
    path.close();

    Paint paint = Paint();
    paint.color = Colors.red;
    return canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}