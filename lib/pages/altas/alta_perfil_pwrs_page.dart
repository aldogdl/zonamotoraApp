import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/singletons/alta_user_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/bg_altas_stack.dart';
import 'package:zonamotora/widgets/container_inputs.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/regresar_pagina_widget.dart' as regresarPagina;
import 'package:zonamotora/utils/validadores.dart';

class AltaPerfilPWRSPage extends StatefulWidget {
  @override
  _AltaPerfilPWRSPageState createState() => _AltaPerfilPWRSPageState();
}

class _AltaPerfilPWRSPageState extends State<AltaPerfilPWRSPage> {

  AppBarrMy appBarrMy       = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AlertsVarios alertsVarios = AlertsVarios();
  AltaUserSngt altaUserSngt = AltaUserSngt();
  Validadores validadores   = Validadores();
  BgAltasStack bgAltasStack = BgAltasStack();
  ContainerInput containerInputs = ContainerInput();

  TextEditingController _ctrlPW = TextEditingController();
  TextEditingController _ctrlRS = TextEditingController();
  TextEditingController _ctrlEmail = TextEditingController();

  FocusNode _focusPW = FocusNode();
  FocusNode _focusRS = FocusNode();
  FocusNode _focusEmail = FocusNode();

  BuildContext _context;
  bool _isInit = false;
  String _errorRS = '';
  String _errorPW = '';
  PersistentBottomSheetController _ctrlHojaInf;
  GlobalKey<ScaffoldState> _skfKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _frmKey = GlobalKey<FormState>();
  String lastUri;

  @override
  void initState() {
    if(altaUserSngt.paginaWeb != null) {
      this._ctrlPW.text = (altaUserSngt.paginaWeb.length > 4) ? altaUserSngt.paginaWeb : null;
    }
    if(altaUserSngt.email != null) {
      this._ctrlEmail.text = (altaUserSngt.email.length > 4) ? altaUserSngt.email : null;
    }
    super.initState();
  }

