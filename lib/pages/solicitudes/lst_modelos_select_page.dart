import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/pages/solicitudes/widgets/ficha_auto_widget.dart';
import 'package:zonamotora/repository/autos_repository.dart';
import 'package:zonamotora/singletons/solicitud_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';


class LstModelosSelectPage extends StatefulWidget {
  @override
  _LstModelosSelectPageState createState() => _LstModelosSelectPageState();
}

class _LstModelosSelectPageState extends State<LstModelosSelectPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AutosRepository emAutos = AutosRepository();
  SolicitudSngt solicitudSgtn = SolicitudSngt();
  AlertsVarios alertsVarios = AlertsVarios();

  Size _screen;
  BuildContext _context;
  List<Widget> _widgetLstAutos = new List();
  bool _isInit = false;
  
  GlobalKey<ScaffoldState> _skfKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;

    if(!this._isInit) {
      this._isInit = true;
      this._screen = MediaQuery.of(this._context).size;
      _createFichaDeAutos();
      appBarrMy.setContext(this._context);
      Provider.of<DataShared>(this._context, listen: false).setLastPageVisit('lst_modelos_page');
    }

    return Scaffold(
      key: this._skfKey,
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: CustomScrollView(
          slivers: <Widget>[
            appBarrMy.getAppBarrSliver(titulo: '${solicitudSgtn.autos.length.toString()} MODELOS SELECCIONADOS', bgContent: _cabecera()),
            SliverList(
              delegate: SliverChildListDelegate(this._widgetLstAutos),
            )
          ],
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  Widget _cabecera() {

    return SizedBox(
      width: this._screen.width,
      height: this._screen.height * 0.15,
      child: Image(
        image: AssetImage('assets/images/garage_autos.jpg'),
        fit: BoxFit.cover,
      ),
    );
  }

  ///
  void _createFichaDeAutos() {

    this._widgetLstAutos = new List();
    this._widgetLstAutos.add(_btnAtrasAndSave());

    if(solicitudSgtn.autos.length == 0) {
      this._widgetLstAutos.add(
        Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 120,
                width: 200,
                child: Image(
                  image: AssetImage('assets/images/auto.png'),
                  fit: BoxFit.cover
                )
              ),
              Text(
                'Sin autos seleccionados.',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
              )
            ],
          ),
        )
      );

      setState(() {});
      return;
    }

    for (var i = 0; i < solicitudSgtn.autos.length; i++) {
      Widget newW;
      if((i+1) >= solicitudSgtn.autos.length){
        newW = Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: new FichaDelAutoWidget(i, _borrarAuto),
        );
      }else{
        newW = new FichaDelAutoWidget(i, _borrarAuto);
      }
      this._widgetLstAutos.add(newW);
    }

    if(this._screen.height <= 550){
      if(solicitudSgtn.autos.length > 2) {
        this._widgetLstAutos.add(_btnAtrasAndSave());
      }
    }else{
      if(solicitudSgtn.autos.length > 3) {
        this._widgetLstAutos.add(_btnAtrasAndSave());
      }
    }
    this._widgetLstAutos.add(const SizedBox(height: 20));
    setState(() {});
  }

  ///
  Widget _btnAtrasAndSave() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton.icon(
          onPressed: () => Navigator.of(this._context).pushNamedAndRemoveUntil('lst_modelos_page', (Route rutas) => false),
          icon: Icon(Icons.arrow_back),
          label: Text(
            'Atras'
          )
        ),
        InkWell(
          child: Container(
            margin: EdgeInsets.only(right: 15),
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  offset: Offset(1, 1),
                  color: Colors.black
                )
              ]
            ),
            child: Text(
              'Terminar mi Pedido',
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                shadows: [
                  BoxShadow(
                    blurRadius: 0,
                    offset: Offset(1, 1),
                    color: Colors.black,
                  )
                ]
              ),
            ),
          ),
          onTap: () => _terminarSolicitud(),
        )
      ],
    );
  }
  
  ///
  Future<void> _borrarAuto(int indexAuto) async {

    String body = '¿Estás segur@ de querer eliminar el Vehículo de ésta lista de solicitud?';
    bool acc = await alertsVarios.aceptarCancelar(this._context, titulo: 'ELIMINAR AUTOMÓVIL', body: body);
    if(acc){
      solicitudSgtn.removeAuto(solicitudSgtn.autos[indexAuto]['md_id']);
      _createFichaDeAutos();
    }
  }

  ///
  Future<void> _terminarSolicitud() async {

    if(solicitudSgtn.autos.isEmpty) {
      String body = 'Es necesario para una SOLICITUD DE PIEZAS.\n\nQue selecciones al menos un MODELO de AUTO.';
      await alertsVarios.entendido(this._context, titulo: 'SELECCIÓN DE AUTOS', body: body);
    }else{
      List<Map<String, dynamic>> errores = await solicitudSgtn.revisarContenido();

      if(errores.isNotEmpty) {
        _alertErrores(errores);
      }else{
        Navigator.of(this._context).pushNamedAndRemoveUntil('fin_solicitud_page', (Route rutas) => false);
      }
    }
  }

  ///
  Future<void> _alertErrores(List<Map<String, dynamic>> errores) async {

    await showDialog(
      context: this._context,
      barrierDismissible: false,
      builder: (_) {

        return AlertDialog(
          backgroundColor: Colors.red[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )
          ),
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.all(5),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: this._screen.width,
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                margin: EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                  )
                ),
                child: Text(
                  'ERRORES de CAPTURA',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(
                height: 150,
                width: 150,
                child: Image(
                  image: AssetImage('assets/images/important-event.png'),
                  fit: BoxFit.cover
                ),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.close),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              label: Text(
                'ENTENDIDO',
                textScaleFactor: 1,
              ),
              onPressed: () => Navigator.of(this._context).pop(false)
            )
          ],
          content: Container(
            width: this._screen.width,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.red[100]
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: _crearListaDeErroresForDialog(errores),
              ),
            ),
          ),
        );
      }
    );
  }

  ///
  List<Widget> _crearListaDeErroresForDialog(List<Map<String, dynamic>> errores) {

    List<Widget> errs = new List();
    
    errores.forEach((err){
      errs.add(
        Text(
          '${err['titulo']}',
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange
          ),
        )
      );
      errs.add(
        Text(
          '${err['stitulo']}',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.red
          ),
        )
      );
      errs.add(Divider());
    });

    return errs;
  }

}