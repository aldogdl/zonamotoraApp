import 'package:flutter/material.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';


class GraxPorSolicitudPage extends StatefulWidget {
  @override
  _GraxPorSolicitudPageState createState() => _GraxPorSolicitudPageState();
}

class _GraxPorSolicitudPageState extends State<GraxPorSolicitudPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  UserRepository emUser = UserRepository();

  Size _screen;
  BuildContext _context;
  bool _showAppBarr = true;

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;
    double altoImg = (this._screen.height <= 550) ? 0.545 : 0.43;

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
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w200,
                  fontSize: 30
                ),
              ),
              Divider(),
              _btnToDos(),
              Divider(),
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () => Navigator.of(this._context).pushNamedAndRemoveUntil('index_page', (Route rutas) => false),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.home),
                ),
                Text(
                  'Regresar\nal Inicio',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () => Navigator.of(this._context).pushNamedAndRemoveUntil('index_page', (Route rutas) => false),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.format_list_numbered),
                ),
                Text(
                  'Listar mis Solicitudes',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () => Navigator.of(this._context).pushNamedAndRemoveUntil('lst_modelos_page', (Route rutas) => false),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.extension),
                ),
                Text(
                  'Hacer otra Solicitud',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

}