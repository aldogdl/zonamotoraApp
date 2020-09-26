import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/https/asesores_http.dart';
import 'package:zonamotora/repository/autos_repository.dart';
import 'package:zonamotora/repository/procc_roto_repository.dart';
import 'package:zonamotora/singletons/alta_user_sngt.dart';
import 'package:zonamotora/singletons/tomar_imagenes_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/bg_altas_stack.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/utils/validadores.dart';
import 'package:zonamotora/widgets/tomar_imagenes_widget.dart';

class AltaSaveResumPage extends StatefulWidget {
  @override
  _AltaSaveResumPageState createState() => _AltaSaveResumPageState();
}

class _AltaSaveResumPageState extends State<AltaSaveResumPage> {

  AppBarrMy appBarrMy       = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AlertsVarios alertsVarios = AlertsVarios();
  AltaUserSngt altaUserSngt = AltaUserSngt();
  Validadores validadores   = Validadores();
  BgAltasStack bgAltasStack = BgAltasStack();
  AutosRepository emAutos   = AutosRepository();
  AsesoresHttp asesoresHttp = AsesoresHttp();
  ProccRotoRepository emProcRoto = ProccRotoRepository();
  TomarImagenesSngt tomarImagenesSngt = TomarImagenesSngt();

  BuildContext _context;
  bool _isInit = false;
  bool _isSaved= false;
  bool _isSavedFachada= false;
  bool _processRoto = false;
  bool _showBtnAtras = true;
  GlobalKey<ScaffoldState> _skfKey = GlobalKey<ScaffoldState>();

  Widget _lstSistemas;
  Widget _lstPalClas;
  Widget _lstMarksMods;
  Widget _lstDatsNegocio;
  Widget _lstRsWeb;
  Widget _lstMapOtros;
  Widget _estrellas;

  IconData _iconSistemas;
  IconData _iconPalClas;
  IconData _iconMarksMods;
  IconData _iconDataNego;
  IconData _iconRsWev;
  IconData _iconMapOtros;
  double _isValid = 0;
  String lastUri;
  String _error;
  String _txtFachada = 'sin imagen aún';
  Map<String, dynamic> _dataResultSave = new Map();

  Widget _widgetImage = Image(
    image: AssetImage('assets/images/img_fin_alta.png'),
    fit: BoxFit.cover,
  );
  String _tituloDataSaved = '¡LISTO DATOS SALVADOS!';
  String _bodyDataSaved = 'Los datos han sido almacenados.\nAhora podrás Crear y Guardar la FACHADA.';

  ///Diseño.
  double _altoAppBar;

  @override
  void dispose() {
    altaUserSngt.setFachada(null);
    tomarImagenesSngt.dispose();
    imageCache.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _initWidget());
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._altoAppBar = MediaQuery.of(this.context).size.height * 0.30;

    if(!this._isInit) {
      this._isInit = true;
      this._estrellas = Text('Calculando...');
      bgAltasStack.setBuildContext(this._context);
      DataShared dataShared = Provider.of<DataShared>(this._context, listen: false);
      lastUri = dataShared.lastPageVisit;
      dataShared.setLastPageVisit('alta_perfil_otros_page');
    }

    if(this._isSaved && !this._processRoto) {
      this._processRoto = true;
      tomarImagenesSngt.proccRoto = {
        'nombre': 'altSoc',
        'metadata': {'idUser':altaUserSngt.userId},
        'contents': {'tokenAsesor': Provider.of<DataShared>(this._context, listen: false).tokenAsesor['token']}
      };
    }

