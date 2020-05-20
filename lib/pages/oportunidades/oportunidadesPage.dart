import 'package:flutter/material.dart';
import 'package:zonamotora/pages/oportunidades/widgets/cotizaciones_widget.dart';
import 'package:zonamotora/pages/oportunidades/widgets/ventas_widget.dart';
import 'package:zonamotora/pages/oportunidades/widgets/solicitudes_widget.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';

class OportunidadesPage extends StatefulWidget {
  @override
  _OportunidadesPageState createState() => _OportunidadesPageState();
}

class _OportunidadesPageState extends State<OportunidadesPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  BuildContext _context;
  List<Tab> _tabsBar;
  int _cantOps = 0;
  int _cantMisCots = 0;
  int _cantPedidos = 0;

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._tabsBar = _getTabs();

    return DefaultTabController(
      length: this._tabsBar.length,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Oportunidades',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 16
            ),
          ),
          bottom: TabBar(tabs: this._tabsBar),
        ),
        backgroundColor: Colors.red[100],
        drawer: MenuMain(),
        body: WillPopScope(
          onWillPop: () => Future.value(false),
          child: _body(),
        ),
        bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
      ),
    );
  }

  ///
  Widget _body() {

    return TabBarView(
      children: <Widget>[
        SolicitudesWidget(),
        CotizacionesWidget(),
        VentasWidget(),
      ],
    );
  }

  ///
  List<Tab> _getTabs() {
    
    double tamFontOp  = (this._cantOps >= 10) ? 11 : 13;
    double tamFontCot = (this._cantMisCots >= 10) ? 11 : 13;
    double tamFontPed = (this._cantPedidos >= 10) ? 11 : 13;

    return [
      Tab(
        icon: CircleAvatar(
          backgroundColor: Colors.red[100],
          maxRadius: 11,
          child: Text(
            '${this._cantMisCots}',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: tamFontOp,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        text: 'Solicitudes',
      ),
      Tab(
        icon: CircleAvatar(
          backgroundColor: Colors.red[100],
          maxRadius: 11,
          child: Text(
            '${this._cantMisCots}',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: tamFontCot,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        text: 'Cotizaciones',
      ),
      Tab(
        icon: CircleAvatar(
          backgroundColor: Colors.red[100],
          maxRadius: 11,
          child: Text(
            '${this._cantPedidos}',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: tamFontPed,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        text: 'Mis Ventas',
      ),
    ];
  }

}