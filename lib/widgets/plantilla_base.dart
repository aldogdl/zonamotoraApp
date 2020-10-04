import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/pages/index/welcome_widget.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/config_gms_sngt.dart';
import 'package:zonamotora/singletons/limpiar_basura_sngt.dart';
import 'package:zonamotora/utils/calcular_alto_screen.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/shared_preference_const.dart' as constSp;
import 'package:zonamotora/singletons/solicitud_sngt.dart';

class PlantillaBase extends StatefulWidget {

  final BuildContext context;
  final Widget child;
  final pagInf;
  final activarIconInf;
  final isIndex;
  PlantillaBase({this.context, this.child, this.pagInf, this.activarIconInf, this.isIndex});

  @override
  _PlantillaBaseState createState() => _PlantillaBaseState();
}

class _PlantillaBaseState extends State<PlantillaBase> {

  ConfigGMSSngt configGMSSngt = ConfigGMSSngt();
  MenuInferior menuInferior = MenuInferior();
  UserRepository emUser = UserRepository();
  LimpiarBasuraSngt limpiarBasuraSngt = LimpiarBasuraSngt();
  SolicitudSngt solicitudSgtn = SolicitudSngt();
  WelcomeWidget welcome = WelcomeWidget();
  CalcularAltoScreen calcularAltoScreen = CalcularAltoScreen();
  
  GlobalKey<ScaffoldState> _keySk = GlobalKey<ScaffoldState>();
  DataShared _dataShared;
  bool _isInit = true;
  bool _verPageWelcome = false;
  bool _isOpenWelcome  = false;
  String _username;

