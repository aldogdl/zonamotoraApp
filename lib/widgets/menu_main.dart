import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/globals.dart' as globals;


class MenuMain extends StatelessWidget {
  const MenuMain({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height * 0.25;

    final btns = {
      'config': {
        'titulo' : 'Ver Configuraciones',
        'ico' : Icons.settings,
        'path'  : 'config_page'
      },
      'autos': {
        'titulo': 'Mis Autos Registrados',
        'ico'   : Icons.directions_car,
        'path'  : 'mis_autos_page'
      },
      'vincular': {
        'titulo': 'Vincular Dispositivo',
        'ico'   : Icons.phone_android,
        'path'  : 'inxed_page'
      },
      'registro': {
        'titulo': 'Registro de Usuario',
        'ico'   : Icons.security,
        'path'  : 'reg_index_page'
      }
    };
    return SafeArea(
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: w, height: h,
              child: _cabecera(w, h),
            ),
            _titulo(w),
            _btnCreate(context, btns['autos']),
            Divider(height: 1, color: Colors.red[200]),
            _btnCreate(context, btns['vincular']),
            Divider(height: 1, color: Colors.red[200]),
            _btnCreate(context, btns['registro']),
            Divider(height: 1, color: Colors.red[200]),
            _btnCreate(context, btns['config']),
          ],
        ),
      ),
    );
  }

  /* */
  Widget _cabecera(double w, double h) {
    
    return Stack(
      alignment: Alignment.center,
      overflow: Overflow.clip,
      children: <Widget>[
        Positioned(
          top: 0,
          child: Container(
            width: w,
            height: h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff7C0000),
                  Colors.red
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter
              )
            ),
          )
        ),
        Positioned(
          top: 0,
          child: SizedBox(
            width: w,
            height: h,
            child: Image(
              fit: BoxFit.contain,
              image: AssetImage('assets/images/zona_motora.png'),
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 10,
          child: Text(
            '${globals.version}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14
            ),
          )
        ),
      ],
    );
  }

  /* */
  Widget _titulo(double w) {

    return Container(
      height: 30,
      width: w,
      color: Colors.grey[400],
      child: Center(
        child: Consumer<DataShared>(
          builder: (_, dataShared, __){
            String tipoApp;
            if(dataShared.username == null){
              tipoApp = 'Genérica';
            }else{
              tipoApp = 'Genérica';
            }
            if(dataShared.username != 'Anónimo') {
              tipoApp = 'Autorizada';
            }
            return Text(
              'Aplicaión $tipoApp',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            );
          },
        ),
      ),
    );
  }

  /* */
  Widget _btnCreate(BuildContext context, Map<String, dynamic> data) {

    return ListTile(
      onTap: (){
        if(data['path'] == 'config_page') {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(data['path']);
        }else{
          Navigator.of(context).pushNamedAndRemoveUntil(data['path'], (Route rutas) => false);
        }
      },
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
      dense: true,
      title: Text(
        '${data['titulo']}',
        textAlign: TextAlign.start,
      ),
      leading: Icon(data['ico'])
    );
  }

}