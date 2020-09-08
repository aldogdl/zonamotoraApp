import 'package:flutter/material.dart';
import 'package:zonamotora/pages/oportunidades/widgets/ficha_auto_img_cache.dart';

class FichaAutoPlaceholderWidget extends StatelessWidget {

  final Map<String, dynamic> pieza;
  const FichaAutoPlaceholderWidget({Key key, this.pieza}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size _screen = MediaQuery.of(context).size;
    double alto = _screen.height * 0.25;
    FichaAutoImgCacheWidget imgCacheWidget = FichaAutoImgCacheWidget(foto: '0');

    return Container(
      width: _screen.width * 0.9,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(blurRadius: 3, offset: Offset(1, 1), color: Colors.red),
      ], borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              width:_screen.width,
              height: alto,
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  imgCacheWidget,
                  Positioned(
                    top: alto - 53,
                    left: 10,
                    child: Text(
                      pieza['marca'],
                      textScaleFactor: 1,
                      style: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          shadows: [
                            BoxShadow(
                                blurRadius: 2,
                                offset: Offset(1, 2),
                                spreadRadius: 5,
                                color: Colors.black)
                          ]),
                    ),
                  ),
                  Positioned(
                    top: alto - 35,
                    child: Container(
                        height: 35,
                        width: _screen.width * 0.9,
                        padding: EdgeInsets.only(left: 10, right: 7),
                        color: Colors.red.withAlpha(200),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Text(
                                '${pieza['auto']}',
                                textScaleFactor: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'AÑO',
                                textScaleFactor: 1,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 17),
                              ),
                            )
                          ],
                        )),
                  )
                ],
              )),
          Container(
            padding: EdgeInsets.all(7),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: _screen.width * 0.70,
                      child: Text(
                        'Recuperando la información',
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
                        'Espera un momento por favor',
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
                        'Datos de la refacción con el ID: ${pieza['solicitud']}',
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
          ),
        ],
      ),
    );
  }
}
