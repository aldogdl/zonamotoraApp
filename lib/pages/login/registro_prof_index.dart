import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/container_inputs.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/template_page_helps.dart';
import 'package:zonamotora/widgets/regresar_pagina_widget.dart' as regresarPagina;

class RegistroProfIndex extends StatefulWidget {
  @override
  _RegistroProfIndexState createState() => _RegistroProfIndexState();
}

class _RegistroProfIndexState extends State<RegistroProfIndex> {

  AppBarrMy appBarrMy = AppBarrMy();
  AlertsVarios alertsVarios = AlertsVarios();
  MenuInferior menuInferior = MenuInferior();
  TemplatePageHelps templatePageHelps = TemplatePageHelps();
  ContainerInput containerInput = ContainerInput();

  BuildContext _context;
  bool _isInit = false;
  bool _isVistaHelp = false;
  String _selectDedicas = '';
  SwiperController  _ctrlPages = SwiperController();
  GlobalKey<ScaffoldState> _scaffKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> _frmKey      = GlobalKey<FormState>();
  TextEditingController _ctrlTel    = TextEditingController();
  TextEditingController _ctrlNombre = TextEditingController();
  TextEditingController _ctrlDom    = TextEditingController();
  TextEditingController _ctrlPagWeb = TextEditingController();
  FocusNode _focusTel    = FocusNode();
  FocusNode _focusNombre = FocusNode();
  FocusNode _focusDom    = FocusNode();
  FocusNode _focusPagWeb = FocusNode();

  @override
  void dispose() {
    this._ctrlTel.dispose();
    this._ctrlNombre.dispose();
    this._ctrlDom.dispose();
    this._ctrlPagWeb.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;

    if(!this._isInit) {
      this._isInit = true;
      Provider.of<DataShared>(this._context, listen: false).setLastPageVisit('reg_index_page');
    }

    return Scaffold(
      key: this._scaffKey,
      appBar: appBarrMy.getAppBarr(titulo: 'Ingresa tus Datos:'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: _body(),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false),
      floatingActionButton: (this._isVistaHelp)
      ?
      FloatingActionButton(
        mini: true,
        onPressed: (){
          this._isVistaHelp = false;
          setState(() { });
        },
        child: Center(
          child: Icon(Icons.help),
        ),
      )
      :
      null
    );
  }

