import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/globals.dart' as globals;
import 'package:zonamotora/widgets/frm_change_ip.dart';


class MenuMain extends StatelessWidget {

  MenuMain({Key key}) : super(key: key);

  final btns = {
    'index': {
      'titulo': 'Página Principal',
      'ico' : Icons.home,
      'path': 'index_page'
    },
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
    },
    'constraint': {
      'titulo': 'Restricciones Push',
      'ico'   : Icons.notification_important,
      'path'  : 'constraint_page_push'
    },
    'zonaMotora': {
      'titulo': 'Zona Motora',
      'ico'   : Icons.business,
      'path'  : 'info_zm_page'
    },
    'opVentas': {
      'titulo': 'Oportunidades',
      'ico'   : Icons.monetization_on,
      'path'  : 'oportunidades_page'
    },
    'solicitud': {
      'titulo': 'Mis Solicitudes',
      'ico'   : Icons.extension,
      'path'  : 'index_cotizacion_page'
    }
  };

  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height * 0.25;
    String role = Provider.of<DataShared>(context, listen: false).role;
    String username = Provider.of<DataShared>(context, listen: false).username;
    
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
            Consumer<DataShared>(
              builder: (_, dataShared, __){
                String tipoApp;
                if(dataShared.username == null){
                  tipoApp = 'Aplicaión Genérica';
                }else{
                  tipoApp = 'Aplicaión Genérica';
                }
                if(dataShared.username != 'Anónimo') {
                  tipoApp = 'App. Autorizada para ${dataShared.username}';
                }
                return _titulo(w, '$tipoApp');
              },
            ),
            (globals.env == 'dev')
            ?
            FrmChangeIpWidget()
            :
            SizedBox(height: 0),
            Expanded(
              child: ListView(
                children: [

                  _btnCreate(context, btns['index']),

                  (role == 'ROLE_SOCIO')
                  ?
                  Column(
                    children: [
                      _getDivider(),
                      _btnCreate(context, btns['opVentas'])
                    ],
                  )
                  :
                  const SizedBox(height: 0),

                  (role != 'ROLE_SOCIO' && username != 'Anónimo')
                  ?
                  Column(
                    children: [
                      _getDivider(),
                      _btnCreate(context, btns['solicitud'])
                    ],
                  )
                  :
                  const SizedBox(height: 0),
                  (username != 'Anónimo')
                  ?
                  Column(
                    children: [
                      _getDivider(),
                      _btnCreate(context, btns['autos'])
                    ],
                  )
                  :
                  const SizedBox(height: 0),
                  _getDivider(),
                  _btnCreate(context, btns['zonaMotora']),
                  
                  _titulo(w, 'Configuraciones'),
                  (role != 'ROLE_SOCIO' && username != 'Anónimo')
                  ?
                  Column(
                    children: [
                      _getDivider(),
                      _btnCreate(context, btns['vincular'])
                    ],
                  )
                  :
                  const SizedBox(height: 0),
                  _getDivider(),
                  _btnCreate(context, btns['registro']),
                  _getDivider(),
                  _btnCreate(context, btns['config']),
                  _getDivider(),
                  Consumer<DataShared>(
                    builder: (_, dataShared, __) {
                      if(dataShared.role == 'ROLE_SOCIO'){
                        return  _btnCreate(context, btns['constraint']);
                      }
                      return const SizedBox();
                    }
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///
  Widget _getDivider() {
    return Divider(height: 1, color: Colors.red[200]);
  }

  ///
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
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Color(0xffffffff),
                  Color(0xffffffff),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              )
            ),
          )
        ),
        Positioned(
          top: 20,
          child: SizedBox(
            width: w * 0.8,
            height: h * 0.8,
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
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 14
            ),
          )
        ),
      ],
    );
  }

  /* */
  Widget _titulo(double w, String titulo) {

    return Container(
      height: 30,
      width: w,
      color: Colors.grey[300],
      child: Center(
        child: Text(
          '$titulo',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
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
        textScaleFactor: 1,
        textAlign: TextAlign.start,
      ),
      leading: Icon(data['ico'])
    );
  }

}