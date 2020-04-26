import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/alta_user_sngt.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/regresar_pagina_widget.dart' as regresarPagina;


class ListaUsersPage extends StatefulWidget {
  @override
  _ListaUsersPageState createState() => _ListaUsersPageState();
}

class _ListaUsersPageState extends State<ListaUsersPage> {

  AppBarrMy appBarrMy       = AppBarrMy();
  UserRepository emUser     = UserRepository();
  MenuInferior menuInferior = MenuInferior();
  AltaUserSngt altaUserSngt = AltaUserSngt();

  bool _isInit = false;
  Size _screen;
  String _tokenTmpAsesor;
  /// Revisamos si hay un usuario en proceso
  int _idUsrAct;
  List<Map<String, dynamic>> _usuarios;
  Widget _lstSocios;
  BuildContext _context;
  DateFormat _format;

  @override
  void initState() {
    this._format = DateFormat('d-MM-yyyy hh:m a');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;

    if(!this._isInit) {
      this._isInit = true;
      this._tokenTmpAsesor = Provider.of<DataShared>(this._context, listen: false).tokenAsesor['token'];
      Provider.of<DataShared>(this._context, listen: false).setLastPageVisit('alta_index_menu_page');
      _getUltimosUserRegistrados();
      this._idUsrAct = altaUserSngt.userId;
      this._lstSocios = Column(
        children: <Widget>[
          _regresoLink(),
          SizedBox(height: this._screen.height * 0.3),
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      );
    }

    return Scaffold(
      appBar: appBarrMy.getAppBarr(titulo: 'Últimos Registros'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: this._lstSocios,
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  /* */
  Future<void> _getUltimosUserRegistrados() async {

    this._usuarios = await emUser.getUltimosUserRegistrados(this._tokenTmpAsesor);
    if(this._usuarios.length == 0) {
      _crearWidgetSinResultados();
    }else{
      if(this._usuarios.first.containsKey('abort')){
        _crerWidgetErrorServer(this._usuarios.first);
      }else{
        _crearWidgetListaDeUsers();
      }
    }
  }

  /* */
  void _crerWidgetErrorServer(Map<String, dynamic> err) {

    Widget w = Column(
      children: <Widget>[
        _regresoLink(),
        SizedBox(height: this._screen.height * 0.2),
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: this._screen.width * 0.1),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                err['msg'],
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: Image(
                  image: AssetImage('assets/images/server-error.png'),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                err['body'],
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        )
      ],
    );

    setState(() {
      this._lstSocios = w;
    });
  }

  /* */
  void _crearWidgetSinResultados() {

    Widget w = Column(
      children: <Widget>[
        _regresoLink(),
        SizedBox(height: this._screen.height * 0.3),
        Center(
          child: Text(
            'Sin Resultados.\nDa de alta un USUARIO',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w300,
              color: Colors.red[400]
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );

    setState(() {
      this._lstSocios = w;
    });
  }

  /* */
  void _crearWidgetListaDeUsers() {

    Widget w = Column(
      children: <Widget>[
        SizedBox(
          height: this._screen.height * 0.08,
          child: _regresoLink(),
        ),
        SizedBox(
          height: this._screen.height * 0.66,
          child: ListView.builder(
            itemCount: this._usuarios.length,
            itemBuilder: (context, int index) {
              
              return (this._idUsrAct != this._usuarios[index]['u_id'])
              ? _machoteTitleListUser(index)
              : Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: _machoteTitleListUser(index),
              );

            }
          )
        )
      ]
    );

    setState(() {
      this._lstSocios = w;
    });
  }

  ///
  Widget _machoteTitleListUser(int index) {

    DateTime fecha = DateTime.parse(this._usuarios[index]['u_createdAt']['date']);
    return ListTile(
      isThreeLine: true,
      onTap: (){
        altaUserSngt.setUserId(this._usuarios[index]['u_id']);
        altaUserSngt.setUsname(this._usuarios[index]['u_username']);
        altaUserSngt.setRoles(this._usuarios[index]['u_roles'][0]);
        // tipos de alta.
        switch (this._usuarios[index]['u_roles'][0]) {
          case 'ROLE_AUTOS':
            Navigator.of(this._context).pushNamedAndRemoveUntil('alta_perfil_contac_page', (Route rutas) => false);
            break;
          case 'ROLE_SOCIO':
            Navigator.of(this._context).pushNamedAndRemoveUntil('alta_sistema_page', (Route rutas) => false);
            break;
          case 'ROLE_SERVS':
            Navigator.of(this._context).pushNamedAndRemoveUntil('alta_sistema_page', (Route rutas) => false);
            break;
          default:
        }
      },
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.perm_identity, size: 40),
          Text(
            'ID ${this._usuarios[index]['u_id']}',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 13,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
      title: Text(
        '${this._usuarios[index]['u_nombre']}',
        textScaleFactor: 1,
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Publicado el ${ this._format.format(fecha) }',
            textScaleFactor: 1,
          ),
          Text(
            'NU: ${ this._usuarios[index]['u_username'] } :: Rol: ${ this._usuarios[index]['u_roles'][0] }',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }

  ///
  Widget _regresoLink() {

    return regresarPagina.widget(this._context, 'IR AL MENÚ DE OPCIONES', lstMenu: altaUserSngt.crearMenuSegunRole(), showBtnMenualta: false);
  }
}