import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/config_gms_sngt.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';

class PrbaPush extends StatefulWidget {
  PrbaPush({Key key}) : super(key: key);

  @override
  _PrbaPushState createState() => _PrbaPushState();
}

class _PrbaPushState extends State<PrbaPush> {

  UserRepository emUser = UserRepository();
  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  ConfigGMSSngt configGMSSngt = ConfigGMSSngt();

  BuildContext _context;

  bool _isInit = false;
  bool _send = false;
  bool _hidePass = true;
  bool _resp = false;

  String _msgErrComunik;
  IconData _iconVerPass = Icons.remove_red_eye;
  TextEditingController _ctrPassPush = TextEditingController();

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    
    if(!this._isInit){
      this._isInit = true;
      configGMSSngt.setContext(this._context);
    }

    return Scaffold(
      appBar: appBarrMy.getAppBarr(),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: _body(),
      ),
    );
  }

  ///
  Widget _body() {

    return ListView(
      children: <Widget>[
        (!this._resp)
        ?
        _introAndPass()
        :
        SizedBox(height: 0),
        SizedBox(height: 10),
        (this._send && !this._resp)
        ?
        Center(
          child: SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(),
          ),
        )
        :
        SizedBox(height: 0),
        (this._send && this._resp)
        ?
          _msgResp()
        :
        SizedBox(height: 0),
        (!this._resp)
        ?
        SizedBox(height: 0)
        :
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withAlpha(50)
          ),
          child: _msgDeRespuesta(),
        ),
        SizedBox(height: 20),
      ],
    );
  }
  
  ///
  Widget _introAndPass() {

    return Column(
      children: <Widget>[
        Text(
          'Para realizar una comunicación vilateral es necesario que ingreses tu contraseña para corroborar tu identidad.',
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 20
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: this._ctrPassPush,
          obscureText: this._hidePass,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (String val) async => _autenticar(),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(this._iconVerPass),
              onPressed: () {
                if(_iconVerPass.codePoint == 58945){
                  this._iconVerPass = Icons.remove_red_eye;
                  this._hidePass = true;
                }else{
                  this._iconVerPass = Icons.no_encryption;
                  this._hidePass = false;
                }
                setState(() {
                });
              },
            ),
            hintText: 'Tu Contraseña',
            hintStyle: TextStyle(
              color: Colors.grey
            ),
            errorText: this._msgErrComunik
          ),
        ),
        SizedBox(height: 10),
        (!this._send)
        ?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
              onPressed: () async => Navigator.of(this._context).pushReplacementNamed('config_page'),
              child: Text(
                'CANCELAR',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              color: Colors.red,
            ),
            RaisedButton(
              onPressed: () async => _autenticar(),
              child: Text(
                'AUTENTICAR',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              color: Colors.green,
            )
          ],
        )
        
        :
        SizedBox(height: 20),
        Icon(Icons.notification_important, size: 150, color: Colors.grey[400]),
      ],
    );
  }
  
  /// Visualizamos este mesaje cuando 
  Widget _msgDeRespuesta() {

    return Column(
      children: <Widget>[

        Consumer<DataShared>(
          builder: (_, dataShared, __) {

            if(dataShared.prbaPush.isNotEmpty){
              return Text(
                dataShared.prbaPush['body'],
                textScaleFactor: 1,
              );
            }

            return Text(
              'En Espera...',
              textScaleFactor: 1,
            );
          },
        ),
        SizedBox(height: 10),
        Text(
          'Si no recibes ningún sonido de notificación, por favor...',
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Es importante que te pongas en contacto con nuestro soporte técnico para que no te pierdas de ninguna oportunidad.',
          textScaleFactor: 1,
        ),
        SizedBox(height: 10),
        RaisedButton(
          onPressed: () => Navigator.of(this._context).pushNamedAndRemoveUntil('index_page', (route) => false),
          child: Text(
            'IR AL INICIO',
            style: TextStyle(
              color: Colors.blue
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          color: Colors.black,
        )
      ],
    );
  }

  /// Visualizamos este mensaje en el momento que el servidor nos retorna una
  /// afirmación de que el mensaje fué enviado al Cpanel.
  Widget _msgResp() {

    return Container(
      child: Column(
        children: <Widget>[
          Icon(Icons.notifications_active, size: 150, color: Colors.green),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '¡La comunicación se realizó con Éxito!',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.orange
              ),
            ),
          ),
          Text(
            'Espera un momento para que tu dispositivo realice un sonido de notificación de respuesta',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black
            ),
          ),
        ],
      ),
    );
  }
  
  ///
  Future<void> _autenticar() async {

    FocusScope.of(this._context).requestFocus(new FocusNode());
    Map<String, dynamic> result = await emUser.autenticacionLocal(this._ctrPassPush.text);
    if(!result['autorizado']){
      this._msgErrComunik = 'Tus credenciales no son correctas';
    }else{
      Provider.of<DataShared>(this._context, listen: false).setPrbaPush(new Map());
      this._msgErrComunik = 'PERFECTO!!, espera un momento por favor.';
      this._send = true;
      _hacerPruebaDeComunicacionPush(result['dataUser']);
      result = null;
    }
    setState(() { });
  }

  ///
  Future<void> _hacerPruebaDeComunicacionPush(Map<String, dynamic> dataUser) async {

    Map<String, dynamic> result = await emUser.hacerPruebaDeComunicacionPush(dataUser);
    if(result['error']){
      this._msgErrComunik = 'No se realizó la comunicación Inicial.';
    }else{
      this._resp = true;
    }
    setState(() { });
  }

}