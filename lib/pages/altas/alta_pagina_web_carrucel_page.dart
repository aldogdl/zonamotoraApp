import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/alta_user_sngt.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/regresar_pagina_widget.dart' as regresarPagina;

class AltaPaginaWebCarrucelPage extends StatefulWidget {

  @override
  _AltaPaginaWebCarrucelPageState createState() => _AltaPaginaWebCarrucelPageState();
}

class _AltaPaginaWebCarrucelPageState extends State<AltaPaginaWebCarrucelPage> {

  AppBarrMy appBarrMy       = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AltaUserSngt altaUserSngt = AltaUserSngt();
  UserRepository emUser     = UserRepository();

  BuildContext _context;
  bool _isInit   = false;
  GlobalKey<FormState> _keyFrm = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _keySkf = GlobalKey<ScaffoldState>();

  TextEditingController _ctrlMision = TextEditingController();
  TextEditingController _ctrlDiff = TextEditingController();
  TextEditingController _ctrlEspec = TextEditingController();

  TextEditingController _ctrlTitMision = TextEditingController();
  TextEditingController _ctrlTitDiff = TextEditingController();
  TextEditingController _ctrlTitEspec = TextEditingController();

  FocusNode _focusMision = FocusNode();
  FocusNode _focusDiff = FocusNode();
  FocusNode _focusEspec = FocusNode();
  FocusNode _focusTitMision = FocusNode();
  FocusNode _focusTitDiff = FocusNode();
  FocusNode _focusTitEspec = FocusNode();

  @override
  void initState() {
    hidratarControladores();
    super.initState();
  }