  @override
  void dispose() {
    this._ctrlPW.dispose();
    this._ctrlRS.dispose();
    this._ctrlEmail.dispose();
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
      lastUri = dataShared.lastPageVisit;
      dataShared.setLastPageVisit('alta_perfil_pwrs_page');
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
          child: Container(
            width: MediaQuery.of(this._context).size.width,
            decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.red,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              )
            ),
            child: _body(),
          ),
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  Widget _body() {

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        regresarPagina.widget(this._context, 'alta_perfil_contac_page', lstMenu: altaUserSngt.crearMenuSegunRole()),
        const SizedBox(height: 10),
        Text(
          '[2/3] Perfil del Usuario',
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20
          ),
        ),
        Text(
          'DATOS DE CONTACTO',
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 15
          ),
        ),
        const SizedBox(height: 10),
        _crearLstInputs(),
      ],
    );
  }

  ///
  Widget _crearLstInputs() {

    List<Widget> listInputs = [
      _inputPW(),
      _intpuEmail(),
      const SizedBox(height: 20),
    ];
    altaUserSngt.redesSociales.forEach((red){
      listInputs.add(_createListRS(red['titulo']));
    });
    listInputs.add(
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
            if(altaUserSngt.paginaWeb == null && this._ctrlPW.text != '') {
              this._errorPW = _validarPaginaWeb();
              if(this._errorPW == null){
                isValid = true;
                isValid = _procesarFormulario();
              }
              setState(() { });
            }else{
              isValid = _procesarFormulario();
            }
            if(isValid){
              Navigator.of(this._context).pushReplacementNamed('alta_perfil_otros_page');
            }
          },
        ),
      )
    );
    listInputs.add(const SizedBox(height: 50));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: MediaQuery.of(this._context).size.height * 0.635,
      width: MediaQuery.of(this._context).size.width,
      child: Form(
        key: this._frmKey,
        child: containerInputs.container(listInputs, 'perfil_redesSociales', labelColor: Colors.grey[200])          
      ),
    );
  }

  ///
  Widget _inputPW() {

    return TextFormField(
      controller: this._ctrlPW,
      focusNode: this._focusPW,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.language),
        hintText: 'empresa.com',
        errorText: (this._errorPW == '') ? null : this._errorPW,
      ),
      validator: (String val){
        String error;
        if(val.length > 0){
          this._errorPW = _validarPaginaWeb();
          error = this._errorPW;
        }
        return error;
      },
      onFieldSubmitted: (String val){
        this._errorPW = _validarPaginaWeb();
        FocusScope.of(this._context).requestFocus(this._focusEmail);
      },
    );
  }

  ///
  Widget _intpuEmail(){

    return TextFormField(
      controller: this._ctrlEmail,
      focusNode: this._focusEmail,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.email),
        hintText: 'aldo.zm@gmail.com'
      ),
      validator: (String val){
        String error;
        if(val.length > 0) {
          Map<String, dynamic> res = validadores.email(val);
          error = (res.containsKey('error')) ? res['error'] : null;
          this._ctrlEmail.text = (res.containsKey('valor')) ? res['valor'] : this._ctrlEmail.text;
        }
        return error;
      },
      onFieldSubmitted: (String val){
        FocusScope.of(this._context).requestFocus(new FocusNode());
      },
    );
  }

  ///
  Widget _createListRS(String titulo) {
    
    IconData icono = _determinarIcono(titulo);

    return SizedBox(
      child: InkWell(
        child: Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(bottom: 25),
          width: MediaQuery.of(this._context).size.width * 0.4,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red[400],
            borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            children: <Widget>[
              Icon(icono, size: 30, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                titulo,
                textScaleFactor: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.white
                ),
              )
            ],
          ),
        ),
        onTap: (){
          this._errorRS = '';
          _showHojaInf(titulo);
        },
      ),
    );
  }

  ///
  void _showHojaInf(String cualRS) {

    this._ctrlHojaInf =  this._skfKey.currentState.showBottomSheet(
      (BuildContext context) => _hojaInferior(cualRS),
      elevation: 20,
      backgroundColor: Colors.red[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )
      )
    );
  }

  ///
  Widget _hojaInferior(String cualRS) {
    
    return Container(
      width: MediaQuery.of(this._context).size.width,
      height: MediaQuery.of(this._context).size.height * 0.4,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          
          Text('Para: ${ cualRS.toUpperCase() }'),

          (this._errorRS != '')
          ? Text(
            '   ${this._errorRS}   ',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 16,
              backgroundColor: Colors.red
            ),
          )
          : const SizedBox(height: 0),
          const SizedBox(height: 10),
          _frmAddRedsocial(cualRS),
          const SizedBox(height: 10),
          _visorDeRSActuales(cualRS),
        ],
      ),
    );
  }

  ///
  Widget _frmAddRedsocial(String cualRS) {

    Map<String, dynamic> txtHelp = altaUserSngt.redesSociales.firstWhere((rs) => (rs['titulo'] == cualRS), orElse: () => new Map());

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 6,
          child: TextFormField(
            controller: this._ctrlRS,
            focusNode: this._focusRS,
            decoration: InputDecoration(
              hintText: 'Ingresa aquí el link',
              hintStyle: TextStyle(
                color: Colors.red[200]
              ),
              helperText: txtHelp['link'],
              filled: true,
              fillColor: Colors.red[50]
            ),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (String val){
              _addRedSocialToList(cualRS);
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              color: Colors.blueGrey,
              padding: EdgeInsets.only(top: 0),
              icon: Icon(Icons.save_alt, size: 45),
              onPressed: () {
                _addRedSocialToList(cualRS);
              },
            ),
          ),
        )
      ],
    );
  }

  ///
  Widget _visorDeRSActuales(String cualRS) {

    Map<String, dynamic> redEnCurso = altaUserSngt.redesSociales.firstWhere((rs) => (rs['titulo'] == cualRS), orElse: () => new Map());
    double altoContanerLinks = (this._errorRS != '') ? 61 : 80;
    int cantItem = 0;

    if(altaUserSngt.redSocs != null){ 
      if(altaUserSngt.redSocs.containsKey(redEnCurso['slug'])) {
        cantItem = altaUserSngt.redSocs[redEnCurso['slug']].length;
      }
    }

    return Container(
      height: altoContanerLinks,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        itemCount: cantItem,
        itemBuilder: (_, int index) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(0),
              height: 35,
              child: FlatButton.icon(
                icon: Icon(Icons.close, color: Colors.red, size: 17),
                padding: EdgeInsets.all(0),
                label: Text(
                  altaUserSngt.redSocs[redEnCurso['slug']][index]
                ),
                textColor: Colors.blue,
                onPressed: (){
                  altaUserSngt.removeLinkRS(
                    redSocial: cualRS,
                    indice: index
                  );
                  setState(() {
                    this._ctrlHojaInf.setState(() => true);
                  });
                },
              ),
            ),
          );
        },
      )
    );
  }
  
  ///
  IconData _determinarIcono(String cualRS) {

    List<IconData> iconos = [
      Icons.filter_none,
      Icons.filter_1,
      Icons.filter_2,
      Icons.filter_3,
      Icons.filter_4,
      Icons.filter_5,
      Icons.filter_6,
      Icons.filter_7,
      Icons.filter_8,
      Icons.filter_9,
    ];

    Map<String, dynamic> redEnCurso = altaUserSngt.redesSociales.firstWhere((rs) => (rs['titulo'] == cualRS));

    int cantRs = 0;
    if(altaUserSngt.redSocs != null){
      if(altaUserSngt.redSocs[redEnCurso['slug']] != null) {
        cantRs = altaUserSngt.redSocs[redEnCurso['slug']].length;
      }
    }
    return iconos[cantRs];
  }

  ///
  bool _procesarFormulario() {
    if(this._frmKey.currentState.validate()) {
      altaUserSngt.setPaginaWeb(this._ctrlPW.text);
      altaUserSngt.setEmail(this._ctrlEmail.text);
      return true;
    }else{

      SnackBar snackbar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'ERROR EN EL FORMULARIO',
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold
          ),
        ),
      );
      this._skfKey.currentState.showSnackBar(snackbar);
      return false;
    }
  }

  ///
  void _addRedSocialToList(String cual) {

    this._errorRS = (this._ctrlRS.text.length == 0) ? 'Coloca un Link por favor.' : '';
    if(this._errorRS != '') {
      this._ctrlHojaInf.setState(()=>true);
      return;
    }
    altaUserSngt.addNewLinkRS(
      redSocial: cual,
      link: this._ctrlRS.text
    );
    setState(() {
      this._ctrlHojaInf.setState(()=>this._errorRS = '');    
    });
  }

  ///
  String _validarPaginaWeb() {

    this._ctrlPW.text = this._ctrlPW.text.replaceAll(' ', '');
    RegExp patron = RegExp(r'^[a-zA-Z]{3,}\.{1}([a-zA-Z]{2,})$');
    bool res = patron.hasMatch(this._ctrlPW.text);
    if(!res) {
      return 'La Página Web no es correcta';
    }
    return null;
  }

}