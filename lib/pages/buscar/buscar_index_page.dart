import 'package:flutter/material.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/banners_top.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';

class BuscarIndexPage extends StatefulWidget {
  @override
  _BuscarIndexPageState createState() => _BuscarIndexPageState();
}

class _BuscarIndexPageState extends State<BuscarIndexPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  Size _screen;

  BuildContext _context;

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;

    return Scaffold(
      appBar: appBarrMy.getAppBarr(),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: Column(
        children: <Widget>[
          _body(),
          const SizedBox(height: 20),
          Text(
            '¿Qué quieres BUSCAR?',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w300
            ),
          ),
          Divider(),
          _queBuscar()
        ],
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  /* */
  Widget _body() {

    return Stack(
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
  Widget _queBuscar() {

    return SingleChildScrollView(
      child: Container(
        height: this._screen.height * 0.40,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                'TODO PARA MI AUTO'
              ),
              subtitle: Text(
                'Filtra automaticamente para tu auto'
              ),
            ),
            ListTile(
              title: Text(
                'REFACCIONES'
              ),
              subtitle: Text(
                'Genericas y Seminuevas'
              ),
            ),
            ListTile(
              title: Text(
                'ACCESORIOS'
              ),
              subtitle: Text(
                'Filtra automaticamente para tu auto'
              ),
            ),
            ListTile(
              title: Text(
                'AUTOMÓVILES'
              ),
              subtitle: Text(
                'Filtra automaticamente para tu auto'
              ),
            ),
            ListTile(
              title: Text(
                'SERVICIOS'
              ),
              subtitle: Text(
                'Filtra automaticamente para tu auto'
              ),
            ),
          ],
        ),
      )
    );
  }
}