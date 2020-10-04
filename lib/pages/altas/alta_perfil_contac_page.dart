import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/app_varios_repository.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/utils/validadores.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/bg_altas_stack.dart';
import 'package:zonamotora/widgets/container_inputs.dart';
import 'package:zonamotora/singletons/alta_user_sngt.dart';
import 'package:zonamotora/widgets/regresar_pagina_widget.dart' as regresarPagina;

class AltaPerfilContacPage extends StatefulWidget {
  @override
  _AltaPerfilContacPageState createState() => _AltaPerfilContacPageState();
}


class _AltaPerfilContacPageState extends State<AltaPerfilContacPage> {

  AppBarrMy appBarrMy       = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AlertsVarios alertsVarios = AlertsVarios();
  AltaUserSngt altaUserSngt = AltaUserSngt();
  Validadores validadores   = Validadores();
  BgAltasStack bgAltasStack = BgAltasStack();
  ContainerInput containerInputs = ContainerInput();
  AppVariosRepository emAppVarios = AppVariosRepository();
  UserRepository emUser = UserRepository();

  TextEditingController _ctrlNombreContacto = TextEditingController();
  TextEditingController _ctrlRazonSocial = TextEditingController();
  TextEditingController _ctrlDomicilio = TextEditingController();
  TextEditingController _ctrlTelContac = TextEditingController();

  FocusNode _focusNombreContacto = FocusNode();
  FocusNode _focusRazonSocial = FocusNode();
  FocusNode _focusDomicilio = FocusNode();
  FocusNode _focusTelContac = FocusNode();

  BuildContext _context;
  bool _isInit = false;
  bool _hasGps = false;
  int _cdSelect = 1;
  String _accionSubTitulo = 'DATOS DE CONTACTO';

