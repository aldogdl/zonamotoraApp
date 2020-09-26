import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/secciones_page_base.dart';

class PubsRefacsIndexPage extends StatefulWidget {
  @override
  _PubsRefacsIndexPageState createState() => _PubsRefacsIndexPageState();
}

class _PubsRefacsIndexPageState extends State<PubsRefacsIndexPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  BuildContext _context;
  bool _isInit = false;
  String lastUri;
  bool _showRastrear = true;
  String _username;

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    bool showResultados = (this._showRastrear) ? false : true;

    if(!this._isInit){
      this._isInit = true;
      DataShared dataShared = Provider.of<DataShared>(this._context, listen: false);
      lastUri = dataShared.lastPageVisit;
      dataShared.setLastPageVisit('refac_index_page');
      this._username = (dataShared.username == null) ? 'Anónimo' : dataShared.username;
    }

    return Scaffold(
      appBar: appBarrMy.getAppBarr(titulo: 'Estas en AUTOPARTES...'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () {
          if(lastUri != null) {
            Navigator.of(this._context).pushReplacementNamed(lastUri);
          }
          return Future.value(false);
        },
        child: Container(
          width: MediaQuery.of(this._context).size.width,
          height: MediaQuery.of(this._context).size.height * 0.9,
          child: SingleChildScrollView(
            child: Column(
              children: [
                (this._showRastrear) ? _reastreador() : _linkRastrear(),
                const SizedBox(height: 10),
                SeccionesPageBase(currentSeccion: 1, showResultados: showResultados)
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  Widget _reastreador() {

    return Container(
      margin: EdgeInsets.only(top: 10),
      width: MediaQuery.of(this._context).size.width * 0.93,
      height: MediaQuery.of(this._context).size.height * 0.61,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: Colors.red[400],
            offset: Offset(1,1)
          )
        ]
      ),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(this._context).size.width,
            height: MediaQuery.of(this._context).size.height * 0.20,
            child: Image(
              image: AssetImage('assets/images/call_center.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              '¿SABIAS que, podemos buscarte la mejor opción en Refacciones totalmente GRATIS?',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Somos el buscador de refacciones Seminuevas y Genericas número uno.',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]
              ),
            ),
          ),
          const SizedBox(height: 10),
          (this._username == 'Anónimo')
          ?
          Center(
            child: SizedBox(
              width: MediaQuery.of(this._context).size.width * 0.7,
              child: RaisedButton.icon(
                color: Colors.red,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                icon: Icon(Icons.verified_user),
                label: Text(
                  'CREAR UNA CUENTA',
                  textScaleFactor: 1,
                ),
                onPressed: (){
                  Navigator.of(this._context).pushNamedAndRemoveUntil('reg_index_page', (route) => false);
                },
              ),
            ),
          )
          :
          Center(
            child: SizedBox(
              width: MediaQuery.of(this._context).size.width * 0.7,
              child: RaisedButton.icon(
                color: Colors.red,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                icon: Icon(Icons.search),
                label: Text(
                  'COMENZAR A BUSCAR',
                  textScaleFactor: 1,
                ),
                onPressed: (){
                  Navigator.of(this._context).pushNamedAndRemoveUntil('add_autos_page', (route) => false);
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              (this._username == 'Anónimo') ? 'Necesitas tener una CUENTA' : 'Contamos con más de 100 proveedores.',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: MediaQuery.of(this._context).size.width * 0.7,
              child: RaisedButton.icon(
                color: Colors.blue[900],
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                icon: Icon(Icons.close),
                label: Text(
                  'VER PUBLICACIONES',
                  textScaleFactor: 1,
                ),
                onPressed: (){
                  setState(() {
                    this._showRastrear = false;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget _linkRastrear() {

    return InkWell(
      onTap: (){
        setState(() {
          this._showRastrear = true;
        });
      },
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Buscar la mejor opción',
              textScaleFactor: 1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 19,
                decoration: TextDecoration.underline
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.blue[900],
              child: Icon(Icons.search, size: 20),
            ),
          ],
        ),
      ),
    );

  }
}