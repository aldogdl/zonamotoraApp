import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/config_gms_sngt.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/globals.dart' as globals;
import 'package:zonamotora/shared_preference_const.dart' as spConsts;


class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {

  AppBarrMy appBarrMy         = AppBarrMy();
  UserRepository emUser       = UserRepository();
  MenuInferior menuInferior   = MenuInferior();
  ConfigGMSSngt msgConfigSngt = ConfigGMSSngt();

  Size _screen;
  BuildContext _context;
  DateFormat _format;
  SharedPreferences _sess;
  bool _isInitConfig = false;
  Map<String, dynamic> _dataUser;

  Widget _nextUpdateTokenServer = Text('Calculando Fecha', textScaleFactor: 1);
  Widget _tokenServer = Text('Calculando Token Server', textScaleFactor: 1);
  Widget _tokenDevice = Text('Calculando Token Device', textScaleFactor: 1);
  Widget _appAutori   = Text('Aplicación Autorizada', textScaleFactor: 1);
  Widget _userApp     = Text('Datos Constantes', textScaleFactor: 1);

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;

    if(!this._isInitConfig) {
      this._isInitConfig = true;
      this._format = DateFormat('d-MM-yyyy');
      msgConfigSngt.setContext(this._context);
      _setSesion();
    }

    return Scaffold(
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: _body(),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  /* */
  Future<void> _setSesion() async {

    this._sess = await SharedPreferences.getInstance();
    this._dataUser = await emUser.getDataConfig();
    _nextTokenServer();
    _setWidgetTokenServer();
    _setWidgetTokenDevice();
    _setWidgetAppAutorizada();
    _setWidgetDatosConstantes();
  }

  /* */
  Widget _cabecera() {

    return Container(
      width: this._screen.width,
      height: this._screen.height * 0.3,
      child: Center(
        child: Image(
          image: AssetImage('assets/images/settings.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /* */
  Widget _body() {
    
    bool isConfigPush = Provider.of<DataShared>(this._context, listen: false).isConfigPush;
    isConfigPush = (isConfigPush == null) ? false : isConfigPush;

    return CustomScrollView(
      slivers: <Widget>[
        appBarrMy.getAppBarrSliver(titulo: 'Configuraciones', bgContent: _cabecera()),
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 70,
                      width: 70,
                      child: Image(
                        image: AssetImage('assets/images/zona_motora.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          this._dataUser['u_usname'].toString().toUpperCase(),
                          textScaleFactor: 1,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Divider(),
                        Text(
                          'Ajustes y Configuraciones',
                          textScaleFactor: 1,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600]
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings_ethernet),
              title: Text(
                'Versión de la Aplicacion',
                textScaleFactor: 1,
              ),
              subtitle: Text(
                '[ ${globals.version} ] Aplicación Instalada.',
                textScaleFactor: 1,
              ),
            ),
            this._appAutori,
            this._userApp,
            this._nextUpdateTokenServer,
            this._tokenServer,
            this._tokenDevice,
            ListTile(
              leading: Icon(Icons.notifications_active),
              title: Text(
                'Notificaciones Push',
                textScaleFactor: 1,
              ),
              subtitle: Text(
                (isConfigPush) ? 'Actualmente configurada' : 'Sin Configuración aún',
                textScaleFactor: 1,
              ),
            ),
          ]),
        )
      ],
    );
  }

  /* */
  Future<void> _nextTokenServer() async {

    String nextUpdateTokenServer = (this._sess.getString(spConsts.sp_updateTokenServerAt) == null) ? '' : this._sess.getString(spConsts.sp_updateTokenServerAt);

    if(nextUpdateTokenServer != null){
      if(nextUpdateTokenServer.isNotEmpty) {
        DateTime converObj = DateTime.parse(nextUpdateTokenServer);
        nextUpdateTokenServer = this._format.format(converObj);
      }else{
        nextUpdateTokenServer = null;
      }
    }
    String sti = ((nextUpdateTokenServer == null)) ? 'Siguiente Actualización Sin Definir.' :  'Siguiente Actualización $nextUpdateTokenServer';
    setState(() {
      this._nextUpdateTokenServer = _getListTitle(
        icono: Icons.date_range, titulo: 'Token Server:', subtitulo: sti
      );
    });
  }

  /* */
  Future<void> _setWidgetTokenServer() async {

    setState(() {
      this._tokenServer = _getListTitle(
        icono: Icons.vpn_key, titulo: 'Llave para Server:', subtitulo: '${this._dataUser['u_tokenServer']}'
      );
    });
  }

  /* */
  Future<void> _setWidgetTokenDevice() async {

    setState(() {
      this._tokenDevice = _getListTitle(
        icono: Icons.notification_important, titulo: 'Token Notificaciones:', subtitulo: '${this._dataUser['u_tokenDevices']}'
      );
    });
  }

  /* */
  Future<void> _setWidgetAppAutorizada() async {

    setState(() {
      this._appAutori = _getListTitle(
        icono: Icons.account_circle, titulo: 'Aplicación Autorizada para:', subtitulo: '${this._dataUser['u_nombre']}'
      );
    });
  }

  /* */
  Future<void> _setWidgetDatosConstantes() async {

    String subt = 'Usuario ID: ${this._dataUser['u_id']}  || Tipo: ${this._dataUser['u_roles']}';
    setState(() {
      this._userApp = _getListTitle(
        icono: Icons.settings_system_daydream, titulo: 'Datos Constantes:', subtitulo: subt
      );
    });
  }

  /* */
  Widget _getListTitle({IconData icono, String titulo, String subtitulo}) {

    return ListTile(
      leading: Icon(icono),
      title: Text(
        titulo,
        textScaleFactor: 1,
      ),
      subtitle: Text(
        subtitulo,
        textScaleFactor: 1,
      ),
    );
  }
}