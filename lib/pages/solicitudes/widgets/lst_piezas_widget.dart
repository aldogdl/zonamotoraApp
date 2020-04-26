import 'package:flutter/material.dart';
import 'package:zonamotora/pages/solicitudes/widgets/ficha_refacciones_widget.dart';
import 'package:zonamotora/singletons/solicitud_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';

class LstPiezasWidget extends StatefulWidget {

  final Function afterDelete;
  LstPiezasWidget(this.afterDelete);

  @override
  _LstPiezasWidgetState createState() => _LstPiezasWidgetState();
}

class _LstPiezasWidgetState extends State<LstPiezasWidget> {

  AlertsVarios alertsVarios = AlertsVarios();
  MenuInferior menuInferior = MenuInferior();
  SolicitudSngt solicitudSgtn = SolicitudSngt();

  Size _screen;
  bool _isInit = false;
  BuildContext _context;
  double _scrollRecovery = 0.0;
  List<Widget> _fichas = new List();
  ScrollController _ctrlScroolLstRefaccs = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_recuperaProcesoRoto); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(!this._isInit){
      this._isInit = true;
      this._context = context;
      this._screen = MediaQuery.of(context).size;
      context = null;
      FocusScope.of(this._context).requestFocus(new FocusNode());
    }

    return _body();
  }

  ///
  Widget _body() {

    _crearListaDePiezas();
    
    double alto = (this._screen.height <= 550) ?  0.65 : 0.723;
    return Column(
      children: <Widget>[
        Container(
          height: this._screen.height * alto,
          width: this._screen.width,
          padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red,
                Colors.black,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: ListView(
            controller: this._ctrlScroolLstRefaccs,
            children: this._fichas
          )
        )
      ],
    );
  }

  ///
  void _crearListaDePiezas() {

    List<Map<String, dynamic>> piezas = new List();
    if(solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']].containsKey('piezas')){
      piezas = new List<Map<String, dynamic>>.from(solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas']);
    }

    this._fichas = new List();
    int indexPieza = 0;
    this._fichas.add(const SizedBox(height: 10));

    if(piezas.length > 0) {
      piezas.forEach((pieza){
        this._fichas.add(
          FichaRefaccionesWidget(
            indexPieza,
            pieza,
            _eliminarPieza,
            _editarPieza,
            _makeBackUpForTakeFoto
          )
        );
        indexPieza++;
      });
    }else{

      Widget sinPiezas = Center(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                minRadius: 100,
                child: Icon(Icons.extension, size: 120, color: Colors.red[200]),
              ),
              const SizedBox(height: 20),
              Text(
                'NO EXISTEN PIEZAS AÚN',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 25,
                  color: Colors.red[100]
                ),
              )
            ],
          ),
        ),
      );

      this._fichas.add(sinPiezas);
    }

  }

  ///
  Future<bool> _makeBackUpForTakeFoto(int indexPieza) async {

    return solicitudSgtn.makeBackupInBd(
      indexPieza: indexPieza,
      scroll: this._ctrlScroolLstRefaccs.offset
    );
  }

  ///
  Future<void> _recuperaProcesoRoto(_) async {

    Map<String, dynamic> metadata = solicitudSgtn.processRecovery;

    if(metadata.isNotEmpty){
      this._scrollRecovery = metadata['scroll'];
      if(this._scrollRecovery > 0) {
        Future.delayed(Duration(seconds: 1), (){
          this._ctrlScroolLstRefaccs.animateTo(
            this._scrollRecovery,
            duration: Duration(seconds: 1),
            curve: Curves.ease
          );
          this._scrollRecovery = 0;
          solicitudSgtn.setProcessRecovery(new Map());
        });
      }
    }

    if(solicitudSgtn.scrollEdit > 0) {
      this._ctrlScroolLstRefaccs.animateTo(
        solicitudSgtn.scrollEdit,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease
      );
      solicitudSgtn.scrollEdit = 0;
    }
  }

  ///
  Future<void> _eliminarPieza(int indexPiezas) async {

    String body = '¿Estás Segur@ de quitar de tu lista la refacción seleccionada?';
    bool res = await alertsVarios.aceptarCancelar(this._context, titulo: 'BORRAR PIEZA', body: body);
    if(res){
      setState((){
        solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'].removeAt(indexPiezas);
      });
      widget.afterDelete();
    }
  }

  ///
  Future<void> _editarPieza(int idPieza) async {

    solicitudSgtn.idAutoForEdit = idPieza;
    solicitudSgtn.paginaVista = 0;
    solicitudSgtn.scrollEdit = this._ctrlScroolLstRefaccs.offset;
    Navigator.of(this._context).pushNamedAndRemoveUntil(
      'gestion_piezas_page',
      (Route rutas) => false,
      arguments: {'indexAuto': solicitudSgtn.autoEnJuego['indexAuto']}
    );
  }
}