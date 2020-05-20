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

  ///
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

  ///
  Widget _queBuscar() {

    double alto = (this._screen.height <= 550) ? 0.33 : 0.40;
    List<Map<String, dynamic>> menu = [
      {
        'titulo' :'REFACCIONES',
        'stitulo':'Cotizador de Refacciones gratuito',
        'icono'  : Icons.extension,
        'color'  : Colors.red,
        'path'   : 'add_autos_page'
      },
      {
        'titulo' :'AUTOMÓVILES',
        'stitulo':'Compra, Vende y/o Cambia un auto',
        'icono'  : Icons.directions_car,
        'color'  : Colors.orange,
        'path'   : 'lst_modelos_page'
      },
      {
        'titulo' :'SERVICIOS AUTOMOTRICES',
        'stitulo':'Los servicios que tu auto necesita',
        'icono'  : Icons.build,
        'color'  : Colors.blue,
        'path'   : 'lst_modelos_page'
      },
    ];
    List<Widget> menuDraw = new List();
    menu.forEach((mn){
      menuDraw.add(titleMenu(mn));
    });

    return SingleChildScrollView(
      child: Container(
        height: this._screen.height * alto,
        child: ListView(
          children: menuDraw,
        ),
      )
    );
  }

  ///
  Widget titleMenu(Map<String, dynamic> mnu) {

    return ListTile(
      title: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: mnu['color'],
            maxRadius: 13,
            child: Icon(mnu['icono'], size: 15, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Text(
            '${ mnu['titulo'] }',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
      subtitle: Padding(
        padding: EdgeInsets.symmetric(vertical: 7),
          child: Text(
          '${ mnu['stitulo'] }',
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 13),
      onTap: () => Navigator.of(this._context).pushNamedAndRemoveUntil('${ mnu['path'] }', (Route rutas) => false),
    );
  }
}