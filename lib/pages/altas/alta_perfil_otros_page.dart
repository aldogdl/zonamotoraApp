import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/app_varios_repository.dart';
import 'package:zonamotora/singletons/alta_user_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/bg_altas_stack.dart';
import 'package:zonamotora/widgets/container_inputs.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/regresar_pagina_widget.dart' as regresarPagina;
import 'package:zonamotora/utils/validadores.dart';

class AltaPerfilOtrosPage extends StatefulWidget {
  @override
  _AltaPerfilOtrosPageState createState() => _AltaPerfilOtrosPageState();
}

class _AltaPerfilOtrosPageState extends State<AltaPerfilOtrosPage> {

  AppBarrMy appBarrMy       = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AlertsVarios alertsVarios = AlertsVarios();
  AltaUserSngt altaUserSngt = AltaUserSngt();
  Validadores validadores   = Validadores();
  BgAltasStack bgAltasStack = BgAltasStack();
  ContainerInput containerInputs = ContainerInput();
  AppVariosRepository emAppVarios= AppVariosRepository();

  TextEditingController _ctrlNombre = TextEditingController();
  TextEditingController _ctrlAlias = TextEditingController();
  FocusNode _focusNombre = FocusNode();
  FocusNode _focusAlias = FocusNode();

  BuildContext _context;
  bool _isInit = false;
  bool _geoPermitida = false;
  String _latLng;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  GlobalKey<ScaffoldState> _skfKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _frmKey = GlobalKey<FormState>();
  GlobalKey _keyBoxBuscador = GlobalKey();
  RenderBox _inputBskPosition;
  ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _lstTmpColonias = new List();
  String lastUri;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  Future<void> _afterLayout(_) async {
    this._inputBskPosition = this._keyBoxBuscador.currentContext.findRenderObject();
  }

