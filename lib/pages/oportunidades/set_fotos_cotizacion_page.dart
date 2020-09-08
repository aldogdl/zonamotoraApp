import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:zonamotora/pages/oportunidades/widgets/motivos_widget.dart';

import 'package:zonamotora/repository/procc_roto_repository.dart';
import 'package:zonamotora/repository/solicitud_repository.dart';
import 'package:zonamotora/singletons/cotizacion_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/globals.dart' as globals;

class SetfotosToCotizacionPage extends StatefulWidget {
  SetfotosToCotizacionPage({Key key}) : super(key: key);

  @override
  _SetfotosToCotizacionPageState createState() => _SetfotosToCotizacionPageState();
}

class _SetfotosToCotizacionPageState extends State<SetfotosToCotizacionPage> {

  CotizacionSngt sgtnCot = CotizacionSngt();
  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  SolicitudRepository emSoli = SolicitudRepository();
  AlertsVarios alertsVarios = AlertsVarios();
  ProccRotoRepository emProcRoto = ProccRotoRepository();


  bool _hasSelected = false;
  bool _isInit = false;
  bool _proccRotoSaved = false;
  bool _cotizaSaved = false;
  BuildContext _context;
  int _takeMaxFotos = 4;
  String _errorLoadFotos = 'Actualmente 0 de 4 fotos permitidas.';
  String _msgFotosTime   = 'Tomarte el tiempo de Agregar fotos a tu Cotización';
  Color _colorBtnMotivos = Colors.blue;
  IconData _icoBtnMotivos = Icons.wifi;
  List<String> _tamsFin = ['Foto 1', 'Foto 2', 'Foto 3', 'Foto 4'];

  double _anchoScreen;
  final double _altoFoto = 50;
  List<Widget> _widgetImages = new List();
  List<Asset> _resultList = new List();

