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

  BuildContext _context;
  bool _isInit   = false;
  String _tokenTmpAsesor;

  List<Map<String, dynamic>> _queVende = [
    {
      'id': 1,
      'titulo': 'REFACCIONES',
      'subTit': 'Productos seminuevos con comisión.',
    },
    {
      'id': 2,
      'titulo': 'SERVICIOS',
      'subTit': 'Todo tipo de Servicios Automotrices.',
    },
    {
      'id': 3,
      'titulo': 'AUTOMÓVILES',
      'subTit': 'Publicación de Autos Seminuevos.',
    }
  ];
  List<int> _queVendeSelect = new List();
  bool _isCheckPublicar = false;
  bool _isCheckRediseniar = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initHidratar());
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        mini: true,
        child: Icon(Icons.save, size: 25),
        onPressed: () async {

          List<String> queVendeFin = new List();
          if(this._queVendeSelect.isNotEmpty){
            for (var i = 0; i < this._queVendeSelect.length; i++) {
              Map<String, dynamic> vende = this._queVende.singleWhere((element) => element['id'] == this._queVendeSelect[i]);
              if(vende.isNotEmpty){
                queVendeFin.add(vende['titulo'].toLowerCase());
              }
            }
            altaUserSngt.setCreateDataSitioWebByKeySingle('ventaDe', queVendeFin);
            altaUserSngt.setCreateDataSitioWebByKeySingle('logo', await tomarImagenesSngt.getImageForSend());
            queVendeFin = null;
            alertsVarios.cargando(this._context);
            await _sendDataAndLogo();
          }else{
            String body = 'Para crear un Sitio Web, es necesario indicar al menos un tipo de producto que publicarás en la WEB.';
            alertsVarios.entendido(this._context, titulo: 'ERROR AL GUARDAR', body: body);
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
        regresarPagina.widget(this._context, 'VOLVER A ATRAS', lstMenu: altaUserSngt.crearMenuSegunRole(), showBtnMenualta: false),
        Container(
          width: MediaQuery.of(this._context).size.width,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Text(
            '¿Qué Publicarás en Tu WEB?',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18
            ),
          ),
        ),
        _queVendeWidget(),
        const SizedBox(height: 10),
        _takeFoto(),
        const SizedBox(height: 10),
        _btnsPublicarRediseniar(),
        SizedBox(height: MediaQuery.of(this._context).size.height * 0.12),
      ],
    );
  }

  ///
  Widget _queVendeWidget() {

    return Column(
      children: this._queVende.map((queVendeElement){
        return CheckboxListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          onChanged: (bool val) {
            if(this._queVendeSelect.indexOf(queVendeElement['id']) > -1){
              this._queVendeSelect.removeWhere((element) => (element == queVendeElement['id']));
            }else{
              this._queVendeSelect.add(queVendeElement['id']);
            }
            setState(() { });
          },
          value: (this._queVendeSelect.indexOf(queVendeElement['id']) > -1) ? true : false,
          dense: true,
          title: Text(
            '${queVendeElement['titulo']}',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          subtitle: Text(
            '${queVendeElement['subTit']}',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 13
            ),
          ),
        );
      }).toList()
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
          contextFrom: this._context,
          child: Consumer<DataShared>(
            builder: (_, dataShared, __) {

              if(dataShared.refreshWidget > -1) {
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

    Map<String, dynamic> data = {
      'idpag'   : altaUserSngt.createDataSitioWeb['idp'],
      'ventaDe' : altaUserSngt.createDataSitioWeb['ventaDe'],
      'logoSts' : altaUserSngt.createDataSitioWeb['logoSts'],
      'slug'    : altaUserSngt.createDataSitioWeb['slug'],
      'changeImg':tomarImagenesSngt.changeImage
    };

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

    if(altaUserSngt.createDataSitioWeb['ventaDe'] != null) {
      for (var i = 0; i < altaUserSngt.createDataSitioWeb['ventaDe'].length; i++) {
        Map<String, dynamic> qv = this._queVende.firstWhere(
          (vende) => (vende['titulo'].toLowerCase() == altaUserSngt.createDataSitioWeb['ventaDe'][i]),
          orElse: () => new Map()
        );
        if(qv.isNotEmpty){
          _queVendeSelect.add(qv['id']);
        }
      }
    }

    if(altaUserSngt.createDataSitioWeb['idp'] != 0) {
      if(altaUserSngt.createDataSitioWeb['logo'] != '0') {
        String logo = altaUserSngt.createDataSitioWeb['logo'];
        if(logo.startsWith('${altaUserSngt.createDataSitioWeb['idp']}__')){
          this._isCheckPublicar = false;
          this._isCheckRediseniar = true;
          altaUserSngt.createDataSitioWeb['logoSts'] = 'rediseniar';
          tomarImagenesSngt.hidratarImagenFromServer( '${globals.uripublicZmdb}/build_logo/$logo' );
        }else{
          this._isCheckPublicar = true;
          this._isCheckRediseniar = false;
          altaUserSngt.createDataSitioWeb['logoSts'] = 'publicar';
          tomarImagenesSngt.hidratarImagenFromServer( '${globals.uripublicZmdb}/images/logotipos/$logo' );
        }
      }
    }
    setState(() {});
  }

}