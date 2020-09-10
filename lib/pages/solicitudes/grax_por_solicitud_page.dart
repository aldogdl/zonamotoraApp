import 'package:flutter/material.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/config_gms_sngt.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';


class GraxPorSolicitudPage extends StatefulWidget {
  @override
  _GraxPorSolicitudPageState createState() => _GraxPorSolicitudPageState();
}

class _GraxPorSolicitudPageState extends State<GraxPorSolicitudPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  ConfigGMSSngt configGMSSngt = ConfigGMSSngt();
  MenuInferior menuInferior = MenuInferior();
  UserRepository emUser = UserRepository();

  Size _screen;
  BuildContext _context;
  bool _showAppBarr = true;
  bool _isInit = false;

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;
    double altoImg = (this._screen.height <= 550) ? 0.545 : 0.43;

    if(!this._isInit){
      this._isInit = true;
      configGMSSngt.setContext(this._context);
    }

    return Scaffold(
      appBar: (this._showAppBarr) ? appBarrMy.getAppBarr(titulo: '¡ Buscando para ti !') : null,
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: this._screen.height * altoImg,
                child: _image(altoImg),
              ),
              const SizedBox(height: 35),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                  'Por favor, Quedate al pendiente, ya que estarás recibiendo las cotizaciones durante el día',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '¿Qué deceas hacer?',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w200,
                  fontSize: 30
                ),
              ),
              Divider(),
              SizedBox(
                width: this._screen.width,
                child: _btnToDos(),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Nuevamente te extendemos nuestro agradecimiento por tu confianza.',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange[600],
                    fontSize: 15
                  ),
                ),
              ),
              SizedBox(height: 20)
            ],
          ),
        )
      )
    );
  }

  ///
  Widget _image(double altoImg) {

    double posMsg = (this._screen.height <= 550) ? (altoImg - 0.13) : (altoImg - 0.09);
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
          top: 0,
          child: SizedBox(
            height: 260,
            width: this._screen.width,
            child: Image(
              image: AssetImage('assets/images/call_center.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: this._screen.height * posMsg,
          width: this._screen.width,
          child: Center(
            child: Container(
              width: this._screen.width * 0.9,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    offset: Offset(1, 2),
                    color: Colors.grey
                  )
                ]
              ),
              child: Text(
                'Estamos procesando tu solicitud, en breve recibirás respuesta de confirmación.',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  ///
  Widget _btnToDos() {

    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueGrey,
            child: Icon(Icons.home),
          ),
          title: Text(
            'Ir al Inicio'
          ),
          subtitle: Text(
            'Visitar la página principal'
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () => Navigator.of(this._context).pushNamedAndRemoveUntil('index_page', (Route rutas) => false),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(Icons.format_list_numbered, color: Colors.white),
          ),
          title: Text(
            'Buscar más Refacciones'
          ),
          subtitle: Text(
            'Cotizar Piezas para un auto'
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () => Navigator.of(this._context).pushNamedAndRemoveUntil('add_autos_page', (Route rutas) => false),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(Icons.extension),
          ),
          title: Text(
            'Ver lista de Solicitudes'
          ),
          subtitle: Text(
            'Revisar cotizaciones actuales'
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () => Navigator.of(this._context).pushNamedAndRemoveUntil('index_cotizacion_page', (Route rutas) => false),
        ),
      ],
    );
  }

}