import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/utils/validadores.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/container_inputs.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/regresar_pagina_widget.dart' as regresarPagina;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  Validadores validaores = Validadores();
  AlertsVarios alertsVarios = AlertsVarios();
  ContainerInput containerInput = ContainerInput();

  Size _screen;
  BuildContext _context;
  GlobalKey<FormState> _frmkKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _sckfkKey = GlobalKey<ScaffoldState>();
  TextEditingController _ctrlUser = TextEditingController();
  TextEditingController _ctrlPass = TextEditingController();
  FocusNode _focusUser = FocusNode();
  FocusNode _focusPass = FocusNode();
  bool _oculatarPass = true;
  bool _isInit = false;
  DataShared _dataShared;

  @override
  void dispose() {
    this._ctrlUser?.dispose();
    this._ctrlPass?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    this._screen = MediaQuery.of(context).size;
    this._context = context;
    context = null;

    if(!this._isInit) {
      this._isInit = true;
      this._dataShared = Provider.of<DataShared>(this._context, listen: false);
    }

    return Scaffold(
      key: this._sckfkKey,
      appBar: appBarrMy.getAppBarr(titulo: 'Autenticación'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: _body(),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  /* */
  Widget _body() {

    String tituloBack = (this._dataShared.lastPageVisit == 'index_page') ? 'REGRESAR AL INICIO' : 'IR AL MENÚ DE OPCIONES';
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _cabecera(),
          regresarPagina.widget(this._context, tituloBack, showBtnMenualta: false),
          _form(),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text(
                  'Olvide mi Contraseña',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 12
                  ),
                ),
                onPressed: () async {
                  
                },
              ),
              const SizedBox(width: 20),
              RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                color: Colors.black87,
                icon: Icon(Icons.settings_input_antenna, color: Colors.orange, size: 15),
                label: Text(
                  'LOGIN',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.grey
                  ),
                ),
                onPressed: () async {
                  bool ok = await _preSendForm();
                  if(ok) {
                    FocusScope.of(this._context).requestFocus(new FocusNode());
                    Navigator.of(this._context).popAndPushNamed(
                      'recovery_cuenta_page',
                      arguments: {'u_usname': this._ctrlUser.text, 'u_uspass' : this._ctrlPass.text}
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /* */
  Widget _cabecera() {

    bool verSubT = (this._screen.height <= 550) ? false : true;
    String isReg   = (this._dataShared.username != 'Anónimo') ? 'CAMBIAR CUENTA' : 'RECUPERACIÓN DE CUENTA';

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          width: this._screen.width,
          height: this._screen.height * 0.30,
          decoration: BoxDecoration(
            color: Color(0xff7C0000)
          ),
          child: SizedBox(height: 30),
        ),

        Positioned(
          width: this._screen.width,
          top: this._screen.height * 0.01,
          child: Center(
            child: Container(
              height: this._screen.width * 0.35,
              width: this._screen.width* 0.35,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(100)
              ),
              child: Image(
                image: AssetImage('assets/images/login.png'),
              ),
            ),
          ),
        ),

        Positioned(
          top: this._screen.width * 0.40,
          width: this._screen.width,
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  isReg,
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 5),
                (verSubT)
                ?
                Text(
                  'Gracias por tu confianza',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.grey[100],
                  ),
                )
                :
                const SizedBox(height: 0)
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
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Center(
        child: Form(
          key: this._frmkKey,
          child: _createListInputs()
        )
      ),
    );
  }

  /* */
  Widget _createListInputs() {

    List<Widget> listInputs = [
      _createInputUser(),
      _createInputPass()
    ];
    return containerInput.listWidgets(listInputs, 'login');
  }

  /* */
  Widget _createInputUser() {

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
  String _userIsValid(String val) {

    if(val.isEmpty) {
      return '   El usuario es requerido';
    }
    if(val.length < 5) {
      return '   Coloca mínimo 5 caracteres';
    }
    return validaores.revisarCamposDeTexto(val);
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
  Future<bool> _preSendForm() async {

    if(this._frmkKey.currentState.validate()){
      return true;
    }else {
      _showAvisoError();
      return false;
    }
  }

  /* */
  void _showAvisoError() {

    Widget snak = SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        'ERROR EN EL FORMULARIO',
        textScaleFactor: 1,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
        textAlign: TextAlign.center,
      ),
    );
    this._sckfkKey.currentState.showSnackBar(snak);
  }
}