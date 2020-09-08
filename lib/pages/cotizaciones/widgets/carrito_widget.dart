import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/carshop_repository.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/sin_piezas_widget.dart';

class CarritoWidget extends StatefulWidget {

    final BuildContext context;
  CarritoWidget({this.context});

  @override
  _CarritoWidgetState createState() => _CarritoWidgetState();
}

class _CarritoWidgetState extends State<CarritoWidget> {

  CarShopRepository emShop = CarShopRepository();
  AlertsVarios alertsVarios = AlertsVarios();

  BuildContext _context;
  Size _screen;
  List<Map<String, dynamic>> _pedidosLst = new List();
  String _costoTotalPedido = '\$ 0.0';
  bool _showBtnHacerPedido = false;
  bool _yaDescargo = false;


  @override
  void dispose() {
    this._yaDescargo = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    this._context = widget.context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;

    return Container(
      width: this._screen.width,
      height: this._screen.height,
      child: Column(
        children: [
          (this._showBtnHacerPedido)
          ?
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'TU PEDIDO ES DE:',
                      textScaleFactor: 1,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      )
                    ),
                    Text(
                      '${this._costoTotalPedido}',
                      textScaleFactor: 1,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.red
                      )
                    ),
                  ],
                ),
                RaisedButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'HACER PEDIDO'
                  ),
                  onPressed: (){
                    Navigator.of(this._context).pushNamed('comprar_index_page');
                  },
                )
              ],
            ),
          )
          :
          SizedBox(height: 0),
          (this._showBtnHacerPedido)
          ?
          Text(
            'Quita una Refacción deslizando hacia la Izquierda',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12
            )
          ):
          SizedBox(height: 0),
          const Divider(),
          Container(
            width: this._screen.width,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Colors.grey[200],
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: _getPedidos(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.hasData && snapshot.data) {
                    return _createListPedidos();
                  }
                  if(snapshot.hasData && !snapshot.data) {
                    return SinPiezasWidget(
                      txt1: 'Por el momento no hay Piezas seleccionadas para Comprar.',
                      txt2: '',
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: _recuperandoLoad(),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  ///
  Widget _recuperandoLoad() {

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(),
          ),
          const SizedBox(height: 20),
          Text(
            'Recuperando...',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12
            ),
          )
        ],
      ),
    );
  }

  ///
  Widget _createListPedidos() {

    List<Widget> lst = this._pedidosLst.map((pieza) => _piezaPedido(pieza)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lst
    );
  }

  ///
  Widget _piezaPedido(Map<String, dynamic> pieza) {

    final costo = NumberFormat.currency(locale: 'en_US', symbol: '\$').format(pieza['i_costoZm']);
    return Dismissible(
      key: Key('${pieza['i_id']}'),
      confirmDismiss: (DismissDirection direccion) async {
        if(DismissDirection.endToStart == direccion) {
          return _quitarPiezaDelPedido(double.parse('${pieza['i_costoZm']}'), pieza['i_id']);
        }
        return false;
      },
      background: Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.only(right: 20),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Icon(Icons.delete, size: 40, color: Colors.white),
        ),
      ),
      direction: DismissDirection.endToStart,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${pieza['pz_palabra']}',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${pieza['re_lado']} ${pieza['re_posicion']}',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    fontSize: 13
                  ),
                ),
                Text(
                  'Para: ${pieza['md_nombre']} ${pieza['ra_anio']}',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    fontSize: 11
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  '$costo',
                  textScaleFactor: 1,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.red
                  )
                ),
                const SizedBox(height: 5),
                Text(
                  'Sin Impuestos',
                  textScaleFactor: 1,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: Colors.grey[600]
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  ///
  Future<bool> _getPedidos() async {

    if(this._yaDescargo){ return true; }
    if(this._pedidosLst.length == 0) {
      Provider.of<DataShared>(this._context, listen: false).setCotizacPageView(2);
      this._yaDescargo = true;
      List<int> lstIdsInv = await emShop.getIdsInCarShop();
      if(lstIdsInv.length > 0) {
        bool pedidos = await emShop.getInventarioByIds(lstIdsInv);
        if(pedidos){
          this._pedidosLst = new List<Map<String, dynamic>>.from(emShop.result['body']);
          double costoTot = 0.0;
          this._pedidosLst.forEach((element) {
            costoTot =  costoTot + element['i_costoZm'];
          });
          setState(() {
            this._costoTotalPedido = NumberFormat.currency(locale: 'en_US', symbol: '\$').format(costoTot);
            this._showBtnHacerPedido = true;
          });
          Provider.of<DataShared>(this._context, listen: false).setCantTotalInCarrito(this._pedidosLst.length);
          return true;
        }
      }
    }else{
      return true;
    }
    return false;
  }

  ///
  Future<bool> _quitarPiezaDelPedido(double costoPieza, int idDel) async {

    String body = 'SEGUR@ que deceas QUITAR la pieza del pedido actual?';

    bool acc = await alertsVarios.aceptarCancelar(this._context, titulo: 'QUITAR PIEZA', body: body);
    if(acc){
      bool echo = await emShop.quitarPiezaDelPedido(idDel);
      if(echo){
        Provider.of<DataShared>(this._context, listen: false).delCantInCarrito();
        String newValor = this._costoTotalPedido.replaceFirst(new RegExp(r'\$'), '');
        newValor = newValor.replaceFirst(new RegExp(r','), '');
        double newTotal = double.parse(newValor) - costoPieza;
        if(newTotal < 0){
          newTotal = 0;
        }
        setState(() {
          this._costoTotalPedido = NumberFormat.currency(locale: 'en_US', symbol: '\$').format(newTotal);
          if(newTotal == 0){
            this._showBtnHacerPedido = false;
          }
        });
        this._pedidosLst.removeWhere((element) => element['i_id'] == idDel);
        return true;
      }
    }
    return false;
  }

}