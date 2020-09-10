import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/autos_repository.dart';
import 'package:zonamotora/repository/carshop_repository.dart';
import 'package:zonamotora/repository/notifics_repository.dart';
import 'package:zonamotora/repository/procc_roto_repository.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/config_gms_sngt.dart';
import 'package:zonamotora/globals.dart' as globals;
import 'package:zonamotora/shared_preference_const.dart' as spConst;



class InitConfigPage extends StatefulWidget {
  @override
  _InitConfigPageState createState() => _InitConfigPageState();
}

class _InitConfigPageState extends State<InitConfigPage> {

  ConfigGMSSngt configGMSSngt = ConfigGMSSngt();
  UserRepository emUser = UserRepository();
  DataShared dataShared = DataShared();
  AutosRepository emAutos = AutosRepository();
  ProccRotoRepository emProccsRotos = ProccRotoRepository();
  NotificsRepository emNotific = NotificsRepository();
  CarShopRepository emShop = CarShopRepository();

  
  String _haciendo = 'Iniciando Configuración';
  bool _recibirNotif;
  SharedPreferences _sess;
  BuildContext _context;
  bool _iniConfig = false;
  String _tokenDB;
  DataShared _dataShared;
  bool _isNewInstalationApp = true;

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;

    if(!this._iniConfig) {
      this._iniConfig = true;
      configGMSSngt.setContext(this._context);
      emNotific.setContext(this._context);
      _initConfig();
    }

