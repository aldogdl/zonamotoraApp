import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';

import 'package:zonamotora/repository/autos_repository.dart';
import 'package:zonamotora/repository/mis_autos_repository.dart';
import 'package:zonamotora/singletons/buscar_autos_sngt.dart';
import 'package:zonamotora/singletons/config_gms_sngt.dart';
import 'package:zonamotora/singletons/frm_mk_md_anios_sngt.dart';
import 'package:zonamotora/singletons/solicitud_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/frm_mk_md_anio_widget.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';

class AddAutosPage extends StatefulWidget {
  @override
  AddAutosPageState createState() => AddAutosPageState();
}

class AddAutosPageState extends State<AddAutosPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AutosRepository emAutos = AutosRepository();
  SolicitudSngt solicitudSgtn = SolicitudSngt();
  BuscarAutosSngt buscarAutosSngt = BuscarAutosSngt();
  ConfigGMSSngt configGMSSngt = ConfigGMSSngt();
  FrmMkMdAniosSngt frmSng = FrmMkMdAniosSngt();
  AlertsVarios alertsVarios = AlertsVarios();
  MisAutosRepository emMisAutos = MisAutosRepository();

  String _titleMain = '¿PARA QUÉ CARRO?';
  String _titlePage = 'Cotizador de Refacciones';

  Size _screen;
  BuildContext _context;
  bool _isInit = false;
  String lastUri;
  bool _isEditing = false;
  int _cantAutosSeleccionados = 0;

  ScrollController _scrollCtr = ScrollController();
  GlobalKey<ScaffoldState> _skfKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    
    this._scrollCtr.addListener((){
      if(this._scrollCtr.offset < 28) {
        if(this._titlePage != 'Cotizador de Refacciones'){
          setState(() {
            this._titlePage = 'Cotizador de Refacciones';
            this._titleMain = '¿PARA QUÉ CARRO?';
          });
        }
      }else{
        if(this._titlePage != '¿PARA QUÉ CARRO?'){
          setState(() {
            this._titlePage = '¿PARA QUÉ CARRO?';
            this._titleMain = '';
          });
        }
      }
    });
    
    WidgetsBinding.instance.addPostFrameCallback(_init);
    super.initState();
  }

  ///
  Future<void> _init(_) async {

    configGMSSngt.setContext(this._context);
    frmSng.setContext(this._context);

    int indexAuto = -1;

    if(solicitudSgtn.indexAutoIsEditing > -1) {
      indexAuto = solicitudSgtn.indexAutoIsEditing;
      this._isEditing = true;
    }else{
      if(!solicitudSgtn.addOtroAuto) {
        if(solicitudSgtn.autos.length == 1) {
          solicitudSgtn.indexAutoIsEditing = -1;
          this._isEditing = false;
        }
      }
    }

    if(indexAuto > -1) {

      buscarAutosSngt.setIdMarca(solicitudSgtn.autos[indexAuto]['mk_id']);
      buscarAutosSngt.setIdModelo(solicitudSgtn.autos[indexAuto]['md_id']);
      buscarAutosSngt.setNombreMarca(solicitudSgtn.autos[indexAuto]['mk_nombre']);
      buscarAutosSngt.setNombreModelo(solicitudSgtn.autos[indexAuto]['md_nombre']);
      frmSng.setCtrAnio(int.parse(solicitudSgtn.autos[indexAuto]['anio']));
      frmSng.setCtrVersion((solicitudSgtn.autos[indexAuto]['version'] == '0') ? '' : solicitudSgtn.autos[0]['version']);

      setState(() { });
    }

  }

  @override
  void dispose() {
    this._scrollCtr?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
     this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;
    if(!this._isInit){
      this._isInit = true;
      lastUri = Provider.of<DataShared>(this._context, listen: false).lastPageVisit;
      Provider.of<DataShared>(this._context, listen: false).setLastPageVisit('add_autos_page');
    }
   
    this._cantAutosSeleccionados = solicitudSgtn.autos.length;

    return Scaffold(
      key: this._skfKey,
      appBar: appBarrMy.getAppBarr(titulo: this._titlePage),
      backgroundColor: Colors.white,
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () {
          if(lastUri != null){
            Navigator.of(this._context).pushReplacementNamed(lastUri);
          }
          return Future.value(false);
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0, left: 0,
              child: Container(
                width: this._screen.width,
                height: this._screen.height * 0.40,
                decoration: BoxDecoration(
                  color: Color(0xff002f51)
                ),
                child: SizedBox(height: 30),
              ),
            ),
            Positioned(
              top: 0, left: 0,
              child: _body()
            ),
            Positioned(
              top: this._screen.height * 0.015,
              width: this._screen.width,
              child: Text(
                '${ this._titleMain }',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w300
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          frmSng.resetScreen();
          if(solicitudSgtn.autos.length == 0) {
            solicitudSgtn.addOtroAuto = false;
          }
          Navigator.of(this._context).pushNamedAndRemoveUntil('index_page', (Route rutas) => false);
        },
        child: Icon(Icons.home),
        mini: true,
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  Widget _body() {

    return Container(
      width: this._screen.width,
      height: this._screen.height,
      child: SingleChildScrollView(
        controller: this._scrollCtr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: this._screen.height * 0.1),
            _btnAddDesdeMisAutos(),
            const SizedBox(height: 30),
            FrmMkMdAnioWidget(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              child: _btnAccion(),
            ),
            SizedBox(height: this._screen.height * 0.20),
          ],
        ),
      ),
    );
  }

  ///
  Widget _btnAddDesdeMisAutos() {

     return SizedBox(
      width: this._screen.width * 0.85,
      height: 40,
      child: RaisedButton.icon(
        icon: Icon(Icons.directions_car),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2)
        ),
        color: Color(0xffc2c3c9),
        label: Text(
          'Agregar desde MIS AUTOS aquí',
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () => _verListaDeMisAutos()
      ),
    );
  }

  ///
  Widget _btnAccion() {

    if(this._isEditing) {
      return Column(
        children: <Widget>[
          // _machoteBtnAccion(
          //   titulo: 'AGREGAR otro AUTO',
          //   color: Colors.grey,
          //   icono: Icons.plus_one,
          //   accion: () {
          //     this._isEditing = false;
          //     solicitudSgtn.indexAutoIsEditing = -1;
          //     _agregarOtroAuto(forceAdd: true);
          //   }
          // ),
          // const SizedBox(height: 20),
          _machoteBtnAccion(
            titulo: ' GUARDAR Y REGRESAR ',
            color: Color(0xff002f51),
            icono: Icons.mode_edit,
            icoColor: Colors.blue,
            accion: () async {

              bool isValid = await frmSng.isValid();
              if(isValid){
                await _addAutoToList();
                if(solicitudSgtn.editAutoPage == 'alta_piezas_page') {
                  Navigator.of(this._context).pushReplacementNamed('alta_piezas_page');
                }else{
                  _irListaDeModelos();
                }
              }
            },
            indicador: false,
          ),
          const SizedBox(height: 30),
          _machoteBtnAccion(
            titulo: ' CANCELAR Y REGRESAR ',
            color: Colors.red,
            icono: Icons.play_circle_filled,
            icoColor: Colors.blue,
            accion: () {

              if(solicitudSgtn.editAutoPage == null) {
                if(solicitudSgtn.autos.length == 1) {
                  Navigator.of(this._context).pushReplacementNamed('alta_piezas_page');
                }else{
                  _irListaDeModelos();
                }
              }else{
                if(solicitudSgtn.editAutoPage == 'alta_piezas_page') {
                  Navigator.of(this._context).pushReplacementNamed('alta_piezas_page');
                }else{
                  _irListaDeModelos();
                }
              }
            },
            indicador: false,
          )
        ],
      );
    }

    if(solicitudSgtn.addOtroAuto) {
      return Column(
        children: <Widget>[
          _machoteBtnAccion(
            titulo: 'IR A LA LISTA DE AUTOS',
            color: Color(0xff002f51),
            icono: Icons.clear_all,
            icoColor: Colors.white,
            indicador: false,
            accion: () async {
              bool revisar = await _hasDataInScreen();
              if(revisar){
                _cotizarRefaccion();
              }else{
                _irListaDeModelos();
              }
            }
          )
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _machoteBtnAccion(
          titulo: ' AGREGAR LAS PIEZAS ',
          color: Color(0xff002f51),
          icono: Icons.play_circle_filled,
          icoColor: Colors.blue,
          accion: _cotizarRefaccion,
          indicador: false,
        ),
        const SizedBox(height: 20)
      ],
    );
  }

  ///
  Widget _machoteBtnAccion({
    String titulo,
    Color color,
    IconData icono,
    Color icoColor = Colors.white,
    Function accion,
    indicador = true
  }) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(10),
        width: this._screen.width,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              offset: Offset(2, 2),
              color: Colors.black.withAlpha(30)
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            
            const SizedBox(width: 10),
            Text(
              titulo,
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            Icon(icono, color: icoColor),
            (indicador)
            ?
            CircleAvatar(
              radius: 15,
              child: Text(
                '${ this._cantAutosSeleccionados }',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            )
            :
            const SizedBox(width: 0)
          ],
        ),
      ),
      onTap: () async => accion(),
    );
  }

  ///
  Future<void> _verListaDeMisAutos() async {

    await showDialog(
      context: this._context,
      useSafeArea: true,
      builder: (BuildContext context) {

        return AlertDialog(
          title: Container(
            padding: EdgeInsets.all(5),
            color: Color(0xff002f51),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                  const Icon(Icons.directions_car, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(
                    'Mi Lista de Autos',
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    ),
                  )
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.all(0),
          content: FutureBuilder(
            future: _listMisAutos(),
            builder: (BuildContext context, AsyncSnapshot snapshot){

              if(snapshot.hasData){
                if(snapshot.data.length == 0) {
                  return _verMsgSinAutos();
                }else{
                  return SingleChildScrollView(
                    child: _verLstAutos(snapshot.data),
                  );
                }
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        );
      }
    );
  }

  ///
  Widget _verMsgSinAutos() {

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.blue[50]
            ),
            child: Text(
              'No se encontraron Autos dados de ALTA',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: Colors.red
              ),
            ),
          ),
          SizedBox(
            width: this._screen.width * 0.7,
            child: RaisedButton.icon(
              label: Text(
                'Agregar Autos a Mi Lista',
                textScaleFactor: 1,
              ),
              icon: Icon(Icons.add, color: Colors.white),
              color: Colors.red,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2)
              ),
              onPressed: (){
                Navigator.of(this._context).pop(false);
                Navigator.of(this._context).pushNamed('mis_autos_page', arguments: {'popBack':true});
              },
            ),
          )
        ],
      ),
    );
  }

  ///
  Widget _verLstAutos(List<Map<String, dynamic>> autos) {

    return Container(
      width: MediaQuery.of(this._context).size.width * 0.5,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(1),
        itemCount: autos.length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            title: Text(
              '${autos[index]['mdNombre']} ${autos[index]['anio']}'
            ),
            subtitle: Text(
              autos[index]['mkNombre']
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){

              frmSng.setCtrAnio(autos[index]['anio']);
              frmSng.setCtrVersion(autos[index]['version']);
              buscarAutosSngt.setIdMarca(autos[index]['mkid']);
              buscarAutosSngt.setNombreMarca(autos[index]['mkNombre']);
              buscarAutosSngt.setIdModelo(autos[index]['mdid']);
              buscarAutosSngt.setNombreModelo(autos[index]['mdNombre']);
              Navigator.of(context).pop(false);
              setState(() {});

            },
          );
        },
      ),
    );
  }

  ///
  Future<List<Map<String, dynamic>>> _listMisAutos() async {

    List<Map<String, dynamic>> misAutos = await emMisAutos.getMisAutos();
    return misAutos;
  }

  ///
  void _cotizarRefaccion() async {

    bool save = false;

    if(solicitudSgtn.autos.length > 1) {
      if(buscarAutosSngt.idMarca != null && buscarAutosSngt.idModelo != null) {
        save = true;
      }else{
        solicitudSgtn.indexAutoIsEditing = -1;
        this._isEditing = false;
        _irListaDeModelos();
      }
    }else{
      save = true;
    }

    bool isValid = false;
    if(save) {
    
      bool revisar = true;
      if(solicitudSgtn.autos.length >= 1) {
        isValid = await _hidratarScreenConElAutoUnico();
        if(isValid){
          // Revisar si hay datos en el screen;
          revisar = await _hasDataInScreen();
        }else{
          revisar = false;
        }
      }

      if(revisar){
        isValid =  await frmSng.isValid();
        if(isValid){
          await _addAutoToList();
        }
      }
    }

    if(save && isValid) {

      frmSng.resetScreen();
      if(solicitudSgtn.autos.length > 1) {
        _irListaDeModelos();
      }else{
        solicitudSgtn.setAutoEnJuegoIndexAuto(0);
        Navigator.of(this._context).pushReplacementNamed('alta_piezas_page');
      }
    }

  }

  ///
  Future<bool> _hasDataInScreen() async {

    if(buscarAutosSngt.idMarca != null) {
      return true;
    }
    if(buscarAutosSngt.idModelo != null) {
      return true;
    }
    if(frmSng.ctrAnio.text != '') {
      return true;
    }
    return false;
  }

  ///
  Future<bool> _hidratarScreenConElAutoUnico() async {

    List<Map<String, dynamic>> isValid = await  solicitudSgtn.isValidContentOfAutos();
    if(isValid.length > 0){
      await alertsVarios.entendido(this._context, titulo: isValid[0]['titulo'], body: isValid[0]['stitulo']);
    }
    return (isValid.length > 0) ? false : true;
  }

  ///
  void _irListaDeModelos() {

    solicitudSgtn.indexAutoIsEditing = -1;
    this._isEditing = false;
    solicitudSgtn.addOtroAuto = false;
    solicitudSgtn.setAutoEnJuegoIndexAuto(null);
    solicitudSgtn.setAutoEnJuegoIndexPieza(null);
    solicitudSgtn.setAutoEnJuegoIdPieza(null);
    Navigator.of(this._context).pushNamedAndRemoveUntil('lst_modelos_select_page', (Route rutas) => false);
  }

  ///
  Future<void> _addAutoToList({bool forceAdd = false}) async {

    Map<String, dynamic> auto = {
      'mk_id'     : buscarAutosSngt.idMarca,
      'mk_nombre' : buscarAutosSngt.nombreMarca,
      'md_id'     : buscarAutosSngt.idModelo,
      'md_nombre' : buscarAutosSngt.nombreModelo,
      'anio'      : frmSng.ctrAnio.text,
      'version'   : (frmSng.ctrVersion.text.isEmpty) ? '0' : frmSng.ctrVersion.text,
      'piezas'    : new List<Map<String, dynamic>>(),
    };

    if(forceAdd){
      solicitudSgtn.setAutoSeleccionado(auto);
    }else{
      if(this._isEditing) {
        await solicitudSgtn.editarAuto(auto);
      }else{
        solicitudSgtn.setAutoSeleccionado(auto);
      }
    }
    this._isEditing = false;
    solicitudSgtn.indexAutoIsEditing = -1;
  }

}