import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:zonamotora/pages/oportunidades/widgets/ficha_auto_img_cache.dart';
import 'package:zonamotora/repository/solicitud_repository.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/cotizacion_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/globals.dart' as globals;

class SendFotosCotPage extends StatefulWidget {
  @override
  _SendFotosCotPageState createState() => _SendFotosCotPageState();
}

class _SendFotosCotPageState extends State<SendFotosCotPage> {

  UserRepository emUser = UserRepository();
  SolicitudRepository emSoli = SolicitudRepository();

  AlertsVarios alertsVarios = AlertsVarios();
  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  CotizacionSngt sngtCot = CotizacionSngt();
  FichaAutoImgCacheWidget imgCacheWidget;
  bool _preparedForSave = false;
  BuildContext _context;


  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Color(0xff7C0000),
        title: Text(
          'TERMINANDO COTIZACIÓN',
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 16
          ),
        ),
      ),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Center(
          child: _body(),
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  Widget _body() {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(80),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Colors.grey
              )
            ]
          ),
          child: Column(
            children: <Widget>[
              Text(
                'Estamos procesando las fotografías y enviándolas como respuesta '+
                'a tu COTIZACIÓN.',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.red[600]
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 75,
                child: Image(
                  image: AssetImage('assets/images/internet.png'),
                ),
              ),
              Text(
                'Este proceso puede durar considerables segundos '+
                'dependiendo del tamaño de cada fotografía, ten paciencia por favor.',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.red[300]
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(20),
          width: MediaQuery.of(this._context).size.width,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Colors.grey
              )
            ]
          ),
          child: Column(
            children: <Widget>[
              Text(
                'Enviando FOTOGRAFÍAS...',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17
                ),
              ),
              const SizedBox(height: 5),
              const LinearProgressIndicator(),
              const SizedBox(height: 5),
              FutureBuilder(
                future: _prepararFotos(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.hasData){
                    if(snapshot.data){
                      _intentarSubirFoto();
                      snapshot = null;
                    }
                    return Text(
                      'Organizando tu Cotización',
                      textScaleFactor: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13
                      ),
                    );
                  }
                  return Text(
                    'Preparando Todo ... ',
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13
                    ),
                  );
                },
              )
            ],
          )
        ),
      ]
    );
  }

  ///
  Future<bool> _prepararFotos() async {

    if(_preparedForSave) return true;
    this._preparedForSave = true;
    bool res;
    int vueltas = 1;
    for (var i = 0; i < sngtCot.fotos.length; i++) {
      
      String originalName = sngtCot.fotos[i]['data'].name;

      List<dynamic> ext = originalName.split('.');
      Map<String, double> tams = await emSoli.getProporcionesPara(
        globals.tamMaxFotoPzas,
        sngtCot.fotos[i]['data'].originalWidth,
        sngtCot.fotos[i]['data'].originalHeight,
        isLandscape: sngtCot.fotos[i]['data'].isLandscape
      );
      ByteData byteData = await sngtCot.fotos[i]['data'].getThumbByteData(tams['ancho'].toInt(), tams['alto'].toInt(), quality: 100);
      sngtCot.fotos[i]['data'] = byteData.buffer.asUint8List();
      sngtCot.fotos[i]['nombreFoto'] = 'zonamotora-${sngtCot.idCotizacion}-$i.${ext[1]}';
      sngtCot.fotos[i]['ext'] = ext[1];
      byteData = null;
      vueltas++;
    }

    if(vueltas >=  sngtCot.fotos.length){
      res = true;
    }
    return res;
  }

  ///
  Future<bool> _intentarSubirFoto() async {

    bool res = await emSoli.sendFotoDeCotizacion(sngtCot.fotos, sngtCot.idCotizacion);
    bool reenviar = false;
    if(!res){
      String body = 'Revisa tu conexión a Internet, no se han podido enviar las fotografía de la cotización.\n\n' +
      'Presiona CONTINUAR si deseas que lo intentemos nuevamente.';
      body = emSoli.result['body'];
      bool acc = await alertsVarios.aceptarCancelar(this._context, titulo: 'ERROR AL ENVIAR FOTOS', body: body);
      if(acc){
        reenviar = true;
      }else{
        res = false;
        reenviar = false;
        Navigator.of(this._context).pushNamedAndRemoveUntil('fin_msg_cotizacion', (route) => false);
      }
    }else{
      Navigator.of(this._context).pushNamedAndRemoveUntil('fin_msg_cotizacion', (route) => false);
    }

    if(reenviar){
      res = await _intentarSubirFoto();
    }
    return res;
  }

}