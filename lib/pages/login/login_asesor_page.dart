import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/https/asesores_http.dart';
import 'package:zonamotora/utils/validadores.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/container_inputs.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';

import 'package:zonamotora/widgets/regresar_pagina_widget.dart' as regresarPagina;

class LoginAsesorPage extends StatefulWidget {
  @override
  _LoginAsesorPageState createState() => _LoginAsesorPageState();
}

class _LoginAsesorPageState extends State<LoginAsesorPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  Validadores validaores = Validadores();
  AlertsVarios alertsVarios = AlertsVarios();
  AsesoresHttp httpAsesores = AsesoresHttp();
  ContainerInput containerInput = ContainerInput();

  Size _screen;
  BuildContext _context;
  GlobalKey<FormState> _frmkKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scafKey = GlobalKey<ScaffoldState>();
  TextEditingController _ctrlPass = TextEditingController();
  FocusNode _focusPass = FocusNode();
  bool _oculatarPass = true;
  String _asesorSelect;
  bool _isInit = false;
  String lastUri;
  List<Map<String, dynamic>> _asesores = new List();

  @override
  void dispose() {
    this._ctrlPass?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(!this._isInit){
      this._isInit = true;
      this._screen = MediaQuery.of(context).size;
      this._context = context;
      context = null;
      lastUri = Provider.of<DataShared>(this._context, listen: false).lastPageVisit;
      Provider.of<DataShared>(this._context, listen: false).setLastPageVisit('login_asesor_page');
    }

    return Scaffold(
      key: this._scafKey,
      appBar: appBarrMy.getAppBarr(titulo: 'Autenticación Asesor'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: (){
          if(lastUri != null){
            Navigator.of(this._context).pushReplacementNamed(lastUri);
          }
          return Future.value(false);
        },
        child: _body(),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  /* */
  Widget _body() {

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _cabecera(),
          regresarPagina.widget(this._context, lastUri, showBtnMenualta: false),
          FutureBuilder(
            future: _getAsesores(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(this._asesores.length > 0) {
                return _form();
              }
              return alertsVarios.cargandoStyleWidget(this._context, titulo: 'RECUPERANDO ASESORES');
            },
          ),
        ],
      ),
    );
  }
  
  /* */
  Widget _cabecera() {

    double altoAspectRadio = 0.01;
    double radioIco = this._screen.width * 0.4;

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          width: this._screen.width,
          height: this._screen.height * 0.32,
          decoration: BoxDecoration(
            color: Color(0xff7C0000)
          ),
          child: SizedBox(height: 30),
        ),

        Positioned(
          top: this._screen.height * altoAspectRadio,
          width: this._screen.width,
          child: Center(
            child: Container(
              height: this._screen.width * 0.4,
              width: this._screen.width* 0.4,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(100)
              ),
              child: Image(
                image: AssetImage('assets/images/asesor.png'),
              ),
            ),
          )
        ),

        Positioned(
          top: (this._screen.width * altoAspectRadio) + (radioIco + 10),
          width: this._screen.width,
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  'ACCESO RESTRINGIDO',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            )
          )
        )
      ],
    );
  }

  /* */
  Widget _form() {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      child: Center(
        child: Form(
          key: this._frmkKey,
          child: _lstInputs()
        )
      ),
    );
  }

  /* */
  Widget _lstInputs() {

    List<Widget> listInputs = [
      _createInputUsers(),
      _createInputPass(),
      _btnSend(),
    ];

    return containerInput.listWidgets(listInputs, 'login');
  }

  ///
  Widget _btnSend() {

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      color: Colors.black87,
      icon: Icon(Icons.settings_input_antenna, color: Colors.orange, size: 15,),
      label: Text(
        'AUTORIZAR ACCESO',
        textScaleFactor: 1,
        style: TextStyle(
          fontSize: 19,
          color: Colors.grey
        ),
      ),
      onPressed: () async {
        await _sendForm();
      },
    );
  }
  
  /* */
  Widget _createInputUsers() {

    return DropdownButtonFormField(
      value: this._asesorSelect,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: '¿Quien eres tu?',
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(Icons.supervised_user_circle),
        border: InputBorder.none,
      ),
      validator: (val){
        if(val == null){
          return '     Selecciona tu Usuario';
        }
        return null;
      },
      items: _crearItemsUsers(),
      onChanged: (val){
        this._asesorSelect = val;
        setState(() {});
        FocusScope.of(this._context).requestFocus(this._focusPass);
      },
    );
  }

  /* */
  List<DropdownMenuItem> _crearItemsUsers() {

    List<DropdownMenuItem> usersItems = new List();
    this._asesores.forEach((user){
      usersItems.add(
        DropdownMenuItem(
          value: user['a_username'],
          child: Text(
            '${user['a_username']}',
            textScaleFactor: 1,
          ),
        )
      );
    });

    return usersItems;
  }

  /* */
  Widget _createInputPass() {

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
        _sendForm();
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
  String _passIsValid(String val) {

    if(val.isEmpty) {
      return '   La contraseña es requerida';
    }

    if(this._asesorSelect != 'aldo'){
      if(val.length < 6) {
        return '   Coloca mínimo 6 caracteres';
      }
    }
    return validaores.revisarCamposDeTexto(val);
  }

  /* */
  Future<void> _sendForm() async {

    if(this._frmkKey.currentState.validate()){
      String txt;
      String titulo;
      alertsVarios.cargando(this._context, titulo: 'Autenticando ASESOR');
      String token = await httpAsesores.autenticar(this._asesorSelect, this._ctrlPass.text);
      if(token == 'error'){
        titulo = httpAsesores.result['msg'];
        txt = httpAsesores.result['body'];
      }else{
        if(token.isNotEmpty) {
          Provider.of<DataShared>(this._context, listen: false).setTokenAsesor({
            'username' : this._asesorSelect.toUpperCase(),
            'token' : token,
          });
          Navigator.of(this._context).pushNamedAndRemoveUntil('alta_index_menu_page', (Route rutas) => false);
          return;
        }else{
          titulo = 'AUTORIZACIÓN';
          txt = 'Ocurrio un ERROR al recuperar tus credenciales, inténtalo nuevamente por favor';
        }
      }
      Navigator.of(this._context).pop();
      await alertsVarios.entendido(this._context, titulo: titulo, body: txt);
    }else {
      Widget snackbar = SnackBar(
        content: Text(
          'ERROR EN EL FORMULARIO',
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.yellow
          ),
        ),
        backgroundColor: Colors.red,
      );
      this._scafKey.currentState.showSnackBar(snackbar);
    }
  }

  /* */
  Future<void> _getAsesores() async {
    if(this._asesores.length == 0){
      this._asesores = await httpAsesores.getAsesores();
    }
  }

}