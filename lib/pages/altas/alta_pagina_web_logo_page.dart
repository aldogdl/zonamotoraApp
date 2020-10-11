import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/singletons/alta_user_sngt.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/widgets/tomar_imagenes_widget.dart';
import 'package:zonamotora/singletons/tomar_imagenes_sngt.dart';
import 'package:zonamotora/repository/procc_roto_repository.dart';
import 'package:zonamotora/widgets/regresar_pagina_widget.dart' as regresarPagina;
import 'package:zonamotora/globals.dart' as globals;

class AltaPaginaWebLogoPage extends StatefulWidget {

  @override
  _AltaPaginaWebLogoPageState createState() => _AltaPaginaWebLogoPageState();
}

class _AltaPaginaWebLogoPageState extends State<AltaPaginaWebLogoPage> {

  AppBarrMy appBarrMy       = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AltaUserSngt altaUserSngt = AltaUserSngt();
  UserRepository emUser     = UserRepository();
  ProccRotoRepository emRoto = ProccRotoRepository();
  AlertsVarios alertsVarios = AlertsVarios();
  TomarImagenesSngt tomarImagenesSngt = TomarImagenesSngt();

  GlobalKey<FormState> _keyFrm = GlobalKey<FormState>();
  TextEditingController _qrWhats = TextEditingController();

  BuildContext _context;
  bool _isInit   = false;
  String _tokenTmpAsesor;

