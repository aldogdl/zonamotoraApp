import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/app_varios_repository.dart';
import 'package:zonamotora/singletons/alta_user_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/regresar_pagina_widget.dart' as regresarPagina;

class AltaSistemaPage extends StatefulWidget {
  @override
  _AltaSistemaPageState createState() => _AltaSistemaPageState();
}

class _AltaSistemaPageState extends State<AltaSistemaPage> {

  AppBarrMy appBarrMy       = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AlertsVarios alertsVarios = AlertsVarios();
  AltaUserSngt altaUserSngt = AltaUserSngt();
  AppVariosRepository emAppVarios = AppVariosRepository();

  BuildContext _context;
  bool _isInit = false;
  Set<int> _lstIdsSistems = new Set();

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;

    if(!this._isInit) {
      this._isInit = true;
      Provider.of<DataShared>(this._context, listen: false).setLastPageVisit('alta_lst_users_page');
      getSistemas();
      altaUserSngt.listSistemaSelect.forEach((sistema){
        this._lstIdsSistems.add(sistema['sa_id']);
      });
    }

    return Scaffold(
      appBar: appBarrMy.getAppBarr(titulo: 'Alta de ${altaUserSngt.usname.toUpperCase()}'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getSistemas(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(altaUserSngt.lstSistemas.length > 0) {
                return _body();
              }
              return Padding(
                padding: EdgeInsets.all(30),
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        mini: true,
        child: Icon(Icons.save, size: 25),
        onPressed: () async {
          if(this._lstIdsSistems.isEmpty) {
            await alertsVarios.entendido(this._context, titulo: 'SISTEMAS DEL AUTO', body: 'Por favor, selecciona al menos un Sistema de auto para conocer que es lo que ofrecer al público el Usuario.');
          }else{
            await altaUserSngt.setSistemSelect(this._lstIdsSistems);
            Navigator.of(this._context).pushReplacementNamed('alta_sistema_pc_page');
          }
        },
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  /* */
  Widget _body() {
    
    return Column(
      children: _createListWidgets()
    );
  }

  /* */
  Future<void> getSistemas() async {

    if(altaUserSngt.lstSistemas.length == 0) {
      List<Map<String, dynamic>> sistemas = await emAppVarios.getSistemas();
      if(sistemas.first.containsKey('error')) {
        await alertsVarios.entendido(this._context, titulo: emAppVarios.result['msg'], body: emAppVarios.result['body']);
        return;
      }
      altaUserSngt.lstSistemas =sistemas;
      sistemas = null;
    }
  }

  /* */
  List<Widget> _createListWidgets() {

    List<Widget> lw = [
      regresarPagina.widget(this._context, 'IR LISTA DE USUARIOS', lstMenu: altaUserSngt.crearMenuSegunRole()),
        Divider(),
        Text(
          'Principalmente el Socio...\n¿Qué Sistemas maneja?',
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: MediaQuery.of(this._context).size.aspectRatio * 29,
            fontWeight: FontWeight.bold
          ),
        ),
        Divider(),
    ];

    for (var i = 0; i < altaUserSngt.lstSistemas.length; i++) {
      lw.add(_swithSistemaCard(index: i));
    }
    lw.add(const SizedBox(height: 70));
    return lw;
  }

  /* */
  Widget _swithSistemaCard({int index}) {

    double marginHrz = 20;
    List<IconData > iconos = [
      Icons.extension,
      Icons.airport_shuttle,
      Icons.local_car_wash,
      Icons.call_split,
      Icons.battery_charging_full,
      Icons.pan_tool,
      Icons.album,
      Icons.build,
      Icons.category,
      Icons.cached
    ];

    int idEnCurso = altaUserSngt.lstSistemas[index]['sa_id'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: marginHrz, vertical: 5),
          padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 1,
                offset: Offset(1, 1),
                spreadRadius: 1,
                color: Colors.red[300]
              )
            ]
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 3,
                      color: Colors.black38
                    )
                  ),
                  child: Center(
                    child: Icon(iconos[index], color: Colors.white,),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: SwitchListTile(
                  value: (this._lstIdsSistems.contains(idEnCurso)) ? true : false,
                  title: Text(
                    altaUserSngt.lstSistemas[index]['sa_nombre'],
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      color: Colors.redAccent
                    ),
                  ),
                  onChanged: (val){
                    if(val) {
                      this._lstIdsSistems.add(idEnCurso);
                    }else{
                      this._lstIdsSistems.remove(idEnCurso);
                    }
                    setState(() {});
                  }
                ),
              )
            ],
          ),
        ),
      ],
    );
  }


}