    return Scaffold(
      backgroundColor: Color(0xff000000),
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(this._context).size.width,
            height: MediaQuery.of(this._context).size.height,
              child: FadeInImage(
              placeholder: AssetImage('assets/images/no_pixel.png'),
              image: AssetImage('assets/icon_splash/zona-motora-splash.gif'),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 40,
            child: Container(
              width: MediaQuery.of(this._context).size.width,
              height: 30,
              child: Center(
                child: Text(
                  '${this._haciendo}',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
            ),
          )
        ],
      )
    );
  }

  /* */
  Future<void> _initConfig() async {

    this._sess = await SharedPreferences.getInstance();
    if(globals.env == 'dev'){
      this._sess.setString('ipDev', globals.ip);
    }

    this._dataShared = Provider.of<DataShared>(this._context, listen: false);
    this._recibirNotif = this._sess.getBool(spConst.sp_notif);
    this._haciendo = 'Checando Procesos Rotos';
    setState(() {});

    Map<String, dynamic> procesoRoto = await emProccsRotos.checkProcesosRotos();
    
    Future.delayed(Duration(seconds: 2), () async {

      this._haciendo = 'Configurando ZonaMotora App.';
      setState(() {});

      await _checkDataUser();
      await _checkMarcasAndModelos();
      await _checkConfigPush();
      await _checkInCarShop();

      this._haciendo = (this._dataShared.username == 'Anónimo') ? 'Bienvenid@' : 'Bienvenid@ ${this._dataShared.username.toUpperCase()}';
      setState(() {});

      PaintingBinding.instance.imageCache.clear();

      if(procesoRoto.isNotEmpty) {
        // si existe el campo ftosCot es que es llamado el proceso roto desde
        // la seleccion de imagenes para una respuesta a alguna solicitud.
        if(procesoRoto.containsKey('ftosCot')) {

          Navigator.of(this._context).pushNamedAndRemoveUntil(
            procesoRoto['path'],
            (Route rutas) => false,
          );

        }else{

          if(procesoRoto.containsKey('altaLogoSocio')){
            this._dataShared.setTokenAsesor({'token':procesoRoto['tokenAsesor']});
          }
          if(procesoRoto.containsKey('altSoc')){
            this._dataShared.setTokenAsesor({'token':procesoRoto['tokenAsesor']});
          }

          Navigator.of(this._context).pushNamedAndRemoveUntil(
            procesoRoto['path'],
            (Route rutas) => false,
            arguments: (procesoRoto.containsKey('indexAuto')) ? {'indexAuto':procesoRoto['indexAuto']} : null
          );
        }

      } else {
        if(this._dataShared.segReg == 1){
          Navigator.of(this._context).pushNamedAndRemoveUntil('mis_autos_page', (Route rutas) => false);
        }else{
          Navigator.of(this._context).pushNamedAndRemoveUntil('index_page', (Route rutas) => false);
        }
      }

    });
  }

  ///
  Future<void> _checkDataUser() async {

    this._haciendo = 'Revisando Credenciales';
    setState(() {});
    
    Map<String, dynamic> dataUser = await emUser.getDataUser();
    if(dataUser.isNotEmpty) {
      this._dataShared.setUsername(dataUser['u_usname']);
      this._dataShared.setRole(dataUser['u_roles']);
      this._tokenDB = dataUser['u_tokenDevice'];

      bool updateTokenServer = false;
      DateTime hoy = DateTime.now();
      String updateNewtoken = this._sess.getString(spConst.sp_updateTokenServerAt);

      if(updateNewtoken != null) {
        DateTime fechaObjNextUpDate = DateTime.parse(updateNewtoken);
        Duration diff = hoy.difference(fechaObjNextUpDate);
        if(!diff.isNegative){
          updateTokenServer = true;
        }
      }
      updateTokenServer = (dataUser['u_tokenServer'] == '0') ? true : updateTokenServer;

      if(updateTokenServer) {
        Map<String, dynamic> token = await emUser.getTokenFromServer();
        if(token.containsKey('token')){
          await emUser.setTokenServerInBD(token['token']);
          DateFormat f = DateFormat('yyyy-MM-dd');
          DateTime nextUpdateToken = hoy.add(Duration(seconds: 216000));
          String newDate = '${f.format(nextUpdateToken)} 00:00:00';
          this._sess.setString(spConst.sp_updateTokenServerAt, newDate);
        }
      }
      this._isNewInstalationApp = false;
    }else{
      this._dataShared.setUsername('Anónimo');
      this._isNewInstalationApp = true;
    }
  }

  ///
  Future<void> _checkConfigPush() async {

    this._haciendo = 'Configurando Notificaciones';
    setState(() {});
    
    // Para no duplicar el hilo actual ya configurado - solo en DEV
    if(globals.env == 'dev') {
      int devClv = this._sess.getInt(spConst.sp_devClv);
      devClv = (devClv == null) ? 1 : devClv;
      if(devClv != globals.devClvTmp){
        return;
      }
    }

    if(this._dataShared.segReg == 0) {

      if(this._recibirNotif == null) {
        await this._sess.setBool(spConst.sp_notif, true);
      }else{

        if(this._recibirNotif) {
          //Grabamos la clave permanente para utilizarla de señal y no duplicar el hilo actual ya configurado - solo en DEV
          this._sess.setInt(spConst.sp_devClv, 1);
          if(!dataShared.isConfigPush){
            await configGMSSngt.initConfigGMS();
          }
          String token = await configGMSSngt.getTokenDevice();
          if(token != this._tokenDB) {
            // Actualizar el token nuevo en la BD y servidor.
            await emUser.updateTokenDevice(token);
          }
        }
      }
    }

    // Vemos si hay notificaciones almacenadas en la BD, para mostrar el Icon.
    int notif = await _checkHasNotific();
    if(notif > 0){
      configGMSSngt.showNotificacionesIcon(notif);
    }
  }

  ///
  Future<int> _checkHasNotific() async {

    if(!this._isNewInstalationApp){
      final hasBackup = await emNotific.descargarNotificacionesBackUp();
      if(hasBackup){
        List<Map<String, dynamic>> notis = await emNotific.createObjectsFromSave(emNotific.result['body']);
        if(notis.isNotEmpty){
          Provider.of<DataShared>(this._context, listen: false).setAllNotifics(notis);
        }
      }
      List<Map<String, dynamic>> res = await emNotific.makeBackupNotificaciones(has: true);
      return res[0]['has'];
    }
    return 0;
  }

  ///
  Future<void> _checkMarcasAndModelos() async {

    this._haciendo = 'Revisando Marcas y Modelos';
    setState(() {});
    bool hasAutos = await emAutos.hasMarcasAndModelos();
    if(!hasAutos) {
      await emAutos.getSetMarcasAndModelos();
    }
  }

  ///
  Future<void> _checkInCarShop() async {

    int cant = await emShop.getCantActualInCarShop();
    Provider.of<DataShared>(this._context, listen: false).setCantTotalInCarrito(cant);
  }
}