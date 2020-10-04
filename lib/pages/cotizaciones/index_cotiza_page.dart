import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zonamotora/pages/cotizaciones/widgets/carrito_widget.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/pages/cotizaciones/widgets/cotizaciones_widget.dart';
import 'package:zonamotora/pages/cotizaciones/widgets/solicitudes_widget.dart';
import 'package:zonamotora/repository/autos_repository.dart';
import 'package:zonamotora/repository/solicitud_repository.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/buscar_autos_sngt.dart';
import 'package:zonamotora/singletons/config_gms_sngt.dart';
import 'package:zonamotora/singletons/solicitud_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';


class IndexCotizaPage extends StatefulWidget {
  @override
  _IndexCotizaPageState createState() => _IndexCotizaPageState();
}

class _IndexCotizaPageState extends State<IndexCotizaPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AutosRepository emAutos = AutosRepository();
  SolicitudSngt solicitudSgtn = SolicitudSngt();
  BuscarAutosSngt buscarAutosSngt = BuscarAutosSngt();
  AlertsVarios alertsVarios = AlertsVarios();
  UserRepository emUser = UserRepository();
  SolicitudRepository emSolicitud = SolicitudRepository();
  ConfigGMSSngt configGMSSngt = ConfigGMSSngt();
  
  BuildContext _context;
  List<Tab> _tabsBar;
  bool _isInit = false;
  Map<String, dynamic> params = new Map();


  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._tabsBar = _getTabs();

    if(!this._isInit){
      this._isInit = true;
      configGMSSngt.setContext(this._context);
    }

    return _body();
  }

  ///
  Widget _body() {

    return DefaultTabController(
      length: this._tabsBar.length,
      initialIndex: Provider.of<DataShared>(this._context, listen: false).cotizacPageView,
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          backgroundColor: Color(0xff002f51),
          title: Text(
            'SOLICITUDES...',
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
          child: TabBarView(
            children: <Widget>[
              SolicitudesWidget(context: this._context),
              CotizacionesWidget(context: this._context),
              CarritoWidget(context: this._context),
            ],
          ),
        ),
        bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
      ),
    );
  }

  ///
  List<Tab> _getTabs() {
    
    double tamFont  = 11;

    return [
      Tab(
        icon: CircleAvatar(
          backgroundColor: Colors.red[100],
          maxRadius: 11,
          child: Consumer<DataShared>(
            builder: (_, dataShared, __){
              return Text(
                '${dataShared.cantSolicitudesPendientes}',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: tamFont,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        child: Text(
          'Pendientes',
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: tamFont
          ),
        ),
      ),
      Tab(
        icon: CircleAvatar(
          backgroundColor: Colors.red[100],
          maxRadius: 11,
          child: Consumer<DataShared>(
            builder: (_, dataShared, __){
              return Text(
                '${dataShared.cantCotiz}',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: tamFont,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        child: Text(
          'Cotizadas',
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: tamFont
          ),
        ),
      ),
      Tab(
        icon: CircleAvatar(
          backgroundColor: Colors.yellow,
          maxRadius: 11,
          child: Consumer<DataShared>(
            builder: (_, dataShared, __){

              return Text(
                '${dataShared.cantInCarrito}',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: tamFont,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          )
        ),
        child: Text(
          'En CARRITO',
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: tamFont
          ),
        ),
      ),
    ];
  }

}