  bool _isCheckPublicar = false;
  bool _isCheckRediseniar = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initHidratar());
  }

  @override
  void dispose() {
    imageCache.clear();
    this._qrWhats.dispose();
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
      proveedor.setLastPageVisit('alta_pagina_web_carrucel_page');

      tomarImagenesSngt.proccRoto = {
        'nombre': 'altaLogoSocio',
        'metadata': {
          'source' : tomarImagenesSngt.source,
          'perfil' : altaUserSngt.createDataSitioWeb['ids']['perfil'],
          'user' : altaUserSngt.createDataSitioWeb['ids']['user'],
        },
        'contents': {'tokenAsesor' : proveedor.tokenAsesor['token']}
      };
      this._tokenTmpAsesor = proveedor.tokenAsesor['token'];
      this._isCheckRediseniar = true;
      tomarImagenesSngt.restringirPosition = 'all';
    }

    return Scaffold(
      appBar: appBarrMy.getAppBarr(titulo: 'Alta de Pagina Web 3/4'),
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
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  Widget _body() {

    return Column(
      children: [
        regresarPagina.widget(this._context, 'alta_pagina_web_carrucel_page', lstMenu: new List(), showBtnMenualta: false),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: this._keyFrm,
            child: TextFormField(
              controller: this._qrWhats,
              validator: (String val){
                if(val.length > 5){
                  if(!val.startsWith('http')){
                    return 'El código es incorrecto';
                  }
                  if(!val.contains('wa.')){
                    return 'El código es incorrecto';
                  }
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'QR-Whatsapp del Usuario',
                border: InputBorder.none
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(this._context).size.width,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(150)
          ),
          child: Text(
            'Logotipo para el Sitio Web',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18
            ),
          ),
        ),
        const SizedBox(height: 10),
        _takeFoto(),
        const SizedBox(height: 10),
        _btnsPublicarRediseniar(),
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
              altaUserSngt.setCreateDataSitioWebByKeySingle('logo', await tomarImagenesSngt.getImageForSend());
              await _sendDataAndLogo();
            },
          ),
        ),
        SizedBox(height: MediaQuery.of(this._context).size.height * 0.12),
      ],
    );
  }

  ///
  Widget _takeFoto() {

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(this._context).size.width,
      height: MediaQuery.of(this._context).size.height * 0.2,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(
        child: TomarImagenWidget(
          isMultiple: false,
          contextFrom: this._context,
          child: Consumer<DataShared>(
            builder: (_, dataShared, __) {

              if(dataShared.refreshWidget > -1 && tomarImagenesSngt.imagenAsset != null) {
                return tomarImagenesSngt.previewImage();
              }else{
                if(tomarImagenesSngt.childImg != null) {
                  return tomarImagenesSngt.childImg;
                }else{
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_camera, size: 45, color: Colors.grey[400]),
                      Text(
                        'Logotipo',
                        textScaleFactor: 1,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600]
                        ),
                      )
                    ],
                  );
                }
              }
            },
          ),
          actionBarTitle: 'LOGOTIPO',
          maxImages: 1,
        )
      )
    );
  }

  ///
  Widget _btnsPublicarRediseniar() {

    return Container(
      width: MediaQuery.of(this._context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RaisedButton.icon(
            icon: Icon((this._isCheckPublicar) ? Icons.check_box : Icons.check_box_outline_blank),
            onPressed: (){
              if(!this._isCheckPublicar) {

                setState(() {
                  this._isCheckPublicar = true;
                  altaUserSngt.setCreateDataSitioWebByKeySingle('logoSts', 'publicar');
                  this._isCheckRediseniar = false;
                });
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            color: Colors.blue,
            textColor: Colors.white,
            label: Text(
              'Publicar',
              textScaleFactor: 1,
            ),
          ),
          RaisedButton.icon(
            icon: Icon((this._isCheckRediseniar) ? Icons.check_box : Icons.check_box_outline_blank),
            onPressed: (){
              if(!this._isCheckRediseniar){
                setState(() {
                  this._isCheckRediseniar = true;
                  altaUserSngt.setCreateDataSitioWebByKeySingle('logoSts', 'rediseniar');
                  this._isCheckPublicar = false;
                });
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            color: Colors.green,
            textColor: Colors.white,
            label: Text(
              'Rediseñar',
              textScaleFactor: 1,
            ),
          ),
        ],
      ),
    );
  }

  ///
  Future<void> _sendDataAndLogo() async {

    if(!this._keyFrm.currentState.validate()){
      return;
    }
    bool seguir = true;
    if(this._qrWhats.text.isEmpty){
      String body = 'Parte de la Tarjeta Digital necesita el Código QR de Whatsapp.\n\n¿Segur@ de querer continuar sin el código QR';
      seguir = await alertsVarios.aceptarCancelar(this._context, titulo: '', body: body);
      if(seguir) {
        this._qrWhats.text = '0';
      }else{
        return false;
      }
    }

    Map<String, dynamic> data = {
      'idpag'   : altaUserSngt.createDataSitioWeb['idp'],
      'logoSts' : altaUserSngt.createDataSitioWeb['logoSts'],
      'slug'    : altaUserSngt.createDataSitioWeb['slug'],
      'changeImg':tomarImagenesSngt.changeImage,
      'qrWhats'  : this._qrWhats.text
    };

    alertsVarios.cargando(this._context);
    bool result = await emUser.sendDataAndLogo(data, altaUserSngt.createDataSitioWeb['logo'],  this._tokenTmpAsesor);
    if(!result) {
      Navigator.of(this._context).pop();
      String body = emUser.result['body'];
      if(body.length == 0){
        body = 'Ocurrio un Error al guardar la información, por favor, reintenta guardar, por favor';
      }
      await alertsVarios.entendido(this._context, titulo: 'ERROR AL GUARDAR', body: body);
    }else{
      tomarImagenesSngt.dispose();
      altaUserSngt.dispose();
      Provider.of<DataShared>(this._context, listen: false).setRefreshWidget(-1);
      imageCache.clear();
      await emRoto.deleteProcesoRoto(nameBackup: 'altaLogoSocio');
      Navigator.of(this._context).pushNamedAndRemoveUntil('alta_pagina_web_bsk_page', (route) => false);
    }
  }

  ///
  Future<void> _initHidratar() async {

    tomarImagenesSngt.changeImage = null;
    if(altaUserSngt.createDataSitioWeb['idp'] != 0) {
      if(altaUserSngt.createDataSitioWeb['logo'] != '0') {
        String logo = altaUserSngt.createDataSitioWeb['logo'];
        if(logo.startsWith('${altaUserSngt.createDataSitioWeb['idp']}__')){
          this._isCheckPublicar = false;
          this._isCheckRediseniar = true;
          altaUserSngt.createDataSitioWeb['logoSts'] = 'rediseniar';
          tomarImagenesSngt.hidratarImagenFromServer( '${globals.uripublicZmdb}' +'build_logo/$logo' );
        }else{
          this._isCheckPublicar = true;
          this._isCheckRediseniar = false;
          altaUserSngt.createDataSitioWeb['logoSts'] = 'publicar';
          tomarImagenesSngt.hidratarImagenFromServer( '${globals.uripublicZmdb}' +'images/logotipos/$logo' );
        }
      }
    }
  
    setState(() {});
  }

}