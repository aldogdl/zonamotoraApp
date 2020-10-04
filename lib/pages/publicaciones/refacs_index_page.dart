import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/widgets/plantilla_base.dart';
import 'package:zonamotora/widgets/secciones_page_base.dart';

class PubsRefacsIndexPage extends StatefulWidget {
  @override
  _PubsRefacsIndexPageState createState() => _PubsRefacsIndexPageState();
}

class _PubsRefacsIndexPageState extends State<PubsRefacsIndexPage> {

  BuildContext _context;
  bool _isInit = false;
  bool _showRastrear = true;
  String _username;
  String _role;
  SharedPreferences _sess;

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;

    if(!this._isInit) {
      this._isInit = true;
      DataShared dataShared = Provider.of<DataShared>(this._context, listen: false);
      this._username = (dataShared.username == null) ? 'Anónimo' : dataShared.username;
      this._role = dataShared.role;
      _getInstancia();
    }

    return PlantillaBase(
      pagInf: 0,
      context: this._context,
      activarIconInf: true,
      isIndex: false,
      child: _body(),
    );
  }

  ///
  Widget _body() {

    bool showResultados = (this._showRastrear) ? false : true;

    Widget widgetBase = SeccionesPageBase(
      currentSeccion: 1,
      showResultados: (this._role != 'ROLE_SOCIO') ? showResultados : true,
      setLastPage: 'refac_index_page',
      hasHeadAdicional: (this._role != 'ROLE_SOCIO') ? true : false,
    );

    int alto = (this._username == 'Anónimo') ? 175 : 135;

    if(this._role == 'ROLE_SOCIO') {
      return widgetBase;
    }

    return FutureBuilder(
      future: _getInstancia(),
      builder: (_, AsyncSnapshot snapshot) {

        if(snapshot.connectionState == ConnectionState.done){
          if(this._showRastrear) {
            return Container(
              width: MediaQuery.of(this._context).size.width,
              height: MediaQuery.of(this._context).size.height - alto,
              decoration: BoxDecoration(
                color: Colors.red[50],
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    color: Colors.red[200],
                    offset: Offset(1,1)
                  )
                ]
              ),
              child: SingleChildScrollView(
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [ _reastreador(),  widgetBase ]
                ),
              ),
            );
          }else{
            return Column( children: [ _linkRastrear(), widgetBase ]);
          }
        }

        return SizedBox(
          width: MediaQuery.of(this._context).size.width,
          child: Center(
            child: LinearProgressIndicator(),
          ),
        );
      },
    );
    
  }
  
  ///
  Widget _reastreador() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(this._context).size.width,
              height: MediaQuery.of(this._context).size.height * 0.20,
              child: Image(
                image: AssetImage('assets/images/call_center.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                width: MediaQuery.of(this._context).size.width,
                color: Colors.white.withAlpha(190),
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.all(0),
                  activeColor: Colors.black,
                  checkColor: Colors.white,
                  dense:true,
                  value: this._sess.getBool('showContainerRefacs'),
                  title: Text(
                    'Maximizar Contenido',
                    textScaleFactor: 1,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  onChanged: (bool val){
                    setState(() {
                      this._sess.setBool('showContainerRefacs', val);
                    });
                  },
                ),
              ),
            )
          ],
        ),
        (this._sess.getBool('showContainerRefacs'))
        ?
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            '¿SABIAS que, podemos buscarte la mejor opción en Refacciones totalmente GRATIS?',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xff002f51)
            ),
          ),
        )
        :
        const SizedBox(height: 0),
        (this._sess.getBool('showContainerRefacs'))
        ?
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
        )
        :
        const SizedBox(height: 10),
        (this._username == 'Anónimo')
        ?
        Center(
          child: SizedBox(
            width: MediaQuery.of(this._context).size.width * 0.85,
            child: RaisedButton.icon(
              color: Colors.red,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2)
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
        (Provider.of<DataShared>(this._context, listen: false).role != 'ROLE_SOCIO')
        ?
        Center(
          child: SizedBox(
            width: MediaQuery.of(this._context).size.width * 0.85,
            child: RaisedButton.icon(
              color: Colors.red,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2)
              ),
              icon: Icon(Icons.search),
              label: Text(
                'BUSCAR UNA MEJOR OPCIÓN',
                textScaleFactor: 1,
              ),
              onPressed: (){
                Navigator.of(this._context).pushNamedAndRemoveUntil('add_autos_page', (route) => false);
              },
            ),
          ),
        )
        :
        Center(
          child: SizedBox(height: 0),
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
            width: MediaQuery.of(this._context).size.width * 0.85,
            child: RaisedButton.icon(
              color: Colors.blue[900],
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2)
              ),
              icon: Icon(Icons.remove_red_eye),
              label: Text(
                'VER PIEZAS PUBLICADAS',
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
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Buscar la mejor opción AQUÍ',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 17,
                  ),
                ),
                Text(
                  'Solicita la pieza que no encontraste',
                  textScaleFactor: 1,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 13,
                  ),
                )
              ],
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.red,
              child: Icon(Icons.search, size: 20),
            ),
          ],
        ),
      ),
    );

  }

  ///
  Future<void> _getInstancia() async {

    this._sess = await SharedPreferences.getInstance();
    if(!this._sess.containsKey('showContainerRefacs')){
      this._sess.setBool('showContainerRefacs', true);
    }else{
      if(this._sess.getBool('showContainerRefacs')){
      }
    }
  }

}