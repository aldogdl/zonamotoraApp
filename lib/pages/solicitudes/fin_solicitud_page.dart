import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:zonamotora/entity/pieza_entity.dart';

import 'package:zonamotora/repository/autos_repository.dart';
import 'package:zonamotora/repository/solicitud_repository.dart';
import 'package:zonamotora/repository/user_repository.dart';
import 'package:zonamotora/singletons/buscar_autos_sngt.dart';
import 'package:zonamotora/singletons/solicitud_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';


class FinSolicitudPage extends StatefulWidget {
  @override
  _FinSolicitudPageState createState() => _FinSolicitudPageState();
}

class _FinSolicitudPageState extends State<FinSolicitudPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AutosRepository emAutos = AutosRepository();
  SolicitudSngt solicitudSgtn = SolicitudSngt();
  BuscarAutosSngt buscarAutosSngt = BuscarAutosSngt();
  AlertsVarios alertsVarios = AlertsVarios();
  UserRepository emUser = UserRepository();
  SolicitudRepository emSolicitud = SolicitudRepository();

  Size _screen;
  BuildContext _context;
  bool _showAppBarr = true;
  bool _showError = false;
  int _errorPaso;
  String _username = '';
  String _procesoActual;
  Widget _pasosToDo;
  List<Map<String, dynamic>> _pasos = new List();
  List<Map<String, dynamic>> _data = new List();
  List<Map<String, dynamic>> _fotos = new List();

  @override
  void initState() {
    
    this._pasos.add({'proceso' : 'Recuperando tus Credenciales', 'accion': () => _getDataUser(), 'echo' : false});
    this._pasos.add({'proceso' : 'Organizando Información', 'accion': () => _organizandoInfo(), 'echo' : false});
    this._pasos.add({'proceso' : 'Enviando Datos de Solicitud', 'accion': () => _sendDataSolicitud(), 'echo' : false});
    this._pasos.add({'proceso' : 'Procesando Imagenes', 'accion': () => _enviarImagenes(), 'echo' : false});
    this._pasos.add({'proceso' : 'Limpiando Cache', 'accion': () => _terminarProcesos(), 'echo' : false});

    this._procesoActual = this._pasos[0]['proceso'];
    super.initState();

    _initProceso();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;

    return Scaffold(
      appBar: (this._showAppBarr) ? appBarrMy.getAppBarr(titulo: 'Fin de tu Solicitud') : null,
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: SingleChildScrollView(
          child: _body(),
        ),
      )
    );
  }

  ///
  Widget _body() {

    return Column(
      children: <Widget>[
        SizedBox(
          width: this._screen.width,
          height: this._screen.height * 0.20,
          child: _cabecera(),
        ),
        _proceso()
      ],
    );
  }

  ///
  Future<void> _initProceso({int startIn = 0}) async {

    for (var i = startIn; i < this._pasos.length; i++) {
      setState(() {
        this._procesoActual = this._pasos[i]['proceso'];
      });
      bool result = await this._pasos[i]['accion']();
      if(!result) {
        setState(() {
          this._showError = true;
          this._errorPaso = i;
        });
        break;
      }else{
        this._pasos[i]['echo'] = true;
        this._showError = false;
        this._errorPaso = null;
        _setPasosToDo();
      }
    }
  }

  ///
  void _setPasosToDo() {

    setState(() {
      this._pasosToDo = ListView(
        children: _createPasosToDo(),
      );
    });
  }

  ///
  List<Widget> _createPasosToDo() {

    List<Widget> pasosW = new List();
    this._pasos.forEach((paso){

      if(!paso['echo']) {
        pasosW.add(
          ListTile(
            title: Text(
              paso['proceso'],
              textScaleFactor: 1,
              textAlign: TextAlign.left,
              style: TextStyle(),
            ),
            leading: Icon(Icons.power),
            dense: false,
            contentPadding: EdgeInsets.all(0),
          )
        );
      }
    });

    return pasosW;
  }

  ///
  Widget _proceso() {

    double alto = (this._screen.height <= 550) ? 0.33 : 0.75;
    _setPasosToDo();
    return Container(
      width: this._screen.width * 0.98,
      child: Column(
        children: <Widget>[
          InkWell(
            child: Text('REGRESAR'),
            onTap: (){
              Navigator.of(this._context).pushNamedAndRemoveUntil('lst_modelos_select_page', (Route rutas) => false);
            }
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Procesando tu Solicitud'
              ),
            ),
          ),
          _starts(),
          const SizedBox(height: 10),
          _cajaProceso(),
          Container(
            height: this._screen.height * alto,
            width: this._screen.width,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: this._pasosToDo,
          )
        ],
      ),
    );
  }

  ///
  Widget _cabecera() {

    double toSubTitulo = (this._screen.height <= 550) ? 5 : 15;
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: this._screen.width,
            height: this._screen.height * 0.20,
            decoration: BoxDecoration(
              color: Color(0xff7C0000)
            ),
            child: SizedBox(height: 30),
          ),
        ),
        Positioned(
          top: this._screen.height * 0.01,
          width: this._screen.width,
          child: (this._showAppBarr)
           ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '¡ GRACIAS !\n${ this._username }',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w300
                ),
              ),
              SizedBox(height: toSubTitulo),
              Text(
                'Tu solicitud cuenta con ${solicitudSgtn.autos.length.toString()} Modelo(s)',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 17
                ),
              )
            ],
          )
          : Padding(
            padding: EdgeInsets.only(
              top: 23,
            ),
            child: Text(
              'PIEZAS > ',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w300
              ),
            ),
          ),
        )
      ],
    );
  }

  ///
  Widget _starts() {

    List<Widget> estrellas = new List();
    IconData icono;
    this._pasos.forEach((paso){
      icono = (paso['echo']) ? Icons.star : Icons.star_border;
      estrellas.add(Icon(icono, size: 22, color: Colors.amber[600]));
      estrellas.add(const SizedBox(width: 10));
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: estrellas,
    );
  }

  ///
  Widget _cajaProceso() {

    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: this._screen.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: this._screen.width),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'PROCESO ACTUAL...',
                      textScaleFactor: 1,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      this._procesoActual,
                      textScaleFactor: 1,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.green[800]
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: CircleAvatar(
                  child: Icon(Icons.cloud_upload),
                ),
              )
            ],
          ),
          const SizedBox(height: 7),
          LinearProgressIndicator(),
          (this._showError)
          ? _errorContainer()
          : const SizedBox(height: 0)
        ],
      ),
    );
  }
  
  ///
  Widget _errorContainer() {

    return Container(
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(100),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(7),
          bottomRight: Radius.circular(7)
        )
      ),
      child: Column(
        children: <Widget>[
          Text(
            'OCURRIO UN ERROR',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 18,
              color: Colors.red
            ),
          ),
          Divider(),
          Text(
            'Se detectó un Error inesperado, por favor, intentalo de nuevo.',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
          ),
          FlatButton.icon(
            icon: Icon(Icons.refresh),
            label: Text(
              'RE INTENTAR',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.deepOrange
              ),
            ),
            onPressed: () async {
              int indexPaso = this._errorPaso;
              this._errorPaso = null;
              _initProceso(startIn: indexPaso);
            },
          )
        ],
      ),
    );
  }

  ///
  Future<bool> _getDataUser() async {

    if(this._username.isEmpty) {
      Map<String, dynamic> user = await emUser.getCredentials();
      solicitudSgtn.setUser(user);
    }
    setState(() {
      this._username = solicitudSgtn.user['u_usname'];
    });
    return true;
  }

  ///
  Future<bool> _organizandoInfo() async {

    List<Map<String, dynamic>> autos = new List<Map<String, dynamic>>.from(solicitudSgtn.autos);

    int idAuto = 0;
    autos.forEach((auto){
      idAuto++;
      if(auto['piezas'].length > 0) {
        for (var i = 0; i < auto['piezas'].length; i++) {
          if(auto['piezas'][i].containsKey('fotos')) {
            if(auto['piezas'][i]['fotos'].length > 0){
              Map<String, dynamic> fts = {
                'idAuto' : idAuto,
                'idPieza': auto['piezas'][i]['id'],
                'fotos'  : auto['piezas'][i]['fotos']
              };
              this._fotos.add(fts);
            }
            auto['piezas'][i].remove('fotos');
          }
        }
      }

      auto['id'] = idAuto;
      this._data.add(auto);
    });

    return true;
  }

  ///
  Future<bool> _sendDataSolicitud() async {

    Map<String, dynamic> data = {
      'user'     : solicitudSgtn.getIdUser(),
      'solicitud': this._data,
      'sendMsg'  : (this._fotos.length > 0) ? false : true
    };

    this._data = null;
    bool res = await emSolicitud.enviarDataSolicitud(data);
    if(res){
      solicitudSgtn.filenameInServer = emSolicitud.result['body']['filename'];
      await emSolicitud.setNewCotizacion(emSolicitud.result['body']);
    }else{
      if(emSolicitud.result['msg'] == 'TOKEN EXPIRADO'){
        
        //ToDo:: Refrescar el token del usuario y repetir esta accion
      }
    }
    return res;
  }

  ///
  Future<bool> _enviarImagenes() async {

    PiezaEntity piezaEntity = PiezaEntity();

    ByteData bytes;
    bool res = false;
    
    List<Map<String, dynamic>> dataSend = new List();
    
    if(this._fotos.length > 0) {
      for (var i = 0; i < this._fotos.length; i++) {
        if(this._fotos[i]['fotos'].isNotEmpty){
          for (var f = 0; f < this._fotos[i]['fotos'].length; f++) {
            List<String> nombreFile = this._fotos[i]['fotos'][f]['nombre'].split('.');
            Map<String, dynamic> imagen = this._fotos[i]['fotos'][f];
            Asset foto = piezaEntity.foto.toAsset(imagen);
            bytes = await foto.getThumbByteData(imagen['width'], imagen['height']);
            dataSend.add({
              'idAuto' : this._fotos[i]['idAuto'],
              'idPieza': this._fotos[i]['idPieza'],
              'ext': '${nombreFile[1]}',
              'foto': bytes.buffer.asUint8List()
            });
          }
        }
      }

      Map<String, dynamic> bolsa = {
        'user' : solicitudSgtn.getIdUser(),
        'file' : solicitudSgtn.filenameInServer,
        'fotos': dataSend
      };

      res = await emSolicitud.enviarFotosSolicitud(bolsa);
    }else{
      res = true;
    }
    return res;
  }

  ///
  Future<bool> _terminarProcesos() async {

    solicitudSgtn.limpiarSingleton();

    buscarAutosSngt.setIdMarca(null);
    buscarAutosSngt.setIdModelo(null);
    buscarAutosSngt.setNombreMarca(null);
    buscarAutosSngt.setNombreModelo(null);
    Navigator.of(this._context).pushNamedAndRemoveUntil('grax_por_solicitud_page', (Route rutas) => false);
    return true;
  }

}