import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zonamotora/repository/procc_roto_repository.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/alta_user_sngt.dart';
import 'package:zonamotora/singletons/tomar_imagenes_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/regresar_pagina_widget.dart' as regresarPagina;
import 'package:zonamotora/widgets/tomar_imagenes_widget.dart';

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
      'subTit': 'Publicacioón de Autos Seminuevos.',
    }
  ];
  List<int> _queVendeSelect = new List();
  bool _isCheckPublicar = true;
  bool _isCheckRediseniar = false;

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
        'contents': Provider.of<DataShared>(this._context, listen: false).tokenAsesor['token']
      };
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

          if(this._queVendeSelect.isNotEmpty){
            List<String> queVendeFin = new List();
            for (var i = 0; i < this._queVendeSelect.length; i++) {
              Map<String, dynamic> vende = this._queVende.singleWhere((element) => element['id'] == this._queVendeSelect[i]);
              if(vende.isNotEmpty){
                queVendeFin.add(vende['titulo'].toLowerCase());
              }
            }
            altaUserSngt.setCreateDataSitioWebByKeySingle('ventaDe', queVendeFin);
            queVendeFin = null;
          }
          print(altaUserSngt.createDataSitioWeb);
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

}