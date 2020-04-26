import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/autos_repository.dart';
import 'package:zonamotora/singletons/alta_user_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/bg_altas_stack.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/regresar_pagina_widget.dart' as regresarPagina;
import 'package:zonamotora/utils/validadores.dart';

class AltaMksMdsPage extends StatefulWidget {
  @override
  _AltaMksMdsPageState createState() => _AltaMksMdsPageState();
}

class _AltaMksMdsPageState extends State<AltaMksMdsPage> {

  AppBarrMy appBarrMy       = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AlertsVarios alertsVarios = AlertsVarios();
  AltaUserSngt altaUserSngt = AltaUserSngt();
  Validadores validadores   = Validadores();
  AutosRepository emAutos   = AutosRepository();

  BuildContext _context;
  bool _isInit = false;
  String _lstAutosSelec = 'marcas';
  Widget _viewListAutos = new SizedBox(height: 0);
  Color _bgBtnMk = Colors.red;
  Color _fgBtnMk = Colors.white;
  Color _bgBtnMd = Colors.red;
  Color _fgBtnMd = Colors.white;
  List<Map<String, dynamic>> _lstMks = new List();
  List<Map<String, dynamic>> _lstMds = new List();
  List<Map<String, dynamic>> _lstTmp = new List();
  GlobalKey<ScaffoldState> _skfKey = GlobalKey<ScaffoldState>();
  TextEditingController _ctrlPalClas = TextEditingController();
  ScrollController _ctrl = ScrollController();
  BgAltasStack bgAltasStack = BgAltasStack();

  
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    this._ctrlPalClas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
     if(!this._isInit) {
      this._isInit = true;
      bgAltasStack.setBuildContext(this._context);
      DataShared dataShared = Provider.of<DataShared>(this._context, listen: false);
      dataShared.setLastPageVisit('alta_sistema_pc_page');
      _getAutos();
    }