  GlobalKey<ScaffoldState> _keySkf = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {

    this._context = context;
    this._anchoScreen = MediaQuery.of(this._context).size.width;

    if(!this._isInit) {
      this._isInit = true;
      if(!sgtnCot.isRecovery){
        _makeBackupProceso();
        _saveCotizacionData();
      }else{
        if(sgtnCot.idCotizacion == 0) {
          _saveCotizacionData();
        }
      }
    }

    return Scaffold(
      key: this._keySkf,
      appBar: appBarrMy.getAppBarr(titulo: 'Pedido ID: ${sgtnCot.dataPiezaEnProceso['pedido']}'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Container(
              height: MediaQuery.of(this._context).size.height * 0.25,
              width: MediaQuery.of(this._context).size.width,
              child: Image(
                image: AssetImage('assets/images/img_sale_more.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: MediaQuery.of(this._context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black
              ),
              child: Text(
                'UNA IMAGEN VENDE MÁS QUE MIL PALABRAS',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(7),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(80),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: <Widget>[
                  RaisedButton.icon(
                    icon: Icon(this._icoBtnMotivos, color: Colors.white),
                    onPressed: () => _verMotivos(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: this._colorBtnMotivos,
                    label: Text(
                      'VER MOTIVOS DEL POR QUÉ...',
                      textScaleFactor: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                  Text(
                    '${this._msgFotosTime}',
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: (sgtnCot.isRecovery) ? _printFotosRecovery() : _listaFotos(),
            ),
            const SizedBox(height: 10),
            Text(
              '${this._errorLoadFotos}',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green[900]
              ),
            ),
            const SizedBox(height: 10),
            RaisedButton.icon(
              icon: Icon(Icons.save, color: Colors.blue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              onPressed: (){
                _saveFotosDeLaCotizacion();
              },
              color: Colors.black,
              label: Text(
                'TERMINAR LA COTIZACIÓN',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: _instrucciones(),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  Widget _listaFotos() {

    if(this._widgetImages.length == 0){
      for (var i = 0; i < 4; i++) {
        this._widgetImages.add(_containerFoto(i, Image(image: AssetImage('assets/images/no-image.png'))));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: this._widgetImages
    );
  }

  ///
  Widget _containerFoto(int index, Widget laFoto) {

    return Column(
      children: <Widget>[
        Text(
          '${this._tamsFin[index]}',
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600]
          ),
        ),
        InkWell(
          onTap: () {
            this._takeMaxFotos = 4;
            _loadAssets();
          },
          onLongPress: (){
            this._takeMaxFotos = 1;
            _loadAssets(index: index);
          },
          child: Container(
            width: (this._anchoScreen / 4) - 15,
            height: this._altoFoto,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(80),
              borderRadius: BorderRadius.circular(10)
            ),
            child: laFoto,
          ),
        )
      ],
    );
  }

  ///
  Widget _instrucciones() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(),
        Text(
          'INSTRUCCIONES',
          textScaleFactor: 1,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.red
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'SELECCIONAR TODAS LAS FOTOS',
          textScaleFactor: 1,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold
          ),
        ),
        Text(
          'Presiona cualquiera de los espacios de las fotos y podrás seleccionar hasta 4 imágenes a la vez.',
          textScaleFactor: 1,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'CAMBIAR UNA DE LAS FOTOS',
          textScaleFactor: 1,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold
          ),
        ),
        Text(
          'Deja presionada la fotografía que deseas cambiar y se sustituirá dicha imagen.',
          textScaleFactor: 1,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14
          ),
        ),
      ],
    );
  }

  ///
  Future<void> _loadAssets({int index = -1}) async {

    if(!this._proccRotoSaved) {
      await _makeBackupProceso();
    }

    if(this._hasSelected && this._takeMaxFotos ==  4){
      String body = 'Ya tienes fotografías seleccionadas, esta acción ' +
      'sustituirá todas, si deceas cambiar una de ellas, deja presionada ' +
      'la foto requerida y se cambiará solo la seleccionada.\n\n¿Aun así deseas continuar?';

      bool res = await alertsVarios.aceptarCancelar(this._context, titulo: 'SELECCION DE FOTOS', body: body);
      if(!res){ return false; }
      this._tamsFin = ['Foto 1', 'Foto 2', 'Foto 3', 'Foto 4'];
    }

    List<Asset> fotosSelect = new List();
    
    try {
      fotosSelect = await MultiImagePicker.pickImages(
        maxImages: this._takeMaxFotos,
        enableCamera: true,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: MaterialOptions(
          actionBarTitle: "INSENTIVA LA VENTA",
          allViewTitle:   "Todas las Fotos",
          selectionLimitReachedText: 'Haz llegado al limite',
          textOnNothingSelected: 'No se ha seleccionado nada',
          lightStatusBar: false,
          useDetailsView: false,
          startInAllView: (this._takeMaxFotos == 4) ? false : true,
          actionBarColor: "#7C0000",
          statusBarColor: "#7C0000",
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      this._errorLoadFotos = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if(fotosSelect.isNotEmpty){

      // _takeMaxFotos = 4 es para saber si el usuario presiono el contenedor de imagen como:
      // onTap o si es = 1 es que hizo un onLongerTap
      if(this._takeMaxFotos == 4) {
        this._resultList = fotosSelect;
        fotosSelect = null;
        await _visualizarMultiplesFotos();
      }else{
        await _visualizarFotoIndividual(index, fotosSelect.first);
      }
      await _makeBackupProceso();
      this._errorLoadFotos = 'Actualmente ${this._resultList.length} de 4 fotos permitidas';
      setState(() {});
    }
  }

  ///
  Future<void> _makeBackupProceso() async {

    List<Map<String, dynamic>> fotos = new List();
    if(this._resultList.length > 0){
      for (var i = 0; i < this._resultList.length; i++) {
        fotos.add({
          'identifier': this._resultList[i].identifier,
          'name'  : this._resultList[i].name,
          'width' : this._resultList[i].originalWidth,
          'height': this._resultList[i].originalHeight,
        });
      }
    }

    Map<String, dynamic> data = {
      'idCotizacion' : sgtnCot.idCotizacion,
      'dataPiezaEnProceso' : sgtnCot.dataPiezaEnProceso,
      'piezaEnProceso' : sgtnCot.piezaEnProceso,
      'fotos': fotos
    };
    Map<String, dynamic> metadata = {
      'solicitud': sgtnCot.dataPiezaEnProceso['solicitud'],
      'pedido': sgtnCot.dataPiezaEnProceso['pedido']
    };
    this._proccRotoSaved = await emProcRoto.makeBackupFotosByCotizacion(metadata: metadata, contents: data);
  }

  ///
  Future<void> _visualizarMultiplesFotos() async {

    this._widgetImages = new List();

    for (var i = 0; i < this._resultList.length; i++) {

      Map<String, double> tams = await emSoli.getProporcionesPara(
        globals.tamMaxFotoPzas,
        this._resultList[i].originalWidth,
        this._resultList[i].originalHeight,
        isLandscape: this._resultList[i].isLandscape
      );
      this._widgetImages.add(
        _containerFoto(
          i,
          AssetThumb(
            asset: this._resultList[i],
            width: tams['ancho'].toInt(),
            height:tams['alto'].toInt()
          )
        )
      );

      this._tamsFin[i] = '${tams['ancho'].toInt()} - ${tams['alto'].toInt()}';
    }

    if(this._widgetImages.length < 4){
      int faltan = 4 - this._resultList.length;

      for (var i = 0; i < faltan; i++) {
        this._widgetImages.add(
          _containerFoto(
            (i + this._resultList.length),
            Image(image: AssetImage('assets/images/no-image.png'))
          )
        );
      }
    }

    this._hasSelected = true;
    setState(() {});
  }

  ///
  Future<void> _visualizarFotoIndividual(int indexFoto, Asset fotosSelect) async {

    double alto = this._altoFoto;
    double ancho = (this._anchoScreen / 4) - 15;
    Map<String, double> tams;
    List<Widget> newLstCopy = new List<Widget>.from(this._widgetImages);
    this._widgetImages = new List();

    for (var i = 0; i < newLstCopy.length; i++) {
      if(i == indexFoto) {
        try {
          this._resultList[indexFoto] = fotosSelect;
        } catch (e) {
          this._resultList.add(fotosSelect);
        }

        tams = await emSoli.getProporcionesPara(
          globals.tamMaxFotoPzas,
          fotosSelect.originalWidth,
          fotosSelect.originalHeight,
          isLandscape: fotosSelect.isLandscape
        );
        ancho = tams['ancho'];
        alto  = tams['alto'];
        
        setState(() {
          this._tamsFin[indexFoto] = '${tams['ancho'].toInt()} - ${tams['alto'].toInt()}';
        });
        this._widgetImages.add(
          _containerFoto(i, AssetThumb(asset: fotosSelect, width: ancho.toInt(), height: alto.toInt()))
        );

      }else{
        this._widgetImages.add(newLstCopy[i]);
      }
    }
    tams = null;
    newLstCopy = null;
  }

  ///
  Future<void> _saveCotizacionData() async {

    if(!this._cotizaSaved){

      if(sgtnCot.dataPiezaEnProceso.containsKey('costo')){
        bool result = await emSoli.setCotizacion(sgtnCot.dataPiezaEnProceso);
        if(!result){
          this._cotizaSaved = false;
          this._errorLoadFotos = emSoli.result['body'];
        }else{
          if(!emSoli.result['abort']){
            this._cotizaSaved = true;
            sgtnCot.idCotizacion = emSoli.result['body'];
            this._icoBtnMotivos = Icons.check_circle;
            this._colorBtnMotivos = Colors.red;
            this._msgFotosTime = 'Tomarte el tiempo de Agregar fotos a tu Cotización.';
          }else{
            this._cotizaSaved = false;
            this._errorLoadFotos = emSoli.result['body'];
          }
        }
        setState(() { });
      }
    }
  }

  ///
  Future<void> _saveFotosDeLaCotizacion() async {

    bool hacer = false;

    if(sgtnCot.idCotizacion == 0) {
      // Alertar que todavia no se guarda la data de la cotizacion,
      String body = 'Hubo un error al guardar los datos de la cotización.\n\nAntes de continuar, ' +
      'necesitamos intentar guardar los datos nuevamente';
      await alertsVarios.entendido(this._context, titulo: 'TERMINAR COTIZACIÓN', body: body);
      this._colorBtnMotivos = Colors.blue;
      this._icoBtnMotivos = Icons.wifi;
      this._msgFotosTime = 'Guardando Datos, espere por favor.';
      this._cotizaSaved = false;
      setState(() { });

      await _saveCotizacionData();
      if(this._cotizaSaved){
        hacer = true;
      }
      if(sgtnCot.idCotizacion != 0){
        hacer = true;
      }
    }else{
      hacer = true;
    }

    if(hacer) {

      if(this._resultList.length == 0) {
        String body = 'Estas apunto de terminar la cotización sin ningúna fotografía que apoye tu VENTA, estás segur@ de ello?';
        bool res = await alertsVarios.aceptarCancelar(this._context, titulo: 'TERMINAR COTIZACIÓN', body: body);
        if(!res){ return false; }
      }
      await emProcRoto.deleteProcesosRotosByFotosCotizacion();

      if(this._resultList != null) {
        sgtnCot.fotos = new List();
        for (var i = 0; i < this._resultList.length; i++) {
          sgtnCot.fotos.add({'data' : this._resultList[i], 'nombreFoto' : '', 'ext' : ''});
        }
      }
      this._resultList = null;
      if(sgtnCot.fotos.length > 0) {
        Navigator.of(this._context).pushNamedAndRemoveUntil('send_fotos_cotizacion', (route) => false);
      }else{
        Navigator.of(this._context).pushNamedAndRemoveUntil('fin_msg_cotizacion', (route) => false);
      }
    }
  }

  ///
  void _verMotivos() {

    this._keySkf.currentState.showBottomSheet(
      (_context) => MotivosWidget()
    );
  }

  ///
  Future<void> _printFotosRecovery() async {

    if(sgtnCot.fotos.length > 0) {
      for (var i = 0; i < sgtnCot.fotos.length; i++) {
        this._resultList.add(
          Asset(
            sgtnCot.fotos[i]['identifier'],
            sgtnCot.fotos[i]['name'],
            sgtnCot.fotos[i]['width'],
            sgtnCot.fotos[i]['height'],
          )
        );
      }
    }
    sgtnCot.fotos = new List();
    sgtnCot.isRecovery = false;
    await _visualizarMultiplesFotos();

    this._errorLoadFotos = 'Actualmente ${this._resultList.length} de 4 fotos permitidas';
  }

}