  @override
  void dispose() {
    this._ctrlNombre.dispose();
    this._ctrlAlias.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;

    if(!this._isInit) {
      this._isInit = true;
      _permisosDeLocalizacion();
      bgAltasStack.setBuildContext(this._context);
      if(altaUserSngt.lstColonias.length != 0){
        this._lstTmpColonias = altaUserSngt.lstColonias;
      }
      lastUri = Provider.of<DataShared>(this._context, listen: false).lastPageVisit;
      Provider.of<DataShared>(this._context, listen: false).setLastPageVisit('alta_perfil_otros_page');
    }

    return Scaffold(
      key: this._skfKey,
      appBar: appBarrMy.getAppBarr(titulo: 'Alta de ${altaUserSngt.usname.toUpperCase()}'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () {
          if(lastUri != null){
            Navigator.of(this._context).pushReplacementNamed(lastUri);
          }
          return Future.value(false);
        },
        child: SingleChildScrollView(
          controller: this._scrollController,
          child: _body()
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  Widget _body() {

    bool isSmall = (MediaQuery.of(this._context).size.height <= 550) ? true : false;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        ///
        regresarPagina.widget(this._context, 'alta_perfil_pwrs_page', lstMenu: altaUserSngt.crearMenuSegunRole()),
        bgAltasStack.stackWidget(
          titulo: '[3/3] Perfil del Usuario', subtitulo: 'DATOS DE CONTACTO',
          altoMax: 0.11,
          widgetTraslapado_1: const SizedBox(height: 0),
          widgetTraslapado_2: (isSmall) ? const SizedBox(height: 0) : _icoRuta()
        ),
        const SizedBox(height: 20),
        _chkPagoTarjeta(),
        _chkDelivery(),
        _chkGeo(),
        Divider(),
        Text(
          (this._latLng != null) ? this._latLng : 'Sin coordenadas de localización',
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.red[400],
            fontSize: 14
          ),
        ),
        Divider(),
        ///Buscador de Colonias
        _inputBuscador(),
        /// Contenedor de Colonias
        FutureBuilder(
          future: _getColonias(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(altaUserSngt.lstColonias.length > 0) {
              return _createListColonias();
            }
            return Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            );
          },
        ),
        const SizedBox(height: 10),
        _ayudaTecnica(),
        SizedBox(
          height: 50,
          width: MediaQuery.of(this._context).size.width * 0.8,
          child: RaisedButton.icon(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            icon: Icon(Icons.save),
            label: Text(
              'Siguiente',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 18
              ),
            ),
            onPressed: () async {
              bool isValid = false;
              if(altaUserSngt.colonia != null){
                if(altaUserSngt.colonia != 0){
                  isValid = true;
                }
              }
              if(!isValid) {
                await alertsVarios.entendido(
                  this._context,
                  titulo: 'LA COLONIA',
                  body: 'Es necesario que selecciones una colonia para CONTINUAR con el REGISTRO del usuario'
                );
              }
              if(this._latLng == null){
                isValid = false;
                await alertsVarios.entendido(
                  this._context,
                  titulo: 'LA LOCALIZACIÓN',
                  body: 'Es necesario que especifiques una Localización para CONTINUAR con el REGISTRO del usuario'
                );
              }
              
              if(isValid) {
                altaUserSngt.setLatLng(this._latLng);
                Navigator.of(this._context).pushReplacementNamed('alta_save_resum_page');
              }
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  ///
  Widget _icoRuta() {

    return Positioned(
      top: 40,
      child: SizedBox(
        height: 180,
        width: MediaQuery.of(this._context).size.width,
        child: Image(
          image: AssetImage('assets/images/donde_ir.png'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  ///
  Widget _ayudaTecnica() {

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(this._context).size.width * 0.13,
        vertical: 10
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'AYUDA TÉCNICA',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red[400],
              letterSpacing: 2
            ),
          ),
          Divider(),
          Text(
            '> EDITAR COLONIA',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[800]
            ),
          ),
          Text(
            'Manten presionado el nombre de la colonia que deseas cambiar.',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.grey[600]
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '> CAMBIAR DE CIUDAD',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[800]
            ),
          ),
          Text(
            'Manten presionado el LINK de [Agregar Colonia].',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.grey[600]
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget _chkPagoTarjeta() {

    return SwitchListTile(
      title: Text(
        '¿Acepta Pagos con Tarjeta?',
        textScaleFactor: 1,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (bool val){
        setState(() {
          altaUserSngt.setPagoCard(val);
        });
      },
      value: altaUserSngt.pagoCard,
      activeColor: Colors.orangeAccent,
      activeTrackColor: Colors.black,
    );
  }

  ///
  Widget _chkDelivery() {

    return SwitchListTile(
      title: Text(
        '¿Maneja Servicio a Domicilio?',
        textScaleFactor: 1,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (bool val){
        setState(() {
          altaUserSngt.setHasDelivery(val);
        });
      },
      value: altaUserSngt.hasDelivery,
      activeColor: Colors.orangeAccent,
      activeTrackColor: Colors.black,
    );
  }

  ///
  Widget _chkGeo() {

    return SwitchListTile(
      title: Text(
        (this._geoPermitida) ? 'La Localización está Activada' : 'Activa el GPS',
        textScaleFactor: 1,
        style: TextStyle(
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 1,
              offset: Offset(1,1)
            )
          ]
        ),
      ),
      onChanged: (bool val) async {

        LocationPermission permisos = await checkPermission();
        if(LocationPermission.always == permisos){
          if(!val){
            this._latLng = null;  
          }else{
            _permisosDeLocalizacion();
          }
          setState(() {
            this._geoPermitida = val;
          });
        }
      },
      value: this._geoPermitida,
      activeColor: Colors.orangeAccent,
      activeTrackColor: Colors.black,
      subtitle: (this._latLng != null)
        ?RaisedButton(
          color: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          child: Text(
            'AFINAR LOCALIZACIÓN',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white
            ),
          ),
          onPressed: () {
            _crearMarcadorMap();
            _dialogMap();
          },
        )
        : Text(''),
    );
  }

  ///
  void _dialogMap() async {

    List<String> pedazos = this._latLng.split(',');

    await showDialog(
      context: this._context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          contentPadding: EdgeInsets.all(2),
          content: Stack(
            children: <Widget> [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: CameraPosition(
                    bearing:90,
                    tilt: 0,
                    zoom: 22,
                    target: LatLng(
                      double.tryParse(pedazos[0]), double.tryParse(pedazos[1]),
                    ),
                  ),
                  mapToolbarEnabled: true,
                  markers: Set<Marker>.of(markers.values),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(this._context).pop(false),
                  ),
                ),
              ),
            ]
          ),
        );
      }
    );
  }

  ///
  Future<void> _permisosDeLocalizacion() async {

    LocationPermission permisos = await checkPermission();
    
    if(LocationPermission.always == permisos){
      this._geoPermitida = true;
    }
    Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(altaUserSngt.direccionForMap != null){
      setState(() {
        this._latLng = '${position.latitude}, ${position.longitude}';
      });
    }    
    _crearMarcadorMap();
  }

  ///
  void _crearMarcadorMap() {

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    final MarkerId markerId = MarkerId(markerIdVal);

    if(this._latLng != null) {
      List<String> coords = this._latLng.split(',');
      final Marker marker = Marker(
        markerId: markerId,
        draggable: true,
        flat: false,
        zIndex: 20,
        position: LatLng(
          double.tryParse(coords[0].trim()),
          double.tryParse(coords[1].trim()),
        ),
        onDragEnd: (LatLng position) {
          final Marker tappedMarker = markers[markerId];
          if (tappedMarker != null) {
            setState(() {
              this._latLng = '${position.latitude}, ${position.longitude}';
            });
          }
        },
      );

      markers[markerId] = marker;
    }

  }

  ///
  Widget _createListColonias() {

    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(this._context).size.width * 0.065),
      width: MediaQuery.of(this._context).size.width,
      height: MediaQuery.of(this._context).size.height * 0.3,
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      child: ListView(
        children: _createListTitlesColonias()
      ),
    );
  }

