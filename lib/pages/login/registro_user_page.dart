import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/entity/usuario_entity.dart';
import 'package:zonamotora/https/asesores_http.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/config_gms_sngt.dart';
import 'package:zonamotora/utils/validadores.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/container_inputs.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/shared_preference_const.dart' as spConst;
import 'package:zonamotora/widgets/regresar_pagina_widget.dart' as regresarPagina;


class RegistroUserPage extends StatefulWidget {
  @override
  _RegistroUserPageState createState() => _RegistroUserPageState();
}

class _RegistroUserPageState extends State<RegistroUserPage> {

  AppBarrMy      appBarrMy     = AppBarrMy();
  AsesoresHttp   httpAsesores  = AsesoresHttp();
  MenuInferior   menuInferior  = MenuInferior();
  Validadores    validaores    = Validadores();
  AlertsVarios   alertsVarios  = AlertsVarios();
  ConfigGMSSngt  configGMSSngt = ConfigGMSSngt();
  UsuarioEntity  userEntity    = UsuarioEntity();
  UserRepository emUser        = UserRepository();

  Size _screen;
  BuildContext _context;
  GlobalKey<FormState> _frmkKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scafKey = GlobalKey<ScaffoldState>();

  TextEditingController _ctrlNombre = TextEditingController();
  TextEditingController _ctrlMovil = TextEditingController();
  TextEditingController _ctrlUser = TextEditingController();
  TextEditingController _ctrlPass = TextEditingController();

  FocusNode _focusNombre = FocusNode();
  FocusNode _focusMovil  = FocusNode();
  FocusNode _focusUser   = FocusNode();
  FocusNode _focusPass   = FocusNode();

  bool _oculatarPass = true;
  Map<String, dynamic> _params;

  List<Map<String, dynamic>> _lstTiposComercios = new List();
  String _tipoSeleccionado;
  bool _iniConfig = false;

