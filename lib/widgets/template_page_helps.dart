import 'package:flutter/material.dart';

class TemplatePageHelps {

  Widget getTemplate({
    BuildContext context,
    String titulo,
    String subTitulo,
    String body,
    IconData icono,
    bool isFin = false,
    Function accionEntendido,
    Function accionSiguinete
    }) {

    double tamCirculIcon = MediaQuery.of(context).size.width * 0.35;
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            Colors.red
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter
        ),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: tamCirculIcon,
            width: tamCirculIcon,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(tamCirculIcon),
              color: Colors.red[50]
            ),
            child: Center(
              child: Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(140),
                  color: Colors.red[200]
                ),
                child: Icon(icono, size: 90,),
              ),
            )
          ),
          Text(
            '$titulo',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.aspectRatio * 35
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '$subTitulo',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.grey[300],
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.aspectRatio * 27
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '$body',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.aspectRatio * 25
            ),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: accionEntendido,
                child: Text(
                  'ENTENDIDO',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.blue
                  ),
                ),
              ),
              (isFin)
              ?
              SizedBox(width: 0)
              :
              SizedBox(width: MediaQuery.of(context).size.aspectRatio * 40),
              (isFin)
              ?
              SizedBox(width: 0)
              :
              FlatButton(
                onPressed: accionSiguinete,
                child: Row(
                  children: <Widget>[
                    Text(
                      'SABER MÁS',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.yellow
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.yellow, size: 17)
                  ],
                )
              )
            ],
          )
        ],
      )
    );
  }
}