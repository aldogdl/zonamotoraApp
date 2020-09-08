import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:zonamotora/repository/solicitud_repository.dart';
import 'package:zonamotora/singletons/cotizacion_sngt.dart';
import 'package:zonamotora/globals.dart' as globals;
import 'package:zonamotora/utils/validadores.dart';


class DataPasarelasWidget extends StatefulWidget {
  @override
  _DataPasarelasWidgetState createState() => _DataPasarelasWidgetState();
}

class _DataPasarelasWidgetState extends State<DataPasarelasWidget> {

  CotizacionSngt sngtCot = CotizacionSngt();
  SolicitudRepository emSoli = SolicitudRepository();
  Validadores vals = Validadores();
  
  BuildContext _context;
  TextEditingController _ctrCosto = TextEditingController();
  bool _verMsg = false;
  bool _isInit = false;
  bool _calculatedMaxMin = false;
  List<double> _maxAndMin = new List();
  List<Widget> _lstPasarelas = new List();

  double _max = 0;
  double _min = 10000000;
  var f = new NumberFormat("###,###.0#", "en_US");
  String _errs;


  @override
  void initState() {
    this._ctrCosto.text = sngtCot.dataPiezaEnProceso['costo'];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    this._ctrCosto.dispose();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;

    return SingleChildScrollView(
      child: _body(),
    );
  }