    return Scaffold(
      key: this._skfKey,
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: CustomScrollView(

          slivers: <Widget>[
            SliverAppBar(
              title: Text(
                'RESUMEN',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 17
                ),
              ),
              expandedHeight: this._altoAppBar,
              backgroundColor: Color(0xff7C0000),
              automaticallyImplyLeading: true,
              elevation: 2.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _containerAppBar(),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _body()
              ]),
            )
          ],
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  Future<void> _initWidget() async {

    if(tomarImagenesSngt.isRecovery) {
      this._isSaved = true;
      this._processRoto = false;
      tomarImagenesSngt.isRecovery = false;
      this._showBtnAtras = false;
      setState(() {});
    }
    tomarImagenesSngt.restringirPosition = 'h';
  }

  ///
  Widget _body() {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        const SizedBox(height: 1),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[200],
                Colors.red[100]
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border(
              top: BorderSide(color: Colors.white, width: 2)
            )
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'Inf. Calif.',
                      textScaleFactor: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800]
                      ),
                    ),
                    this._estrellas,
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'FACHADA',
                      textScaleFactor: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      this._txtFachada,
                      textScaleFactor: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(),
        (this._error != null)
        ? Text(
          this._error,
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold
          ),
        )
        : SizedBox(height: 0),
        const SizedBox(height: 20),
        (this._isSaved) ? _dataSaved() : _recomendacion(),
        (this._isSaved) ? SizedBox(height: 0) : _listaDeSecciones(),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Necesitas guardar los datos hasta ahora registrados para proceguir con la imagen de la fachada del negocio',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          width: MediaQuery.of(this._context).size.width * 0.8,
          child: RaisedButton.icon(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            icon: Icon(Icons.save),
            label: Text(
              'Guardar y Continuar',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 18
              ),
            ),
            onPressed: () async {
              if(this._isSaved) {
                _saveFachada();
              }else{
                await _saveData();
              }
            },
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  ///
  Widget _listaDeSecciones() {

    List<Widget> secciones = new List();
    if(altaUserSngt.roles != 'ROLE_AUTOS'){
      secciones.add(
        _containerOfDatas(
          titulo: altaUserSngt.allPasosDelAltas[0]['titulo'],
          rutaEdit: altaUserSngt.allPasosDelAltas[0]['ruta'],
          futuro: _crearLstSistemas(),
          child: this._lstSistemas
        )
      );
      secciones.add(
        _containerOfDatas(
          titulo: altaUserSngt.allPasosDelAltas[1]['titulo'],
          rutaEdit: altaUserSngt.allPasosDelAltas[1]['ruta'],
          futuro: _showPalabrasClaves(),
          child: this._lstPalClas
        )
      );
      secciones.add(
        _containerOfDatas(
          titulo: altaUserSngt.allPasosDelAltas[2]['titulo'],
          rutaEdit: altaUserSngt.allPasosDelAltas[2]['ruta'],
          futuro: _showMarcasModelos(),
          child: this._lstMarksMods
        )
      );
    }

    secciones.add(
      _containerOfDatas(
        titulo: altaUserSngt.allPasosDelAltas[3]['titulo'],
        rutaEdit: altaUserSngt.allPasosDelAltas[3]['ruta'],
        futuro: _showDataNegocio(),
        child: this._lstDatsNegocio
      )
    );
    secciones.add(
      _containerOfDatas(
        titulo: altaUserSngt.allPasosDelAltas[4]['titulo'],
        rutaEdit: altaUserSngt.allPasosDelAltas[4]['ruta'],
        futuro: _showMapAndOtros(),
        child: this._lstMapOtros
      )
    );
    secciones.add(
      _containerOfDatas(
        titulo: altaUserSngt.allPasosDelAltas[5]['titulo'],
        rutaEdit: altaUserSngt.allPasosDelAltas[5]['ruta'],
        futuro: _showDataRSAndInternet(),
        child: this._lstRsWeb
      )
    );
    return Column(
      children: secciones,
    );
  }

  ///
  Widget _recomendacion() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'RECOMENDACIÓN',
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w300
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Revisar la información y enviala al servidor antes de procesar la Fachada.',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  ///
  Widget _dataSaved() {

    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(this._context).size.width * 0.05),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            offset: Offset(1,1),
            color: Colors.red
          )
        ]
      ),
      width: MediaQuery.of(this._context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            this._tituloDataSaved,
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w300,
              color: Colors.green
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 7),
            child: Text(
              _bodyDataSaved,
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey
              ),
            ),
          ),
          TomarImagenWidget(
            contextFrom: this._context,
            actionBarTitle: 'FACHADA',
            maxImages: 1,
            isMultiple: false,
            child: _btnTomarFachada(),
          ),
          Divider(),
          Text(
            'ACCIONES POSTERIORES',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue
            ),
          ),
          (this._isSavedFachada)
          ?
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                _machoteBtnAcciones(titulo: 'CREAR SITIO WEB', accion: () async {
                  altaUserSngt.dispose();
                  if(this._dataResultSave.isNotEmpty){
                    altaUserSngt.setUserId(this._dataResultSave['u_id']);
                    altaUserSngt.setCreateDataSitioWebByKeyMap('ids', 'perfil', this._dataResultSave['p_id']);
                    altaUserSngt.setCreateDataSitioWebByKeyMap('ids', 'user', this._dataResultSave['u_id']);
                    altaUserSngt.setCreateDataSitioWebByKeySingle('slug', this._dataResultSave['p_razonSocial']);
                    altaUserSngt.setCreateDataSitioWebByKeySingle('pagWeb', this._dataResultSave['p_pagWeb']);
                    Navigator.of(this._context).pushNamedAndRemoveUntil('alta_pagina_web_despeq_page', (Route rutas) => false);
                  }else{
                    String body = 'No se tiene por el momento, información para crear el sitio Web, espera a ser procesada.';
                    await alertsVarios.entendido(this._context, titulo: 'PROCESO INVALIDO', body: body);
                    return false;
                  }
                }),
                _machoteBtnAcciones(titulo: 'MENÚ', accion: (){
                  altaUserSngt.dispose();
                  altaUserSngt.setUserId(null);
                  Navigator.of(this._context).pushNamedAndRemoveUntil('alta_index_menu_page', (Route rutas) => false);
                }),
                _machoteBtnAcciones(titulo: 'Nuevo Registro', accion: (){
                  altaUserSngt.dispose();
                  altaUserSngt.setUserId(null);
                  Navigator.of(this._context).pushNamedAndRemoveUntil('reg_user_page', (Route rutas) => false, arguments: {'source':'asesor'});
                }),
                _machoteBtnAcciones(titulo: 'Continuar Nueva Alta', accion: (){
                  altaUserSngt.dispose();
                  altaUserSngt.setUserId(null);
                  Navigator.of(this._context).pushNamedAndRemoveUntil('alta_lst_users_page', (Route rutas) => false);
                }),
                _machoteBtnAcciones(titulo: 'Inicio', accion: (){
                  altaUserSngt.dispose();
                  altaUserSngt.setUserId(null);
                  Navigator.of(this._context).pushNamedAndRemoveUntil('index_page', (Route rutas) => false);
                })
              ],
            ),
          )
          :
          SizedBox(height: 0)
        ],
      ),
    );
  }

  ///
  Widget _btnTomarFachada() {

    return Container(
      width: MediaQuery.of(this._context).size.width * 0.6,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(1, 1),
            color: Colors.black.withAlpha(150)
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.folder_special, color: Colors.amber[600]),
          Text(
            'Seleccionar Fachada',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.blue[300]
            ),
          )
        ],
      ),
    );
  }

  ///
  Widget _machoteBtnAcciones({String titulo, Function accion}) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7)
        ),
        color: Colors.lightBlue,
        textColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          '$titulo'
        ),
        onPressed: accion,
      ),
    );
  }

  ///
  Widget _containerAppBar() {

    return Stack(
      children: <Widget>[
        Positioned(
          top: 0, left: 0,
          child: Container(
            width: MediaQuery.of(this._context).size.width,
            color: Colors.blue,
            child: Consumer<DataShared>(
              builder: (_, dataShared, __){
                if(dataShared.refreshWidget > -1){
                  if(tomarImagenesSngt.childImg != null) {
                    return tomarImagenesSngt.childImg;
                  }else{
                    return tomarImagenesSngt.previewImage();
                  }
                }
                return this._widgetImage;
              }
            ),
          ),
        ),
        Positioned(
          top: 0, left: 0,
          child: Container(
            height: (this._altoAppBar / 2),
            width: MediaQuery.of(this._context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff7C0000),
                  Color(0xff7C0000).withAlpha(0)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            ),
          ),
        ),
        Positioned(
          bottom: 0, left: 0,
          child: Container(
            height: (this._altoAppBar / 1.5),
            width: MediaQuery.of(this._context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff7C0000).withAlpha(0),
                  Color(0xff7C0000),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            ),
          ),
        ),
        (!this._showBtnAtras)
        ?
        SizedBox(height: 0)
        :
        Positioned(
          top: (this._altoAppBar - MediaQuery.of(this._context).size.width * 0.07),
          left: MediaQuery.of(this._context).size.width * 0.05,
          child: CircleAvatar(
            maxRadius: 17,
            backgroundColor: Colors.white,
            child: IconButton(
              alignment: Alignment.center,
              icon: Icon(Icons.arrow_back_ios, size: 17, color: Colors.red),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('alta_perfil_otros_page', (Route rutas) => false);
              },
            ),
          ),
        ),
      ],
    );
  }
  
  ///
  Widget _tituloInfo(String titulo, {Color txtColor = Colors.green}) {

    return Text(
      '$titulo',
      textScaleFactor: 1,
      textAlign: TextAlign.start,
      style: TextStyle(
        color: txtColor
      ),
    );
  }

  ///
  Widget _containerDataRaw({@required child}) {

    return Container(
      width: MediaQuery.of(this._context).size.width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(10)
      ),
      child: child,
    );
  }

  ///
  Widget _containerOfDatas({
    @required String titulo,
    @required String rutaEdit,
    @required Future futuro,
    @required Widget child
  }) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(this._context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '$titulo',
                textScaleFactor: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.edit, color: Colors.purpleAccent),
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('$rutaEdit', (Route rutas) => false)
              ),
            ],
          ),
          Divider(color: Colors.red, height: 1,),
          Divider(color: Colors.white, height: 1,),
          const SizedBox(height: 10),
          FutureBuilder(
            future: futuro,
            builder: (_, AsyncSnapshot snapshot){
              if(child != null) {
                return child;
              }
              return LinearProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  ///
  Future<void> _crearLstSistemas() async {

    if(this._lstSistemas != null) return;
    List<Widget> sistemas = new List();

    altaUserSngt.listSistemaSelect.forEach((sistema){

      Map<String, dynamic> sistem = altaUserSngt.lstSistemas.firstWhere((item){
        return (item['sa_id'] == sistema['sa_id']);
      }, orElse: () => new Map());

      sistemas.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 7),
          child: Text(
            '${sistem['sa_nombre']}',
            textScaleFactor: 1,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14
            ),
          ),
        )
      );
    });

    if(sistemas.length > 0) {
      this._iconSistemas = Icons.star;
      this._isValid = this._isValid + 1;
    }else{
      this._iconSistemas = Icons.star_border;
    }

    this._lstSistemas = _containerDataRaw(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sistemas
      )
    );
    Widget w = await _putStar();
    setState(() {
      this._estrellas = w;
    });
    w = null;
  }

  ///
  Future<void> _showPalabrasClaves() async {

    if(this._lstPalClas != null) return;
    List<String> palabras = new List();
    String palclas = '';
    altaUserSngt.listSistemaSelect.forEach((sistema){
      List<String> pedazos = sistema['sa_palclas'].split(',');
      pedazos.forEach((parte){
        String p = parte.trim();
        if(p != '0'){
          palabras.add(p);
        }
      });
    });

    palclas = (palabras.length > 0) ? palabras.join(', ') : 'Sin Datos';
    if(palabras.length > 0) {
      this._iconPalClas = Icons.star;
      this._isValid = this._isValid + 1;
    }else{
      this._iconPalClas = Icons.star_border;
    }

    this._lstPalClas = _containerDataRaw(
      child: Text(
        '$palclas ...',
        textScaleFactor: 1,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 14,
          height: 1.7
        ),
      )
    );
    Widget w = await _putStar();
    setState(() {
      this._estrellas = w;
    });
    w = null;
  }

  ///
  Future<void> _showMarcasModelos() async {

    if(this._lstMarksMods != null) return;

    List<Widget> mkmd = new List();
    List<Map<String, dynamic>> items;
    if(altaUserSngt.mrksSelect.isNotEmpty){
      List<int> idMarcas = altaUserSngt.mrksSelect.toList();
      items = await emAutos.getMarcaByIds(idMarcas.join(','));
      if(items.isNotEmpty){

        mkmd.add(_tituloInfo('MARCAS:'));
        mkmd.add(Divider());
        items.forEach((mark){
          mkmd.add(_tituloInfo('${mark['mk_nombre']}', txtColor: Colors.black87));
        });
      }
    }
    
    if(altaUserSngt.mdsSelect.isNotEmpty){

      double spacer = (items.isEmpty) ? 0 : 30;
      List<int> idModelos = altaUserSngt.mdsSelect.toList();
      items = await emAutos.getModelosByIds(idModelos.join(','));

      if(items.isNotEmpty){

        mkmd.add(SizedBox(height: spacer));
        mkmd.add(_tituloInfo('MODELOS:'));
        mkmd.add(Divider());

        items.forEach((mods){
          mkmd.add(_tituloInfo('${mods['md_nombre']}', txtColor: Colors.black87));
        });
      }
    }

    items = null;
    this._isValid = this._isValid + 1;
    if(mkmd.length == 0) {
      this._iconMarksMods = Icons.star;
    }
    if(mkmd.length > 0){
      this._lstMarksMods = _containerDataRaw(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: mkmd
        )
      );
    }else{
      this._lstMarksMods = Text('...');
    }
    Widget w = await _putStar();
    setState(() {
      this._estrellas = w;
    });
    w = null;
  }

  ///
  Future<void> _showDataNegocio() async {

    if(this._lstDatsNegocio != null) return;

    Map<String, dynamic> info = altaUserSngt.toJsonPerfilContact();
    List<Widget> data = new List();
    double alto = 20;
    double isValido = 0;
    data.add(_tituloInfo('COMERCIO:'));
    data.add(Divider());
    String titulo = (info['razonSocial'] == null) ? 'Sin Datos' : info['razonSocial'];
    isValido = (info['razonSocial'] == null) ? (isValido + 0) : (isValido + 1);
    data.add(_tituloInfo('$titulo', txtColor: Colors.black87));
    data.add(SizedBox(height: alto));

    data.add(_tituloInfo('CONTACTO:'));
    data.add(Divider());
    titulo = (info['nombreContacto'] == null) ? 'Sin Datos' : info['nombreContacto'];
    isValido = (info['nombreContacto'] == null) ? (isValido + 0) : (isValido + 1);
    data.add(_tituloInfo('$titulo', txtColor: Colors.black87));
    data.add(SizedBox(height: alto));

    data.add(_tituloInfo('DOMILICIO:'));
    data.add(Divider());
    titulo = (info['domicilio'] == null) ? 'Sin Datos' : info['domicilio'];
    isValido = (info['domicilio'] == null) ? (isValido + 0) : (isValido + 1);
    data.add(_tituloInfo('$titulo', txtColor: Colors.black87));
    data.add(SizedBox(height: alto));

    Map<String, dynamic> loc;
    
    if(altaUserSngt.ciudad != null){
      loc = altaUserSngt.lstCiudades.firstWhere((cd){
        return (cd['c_id'] == altaUserSngt.ciudad);
      }, orElse: () => new Map());
    }
    data.add(_tituloInfo('CIUDAD:'));
    data.add(Divider());
    titulo = (altaUserSngt.ciudad == null) ? 'Sin Datos' : loc['c_nombre'];
    isValido = (altaUserSngt.ciudad == null) ? (isValido + 0) : (isValido + 1);
    data.add(_tituloInfo('$titulo', txtColor: Colors.black87));
    data.add(SizedBox(height: alto));

    if(altaUserSngt.colonia > 0){
      loc = altaUserSngt.lstColonias.firstWhere((col){
        return (col['cl_id'] == altaUserSngt.colonia);
      }, orElse: () => new Map());
    }
    data.add(_tituloInfo('COLONIA:'));
    data.add(Divider());
    titulo = (altaUserSngt.colonia == 0) ? 'Sin Datos' : loc['cl_nombre'];
    isValido = (altaUserSngt.colonia == 0) ? (isValido + 0) : (isValido + 1);
    data.add(_tituloInfo('$titulo', txtColor: Colors.black87));
    data.add(SizedBox(height: alto));

    data.add(_tituloInfo('TELÉFONO:'));
    data.add(Divider());
    titulo = (info['telsContac'] == null) ? 'Sin Datos' : info['telsContac'];
    isValido = (info['telsContac'] == null) ? (isValido + 0) : (isValido + 1);
    data.add(_tituloInfo('$titulo', txtColor: Colors.black87));
    data.add(SizedBox(height: alto));

    if(isValido >= 5) {
      this._isValid = this._isValid + isValido;
      this._iconDataNego = Icons.star;
    }
    this._lstDatsNegocio = _containerDataRaw(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data,
      )
    );
    Widget w = await _putStar();
    setState(() {
      this._estrellas = w;
    });
    w = null;
  }

  ///
  Future<void> _showMapAndOtros() async {

    if(this._lstMapOtros != null) return;

    List<Widget> data = new List();
    double alto = 20;

    data.add(_tituloInfo('SERVICIO A DOMICILIO:'));
    data.add(Divider());
    String titulo = (altaUserSngt.hasDelivery) ? 'SI' : 'NO';
    data.add(_tituloInfo(titulo, txtColor: Colors.black87));
    data.add(SizedBox(height: alto));

    data.add(_tituloInfo('ACEPTA PAGOS CON TARJETA:'));
    data.add(Divider());
    titulo = (altaUserSngt.pagoCard) ? 'SI' : 'NO';
    data.add(_tituloInfo(titulo, txtColor: Colors.black87));
    data.add(SizedBox(height: alto));

    data.add(_tituloInfo('UBICACIÓN:'));
    data.add(Divider());
    titulo = (altaUserSngt.latLng == null) ? 'Sin Datos' : altaUserSngt.latLng;
    data.add(_tituloInfo('$titulo', txtColor: Colors.black87));

    data.add(SizedBox(height: alto));

    if(altaUserSngt.latLng != null) {
      this._isValid = this._isValid + 1;
      this._iconMapOtros = Icons.star;
    }
    this._lstMapOtros = _containerDataRaw(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data,
      )
    );
    Widget w = await _putStar();
    setState(() {
      this._estrellas = w;
    });
    w = null;
  }

  ///
  Future<void> _showDataRSAndInternet() async {

    if(this._lstRsWeb != null) return;

    List<Widget> data = new List();
    double alto = 20;

    data.add(_tituloInfo('PÁGINA WEB:'));
    data.add(Divider());
    String titulo = (altaUserSngt.paginaWeb.isEmpty) ? 'Sin Página Web' : altaUserSngt.paginaWeb;
    data.add(_tituloInfo('$titulo', txtColor: Colors.black87));
    data.add(SizedBox(height: alto));

    data.add(_tituloInfo('EMAIL:'));
    data.add(Divider());
    titulo = (altaUserSngt.email.isEmpty) ? 'No cuenta con Email' : altaUserSngt.email;
    data.add(_tituloInfo('$titulo', txtColor: Colors.black87));
    data.add(SizedBox(height: alto));

    data.add(_tituloInfo('REDES SOCIALES:'));
    data.add(Divider());
    if(altaUserSngt.redSocs.isNotEmpty){
      altaUserSngt.redesSociales.forEach((rs){
        if(altaUserSngt.redSocs.containsKey(rs['slug'])){
          data.add(
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: _tituloInfo('${rs['titulo']}', txtColor: Colors.blue),
            )
          );
          for (var item in altaUserSngt.redSocs[rs['slug']]) {
            data.add(_tituloInfo('$item', txtColor: Colors.black87));
          }
        }
      });
    }

    this._isValid = this._isValid + 1;
    this._iconRsWev = Icons.star;
    this._lstRsWeb = _containerDataRaw(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data,
      )
    );
    Widget w = await _putStar();
    setState(() {
      this._estrellas = w;
    });
    w = null;
  }

  ///
  Future<Widget> _putStar() async {

    List<Widget> estrellas = new List();
    IconData icono;
    double sizeStar = 20;
    Color icocolor = Colors.amber[600];

    icono = (this._iconSistemas == null) ? Icons.star_border : this._iconSistemas;
    estrellas.add(Icon(icono, color: icocolor, size: sizeStar));
    icono = (this._iconPalClas == null) ? Icons.star_border : this._iconPalClas;
    estrellas.add(Icon(icono, color: icocolor, size: sizeStar));
    icono = (this._iconMarksMods == null) ? Icons.star_border : this._iconMarksMods;
    estrellas.add(Icon(icono, color: icocolor, size: sizeStar));
    icono = (this._iconDataNego == null) ? Icons.star_border : this._iconDataNego;
    estrellas.add(Icon(icono, color: icocolor, size: sizeStar));
    icono = (this._iconRsWev == null) ? Icons.star_border : this._iconRsWev;
    estrellas.add(Icon(icono, color: icocolor, size: sizeStar));
    icono = (this._iconMapOtros == null) ? Icons.star_border : this._iconMapOtros;
    estrellas.add(Icon(icono, color: icocolor, size: sizeStar));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: estrellas,
    );
  }

  ///
  Future<void> _saveData() async {

    int cantMaxDePuntos = (altaUserSngt.roles == 'ROLE_AUTOS') ? 8 : 10;

    if(this._isValid < cantMaxDePuntos) {
      String body = 'Por favor, revisa los datos que vas a enviar al servidor, ya que no estan completos.';
      await alertsVarios.entendido(this._context, titulo: 'DATOS INCOMPLETOS', body: body);
    }else{
      Map<String, dynamic> data = altaUserSngt.jsonToSend();
      alertsVarios.cargando(this._context);
      Map<String, dynamic> res = await asesoresHttp.saveAltaNuevoUser(data, Provider.of<DataShared>(this._context, listen: false).tokenAsesor['token']);
      Navigator.of(this._context).pop(false);

      if(res['abort']){
        await alertsVarios.entendido(this._context, titulo: asesoresHttp.result['msg'], body: asesoresHttp.result['body']);
      }else{
        // Eliminamos el singleton del alta.
        if(res['msg'] == 'hasData'){
          this._dataResultSave = new Map<String, dynamic>.from(res['body']);
        }
        setState(() {
          this._isSaved = true;
        });
      }
    }
  }

  ///
  Future<void> _saveFachada() async {

    if(tomarImagenesSngt.imagenAsset != null) {

      alertsVarios.cargando(this._context, titulo: 'FACHADA');
      bool res = await asesoresHttp.saveFachada(
        altaUserSngt.userId,
        await tomarImagenesSngt.getImageForSend(),
        Provider.of<DataShared>(this._context, listen: false).tokenAsesor['token']
      );
      Navigator.of(this._context).pop(false);
      if(!res){
        this._txtFachada = 'Asegurada';
        this._tituloDataSaved = 'IMAGEN GUARDADA';
        this._bodyDataSaved = 'Haz completado con éxito el alta del usuario.\n¿Qué deceas hacer ahora?';
        await emProcRoto.deleteProcesoRoto(nameBackup: 'altSoc');
        // Cuando se abre esta pantalla por recuperacion del proceso roto, el usuario del asesor es null
        if(Provider.of<DataShared>(this._context, listen: false).tokenAsesor['username'] == null){
          Navigator.of(this._context).pushNamedAndRemoveUntil('reg_index_page', (route) => false);
          return;
        }
        setState(() {
          this._isSavedFachada = true;
        });
      }else{
        await alertsVarios.entendido(this._context, titulo: asesoresHttp.result['msg'], body: asesoresHttp.result['body']);
      }
    }else{
      String body = 'Los datos ya fueron guardados con éxito, y el sistema no ha detectado una imagen '+
      'para la FACHADA.\n\n¿Estas segur@ de querer terminar el registro sin FACHADA?.';
      bool acc = await alertsVarios.aceptarCancelar(this._context, titulo: 'TERMINAR REGISTRO', body: body);
      if(acc){
        Navigator.of(this._context).pushNamedAndRemoveUntil('alta_index_menu_page', (route) => false);
      }
      return;
    }
  }
}