    return Scaffold(
      key: this._skfKey,
      appBar: appBarrMy.getAppBarr(titulo: 'Alta de ${altaUserSngt.usname.toUpperCase()}'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: SingleChildScrollView(
          controller: this._ctrl,
          child: Container(
            width: MediaQuery.of(this._context).size.width,
            height: MediaQuery.of(this._context).size.height * 0.8,
            child: _body(),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        mini: true,
        child: Icon(Icons.save, size: 25),
        onPressed: (){
          Navigator.of(this._context).pushReplacementNamed('alta_perfil_contac_page');
        },
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  /* */
  Widget _body() {

    double altoContainer = (MediaQuery.of(this._context).size.height < 550) ? 0.28 : 0.35;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        regresarPagina.widget(this._context, 'REGRESAR', lstMenu: altaUserSngt.crearMenuSegunRole()),

        bgAltasStack.stackWidget(
          titulo: 'Marcas y Modelos',
          subtitulo: 'Indícalo si se manejan Específicamente',
          widgetTraslapado_1: _btns(),
          widgetTraslapado_2: _buscadorAndSheet()
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(this._context).size.height * altoContainer,
          width: MediaQuery.of(this._context).size.width,
          child: this._viewListAutos
        )
      ],
    );
  }

  /* */
  Widget _btns() {

    return Positioned(
      top: 60,
      width: MediaQuery.of(this._context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            onPressed: _clickBtnVerMarcas,
            color: this._bgBtnMk,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text(
              'ver MARCAS',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: this._fgBtnMk,
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          RaisedButton(
            onPressed: _clickBtnVerModelos,
            color: this._bgBtnMd,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text(
              'ver MODELOS',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: this._fgBtnMd,
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
    );
  }
  
  /* */
  Widget _buscadorAndSheet() {

    double topContainer = (MediaQuery.of(this._context).size.height < 550) ? 0.23 : 0.18;
    double altoContainer = (MediaQuery.of(this._context).size.height < 550) ? 0.4 : 0.5;
    
    return Positioned(
      top: MediaQuery.of(this._context).size.height * topContainer,
      width: MediaQuery.of(this._context).size.width,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(this._context).size.width * 0.05),
        height: MediaQuery.of(this._context).size.height * altoContainer,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.red[100]
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: Offset(0,-4),
              color: Colors.black
            )
          ]
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 2,
                    offset: Offset(0,0),
                    color: Colors.grey[800]
                  )
                ]
              ),
              child: TextFormField(
                onChanged: (String val) {
                  if(this._ctrl.offset < 153.3) {
                    this._ctrl.position.animateTo(
                      153.3,
                      duration: Duration(seconds: 1),
                      curve: Curves.ease
                    );
                  }
                  _buscadorDeAutos(val);
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.search, size: 35),
                  border: InputBorder.none
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* */
  Future<void> _getAutos() async {

    if(this._lstMks.length == 0) {
      List<Map<String, dynamic>> mrkMods = await emAutos.getAllAutos();
      Set<int> existMrk = new Set();
      mrkMods.forEach((autos){
        if(!existMrk.contains(autos['mk_id'])) {
          this._lstMks.add(autos);
        }
        existMrk.add(autos['mk_id']);
        this._lstMds.add(autos);
      });
      existMrk = mrkMods = null;
    }
    _clickBtnVerMarcas();
  }

  /* */
  Future<void> _viewListAutosBy() async {

    Set<int> existeAuto = new Set();
    List<Map<String, dynamic>> autos =(this._lstAutosSelec == 'marcas') ? this._lstMks : this._lstMds;

    Widget w = ListView.builder(
      itemCount: autos.length,
      itemBuilder: (BuildContext context, int index) {
        Widget widget = SizedBox(height: 0, width: 0);
        if(this._lstAutosSelec == 'marcas') {
          if(!existeAuto.contains(autos[index]['mk_id'])){
            existeAuto.add(autos[index]['mk_id']);
            return _listTitle(
              autos[index]['mk_id'],
              autos[index]['mk_nombre'],
              autos[index]['md_nombre']
            );
          }
        }else{
          if(!existeAuto.contains(autos[index]['md_id'])){
            existeAuto.add(autos[index]['md_id']);
            return _listTitle(
              autos[index]['md_id'],
              autos[index]['md_nombre'],
              autos[index]['mk_nombre']
            );
          }
        }
        return widget;
      },
    );

    setState(() {
      this._viewListAutos = w;
    });
  }

  /* */
  Widget _listTitle(int idAuto, String nombre, String subTitulo) {

    return CheckboxListTile(
      dense: true,
      onChanged: (bool val) {

        if(val) {
          if(this._lstAutosSelec == 'marcas') {
            altaUserSngt.mrksSelect.add(idAuto);
          }else{
            altaUserSngt.mdsSelect.add(idAuto);
          }
        } else {
          if(this._lstAutosSelec == 'marcas') {
            altaUserSngt.mrksSelect.remove(idAuto);
          }else{
            altaUserSngt.mdsSelect.remove(idAuto);
          }
        }

        _viewListAutosBy();
      },
      secondary: Icon(Icons.directions_car),
      value: (this._lstAutosSelec == 'marcas') ? altaUserSngt.mrksSelect.contains(idAuto) : altaUserSngt.mdsSelect.contains(idAuto),
      title: Text('$nombre'),
      subtitle: (this._lstAutosSelec != 'marcas') ? Text('$subTitulo') : Text('armadora'),
    );
  }

  /* */
  void _clickBtnVerMarcas() {

    this._bgBtnMd = Colors.red;
    this._fgBtnMd = Colors.white;
    this._bgBtnMk = Colors.white;
    this._fgBtnMk = Colors.black54;
    this._lstAutosSelec = 'marcas';
    this._lstTmp = this._lstMks;
    _viewListAutosBy();
  }

  /* */
  void _clickBtnVerModelos() {
    this._bgBtnMk = Colors.red;
    this._fgBtnMk = Colors.white;
    this._bgBtnMd = Colors.white;
    this._fgBtnMd = Colors.black54;
    this._lstAutosSelec = 'modelo';
    this._lstTmp = this._lstMds;
    _viewListAutosBy();
  }

  /* */
  void _buscadorDeAutos(String txt) {

    if(this._lstAutosSelec == 'marcas') {
      this._lstMks = new List();
      this._lstTmp.forEach((Map<String, dynamic> auto){
        if(auto['mk_nombre'].toLowerCase().contains(txt.toLowerCase())){
          this._lstMks.add(auto);
        }
      });
      _viewListAutosBy();
    }else{
      this._lstMds = new List();
      this._lstTmp.forEach((Map<String, dynamic> auto){
        if(auto['md_nombre'].toLowerCase().contains(txt.toLowerCase())){
          this._lstMds.add(auto);
        }
      });
      _viewListAutosBy();
    }
  }
}