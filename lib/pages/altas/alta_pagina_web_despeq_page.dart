import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/alta_user_sngt.dart';
import 'package:zonamotora/utils/validadores.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/regresar_pagina_widget.dart' as regresarPagina;

class AltaPaginaWebDesPeqPage extends StatefulWidget {

  @override
  _AltaPaginaWebDesPeqPageState createState() => _AltaPaginaWebDesPeqPageState();
}

class _AltaPaginaWebDesPeqPageState extends State<AltaPaginaWebDesPeqPage> {

  AppBarrMy appBarrMy       = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AltaUserSngt altaUserSngt = AltaUserSngt();
  UserRepository emUser     = UserRepository();
  Validadores utils         = Validadores();
  AlertsVarios alertsVarios = AlertsVarios();

  BuildContext _context;
  bool _isInit   = false;
  bool _makeBusquedaPagWeb = false;
  String _tokenTmpAsesor;
  GlobalKey<FormState> _keyFrm = GlobalKey<FormState>();

  TextEditingController _ctrlSlug = TextEditingController();
  TextEditingController _ctrlAnios = TextEditingController();
  TextEditingController _ctrlDespeq = TextEditingController();

  FocusNode _focusSlug = FocusNode();
  FocusNode _focusAnios = FocusNode();
  FocusNode _focusDespeq = FocusNode();

