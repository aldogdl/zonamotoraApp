import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zonamotora/data_shared.dart';
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
  MenuInferior menuInferior = MenuInferior();

  Size _screen;
  BuildContext _context;
  DataShared _dataShared;
  bool _isInit = false;
  bool _verPageWelcome = false;
  SwiperController _ctrlPages = SwiperController();

  @override
  Widget build(BuildContext context) {

    this._screen = MediaQuery.of(context).size;
    this._context = context;
    context = null;
    if(!this._isInit){
      this._isInit = true;
      this._dataShared = Provider.of<DataShared>(this._context);
      _checkPageWelcome();
    }

    return Scaffold(
      appBar: appBarrMy.getAppBarr(),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: FutureBuilder(
        future: _checkPageWelcome(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(this._verPageWelcome) {
            return _welcome();
          }
          return SingleChildScrollView(child: _body());
        },
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
                SizedBox(
                  width: (this._screen.height <= 550) ? 100 : 150,
                  height: (this._screen.height <= 550) ? 100 : 150,
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
                    '¿Quieres saber qué Sigue?',
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

  ///
  Widget _pageQueSigue() {

    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
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
                  child: Text(
                    'Para una mejor experiencia te recomendamos que te Registres',
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: (this._screen.height <= 550) ? 16 : 18,
                      letterSpacing: 1.2
                    ),
                  ),
                ),
                SizedBox(height: (this._screen.height <= 550) ? 0 : 20),
                const Text(
                  '¿ QUÉ SIGUE ?',
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
                SizedBox(height: (this._screen.height <= 550) ? 10 : 20),
                InkWell(
                  onTap: (){
                    _accionEntendidoHelpPages();
                    Navigator.of(this._context).pushNamedAndRemoveUntil('reg_index_page', (Route rutas) => false);
                  },
                  child: _machoteDeOpcionesQueSigue(
                    icono: Icons.extension,
                    titulo: 'Solicitar Cotización de Refacción',
                    subTitulo: 'Ésta opción requiere que te registres',
                  ),
                ),
                SizedBox(height: (this._screen.height <= 550) ? 10 : 20),
                InkWell(
                  onTap: (){
                    _accionEntendidoHelpPages();
                    //Navigator.of(this._context).pushNamedAndRemoveUntil('reg_index_page', (Route rutas) => false);
                  },
                  child: _machoteDeOpcionesQueSigue(
                    icono: Icons.directions_car,
                    titulo: 'Buscar Automóviles',
                    subTitulo: 'También podrás vender fácilmente',
                  ),
                ),
                SizedBox(height: (this._screen.height <= 550) ? 10 : 20),
                InkWell(
                  onTap: (){
                    _accionEntendidoHelpPages();
                    //Navigator.of(this._context).pushNamedAndRemoveUntil('reg_index_page', (Route rutas) => false);
                  },
                  child: _machoteDeOpcionesQueSigue(
                    icono: Icons.add_to_home_screen,
                    titulo: 'Encontrar Servicios',
                    subTitulo: '¿Qué necesita tu auto?',
                  ),
                ),
                SizedBox(height: (this._screen.height <= 550) ? 10 : 20),
                InkWell(
                  onTap: (){
                    _accionEntendidoHelpPages();
                    Navigator.of(this._context).pushNamedAndRemoveUntil('reg_prof_index_page', (Route rutas) => false);
                  },
                  child: _machoteDeOpcionesQueSigue(
                    icono: Icons.add_to_home_screen,
                    titulo: 'Anunciarte con Nosotros',
                    subTitulo: 'Sin compromiso te visitamos',
                  )
                ),
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
                  onPressed: () => _accionEntendidoHelpPages(),
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
      width: this._screen.width * 0.86,
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
                  fontSize: (this._screen.height <= 550) ? 14 : 16
                ),
              ),
              Text(
                subTitulo,
                textScaleFactor: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                color: Colors.grey[600],
                fontSize: (this._screen.height <= 550) ? 13 : 15
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

  /* */
  Widget _body() {

    String username = (this._dataShared.username == null) ? 'Anónimo' : this._dataShared.username;
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
            child: _autorizadoComo(),
          ),
        ),

        // Botones
        Positioned(
          top: this._screen.height * 0.38,
          child:  SizedBox(
            width: this._screen.width,
            child: Container(
              padding: EdgeInsets.all(10),
              height: this._screen.height * 0.455,
              child: SingleChildScrollView(
                child: _tableDeBtns(),
              ),
            )
          ),
        ),
        // Buscas una Refaccion...
        (username == 'Anónimo')
        ?
        const SizedBox(height: 0)
        :
        Positioned(
            top: this._screen.height * 0.596,
            child: InkWell(
              child: _btnSolicitarRefacs(),
              onTap: (){
                Navigator.of(this._context).pushNamedAndRemoveUntil('lst_modelos_page', (Route rutas) => false);
              }
          )
        )
      ],
    );
  }

  /* */
  Widget _background() {

    return Stack(
      children: <Widget>[
        Container(
          width: this._screen.width,
          height: this._screen.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.red[400]
          ),
          child: CustomPaint(
            painter: Dibujo(),
          ),
        ),
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
        Positioned(
          top: 0,
          child: Container(
            width: this._screen.width,
            height: this._screen.height * 0.30,
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

  /* */
  Widget _autorizadoComo() {

    String username = (this._dataShared.username == null) ? 'Anónimo' : this._dataShared.username;
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
                      '$username',
                      textScaleFactor: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5
                      ),
                    ),
                    Text(
                      (username != 'Anónimo') ? 'Usuario Autorizado' : 'Identifícate por favor',
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
                    child: (username == 'Anónimo')
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

  /* */
  Widget _btnSolicitarRefacs() {

    double alto = (this._screen.height <= 550) ? 0.21 : 0.19;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: this._screen.height * alto,
      width: this._screen.width,
      color: Colors.red[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              '¡SOLICITA HOY MISMO!...',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown,
                letterSpacing: 1,
                fontSize: (this._screen.height <= 550) ? 15 : 19
              ),
            ),
          ),
          Divider(height: 10, color: Colors.white),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  height:60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: Colors.white),
                    gradient: LinearGradient(
                      colors: [
                        Colors.red[100],
                        Colors.red[800]
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  ),
                  child: Image(
                    image: AssetImage('assets/images/google-web-search.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Flexible(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Refacciones Seminuevas y Genericas. Todas las marcas y modelos',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: (this._screen.height <= 550) ? 13 : 16
                      ),
                      overflow: TextOverflow.clip,
                    ),
                    Text(
                      'SOLICITAR COTIZACIÓN >>',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.blue[800]
                      ),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      )
    );
  }

  /* */
  Widget _tableDeBtns() {

    List<Widget> tablaRowsReg;
    
    String username = (this._dataShared.username == null) ? 'Anónimo' : this._dataShared.username;
    if(username == 'Anónimo'){
      tablaRowsReg = [
        _buildBtnMenuGenerico(icono: Icons.verified_user, titulo: 'Registrarme', numIndice: 1),
        _buildBtnMenuGenerico(icono: Icons.account_circle, titulo: 'Hacer Lógin', numIndice: 2),
        _buildBtnMenuGenerico(icono: Icons.drive_eta, titulo: 'Mis AUTOS', numIndice: 3),
      ];
    }else{
      tablaRowsReg = [
        SizedBox(height: 0),
        SizedBox(height: 0),
        SizedBox(height: 0),
      ];
    }

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: tablaRowsReg
        ),
        TableRow(
          children: [
            _buildBtnMenuGenerico(icono: Icons.account_balance, titulo: 'ZonaMotora', numIndice: 4),
            _buildBtnMenuGenerico(icono: Icons.search, titulo: 'Buscador', numIndice: 5),
            _buildBtnMenuGenerico(icono: Icons.add_shopping_cart, titulo: 'Publicar', numIndice: 6),
          ]
        )
      ],
    );
  }

  /* */
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
              // Navigator.of(this._context).pushNamedAndRemoveUntil('recovery_cuenta_page', (Route rutas) => false);
              break;
            case 5:
              Navigator.of(this._context).pushNamedAndRemoveUntil('buscar_index_page', (Route rutas) => false);
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
              Icon(icono, size: 20),
              const SizedBox(height: 4),
              Text(
                '$titulo',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 7
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