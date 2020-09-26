import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zonamotora/repository/notifics_repository.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/banners_top.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';

class NotificacionesPage extends StatefulWidget {
  @override
  _NotificacionesPageState createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {

  NotificsRepository emNotif = NotificsRepository();
  
  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  Size _screen;
  BuildContext _context;
  List<Map<String, dynamic>> _notifics = new List();
  bool _isMarkVistos = false;
  bool _isInit = false;

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;
    
    if(!this._isInit){
      this._isInit = true;
      emNotif.setContext(this._context);
    }
    return Scaffold(
      appBar: appBarrMy.getAppBarr(titulo: 'NOTIFICACIONES'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: Column(
        children: [
          _body(),
          FutureBuilder(
            future: _getNotificaciones(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {

              if(snapshot.hasData) {
                if(this._notifics.length == 0) {
                  return _sinNotificaciones();
                }else{
                  return _lstNotificaciones();
                }
              }

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Cargando nuevas Notificaciones',
                      textScaleFactor: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: LinearProgressIndicator(),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  /* */
  Widget _body() {

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          width: this._screen.width,
          height: this._screen.height * 0.28,
          decoration: BoxDecoration(
            color: Color(0xff7C0000)
          ),
          child: SizedBox(height: 30),
        ),

         // Banners
        Positioned(
          top: 0,
          child:  BannersTop()
        ),
      ],
    );
  }

  ///
  Future<bool> _getNotificaciones() async {

    this._notifics = await emNotif.makeBackupNotificaciones();
    if(this._notifics.length == 0){
      await emNotif.hideIconNotif();
    }
    if(!this._isMarkVistos){
      this._isMarkVistos = true;
      await emNotif.markComo('visto');
    }
    return true;
  }

  ///
  Widget _sinNotificaciones() {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Divider(height: 0, color: Colors.grey[600]),
        ),
        Text(
          'SIN NOTIFICACIONES',
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );

  }

  ///
  Widget _lstNotificaciones() {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: MediaQuery.of(this._context).size.width,
          color: Colors.white,
          padding: EdgeInsets.all(7),
          child: Text(
            'NOTIFICACIONES',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 10),
          height: MediaQuery.of(this._context).size.height * 0.45,
          width: MediaQuery.of(this._context).size.width,
          child: _lstNotifics(),
        )
      ],
    );
  }

  ///
  Widget _lstNotifics() {

    return ListView.builder(
      itemCount: this._notifics.length,
      itemBuilder: (BuildContext _context, int index) {
        
        Map<String, dynamic> date = json.decode(this._notifics[index]['createdAt']);

        return ListTile(
          dense: true,
          leading: Icon(Icons.notifications_paused, color: Colors.orange[600], size: 30,),
          title: Text(
            '${this._notifics[index]['titulo']}',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
          ),
          subtitle: Text(
            'Último enviado: ${date['date'].split(' ')[0]}',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 14
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.arrow_forward_ios, size: 20),
              Text(
                ' ${this._notifics[index]['cant']} ',
                textScaleFactor: 1,
                style: TextStyle(
                  backgroundColor: Colors.red,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 13
                ),
              ),
            ],
          ),
          onTap: () async {

            print('hola');
            String pageTo = this._notifics[index]['page'];
            if(this._notifics[index].containsKey('idServer')){
              if(this._notifics[index]['idServer'] != 0){
                await emNotif.markComo('leido', idPush: this._notifics[index]['idServer']);    
              }
            }
            
            int hasTot = await emNotif.deleteTemaNotifById(this._notifics[index]['id']);
            if(hasTot == 0){
              await emNotif.hideIconNotif();
            }

            Navigator.of(this._context).pushNamedAndRemoveUntil(pageTo, (route) => false);
          },
        );
      },
    );
  }

}