  @override
  void dispose() {
    this._ctrlSlug?.dispose();
    this._ctrlAnios?.dispose();
    this._ctrlDespeq?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    this._context = context;
    context = null;

    if(!this._isInit) {
      this._isInit = true;
      DataShared proveedor = Provider.of<DataShared>(this._context, listen: false);
      proveedor.setLastPageVisit('alta_pagina_web_bsk_page');
      this._tokenTmpAsesor = proveedor.tokenAsesor['token'];
    }

    return Scaffold(
      appBar: appBarrMy.getAppBarr(titulo: 'Alta de Pagina Web 1/4'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: FutureBuilder(
          future: _hasSitioWeb(),
          builder: (_, AsyncSnapshot snapshot){
            if(snapshot.hasData) {
              return SingleChildScrollView(
                child: _body(),
              );
            }
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Buscando Sitio Web',
                    textScaleFactor: 1,
                  )
                ],
              ),
            );
          },
        ),
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
            regresarPagina.widget(this._context, 'alta_pagina_web_bsk_page', lstMenu: altaUserSngt.crearMenuSegunRole(), showBtnMenualta: false),
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
                    _inputSlug(),
                    _propuestasSlug(),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _inputAnios(),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ' Años de Experiencia',
                            textScaleFactor: 1,
                            style: TextStyle(
                              fontSize: 17
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    _inputDespeq(),
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
                          if(this._keyFrm.currentState.validate()) {

                            Map<String, dynamic> slug = utils.quitarAcentos(this._ctrlSlug.text);
                            if(slug['error'] != '0'){
                              String body = 'Revisa el Sub Dominio seleccionado, se encontro un error de captura';
                              await alertsVarios.entendido(this._context, titulo: 'ERROR EN EL SLUG', body: body);
                              return false;
                            }
                            String slugOk = slug['newtext'];
                            slugOk = slugOk.replaceAll(' ', '-');

                            bool resp = await emUser.checkSlugParaSitioWeb(slugOk, altaUserSngt.createDataSitioWeb['idp'], this._tokenTmpAsesor);
                            if(resp){
                              String body = 'El Sub Dominio $slugOk, ya esta ocupado, por favor, selecciona otro.';
                              await alertsVarios.entendido(this._context, titulo: 'ERROR EN EL SLUG', body: body);
                              return false;
                            }else{
                              this._ctrlSlug.text = slugOk;
                              altaUserSngt.createDataSitioWeb['slug'] = slugOk;
                              altaUserSngt.createDataSitioWeb['aniosExp'] = this._ctrlAnios.text;
                              altaUserSngt.createDataSitioWeb['despeq'] = this._ctrlDespeq.text;
                              Navigator.of(this._context).pushReplacementNamed('alta_pagina_web_carrucel_page');
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            ),
            SizedBox(height: MediaQuery.of(this._context).size.height * 0.03)
          ],
        ),
      ],
    );
  }

  ///
  Widget _inputSlug() {

    return TextFormField(
      controller: this._ctrlSlug,
      focusNode: this._focusSlug,
      style: TextStyle(
        color: Colors.blue
      ),
      decoration: InputDecoration(
        labelText: 'Sub Dominio del Sitio',
        prefixIcon: Icon(Icons.not_listed_location),
        helperText: 'De preferencia menor a 10 digitos',
        filled: true,
        errorStyle: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold
        )
      ),
      validator: (String val) {
        if(val.length == 0) {
          return 'Es REQUERIDO.';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.url,
      onFieldSubmitted: (String val) {
        FocusScope.of(this._context).requestFocus(this._focusAnios);
      }
    );
  }

  ///
  Widget _inputAnios() {

    return TextFormField(
      controller: this._ctrlAnios,
      focusNode: this._focusAnios,
      style: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontSize: 20
      ),
      enabled: true,
      decoration: InputDecoration(
        hintText: '?',
        prefixIcon: Icon(Icons.flare),
        filled: true
      ),
      validator: (String val) {
        return null;
      },
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      onFieldSubmitted: (String val) {
        FocusScope.of(this._context).requestFocus(this._focusDespeq);
      }
    );
  }

  ///
  Widget _inputDespeq() {

    return TextFormField(
      controller: this._ctrlDespeq,
      focusNode: this._focusDespeq,
      maxLines: 5,
      maxLength: 150,
      style: TextStyle(
        color: Colors.blue
      ),
      validator: (String val) {
        if(val.length < 25) {
          return 'Mínimo 25 caracteres.';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Una pequeña descripción:',
        prefixIcon: Icon(Icons.account_box),
        helperText: '¿A qué se dedica tu negocio?',
        errorStyle: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold
        ),
        filled: true
      ),
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (String val) {
        FocusScope.of(this._context).requestFocus(new FocusNode());
      }
    );
  }

  ///
  Widget _propuestasSlug() {

    return FutureBuilder(
      future: _calcularSubDominios(),
      builder: (_, AsyncSnapshot<List<Widget>> snapshot) {
        if(snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: snapshot.data.toList(),
          );
        }

        return Padding(
          padding: EdgeInsets.all(7),
          child: Text(
            'Calculando Sub Dominios',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.orange
            ),
          ),
        );
      },
    );
  }

  ///
  Future<List<Widget>> _calcularSubDominios() async {

    List<Widget> propuestas = new List();
    propuestas.add(
      SizedBox(width: MediaQuery.of(this._context).size.width, height: 0)
    );

    Map<String, dynamic> data = altaUserSngt.createDataSitioWeb;
    
    String slug = '';
    String pagWeb = '';
    
    if(data['slug'] != null){

      if(data['slug'].isNotEmpty) {
        
        slug = data['slug'];
        slug = slug.toLowerCase();
        slug = slug.replaceAll(
          new RegExp(r'\s', caseSensitive: false),
          '-'
        );
        Map<String, String> txtSinAcentos = {'á':'a','é':'e','í':'i','ó':'o','ú':'u'};

        RegExp exp = RegExp(r'[áéíóú]');
        slug = slug.replaceAllMapped(exp, (m){
          return txtSinAcentos[m.group(0)];
        });
        propuestas.add(_machotePropuesta(slug));
      }
    }

    if(data['pagWeb'] != null) {
      if(data['pagWeb'].isNotEmpty) {
        print('entra');
        pagWeb = data['pagWeb'];
        pagWeb = pagWeb.toLowerCase();
        List<String> partes = pagWeb.split('.');
        propuestas.add(_machotePropuesta(partes[0]));
      }
    }

    return propuestas;
  }

  ///
  Widget _machotePropuesta(String propuesta) {

    return FlatButton.icon(
      icon: Icon(Icons.arrow_right, color: Colors.grey[800]),
      padding: EdgeInsets.all(0),
      textColor: Colors.purple,
      label: Text(
        '$propuesta',
        textScaleFactor: 1,
        textAlign: TextAlign.left,
      ),
      onPressed: (){
        setState(() {
          this._ctrlSlug.text = propuesta;
        });
        FocusScope.of(this._context).requestFocus(this._focusAnios);
      },
    );
  }

  ///
  Future<bool> _hasSitioWeb() async {

    if(this._makeBusquedaPagWeb){ return true; }
    bool retorno;
    if(altaUserSngt.isAtras){
      hidratarControladores();
      return true;
    }
    Map<String, dynamic> sitioWeb = new Map();
    Map<String, dynamic> data = altaUserSngt.createDataSitioWeb;
    sitioWeb = await emUser.hasSitioWebByIdPerfil(data['ids']['perfil'], this._tokenTmpAsesor);

    if(sitioWeb.containsKey('pw_id')){
      altaUserSngt.hidratarCreateDataSitioWeb(sitioWeb);
      hidratarControladores();
      retorno = true;
    }else{
      retorno = false;
    }

    this._makeBusquedaPagWeb = true;
    return retorno;
  }

  ///
  void hidratarControladores() {

    this._ctrlSlug.text = altaUserSngt.createDataSitioWeb['slug'];
    this._ctrlAnios.text = '${altaUserSngt.createDataSitioWeb['aniosExp']}';
    this._ctrlDespeq.text = altaUserSngt.createDataSitioWeb['despeq'];
  }

}