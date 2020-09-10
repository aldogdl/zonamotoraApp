import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';

class RegistroIndexPage extends StatefulWidget {
  @override
  _RegistroIndexPageState createState() => _RegistroIndexPageState();
}

class _RegistroIndexPageState extends State<RegistroIndexPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  UserRepository emUser = UserRepository();
  MenuInferior menuInferior = MenuInferior();
  AlertsVarios alertsVarios = AlertsVarios();

  Size _screen;
  BuildContext _context;
  bool _isInit = false;

  @override
  Widget build(BuildContext context) {

    this._screen = MediaQuery.of(context).size;
    this._context = context;
    context = null;
    if(!this._isInit) {
      this._isInit = true;
      appBarrMy.setContext(this._context);
      Provider.of<DataShared>(this._context, listen: false).setLastPageVisit('reg_index_page');
    }

    return Scaffold(
      appBar: appBarrMy.getAppBarr(titulo: 'Crea tu CUENTA!'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: Container(
        width: this._screen.width,
        child: _body(),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  /* */
  Widget _body() {

    String txt = '';
    txt += 'Registrarte en ZonaMotora te otorga ¡oportunidades increíbles!';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[

        // Icono y text de la cabecera
        Container(
          width: this._screen.width,
          height: this._screen.height * 0.15,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Color(0xff7C0000)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  height: 60,
                  width: 60,
                  child: Image(
                    image: AssetImage('assets/images/register.png'),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      txt,
                      softWrap: true,
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
                
              )
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Cards de Opciones
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const SizedBox(height: 10),
                Text(
                  'Selecciona un PERFIL',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w300,
                    color: Colors.red
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  child: _createCard(
                    titulo: 'SOY PARTICULAR',
                    cuerpo: 'Si eres dueño de un auto y no te dedicas a la comercialización del mundo automotriz',
                    foto: 'duenio_auto.jpg',
                    icono: Icons.vpn_key
                  ),
                  onTap: () async {
                    bool hasReg = await _checkRegActual();
                    if(!hasReg){
                      Navigator.of(this._context).pushReplacementNamed('reg_user_page', arguments: {'source':'user'});
                    }
                  },
                ),
                const SizedBox(height: 20),
                InkWell(
                  child: _createCard(
                    titulo: 'SOY PROFESIONAL AUTOMOTRIZ',
                    cuerpo: '¿VENDES Refacciones, Autos o realizasas cualquier tipo de Servicio Automotriz?',
                    foto: 'prof_automotriz.jpg',
                    icono: Icons.shopping_cart
                  ),
                  onTap: () async {
                    bool hasReg = await _checkRegActual();
                    if(!hasReg){
                      Navigator.of(this._context).pushReplacementNamed('reg_prof_index_page');
                    }
                  },
                ),
                const SizedBox(height: 20),
                InkWell(
                  child: _createCard(
                    titulo: 'ASESOR DE ZONAMOTORA',
                    cuerpo: 'Credenciales REQUERIDAS',
                    foto: 'zm_asesor.jpg',
                    icono: Icons.security
                  ),
                  onTap: () async {
                    DataShared datashared = Provider.of<DataShared>(this._context, listen: false);
                    if(datashared.tokenAsesor == null) {
                      Navigator.of(this._context).pushReplacementNamed('login_asesor_page');
                    }else{
                      Navigator.of(this._context).pushReplacementNamed('alta_index_menu_page');
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        )
      ],
    );
  }

  /* */
  Widget _createCard({String titulo, String cuerpo, String foto, IconData icono}) {

    return Container(
      padding: EdgeInsets.all(10),
      width: this._screen.width * 0.82,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            offset: Offset(1,2)
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Image(
              image: AssetImage('assets/images/$foto'),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                  '$titulo',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Icon(icono, color: Colors.green),
                ],
              ),
              Divider(),
              (titulo == 'ASESOR DE ZONAMOTORA')
              ?
              Consumer<DataShared>(
                builder: (_, dataShared, __){
                  if(dataShared.tokenAsesor != null) {
                    return FlatButton(
                      child: Text(
                        'SALIR DE LA SESIÓN',
                        textScaleFactor: 1,
                        style: TextStyle(
                          color: Colors.red
                        ),
                      ),
                      onPressed: () {
                        Provider.of<DataShared>(this._context, listen: false).setTokenAsesor(null);
                      },
                    );
                  }else{
                    return Text(
                      '$cuerpo',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.red[400],
                      ),
                      textAlign: TextAlign.center,
                    );
                  }
                },
              )
              :
              Text(
                '$cuerpo',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.red[400],
                ),
                textAlign: TextAlign.center,
              )
            ],
          )
        ],
      ),
    );
  }

  /* Utilizado para evitar que el usuario se registre dos veces */
  Future<bool> _checkRegActual() async {

    bool hasReg = false;
    Map<String, dynamic> dataUser = await emUser.getDataUser();
    if(dataUser['u_usname'] != null && dataUser['u_usname'].length > 4) {
      hasReg = true;
    }
    if(hasReg) {
      await alertsVarios.entendido(
        this._context,
        titulo: 'USUARIO REGISTRADO',
        body: 'Ya cuentas con un Registro ${dataUser['u_usname'].toUpperCase()}, por lo tanto, no es necesario realizar ésta acción nuevamente.'
      );
    }
    return hasReg;
  }
}