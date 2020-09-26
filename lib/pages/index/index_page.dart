import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/config_gms_sngt.dart';
import 'package:zonamotora/singletons/limpiar_basura_sngt.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/banners_top.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/shared_preference_const.dart' as constSp;

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  ConfigGMSSngt configGMSSngt = ConfigGMSSngt();
  MenuInferior menuInferior = MenuInferior();
  UserRepository emUser = UserRepository();
  LimpiarBasuraSngt limpiarBasuraSngt = LimpiarBasuraSngt();

  Size _screen;
  BuildContext _context;
  GlobalKey<ScaffoldState> _keySk = GlobalKey<ScaffoldState>();
  DataShared _dataShared;
  bool _isInit = true;
  bool _verPageWelcome = false;
  List<Widget> tablaRowsReg = new List();
  String _username = '';
  bool _isSocio = false;
  SwiperController _ctrlPages = SwiperController();

  @override
  Widget build(BuildContext context) {

    this._screen = MediaQuery.of(context).size;
    this._context = context;
    context = null;

    if(this._isInit){
      this._isInit = false;
      this._dataShared = Provider.of<DataShared>(this._context);
      limpiarBasuraSngt.setContext(this._context, this._dataShared.lastPageVisit);
      this._username = (this._dataShared.username == null) ? 'Anónimo' : this._dataShared.username;
      configGMSSngt.setContext(this._context);
      this._dataShared.setLastPageVisit('index_page');
      _checkPageWelcome();
    }

    double alto = (this._screen.height < 550) ? 0.85 : 0.795;
    return Scaffold(
      key: this._keySk,
      appBar: appBarrMy.getAppBarr( titulo: (this._verPageWelcome) ? 'Bienvenid@' : 'Página Principal'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: FutureBuilder(
          future: _checkPageWelcome(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(this._verPageWelcome) {
              return _welcome();
            }
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: this._screen.width,
                    height: this._screen.height * alto,
                    child: _body(),
                  ),
                  Container(
                    height: 5,
                    color: Colors.black,
                  ),
                ],
              )
            );
          },
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0)
    );
  }

  ///
  Future<void> _checkPageWelcome() async {

    SharedPreferences sess = await SharedPreferences.getInstance();
    this._verPageWelcome = sess.getBool(constSp.sp_showWelcome);
    if(this._verPageWelcome == null) {
      this._verPageWelcome = true;
      sess.setBool(constSp.sp_showWelcome, true);
    }
  }

  ///
  Widget _welcome() {
    List<Widget> vistas = [
      _pageInitWelcome(),
      _pageQueSigue()
    ];

    return Container(
      child: Swiper(
        loop: false,
        itemCount: vistas.length,
        autoplay: false,
        controller: this._ctrlPages,
        pagination: new SwiperPagination(),
        itemBuilder: (BuildContext context, int index) {
          return vistas[index];
        },
      ),
    );
  }

  ///
  Widget _pageInitWelcome() {

    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.black,
            Colors.red[300]
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter
        ),
      ),
      child: Stack(
        children: <Widget>[
          _getBolaSupDerWelcome(),
          _getBolaInfIzqWelcome(),
          Positioned(
            width: this._screen.width,
            top: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: (this._screen.height <= 550) ? 100 : 100,
                  height: (this._screen.height <= 550) ? 100 : 100,
                  child: Image(
                    image: AssetImage('assets/images/zona_motora.png'),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '¡BIENVENID@!',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.2
                  ),
                ),
                SizedBox(height: (this._screen.height <= 550) ? 20 : 40),
                SizedBox(
                  width: this._screen.width * 0.9,
                  child: Text(
                    'Somos tu mejor opción de búsqueda y solución a todas las necesidades de tu Automóvil',
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: (this._screen.height <= 550) ? 16 : 18,
                      letterSpacing: 1.2
                    ),
                  ),
                ),
                SizedBox(height: (this._screen.height <= 550) ? 15 : 30),
                SizedBox(
                  width: this._screen.width * 0.9,
                  child: Text(
                    'Podrás encontrar Refacciones, Autos y Servicios específicos para el auto que manejas.',
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: (this._screen.height <= 550) ? 16 : 18,
                      letterSpacing: 1.2
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: this._screen.height * 0.05,
            width: this._screen.width,
            child: Center(
              child: SizedBox(
                width: this._screen.width * 0.7,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  color: Colors.white,
                  child: Text(
                    '¡Conoce los Beneficios!',
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red
                    ),
                  ),
                  onPressed: () => this._ctrlPages.next()
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// pii001
  Widget _pageQueSigue() {

    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.black,
            Colors.red[300]
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter
        ),
      ),
      child: Stack(
        children: <Widget>[
          _getBolaSupDerWelcome(),
          _getBolaInfIzqWelcome(),
          Positioned(
            width: this._screen.width,
            top: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                (this._screen.height <= 550)
                ?
                SizedBox(height: 0)
                :
                SizedBox(
                  width: this._screen.width * 0.9,
                  child: RichText(
                    textAlign: TextAlign.center,
                    textScaleFactor: 1,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Para una mejor experiencia te recomendamos ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: (this._screen.height <= 550) ? 16 : 16,
                            letterSpacing: 1.2
                          ),
                        ),
                        TextSpan(
                          text: 'Crear tu Cuenta',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                            fontSize: (this._screen.height <= 550) ? 16 : 16,
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(
                                blurRadius: 0,
                                offset: Offset(1,1),
                                color: Colors.black
                              )
                            ]
                          ),
                          recognizer: new TapGestureRecognizer()..onTap = () {
                            _accionEntendidoHelpPages();
                            Navigator.of(this._context).pushNamedAndRemoveUntil('reg_index_page', (Route rutas) => false);
                          }
                        ),
                        TextSpan(
                          text: '. Es fácil y ¡completamente GRATIS!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: (this._screen.height <= 550) ? 16 : 18,
                            letterSpacing: 1.2,
                            height: 1.2
                          )
                        ),
                      ]
                    )
                  ),
                ),
                SizedBox(height: (this._screen.height <= 550) ? 0 : 15),
                const Text(
                  '¿ QUÉ DESEAS HACER ?',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.2,
                    shadows: [
                      BoxShadow(
                        blurRadius: 2,
                        offset: Offset(1, 2),
                        color: Colors.black
                      )
                    ]
                  ),
                ),
                
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: (this._screen.height <= 550) ? 10 : 20),

                    InkWell(
                      onTap: (){
                        _accionEntendidoHelpPages();
                        Navigator.of(this._context).pushNamedAndRemoveUntil('mis_autos_page', (Route rutas) => false);
                      },
                      child: _machoteDeOpcionesQueSigue(
                        icono: Icons.directions_car,
                        titulo: 'Registra tu autor en tu App',
                        subTitulo: 'Filtra y Recibe lo que te interesa.',
                      ),
                    ),
                    SizedBox(height: (this._screen.height <= 550) ? 10 : 20),

                    InkWell(
                      onTap: (){
                        _accionEntendidoHelpPages();
                        Navigator.of(this._context).pushNamedAndRemoveUntil('reg_index_page', (Route rutas) => false);
                      },
                      child: _machoteDeOpcionesQueSigue(
                        icono: Icons.extension,
                        titulo: 'Solicitar Cotización de Refacción',
                        subTitulo: 'Esta opción requiere tener tu cuenta.',
                      ),
                    ),
                    SizedBox(height: (this._screen.height <= 550) ? 10 : 20),
                    
                    InkWell(
                      onTap: (){
                        _accionEntendidoHelpPages();
                        Navigator.of(this._context).pushNamedAndRemoveUntil('servs_index_page', (Route rutas) => false);
                      },
                      child: _machoteDeOpcionesQueSigue(
                        icono: Icons.add_to_home_screen,
                        titulo: 'Encontrar Servicios Automotrices',
                        subTitulo: '¿Qué necesita tu auto?.',
                      ),
                    ),
                  ],
                )
                
              ],
            ),
          ),
          Positioned(
            bottom: this._screen.height * 0.05,
            width: this._screen.width,
            child: Center(
              child: SizedBox(
                width: this._screen.width * 0.7,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  color: Colors.white,
                  child: Text(
                    'CERRAR y CONTINUAR',
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red
                    ),
                  ),
                  onPressed: (){
                    _accionEntendidoHelpPages();
                    Navigator.of(this._context).pushNamedAndRemoveUntil('index_page', (route) => false);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ///
  Widget _getBolaSupDerWelcome() {

    return Positioned(
      top: -this._screen.width / 2,
      right: -this._screen.width / 2,
      child: Container(
        height: this._screen.width,
        width: this._screen.width,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(50),
          borderRadius: BorderRadius.circular(this._screen.width)
        ),
      ),
    );
  }

  ///
  Widget _getBolaInfIzqWelcome() {

    return Positioned(
      top: this._screen.width / 2,
      right: this._screen.width / 2,
      child: Container(
        height: this._screen.width,
        width: this._screen.width,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(25),
          borderRadius: BorderRadius.circular(this._screen.width)
        ),
      ),
    );
  }

  ///
  Widget _machoteDeOpcionesQueSigue({@required IconData icono, @required String titulo, @required String subTitulo}) {

    return Container(
      width: this._screen.width * 0.87,
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 2,
          color: Colors.white,
          style: BorderStyle.solid
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(1, 2),
            color: Colors.black
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            maxRadius: 17,
            child: Icon(icono),
          ),
          const SizedBox(width: 7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                titulo,
                textScaleFactor: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: (this._screen.height <= 550) ? 14 : 14,
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(
                subTitulo,
                textScaleFactor: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                color: Colors.grey[600],
                fontSize: (this._screen.height <= 550) ? 13 : 13
              ),
              )
            ],
          )
        ],
      ),
    );
  }

  ///
  Future<void> _accionEntendidoHelpPages() async {

    SharedPreferences sess = await SharedPreferences.getInstance();
    sess.setBool(constSp.sp_showWelcome, false);
    this._verPageWelcome = false;
    setState(() {});
  }

  ///
  Widget _body() {

    double posBtns =  (this._username == 'Anónimo') ? 0.40  : 0.53;
    return Stack(
      children: <Widget>[

        _background(),

        // Banners
        Positioned(
          top: 0,
          child:  BannersTop()
        ),

        // Autorizado como
        Positioned(
          top: this._screen.height * 0.23,
          child:  SizedBox(
            width: this._screen.width,
            child: InkWell(
              onTap: () {
                Provider.of<DataShared>(this._context, listen: false).setLastPageVisit('index_page');
                Navigator.of(this._context).pushReplacementNamed('login_page');
              },
              child: _autorizadoComo(),
            )
          ),
        ),

        // Botones
        Positioned(
          top: this._screen.height * posBtns,
          width: this._screen.width,
          height: this._screen.height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: FutureBuilder(
              future: _deternimarBotonesSegunRole(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  return getTablaFinalDeBotones();
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ],
    );
  }

  ///
  Widget _background() {

    return Stack(
      children: <Widget>[
        //El fondo completo
        Container(
          width: this._screen.width,
          height: this._screen.height,
          decoration: BoxDecoration(
            color: Colors.red[400]
          ),
          child: CustomPaint(
            painter: Dibujo(),
          ),
        ),
        //una bola
        Positioned(
          top: -this._screen.width * 0.90,
          left: -50,
          child: Container(
            width: this._screen.width + 100,
            height: this._screen.width +100,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 87, 51, 1),
              borderRadius: BorderRadius.circular(this._screen.width)
            ),
          ),
        ),
        //una bola
        Positioned(
          top: this._screen.width * 0.9,
          left: 100,
          child: Container(
            width: this._screen.width + 100,
            height: this._screen.width +100,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 87, 51, 0.5),
              borderRadius: BorderRadius.circular(this._screen.width),
              boxShadow: [
                BoxShadow(
                  blurRadius: 25,
                  color: Color.fromRGBO(224, 50, 12, 1),
                  spreadRadius: 1
                )
              ]
            ),
          ),
        ),

        // La parte mas tinta
        Positioned(
          top: 0,
          child: Container(
            width: this._screen.width,
            height: this._screen.height * 0.45,
            decoration: BoxDecoration(
              color: Color(0xff7C0000)
            ),
            child: CustomPaint(
              painter: Dibujo2(),
            ),
          ),
        )
      ],
    );
  }

  ///
  Widget _autorizadoComo() {

    double radiusIcon = (this._screen.height <= 550) ? 40 : 50;
    return Center(
      child: Container(
        height: this._screen.height * 0.3,
        width: this._screen.width * 0.7,
        child: Stack(
          children: <Widget>[
            
            // Contenedor del tipo de autorizacion
            Positioned(
              top: 35,
              child: Container(
                height: this._screen.height * 0.085,
                width: this._screen.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      offset: Offset(3, 3)
                    )
                  ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${this._username}',
                      textScaleFactor: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5
                      ),
                    ),
                    Text(
                      (this._username != 'Anónimo') ? 'Usuario Autorizado' : 'Identifícate por favor',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 13
                      ),
                    ),
                    const SizedBox(height: 7)
                  ],
                )
              ),
            ),

            // Icono del candado
            Positioned(
              top: 0,
              child: SizedBox(
                width: this._screen.width * 0.70,
                child: Center(
                  child: Container(
                    width: radiusIcon,
                    height: radiusIcon,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3
                        )
                      ]
                    ),
                    child: (this._username == 'Anónimo')
                    ?
                    Icon(Icons.lock_open, color: Colors.blue)
                    :
                    Icon(Icons.lock, color: Colors.green)
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  ///
  List<Widget> _getBtnsSame() {

    List<Widget> lst = new List();
    lst.add(_buildBtnMenuGenerico(icono: Icons.extension, titulo: 'AutoPartes', numIndice: 4));
    lst.add(_buildBtnMenuGenerico(icono: Icons.directions_car, titulo: 'Vehículos', numIndice: 6));
    lst.add(_buildBtnMenuGenerico(icono: Icons.build, titulo: 'Servicios', numIndice: 5));
    return lst;
  }

  ///
  List<Widget> _getBtnsAnonimo() {

    List<Widget> lst = new List();
    lst.add(_buildBtnMenuGenerico(icono: Icons.verified_user, titulo: 'Crear Cuenta', numIndice: 1));
    lst.add(_buildBtnMenuGenerico(icono: Icons.account_circle, titulo: 'Hacer Lógin', numIndice: 2));
    lst.add(_buildBtnMenuGenerico(icono: Icons.drive_eta, titulo: 'Mis AUTOS', numIndice: 3));
    return lst;
  }

  ///
  Widget getTablaFinalDeBotones() {

    String titAcc = (this._username != 'Anónimo') ? 'Buscar' : 'Hacer';
    return Column(
      children: [

        Text(
          '¿Qué deseas $titAcc?',
          textAlign: TextAlign.center,
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.red[100],
            letterSpacing: 1
          ),
        ),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            (!this._isSocio && this._username == 'Anónimo')
            ?
            TableRow(
              children: _getBtnsAnonimo()
            )
            :
            TableRow(
              children: [
                const SizedBox(height: 0),
                const SizedBox(height: 0),
                const SizedBox(height: 0),
              ]
            ),
            TableRow(
              children: _getBtnsSame()
            ),
          ],
        )
      ],
    );
  }

  ///
  Future<bool> _deternimarBotonesSegunRole() async {
    this._isSocio =  await emUser.isSocio();
    return true;
  }

  ///
  Widget _buildBtnMenuGenerico({IconData icono, String titulo, int numIndice}) {

    return FittedBox(
      fit: BoxFit.cover,
      child: InkWell(
        onTap: (){
          switch (numIndice) {
            case 1:
              Navigator.of(this._context).pushNamedAndRemoveUntil('reg_index_page', (Route rutas) => false);
              break;
            case 2:
              this._dataShared.setLastPageVisit('index_page');
              Navigator.of(this._context).pushNamedAndRemoveUntil('login_page', (Route rutas) => false);
              break;
            case 3:
              Navigator.of(this._context).pushNamedAndRemoveUntil('mis_autos_page', (Route rutas) => false);
              break;
            case 4:
              Navigator.of(this._context).pushNamedAndRemoveUntil('refac_index_page', (Route rutas) => false);
              break;
            case 5:
              Navigator.of(this._context).pushNamedAndRemoveUntil('servs_index_page', (Route rutas) => false);
              break;
            case 6:
              Navigator.of(this._context).pushNamedAndRemoveUntil('autos_index_page', (Route rutas) => false);
              break;
            default:
              Navigator.of(this._context).pushNamedAndRemoveUntil('index_page', (Route rutas) => false);
          }
        },
        splashColor: Colors.white,
        highlightColor: Colors.white,
        hoverColor: Colors.white,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
          width: 50.0,
          height: 48.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 255, 255, 0.8),
                Color.fromRGBO(255, 255, 255, 0.6)
              ],
              begin: Alignment.topRight
            ),
            border: Border.all(
              color: Colors.red[100]
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 1,
                color: Color(0xffAF270A),
                offset: Offset(2,2)
              )
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(icono, size: 20, color: (titulo == 'Buscador') ? Colors.white : Colors.black),
              const SizedBox(height: 4),
              Text(
                '$titulo',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 7,
                  color: (titulo == 'Buscador') ? Colors.white : Colors.black,
                  fontWeight: (titulo == 'Buscador') ? FontWeight.bold : FontWeight.normal
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      )
    );
  }

}


// Clases para dibujar el Bacground

class Dibujo extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    
    Path path = new Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();

    Paint paint = new Paint();
    paint.color = Colors.red[600];
    return canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {

    return false;
  }

}

class Dibujo2 extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    
    Path path = new Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height + 30);
    path.lineTo(size.width, size.height);
    path.close();

    Paint paint = new Paint();
    paint.color = Color(0xff7C0000);
    canvas.drawShadow(path, Colors.black, 5, true);

    return canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {

    return false;
  }

}