  ///
  Widget _body() {

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.lightBlue,
            Colors.white
          ],
          begin: Alignment.topCenter
        )
      ),
      width: MediaQuery.of(this._context).size.width,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, right: 10, bottom: 0, left: 10),
            child: const Text(
              'Tus clientes tienen distintas opciones de pago para comprar tus refacciones por INTERNET.',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          (!this._verMsg)
          ? _btnVermsg()
          : Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withAlpha(90),
            ),
            child: _msgIntro(),
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withAlpha(90),
            ),
            child: Text(
              'CALCULADORA DE COMISIONES'
            ),
          ),
          _inputCosto(),
          const SizedBox(height: 10),
          Text(
            'Recibirás un monto de...',
            textScaleFactor: 1,
          ),
          Container(
            width: MediaQuery.of(this._context).size.width,
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            color: Colors.white.withAlpha(150),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: (this._calculatedMaxMin)
            ?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Mínimo:'),
                Text(' \$ ${(this._max > 0) ? f.format(this._max) : 0.0}'),
                const SizedBox(width: 20),
                Text('Máximo:'),
                Text(' \$ ${(this._min > 0) ? f.format(this._min) : 0.0}'),
              ],
            )
            :
            Text(
              'Calculando Máximos y Mínimos',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.green
              ),
            )
          ),
          const SizedBox(height: 10),
           _btnEntendidoContinuar(),
          const Divider(),
          const SizedBox(height: 10),
          Text(
            'SI EL CLIENTE COMPRA POR:',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 10),
          (!this._isInit)
          ?
          _futureGetPasarelas()
          :
          Column(
            children: this._lstPasarelas
          )
        ],
      ),
    );
  }

  ///
  Widget _inputCosto() {

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.purpleAccent,
            offset: Offset(1,2)
          )
        ]
      ),
      width: MediaQuery.of(this._context).size.width * 0.8,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Text(
            'Tu Costo sugerido inicial es:'
          ),
          TextFormField(
            controller: this._ctrCosto,
            onChanged: (String val) {
              setState(() {
                _createLstDePasarelas();
              });
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              helperText: 'Comision al Vendedor: \$ ${sngtCot.dataPiezaEnProceso['comision']}',
              prefixIcon: Icon(Icons.monetization_on),
              suffix: Text(
                'MXN',
                textScaleFactor: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              errorText: this._errs
            ),
          )
        ],
      ),
    );
  }
  
  ///
  Widget _btnVermsg() {

    return FlatButton.icon(
      onPressed: (){
        setState(() {
          this._verMsg = true;
        });
      },
      icon: Icon(Icons.info),
      label: Text(
        'Ver información complementaria'
      ),
    );
  }

  ///
  Widget _msgIntro() {

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(50)
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          FlatButton.icon(
            color: Colors.red,
            textColor: Colors.white,
            onPressed: (){
              setState(() {
                this._verMsg = false;
              });
            },
            icon: Icon(Icons.close),
            label: Text(
              'Cerrar información'
            )
          ),
          const SizedBox(height: 5),
          const Text(
            'Para ello es necesario PAGAR UNA PEQUEÑA COMISIÓN por los servicios que ofrecen las distintas '+
            'empresas destinadas a realizar con seguridad una transacción por medios electrónicos.',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 16
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Te presentamos el cálculo de costos que se paga a las compañias de seguridad interbancaria.',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue[800]
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Las comisiones están sujetas a cambios de acuerdo a las políticas de cada institución.',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600]
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget _sinData() {

    return Container(
      child: Text('sin datos'),
    );
  }

  ///
  Widget _machoteTitle(String medio, deducciones) {

    String titulo;
    switch (medio) {
      case 'tarjeta':
        titulo = 'Tarjeta de Débito';
        break;
      case 'transfer':
        titulo = 'Realiza Transferencia';
        break;
      case 'efectivo':
        titulo = 'Efectivo por [OXO]';
        break;
      default:
    }

    Map<String, double> total =  _calcularDeduccion(deducciones);

    double totalT = double.parse(total['total'].toStringAsFixed(2));
    double comision = double.parse(total['comision'].toStringAsFixed(2));
    this._maxAndMin.add(totalT);

    return ListTile(
      title: Text(
        '$titulo',
        textScaleFactor: 1,
      ),
      leading: Icon(Icons.monetization_on, color: Colors.blue.withAlpha(90), size: 35),
      subtitle: Text(
        'Comisón \$ ${f.format(comision)}',
        textScaleFactor: 1,
        style: TextStyle(
          fontSize: 15
        ),
      ),
      isThreeLine: true,
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            'Recibirás',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.green,
              fontSize: 12,
              fontWeight: FontWeight.bold
            ),
          ),
          Text(
            '\$ ${f.format(totalT)}',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget _btnEntendidoContinuar() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.red,
          textColor: Colors.white,
          child: Text(
            'CERRAR'
          ),
          onPressed: (){
            Navigator.of(this._context).pop(false);
          },
        ),
        RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.black,
          textColor: Colors.white,
          child: Text(
            'OK - CONTINUAR'
          ),
          onPressed: (){
            this._errs= vals.onlyNumber(this._ctrCosto.text);
            if(this._errs == null){
              if(this._ctrCosto.text.length == 0){
                this._errs = 'El Costo al público es requerido';
              }
            }
            if(this._errs == null){
              sngtCot.dataPiezaEnProceso['costo'] = this._ctrCosto.text;
              Navigator.of(this._context).pushReplacementNamed('set_fotos_cotizacion');
            }else{
              setState(() { });
            }
          },
        )
      ],
    );
  }
  
  ///
  Widget _futureGetPasarelas() {

    return FutureBuilder(
      future: _getPasarelas(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          if(snapshot.data){
            if(sngtCot.dataPasarelas.containsKey('conekta')) {
              _createLstDePasarelas();
              return Column(
                children: this._lstPasarelas
              );
            }else{
              return _sinData();
            }
          }
        }
        return Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(this._context).size.height * 0.1),
            SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(),
            ),
            SizedBox(height: MediaQuery.of(this._context).size.height * 0.3),
          ],
        );
      },
    );
  }

  ///
  Future<void> _getPasarelas() async {
    await emSoli.getDataPasarelas();
    return true;
  }

  ///
  Map<String, double> _calcularDeduccion(Map<String, dynamic> deducciones) {

    double iva = globals.iva / 100 + 1;
    double costo = 0;
    if(this._ctrCosto.text != null && this._ctrCosto.text != ''){
      costo = double.parse(this._ctrCosto.text);
    }
    
    double comision = (deducciones.containsKey('comision')) ? double.parse(deducciones['comision']) : 0;
    comision = ((comision / 100) + 1);
    comision = (costo * comision) - costo;
    
    double montofix = (deducciones.containsKey('fijo')) ? double.parse(deducciones['fijo']) : 0;
    comision = (comision + montofix);
    comision = (comision * iva);
    double totComision = (comision + double.parse(sngtCot.dataPiezaEnProceso['comision']));
    double total = (costo - totComision);

    if(total > this._max) {
      this._max = total;
    }
    if(total < this._min) {
      this._min = total;
    }
    Future.delayed(Duration(milliseconds: 1100)).then((_){
      _calcularMaxAndMin();
    });
    return {'comision':comision, 'total':(total < 0) ? 0.0 : total};
  }
  
  ///
  void _createLstDePasarelas() {

    this._lstPasarelas = new List();
    this._maxAndMin = new List();
    this._min = 10000000;
    this._max = 0;

    sngtCot.dataPasarelas.forEach((key, pasarela) {
      this._lstPasarelas.add(
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(left: 20),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.green,
            ),
            child: Text(
              '${pasarela['nombre']}',
              textScaleFactor: 1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          ),
        )
      );
      Map<String, dynamic> data = new Map<String, dynamic>.from(pasarela['medios']);

      data.forEach((medio, deducciones) {
        this._lstPasarelas.add(_machoteTitle(medio, deducciones));
      });

    });

    if(this._lstPasarelas.length > 0){
      this._lstPasarelas.add( _btnEntendidoContinuar() );
    }

    this._isInit = true;
  }

  ///
  void _calcularMaxAndMin() {

    for (var i = 0; i < this._maxAndMin.length; i++) {
      if(this._max > this._maxAndMin[i]){
        this._max = this._maxAndMin[i];
      }
      if(this._min < this._maxAndMin[i]){
        this._min = this._maxAndMin[i];
      }
    }
    this._calculatedMaxMin = true;
    setState(() {});
  }
}