  @override
  void dispose() {
    this._ctrlNombre.dispose();
    this._ctrlMovil.dispose();
    this._ctrlUser.dispose();
    this._ctrlPass.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    this._screen = MediaQuery.of(context).size;
    this._context = context;
    context = null;
    this._params = ModalRoute.of(this._context).settings.arguments;

    if(!this._iniConfig) {
      this._iniConfig = true;
      appBarrMy.setContext(this._context);
      if(this._params['source'] == 'user'){
        Provider.of<DataShared>(this._context, listen: false).setLastPageVisit('reg_index_page');
      }else{
        Provider.of<DataShared>(this._context, listen: false).setLastPageVisit('alta_index_menu_page');
      }

      configGMSSngt.setContext(this._context);
    }

    return Scaffold(
      key: this._scafKey,
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body:  WillPopScope(
        onWillPop: () => Future.value(false),
        child: _body(),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  /* */
  Widget _body() {

    String tituloLinkBackPage = (this._params['source'] == 'user') ? 'REGRESAR' : 'IR AL MENÚ DE OPCIONES';

    return CustomScrollView(
      slivers: <Widget>[
        appBarrMy.getAppBarrSliver(titulo: 'Registro de Usuario', bgContent: _cabecera()),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              regresarPagina.widget(this._context, tituloLinkBackPage, showBtnMenualta: false),
              FutureBuilder(
                future: _getTiposComercios(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(this._lstTiposComercios.length > 0) {
                    return Container(
                      width: this._screen.width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        widthFactor: this._screen.width,
                        child: _form(),
                      ),
                    );
                  }
                  return alertsVarios.cargandoStyleWidget(this._context, titulo: 'Recuperando...', body: 'Obteniendo los Tipos de Comercios permitidos actualmente.');
                },
              ),
            ]
          )
        )
      ],
    );
  }

  /* */
  Widget _cabecera() {

    return Center(
      child: Container(
        height: this._screen.width * 0.4,
        width: this._screen.width* 0.4,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(100)
        ),
        child: Image(
          image: AssetImage('assets/images/login.png'),
        ),
      ),
    );
  }

  /* */
  Future<void> _getTiposComercios() async {

    if(this._params['source'] == 'user'){
      this._lstTiposComercios = [{'role':'ROLE_PART', 'titulo' : 'USUARIO PARICULAR'}];
      this._tipoSeleccionado = this._lstTiposComercios[0]['role'];
      setState(() { });
    }
    if(this._lstTiposComercios.length == 0) {
      this._lstTiposComercios = await httpAsesores.getTiposDeSocios();
    }
  }

  /* */
  List<DropdownMenuItem<dynamic>> _createListTiposComercios() {

    List<DropdownMenuItem<dynamic>> lstTipos = new List();
    this._lstTiposComercios.forEach((Map<String, dynamic> tipo){
      lstTipos.add(
        DropdownMenuItem(
          child: Text(
            tipo['titulo']
          ),
          value: tipo['role'],
        )
      );
    });
    return lstTipos;
  }

  /* */
  Widget _form() {

    List<Widget> listInput = [
      _dropdownTipos(),
      _inputNombre(),
      _inputMovil(),
      _inputUser(),
      _inputPass(),
      _btnEnviar()
    ];

    ContainerInput containerInput = ContainerInput();

    return Form(
      key: this._frmkKey,
      child: containerInput.listWidgets(listInput, 'registro_ind')
    );
  }

  /* */
  Widget _dropdownTipos() {

    return DropdownButtonFormField(
      value: this._tipoSeleccionado,
      items: _createListTiposComercios(),
      onChanged: (valorSeleccionado) {
        this._tipoSeleccionado = valorSeleccionado;
        setState(() { });
        FocusScope.of(this._context).requestFocus(this._focusNombre);
      },
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(Icons.work),
        border: InputBorder.none
      ),
      validator: (val) {
        if(this._tipoSeleccionado == null) {
          return '     Que tipo de Relación Comercial';
        }
        return null;
      },
    );
  }

  /* */
  Widget _inputNombre() {

    return TextFormField(
      controller: this._ctrlNombre,
      focusNode: this._focusNombre,
      textInputAction: TextInputAction.next,
      obscureText: false,
      validator: (String val){
        val = val.toLowerCase();
        return _nombreIsValid(val);
      },
      onFieldSubmitted: (String val) {
        val = val.toLowerCase();
        FocusScope.of(this._context).requestFocus(this._focusMovil);
      },
      decoration: InputDecoration(
        hintText: 'Ej. mireya cervantes jiménez',
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(Icons.perm_identity),
        border: InputBorder.none
      ),
    );
  }

  /* */
  Widget _inputMovil() {

    return TextFormField(
      controller: this._ctrlMovil,
      focusNode: this._focusMovil,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      obscureText: false,
      validator: (String val){
        return _movilIsValid(val);
      },
      onFieldSubmitted: (String val) {
        val = val.toLowerCase();
        FocusScope.of(this._context).requestFocus(this._focusUser);
      },
      decoration: InputDecoration(
        hintText: 'Ej. 33 00 00 00 00',
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(Icons.phone_android),
        border: InputBorder.none
      ),
    );
  }

  /* */
  Widget _inputUser() {

    return TextFormField(
      controller: this._ctrlUser,
      focusNode: this._focusUser,
      textInputAction: TextInputAction.next,
      obscureText: false,
      validator: (String val){
        val = val.toLowerCase();
        return _userIsValid(val);
      },
      onFieldSubmitted: (String val) {
        val = val.toLowerCase();
        FocusScope.of(this._context).requestFocus(this._focusPass);
      },
      decoration: InputDecoration(
        hintText: 'Ej. mireya',
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(Icons.account_circle),
        border: InputBorder.none
      ),
    );
  }

  /* */
  Widget _inputPass() {

    return TextFormField(
      controller: this._ctrlPass,
      focusNode: this._focusPass,
      textInputAction: TextInputAction.done,
      obscureText: this._oculatarPass,
      validator: (String val){
        val = val.toLowerCase();
        return _passIsValid(val);
      },
      onFieldSubmitted: (String val) {
        val = val.toLowerCase();
      },
      decoration: InputDecoration(
        hintText: 'Ej. 1234567',
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(Icons.security),
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_red_eye),
          onPressed: () {
            setState(() {
              this._oculatarPass = !this._oculatarPass;
            });
          },
        ),
        border: InputBorder.none
      ),
    );
  }

    /* */
  String _nombreIsValid(String val) {

    val = val.trim();
    if(val.isEmpty) {
      return '   El Nombre es Requerido';
    }
    if(val.length < 5) {
      return '   Coloca mínimo 5 caracteres';
    }
    RegExp patron = RegExp(r'^[a-zA-Z\s*]+', multiLine: true);
    bool res = patron.hasMatch(val);
    if(!res) {
      return 'Coloca sólo letras, por favor';
    }
    patron = RegExp(r'^.+\s+[a-zA-Záéíóú]{3}', multiLine: true);
    res = patron.hasMatch(val);
    if(!res) {
      return 'Por lo menos un Apellido';
    }
    this._ctrlNombre.text = val;
    return null;
  }

    /* */
  String _movilIsValid(String val) {

    val = val.trim();
    if(val.isEmpty) {
      return '   El Celular es Requerido.';
    }
    if(val.length < 10) {
      return '   Coloca mínimo 10 dígitos';
    }
    RegExp patron = RegExp(r'^[\d*]+', multiLine: true);
    bool res = patron.hasMatch(val);
    if(!res) {
      return 'Coloca sólo numero, por favor';
    }
    List<String> partes = val.split(' ');
    if(partes.length > 0) {
      String newTel = '';
      partes.forEach((parte) {
        newTel += parte.trim();
      });
      val = newTel;
    }
    this._ctrlMovil.text = val;
    return null;
  }

  /* */
  String _userIsValid(String val) {

    val = val.trim();
    if(val.isEmpty) {
      return '   El usuario es requerido';
    }
    if(val.length < 5) {
      return '   Coloca mínimo 5 caracteres';
    }
    String res = validaores.revisarCamposDeTexto(val);
    if(res == null){
      this._ctrlUser.text = val;
    }
    return res;
  }

  /* */
  String _passIsValid(String val) {

    if(val.isEmpty) {
      return '   La contraseña es requerido';
    }
    if(val.length < 6) {
      return '   Coloca mínimo 6 caracteres';
    }
    return validaores.revisarCamposDeTexto(val);
  }

  /* */
  Widget _btnEnviar() {

    return RaisedButton.icon(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      color: Colors.black87,
      icon: Icon(Icons.settings_input_antenna, color: Colors.orange, size: 15,),
      label: Text(
        'REGISTRAR USUARIO',
        textScaleFactor: 1,
        style: TextStyle(
          fontSize: 19,
          color: Colors.grey
        ),
      ),
      onPressed: () async {
        bool ok = await _preSendForm();
        if(ok) {
          await _sendForm();
        }
      },
    );
  }

  /* */
  Future<bool> _preSendForm() async {

    if(this._frmkKey.currentState.validate()){

      String token = await configGMSSngt.getTokenDevice();
      if(token == null) {
        String msg = 'Éste dispositivo necesita enviar su token para las notificaciones, Inténtalo nuevamente por favor';
        await alertsVarios.entendido(this._context, titulo: 'Dispositivo Sin TOKEN', body: msg);
        return false;
      }
      await _hidratarEntityUser(token);
      return true;

    }else {

      this._scafKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'ERROR EN EL FORMULARIO',
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
      ));

      return false;
    }
  }

  /* */
  Future<void> _sendForm() async {

    bool accForAssesor = false;
    String saveAs = 'user';

    // Si es asesor mostramos Dialog para ver que qiere hacer.
    if(this._params['source'] != 'user') {
      FocusScope.of(this._context).requestFocus(new FocusNode());

      bool acc = await _verDialogForAsesor();
      if(acc == null) { return false; }

      accForAssesor = acc;
      // FALSE continuar  | TRUE reiniciar
      saveAs = (acc) ? 'user' : 'asesor';
    }

    alertsVarios.cargando(this._context);
    Map<String, dynamic> res = await emUser.registrarNewUser(userEntity.toJson(), saveAs);
    Navigator.of(this._context).pop();

    // Si hay errores en el resultado
    if(res.containsKey('abort') && res['abort']) {

      await alertsVarios.entendido(
        this._context,
        titulo: res['msg'],
        body: res['body']
      );
      return;
    }

    if(this._params['source'] == 'user') {

      _reiniciarApp(res['u_usname']);

    } else {

      if(accForAssesor){
        // El asesor desidio Reiniciar el sistema.
        _reiniciarApp(res['u_usname']);
      }else{
        // Continuar dando de alta
        Navigator.of(this._context).pushNamedAndRemoveUntil('alta_lst_users_page', (Route rutas) => false);
      }
    }
  }

  /*
   * Para un usuario particular y para el asesor cuando solo da de alta al usuario en el
   * dispositivo des mismo usuario.
  */
  Future<void> _reiniciarApp(String username) async {

    DataShared dataShared = Provider.of<DataShared>(this._context, listen: false);
    SharedPreferences sess = await SharedPreferences.getInstance();

    sess.setBool(spConst.sp_notif, true);

    dataShared.setUsername(username);
    dataShared.setsegReg(1);
    dataShared.setTokenAsesor(null);
    if(!dataShared.isConfigPush) {
      await configGMSSngt.initConfigGMS();
      await configGMSSngt.getTokenDevice();
    }
    await _checandoConfigFinal();
    await alertsVarios.entendido(
      this._context,
      titulo: 'REGISTRO REALIZADO',
      body: 'Tu registro fué un Éxito, el sistema se reinicilizará para configurar tu Aplicación',
      redirec: () async {
        Navigator.of(this._context).pushNamedAndRemoveUntil('init_config_page', (Route rutas) => true);
      }
    );
  }

  /* */
  Future<void> _hidratarEntityUser(String token) async {

    userEntity.hidratarFromForm(
      id: 0,
      movil: this._ctrlMovil.text,
      nombre: this._ctrlNombre.text,
      username: this._ctrlUser.text,
      password: this._ctrlPass.text,
      roles: this._tipoSeleccionado,
      tokenDevices: token,
      tokenServer: '0',
    );
  }

  /* */
  Future<bool> _verDialogForAsesor() async {

    return await showDialog(
      context: this._context,
      barrierDismissible: false,
      builder: (context) {
        double tamIcono = MediaQuery.of(context).size.width * 0.3;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: tamIcono,
                width: tamIcono,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(tamIcono),
                  border: Border.all(
                    color: Colors.grey[300],
                    width: 5
                  )
                ),
                child: Icon(Icons.thumb_up, size: 60, color: Colors.white),
              ),
              SizedBox(height: MediaQuery.of(context).size.aspectRatio * 20),
              Text(
                '¿QUÉ DESEAS HACER?',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                  fontSize: MediaQuery.of(context).size.aspectRatio * 35
                ),
                textAlign: TextAlign.center,
              ),
              Divider(),
              SizedBox(height: MediaQuery.of(context).size.aspectRatio * 30),
              InkWell(
                onTap: (){
                  Navigator.of(this._context).pop(true);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '[ TERMINAR Y REINICIAR ]',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Si estas usando el Celular del usuario y sólo lo estas Registrando.',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: (){
                  Navigator.of(this._context).pop(false);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '[ SEGUIR COMO ASESOR ]',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Selecciona esta opción si estás utilizando tu propio Celuar.',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  /*
   * Si es el asesor quien esta dando de alta un nuevo usuario, y este decide
   * reiniciar el sistema, quiere decir, que esta registrando un usuario en 
   * el celular de este, y solo para asegurarnos de que todo este bien...
   * 
   * Es necesario checar las bases de datos y eliminar el contenido, ya que posiblemente
   * el asesor este cambiando el usuario del dispositivo y halla residuos de informacion
   * del anterior usuario.
   * 
   * si el nuevo usuario desea recuperar su información entonces no se requiere de registro
   * nuevo si no mas bien, una recuperacion de cuenta.
   */
  Future<void> _checandoConfigFinal() async {

    // Sin Hacer
  }
}