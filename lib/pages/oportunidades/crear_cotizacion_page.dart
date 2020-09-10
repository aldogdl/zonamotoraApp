import 'package:flutter/material.dart';
import 'package:zonamotora/pages/oportunidades/widgets/data_pasarelas_widget.dart';

import 'package:zonamotora/pages/oportunidades/widgets/ficha_auto_data_pieza.dart';
import 'package:zonamotora/pages/oportunidades/widgets/ficha_auto_img_cache.dart';
import 'package:zonamotora/pages/oportunidades/widgets/ficha_auto_placeholder.dart';
import 'package:zonamotora/repository/solicitud_repository.dart';
import 'package:zonamotora/singletons/cotizacion_sngt.dart';
import 'package:zonamotora/utils/validadores.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/visor_fotos_dialog.dart';

class CrearCotizacionPage extends StatefulWidget {
  @override
  _CrearCotizacionPageState createState() => _CrearCotizacionPageState();
}

class _CrearCotizacionPageState extends State<CrearCotizacionPage> {

  CotizacionSngt sngtCot = CotizacionSngt();
  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  SolicitudRepository emSoli = SolicitudRepository();
  Validadores vals = Validadores();

  /// Widgets
  FichaAutoImgCacheWidget imgCacheWidget;
  FichaAutoDataPiezaWidget dataPiezaWidget;
  FichaAutoPlaceholderWidget placeholderWidget;
  VisorFotosDialogWidget fotosDialogWidget;

  GlobalKey<ScaffoldState> _keySka = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _frmKey = GlobalKey<FormState>();
  TextEditingController _ctrPrecio = TextEditingController();
  TextEditingController _ctrComision = TextEditingController();
  TextEditingController _ctrCaracs = TextEditingController();

  FocusNode _focusPrecio = FocusNode();
  FocusNode _focusComision = FocusNode();
  FocusNode _focusCaracs = FocusNode();

  String _hasDevolucion = 'si';
  String _txtDevolucion = 'ACEPTO la devolución';
  Map<String, dynamic> pieza = new Map();
  Map<String, dynamic> _dataPieza = new Map();

  int _cantidaPiezas = 1;
  int _cantidaPiezaSolicitada = 1;
  bool _showVisorFoto = false;
  bool _otraCotiza = false;
  bool _showFrm = false;
  Size _screen;
  BuildContext _context;

  Map<String, dynamic> _metadataOpsYesOrNot = {
    'no': {
      'colorSI': Colors.grey[600],
      'colorNo': Colors.black,
      'bgSI': Colors.grey[300],
      'bgNo': Colors.green,
      'icono': Icons.close
    },
    'si': {
      'colorSI': Colors.black,
      'colorNo': Colors.grey[600],
      'bgSI': Colors.green,
      'bgNo': Colors.grey[300],
      'icono': Icons.check
    },
  };