  ///
  List<Widget> _createListTitlesColonias() {

    List<Widget> lstTitleColonias = new List();
    IconData iconoSec;
    Color iconoMainColor;
    Color nomCol;

    /// Link para Agregar nuevas colonias.
    lstTitleColonias.add(
      ListTile(
        leading: Icon(Icons.add_circle),
        title: Text(
          'Agregar Colonia',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.blue
          ),
        ),
        subtitle: Text(
          '${altaUserSngt.getNombreCiudadById()}',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.green
          ),
        ),
        trailing: Icon(Icons.scatter_plot),
        onTap: (){
          /// Agregamos nueva colonia
          this._ctrlNombre.text = '';
          this._ctrlAlias.text = '';
          _showHojaInfGestionColonias(null);
        },
        onLongPress: () async {
          /// Cambiamos de ciudad
          await alertsVarios.aceptarCancelar(
            this._context,
            titulo: 'CAMBIAR CIUDAD',
            body: 'Al presionar CONTINUAR podrás realizar el cambio de ciudad.',
            forceClose: true,
            redirec: () => Navigator.of(this._context).pushNamedAndRemoveUntil('alta_perfil_contac_page', (Route rutas) => false)
          );
        },
      )
    );

    this._lstTmpColonias.forEach((colonia){

      // verificar si esta seleccionada para pintarla de otro color
      if(altaUserSngt.colonia == colonia['cl_id']){
        iconoSec = Icons.check_circle;
        iconoMainColor = Colors.green;
        nomCol = Colors.red;
      } else{
        iconoSec = Icons.scatter_plot;
        iconoMainColor = Colors.grey[400];
        nomCol = Colors.grey;
      }

      lstTitleColonias.add(
        ListTile(
          dense: true,
          leading: Icon(Icons.map, color: iconoMainColor),
          title: Text(
            '${colonia['cl_nombre']}',
            textScaleFactor: 1.2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: nomCol
            ),
          ),
          subtitle: Text(
            (colonia['cl_alias'] == '0') ? 'Puedes Agregar Alias' : '${colonia['cl_alias']}',
            textScaleFactor: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Icon(iconoSec, color: Colors.orange),
          onTap: (){
            setState(() {
              altaUserSngt.setColonia(colonia['cl_id']);
            });
          },
          onLongPress: (){
            this._ctrlNombre.text = colonia['cl_nombre'];
            this._ctrlAlias.text = colonia['cl_alias'];
            _showHojaInfGestionColonias(colonia['cl_id']);
          },
        )
      );
    });

    return lstTitleColonias;
  }

  ///
  Future<void> _getColonias() async {

    if(altaUserSngt.lstColonias.length == 0){
      List<Map<String, dynamic>> colonias = await emAppVarios.getColonias(altaUserSngt.ciudad);
      if(colonias.length > 0){
        if(colonias.first.containsKey('error')) {
          alertsVarios.entendido(this._context, titulo: 'ERROR DESCONOCIDO', body: 'Regresa a la página anterior, y vuelve aquí para reintentar nuevamente la petición, por favor');
          return;
        }
      }
      altaUserSngt.lstColonias = colonias;
      this._lstTmpColonias = colonias;
      colonias = null;
    }
    return;
  }

  ///
  Future<void> _showHojaInfGestionColonias(int idColonia) async {

    this._skfKey.currentState.showBottomSheet(
      (BuildContext context) => SingleChildScrollView(child: _hojaInfGestionColonias(idColonia)),
      elevation: 10
    );
  }

  ///
  Widget _hojaInfGestionColonias(int idColonia) {

    Map<String, dynamic> item;
    String txtAcc = 'AGREGAR';
    String subTit = '';

    /// tomamos los valores correspondientes dependiendo de la accion a realizar.
    if(idColonia != null) {
      item = altaUserSngt.lstColonias.firstWhere((colonia){
        return (colonia['cl_id'] == idColonia);
      }, orElse: () => new Map());
      subTit = item['cl_nombre'];
      item = null;
      txtAcc = 'EDITAR';
    }else{
      item = altaUserSngt.lstCiudades.firstWhere((ciudad){
        return (ciudad['c_id'] == altaUserSngt.ciudad);
      }, orElse: () => new Map());
      subTit = (item.isNotEmpty) ? 'a... ${item['c_nombre']}' : 'ERROR, Sin Ciudad';
      item = null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Center(
          child: Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(0),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.red[50], width: 3)
            ),
            child: Image(
              image: AssetImage('assets/images/mapa-google.png'),
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '$txtAcc COLONIA',
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red
          ),
        ),
        Text(
          '$subTit',
          textScaleFactor: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.red[200]
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: this._frmKey,
            child: _createLstInputs(),
          ),
        ),
        const SizedBox(height: 10),
        // ACCIONES
        _accionesFrmGestionColonias(txtAcc, idColonia),
        const SizedBox(height: 10),
      ],
    );
  }

  /// GUARDAR | EDITAR colonias acc del formulario
  Widget _accionesFrmGestionColonias(String txtAcc, int idColonia) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton(
          child: Text(
            'CANCELAR',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold
            ),
          ),
          onPressed: (){
            Navigator.of(this._context).pop(false);
          },
        ),
        SizedBox(
          width: 100,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.blue,
            textColor: Colors.white,
            child: Text(
              '$txtAcc',
              textScaleFactor: 1,
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            onPressed: () async {
              if(this._frmKey.currentState.validate()) {
                Map<String, dynamic> newColonia = {
                  'nombre': this._ctrlNombre.text,
                  'alias' : this._ctrlAlias.text,
                  'idCd'  : altaUserSngt.ciudad,
                  'idCol' : (idColonia == null) ? 0 : idColonia,
                };
                Map<String, dynamic> tokenAsesor = Provider.of<DataShared>(this._context, listen: false).tokenAsesor;

                String body = 'Se está ENVIANDO la nueva Colonia, por favor, espera un momento.';
                alertsVarios.cargando(this._context, titulo: 'GUARDANDO...', body: body);
                Map<String, dynamic> res = await emAppVarios.setColonia(newColonia, tokenAsesor['token']);
                Navigator.of(this._context).pop(false);
                if(res.containsKey('error')){
                  await alertsVarios.entendido(this._context, titulo: emAppVarios.result['msg'], body: emAppVarios.result['body']);
                }else{
                  if(newColonia['idCol'] == 0){
                    altaUserSngt.lstColonias.add(res['body']);
                  }else{
                    int index = altaUserSngt.lstColonias.indexWhere((colonia) => (colonia['cl_id'] == newColonia['idCol']));
                    altaUserSngt.lstColonias[index] = res['body'];
                    newColonia = new Map();
                  }
                  setState(() {
                    Navigator.of(this._context).pop(false);
                  });
                }
              }
            },
          ),
        )
      ],
    );
  }
  
  ///
  Widget _createLstInputs() {

    List<Widget> listInputs = [
      _inputNombre(),
      _inputAlias(),
    ];

    return containerInputs.listWidgets(listInputs, 'colonias');
  }

  ///
  Widget _inputBuscador() {
    
    return Container(
      key: this._keyBoxBuscador,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(5),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          icon: Icon(Icons.search, size: 35),
          border: InputBorder.none,
        ),
        onChanged: (String txt) {
          if(this._inputBskPosition.localToGlobal(Offset.zero).dy < (MediaQuery.of(this._context).size.height * 0.69)){
            this._scrollController.animateTo(
              MediaQuery.of(this._context).size.height * 0.69,
              duration: Duration(microseconds: 500),
              curve: Curves.ease
            );
          }
          this._lstTmpColonias = new List();
          altaUserSngt.lstColonias.forEach((colonia) {
            if(colonia['cl_nombre'].toLowerCase().contains(txt.toLowerCase())){
              this._lstTmpColonias.add(colonia);
              _createListTitlesColonias();
            }
          });
          setState(() {});
        },
      ),
    );
  }

  ///
  Widget _inputNombre() {

    return TextFormField(
      controller: this._ctrlNombre,
      focusNode: this._focusNombre,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        icon: Icon(Icons.place),
        border: InputBorder.none
      ),
      onFieldSubmitted: (String val){
        FocusScope.of(this._context).requestFocus(this._focusAlias);
      },
      validator: (String val) {
        if(val.isEmpty) {
          return 'Coloca el nombre de la Colonia.';
        }
        if(val.length <= 3) {
          return 'Se más específico en el nombre.';
        }
        return null;
      },
    );
  }

  ///
  Widget _inputAlias() {

    return TextFormField(
      controller: this._ctrlAlias,
      focusNode: this._focusAlias,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        icon: Icon(Icons.map),
        border: InputBorder.none
      ),
      validator: (String val) {
        if(val.isNotEmpty){
          if(val.length <= 3) {
            return 'Se más específico con el Alias.';
          }
        }
        return null;
      },
      onFieldSubmitted: (String val){
        this._frmKey.currentState.validate();
      },
    );
  }


}