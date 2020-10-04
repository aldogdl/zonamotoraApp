import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/singletons/alta_user_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/bg_altas_stack.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/regresar_pagina_widget.dart' as regresarPagina;
import 'package:zonamotora/utils/validadores.dart';

class AltaSistemaPalClasPage extends StatefulWidget {
  @override
  _AltaSistemaPalClasPageState createState() => _AltaSistemaPalClasPageState();
}

class _AltaSistemaPalClasPageState extends State<AltaSistemaPalClasPage> {

  AppBarrMy appBarrMy       = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AlertsVarios alertsVarios = AlertsVarios();
  AltaUserSngt altaUserSngt = AltaUserSngt();
  Validadores validadores   = Validadores();
  BgAltasStack bgAltasStack = BgAltasStack();


  BuildContext _context;
  bool _isInit = false;
  GlobalKey<ScaffoldState> _skfKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _frmKey = GlobalKey<FormState>();
  TextEditingController _ctrlPalClas = TextEditingController();
  String _txtHelp = 'Selecciona un Sistema, por favor';
  Set<int> _lstIdsSistems = new Set();
  bool _isSmall;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    this._ctrlPalClas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;

    if(!this._isInit) {
      this._isInit = true;
      DataShared dataShared = Provider.of<DataShared>(this._context, listen: false);
      bgAltasStack.setBuildContext(this._context);
      dataShared.setLastPageVisit('alta_sistema_page');

      altaUserSngt.listSistemaSelect.forEach((sistema){
        this._lstIdsSistems.add(sistema['sa_id']);
      });
      this._isSmall = (MediaQuery.of(this._context).size.height <= 550) ? true : false;
    }

