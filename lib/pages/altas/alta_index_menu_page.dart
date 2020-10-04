import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';

class AltaIndexMenuPage extends StatefulWidget {
  @override
  _AltaIndexMenuPageState createState() => _AltaIndexMenuPageState();
}

class _AltaIndexMenuPageState extends State<AltaIndexMenuPage> {

  AppBarrMy appBarrMy       = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AlertsVarios alertsVarios = AlertsVarios();

  bool _isInit   = false;
  bool _hasCoord = false;
  Size _screen;
  String _username;
  BuildContext _context;
  LocationPermission _geolocationStatus;

  @override
  void initState() {
    
    WidgetsBinding.instance.addPostFrameCallback(_afterFirstLayout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    if(!this._isInit){
      appBarrMy.setContext(this._context);
      this._screen = MediaQuery.of(this._context).size;
      this._username = Provider.of<DataShared>(this._context, listen: false).tokenAsesor['username'];
    }

    return Scaffold(
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () => Future.value(false),
          child: _body(),
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  void _afterFirstLayout(_) async {

    if(!this._isInit) {
      this._isInit = true;
      this._geolocationStatus = await checkPermission();
      await _checkGPS();
      Provider.of<DataShared>(this._context, listen: false).setLastPageVisit('alta_index_menu_page');
    }
    await _setCoordenadas();
  }

  ///
  Future<bool> _checkGPS() async {

    LocationPermission permission = await requestPermission();
    if(this._geolocationStatus != permission) {
      await alertsVarios.entendido(this._context, titulo: 'SERVICIO DE UBICACIÓN', body: 'Habilita el servicio de GPS del dispositivo para captura las coordenas de ubucación');
      return false;
    }else{
      return true;
    }
  }

  ///
  Future<void> _setCoordenadas() async {

    try {
      Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if(position.latitude.toString().isNotEmpty){
        this._hasCoord = true;
      }
    } catch (e) {
      await alertsVarios.entendido(this._context, titulo: 'OPTENIENDO COORDENADAS', body: 'Se abrirá la configuración de ubicación para que habilites la geolocalización.');
      await openLocationSettings();
    }
  }

  /* */
  Widget _cabecera() {

    double txtHolaTop = (this._screen.height < 550) ? 0.24 : 0.255;
    return Stack(
      children: <Widget>[
        Positioned(
          child:  Container(
            height: this._screen.height * 0.29,
            child: FadeInImage(
              image: AssetImage('assets/images/data_colection.jpg'),
              placeholder: AssetImage('assets/images/data_colection.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
            top: 0,
            child: Container(
              width: this._screen.width,
              height: this._screen.height * 0.29,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color.fromRGBO(124, 0, 0, 1),
                    Color.fromRGBO(124, 0, 0, 0)
                  ]
                )
              ),
            ),
          ),
          Positioned(
            top: this._screen.height * txtHolaTop,
            left: this._screen.height * 0.03,
            child: Text(
              'Hola ${this._username}',
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Positioned(
            top: this._screen.height * 0.29,
            left: this._screen.height * 0.02,
            child: Text(
              '¿Qué deseas hacer?',
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.grey[100],
                fontSize: 25,
                fontWeight: FontWeight.w300
              ),
            ),
          )
      ],
    );

  }

  /* */
  Widget _body() {

    return CustomScrollView(
      slivers: <Widget>[
        appBarrMy.getAppBarrSliver(titulo: '', bgContent: _cabecera()),
        SliverList(
          delegate: SliverChildListDelegate([
            Align(
              alignment: Alignment.centerLeft,
              child: FlatButton.icon(
                label: Text(
                  'OPCIONES DE REGISTRO',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 17
                  ),
                  textAlign: TextAlign.left,
                ),
                icon: Icon(Icons.arrow_back, size: 30),
                onPressed: () => Navigator.of(this._context).pushReplacementNamed('reg_index_page'),
              ),
            ),
            Divider(),
          ]),
        ),
        SliverList(
          delegate: SliverChildListDelegate(_createMenu()),
        )
      ],
    );
  }
  
  /* */
  List<Widget> _createMenu() {

    List<Widget> itemsMenu = new List();
    List<Map<String, dynamic>> botones = [
      {
        'titulo'    : 'Registrar Usuario',
        'subTitulo' : 'Inicialización del Registro',
        'icono'     : Icons.supervised_user_circle,
        'onClick'   : () => Navigator.of(this._context).pushReplacementNamed('reg_user_page', arguments: {'source':'socio'}),
        'icoColor'   : Colors.redAccent[200]
      },
      {
        'titulo'    : 'Continuar con un Alta',
        'subTitulo' : 'Cliente o Socio Comercial',
        'icono'     : Icons.add_to_home_screen,
        'onClick'   : () async {
          if(this._hasCoord){
            Navigator.of(this._context).pushReplacementNamed('alta_lst_users_page');
          }else{
            this._geolocationStatus = null;
            _checkGPS();
            await _setCoordenadas();
          }
        },
        'icoColor'   : Colors.blue[200]
      },
      {
        'titulo'    : 'Vincular Dispositios',
        'subTitulo' : 'Agregar Móvil a un Usuario',
        'icono'     : Icons.mobile_screen_share,
        'onClick'   : () => Navigator.of(this._context).pushReplacementNamed('alta_lst_users_page'),
        'icoColor'   : Colors.purple[200]
      },
      {
        'titulo'    : 'Gestión de Sitios Web',
        'subTitulo' : 'Publicidad Digital Comercial',
        'icono'     : Icons.public,
        'onClick'   : () => Navigator.of(this._context).pushReplacementNamed('alta_pagina_web_bsk_page'),
        'icoColor'   : Colors.green[200]
      },
      {
        'titulo'    : 'Editar Datos Generales',
        'subTitulo' : 'Edita los datos del cliente',
        'icono'     : Icons.edit_location,
        'onClick'   : () => Navigator.of(this._context).pushReplacementNamed('alta_lst_users_page'),
        'icoColor'   : Colors.orange[200]
      },
      {
        'titulo'    : 'Recuperar Cuenta',
        'subTitulo' : 'Reestablecer éste Dispositivo',
        'icono'     : Icons.cloud_download,
        'onClick'   : () => Navigator.of(this._context).pushReplacementNamed('login_page'),
        'icoColor'   : Colors.red[200]
      },
      {
        'titulo'    : 'Prueba de notificación',
        'subTitulo' : 'Enviar a éste Dispositivo',
        'icono'     : Icons.notifications_active,
        'onClick'   : () => Navigator.of(this._context).pushReplacementNamed('alta_lst_users_page'),
        'icoColor'   : Colors.yellow[400]
      }
    ];

    double min = 0.25;
    double suma;
    double fraccion = ((min - 0.08) / botones.length);
    for (var i = 0; i < botones.length; i++) {
      suma = (i > 0) ? (suma -= fraccion) : min;
      itemsMenu.add(
        Padding(
          padding: EdgeInsets.only(left: this._screen.width * suma),
          child: _containerMenu(botones[i]),
        )
      );
      itemsMenu.add(
          SizedBox(height: 10)
      );
    }

    return itemsMenu;
  }

  // Contenedor individual del menu
  Widget _containerMenu(Map<String, dynamic> boton) {

    return InkWell(
      onTap: boton['onClick'],
      child: Container(
        height: 70,
        width: this._screen.width,
        padding: EdgeInsets.only(right: MediaQuery.of(this._context).size.aspectRatio * 17),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            bottomLeft: Radius.circular(50)
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              offset: Offset(1, 2),
              spreadRadius: 1
            )
          ]
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 5),
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: boton['icoColor'],
                  borderRadius: BorderRadius.circular(60)
                ),
                child: Icon(boton['icono'], color: Colors.white, size: 35),
              ),
            ),
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${boton['titulo']}',
                    textScaleFactor: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(this._context).size.aspectRatio * 29,
                      shadows: [
                        Shadow(
                          blurRadius: 0.1,
                          offset: Offset(0.2, 0.2)
                        )
                      ],
                    ),
                    textAlign: TextAlign.end,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${boton['subTitulo']}',
                    textScaleFactor: 1,
                    style: TextStyle(
                      color: Colors.white
                    ),
                    textAlign: TextAlign.end,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


}