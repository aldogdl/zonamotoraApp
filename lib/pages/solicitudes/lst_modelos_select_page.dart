import 'package:flutter/material.dart';

import 'package:zonamotora/pages/solicitudes/widgets/ficha_auto_widget.dart';
import 'package:zonamotora/repository/autos_repository.dart';
import 'package:zonamotora/singletons/solicitud_sngt.dart';
import 'package:zonamotora/singletons/buscar_autos_sngt.dart';
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
  BuscarAutosSngt buscarAutosSngt = BuscarAutosSngt();
  AlertsVarios alertsVarios = AlertsVarios();

  Size _screen;
  BuildContext _context;
  List<Widget> _widgetLstAutos = new List();
  bool _isInit = false;

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;

    if(!this._isInit) {
      this._isInit = true;
      _createFichaDeAutos();
      appBarrMy.setContext(this._context);
    }

    String titulo = (solicitudSgtn.onlyRead)
    ? '${solicitudSgtn.autos.length.toString()} Cotizaciones Solicitadas'
    : '[${solicitudSgtn.autos.length.toString()}] LISTA DE AUTOS';

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: CustomScrollView(
          slivers: <Widget>[
            appBarrMy.getAppBarrSliver(titulo: titulo, bgContent: _cabecera()),
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
    this._widgetLstAutos.add(
      (solicitudSgtn.onlyRead) ?_btnCreateNewSolicitud() : _btnSave()
    );

    if(solicitudSgtn.autos.length == 0) {
      this._widgetLstAutos.add(
        Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
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
          child: FichaDelAutoWidget(i, _borrarAuto)
        );
      }else{
        newW = FichaDelAutoWidget(i, _borrarAuto);
      }
      this._widgetLstAutos.add(newW);
    }

    this._widgetLstAutos.add(
      (solicitudSgtn.onlyRead) ?_btnCreateNewSolicitud() : _btnSave()
    );
    this._widgetLstAutos.add(const SizedBox(height: 20));
    setState(() {});
  }

  ///
  Widget _btnSave() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: _machoteBtnAccion(
            titulo: 'TERMINAR Y ENVIAR',
            icono: Icons.check_circle,
            icoColor: Colors.white,
            color: Color(0xff002f51),
            indicador: false,
            accion: () => _enviarSolicitud()
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 0, left: 20, right: 20, bottom: 20
          ),
          child: _machoteBtnAccion(
            titulo: 'AGREGAR OTRO AUTO',
            icono: Icons.directions_car,
            icoColor: Colors.white,
            color: Colors.red,
            indicador: false,
            accion: () {
              buscarAutosSngt.setIdMarca(null);
              buscarAutosSngt.setIdModelo(null);
              buscarAutosSngt.setNombreMarca(null);
              buscarAutosSngt.setNombreModelo(null);
              solicitudSgtn.addOtroAuto = true;
              Navigator.of(this._context).pushNamedAndRemoveUntil('add_autos_page', (Route rutas) => false);
            }
          ),
        ),
      ],
    );
  }

  ///
  Widget _btnCreateNewSolicitud() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        RaisedButton.icon(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          onPressed: () {
            solicitudSgtn.limpiarSingleton();
            Navigator.of(this._context).pushNamedAndRemoveUntil('add_autos_page', (Route route) => false);
          },
          icon: Icon(Icons.check_circle, color: Colors.blue),
          color: Colors.black,
          textColor: Colors.white,
          label: Text(
            'Solicitar otra cotización',
            textScaleFactor: 1,
          )
        ),
      ],
    );
  }

  ///
  Widget _machoteBtnAccion({
    String titulo,
    Color color,
    IconData icono,
    Color icoColor = Colors.white,
    Function accion,
    indicador = true
  }) {

    return InkWell(
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(this._context).size.width,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              offset: Offset(2, 2),
              color: Colors.black.withAlpha(30)
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            
            const SizedBox(width: 10),
            Text(
              titulo,
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            Icon(icono, color: icoColor),
            (indicador)
            ?
            CircleAvatar(
              radius: 15,
              child: Text(
                '1',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            )
            :
            const SizedBox(width: 0)
          ],
        ),
      ),
      onTap: () async => accion(),
    );
  }

  ///
  Future<void> _borrarAuto(int indexAuto) async {

    String body = '¿Estás segur@ de querer eliminar el Vehículo de ésta lista de solicitud?';
    if(solicitudSgtn.autos[indexAuto]['piezas'].length > 0) {
      body = 'ESTE AUTO CUENTA CON PIEZAS REGISTRADAS\n\n ¿Estás segur@ de querer eliminar el Vehículo de ésta lista de solicitud?';
    }
    
    bool acc = await alertsVarios.aceptarCancelar(this._context, titulo: 'ELIMINAR AUTOMÓVIL', body: body);
    if(acc){
      solicitudSgtn.removeAutoByIndex(indexAuto);
      if(solicitudSgtn.autos.length == 0){
        Navigator.of(this._context).pushNamedAndRemoveUntil('add_autos_page', (Route rutas) => false);
      }else{
        _createFichaDeAutos();
      }
    }
  }

  ///
  Future<void> _enviarSolicitud() async {

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