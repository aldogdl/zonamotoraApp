import 'package:flutter/material.dart';
import 'package:zonamotora/pages/oportunidades/widgets/motivos_widget.dart';

import 'package:zonamotora/singletons/cotizacion_sngt.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';

class FinMsgCotPage extends StatefulWidget {
  @override
  _FinMsgCotPageState createState() => _FinMsgCotPageState();
}

class _FinMsgCotPageState extends State<FinMsgCotPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  CotizacionSngt sngtCot = CotizacionSngt();
  
  BuildContext _context;
  bool _isInit = false;

  @override
  void initState() {
    sngtCot.dispose();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    if(!this._isInit){
      this._isInit = true;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Color(0xff7C0000),
        title: Text(
          'Gracias por tu tiempo',
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 16
          ),
        ),
      ),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(this._context).size.width,
          child: SingleChildScrollView(
            child: _body(),
          ),
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  Widget _body() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Text(
            '¡Suerte con tu Venta!',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 25
            ),
          ),
        ),
        Text(
          'Te agradecemos tu tiempo',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.green[900]
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: MediaQuery.of(this._context).size.width * 0.7,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Text(
            'Pero...¿Qué Sigue?',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Estamos distribuyendo la información por todos los medios de VENTA.',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'La Aplicación te notificará si tu refacción fue seleccionada por algún '
          'CLIENTE que le interese para que puedas...',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.red[900],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Apartarla por un lapso de 1 hora.',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 17,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 25),
        _titleCustom(1, 'Lista de Pedidos', 'Revisar las oportunidades de venta de hoy', Icons.clear_all),
        const SizedBox(height: 20),
        _titleCustom(2, 'Otra Cotización', 'Enviar otra cotización para este mismo Pedido.', Icons.add_a_photo),
        const SizedBox(height: 25),
        MotivosWidget()
      ],
    );
  }

  ///
  Widget _titleCustom(indice, String titulo, String stitulo, IconData icono) {

    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(1,2),
            color: Colors.red[400]
          )
        ],
        color: Colors.white,
      ),
      width: MediaQuery.of(this._context).size.width,
      child: ListTile(
        leading: Icon(icono, size: 30, color: Colors.blue),
        title: Text(
          titulo,
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        subtitle: Text(
          stitulo,
          textScaleFactor: 1,
        ),
        onTap: () {
          if(indice == 1){
            sngtCot.piezaEnProceso = new Map();
            sngtCot.dataPiezaEnProceso = new Map();
            sngtCot.isOtra = false;
            Navigator.of(this._context).pushNamedAndRemoveUntil('oportunidades_page', (route) => false);
          }else{
            sngtCot.isOtra = true;
            Navigator.of(this._context).pushNamedAndRemoveUntil(
              'crear_cotizacion_page',
              (route) => false,
              arguments: {'pieza':sngtCot.piezaEnProceso}
            );
          }
        },
      )
    );
  }

}