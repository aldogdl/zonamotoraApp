import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/banners_top.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';

class RegistroProfGraxPage extends StatefulWidget {
  @override
  _RegistroProfGraxPageState createState() => _RegistroProfGraxPageState();
}

class _RegistroProfGraxPageState extends State<RegistroProfGraxPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  BuildContext _context;

  Size _screen;

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;

    return Scaffold(
      appBar: appBarrMy.getAppBarr(titulo: 'GRACIAS'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: Column(
        children: <Widget>[
          _containerBanner(),
          _txtAgradecimiento()
        ],
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  /* */
  Widget _containerBanner() {

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          width: this._screen.width,
          height: this._screen.height * 0.28,
          decoration: BoxDecoration(
            color: Color(0xff7C0000)
          ),
          child: SizedBox(height: 30),
        ),
         // Banners
        Positioned(
          top: 0,
          child:  BannersTop()
        ),
      ],
    );
  }

  /* */
  Widget _txtAgradecimiento() {

    return SingleChildScrollView(
      child: Container(
        width: this._screen.width,
        height: this._screen.height * 0.462,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'GRACIAS POR',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'REGISTRARTE',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 25,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Espera nuestra llamada, un asesor te otorgará toda la información que necesitas para saber como '+
                'aprovechar al máximo todo lo que tenemos para tu negocio',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      '¿Sabias que con ZonaMotora, puedes encotrar Refacciones, Accesorios y Autopartes Genericas y Seminuevas '+
                      'al mejor costo?',
                      textScaleFactor: 1,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              FlatButton.icon(
                icon: Icon(Icons.search),
                label: Text(
                  'Buscar Refacciones',
                  style: TextStyle(
                    color: Colors.deepOrange
                  ),
                ),
                onPressed: (){

                },
              )
            ],
          ),
        )
      ),
    );
  }

}