  @override
  void dispose() {
    this._ctrlMision?.dispose();
    this._ctrlDiff?.dispose();
    this._ctrlEspec?.dispose();
    this._ctrlTitMision?.dispose();
    this._ctrlTitDiff?.dispose();
    this._ctrlTitEspec?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    this._context = context;
    context = null;

    if(!this._isInit) {
      this._isInit = true;
      altaUserSngt.isAtras = true;
      DataShared proveedor = Provider.of<DataShared>(this._context, listen: false);
      proveedor.setLastPageVisit('alta_pagina_web_despeq_page');
    }

    return Scaffold(
      key: this._keySkf,
      appBar: appBarrMy.getAppBarr(titulo: 'Alta de Pagina Web 2/4'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(this._context).size.width,
            child: _body(),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        mini: true,
        child: Icon(Icons.save, size: 25),
        onPressed: () async {
          if(this._keyFrm.currentState.validate()) {

            altaUserSngt.setCreateDataSitioWebByCarruselByKey('mision', 'body', this._ctrlMision.text);
            altaUserSngt.setCreateDataSitioWebByCarruselByKey('diff', 'body', this._ctrlDiff.text);
            altaUserSngt.setCreateDataSitioWebByCarruselByKey('espec', 'body', this._ctrlEspec.text);
            altaUserSngt.setCreateDataSitioWebByCarruselByKey('mision', 'titulo', this._ctrlTitMision.text);
            altaUserSngt.setCreateDataSitioWebByCarruselByKey('diff', 'titulo', this._ctrlTitDiff.text);
            altaUserSngt.setCreateDataSitioWebByCarruselByKey('espec', 'titulo', this._ctrlTitEspec.text);

            Navigator.of(this._context).pushReplacementNamed('alta_pagina_web_build_page');
          }else{

            SnackBar snackbar = SnackBar(
              content: Container(
                child: Text(
                  'Hay un ERROR en el Fomulario',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            );
            this._keySkf.currentState.showSnackBar(snackbar);
          }
        }
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  Widget _body() {

    return Column(
      children: [
        Column(
          children: [
            regresarPagina.widget(this._context, 'VOLVER A ATRAS', lstMenu: altaUserSngt.crearMenuSegunRole(), showBtnMenualta: false),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(200),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)
                )
              ),
              child: Form(
                key: this._keyFrm,
                child: Column(
                  children: [
                    _inputCaja(
                      this._ctrlMision,
                      this._focusMision,
                      this._focusTitMision,
                      'La MISIÓN...',
                      '¿Cuál es la MISIÓN del Negocio?',
                      (String valor) {
                        if(valor.length > 0) {
                          if(valor.length < 50){
                            return 'Coloca mínimo 50 caracteres.';
                          }
                        }
                        return null;
                      }
                    ),
                    const SizedBox(height: 10),
                    _inputTitulo(
                      this._ctrlTitMision,
                      this._focusTitMision,
                      this._focusDiff,
                      'Título de la MISIÓN',
                      'Determina el título según redacción',
                      (String valor) {
                        if(this._ctrlMision.text.length > 0) {
                          if(valor.length == 0){
                            return 'Es necesario un Título.';
                          }
                          if(valor.length < 10){
                            return 'Debe ser mínimo de 10 caracteres.';
                          }
                        }
                        return null;
                      }
                    ),
                    const SizedBox(height: 30),
                    _inputCaja(
                      this._ctrlDiff,
                      this._focusDiff,
                      this._focusTitDiff,
                      '¿Qué te diferencía?',
                      'Indica las cualidades de tu negocio',
                      (String valor) {
                        if(valor.length > 0) {
                          if(valor.length < 50){
                            return 'Coloca mínimo 50 caracteres.';
                          }
                        }
                        return null;
                      }
                    ),
                    const SizedBox(height: 10),
                    _inputTitulo(
                      this._ctrlTitDiff,
                      this._focusTitDiff,
                      this._focusEspec,
                      'Título de la Diferencia',
                      'Determina el título según redacción',
                      (String valor) {
                        if(this._ctrlDiff.text.length > 0) {
                          if(valor.length == 0){
                            return 'Es necesario un Título.';
                          }
                          if(valor.length < 10){
                            return 'Debe ser mínimo de 10 caracteres.';
                          }
                        }
                        return null;
                      }
                    ),
                    const SizedBox(height: 30),
                    _inputCaja(
                      this._ctrlEspec,
                      this._focusEspec,
                      this._focusTitEspec,
                      '¿Cuál es tu Especialidad?',
                      '',
                      (String valor) {
                        if(valor.length > 0) {
                          if(valor.length < 50){
                            return 'Coloca mínimo 50 caracteres.';
                          }
                        }
                      }
                    ),
                    _inputTitulo(
                      this._ctrlTitEspec,
                      this._focusTitEspec,
                      null,
                      'Título de la Especialidad',
                      '',
                      (String valor) {
                        if(this._ctrlEspec.text.length > 0) {
                          if(valor.length == 0){
                            return 'Es necesario un Título.';
                          }
                          if(valor.length < 10){
                            return 'Debe ser mínimo de 10 caracteres.';
                          }
                        }
                        return null;
                      }
                    ),
                  ],
                ),
              )
            ),
            SizedBox(height: MediaQuery.of(this._context).size.height * 0.1)
          ],
        ),
      ],
    );
  }

  ///
  Widget _inputTitulo(
    TextEditingController controlador,
    FocusNode foco,
    FocusNode nextFoco,
    label,
    help,
    Function validador
  ) {

    return TextFormField(
      controller: controlador,
      focusNode: foco,
      style: TextStyle(
        color: Colors.blue
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.bookmark),
        helperText: help,
        errorStyle: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold
        ),
        filled: true,
        fillColor: Colors.white
      ),
      validator: validador,
      textInputAction: (nextFoco != null) ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: (String val) {
        if(nextFoco == null) {
          nextFoco = new FocusNode();
        }
        FocusScope.of(this._context).requestFocus(nextFoco);
      }
    );
  }

  ///
  Widget _inputCaja(
    TextEditingController controlador,
    FocusNode foco,
    FocusNode nextFoco,
    label,
    help,
    Function validador
  ) {

    return TextFormField(
      controller: controlador,
      focusNode: foco,
      maxLines: 5,
      maxLength: 150,
      style: TextStyle(
        color: Colors.blue
      ),
      validator: validador,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.hearing),
        helperText: help,
        errorStyle: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      textInputAction: (nextFoco != null) ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: (String val) {
        if(nextFoco == null) {
          nextFoco = new FocusNode();
        }
        FocusScope.of(this._context).requestFocus(nextFoco);
      }
    );
  }

  ///
  void hidratarControladores() {

    this._ctrlMision.text = altaUserSngt.createDataSitioWeb['carrucel']['mision']['body'];
    this._ctrlDiff.text = altaUserSngt.createDataSitioWeb['carrucel']['diff']['body'];
    this._ctrlEspec.text = altaUserSngt.createDataSitioWeb['carrucel']['espec']['body'];
    this._ctrlTitMision.text = altaUserSngt.createDataSitioWeb['carrucel']['mision']['titulo'];
    this._ctrlTitDiff.text = altaUserSngt.createDataSitioWeb['carrucel']['diff']['titulo'];
    this._ctrlTitEspec.text = altaUserSngt.createDataSitioWeb['carrucel']['espec']['titulo'];
  }

}