  @override
  Widget build(BuildContext context) {

    context = null;

    if(this._isInit){
      this._isInit = false;
      this._dataShared = Provider.of<DataShared>(widget.context);
      this._username = (this._dataShared.username == null) ? 'Anónimo' : this._dataShared.username;
      this._dataShared.setLastPageVisit('index_page');

      limpiarBasuraSngt.setContext(widget.context, this._dataShared.lastPageVisit);
      configGMSSngt.setContext(widget.context);
      calcularAltoScreen.setContext(widget.context);
    }

    return Scaffold(
      key: this._keySk,
      backgroundColor: Colors.white,
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: FutureBuilder(
          future: _checkPageWelcome(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {

            if(this._verPageWelcome) {
              Future.delayed(Duration(milliseconds: 1500), () => _verWelcomeWidget());
            }
            return _bodyMain();

          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: (!widget.isIndex)
      ?
      FloatingActionButton(
        onPressed: (){
          if(solicitudSgtn.onlyRead){
            solicitudSgtn.limpiarSingleton();
          }
          Navigator.of(widget.context).pushReplacementNamed('index_page');
        },
        child: Icon(Icons.home),
        isExtended: true,
        mini: true,
      )
      :null,
      bottomNavigationBar: menuInferior.getMenuInferior(widget.context, widget.pagInf, homeActive: widget.activarIconInf)
    );
  }

  ///
  Widget _bodyMain() {

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0, left: 0,
          child: Container(
            width: MediaQuery.of(widget.context).size.width,
            height: calcularAltoScreen.hGradient,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Color(0xffffffff),
                  Color(0xffffffff)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                transform: GradientRotation(1)
              )
            )
          ),
        ),
        Positioned(
          top: calcularAltoScreen.hPosHead,
          left: 0,
          child: Container(
            width: MediaQuery.of(widget.context).size.width,
            height: calcularAltoScreen.hHead,
            child: _cabecera(),
          ),
        ),
        (this._username == 'Anónimo')
        ?
        Positioned(
          top: calcularAltoScreen.getTopBody(this._username) - calcularAltoScreen.hHeadAnonimo,
          left: 0,
          child: _btnsAnonimo()
        )
        :
        const SizedBox(height: 0),
        Positioned(
          top: calcularAltoScreen.getTopBody(this._username),
          left: 0,
          child: widget.child
        ),
      ],
    );
  }

  ///
  Widget _cabecera() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Icon(Icons.menu, size: 28, color: Color(0xff002f51)),
            onPressed: () {
              this._keySk.currentState.openDrawer();
            },
          ),
        ),
        Expanded(
          flex: 4,
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 20,
              child: Image(
                image: AssetImage('assets/images/zm_alt_light.png'),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Consumer<DataShared>(
            builder: (_, dataShared, __){
              if(dataShared.cantNotif == 0) {
                return _singleNotification();
              }else{
                return _complexNotification(dataShared.cantNotif);
              }
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Consumer<DataShared>(
            builder: (_, dataShared, __){
              if(dataShared.cantInCarrito == 0) {
                return _singlecarrShop();
              }else{
                return _complexcarrShop();
              }
            },
          ),
        ),
      ],
    );
  }

  ///
  Widget _singleNotification() {

    return IconButton( icon: FaIcon(FontAwesomeIcons.bell, color: Colors.grey, size: 22), onPressed: null);
  }

  ///
  Widget _complexNotification(int cant) {

    return Stack(
      alignment: Alignment.center,
      overflow: Overflow.visible,
      children: [
        IconButton(
          icon: Icon(Icons.notifications_active, color: Color(0xff002f51), size: 22),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('notificaciones_page');
          },
        ),
        Positioned(
          top: 5,
          right: 5,
          child: CircleAvatar(
            radius: 8,
            backgroundColor: Colors.red,
            child: Text(
              '$cant',
              textScaleFactor: 1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12
              ),
            ),
          ),
        )
      ],
    );
  }

  ///
  Widget _singlecarrShop() {

    return IconButton( icon: FaIcon(FontAwesomeIcons.shoppingCart, color: Colors.grey, size: 22), onPressed: null);
  }

  ///
  Widget _complexcarrShop() {

    return Stack(
      alignment: Alignment.center,
      overflow: Overflow.visible,
      children: [
        FaIcon(FontAwesomeIcons.shoppingCart, color: Color(0xff002f51), size: 22),
        Positioned(
          top: -6,
          right: 7,
          child: CircleAvatar(
            radius: 7,
            backgroundColor: Colors.red,
            child: Text(
              '0',
              textScaleFactor: 1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12
              ),
            ),
          ),
        )
      ],
    );

  }
  
  ///
  Future<void> _checkPageWelcome({bool isRespuesta}) async {

    SharedPreferences sess = await SharedPreferences.getInstance();
    this._verPageWelcome = sess.getBool(constSp.sp_showWelcome);
    if(this._verPageWelcome == null) {
      this._verPageWelcome = true;
      sess.setBool(constSp.sp_showWelcome, true);
    }else{
      if(isRespuesta != null){
        sess.setBool(constSp.sp_showWelcome, isRespuesta);
      }
    }
  }

  ///
  Widget _btnsAnonimo() {

    return Container(
      width: MediaQuery.of(widget.context).size.width,
      height: calcularAltoScreen.hHeadAnonimo,
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border(
          top: BorderSide(width: 2, color: Color(0xff002f51)),
          bottom: BorderSide(width: 2, color: Color(0xff002f51))
        )
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(width: 10),
            _machoteBtnAnonimo(
              titulo: 'Crear Cuenta',
              icono: Icons.supervised_user_circle,
              iconoColor: Colors.purple,
              accion: (){
                Navigator.of(widget.context).pushNamedAndRemoveUntil('reg_index_page', (Route rutas) => false);
              }
            ),
            const SizedBox(width: 18),
            _machoteBtnAnonimo(
              titulo: 'Hacer Lógin',
              icono: Icons.verified_user,
              iconoColor: Colors.red,
              accion: (){
                Navigator.of(widget.context).pushNamedAndRemoveUntil('login_page', (Route rutas) => false);
              }
            ),
            const SizedBox(width: 18),
            _machoteBtnAnonimo(
              titulo: 'Mis Autos',
              icono: Icons.directions_car,
              iconoColor: Colors.orange,
              accion: (){
                Navigator.of(widget.context).pushNamedAndRemoveUntil('mis_autos_page', (Route rutas) => false);
              }
            ),
            const SizedBox(width: 10)
          ],
        ),
      ),
    );
  }

  ///
  Widget _machoteBtnAnonimo({
    String titulo,
    Function accion,
    IconData icono,
    Color iconoColor
  }) {

    return InkWell(
      child: Row(
        children: [
          Icon(icono, size: 19, color: iconoColor),
          const SizedBox(width: 5),
          Text(
            '$titulo',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
      onTap: accion,
    );
  }

  ///
  Future<void> _verWelcomeWidget() async {

    if(this._isOpenWelcome){ return false; }

    Future modalWelcome = showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        this._isOpenWelcome = true;
        return welcome.getWelcomeWidget(widget.context);
      }
    );
    modalWelcome.then((value) => _cerrarModalWelcome(value));
  }

  ///
  Future<void> _cerrarModalWelcome(bool value) async {

    await _checkPageWelcome(isRespuesta: value);
  }

}
