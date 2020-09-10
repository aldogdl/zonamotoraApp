import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/entity/usuario_entity.dart';
import 'package:zonamotora/repository/mis_autos_repository.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/config_gms_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/shared_preference_const.dart' as spConsts;

class RecoveryCuentaPage extends StatefulWidget {
  @override
  _RecoveryCuentaPageState createState() => _RecoveryCuentaPageState();
}

class _RecoveryCuentaPageState extends State<RecoveryCuentaPage> {

  UsuarioEntity userEntiy       = UsuarioEntity();
  UserRepository emUser         = UserRepository();
  ConfigGMSSngt msgConfigSgt    = ConfigGMSSngt();
  AlertsVarios alertsVarios     = AlertsVarios();
  MisAutosRepository emMisAutos = MisAutosRepository();

  Size _screen;
  int _currentStep = 0;
  bool _hasError = false;
  bool _inicializado = false;
  List<Map<String, dynamic>> _listPasos = new List();
  Widget _contenidoStep = Center(child: LinearProgressIndicator());
  Map<String, dynamic> _params;
  SharedPreferences _sess;
  BuildContext _context;
  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();

  @override
  void initState() {
    _crearListaDePasos();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;
    this._params = ModalRoute.of(this._context).settings.arguments;
    double altoScreen = (this._screen.height <= 550) ? 0.73 : 0.75;

    if(!this._inicializado) {
      this._inicializado = true;
      msgConfigSgt.setContext(this._context);
      _getTokens();
    }

    return Scaffold(
      appBar: appBarrMy.getAppBarr(titulo: 'Recuperando cuenta'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              child: SizedBox(
                height: this._screen.height * altoScreen,
                child: _pasos(),
              )
            )
          ],
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  /* */
  Widget _pasos() {

    List<Step> steps = new List();
    this._listPasos.forEach((paso) {
      steps.add(_printPaso(paso));
    });

    return Stepper(
      currentStep: this._currentStep,
      controlsBuilder:
      (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        if(this._hasError) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
             FlatButton.icon(
               icon: Icon(Icons.arrow_back_ios, size: 13,),
               label: const Text(
                 'REGRESAR',
                 textScaleFactor: 1,
                 style: TextStyle(
                   color: Colors.orange
                 ),
               ),
               onPressed: () => Navigator.of(this._context).popAndPushNamed('login_page')
             ),
             FlatButton(
               child: const Text(
                 'REINTENTAR', 
                 textScaleFactor: 1,
                 style: TextStyle(
                   color: Colors.blue
                 ),
               ),
               onPressed: () async {
                 setState(() {
                  this._hasError = false;
                  this._contenidoStep = Center(child: LinearProgressIndicator());
                  this._listPasos[this._currentStep]['active'] = true;
                  this._listPasos[this._currentStep]['status'] = StepState.editing;
                });
                 switch (this._currentStep) {
                   case 0:
                     await _getTokens();
                     break;
                   case 1:
                     await _getCredentialsFromServer();
                     break;
                   case 2:
                     await _setCredentialsInDb();
                     break;
                   case 3:
                     await _getAutosRegFromServer();
                     break;
                   case 4:
                     await _getSolicitudesFromServer();
                     break;
                   case 5:
                     await _getRespuestasFromServer();
                     break;
                   default:
                 }
               },
             ),
           ],
         );
        }else{
          return SizedBox(height: 0);
        }
      },
      steps: steps,
    );
  }

  /* */
  Step  _printPaso(Map<String, dynamic> paso) {

    return Step(
      title: Text(
        paso['titulo'],
        textScaleFactor: 1,
      ),
      content: this._contenidoStep,
      isActive: paso['active'],
      state: paso['status']
    );
  }

  /* */
  Future<void> _crearListaDePasos() async {

    this._listPasos.add({
      'active' : false,
      'status' : StepState.indexed,
      'titulo' :' Obteniendo tus TOKENS',
    });
    this._listPasos.add({
      'active' : false,
      'status' : StepState.indexed,
      'titulo' :'Recuperaremos tus Credenciales',
    });
    this._listPasos.add({
      'active' : false,
      'status' : StepState.indexed,
      'titulo' :'Guardando tus Credenciales',
    });
    this._listPasos.add({
      'active' : false,
      'status' : StepState.indexed,
      'titulo' :'Revisando tus Autos Registrados',
    });
    this._listPasos.add({
      'active' : false,
      'status' : StepState.indexed,
      'titulo' :'Recuperando tus Solicitudes',
    });
    this._listPasos.add({
      'active' : false,
      'status' : StepState.indexed,
      'titulo' :'Buscando tus respuestas',
    });
    this._listPasos.add({
      'active' : false,
      'status' : StepState.indexed,
      'titulo' :'Últimas configuraciones',
    });

  }

  /* PASO 0 */
  Future<void> _getTokens() async {

    this._sess = await SharedPreferences.getInstance();
    setState(() {
      this._currentStep = 0;
      this._listPasos[this._currentStep]['active'] = true;
    });

    emUser.getTokenFromServer(dataUser: this._params).then((Map<String, dynamic> res) async {

      if(res.containsKey('abort')) {
        _showError(res);
      }else{
        setState(() {
          this._listPasos[this._currentStep]['status'] = StepState.complete;
        });
        
        this._sess.setBool(spConsts.sp_notif, true);
        userEntiy.setTokenDevice(await msgConfigSgt.getTokenDevice());
        userEntiy.setTokenServer(res['token']);

        // Almacenamos en SharedPreference la siguinete fecha para refresh TokenServer
        DateTime fecha = DateTime.now();
        DateTime update = fecha.add(Duration(seconds: 216000));
        DateFormat format = DateFormat('yyyy-MM-dd');
        String nuevaFecha = '${format.format(update)} 00:00:00';
        await this._sess.setString(spConsts.sp_updateTokenServerAt, nuevaFecha);
        fecha = null; update = null;

        _getCredentialsFromServer();
      }
    });
  }

  /* PASO 1 */
  Future<void> _getCredentialsFromServer() async {
    
    setState(() {
      this._currentStep = 1;
      this._listPasos[this._currentStep]['active'] = true;
    });

    userEntiy.setUsername(this._params['u_usname']);
    userEntiy.setPassword(this._params['u_uspass']);

    emUser.getDataUserFromServer(userEntiy).then((Map<String, dynamic> res) async {
      if(res.containsKey('abort')) {
        _showError(res);
      }else{
        setState(() {
          this._listPasos[this._currentStep]['status'] = StepState.complete;
        });
        userEntiy.setId(res['u_id']);
        userEntiy.setNombre(res['u_nombre']);
        userEntiy.setRoles(res['u_roles']);
        _setCredentialsInDb();
      }
    });
  }

  /* PASO 2 */
  Future<void> _setCredentialsInDb() async {

    setState(() {
      this._currentStep = 2;
      this._listPasos[this._currentStep]['active'] = true;
    });
    
    emUser.updateDataUserInBd(userEntiy.toDb()).then((int saved) async {
      if(saved == 0) {
        _showError({
          'msg' : 'SIN GUARDAR',
          'body': 'Ocurrio un Error inesperado.\nReintenta guardar tu datos nuevamente, por favor.'
        });
      }else{
        setState(() {
          this._listPasos[this._currentStep]['status'] = StepState.complete;
        });
        _getAutosRegFromServer();
      }
    });
  }

  /* PASO 3 */
  Future<void> _getAutosRegFromServer() async {

    setState(() {
      this._currentStep = 3;
      this._listPasos[this._currentStep]['active'] = true;
    });
    
    emMisAutos.getMisAutosFromServer().then((autos) async {

      if(autos.length > 0) {

        if(autos.first.containsKey('abort')){

          this._hasError = true;
          _showError({
            'msg' : autos.first['msg'],
            'body': autos.first['body']
          });

        }else{

          this._sess.setBool(spConsts.sp_isViewAutos, true);
          await emMisAutos.setListAutos(autos);
          setState(() {
            this._listPasos[this._currentStep]['status'] = StepState.complete;
          });
          _getSolicitudesFromServer();
        }

      }else{
        this._sess.setBool(spConsts.sp_isViewAutos, false);
        await emMisAutos.borrarAutosDeEsteDispositivo();
        _getSolicitudesFromServer();
      }
    });
  }

  /* PASO 4 */
  Future<void> _getSolicitudesFromServer() async {

    setState(() {
      this._currentStep = 4;
      this._listPasos[this._currentStep]['active'] = true;
    });
    _getRespuestasFromServer();
  }

  /* PASO 5 */
  Future<void> _getRespuestasFromServer() async {

    setState(() {
      this._currentStep = 5;
      this._listPasos[this._currentStep]['active'] = true;
    });
    _lastConfig();
  }

  /* PASO 6 */
  Future<void> _lastConfig() async {
    setState(() {
      this._currentStep = 6;
      this._listPasos[this._currentStep]['active'] = true;
    });
    String body = 'Tu cuenta fué recuperada.\nEl sistema se reinicializará para realizar las últimas configuraciones';
    Provider.of<DataShared>(this._context, listen: false).setTokenAsesor(null);
    await alertsVarios.entendido(this._context, titulo: 'HOLA DE NUEVO\n${ userEntiy.nombre }', body: body);
    Navigator.of(this._context).pushNamedAndRemoveUntil('init_config_page', (Route rutas) => false);
  }


  /* El template para mostrar los errores */
  void _showError(Map<String, dynamic> res) {
    setState(() {
      this._hasError = true;
      this._listPasos[this._currentStep]['active'] = true;
      this._listPasos[this._currentStep]['status'] = StepState.error;
      this._contenidoStep = _printContainerErr(res);
    });
  }

  /* */
  Widget _printContainerErr(Map<String, dynamic> data) {

    return Container(
      width: this._screen.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '${data['msg']}',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '${data['body']}',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

}