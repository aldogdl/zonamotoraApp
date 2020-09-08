
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/globals.dart' as globals;
import 'package:zonamotora/repository/carshop_repository.dart';
import 'package:zonamotora/widgets/dialog_ver_fotos.dart';

class FichaTecnicaPzaWidget extends StatefulWidget {

  final List<Map<String, dynamic>> respuestas;
  const FichaTecnicaPzaWidget({this.respuestas});

  @override
  _FichaTecnicaPzaWidgetState createState() => _FichaTecnicaPzaWidgetState();
}

class _FichaTecnicaPzaWidgetState extends State<FichaTecnicaPzaWidget> {

  CarShopRepository emShop = CarShopRepository();
  
  BuildContext _context;
  DateFormat _dateFormat = DateFormat('d-MM-yyyy');
  String _msgTit = 'FICHA TÉCNICA';
  int _piezaSelecIndex = -1;

  Map<String, dynamic> _datafixed = new Map();
  Map<String, dynamic> _dataRespuesta = new Map();

  IconData _icoCarr = Icons.shopping_cart;
  Color _colorInCarrito = Colors.red;
  String _txtCarrito = 'Al Carrito';

  @override
  void initState() {

    if(widget.respuestas.length > 0) {
      this._piezaSelecIndex = 0;
      _existInCarShop(true);
      _hidratarDataFixed();
      _hidratarDataRespuestaActual();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;

    return Container(
      width: MediaQuery.of(this._context).size.width,
      height: MediaQuery.of(this._context).size.height * 0.90,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(0, 0),
            color: Colors.black.withAlpha(100),
            spreadRadius: 3
          )
        ]
      ),
      child: _body(),
    );
  }

  ///
  Widget _body() {

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _titulo(),
        // Contenido
        Container(
          height: MediaQuery.of(this._context).size.height * 0.8,
          width: MediaQuery.of(this._context).size.width,
          color: Colors.grey[100],
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _imagesPza(),
                _dataPzaAndCosto(),
                 Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: _publicAtAndAcciones(true),
                ),
                _lstRelacionadas(),
                const SizedBox(height: 17),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Más Detalles de la Pieza',
                    textScaleFactor: 1,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const Divider(height: 2),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    (this._dataRespuesta['detalles'] == '0') ? 'Sin más Detalles...' : '${this._dataRespuesta['detalles']}',
                    textScaleFactor: 1,
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 17),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'GARANTÍA de la Pieza',
                    textScaleFactor: 1,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const Divider(height: 2),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    (this._dataRespuesta['hasGarant']) ? _txtGarantiaSocio() : _txtSinGarantiasSocio(),
                    textScaleFactor: 1,
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 17),
                Divider(height: 1, color: Colors.grey[800]),
                const Divider(height: 1, color: Colors.white),
                const SizedBox(height: 17),
                CustomPaint(
                  painter: SeparadorTxtZm(),
                  child: SizedBox(
                    width: MediaQuery.of(this._context).size.width,
                    height: 15,
                    child: Center(
                      child: Transform.rotate(
                        angle: 95,
                        child: Container(
                          width: 10,
                          height: 10,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                _txtZonaMotora(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: _publicAtAndAcciones(false),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        )
      ],
    );
  }

  ///
  Widget _titulo() {

    return Container(
      width: MediaQuery.of(this._context).size.width,
      height: MediaQuery.of(this._context).size.height * 0.1,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8)
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '${this._datafixed['modelo']} ${this._datafixed['anio']}',
            textAlign: TextAlign.center,
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.1
            ),
          ),
          Text(
            '${this._msgTit}',
            textAlign: TextAlign.center,
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.1,
              fontSize: 12
            ),
          )
        ],
      ),
    );
  }

  ///
  Widget _imagesPza() {

    Widget foto = Image(
      image: AssetImage('assets/images/mas_ventas.png'),
      fit: BoxFit.fitWidth,
    );

    if(this._dataRespuesta['fotos'].length > 0){
      foto = InkWell(
        child: FadeInImage(
          image: NetworkImage('${globals.uriImageInvent}/${this._dataRespuesta['fotos'][0]}'),
          placeholder: AssetImage('assets/images/mas_ventas.png'),
          fit: BoxFit.cover,
        ),
        onTap: (){
          showDialog(
            context: this._context,
            builder: (BuildContext context) {
              return DialogVerFotosWidget(fotos: this._dataRespuesta['fotos'], typeFoto: 'inventario');
            }
          );
        },
      );
    }

    return Container(
      width: MediaQuery.of(this._context).size.width * 0.98,
      height: MediaQuery.of(this._context).size.height * 0.25,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              width: MediaQuery.of(this._context).size.width,
              height: MediaQuery.of(this._context).size.height * 0.25,
              child: foto
            ),
          ),
          Positioned(
            right: 0,
            top: 3,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(150),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5)
                )
              ),
              child: Text(
                '${this._datafixed['marca']}',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.5
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(this._context).size.width,
              padding: EdgeInsets.all(5),
              color: Colors.red.withAlpha(170),
              child: InkWell(
                onTap: (){
                  showDialog(
                    context: this._context,
                    builder: (BuildContext context) {
                      return DialogVerFotosWidget(fotos: this._dataRespuesta['fotos'], typeFoto: 'inventario');
                    }
                  );
                },
                child: Text(
                  'VER FOTOGRAfÍAS',
                  textAlign: TextAlign.center,
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.1,
                    fontSize: 12
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget _dataPzaAndCosto() {

    final costo = NumberFormat.currency(locale: 'en_US', symbol: '\$').format(this._dataRespuesta['costo']);

    return Container(
      width: MediaQuery.of(this._context).size.width,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15)
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${this._datafixed['pieza']}',
                textScaleFactor: 1,
                overflow: TextOverflow.clip,
                softWrap: true,
                textWidthBasis: TextWidthBasis.parent,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[400],
                ),
              ),
              SizedBox(height: 5),
              Text(
                '${this._datafixed['lado']} ${this._datafixed['posicion']}',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[400],
                  letterSpacing: 0.5
                ),
              )
            ],
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$costo',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Costo Sin IVA',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[400]
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  ///
  Widget _publicAtAndAcciones(bool isFirst) {

    DateTime fecha;
    if(this._dataRespuesta['publicado'] != null){
      fecha = DateTime.parse(this._dataRespuesta['publicado']['date']);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (fecha != null) ? 'Publicado: ${_dateFormat.format(fecha)}' : 'SIN RESPUESTAS',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 0.2,
                  color: Colors.grey[800]
                ),
              ),
              (isFirst)
              ?
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(Icons.arrow_downward, size: 20, color: Colors.red),
                  Text(
                    'COTIZACIONES',
                    textScaleFactor: 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 13,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              )
              :
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'COMPRALA HOY',
                    textScaleFactor: 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 13,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 20, color: Colors.red),
                ],
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(width: 2),
              InkWell(
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.green[600],
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.white
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            offset: Offset(1, 1)
                          )
                        ]
                      ),
                      child: Icon(Icons.contact_phone, color: Colors.white, size: 20),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Soporte',
                      textScaleFactor: 1,
                      style: TextStyle(
                        fontSize: 12
                      ),
                    )
                  ],
                ),
                onTap: () async  => _contactarnos(),
              ),
              InkWell(
                child: Column(
                  children: [

                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: this._colorInCarrito,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.white
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            offset: Offset(1, 1)
                          )
                        ]
                      ),
                      child: Icon(this._icoCarr, color: Colors.white, size: 20),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${this._txtCarrito}',
                      textScaleFactor: 1,
                      style: TextStyle(
                        fontSize: 12
                      ),
                    )
                  ],
                ),
                onTap: () async  => await _addAlCarrito(),
              ),
            ],
          ),
        )
      ],
    );
  }

  ///
  Future<void> _addAlCarrito() async {

    String txt;
    // 4280391411  es color Azul
    if(this._colorInCarrito.value != 4280391411) {

      // Entra si es ROJO es decir, no esta en carrito
      bool existe = await _existInCarShop(true);
      print('$existe:: meto del carrito');
      if(!existe){
        Provider.of<DataShared>(this._context, listen: false).setCantInCarrito();
        txt = 'Sacar';
        await emShop.addPzaToCarShop(widget.respuestas[this._piezaSelecIndex]['i_id']);
      }
      this._icoCarr = Icons.remove_shopping_cart;
      this._colorInCarrito = Colors.blue;
    }else{

      bool existe = await _existInCarShop(false);
      print('$existe:: saco del carrito');
      if(existe){
        Provider.of<DataShared>(this._context, listen: false).delCantInCarrito();
        txt = 'Al Carrito';
        await emShop.quitarPiezaDelPedido(widget.respuestas[this._piezaSelecIndex]['i_id']);
      }
      this._icoCarr = Icons.shopping_cart;
      this._colorInCarrito = Colors.red;
    }
    
    setState(() {
      this._txtCarrito = txt;
    });
  }

  ///
  Future<bool> _existInCarShop(bool accion) async {
    return await emShop.existInCarShop(widget.respuestas[this._piezaSelecIndex]['i_id']);
  }

  ///
  Widget _lstRelacionadas() {

    List<Widget> lstResps = new List();

    for (var i = 0; i < widget.respuestas.length; i++) {
      lstResps.add(
        InkWell(
          child: _pzaRelacionadas(i, widget.respuestas[i]),
          onTap: (){
            this._piezaSelecIndex = i;
            setState(() {
              _hidratarDataRespuestaActual();
            });
          },
        )
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      width: MediaQuery.of(this._context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: lstResps,
        ),
      ),
    );
  }

  ///
  Widget _pzaRelacionadas(index, respuesta) {

    final costo = NumberFormat.currency(locale: 'en_US', symbol: '\$').format(respuesta['i_costoZm']);

    double radio = (MediaQuery.of(this._context).size.height < 550) ? 25 : 29;
    Widget foto = CircleAvatar(
      radius: radio,
      child: Icon(Icons.camera_alt, color: Colors.grey),
    );

    if(respuesta['i_fotos'].length > 0){
      foto = CircleAvatar(
        radius: radio,
        backgroundImage: NetworkImage('${globals.uriImageInvent}/${respuesta['i_fotos'][0]}'),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: (index == this._piezaSelecIndex) ? Colors.red[100] : null,
      child: Column(
        children: [
          foto,
          SizedBox(height: 7),
          Text(
            '$costo',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: Colors.grey[600]
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget _txtZonaMotora() {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(this._context).size.width,
      color: Colors.black87,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'NOTAS ZONA MOTORA',
              textScaleFactor: 1,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey[300]
              ),
            ),
          ),
          Divider(height: 2),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(
              _txtExistenciaZM(),
              textScaleFactor: 1,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey
              ),
            ),
          ),
          CustomPaint(
            painter: SeparadorTxtZm(),
            child: SizedBox(
              width: MediaQuery.of(this._context).size.width,
              height: 15,
              child: Center(
                child: Transform.rotate(
                  angle: 95,
                  child: Container(
                    width: 10,
                    height: 10,
                    color: Colors.grey[350],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(
              _txtGarantiaZM(),
              textScaleFactor: 1,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400]
              ),
            ),
          )
        ],
      ),
    );
  }

  ///
  void _hidratarDataFixed() {

    this._datafixed = {
      'pieza'    : widget.respuestas[this._piezaSelecIndex]['pz_palabra'],
      'lado'     : widget.respuestas[this._piezaSelecIndex]['re_lado'],
      'posicion' : widget.respuestas[this._piezaSelecIndex]['re_posicion'],
      'modelo'   : widget.respuestas[this._piezaSelecIndex]['md_nombre'],
      'marca'    : widget.respuestas[this._piezaSelecIndex]['mk_nombre'],
      'anio'     : widget.respuestas[this._piezaSelecIndex]['ra_anio']
    };
  }

  ///
  Future<void> _hidratarDataRespuestaActual() async {

    this._dataRespuesta = {
      'detalles' : widget.respuestas[this._piezaSelecIndex]['i_detalles'],
      'publicado': widget.respuestas[this._piezaSelecIndex]['i_createdAt'],
      'costo'    : widget.respuestas[this._piezaSelecIndex]['i_costoZm'],
      'hasGarant': widget.respuestas[this._piezaSelecIndex]['i_hasDevol'],
      'cantPzas' : widget.respuestas[this._piezaSelecIndex]['i_cant'],
      'fotos'    : widget.respuestas[this._piezaSelecIndex]['i_fotos'],
      'idInv'    : widget.respuestas[this._piezaSelecIndex]['i_id']
    };
    await _existInCarShop(true);
  }

  ///
  String _txtGarantiaSocio() {

    return '' +
    'Esta piezas cuenta con la garantia de 24 horas después de recibir el '+
    'pedido con la finaliad de rebisar el estado del producto ' +
    'y solicitar el retorno de la inversión en caso de insatisfacción.';
  }

  ///
  String _txtSinGarantiasSocio() {
    return '' +
    'Esta refacción no cuenta con la garantia de la devolución monetaria.';
  }

  ///
  String _txtExistenciaZM() {

    return '' +
    'Las piezas aquí publicadas son rastreadas en tiempo real entre cientos '+
    'de Socios Comerciales ubicados en distintos puntos de la ciudad, es por ' +
    'ello que no se garantiza la existencia de la refacción publicada en este ' +
    'momento, es muy recomendable que nos contacte antes de realizar su pedido.';
  }

  ///
  String _txtGarantiaZM() {

    return '' +
    'Siempre pensando en tu economía Zona Motora te otorga resultados de piezas '+
    'y costos siempre vigentes al tiempo de tu consulta, sin embargo Zona Motora no se ' +
    'hace responsable de Promociones, Ofertas y Costos, ya que estos son publicados ' +
    'directamente por nuestros Socios Comerciales.';
  }

  ///
  void _contactarnos() {

    showDialog(
      context: this._context,
      builder: (_) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(10),
          titlePadding: EdgeInsets.all(0),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                child: Image(
                  image: AssetImage('assets/images/zm_asesor.jpg'),
                ),
              ),
              Container(
                width: MediaQuery.of(this._context).size.width,
                color: Colors.red,
                padding: EdgeInsets.all(5),
                child: Text(
                  'NUESTROS ASESORES',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ],
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
              Text(
                'Contáctanos para cualquier duda acerca de las Refacciones ' +
                'que necesitas adquirir, trateremos de resolver tus dudas lo ' +
                'más rápido posible.',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '¿QUÉ DESEAS HACER?',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.all(3),
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.message, color: Colors.white)
                ),
                title: Text(
                  'Enviarnos un Mensaje ...',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                  'Agrega nuestro número a WhatsApp',
                  textScaleFactor: 1,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(3),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.phone_forwarded, color: Colors.white),
                ),
                title: Text(
                  'Llamarnos por Teléfono ...',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }

}

class SeparadorTxtZm extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {

    Path path = new Path();

    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();

    Paint paint = new Paint();
    paint.color = Colors.black87;

    return canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}