  GlobalKey<ScaffoldState> _skfKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _frmKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterFirstLayout);

    Map<String, dynamic> data = altaUserSngt.toJsonPerfilContact();
    this._ctrlNombreContacto.text = (data['nombreContacto'] == null) ? '' : data['nombreContacto'];
    this._ctrlRazonSocial.text = (data['razonSocial'] == null) ? '' : data['razonSocial'];
    this._ctrlDomicilio.text = (data['domicilio'] == null) ? '' : data['domicilio'];
    this._ctrlTelContac.text = (data['telsContac'] == null) ? '' : data['telsContac'];
    this._cdSelect = (altaUserSngt.ciudad == null) ? 1 : altaUserSngt.ciudad;
    altaUserSngt.setCiudad(this._cdSelect);
    super.initState();
  }

  @override
  void dispose() {
    this._ctrlNombreContacto.dispose();
    this._ctrlRazonSocial.dispose();
    this._ctrlDomicilio.dispose();
    this._ctrlTelContac.dispose();
    altaUserSngt.isDowloadData = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    if(!this._isInit) {
      this._isInit = true;
      bgAltasStack.setBuildContext(this._context);
      Provider.of<DataShared>(this._context, listen: false).setLastPageVisit('alta_perfil_contac_page');
    }

    return Scaffold(
      key: this._skfKey,
      appBar: appBarrMy.getAppBarr(titulo: 'Alta de ${altaUserSngt.usname.toUpperCase()}'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Container(
          width: MediaQuery.of(this._context).size.width,
          height: MediaQuery.of(this._context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.red
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
          ),
          child: Column(
            children: [
              regresarPagina.widget(this._context, 'alta_lst_users_page', lstMenu: altaUserSngt.crearMenuSegunRole()),
              (!altaUserSngt.isDowloadData)
              ?
              LinearProgressIndicator()
              :
              SizedBox(height: 0),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _crearLstInputs(),
                ),
              ),
            ]
          )
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  Future<void> _afterFirstLayout(_) async {

    if(!this._isInit) {
      this._isInit = true;
      String ruta = 'alta_mksmds_page';
      if(altaUserSngt.roles == 'ROLE_AUTOS'){
        ruta = 'alta_lst_users_page';
      }
      Provider.of<DataShared>(this._context, listen: false).setLastPageVisit(ruta);
    }

    await _revisarSiExistenDatosRegistrados();
    await _getPosicionGPS();
  }

  ///
  Future<void> _getPosicionGPS() async {

    LocationPermission permisos = await checkPermission();
    if(LocationPermission.always == permisos){
      Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
      if(placemark.length > 0){
        if(this._ctrlDomicilio.text == null && altaUserSngt.direccionForMap == null) {
          this._ctrlDomicilio.text = '${placemark.first.thoroughfare} ${placemark.first.subThoroughfare}';
        }
        this._hasGps = true;
      }
    }
  }

  ///
  Future<bool> _checkGPS() async {

    if(!this._hasGps){
      String body = 'Habilita el servicio de GPS del dispositivo para captura las coordenas de ubucación, ya habilitado, preciona CONTINUAR.';
      bool acc = await alertsVarios.aceptarCancelar(this._context, titulo: 'SERVICIO DE UBICACIÓN', body: body);
      if(acc) {
        await _getPosicionGPS();
        return false;
      }
      return false;
    }else{
      return true;
    }
  }

  ///
  Future<bool> _procesarFormulario() async {

    if(this._frmKey.currentState.validate()) {

      altaUserSngt.hidratarPerfilContacSgtn(
        id: altaUserSngt.getIdPerfil(),
        nombreContacto: this._ctrlNombreContacto.text,
        razonSocial: this._ctrlRazonSocial.text,
        domicilio: this._ctrlDomicilio.text,
        telsContac: this._ctrlTelContac.text,
      );
      
      return true;
    }else{

      this._skfKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'ERROR EN EL FORMULARIO',
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
            fontSize: 17
          ),
        ),
        backgroundColor: Colors.red,
      ));
    }
    return false;
  }

  ///
  Widget _crearLstInputs() {

    List<Widget> listInputs = [
      SizedBox(
        width: MediaQuery.of(this._context).size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Column(
              children: [
                Text(
                  '[1/3] Perfil de Usuario',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17
                  ),
                ),
                Text(
                  this._accionSubTitulo,
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.red[100]
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      _inputNombreContacto(),
      _inputRasonSocial(),
      _selectCiudades(),
      _intpuDomicilio(),
      _intpuTelsContac(),
      const SizedBox(height: 30),
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
            bool res = await _procesarFormulario();
            if(res) {
              if(await _checkGPS()) {
                if(this._cdSelect != altaUserSngt.ciudad) {
                  altaUserSngt.lstColonias = new List();
                }
                altaUserSngt.setCiudad(this._cdSelect);
                altaUserSngt.isDowloadData = true;                
                Navigator.of(this._context).pushReplacementNamed('alta_perfil_pwrs_page');
              }
            }
          },
        ),
      ),
      const SizedBox(height: 20),
    ];

    return Form(
      key: this._frmKey,
      child: containerInputs.container(listInputs, 'perfil_contact', labelColor: Colors.grey[200]),
    );
  }

  ///
  Widget _inputNombreContacto() {

    return TextFormField(
      controller: this._ctrlNombreContacto,
      focusNode: this._focusNombreContacto,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.person_outline)
      ),
      validator: (String val){
        String error;
        error = validadores.notNull(val, 'Contacto');
        if(error == null) {
          error = validadores.hasApellido(val);
        }
        return error;
      },
      onFieldSubmitted: (String val){
        FocusScope.of(this._context).requestFocus(this._focusRazonSocial);
      },
    );
  }

  ///
  Widget _inputRasonSocial() {

    return TextFormField(
      controller: this._ctrlRazonSocial,
      focusNode: this._focusRazonSocial,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.business)
      ),
      validator: (String val){
        String error;
        error = validadores.notNull(val, 'Nombre del Negocio');
        if(error == null) {
          error = validadores.longitudMinima(val, 5);
        }
        return error;
      },
      onFieldSubmitted: (String val){
        FocusScope.of(this._context).requestFocus(this._focusDomicilio);
      },
    );
  }

  ///
  Widget _intpuDomicilio(){

    return TextFormField(
      controller: this._ctrlDomicilio,
      focusNode: this._focusDomicilio,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.person_pin_circle)
      ),
      validator: (String val){
        String error;
        error = validadores.notNull(val, 'Domicilio');
        if(error == null) {
          error = validadores.domicilio(val);
        }
        return error;
      },
      onFieldSubmitted: (String val){
        FocusScope.of(this._context).requestFocus(this._focusTelContac);
      },
    );
  }

  ///
  Widget _intpuTelsContac(){

    return TextFormField(
      controller: this._ctrlTelContac,
      focusNode: this._focusTelContac,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.phone_in_talk)
      ),
      validator: (String val){
        String error;
        if(val.length > 0){
          val = val.replaceAll(' ', '');
          setState(() {
            this._ctrlTelContac.text = val;
          });
          error = validadores.telefono(val, 10);
        }
        return error;
      },
      onFieldSubmitted: (String val){
        if(val.length > 0){
          val = val.replaceAll(' ', '');
          setState(() {
            this._ctrlTelContac.text = val;
          });
        }
        FocusScope.of(this._context).requestFocus(new FocusNode());
      },
    );
  }

  ///
  Widget _selectCiudades() {

    return FutureBuilder(
      future: _getCiudades(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(altaUserSngt.lstCiudades.length > 0) {
          return DropdownButtonFormField(
            items: _crearOptionSelectCiudades(),
            value: this._cdSelect,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
              icon: Icon(Icons.map),
            ),
            onChanged: (val){
              setState(() {
                this._cdSelect = val;
              });
            },
          );
        }
        return Text(
          'Cangando Ciudades'
        );
      },
    );
  }

  ///
  Future<void> _getCiudades() async {

    if(altaUserSngt.lstCiudades.length > 0) return;
    List<Map<String, dynamic>> cds = await emAppVarios.getCiudades();
    if(cds.first.containsKey('error')){
      alertsVarios.entendido(this._context, titulo: emAppVarios.result['msg'], body: emAppVarios.result['body']);
      return;
    }
    altaUserSngt.lstCiudades = cds;
    cds = null;
  }

  ///
  List<DropdownMenuItem> _crearOptionSelectCiudades() {

    List<DropdownMenuItem> ciudades = new List();
    altaUserSngt.lstCiudades.forEach((ciudad){
      ciudades.add(
        DropdownMenuItem(
          child: Text(
            '${ciudad['c_nombre']}'
          ),
          value: ciudad['c_id'],
        )
      );
    });

    return ciudades;
  }

  ///
  Future<void> _revisarSiExistenDatosRegistrados() async {
    
    if(altaUserSngt.isDowloadData){ return false; }
    if(altaUserSngt.isBack){
      setState(() {
        altaUserSngt.isDowloadData = true;
      });
      return false;
    }
    setState(() {
      this._accionSubTitulo = 'BUSCANDO DATOS EXISTENTES...';
    });
    String tokenAsesor =  Provider.of<DataShared>(this._context, listen: false).tokenAsesor['token'];
    Map<String, dynamic> result = await emUser.getDatosUserByFile(altaUserSngt.userId, altaUserSngt.usname, tokenAsesor);
    tokenAsesor = null;

    if(result['body'] != null){
      Map<String, dynamic> dataUser = new Map<String, dynamic>.from(result['body']);
      result = null;

      if(dataUser.containsKey('perfil')){

        altaUserSngt.hidratarPerfilContacSgtn(
          id: dataUser['perfil']['id'],
          razonSocial: dataUser['perfil']['razonSocial'],
          domicilio: dataUser['perfil']['domicilio'],
          nombreContacto: dataUser['perfil']['nombreContacto'],
          telsContac: dataUser['perfil']['telsContac'][0]
        );
        
        altaUserSngt.setColonia(dataUser['perfil']['colonia']);
        altaUserSngt.setHasDelivery(dataUser['perfil']['hasDelivery']);
        altaUserSngt.setPagoCard(dataUser['perfil']['pagoCard']);
        altaUserSngt.setEmail(dataUser['perfil']['email']);
        altaUserSngt.setLatLng(dataUser['perfil']['latLng']);
        altaUserSngt.setSistemSelect(new Set<int>.from(dataUser['sistemas']));
        altaUserSngt.mrksSelect = new Set<int>.from(dataUser['marcas']);
        altaUserSngt.mdsSelect = new Set<int>.from(dataUser['modelo']);
        dataUser = null;
        setState(() {
          this._accionSubTitulo = 'DATOS DE CONTACTO';
        });
        Navigator.of(this._context).pushReplacementNamed('alta_perfil_contac_page');
      }
    }
    altaUserSngt.isBack = true;
    altaUserSngt.isDowloadData = true;
  }

}