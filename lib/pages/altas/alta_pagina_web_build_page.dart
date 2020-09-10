import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/alta_user_sngt.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/globals.dart' as globals;

class AltaPaginaWebBuildPage extends StatefulWidget {

  @override
  _AltaPaginaWebBuildPageState createState() => _AltaPaginaWebBuildPageState();
}

class _AltaPaginaWebBuildPageState extends State<AltaPaginaWebBuildPage> {

  AppBarrMy appBarrMy       = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AltaUserSngt altaUserSngt = AltaUserSngt();
  UserRepository emUser     = UserRepository();

  BuildContext _context;
  bool _isInit   = false;
  bool _saved = false;
  String _tokenTmpAsesor;

  String _txtError;

  @override
  Widget build(BuildContext context) {
    
    this._context = context;
    context = null;
    
    if(!this._isInit) {
      this._isInit = true;
      altaUserSngt.isAtras = true;
      DataShared proveedor = Provider.of<DataShared>(this._context, listen: false);
      proveedor.setLastPageVisit('alta_pagina_web_carrucel_page');
      this._tokenTmpAsesor = proveedor.tokenAsesor['token'];
      _saveDataSitioWeb();
    }

    return Scaffold(
      appBar: appBarrMy.getAppBarr(titulo: 'Alta de Pagina Web 3/4'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: _body(),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  Widget _body() {

    return Center(
      child: Container(
      width: MediaQuery.of(this.context).size.width * 0.7,
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          (globals.env == 'dev')
          ?
          FlatButton(
            onPressed: () => Navigator.of(this._context).pushReplacementNamed('alta_pagina_web_build_page'),
            child: Text('Reintentar'),
          )
          :
          SizedBox(height: 0),
          SizedBox(
            width: double.infinity,
            height: 100,
            child: Image(
              image: AssetImage('assets/images/img_fin_alta.png'),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'CONSTRUYENDO',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(),
          Text(
            'Espera un momento mientras creamos el Sitio Web',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          (this._txtError != null)
          ?
          _showError()
          :
          const SizedBox(height: 0)
        ],
      )
      ),
    );
  }

  ///
  Widget _showError() {

    return Container(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            '${this._txtError}',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '¿QUE DESAS HACER?',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.red
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: RaisedButton.icon(
              color: Colors.red,
              textColor: Colors.white,
              icon: Icon(Icons.close),
              label: Text(
                'CANCELAR',
                textScaleFactor: 1,
              ),
              onPressed: (){
                Navigator.of(this._context).pushReplacementNamed('alta_pagina_web_carrucel_page');
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: RaisedButton.icon(
              color: Colors.green,
              textColor: Colors.white,
              icon: Icon(Icons.refresh),
              label: Text(
                'REINTENTAR',
                textScaleFactor: 1,
              ),
              onPressed: (){
                Navigator.of(this._context).pushReplacementNamed('alta_pagina_web_build_page');
              },
            ),
          )
        ],
      ),
    );
  }

  ///
  Future<bool> _saveDataSitioWeb() async {

    this._txtError = null;
    
    if(!this._saved){
      this._saved = true;
      bool resp = await emUser.saveDataSitioWeb(altaUserSngt.createDataSitioWeb, this._tokenTmpAsesor);
      if(!resp) {
        setState(() {
          this._txtError = emUser.result['body'];
        });
      }else{
        altaUserSngt.setCreateDataSitioWebByKeySingle('idp', emUser.result['body']['idp']);
        if(emUser.result['body']['slug']['hasChangeSlug']){
          altaUserSngt.setCreateDataSitioWebByKeySingle('slug', emUser.result['body']['slug']['oldSlug']);
        }
        Navigator.of(this._context).pushReplacementNamed('alta_pagina_web_logo_page');
      }
    }

    return false;
  }
}