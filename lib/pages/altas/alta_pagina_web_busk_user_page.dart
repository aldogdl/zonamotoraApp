import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/alta_user_sngt.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/regresar_pagina_widget.dart' as regresarPagina;

class AltaPaginaWebBuskUserPage extends StatefulWidget {

  @override
  _AltaPaginaWebBuskUserPageState createState() => _AltaPaginaWebBuskUserPageState();
}

class _AltaPaginaWebBuskUserPageState extends State<AltaPaginaWebBuskUserPage> {

  AppBarrMy appBarrMy       = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AltaUserSngt altaUserSngt = AltaUserSngt();
  UserRepository emUser     = UserRepository();

  BuildContext _context;
  bool _isInit   = false;
  String _tokenTmpAsesor;
  TextEditingController _ctrlCriterio = TextEditingController();
  Widget _widgetResults;

  @override
  void dispose() {
    this._ctrlCriterio?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    this._widgetResults = _initWidget();
    altaUserSngt.setCreateDataSitioWebInit();
    altaUserSngt.isAtras = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    this._context = context;
    context = null;

    if(!this._isInit) {
      this._isInit = true;
      DataShared proveedor = Provider.of<DataShared>(this._context, listen: false);
      proveedor.setLastPageVisit('alta_index_menu_page');
      this._tokenTmpAsesor = proveedor.tokenAsesor['token'];
    }

    return Scaffold(
      appBar: appBarrMy.getAppBarr(titulo: 'Sitios WEB'),
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

    return Column(
      children: [
        Column(
          children: [
            regresarPagina.widget(this._context, 'alta_index_menu_page', lstMenu: altaUserSngt.crearMenuSegunRole(), showBtnMenualta: false),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: EdgeInsets.only(top: 0, bottom: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(200),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)
                )
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: this._ctrlCriterio,
                      autofocus: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.supervised_user_circle),
                        helperText: 'Busca por Usuario o ID del Socio',
                        hintText: '¿A cuál Socio?'
                      ),
                      textInputAction: TextInputAction.done,
                      onEditingComplete: ()async => hacerBusqueda()
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.center,
                    color: Colors.blue,
                    icon: Icon(Icons.search),
                    onPressed: () async => hacerBusqueda(),
                  )
                ],
              ),
            )
          ],
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(this._context).size.width,
            child: this._widgetResults,
          ),
        )
      ],
    );
  }

  ///
  Future<void> hacerBusqueda() async {

    setState(() {
      this._widgetResults = _buscando();
    });
    List<Map<String, dynamic>> lstUsers = await emUser.buscarUserBy(this._ctrlCriterio.text, this._tokenTmpAsesor);

    if(lstUsers.length > 0) {
      setState(() {
        this._widgetResults = _verLstsociosResultados(lstUsers);
      });
    }else{
      setState(() {
        this._widgetResults = _sinResultados();
      });
    }

    FocusScope.of(this._context).requestFocus(new FocusNode());
  }

  ///
  Widget _buscando() {

    return Center(
      child: SizedBox(
        height: 100,
        width: 100,
        child: Column(
          children: [
            CircularProgressIndicator(),
            const SizedBox(height: 10),
            Text(
              'Buscando',
              textScaleFactor: 1,
            )
          ],
        ),
      ),
    );
  }

  ///
  Widget _initWidget() {

    return _machoteDeResultados(
      Icons.search,
      Colors.grey,
      'Encuentra el registro del socio al cual le darás de Alta su Sitio Web.'
    );
  }

  ///
  Widget _sinResultados() {

    return _machoteDeResultados(
      Icons.face,
      Colors.red,
      'No se encontraron socios con el criterio indicado en la caja de búsqueda.'
    );
  }

  ///
  Widget _verLstsociosResultados(List<Map<String, dynamic>> lstSocios) {
    
    return ListView.builder(
      itemCount: lstSocios.length,
      itemBuilder: (_, index) {
        
        DateTime creado = DateTime.parse(lstSocios[index]['u_createdAt']['date']);

        return ListTile(
          leading: Icon(Icons.account_circle, size: 40, color: Colors.blueGrey),
          contentPadding: EdgeInsets.all(0),
          title: Text(
            '${lstSocios[index]['u_username']}',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          subtitle: Text(
            'Creado el: ${creado.day}-${creado.month}-${creado.year} -> ID: ${lstSocios[index]['u_id']}',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 13
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 20),
          onTap: () {
            altaUserSngt.setCreateDataSitioWebByKeyMap('ids', 'perfil', lstSocios[index]['p_id']);
            altaUserSngt.setCreateDataSitioWebByKeyMap('ids', 'user', lstSocios[index]['u_id']);
            altaUserSngt.setCreateDataSitioWebByKeySingle('slug', lstSocios[index]['p_razonSocial']);
            altaUserSngt.setCreateDataSitioWebByKeySingle('pagWeb', lstSocios[index]['p_pagWeb']);
            Navigator.of(this._context).pushReplacementNamed('alta_pagina_web_despeq_page');
          },
        );
      }
    );
  }

  ///
  Widget _machoteDeResultados(IconData icono, Color icoColor, String msg) {

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$msg',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800]
              ),
            ),
            Icon(icono, size: 100, color: icoColor)
          ],
        ),
      ),
    );
  }
}