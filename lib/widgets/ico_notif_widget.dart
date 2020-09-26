import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/notifics_repository.dart';

class IcoNotifWidget extends StatefulWidget {
  IcoNotifWidget({Key key}) : super(key: key);

  @override
  _IcoNotifWidgetState createState() => _IcoNotifWidgetState();
}

class _IcoNotifWidgetState extends State<IcoNotifWidget> {

  NotificsRepository emNotif = NotificsRepository();

  List<Map<String, dynamic>> _notifics = new List();
  BuildContext _context;
  bool _isInit = false;
  bool _isMarkVistos = false;

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    if(!this._isInit){
      this._isInit = true;
      emNotif.setContext(this._context);
    }

    return InkWell(
      onTap: () => _verDialogNotifics(),
      child: Row(
        children: <Widget>[
          Icon(Icons.notifications_active, color: Colors.yellow),
          CircleAvatar(
            radius: 12,
            child: Consumer<DataShared>(
              builder: (BuildContext context, dataShared, _){
                return Text(
                  '${dataShared.cantNotif}',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 10)
        ],
      ),
    );
  }

  ///
  void _verDialogNotifics() {

    showDialog(
      context: this._context,
      builder: (BuildContext context){

        return AlertDialog(
          insetPadding: EdgeInsets.all(10),
          title: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image(
              image: AssetImage('assets/images/notif_push.png'),
              fit: BoxFit.cover,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          contentPadding: EdgeInsets.all(3),
          titlePadding: EdgeInsets.all(0),
          content: FutureBuilder(
            future: _getNotificaciones(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {

              if(snapshot.hasData) {
                if(this._notifics.length == 0) {
                  return _sinNotificaciones();
                }else{
                  return _lstNotificaciones();
                }
              }

              return Column(
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
              );
            },
          ),
        );
      }
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
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Divider(height: 0, color: Colors.grey[600]),
        ),
        Text(
          'NOTIFICACIONES',
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 10),
          height: MediaQuery.of(this._context).size.height * 0.4,
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
          title: Text(
            '${this._notifics[index]['titulo']}',
            textScaleFactor: 1,
          ),
          subtitle: Text(
            'Último enviado: ${date['date'].split(' ')[0]}',
            textScaleFactor: 1,
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