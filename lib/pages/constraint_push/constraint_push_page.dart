import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/notifics_repository.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/config_gms_sngt.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';


class ConstraintPushPage extends StatefulWidget {
  @override
  _ConstraintPushPageState createState() => _ConstraintPushPageState();
}

class _ConstraintPushPageState extends State<ConstraintPushPage> {

  AppBarrMy appBarrMy         = AppBarrMy();
  UserRepository emUser       = UserRepository();
  MenuInferior menuInferior   = MenuInferior();
  ConfigGMSSngt msgConfigSngt = ConfigGMSSngt();
  NotificsRepository emNotif  = NotificsRepository();

  Size _screen;
  BuildContext _context;
  bool _isInitConfig = false;
  Map<String, dynamic> _constraints = new Map();

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;

    if(!this._isInitConfig) {
      this._isInitConfig = true;
      msgConfigSngt.setContext(this._context);
      appBarrMy.setContext(this._context);
    }

    return Scaffold(
      appBar: appBarrMy.getAppBarr(titulo: 'Restricciones Push'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body:WillPopScope(
        onWillPop: () => Future.value(false),
        child: _body(),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  Widget _body() {
    
    bool isConfigPush = Provider.of<DataShared>(this._context, listen: false).isConfigPush;
    isConfigPush = (isConfigPush == null) ? false : isConfigPush;
    String msgInit = 'Las restricciones sobre las notificaciones, ' +
    'te orientan para conocer cuales son los avisos que recibirás ' +
    'para estar al tanto de las OPORTUNIDADES DE VENTA con las cuales' +
    ' haz sido dado de alta.';

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Divider(color: Colors.black, height: 5),
            const Divider(color: Colors.black, height: 5),
            const Divider(color: Colors.black, height: 5),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(150),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Text(
                '$msgInit',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.3
                ),
              ),
            ),
            FutureBuilder(
              future: _getRestricciones(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  return Column(
                    children: [
                      _paraTitulo('SOBRE MARCAS AUTOMOTRICES'),
                      _hidratarConstraintMarcas(),
                      _paraTitulo('ACERCA DE TUS REFACCIONES'),
                      _hidratarConstraintPiezas()
                    ],
                  );
                }
                return _getWidgetCargando();
              },
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  ///
  Widget _paraTitulo(String titulo) {

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red.withAlpha(200),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Text(
          '$titulo',
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  ///
  Widget _titPeq(String txt) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Text(
        '$txt',
        textScaleFactor: 1,
        style: TextStyle(
          color: Colors.orange[200]
        ),
      ),
    );
  }

  ///
  Widget _lstBuilder(String lst) {

    List<String> lstView = lst.split(','); 
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: this._screen.width * 0.7,
          height: this._screen.height * 0.03 * lstView.length,
          child: ListView.builder(
            itemCount: lstView.length,
            itemBuilder: (_, i){
              return Text(
                '* ${lstView[i].trim()}',
                textScaleFactor: 1,
              );
            },
          ),
        ),
        Icon(Icons.check_circle_outline, size: 25, color: Colors.orange)
      ],
    );
  }

  ///
  Widget _getWidgetCargando() {

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(),
          ),
          Text(
            'Cargando',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey
            ),
          )
        ],
      ),
    );
  }

  ///
  Future<bool> _getRestricciones() async {

    bool hasData = false;
    if(!this._constraints.containsKey('pza')){
      this._constraints = await emNotif.getConstraints();
      if(!this._constraints.containsKey('pza')){
        hasData = false;
      }
      hasData = true;
    }
    return hasData;

  }

  ///
  Widget _hidratarConstraintMarcas() {

    String txt = 'Sólo recibirás notificaciones cuando soliciten piezas para ...';
    if(this._constraints['mk'] == 'TODAS LAS MARCAS'){
      txt = 'Recibirás notificaciones sin restricciones cuando soliciten piezas para ...';
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            '$txt'
          ),
          const Divider(),
          const SizedBox(height: 5),
          _titPeq('LAS MARCAS:'),
          const SizedBox(height: 5),
          _lstBuilder(this._constraints['mk']),
          const SizedBox(height: 10),
          _titPeq('PARA LOS MODELOS:'),
          const SizedBox(height: 5),
          _lstBuilder(this._constraints['md']),
        ],
      ),
    );
  }

  ///
  Widget _hidratarConstraintPiezas() {

    String txt = 'de la marca ${this._constraints['mk']}';
    if(this._constraints['mk'].contains(',')){
      txt = 'solo de los Autos anteriores.';
    }
    if(this._constraints['mk'] == 'TODAS LAS MARCAS'){
      txt = '...';
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Tendrás prioridad cuando soliciten las siguientes Piezas $txt'
          ),
          const Divider(),
          const SizedBox(height: 5),
          _titPeq('PALABRAS CLAVES:'),
          const SizedBox(height: 5),
          _lstBuilder(this._constraints['pza'])
        ],
      ),
    );
  }

}