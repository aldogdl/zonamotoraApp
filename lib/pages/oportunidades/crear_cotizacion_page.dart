import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/banners_top.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/globals.dart' as globals;

class CrearCotizacionPage extends StatefulWidget {
  @override
  _CrearCotizacionPageState createState() => _CrearCotizacionPageState();
}

class _CrearCotizacionPageState extends State<CrearCotizacionPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  Size _screen;
  BuildContext _context;

  GlobalKey<FormState> _frmKey = GlobalKey<FormState>();
  TextEditingController _ctrPrecio = TextEditingController();
  TextEditingController _ctrComision = TextEditingController();
  FocusNode _focusPrecio = FocusNode();
  FocusNode _focusComision = FocusNode();

  String _hasDevolucion = 'si';
  String _txtDevolucion = 'ACEPTO la devolución';

  String _pagoTrg = 'si';
  String _hasDelivery = 'si';
  int _cantidaPiezas = 1;
  int _cantidaPiezaSolicitada = 2;

  Map<String, dynamic> _metadataOpsYesOrNot = {
    'no' : {
      'colorSI' : Colors.grey[600],
      'colorNo' : Colors.black,
      'bgSI'    : Colors.grey[300],
      'bgNo'    : Colors.green,
      'icono'   : Icons.close
    },
    'si' : {
      'colorSI' : Colors.black,
      'colorNo' : Colors.grey[600],
      'bgSI'    : Colors.green,
      'bgNo'    : Colors.grey[300],
      'icono'   : Icons.check
    },
  };

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;

    return Scaffold(
      appBar: appBarrMy.getAppBarr(titulo: 'Cotización ID: 23456789'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _cabecera(),
            FlatButton.icon(
              padding: EdgeInsets.all(0),
              icon: Icon(Icons.arrow_back),
              label: Text(
                'Regresar a la Lista de Oportunidades'
              ),
              onPressed: () => Navigator.of(this._context).pop(false),
            ),
            Divider(),
            _fichaRefaccion(),
            const SizedBox(height: 10),
            _frm()
          ],
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  /* */
  Widget _cabecera() {

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          width: this._screen.width,
          height: this._screen.height * 0.28,
          decoration: BoxDecoration(
            color: Color(0xff7C0000)
          ),
          child: SizedBox(height: 30),
        ),

         // Banners
        Positioned(
          top: 0,
          child:  BannersTop()
        ),
      ],
    );
  }

  ///
  Widget _fichaRefaccion() {

    return Container(
      width: this._screen.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _fichaHead(),
          _piezaData(),
          _btnNoTengo()
        ],
      ),
    );
  }

  ///
  Widget _fichaHead() {

    double alto = this._screen.height * 0.25;

    return Container(
      width: this._screen.width,
      height: alto,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          _imagenCache(),
          Positioned(
            top: alto - 53,
            left: 10,
            child: Text(
              'FORD',
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                shadows: [
                  BoxShadow(
                    blurRadius: 2,
                    offset: Offset(1,2),
                    spreadRadius: 5,
                    color: Colors.black
                  )
                ]
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: CircleAvatar(
              maxRadius: 15,
              backgroundColor: Colors.white,
              child: Icon(Icons.image_aspect_ratio),
            ),
          ),
          Positioned(
            top: alto -35,
            child: Container(
              height: 35,
              width: this._screen.width * 0.9,
              padding: EdgeInsets.only(left: 10, right: 7),
              color: Colors.red.withAlpha(200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Text(
                      'SABE ESCORT DEPORTIVO ZX2 adsadasdadasds ada',
                      textScaleFactor: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '2000',
                      textScaleFactor: 1,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 17
                      ),
                    ),
                  )
                ],
              )
            ),
          )
        ],
      )
    );
  }
  
  ///
  Widget _imagenCache() {

    return CachedNetworkImage(
      imageUrl: '${globals.uriImgSolicitudes}/2_420200_1.jpg',
      imageBuilder: (context, imageProvider) {

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20)
            ),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      placeholder: (context, url){

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20)
            ),
          ),
          color: Colors.red[400],
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      errorWidget: (context, url, error){

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20)
            ),
            image: DecorationImage(
              image: AssetImage('assets/images/no-image.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn),
            )
          )
        );
      },
    );
  }

  ///
  Widget _piezaData() {

    return Container(
      padding: EdgeInsets.all(7),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            child: Icon(Icons.extension),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: this._screen.width * 0.70,
                  child: Text(
                  'Liezo de Costado de la cajuela',
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                  ),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: this._screen.width * 0.70,
                child: Text(
                  'Derecho IZQUIERO - INFERIOR',
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.green[600],
                    fontWeight: FontWeight.normal,
                    fontSize: 14
                  ),
                ),
              ),
              SizedBox(
                width: this._screen.width * 0.70,
                child: Text(
                  'Del Salpicadero',
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.normal,
                    fontSize: 13
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  ///
  Widget _btnNoTengo() {

    return Container(
      width: this._screen.width,
      child: RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20)
        )
      ),
      color: Colors.orange,
      icon: Icon(Icons.signal_cellular_no_sim, color: Colors.white),
      label: Text(
        'Por el momento, NO TENGO la Pieza',
        textScaleFactor: 1,
        style: TextStyle(
          color: Colors.white
        ),
      ),
      onPressed: (){},
    ),
    );
  }

  ///
  Widget _frm() {

    return Form(
      key: this._frmKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: this._ctrPrecio,
              focusNode: this._focusPrecio,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (String txt) {
                FocusScope.of(this._context).requestFocus(this._focusComision);
              },
              decoration: InputDecoration(
                labelText: 'Precio al Público General:'
              ),
            ),
            TextFormField(
              controller: this._ctrComision,
              focusNode: this._focusComision,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Comisión para el vendedor:'
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                const SizedBox(width: 10),
                Text(
                  'Te Solicitan ',
                  textScaleFactor: 1,
                ),
                Text(
                  '  ${ this._cantidaPiezaSolicitada }  ',
                  textScaleFactor: 1,
                  style: TextStyle(
                    backgroundColor: Colors.red,
                    color: Colors.white
                  ),
                ),
                Text(
                  ' piezas del mismo tipo... ',
                  textScaleFactor: 1,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(100),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Tu CUENTAS con:',
                      textScaleFactor: 1,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: _cantidades(),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(100),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    'En caso de que el producto no satisfaga las necesidades del cliente.',
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal
                    ),
                  ),
                  Divider(),
                  Text(
                    '¿Estás dispuest@ a la devolución del monto en un periodo de 24 hras.?',
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 1, bottom: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(100),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      '${this._txtDevolucion}:',
                      textScaleFactor: 1,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: _yesOrNot('devolucion'),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(100),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      '¿Aceptas pago con TARJETA?',
                      textScaleFactor: 1,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: _yesOrNot('tarjeta'),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(100),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      '¿Tienes servicio a DOMICILIO?',
                      textScaleFactor: 1,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: _yesOrNot('delivery'),
                  )
                ],
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Características que apoyen tu VENTA:'
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                color: Colors.blue,
                icon: Icon(Icons.send),
                label: Text(
                  'ENVIAR COTIZACIÓN',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.2
                  ),
                ),
                onPressed: (){},
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  ///
  Widget _cantidades() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              height: 35,
              width: 35,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)
                ),
                padding: EdgeInsets.all(0),
                child: Icon(Icons.keyboard_arrow_down),
                onPressed: (){
                  this._cantidaPiezas--;
                  if(_cantidaPiezas < 1) {
                    this._cantidaPiezas = 1;
                  }
                  setState(() {});
                },
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 35,
              width: 35,
              margin: EdgeInsets.only(right: 3),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(5)
              ),
              child: Center(
                child: Text(
                  '${ this._cantidaPiezas }',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[50]
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 35,
              width: 35,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)
                ),
                padding: EdgeInsets.all(0),
                child: Icon(Icons.keyboard_arrow_up),
                onPressed: (){
                  this._cantidaPiezas++;
                  if(this._cantidaPiezas > this._cantidaPiezaSolicitada){
                    this._cantidaPiezas = this._cantidaPiezaSolicitada;
                  }
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  ///
  Widget _yesOrNot(String elemento) {

    IconData icono;
    Color colorSI;
    Color colorNo;
    Color bgSI;
    Color bgNo;

    switch (elemento) {
      case 'devolucion':
        icono = this._metadataOpsYesOrNot[this._hasDevolucion]['icono'];
        colorSI = this._metadataOpsYesOrNot[this._hasDevolucion]['colorSI'];
        colorNo = this._metadataOpsYesOrNot[this._hasDevolucion]['colorNo'];
        bgSI = this._metadataOpsYesOrNot[this._hasDevolucion]['bgSI'];
        bgNo = this._metadataOpsYesOrNot[this._hasDevolucion]['bgNo'];
        break;
      case 'tarjeta':
        icono = this._metadataOpsYesOrNot[this._pagoTrg]['icono'];
        colorSI = this._metadataOpsYesOrNot[this._pagoTrg]['colorSI'];
        colorNo = this._metadataOpsYesOrNot[this._pagoTrg]['colorNo'];
        bgSI = this._metadataOpsYesOrNot[this._pagoTrg]['bgSI'];
        bgNo = this._metadataOpsYesOrNot[this._pagoTrg]['bgNo'];
        break;
      case 'delivery':
        icono = this._metadataOpsYesOrNot[this._hasDelivery]['icono'];
        colorSI = this._metadataOpsYesOrNot[this._hasDelivery]['colorSI'];
        colorNo = this._metadataOpsYesOrNot[this._hasDelivery]['colorNo'];
        bgSI = this._metadataOpsYesOrNot[this._hasDelivery]['bgSI'];
        bgNo = this._metadataOpsYesOrNot[this._hasDelivery]['bgNo'];
        break;
      default:
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              height: 35,
              width: 35,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)
                ),
                padding: EdgeInsets.all(0),
                color: bgNo,
                child: Text(
                  'NO',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorNo
                  ),
                ),
                onPressed: (){
                  switch (elemento) {
                    case 'devolucion':
                      setState(() {
                        this._hasDevolucion = 'no';
                        this._txtDevolucion = 'NO Hay Devoluciones';
                      });
                      break;
                    case 'tarjeta':
                      setState(() {
                        this._pagoTrg = 'no';
                      });
                      break;
                    case 'delivery':
                      setState(() {
                        this._hasDelivery = 'no';
                      });
                      break;
                    default:
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 35,
              width: 35,
              margin: EdgeInsets.only(right: 3),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(5)
              ),
              child: Center(
                child: Icon(icono, color: Colors.white, size: 20)
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 35,
              width: 35,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)
                ),
                color: bgSI,
                padding: EdgeInsets.all(0),
                child: Text(
                  'SI',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorSI
                  ),
                ),
                onPressed: (){
                  switch (elemento) {
                    case 'devolucion':
                      setState(() {
                        this._hasDevolucion = 'si';
                        this._txtDevolucion = 'ACEPTO la Devolución';
                      });
                      break;
                    case 'tarjeta':
                      setState(() {
                        this._pagoTrg = 'si';
                      });
                      break;
                    case 'delivery':
                      setState(() {
                        this._hasDelivery = 'si';
                      });
                      break;
                    default:
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

}