  @override
  void initState() {

    if(sngtCot.dataPiezaEnProceso.isNotEmpty){
      this._dataPieza['sp_id'] = sngtCot.dataPiezaEnProceso['solicitud'];
      this._dataPieza['sp_pedido'] = sngtCot.dataPiezaEnProceso['pedido'];
      this._otraCotiza = true;
    }
    sngtCot.piezaEnProceso = new Map();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    this._ctrPrecio.dispose();
    this._ctrComision.dispose();
    this._ctrCaracs.dispose();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    pieza = ModalRoute.of(this._context).settings.arguments;
    pieza = pieza['pieza'];

    this._screen = MediaQuery.of(this._context).size;
    this._cantidaPiezaSolicitada = pieza['cant'];
    imgCacheWidget = FichaAutoImgCacheWidget(foto: pieza['foto']);
    placeholderWidget = FichaAutoPlaceholderWidget(pieza: pieza);
    context = null;

    return Scaffold(
      key: this._keySka,
      appBar: appBarrMy.getAppBarr(titulo: 'Pedido ID: ${pieza['pedido']}'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            _btnsAccionTop(),
            const SizedBox(height: 10),
            FutureBuilder(
              future: _getDataPiezaFromServer(),
              builder: (_, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  if(snapshot.data){
                    if(this._dataPieza.containsKey('sp_fotos')){
                      if(this._dataPieza['sp_fotos'].length > 0){
                        this._showVisorFoto = true;
                      }
                    }
                    return _fichaRefaccion();
                  }else{
                    return _sinRespuestaDelServer();
                  }
                }
                return placeholderWidget;
              },
            ),
            const SizedBox(height: 10),
            (this._showFrm) ? _frm() : const SizedBox(height: 00)
          ],
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  /// Los botones ATRAS y NO TENGO LA PIEZA
  Widget _btnsAccionTop() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton.icon(
          icon: Icon(Icons.arrow_back),
          padding: EdgeInsets.all(0),
          label: Text('Atrás'),
          onPressed: () {
            sngtCot.hasDataPedidos = false;
            sngtCot.hasDataPieza = true;
            sngtCot.dataPiezaEnProceso = new Map();
            Navigator.of(this._context).pushNamedAndRemoveUntil('oportunidades_page', (route) => false);
          }
        ),
        RaisedButton.icon(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.black,
          textColor: Colors.white,
          icon: Icon(Icons.close, color: Colors.blue),
          label: Text('NO TENGO LA PIEZA'),
          onPressed: () async {

            AlertsVarios alertsVarios = AlertsVarios();
            String body = 'Muchas gracias por tu tiempo, estamos notificando de tu respuesta, espera un momento, por favor.';
            alertsVarios.cargando(this._context, titulo: 'GRACIAS POR TU RESPUESTA', body: body);
            await emSoli.setCotizacion({'nohay':1, 'solicitud':pieza['solicitud'], 'pedido':pieza['pedido']});

            sngtCot.dataPiezaEnProceso = new Map();
            sngtCot.piezaEnProceso = new Map();
            sngtCot.dispose();
            Navigator.of(this._context).pushNamedAndRemoveUntil('oportunidades_page', (route) => false);

          },
        ),
      ],
    );
  }

  ///
  Widget _fichaRefaccion() {

    dataPiezaWidget = FichaAutoDataPiezaWidget(
      descripcion: this._dataPieza['sp_requerimientos'],
      lado: this._dataPieza['re_lado'],
      posicion: this._dataPieza['re_posicion'],
      pieza: this._dataPieza['pz_palabra'],
    );

    return Container(
      width: this._screen.width * 0.9,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(blurRadius: 3, offset: Offset(1, 1), color: Colors.red),
      ], borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _fichaHead(),
          dataPiezaWidget,
        ],
      ),
    );
  }

  ///
  Widget _fichaHead() {

    double alto = this._screen.height * 0.25;
    List<String> lasFotos = new List();
    if(this._dataPieza.containsKey('sp_fotos')){
      if(this._dataPieza['sp_fotos'].length > 0){
        lasFotos = new List<String>.from(this._dataPieza['sp_fotos']);
      }else{
        this._showVisorFoto = false;
      }
    }

    fotosDialogWidget = VisorFotosDialogWidget(fotos: lasFotos);

    return Container(
      width: this._screen.width,
      height: alto,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          InkWell(
            onTap: (){
              showDialog(
                context: this._context,
                builder: (BuildContext context) {
                  return fotosDialogWidget;
                }
              );
            },
            child: imgCacheWidget,
          ),
          Positioned(
            top: alto - 53,
            left: 10,
            child: Text(
              '${this._dataPieza['mk_nombre']}',
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                shadows: [
                  BoxShadow(
                    blurRadius: 2,
                    offset: Offset(1, 2),
                    spreadRadius: 5,
                    color: Colors.black
                  )
                ]
              ),
            ),
          ),
          (!this._showVisorFoto)
          ?
          SizedBox(height: 0)
          :
          Positioned(
            top: 10,
            right: 10,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: this._context,
                  builder: (BuildContext context) {
                    return fotosDialogWidget;
                  }
                );
              },
              child: CircleAvatar(
                maxRadius: 25,
                backgroundColor: Colors.white,
                child: Icon(Icons.photo_album, size: 30),
              ),
            ),
          ),
          Positioned(
            top: alto - 35,
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
                      (this._dataPieza['ra_version'] != '0') ? '${this._dataPieza['ra_version']}' : 'Sin Versión',
                      textScaleFactor: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${this._dataPieza['ra_anio']}',
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
  Widget _frm() {

    return Form(
      key: this._frmKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                const SizedBox(width: 10),
                Text(
                  'Te Solicitan ',
                  textScaleFactor: 1,
                ),
                Text(
                  '  ${this._cantidaPiezaSolicitada}  ',
                  textScaleFactor: 1,
                  style: TextStyle(
                      backgroundColor: Colors.red, color: Colors.white),
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
                  borderRadius: BorderRadius.circular(10)),
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
            const SizedBox(height: 15),
            _inputCosto(),
            const SizedBox(height: 5),
            _inputComision(),
            const SizedBox(height: 5),
            _inputCaracteristicas(),
            const SizedBox(height: 20),
            _inputGarantia(),
            Container(
              margin: EdgeInsets.only(top: 1, bottom: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white.withAlpha(100),
                  borderRadius: BorderRadius.circular(10)),
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
            Center(
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.blue,
                icon: Icon(Icons.send),
                label: Text(
                  'ENVIAR COTIZACIÓN',
                  textScaleFactor: 1,
                  style: TextStyle(color: Colors.white, letterSpacing: 1.2),
                ),
                onPressed: () {
                  FocusScope.of(this._context).requestFocus(new FocusNode());
                  _sendCotizacion();
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  ///
  Widget _inputCosto() {

    return TextFormField(
      controller: this._ctrPrecio,
      focusNode: this._focusPrecio,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (String txt) {
        FocusScope.of(this._context).requestFocus(this._focusComision);
      },
      validator: (String txt) {
        String errs = vals.onlyNumber(txt);
        if(errs == null){
          if(txt.length == 0){
            errs = 'El Costo al público es requerido';
          }
        }
        return errs;
      },
      decoration: InputDecoration(
        labelText: 'Precio al Público SIN I.V.A.:',
        prefixIcon: Icon(Icons.attach_money),
        filled: true,
        fillColor: Colors.grey[50],
        hintText: (this._otraCotiza) ? 'Ref. ${ sngtCot.dataPiezaEnProceso['costo'] }' : null,
        hintStyle: TextStyle(
          color: Colors.grey
        )
      ),
    );
  }

  ///
  Widget _inputComision() {

    return TextFormField(
      controller: this._ctrComision,
      focusNode: this._focusComision,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (String txt) {
        FocusScope.of(this._context).requestFocus(this._focusCaracs);
      },
      validator: (String val) {
        String errs;
        errs = vals.onlyNumber(val);
        if(errs == null){
          if(val.length == 0){
            errs = 'La comisón al vendedor es requerida.';
          }
        }
        if(double.parse(this._ctrComision.text) > double.parse(this._ctrPrecio.text)) {
          errs = 'La comisión no debe sobrepasa el costo de venta.';
        }
        return errs;
      },
      decoration: InputDecoration(
        labelText: 'Comisión para el vendedor:',
        prefixIcon: Icon(Icons.attach_money),
        filled: true,
        fillColor: Colors.grey[50],
        hintText: (this._otraCotiza) ? 'Ref. ${ sngtCot.dataPiezaEnProceso['comision'] }' : null,
        hintStyle: TextStyle(
          color: Colors.grey
        )
      ),
    );
  }

  ///
  Widget _inputCaracteristicas() {

    return TextFormField(
      controller: this._ctrCaracs,
      focusNode: this._focusCaracs,
      keyboardType: TextInputType.text,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Características adicionales',
        prefixIcon: Icon(Icons.message),
        filled: true,
        fillColor: Colors.grey[50],
        hintText: (this._otraCotiza) ? 'Ref. ${ sngtCot.dataPiezaEnProceso['caracts'] }' : null,
        hintStyle: TextStyle(
          color: Colors.grey
        )
      ),
    );

  }

  ///
  Widget _inputGarantia() {

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white.withAlpha(100),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: <Widget>[
          Text(
            'En caso de que el producto no satisfaga las necesidades del cliente.',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[600], fontWeight: FontWeight.normal),
          ),
          Divider(),
          Text(
            '¿Estás dispuest@ a la devolución del monto en un periodo de 24 horas.?',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
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
                borderRadius: BorderRadius.circular(7)),
                padding: EdgeInsets.all(0),
                child: Icon(Icons.keyboard_arrow_down),
                onPressed: () {
                  this._cantidaPiezas--;
                  if (this._cantidaPiezas < 1) {
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
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  '${this._cantidaPiezas}',
                  textScaleFactor: 1,
                  style: TextStyle(fontSize: 20, color: Colors.grey[50]),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 35,
              width: 35,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7)),
                padding: EdgeInsets.all(0),
                child: Icon(Icons.keyboard_arrow_up),
                onPressed: () {
                  this._cantidaPiezas++;
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
                  style: TextStyle(fontWeight: FontWeight.bold, color: colorNo),
                ),
                onPressed: () {
                  switch (elemento) {
                    case 'devolucion':
                      setState(() {
                        this._hasDevolucion = 'no';
                        this._txtDevolucion = 'NO Hay Devoluciones';
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
              child: Center(child: Icon(icono, color: Colors.white, size: 20)),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 35,
              width: 35,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)),
                color: bgSI,
                padding: EdgeInsets.all(0),
                child: Text(
                  'SI',
                  textScaleFactor: 1,
                  style: TextStyle(fontWeight: FontWeight.bold, color: colorSI),
                ),
                onPressed: () {
                  switch (elemento) {
                    case 'devolucion':
                      setState(() {
                        this._hasDevolucion = 'si';
                        this._txtDevolucion = 'ACEPTO la Devolución';
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

  /// Mensaje sobre el error de descargar la info de la pieza.
  Widget _sinRespuestaDelServer() {

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.withAlpha(50),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: <Widget>[
          Text(
            'No se pudo recuperar la información de la Refaccion solicitada, por favor, '+
            'presiona el boton para reintentar obtener los datos correspondientes',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
          ),
          RaisedButton.icon(
            icon: Icon(Icons.cloud_download),
            onPressed: (){
              sngtCot.hasDataPieza = false;
              Navigator.of(this._context).popAndPushNamed('crear_cotizacion_page', arguments: {'pieza':pieza});
            },
            label: Text(
              'REINTENTAR',
              textScaleFactor: 1,
            ),
          )
        ],
      ),
    );
  }

  ///
  Future<bool> _getDataPiezaFromServer() async {

    if(sngtCot.hasDataPieza){ return true; }
    final dataSend = {'u_id':'0', 'solicitud':pieza['solicitud'], 'pedido':pieza['pedido']};
    this._dataPieza = await emSoli.getDataPiezaFromServer(dataSend);
    if(this._dataPieza.containsKey('sp_id')) {
      sngtCot.hasDataPieza = true;
      if(this._dataPieza['sp_pedido'] != null){
        this._showFrm = true;
        Future.delayed(Duration(milliseconds: 200), (){
          setState(() {});
        });
      }
      return true;
    }
    return false;
  }

  ///
  Future<bool> _sendCotizacion() async {

    if(this._frmKey.currentState.validate()){
      this._keySka.currentState.showBottomSheet((_context) => _verDeducciones());
    }else{
      _errorEnFormulario();
    }

    return false;
  }

  ///
  Widget _verDeducciones() {

    Map<String, dynamic> dataSend = {
      'solicitud' : this._dataPieza['sp_id'],
      'pedido'    : this._dataPieza['sp_pedido'],
      'costo'     : this._ctrPrecio.text,
      'comision'  : this._ctrComision.text,
      'garantia'  : this._hasDevolucion,
      'caracts'   : this._ctrCaracs.text,
      'existencia': this._cantidaPiezas
    };
    sngtCot.hasDataPedidos = true;
    sngtCot.hasDataPieza = true;
    sngtCot.dataPiezaEnProceso = dataSend;
    this._otraCotiza = false;
    sngtCot.piezaEnProceso = pieza;

    return DataPasarelasWidget();
  }

  ///
  void _errorEnFormulario() {

    Widget snackbar = SnackBar(
      backgroundColor: Colors.red,
      content: Container(
        width: this._screen.width,
        child: Text(
          'ERROR EN EL FORMULARIO',
          textAlign: TextAlign.center,
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );

    this._keySka.currentState.showSnackBar(snackbar);
  }

}
