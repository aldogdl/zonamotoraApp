import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/pages/oportunidades/widgets/apartados_widget.dart';
import 'package:zonamotora/pages/oportunidades/widgets/acotizar_widget.dart';
import 'package:zonamotora/pages/oportunidades/widgets/inventario_widget.dart';
import 'package:zonamotora/singletons/config_gms_sngt.dart';
import 'package:zonamotora/singletons/cotizacion_sngt.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';

class OportunidadesPage extends StatefulWidget {
  @override
  _OportunidadesPageState createState() => _OportunidadesPageState();
}

class _OportunidadesPageState extends State<OportunidadesPage> {

  MenuInferior menuInferior = MenuInferior();
  CotizacionSngt sngtCot = CotizacionSngt();
  ConfigGMSSngt configGMSSngt = ConfigGMSSngt();
  
  BuildContext _context;
  List<Tab> _tabsBar;
  bool _isInit = false;

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._tabsBar = _getTabs();

    if(!this._isInit){
      this._isInit = true;
      sngtCot.hasDataPedidos = false;
      sngtCot.hasDataPieza = true;
      configGMSSngt.setContext(this._context);
    }

    return DefaultTabController(
      length: this._tabsBar.length,
      initialIndex: Provider.of<DataShared>(this._context).opsVtasPageView,
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          backgroundColor: Color(0xff7C0000),
          title: Text(
            'Oportunidades de Venta',
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
        ACotizarWidget(),
        ApartadosWidget(),
        InventarioWidget(),
      ],
    );
  }

  ///
  List<Tab> _getTabs() {

    return [
      Tab(
        icon: CircleAvatar(
          backgroundColor: Colors.red[100],
          maxRadius: 11,
          child: Consumer<DataShared>(
            builder: (BuildContext _context, dataShared, __){
              return Text(
                '${dataShared.opVtasAcotizar}',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: (dataShared.opVtasAcotizar > 10 ? 11 : 13),
                  fontWeight: FontWeight.bold
                ),
              );
            },
          ),
        ),
        child: Text(
          'A Cotizar',
          textScaleFactor: 1,
        ),
      ),
      Tab(
        icon: CircleAvatar(
          backgroundColor: Colors.red[100],
          maxRadius: 11,
          child: Consumer<DataShared>(
            builder: (BuildContext _context, dataShared, __){
              return Text(
                '${dataShared.opVtasApartadas}',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: (dataShared.opVtasApartadas > 10 ? 11 : 13),
                  fontWeight: FontWeight.bold
                ),
              );
            },
          ),
        ),
        child: Text(
          'Apartadas',
          textScaleFactor: 1,
        ),
      ),
      Tab(
        icon: CircleAvatar(
          backgroundColor: Colors.red[100],
          maxRadius: 11,
          child: Consumer<DataShared>(
            builder: (BuildContext _context, dataShared, __){
              return Text(
                '${dataShared.opVtasInventario}',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: (dataShared.opVtasInventario > 10 ? 11 : 13),
                  fontWeight: FontWeight.bold
                ),
              );
            },
          ),
        ),
        child: Text(
          'Inventario',
          textScaleFactor: 1,
        )
      ),
    ];
  }

}