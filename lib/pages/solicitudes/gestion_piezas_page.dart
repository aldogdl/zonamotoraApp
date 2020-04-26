import 'package:flutter/material.dart';
import 'package:zonamotora/pages/solicitudes/widgets/agregar_piezas_widget.dart';
import 'package:zonamotora/pages/solicitudes/widgets/finalizar_reg_piezas_widget.dart';
import 'package:zonamotora/pages/solicitudes/widgets/lst_piezas_widget.dart';
import 'package:zonamotora/singletons/solicitud_sngt.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';

class GestionPiezasPage extends StatefulWidget {

  @override
  _GestionPiezasPageState createState() => _GestionPiezasPageState();
}

class _GestionPiezasPageState extends State<GestionPiezasPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  SolicitudSngt solicitudSgtn = SolicitudSngt();

  int _cantPiezaSaved;
  bool _isInit = false;
  BuildContext _context;
  Map<String, int> _params;
  GlobalKey<ScaffoldState> _skfKey = GlobalKey<ScaffoldState>();
  List<Widget> _tabsBar;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback(_init);
    solicitudSgtn.setIndicadorColorCantPiezas(Colors.red[800]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(!this._isInit) {
      this._isInit = true;
      this._context = context;
      this._params = new Map<String, int>.from(ModalRoute.of(context).settings.arguments);
      solicitudSgtn.setAutoEnJuegoIndexAuto(this._params['indexAuto']);
      context = null;
    }

    this._cantPiezaSaved = (this._cantPiezaSaved != null) ? this._cantPiezaSaved : 0;
    double tamFont = (this._cantPiezaSaved >= 10) ? 11 : 13;
    this._tabsBar = [
      Tab(text: 'Agregar'),
      Tab(child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: solicitudSgtn.indicadorColorCantPiezas,
            maxRadius: 11,
            child: Text(
              '${this._cantPiezaSaved}',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: tamFont,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Text(
            ' Piezas',
            textScaleFactor: 1,
          )
        ],
      )),
      Tab(text: 'FINALIZAR'),
    ];

    int indexAuto;
    if(solicitudSgtn.autoEnJuego['indexAuto'] != null) {
      indexAuto = solicitudSgtn.autoEnJuego['indexAuto'];
    }
    String titulo = (indexAuto != null) ? solicitudSgtn.autos[indexAuto]['md_nombre'] : '...';

    return DefaultTabController(
      length: this._tabsBar.length,
      initialIndex: solicitudSgtn.paginaVista,
      child: Scaffold(
        key: this._skfKey,
        appBar: AppBar(
          title: Text(
            'Piezas para $titulo',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 16
            ),
          ),
          elevation: 5,
          bottom: TabBar(tabs: this._tabsBar),
        ),
        backgroundColor: Colors.red[100],
        drawer: MenuMain(),
        body: WillPopScope(
          onWillPop: () => Future.value(false),
          child: TabBarView(
            children: <Widget>[
              AgregarPiezasWidget(this._skfKey, _salvarPieza),
              LstPiezasWidget(_refreshScreenAfterDeletePieza),
              FinalizarRegPiezasWidget()
            ],
          ),
        ),
        bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
      )
    );
  }

  ///
  Future<void> _init(_) async {
    this._params = null;

    if(solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']].containsKey('piezas')){
      this._cantPiezaSaved = (solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'].length > 0)
        ? solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'].length
        : null;
    }

    setState(() { });
  }

  ///
  Future<bool> _salvarPieza(String pieza, List<Map<String, dynamic>> opLados, Set<int> ladosSeleccionados, String ladoSelect, String ubicacion) async {

    String subLados = solicitudSgtn.traslateLados(pieza, opLados, ladosSeleccionados);

    int idAutoForEdit = 0;
    if(solicitudSgtn.idAutoForEdit != null) {
      idAutoForEdit = solicitudSgtn.idAutoForEdit;
      solicitudSgtn.idAutoForEdit = null;
      solicitudSgtn.paginaVista = 1;
    }

    bool res = await solicitudSgtn.savePieza(
      pieza: pieza,
      lado: '$ladoSelect$subLados',
      posicion: (ubicacion == null) ? '' : ubicacion,
      id: idAutoForEdit
    );
    this._cantPiezaSaved = solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'].length;
    _changeColorIndicadorCantPiezas();
    setState(() { });
    return res;
  }

  ///
  void _changeColorIndicadorCantPiezas() {

    if(solicitudSgtn.indicadorColorCantPiezas.value == 4291176488){
      solicitudSgtn.setIndicadorColorCantPiezas(Colors.yellow);
    }else{
      if(solicitudSgtn.indicadorColorCantPiezas.value == 4294961979) {
        solicitudSgtn.setIndicadorColorCantPiezas(Colors.grey[200]);
      }else{
        solicitudSgtn.setIndicadorColorCantPiezas(Colors.red[800]);
      }
    }
  }

  ///
  void _refreshScreenAfterDeletePieza() {
    setState(() {
      this._cantPiezaSaved = solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'].length;
    });
  }


}