    return Scaffold(
      key: this._skfKey,
      appBar: appBarrMy.getAppBarr(titulo: 'Alta de ${altaUserSngt.usname.toUpperCase()}'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(this._context).size.width,
            height: MediaQuery.of(this._context).size.height * 0.84,
            child: _body(),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        mini: true,
        child: Icon(Icons.save, size: 25),
        onPressed: (){
          Navigator.of(this._context).pushReplacementNamed('alta_mksmds_page');
        },
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  /* */
  Widget _body() {

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[

        regresarPagina.widget(this._context, 'REGRESAR', lstMenu: altaUserSngt.crearMenuSegunRole()),
        bgAltasStack.stackWidget(
          titulo: '¿Maneja Refacciones Específicas?',
          subtitulo: 'Sólo si se especializa en Algo',
          altoMax: 0.48,
          altoMin: 0.48,
          widgetTraslapado_1: _cardInfoSistema(),
          widgetTraslapado_2: _posicionDelaLista()
        ),
      ],
    );
  }

  ///
  Widget _cardInfoSistema() {

    return Positioned(
        top: MediaQuery.of(this._context).size.height * 0.42,
        child: Container(
          width: MediaQuery.of(this._context).size.width * 0.8,
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(this._context).size.width * 0.1),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                offset: Offset(0, -5),
                spreadRadius: 1,
                color: Colors.red[800]
              )
            ]
          ),
          child: Column(
            children: <Widget>[
              Text(
                '${this._txtHelp}',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300
                ),
              ),
              SizedBox(
                height:90,
                width: 90,
                child: Image(
                  image: AssetImage('assets/images/auto_ico.png'),
                ),
              ),
              Text(
                'GUÍA DE REFERENCIA',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300
                ),
              ),
            ],
          ),
        ),
      );
  }

  ///
  Widget _posicionDelaLista() {

    return Positioned(
      top: MediaQuery.of(this._context).size.height * 0.11,
      child: _createListSistemas(),
    );
  }

  /* */
  Widget _createListSistemas() {

    return Container(
      height: MediaQuery.of(this._context).size.height * 0.3,
      width: MediaQuery.of(this._context).size.width,
      child: ListView.builder(
        itemCount: altaUserSngt.listSistemaSelect.length,
        itemBuilder: (BuildContext contex, int index) {

          final icono = _getElementByListSeleccionada('icono', index);
          Map<String, dynamic> sistemaTxt = altaUserSngt.lstSistemas.firstWhere((element) => element['sa_id'] == altaUserSngt.listSistemaSelect[index]['sa_id']);

          return ListTile(
            dense: true,
            leading: Icon(icono, color: Colors.white),
            trailing: FlatButton(
              child: Text(
                '| Gestionar |',
                textScaleFactor: 1,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.amberAccent
                ),
              ),
              onPressed: (){
                this._skfKey.currentState.showBottomSheet((_) {
                  _getElementByListSeleccionada('palClas', index);
                  return _contenedorDelInputPalClas(index);
                });
              },
            ),
            onTap:(){
              setState(() {
                this._txtHelp = altaUserSngt.lstSistemas[index]['sa_despeq'];
              });
            },
            title: Text(
              '${sistemaTxt['sa_nombre']}',
              textScaleFactor: 1,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 17,
                letterSpacing: 1
              ),
            ),
          );
        },
      ),
    );
  }

  /* */
  Widget _contenedorDelInputPalClas(int index) {

    Map<String, dynamic> sistemaTxt = altaUserSngt.lstSistemas.firstWhere((element) => element['sa_id'] == altaUserSngt.listSistemaSelect[index]['sa_id']);

    return Container(
      width: MediaQuery.of(this._context).size.width,
      //height: MediaQuery.of(this._context).size.height * ((this._isSmall) ? 0.42 : 0.32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 7),
            width: MediaQuery.of(this._context).size.width,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black, width: 3)
              ),
              color: Colors.orange,
            ),
            child: Text(
              '${sistemaTxt['sa_nombre']}',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 8),
            child: Text(
              'Separa las PIEZAS con COMAS (,)',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.3
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 0),
            child: _inputPalClas(index),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton.icon(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                icon: Icon(Icons.close),
                label: Text(
                  'CERRAR',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
                onPressed: (){
                  Navigator.of(this._context).pop(false);
                }, 
              ),
              FlatButton.icon(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                icon: Icon(Icons.save_alt),
                label: Text(
                  'GUARDAR',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16
                  ),
                ),
                onPressed: (){
                  _addPalClasToSingleton(altaUserSngt.listSistemaSelect[index]['sa_id']);
                }, 
              ),
            ],
          )
        ],
      ),
    );
  }

  /* */
  Widget _inputPalClas(int index) {

    String palClas = this._ctrlPalClas.text.trim();
    if(palClas.isNotEmpty) {
      this._ctrlPalClas = new TextEditingController.fromValue(
        new TextEditingValue(
          text: palClas,
          selection: new TextSelection.collapsed(
            offset: palClas.length
          )
        )
      );
    }
    
    return Form(
      key: this._frmKey,
      child: TextFormField(
        controller: this._ctrlPalClas,
        autofocus: true,
        maxLines: (this._isSmall) ? 2 : 3,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        validator: (String val) {
          val = val.trim();
          String error;
          if(val.length == 0) {
            //error = 'Coloca al menos una palabra clave';
            this._ctrlPalClas.text = '0';
            return null;
          }
          Map<String, String> result = validadores.quitarAcentos(val);
          if(result['error'] != '0') {
            error = result['error'];
          }else{
            this._ctrlPalClas.text = result['newtext'];
            error = null;
          }
          return error;
        },
        onFieldSubmitted: (String val){
          _addPalClasToSingleton(altaUserSngt.listSistemaSelect[index]['sa_id']);
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey
            )
          ),
          hintText: 'Ej. faros, computadoras, cofres ...',
          errorStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14
          )
        ),
      ),
    );
  }

  /// Retornamos el tipo de icono para colocarlo en el Checkbox, si esta
  /// hidratado con palabras claves o está bacio.
  dynamic _getElementByListSeleccionada(String element, int indexList) {

    IconData icono;
    int idCurrent = altaUserSngt.listSistemaSelect[indexList]['sa_id'];
    Map<String, dynamic> sistema = altaUserSngt.listSistemaSelect.firstWhere(
      (sis) => (sis['sa_id'] == idCurrent), orElse: () => new Map()
    );
    if(sistema.isEmpty) {
      icono = Icons.warning;
    }else{
      icono = (sistema['sa_palclas'] != '0') ? Icons.check_box : Icons.check_box_outline_blank;
      if(element == 'palClas') {
        this._ctrlPalClas.text = (sistema['sa_palclas'] != '0') ? sistema['sa_palclas'] : '';
      }
    }
    return icono;
  }

  /* */
  void _addPalClasToSingleton(int idSistema) {
    if(this._frmKey.currentState.validate()) {
      altaUserSngt.setPalClasToSistemSelect(idSistema, this._ctrlPalClas.text);
      Navigator.of(this._context).pop(false);
    }
  }


}