  /* */
  Widget _body() {

    List<Widget> vistas;

    if(this._isVistaHelp) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: this._frmKey,
            child: _form()
          ),
        ),
      );
    }else{
      vistas = [
        _introInfo(),
        _zmVendeInfo(),
        _zmVaToNegInfo(),
        _zmQueHacerInfo(),
        _zmFinInfo()
      ];
      return Container(
        child: Swiper(
          loop: false,
          itemCount: vistas.length,
          autoplay: false,
          controller: this._ctrlPages,
          pagination: new SwiperPagination(),
          itemBuilder: (BuildContext context, int index) {
            return vistas[index];
          },
        ),
      );
    }
    
  }

  /* */
  Widget _form() {

    return Column(
      children: <Widget>[
        regresarPagina.widget(this._context, 'REGRESAR', showBtnMenualta: false),
        Divider(height: 2),
        const SizedBox(height: 10),
        Text(
          'Registrate',
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 40,
            color: Colors.red[400],
            fontWeight: FontWeight.w100
          ),
        ),
        _containerInputs()
        
      ],
    );
  }

  /* */
  Widget _containerInputs() {

    List<Widget> listInputs = [
      _inputQueHaces(),
      _inputNoCel(),
      _inputNombre(),
      _inputCalleNumero(),
      _inputPaginaWeb(),
      _btnEnviar()
    ];

    return containerInput.listWidgets(listInputs, 'registro');
    
  }

  /* */
  Widget _inputQueHaces() {

    return DropdownButtonFormField(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        fillColor: Colors.white,
        filled: true,
        border: InputBorder.none,
        prefixIcon: Icon(Icons.work)
      ),
      validator: (String val){
        if(val.isEmpty) {
          return '     Selecciona una opción por favor';
        }
        return null;
      },
      onChanged: (val){
        this._selectDedicas = val;
        FocusScope.of(this._context).requestFocus(this._focusTel);
      },
      value: this._selectDedicas,
      items: [
        DropdownMenuItem(
          value: '',
          child : Text(
            '   SELECCIONA UNO',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 15,
              color: Colors.red[200]
            ),
          ),
        ),
        DropdownMenuItem(
          value: 'VENDO AUTOS',
          child : Text(
            'VENDO AUTOS',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 15
            ),
          ),
        ),
        DropdownMenuItem(
          value: 'TENGO REFACCIONARIA | AUTOPARTES',
          child: Text(
            'TENGO REFACCIONARIA | AUTOPARTES',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 15
            ),
          ),
        ),
        DropdownMenuItem(
          value: 'OFREZCO SERVICIO AUTOMOTRIZ',
          child: Text(
            'OFREZCO SERVICIO AUTOMOTRIZ',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 15
            ),
          ),
        ),
        DropdownMenuItem(
          value: 'OTROS',
          child: Text(
            'OTROS',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 15
            ),
          ),
        ),
      ],
    );
  }

  /* */
  Widget _inputNoCel() {

    return TextFormField(
      controller: this._ctrlTel,
      focusNode: this._focusTel,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (String val) {
        FocusScope.of(this._context).requestFocus(this._focusNombre);
      },
      validator: (String val){
        RegExp patron = RegExp(r'[\d]{10}');
        bool res = patron.hasMatch(val);
        if(!res) {
          return 'Sólo números con un mínimo de 10 dígitos';
        }
        return null;
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: InputBorder.none,
        prefixIcon: Icon(Icons.phone_android)
      ),
      keyboardType: TextInputType.number,
    );
  }

  /* */
  Widget _inputNombre() {

    return TextFormField(
      controller: this._ctrlNombre,
      focusNode: this._focusNombre,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      onFieldSubmitted: (String val) {
        FocusScope.of(this._context).requestFocus(this._focusDom);
      },
      validator: (String val) {
        RegExp patron = RegExp(r'^[a-zA-Z]+\s+[\w]+$');
        bool res = patron.hasMatch(val);
        if(!res) {
          return 'Coloca por lo menos un Apellido, por favor.';
        }
        return null;
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: InputBorder.none,
        prefixIcon: Icon(Icons.person)
      ),
    );
  }

  /* */
  Widget _inputCalleNumero() {

    return TextFormField(
      controller: this._ctrlDom,
      focusNode: this._focusDom,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      onFieldSubmitted: (String val) {
        FocusScope.of(this._context).requestFocus(this._focusPagWeb);
      },
      validator: (String val) {
        RegExp patron = RegExp(r'^[\w0-9]+\s+(\w*\s*)[\d+]+$');
        bool res = patron.hasMatch(val);
        if(!res){
          return 'Coloca el nombre y número por favor';
        }
        return null;
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: InputBorder.none,
        prefixIcon: Icon(Icons.location_on)
      ),
    );
  }

  /* */
  Widget _inputPaginaWeb() {

    return TextFormField(
      controller: this._ctrlPagWeb,
      focusNode: this._focusPagWeb,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.url,
      validator: (String val) {
        if(val.isNotEmpty) {
          RegExp patron = RegExp(r'^(www\.)*[a-zA-Z]+\.com?$');
          bool res = patron.hasMatch(val);
          if(!res) {
            return 'La Página Web no está bien escrita.';
          }
        }
        return null;
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: InputBorder.none,
        prefixIcon: Icon(Icons.web)
      ),
    );
  }

  /* */
  Widget _btnEnviar() {

    return RaisedButton.icon(
      color: Colors.black87,
      textColor: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      icon: Icon(Icons.send),
      label: Text(
        'Enviar Solicitud de Registro',
        textScaleFactor: 1,
      ),
      onPressed: () async {
        await _enviarFrm();
      },
    );
  }

  /* */
  Future<bool> _enviarFrm() async {

    if(this._frmKey.currentState.validate()) {
      alertsVarios.cargando(this._context);
      Navigator.of(this._context).pushReplacementNamed('reg_prof_grax_page');
    }else{
      SnackBar snackbar = SnackBar(
        backgroundColor: Colors.red,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.warning, color: Colors.yellow),
            const SizedBox(width: 20),
            Text(
              'ALERTA en FORMULARIO',
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.white
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
      this._scaffKey.currentState.showSnackBar(snackbar);
    }
    return false;
  }



  // paginas para la vista de ayuda

  /* */
  Widget _introInfo() {
    
    return templatePageHelps.getTemplate(
      context: this._context,
      icono: Icons.accessibility_new,
      titulo: '¡NO TE PREOCUPES POR NADA!',
      subTitulo: 'Nosotros hacemos todo por ti.',
      body: 'ZonaMotora se especializó en construir herramientas tecnológicas para '
            +'ofrecerte grandes ventajas al dedicarte al área automotriz',
      accionEntendido: (){
        this._isVistaHelp = true;
        setState(() {});
      },
      accionSiguinete: (){
        this._ctrlPages.next();
      }
    );
  }

  /* */
  Widget _zmVendeInfo() {
    
    return templatePageHelps.getTemplate(
      context: this._context,
      icono: Icons.live_help,
      titulo: '¡NOS PREOCUPAMOS POR QUE VENDAS!',
      subTitulo: 'Te ayudamos a incrementar tus ingresos.',
      body: 'Promovemos tus AUTOS, REFACCIONES o SERVICIOS en todas nuestras plataformas digitales ¡¡GRATIS!!',
      accionEntendido: (){
        this._isVistaHelp = true;
        setState(() {});
      },
      accionSiguinete: (){
        this._ctrlPages.next();
      }
    );
  }

  /* */
  Widget _zmVaToNegInfo() {
    
    return templatePageHelps.getTemplate(
      context: this._context,
      icono: Icons.directions_run,
      titulo: '¡INFÓRMATE MÁS!',
      subTitulo: 'Te visitamos sin compromiso de ningún tipo, garantizado',
      body: 'Te explicamos todo lo que puedes hacer con todas nuestras herramientas directamente en tu negocio u oficina',
      accionEntendido: (){
        this._isVistaHelp = true;
        setState(() {});
      },
      accionSiguinete: (){
        this._ctrlPages.next();
      }
    );
  }

   /* */
  Widget _zmQueHacerInfo() {
    
    return templatePageHelps.getTemplate(
      context: this._context,
      icono: Icons.comment,
      titulo: '¡INGRESA TUS DATOS!',
      subTitulo: '¿Cómo te Contactamos?',
      body: 'Sólo indícanos tu Domicilio y un Teléfono de contacto y recibirás información directa de un Ejecutivo',
      accionEntendido: (){
        this._isVistaHelp = true;
        setState(() {});
      },
      accionSiguinete: (){
        this._ctrlPages.next();
      }
    );
  }

   /* */
  Widget _zmFinInfo() {
    
    return templatePageHelps.getTemplate(
      context: this._context,
      icono: Icons.star,
      titulo: '¡NO DEJES PASAR ESTA OPORTUNIDAD!',
      subTitulo: '...',
      body: 'COMIENZA A VENDER MÁS Y TOTALMENTE ¡GRATIS!',
      isFin : true,
      accionEntendido: (){
        this._isVistaHelp = true;
        setState(() {});
      },
      accionSiguinete: (){
        this._ctrlPages.next();
      }
    );
  }

}