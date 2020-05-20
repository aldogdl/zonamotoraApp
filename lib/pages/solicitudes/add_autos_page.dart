import 'package:flutter/material.dart';

import 'package:zonamotora/repository/autos_repository.dart';
import 'package:zonamotora/singletons/buscar_autos_sngt.dart';
import 'package:zonamotora/singletons/solicitud_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/buscar_autos_by.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';

class AddAutosPage extends StatefulWidget {
  @override
  AddAutosPageState createState() => AddAutosPageState();
}

class AddAutosPageState extends State<AddAutosPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AutosRepository emAutos = AutosRepository();
  SolicitudSngt solicitudSgtn = SolicitudSngt();
  BuscarAutosSngt buscarAutosSngt = BuscarAutosSngt();
  AlertsVarios alertsVarios = AlertsVarios();

  String _titleMain = '¿PARA QUÉ CARRO?';
  String _titlePage = 'Cotizador de Refacciones';
  String _txtMarca = 'Click AQUÍ';
  Color _colorMarca = Colors.grey;
  String _txtModelo= 'Click AQUÍ';
  Color _colorModelo = Colors.grey;
  
  TextEditingController _ctrAnio = TextEditingController();
  TextEditingController _ctrVersion = TextEditingController();
  FocusNode _focusAnio = FocusNode();

  Size _screen;
  BuildContext _context;
  bool _isEditing = false;
  int _cantAutosSeleccionados = 0;
  ScrollController _scrollCtr = ScrollController();
  GlobalKey<ScaffoldState> _skfKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    
    this._scrollCtr.addListener((){
      if(this._scrollCtr.offset < 28) {
        if(this._titlePage != 'Cotizador de Refacciones'){
          setState(() {
            this._titlePage = 'Cotizador de Refacciones';
            this._titleMain = '¿PARA QUÉ CARRO?';
          });
        }
      }else{
        if(this._titlePage != '¿PARA QUÉ CARRO?'){
          setState(() {
            this._titlePage = '¿PARA QUÉ CARRO?';
            this._titleMain = '';
          });
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback(_init);
    super.initState();
  }

  @override
  void dispose() {
    this._scrollCtr?.dispose();
    this._ctrAnio?.dispose();
    this._ctrVersion?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;

    if(buscarAutosSngt.idMarca != null) {
      this._txtMarca = buscarAutosSngt.nombreMarca;
      this._colorMarca = Colors.blue;
    }else{
      this._txtMarca = 'Click AQUÍ';
      this._colorMarca = Colors.grey;
    }

    if(buscarAutosSngt.idModelo != null) {
      this._txtModelo = buscarAutosSngt.nombreModelo;
      this._colorModelo = Colors.blue;
    }else{
      this._txtModelo = 'Click AQUÍ';
      this._colorModelo = Colors.grey;
    }

    this._cantAutosSeleccionados = solicitudSgtn.autos.length;

    return Scaffold(
      key: this._skfKey,
      appBar: appBarrMy.getAppBarr(titulo: this._titlePage),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: this._screen.width,
                height: this._screen.height * 0.20,
                decoration: BoxDecoration(
                  color: Color(0xff7C0000)
                ),
                child: SizedBox(height: 30),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: _body()
            ),
            Positioned(
              top: this._screen.height * 0.01,
              width: this._screen.width,
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 20),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Colors.red,
                        width: 1
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          color: Colors.black
                        )
                      ]
                    ),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.green,
                      child: InkWell(
                        onTap: () {
                          _resetScreen();
                          if(solicitudSgtn.autos.length == 0) {
                            solicitudSgtn.addOtroAuto = false;
                          }
                          Navigator.of(this._context).pushNamedAndRemoveUntil('buscar_index_page', (Route rutas) => false);
                        },
                        child: Icon(Icons.arrow_back_ios, color: Colors.black)
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${ this._titleMain }',
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w300
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  Future<void> _init(_) async {

    int indexAuto = -1;

    if(solicitudSgtn.indexAutoIsEditing > -1) {
      indexAuto = solicitudSgtn.indexAutoIsEditing;
      this._isEditing = true;
    }else{
      if(!solicitudSgtn.addOtroAuto) {
        if(solicitudSgtn.autos.length == 1) {
          solicitudSgtn.indexAutoIsEditing = -1;
          this._isEditing = false;
        }
      }
    }

    if(indexAuto > -1){
      buscarAutosSngt.setIdMarca(solicitudSgtn.autos[indexAuto]['mk_id']);
      buscarAutosSngt.setIdModelo(solicitudSgtn.autos[indexAuto]['md_id']);
      buscarAutosSngt.setNombreMarca(solicitudSgtn.autos[indexAuto]['mk_nombre']);
      buscarAutosSngt.setNombreModelo(solicitudSgtn.autos[indexAuto]['md_nombre']);
      this._ctrAnio.text = solicitudSgtn.autos[indexAuto]['anio'];
      this._ctrVersion.text = (solicitudSgtn.autos[indexAuto]['version'] == '0') ? '' : solicitudSgtn.autos[0]['version'];
      setState(() { });
    }
  }

  ///
  Widget _body() {

    double alto;
    if(this._isEditing){
      alto = (this._screen.height <= 550) ? 1.07 : 0.85;
    }else{
      alto = (this._screen.height <= 550) ? 1 : 0.75;
    }

    return Container(
      width: this._screen.width,
      height: this._screen.height,
      child: ListView(
        controller: this._scrollCtr,
        children: <Widget>[
          const SizedBox(height: 60),
          Center(
            widthFactor: this._screen.width,
            child: Container(
              padding: EdgeInsets.all(10),
              width: this._screen.width * 0.92,
              height: this._screen.height * alto,
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  border: Border.all(
                    color: Colors.grey[400]
                  )
                ),
                child: _frm(),
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  ///
  Widget _frm() {

    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '   MARCA DEL AUTO:',
            textScaleFactor: 1,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(height: 5),
        _inputMarca(),
        const SizedBox(height: 20),
        Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(
                '   MODELO:',
                textScaleFactor: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'AÑO:',
                textScaleFactor: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: this._screen.width,
          height: 60,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: _inputModelo(),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: _inputAnio(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Versión o Características del Modelo:',
            textScaleFactor: 1,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(height: 5),
        _inputVersion(),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '   Detalles que diferencien el vehículo',
            textScaleFactor: 1,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14,
              color: Colors.red
            ),
          ),
        ),
        const SizedBox(height: 20),
        _btnAccion(),
      ],
    );

  }

  ///
  Widget _btnAccion() {

    if(this._isEditing) {
      return Column(
        children: <Widget>[
          _machoteBtnAccion(
            titulo: 'AGREGAR otro AUTO',
            color: Colors.grey,
            icono: Icons.plus_one,
            accion: () {
              this._isEditing = false;
              solicitudSgtn.indexAutoIsEditing = -1;
              _agregarOtroAuto(forceAdd: true);
            }
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: this._screen.width * 0.9,
            child: RaisedButton.icon(
              icon: Icon(Icons.edit),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              color: Colors.blue,
              label: Text(
                'CAMBIAR AUTOMÓVIL'
              ),
              onPressed: () async {
                bool isValid = await _isValid();
                if(isValid){
                  await _addAutoToList();
                  if(solicitudSgtn.editAutoPage == 'alta_piezas_page') {
                    Navigator.of(this._context).pushReplacementNamed('alta_piezas_page');
                  }else{
                    _irListaDeModelos();
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: this._screen.width * 0.9,
            child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              color: Colors.red,
              icon: Icon(Icons.delete),
              textColor: Colors.white,
              label: Text(
                'CANCELAR Y REGRESAR',
                textScaleFactor: 1,
              ),
              onPressed: () {

                if(solicitudSgtn.editAutoPage == null) {
                  if(solicitudSgtn.autos.length == 1) {
                    Navigator.of(this._context).pushReplacementNamed('alta_piezas_page');
                  }else{
                    _irListaDeModelos();
                  }
                  
                }else{
                  if(solicitudSgtn.editAutoPage == 'alta_piezas_page') {
                    Navigator.of(this._context).pushReplacementNamed('alta_piezas_page');
                  }else{
                    _irListaDeModelos();
                  }
                }
                
              },
            ),
          ),
        ],
      );
    }

    if(solicitudSgtn.addOtroAuto) {
      return Column(
        children: <Widget>[
          _machoteBtnAccion(
            titulo: 'AGREGAR NUEVO AUTO',
            color: Colors.grey,
            icono: Icons.plus_one,
            accion: () {
              this._isEditing = false;
              solicitudSgtn.indexAutoIsEditing = -1;
              _agregarOtroAuto(forceAdd: true);
            }
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: this._screen.width * 0.9,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              color: Colors.red,
              textColor: Colors.white,
              child: Text(
                'IR A LA LISTA DE AUTOS',
                textScaleFactor: 1,
              ),
              onPressed: () {
                _irListaDeModelos();
              },
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[

         _machoteBtnAccion(
          titulo: 'AGREGAR otro AUTO',
          color: Colors.grey,
          icono: Icons.plus_one,
          accion: _agregarOtroAuto
        ),
        const SizedBox(height: 20),
        _machoteBtnAccion(
          titulo: 'Cotizar REFACCIONES ',
          color: Colors.red,
          icono: Icons.arrow_forward,
          accion: _cotizarRefaccion,
          indicador: false,
        ),
      ],
    );
  }

  ///
  Widget _machoteBtnAccion(
    {String titulo,
    Color color,
    IconData icono,
    Function accion,
    indicador = true}
  ) {

    return InkWell(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              offset: Offset(1, 1),
              color: Colors.black
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(icono, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              titulo,
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
            (indicador)
            ?
            CircleAvatar(
              radius: 15,
              child: Text(
                '${ this._cantAutosSeleccionados }',
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
  Widget _inputMarca() {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(1,1),
            color: Colors.grey
          )
        ]
      ),
      child: InkWell(
        onTap: () async { 
          await showDialog(
            context: this._context,
            builder: (BuildContext context) {
              return BuscarAutosBy(
                titulo: 'Busca la Marca:',
                subTitulo: 'Selecciona la marca del Auto',
                autosBy: 'marca',
              );
            }
          );
          setState(() { });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: SizedBox(
                height: this._screen.height * 0.15,
                child: Image(
                  image: AssetImage('assets/images/auto_ico.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: SizedBox(
                width: this._screen.width * 0.7,
                child: Text(
                  '${ this._txtMarca }',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: this._colorMarca,
                    fontWeight: (this._colorMarca == Colors.grey) ? FontWeight.normal : FontWeight.bold
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Icon(Icons.search, color: Colors.grey),
            ),
            const SizedBox(width: 5)
          ],
        ),
      )
    );
  }
  
  ///
  Widget _inputModelo() {

    return Container(
      width: this._screen.width * 0.48,
      height: 60,
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10)
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(1,1),
            color: Colors.grey
          )
        ]
      ),
      child: InkWell(
        onTap: () async {
          if(buscarAutosSngt.idMarca != null){
            await showDialog(
              context: this._context,
              builder: (BuildContext context) {
                return BuscarAutosBy(
                  titulo: 'Busca Modelo:',
                  subTitulo: 'Selecciona el Modelo del Auto',
                  autosBy: 'modelos',
                );
              }
            );
            if(buscarAutosSngt.idModelo != null) {
              FocusScope.of(this._context).requestFocus(this._focusAnio);
            }
            setState(() { });
          }else{
            await alertsVarios.entendido(
              this._context,
              titulo: 'SIN MARCA',
              body: 'No se ha detectado que hallas seleccionado LA MARCA DEL AUTO para filtrar sus respectivos MODELOS.'
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>
          [
            Text(
              '${ this._txtModelo }',
              textScaleFactor: 1,
              style: TextStyle(
                color: this._colorModelo,
                fontWeight: (this._colorMarca == Colors.grey) ? FontWeight.normal : FontWeight.bold
              )
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Icon(Icons.search, color: Colors.grey),
            ),
          ] ,
        ),
      )
    );
  }

  ///
  Widget _inputAnio() {

    return Container(
      width: this._screen.width * 0.30,
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10)
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(1,1),
            color: Colors.grey
          )
        ]
      ),
      child: TextField(
        controller: this._ctrAnio,
        focusNode: this._focusAnio,
        keyboardType: TextInputType.number,
        maxLength: 4,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 21,
          color: Colors.blue,
          fontWeight: FontWeight.bold
        ),
        buildCounter: null,
        decoration: InputDecoration(
          hintText: '0000',
          counterText: '',
          hintStyle: TextStyle(
            color: Colors.grey[300]
          ),
        ),
      )
    );
  }

  ///
  Widget _inputVersion() {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(1,1),
            color: Colors.grey
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 4,
            child: SizedBox(
              width: this._screen.width * 0.7,
              child: TextField(
                controller: this._ctrVersion,
                textInputAction: TextInputAction.done,
                maxLines: 2,
                maxLength: 66,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Dato Opcional',
                  counterText: '',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 13
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.help, color: Colors.blue, size: 30),
            onPressed: () => _showHelpVersion(),
          ),
        ],
      )
    );
  }

  ///
  void _agregarOtroAuto({bool forceAdd = false}) async {

    bool isValid = await _isValid();

    if(isValid){
      await _addAutoToList(forceAdd: forceAdd);

      String body = 'MODELO AGREGADO CON ÉXITO A TU LISTA.\n\nContinuar agregando el siguiente vehículo.';
      SnackBar snackbar = new SnackBar(
        backgroundColor: Colors.blue,
        content: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: CircleAvatar(
                child: Icon(Icons.thumb_up),
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                body,
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
          ],
        ),
      );
      this._skfKey.currentState.showSnackBar(snackbar);

      _resetScreen();
      this._scrollCtr.animateTo(0, duration: Duration(seconds: 1), curve: Curves.ease);
      setState(() {});
    }
  }

  ///
  void _cotizarRefaccion() async {

    bool save = false;
    if(solicitudSgtn.autos.length > 1) {
      if(buscarAutosSngt.idMarca != null && buscarAutosSngt.idModelo != null) {
        save = true;
      }else{
        solicitudSgtn.indexAutoIsEditing = -1;
        this._isEditing = false;
        _irListaDeModelos();
      }
    }else{
      save = true;
    }

    bool isValid = false;
    if(save) {
      isValid = await _isValid();
      if(isValid){
        await _addAutoToList();
      }
    }

    if(save && isValid) {
      _resetScreen();
      if(solicitudSgtn.autos.length > 1) {
        _irListaDeModelos();
      }else{
        solicitudSgtn.setAutoEnJuegoIndexAuto(0);
        Navigator.of(this._context).pushReplacementNamed('alta_piezas_page');
      }
    }

  }

  ///
  void _irListaDeModelos() {

    solicitudSgtn.indexAutoIsEditing = -1;
    this._isEditing = false;
    solicitudSgtn.addOtroAuto = false;
    solicitudSgtn.setAutoEnJuegoIndexAuto(null);
    solicitudSgtn.setAutoEnJuegoIndexPieza(null);
    solicitudSgtn.setAutoEnJuegoIdPieza(null);
    Navigator.of(this._context).pushNamedAndRemoveUntil('lst_modelos_select_page', (Route rutas) => false);
  }

  ///
  void _resetScreen() {
    
    buscarAutosSngt.setIdMarca(null);
    buscarAutosSngt.setNombreMarca(null);
    buscarAutosSngt.setIdModelo(null);
    buscarAutosSngt.setNombreModelo(null);
    this._txtMarca    = 'Click AQUÍ';
    this._txtModelo   = 'Click AQUÍ';
    this._colorMarca  = Colors.grey;
    this._colorModelo = Colors.grey;
    this._ctrAnio.text= '';
    this._ctrVersion.text = '';
  }

  ///
  Future<void> _addAutoToList({bool forceAdd = false}) async {

    Map<String, dynamic> auto = {
      'mk_id'     : buscarAutosSngt.idMarca,
      'mk_nombre' : buscarAutosSngt.nombreMarca,
      'md_id'     : buscarAutosSngt.idModelo,
      'md_nombre' : buscarAutosSngt.nombreModelo,
      'anio'      : this._ctrAnio.text,
      'version'   : (this._ctrVersion.text.isEmpty) ? '0' : this._ctrVersion.text,
      'piezas'    : new List<Map<String, dynamic>>(),
    };

    if(forceAdd){
      solicitudSgtn.setAutoSeleccionado(auto);
    }else{
      if(this._isEditing) {
        await solicitudSgtn.editarAuto(auto);
      }else{
        solicitudSgtn.setAutoSeleccionado(auto);
      }
    }
    this._isEditing = false;
    solicitudSgtn.indexAutoIsEditing = -1;
  }

  ///
  Future<bool> _isValid() async {

    bool res = true;
    String errorBody;
    String errorTitle;

    if(buscarAutosSngt.idMarca == null) {
      errorTitle = '¡LA MARCA!';
      errorBody  = 'No haz seleccionado una MARCA';
      res = false;
    }
    if(res) {
      if(buscarAutosSngt.idModelo == null) {
        errorTitle = '¡EL MODELO!';
        errorBody  = 'Selecciona un modelos para ${ buscarAutosSngt.nombreMarca }';
        res = false;
      }
    }
    if(res) {
      if(this._ctrAnio.text.length == 0) {
        errorTitle = '¡EL AÑO!';
        errorBody  = 'Inidca el Año para ${ buscarAutosSngt.nombreModelo }';
        FocusScope.of(this._context).requestFocus(this._focusAnio);
        res = false;
      }
    }
    if(res) {
      if(this._ctrAnio.text.length > 1 && this._ctrAnio.text.length < 4) {
        errorTitle = '¡EL AÑO!';
        errorBody  = 'El año debe ser de 4 dígitos';
        FocusScope.of(this._context).requestFocus(this._focusAnio);
        res = false;
      }
    }
    if(!res){
      await alertsVarios.entendido(this._context, titulo: errorTitle, body: errorBody);
    }
    return res;
  }

  ///
  Future<void> _showHelpVersion() async {

    String body = 'En ocaciones, los Modelos cuentan con varias versiones que hacen que su diseño y funcionamiento cambien.';
    String body2 = 'Por ejemplo:\n\nSi el auto es 2 o 5 puertas, si es Automático, o si es tipo Sedan, Vagoneta, Hashback.\n\nEn la mayoria de las ocaciones, con el nombre específico de la versión vasta para conocer las características necesarias.';
    String body3 = 'Agregar detalles adicionales, nos ayudan a otorgarte un mejor servicio.';

    await showDialog(
      context: this._context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          titleTextStyle: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 23
          ),
          title: Text(
            'AYUDA RÁPIDA',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 7),
          content: Container(
            width: this._screen.width,
            height: this._screen.height * 0.55,
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(7),
                  width: this._screen.width,
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(
                    body,
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                ),
                Divider(),
                Text(
                  body2,
                  textScaleFactor: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  body3,
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton.icon(
              color: Colors.blue,
              textColor: Colors.white,
              icon: Icon(Icons.check),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              label: Text(
                'OK',
                textScaleFactor: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () => Navigator.of(this._context).pop(true)
            )
          ],
        );
      }
    );
  }
}