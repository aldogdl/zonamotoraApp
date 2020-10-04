import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/procc_roto_repository.dart';

import 'package:zonamotora/singletons/buscar_autos_sngt.dart';
import 'package:zonamotora/singletons/config_gms_sngt.dart';
import 'package:zonamotora/singletons/solicitud_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';


class AltaPiezasPage extends StatefulWidget {

  @override
  _AltaPiezasPageState createState() => _AltaPiezasPageState();
}

class _AltaPiezasPageState extends State<AltaPiezasPage> {

  SolicitudSngt solicitudSgtn = SolicitudSngt();
  BuscarAutosSngt buscarAutosSngt = BuscarAutosSngt();
  AlertsVarios alertsVarios = AlertsVarios();
  MenuInferior menuInferior = MenuInferior();
  ConfigGMSSngt configGMSSngt = ConfigGMSSngt();
  AppBarrMy appBarrMy = AppBarrMy();
  ProccRotoRepository emRoto = ProccRotoRepository();


  SwiperController _swipCtrl = SwiperController();
  ScrollController _ctrScroll= ScrollController();
  GlobalKey<ScaffoldState> _skfKey = GlobalKey<ScaffoldState>(); 

  GlobalKey<FormState> _frmKey = GlobalKey<FormState>(); 
  TextEditingController _ctrCant = TextEditingController();
  TextEditingController _ctrPieza = TextEditingController();
  TextEditingController _ctrDeta = TextEditingController();
  FocusNode _focusCant  = FocusNode();
  FocusNode _focusPieza = FocusNode();
  FocusNode _focusDeta  = FocusNode();
  String _ladoSeleccionado = 'DELANTER@';
  String _posSeleccionada = 'SIN POSICIÓN';
  
  bool _hasFotos = false;
  bool _hasData  = false;
  bool _isRecovery  = false;
  bool _isInit = true;
  bool _showHead = true;
  bool _isShowHeadforce = false;

  String lastUri;
  Map<String, dynamic> _infoZM;
  int _cantPiezaSaved = 0;
  int _idPiezaInScreen = -1;
  List<Asset> _images = List<Asset>();
  String _error;

  double _altoHead;
  double _altoBody;

  BuildContext _context;
  Color _errorFrmTxtDetalles = Colors.red[200];
  Color _errorFrmBgDetalles;
  Color _errorFrmTxtPieza = Colors.red[200];
  Color _errorFrmBgPieza;
  Color _errorFrmTxtCant = Colors.red[200];
  Color _errorFrmBgCant;
  double _scrollOffset = 0.0;

  @override
  void dispose() {
    this._swipCtrl?.dispose();
    this._ctrCant?.dispose();
    this._ctrPieza?.dispose();
    this._ctrDeta?.dispose();
    this._ctrScroll?.dispose();
    super.dispose();
  }

  @override
  void initState() {

    _calculaCantPiezas();
    if(solicitudSgtn.isRecovery) {
      solicitudSgtn.setIsRecovery(false);
      this._isRecovery = true;
    }
    this._ctrCant.text = '1';

    WidgetsBinding.instance.addPostFrameCallback(_getDataActuales);
    this._ctrScroll.addListener(() {

      if(this._ctrScroll.offset >= 199) {

        if(!this._isShowHeadforce){
          setState(() {
            this._showHead = false;
          });
        }
      }else{
        if(!this._isShowHeadforce){
          setState(() {
            this._showHead = true;
          });
        }
      }
    });

    super.initState();
    
  }

  ///
  void _getDataActuales(_) async {

    if(solicitudSgtn.autos.length > 0){
      // Si tengo autos
      if(solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'].length > 0){
        // Si tengo piezas
        if(solicitudSgtn.autoEnJuego['indexPieza'] != null && solicitudSgtn.autoEnJuego['idPieza'] != null) {
          // Quiero editar
          Map<String, dynamic> pieza = solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'][solicitudSgtn.autoEnJuego['indexPieza']];
          if(pieza['id'] == solicitudSgtn.autoEnJuego['idPieza']){
            this._ctrCant.text    = pieza['cant'];
            this._ctrPieza.text   = pieza['nombre'];
            this._ctrDeta.text    = (pieza['detalles'] == '0') ? null : pieza['detalles'];
            this._ladoSeleccionado= pieza['lado'];
            this._posSeleccionada = pieza['posicion'];
            this._images          = solicitudSgtn.recoveryFotos();
            if(this._images.length > 0) {
              this._hasFotos = true;
            }
          }
          setState(() {});
        }
        // quiero Agregar nueva pieza
      }
    }else{
      Navigator.of(this._context).pop(false);
    }
    configGMSSngt.setContext(this._context);
    this._scrollOffset = (MediaQuery.of(this._context).size.height <= 550) ? 440 : 420;
    if(this._isRecovery) {
      this._isRecovery = false;
      await _showDialogDeRecovery();
    }
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    if(!this._isInit){
      this._isInit = true;
      lastUri = Provider.of<DataShared>(this._context, listen: false).lastPageVisit;
      Provider.of<DataShared>(this._context, listen: false).setLastPageVisit('alta_piezas_page');
      this._infoZM = Provider.of<DataShared>(context, listen: false).infoZM;
    }
    this._altoHead = (MediaQuery.of(this._context).size.height <= 550) ? 0.26 : 0.22;
    if(this._showHead){
      this._altoBody = (MediaQuery.of(this._context).size.height <= 550) ? 0.47 : 0.57;
    }else{
      this._altoBody = (MediaQuery.of(this._context).size.height <= 550) ? 0.73 : 0.79;
    }

    String titulo = solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['md_nombre'];

    return Scaffold(
      key: this._skfKey,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        elevation: 0,
        title: Text(
          'Piezas para $titulo',
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 13
          ),
        ),
        backgroundColor: Color(0xff002f51),
        actions: [
          IconButton(
            icon: Icon((this._showHead) ? Icons.clear : Icons.file_download),
            onPressed: (){
              setState(() {
                this._showHead = (!this._showHead) ? true : false;
                this._isShowHeadforce = (this._showHead) ? true : false;
              });
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: (){
          if(lastUri != null){
            Navigator.of(this._context).pushReplacementNamed(lastUri);
          }
          return Future.value(false);
        },
        child: ListView(
          children: [
            (this._showHead)
            ?
            Container(
              width: MediaQuery.of(this._context).size.width,
              height: MediaQuery.of(this._context).size.height * this._altoHead,
              decoration: BoxDecoration(
                color: Color(0xff002f51)
              ),
              child: _cabeceraFix(),
            )
            :
            const SizedBox(height: 0),
            Container(
              width: MediaQuery.of(this._context).size.width,
              height: MediaQuery.of(this._context).size.height * this._altoBody,
              child: _body(),
            )
          ],
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  void _calculaCantPiezas() {

    if(solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']].containsKey('piezas')) {
      this._cantPiezaSaved = (solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'].length > 0)
      ? solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'].length
      : 0;
    }
  }

  ///
  Widget _cabeceraFix() {

    return Column(
      children: [
        _btnCambiarAutoOnly(),
        InkWell(
          onTap: () {
            _resetScreen();
            solicitudSgtn.indexAutoIsEditing = -1;
            Navigator.of(this._context).pushNamedAndRemoveUntil('lst_piezas_page', (Route rutas) => false);
          },
          child: _cantPiezasBtnAyuda(),
        ),
      ],
    );
  }

  ///
  Widget _body() {

    return SingleChildScrollView(
      controller: this._ctrScroll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: _showBtnCancelar(),
          ),
          _form(),
          const SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child:  Column(
              children: <Widget>[
                Text(
                  '¿Qué deseas hacer?',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w300,
                    fontSize: 20
                  ),
                ),
                Divider(
                  color: Colors.grey[400],
                ),
                (this._cantPiezaSaved > 0) ? _btnsAccionConPiezas() : _btnsAccionSinPiezas()
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
  
  ///
  Widget _showBtnCancelar() {

    return (this._cantPiezaSaved > 0)
    ?
    _machoteBtnAccion(
      titulo: 'NO DESEO AGREGAR MÁS',
      icono: Icons.arrow_forward,
      icoColor: Colors.white,
      color: Colors.red,
      indicador: false,
      accion: () {
        _resetScreen();
        solicitudSgtn.indexAutoIsEditing = -1;
        Navigator.of(this._context).pushNamedAndRemoveUntil('lst_piezas_page', (Route rutas) => false);
      }
    )
    :
    const SizedBox(height: 0);
  }

  ///
  Widget _btnCambiarAutoOnly() {

    return Padding(
      padding: EdgeInsets.only(
        top: 0, right: 20, bottom: 20, left: 20
      ),
      child: SizedBox(
        width: MediaQuery.of(this._context).size.width,
        child: _btnCambiarAuto(),
      ),
    );
  }
  
  ///
  Widget _btnCambiarAuto() {

    return _machoteBtnAccion(
      titulo: 'Cambiar el Automóvil Aquí',
      color: Colors.red,
      icono: Icons.directions_car,
      icoColor: Colors.white,
      indicador: false,
      accion: (){

        if(solicitudSgtn.autos.length > 1) {
          Navigator.of(this._context).pushNamedAndRemoveUntil('lst_modelos_select_page', (Route rutas) => false);
        }else{
          solicitudSgtn.indexAutoIsEditing = solicitudSgtn.autoEnJuego['indexAuto'];
          solicitudSgtn.editAutoPage = 'alta_piezas_page';

          buscarAutosSngt.setIdMarca(solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['mk_id']);
          buscarAutosSngt.setIdModelo(solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['md_id']);
          buscarAutosSngt.setNombreMarca(solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['mk_nombre']);
          buscarAutosSngt.setNombreModelo(solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['md_nombre']);
          Navigator.of(this._context).pushNamedAndRemoveUntil('add_autos_page', (Route rutas) => false);
        }
      }
    );
  }
  
  ///
  Widget _cantPiezasBtnAyuda() {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.orange,
            maxRadius: 15,
            child: Text(
              '${ this._cantPiezaSaved }',
              textScaleFactor: 1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                ' PIEZA${ this._cantPiezaSaved > 1 ? "S" : (this._cantPiezaSaved == 0) ? "S" : "" }',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.red[100],
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 3),
              Text(
                ' AÑADIDA${ this._cantPiezaSaved > 1 ? "S" : (this._cantPiezaSaved == 0) ? "S" : "" }',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.red[100],
                  fontSize: 10,
                  letterSpacing: 0.8
                ),
              ),
            ],
          ),
          Expanded(
            flex: 1,
            child: SizedBox(width: 10),
          ),
          RaisedButton.icon(
            onPressed: () {
              this._skfKey.currentState.showBottomSheet(
                (BuildContext context) => _verAyuda(),
                elevation: 5
              );
            },
            color: Colors.red[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            icon: Icon(Icons.headset_mic),
            label: Text(
              'Pedir Asistencia',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget _form() {

    Widget child = Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: _inputCantidad(),
        ),
        const SizedBox(width: 5),
        Expanded(
          flex: 4,
          child: _inputNombrePieza(),
        )
      ],
    );

    TextStyle styloLabels = TextStyle(
      color: Colors.black45,
      fontSize: 15
    );

    return Form(
      key: this._frmKey,
      child: Container(
        width: MediaQuery.of(this._context).size.width,
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Align(
              widthFactor: MediaQuery.of(this._context).size.width,
              alignment: Alignment.center,
              child: Text(
                '¿Qué Refacción necesitas?',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black
                ),
              ),
            ),
            Divider(color: Colors.red[200]),
            const SizedBox(height: 30),

            Text(
              '* ¿De qué LADO es la pieza?:',
              textScaleFactor: 1,
              textAlign: TextAlign.start,
              style: styloLabels,
            ),
            const SizedBox(height: 7),

            _selectLados(),
            const SizedBox(height: 35),

            Text(
              '* ¿Tiene alguna Posición adicional?',
              textScaleFactor: 1,
              textAlign: TextAlign.start,
              style: styloLabels,
            ),
            const SizedBox(height: 7),
            _selectPosicion(),
            const SizedBox(height: 35),

            _machoteRoundedInput(child: child),
            const SizedBox(height: 35),

            _inputDetalles(),
            const SizedBox(height: 15),
            Container(
              padding: (this._hasFotos) ? EdgeInsets.all(10) : EdgeInsets.all(0),
              width: MediaQuery.of(this._context).size.width,
              height: MediaQuery.of(this._context).size.height * 0.24,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10)
              ),
              child: (this._hasFotos)
              ?
              showFotos()
              :
              Center(
                child: SizedBox(
                  height: MediaQuery.of(this._context).size.height * 0.21,
                  child: InkWell(
                    onTap: () => _loadAssets(),
                    child: _msgAddfoto(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  Widget _selectLados() {

    double ancho = (MediaQuery.of(this._context).size.width <= 550) ? 0.71 : 0.75;

    List<Map<String, dynamic>> lados = [
      {'valor' :'DELANTER@', 'icon' : 'auto_ico_del'},
      {'valor' :'TRASER@', 'icon'   : 'auto_ico_tras'},
      {'valor' :'LATERAL', 'icon'   : 'auto_ico_lat'},
      {'valor' :'OTROS', 'icon'     : 'auto_ico_otro'},
    ];

    List<DropdownMenuItem> ladosWidget = new List();
    lados.forEach((lado){

      ladosWidget.add(

        DropdownMenuItem(
          child: Container(
            width: MediaQuery.of(this._context).size.width * ancho,
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 30,
                  child: Image(
                    image: AssetImage('assets/images/${ lado['icon'] }.png'),
                    color: Colors.grey,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${lado['valor']}',
                  textScaleFactor: 1,
                )
              ],
            ),
          ),
          value: lado['valor'],
        )

      );
    });

    Widget child = DropdownButtonFormField(
      items: ladosWidget,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
        fillColor: Colors.white,
        filled: true,
      ),
      onChanged: (valor){
        setState(() {
          this._ladoSeleccionado = valor;
        });
      },
      value: this._ladoSeleccionado
    );

    return _machoteRoundedInput(child: child);
  }
  
  ///
  Widget _selectPosicion() {

    double ancho = (MediaQuery.of(this._context).size.width <= 550) ? 0.71 : 0.75;

    List<Map<String, dynamic>> lados = [
      {'valor' :'SIN POSICIÓN', 'align' : Alignment.center, 'color': Colors.grey},
      {'valor' :'DERECH@', 'align'  : Alignment.centerRight, 'color': Colors.white},
      {'valor' :'IZQUIERD@', 'align': Alignment.centerLeft, 'color': Colors.white},
      {'valor' :'SUPERIOR', 'align' : Alignment.topCenter, 'color': Colors.white},
      {'valor' :'INFERIOR', 'align' : Alignment.bottomCenter, 'color': Colors.white},
      {'valor' :'CENTRAL', 'align'  : Alignment.center, 'color': Colors.white},
    ];

    List<DropdownMenuItem> ladosWidget = new List();
    lados.forEach((lado){

      ladosWidget.add(
        DropdownMenuItem(
          child: Container(
            width: MediaQuery.of(this._context).size.width * ancho,
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  height: 30,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey,
                  ),
                  child: Align(
                    alignment: lado['align'],
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: lado['color']
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  lado['valor']
                )
              ],
            ),
          ),
          value: lado['valor'],
        )
      );
    });

    Widget child = DropdownButtonFormField(
      items: ladosWidget,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        fillColor: Colors.white,
        filled: true,
      ),
      onChanged: (valor){
        setState(() {
          this._posSeleccionada = valor;
        });
      },
      value: this._posSeleccionada
    );

    return _machoteRoundedInput(child: child);
  }

  ///
  Widget _inputCantidad() {
    
    return TextFormField(
      controller: this._ctrCant,
      focusNode: this._focusCant,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      onChanged: (String txt){
        setState(() {});
      },
      textAlign: TextAlign.center,
      onEditingComplete: (){
        FocusScope.of(this._context).requestFocus(this._focusPieza);
      },
      validator: (String txt){
        String val;
        txt = txt.trim();
        if(txt.length == 0) {
          this._errorFrmTxtCant = Colors.black;
          this._errorFrmBgCant  = Colors.orange;
          val = 'Cant';
        }
        return val;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        border: InputBorder.none,
        hintStyle: TextStyle(
          fontSize: 14
        ),
        errorText: 'Cant.',
        errorStyle: TextStyle(
          color: this._errorFrmTxtCant,
          backgroundColor: this._errorFrmBgCant
        )
      ),
    );
  }

  ///
  Widget _inputNombrePieza() {
    
    return TextFormField(
      controller: this._ctrPieza,
      focusNode: this._focusPieza,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validator: (String txt){
        String val;
        if(txt.length == 0) {
          this._errorFrmTxtPieza = Colors.black;
          this._errorFrmBgPieza = Colors.orange;
          return ' El nombre de la piezas en requerido ';
        }
        return val;
      },
      onChanged: (String txt){
        txt = txt.trim();
        if(txt.length >= 3){
          setState(() {
            this._hasData = true;
          });
        }else{
          if(this._hasData){
            setState(() {
              this._hasData = false;
            });
          }
        }
      },
      onFieldSubmitted: (String txt) {
        FocusScope.of(this._context).requestFocus(this._focusDeta);
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: InputBorder.none,
        hintText: '* El Nombre de la pieza',
        hintStyle: TextStyle(
          fontSize: 14
        ),
        errorText: 'Campo Obligatorio',
        errorStyle: TextStyle(
          color: this._errorFrmTxtPieza,
          backgroundColor: this._errorFrmBgPieza
        ),
      ),
    );
  }

  ///
  Widget _inputDetalles() {
    
    Widget child = TextFormField(
      controller: this._ctrDeta,
      focusNode: this._focusDeta,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onChanged: (String txt){
        setState(() {});
      },
      maxLines: 4,
      maxLength: 100,
      onFieldSubmitted: (String txt) {
        FocusScope.of(this._context).requestFocus(new FocusNode());
      },
      validator: (String txt){
        String val;
        txt = txt.trim();
        if(txt.length > 0) {
          if(txt.length < 4) {
            this._errorFrmTxtDetalles = Colors.black;
            this._errorFrmBgDetalles = Colors.orange;
            return ' Se más específico en los detalles ';
          }
        }
        return val;
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.white,
        hintText: 'Más Detalles   (Campo NO obligatorio)',
        hintStyle: TextStyle(
          fontSize: 14
        ),
        errorText: 'Alguna información adicional',
        errorStyle: TextStyle(
          color: this._errorFrmTxtDetalles,
          backgroundColor: this._errorFrmBgDetalles
        ),
        counterStyle: TextStyle(
          color: Colors.black
        )
      ),
    );

    return _machoteRoundedInput(child: child);
  }

  ///
  Widget _msgAddfoto() {

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          width: MediaQuery.of(this._context).size.width * 0.95,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(160),
          ),
          child: Column(
            children: <Widget>[
              Text(
                '¿Deséas Agregar Fotos?',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w300,
                  fontSize: 23
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Una Imagen dice más que mil Palabras',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.black54
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: const SizedBox(height: 5),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: _machoteBtnAccion(
            titulo: 'Seleccionar Fotografías',
            icono: Icons.add_a_photo,
            icoColor: Colors.white,
            color: Color(0xff002f51),
            indicador: false,
            accion: () => _loadAssets()
          ),
        ),
      ],
    );
  }
  
  ///
  Widget showFotos() {

    double alto = MediaQuery.of(this._context).size.height * 0.28;

    return Stack(
      children: <Widget>[
        Swiper(
          itemCount: this._images.length,
          viewportFraction: 0.95,
          scale: 0.98,
          controller: this._swipCtrl,
          loop: false,
          itemBuilder: (BuildContext context, int index) {
            Asset asset = this._images[index];
            return Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  width: MediaQuery.of(this._context).size.width,
                  child: Image(
                    image: AssetThumbImageProvider(asset,
                      height: alto.toInt(),
                      width: MediaQuery.of(this._context).size.width.toInt()
                    ),
                    fit: BoxFit.cover
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    padding: EdgeInsets.all(3),
                    icon: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.close, color: Colors.white),
                    ),
                    onPressed: (){
                      this._images.removeAt(index);
                      if(this._images.length == 0){
                        this._hasFotos = false;
                        if(this._ctrPieza.text.length > 3){
                          this._hasData = true;
                        }else{
                          this._hasData = false;
                        }
                      }
                      setState(() {});
                    },
                  ),
                )
              ],
            );
          },
        ),
        Positioned(
          bottom: 0,
          right: 10,
          child: IconButton(
            padding: EdgeInsets.all(3),
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.add_a_photo, color: Colors.purple),
            ),
            onPressed: () async => await _loadAssets(),
          ),
        ),
        Positioned(
          bottom: 48,
          right: 10,
          child: IconButton(
            padding: EdgeInsets.all(3),
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.play_circle_filled, color: Colors.purple),
            ),
            onPressed: (){
              this._swipCtrl.next();
            },
          ),
        )
      ],
    );
  }

  ///
  Widget _machoteRoundedInput({Widget child}) {

    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey[400]
        )
      ),
      child: child,
    );
  }

  ///
  Widget _btnsAccionSinPiezas() {

    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        (this._hasData) ? _btnTerminar() : const SizedBox(width: 0),
        const SizedBox(height: 30),
        (this._hasData) ? _btnAddOtra() : _msgPedirAsistencia(),
        const SizedBox(height: 10),
      ],
    );

  }

  ///
  Widget _btnsAccionConPiezas() {

    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        _btnTerminar(),
        const SizedBox(height: 30),
        _btnAddOtra(),
        const SizedBox(height: 30),
        _showBtnCancelar(),
        const SizedBox(height: 10),
      ],
    );
  }

  ///
  Widget _btnAddOtra() {

    return _machoteBtnAccion(
      titulo: 'AGREGAR OTRA PIEZA',
      icono: Icons.add_circle,
      icoColor: Colors.white,
      color: Colors.grey,
      indicador: false,
      accion: () async {
        await _salvarPieza(1);
      }
    );

  }
  
  ///
  Widget _btnTerminar() {

    return _machoteBtnAccion(
      titulo: 'Guardar y TERMINAR',
      icono: Icons.check_circle,
      icoColor: Colors.white,
      color: Color(0xff002f51),
      indicador: false,
      accion: () async {
        await _salvarPieza(2);
      }
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
        width: MediaQuery.of(this._context).size.width,
        height: 40,
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
                '1',
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
  Widget _msgPedirAsistencia() {

    return SizedBox(
      width: MediaQuery.of(this._context).size.width * 0.9,
      child: Text(
        'No dudes en pedir Asistencia, nuestros asesores estan para servirte',
        textScaleFactor: 1,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black
        ),
      ),
    );
  }

  ///
  Future<void> _launchWhatsApp() async {
    
    String phoneNumber = '52${this._infoZM['socios']}';
    String message = 'Necesito...';
    var whatsappUrl = "https://wa.me/$phoneNumber?text=$message";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'No se pudo abrir $whatsappUrl';
    }
  }

  ///
  Future<void> _launchTelefono() async {

    String phoneNumber = 'tel${this._infoZM['socios']}';
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'No se pudo abrir $phoneNumber';
    }
  }

  ///
  Future<void> _loadAssets() async {

    List<Asset> resultList = new List();
    this._hasFotos = false;
    this._hasData = false;

    await solicitudSgtn.makeBackup(await _getPiezaToScreen());

    try {

      resultList = await MultiImagePicker.pickImages(
        maxImages: 2,
        enableCamera: true,
        selectedAssets: this._images,
        materialOptions: MaterialOptions(
          startInAllView: true,
          allViewTitle: 'Todas las Fotos',
          actionBarColor: '#E70707',
          statusBarColor: '#7C0000',
          lightStatusBar: false,
          textOnNothingSelected: 'No seleccionaste fotografía',
          selectionLimitReachedText: 'Permitidas 2 Fotografías',
        )
      );

    } on Exception catch (e) {
      this._error = e.toString();
      assert((){
        print(this._error);
        return true;
      }());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if(resultList.length > 0) {
      this._images = resultList;
    }
    resultList = null;
    if(this._images.length > 0) {
      this._hasFotos = true;
      this._hasData = true;
    }else{
      if(this._ctrPieza.text.length > 3){
        this._hasData = true;
      }else{
        this._hasData = false;
      }
    }
    
    if (this._error == null) _error = 'Sin Errores';
    setState(() {});
  }

  ///
  Widget _verAyuda() {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      width: MediaQuery.of(this._context).size.width,
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.red,
            offset: Offset(0, -3)
          )
        ]
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(
            color: Colors.grey
          )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(7),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
              ),
              child: Center(
                child: Text(
                  'Estamos para servirte!',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 19
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.phone_android, size: 35, color: Colors.orange),
              title: Text(
                'Vía Telefónica',
                textScaleFactor: 1,
              ),
              subtitle: Text(
                'Haz tu cotización por teléfono',
                textScaleFactor: 1,
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => _launchTelefono(),
            ),
            ListTile(
              leading: Icon(Icons.message, size: 35, color: Colors.green),
              title: Text(
                'Vía Whatsapp'
              ),
              subtitle: Text(
                'Envianos un Mensaje'
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => _launchWhatsApp(),
            ),
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.grey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Uno de nuestros Agentes te asistirá para realizar tu cotización',
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17
                    ),
                  ),
                  FlatButton.icon(
                    color: Colors.red,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    onPressed: () => Navigator.of(this._context).pop(false),
                    icon: Icon(Icons.close),
                    label: Text(
                      'Cerrar Asistencia',
                      textScaleFactor: 1,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  Future<void> _salvarPieza(int clickFrom) async {

    if(this._frmKey.currentState.validate()){

      _saveAfterValidar(clickFrom);

    }else{

      bool save = false;
      solicitudSgtn.autos.forEach((auto) {
        if(auto.containsKey('piezas')){
          if(auto['piezas'].length > 0) {
            save =true;
          }else{
            save =false;
          }
        }
      });

      if(save){

        _calculaCantPiezas();
        _resetScreen();

        if(this._cantPiezaSaved > 1) {
          Navigator.of(this._context).pushReplacementNamed('lst_piezas_page');
        }else{
          Navigator.of(this._context).pushReplacementNamed('lst_modelos_select_page');
        }

      }else{
        setState(() {
          this._skfKey.currentState.showSnackBar(stackErrorFrm());
        });
        this._ctrScroll.animateTo(this._scrollOffset, duration: Duration(seconds: 1), curve: Curves.ease);
      }
    }
  }

  ///
  Future<void> _saveAfterValidar(int clickFrom) async {

    bool res = true;
    bool save = true;
    FocusScope.of(this._context).requestFocus(new FocusNode());

    Map<String, dynamic> piezaNueva = await _getPiezaToScreen();

    if(piezaNueva['fotos'].length == 0) {
      res = await _dialogSinFotos();
      save = (res) ? res : false;
    }
 
    if(res && save) {

      if(solicitudSgtn.autoEnJuego['idPieza'] != null) {
        await solicitudSgtn.editPieza(piezaNueva);
        solicitudSgtn.setAutoEnJuegoIndexPieza(null);
        solicitudSgtn.setAutoEnJuegoIdPieza(null);
      }else{
        int indexPieza = solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'].indexWhere((pieza) => (pieza['id'] == this._idPiezaInScreen));
        if(indexPieza > -1){

          solicitudSgtn.setAutoEnJuegoIndexPieza(indexPieza);
          solicitudSgtn.setAutoEnJuegoIdPieza(this._idPiezaInScreen);

          await solicitudSgtn.editPieza(piezaNueva);

          solicitudSgtn.setAutoEnJuegoIndexPieza(null);
          solicitudSgtn.setAutoEnJuegoIdPieza(null);

        }else{
          await solicitudSgtn.addPieza(piezaNueva);
        }
      }
      piezaNueva = null;
      _calculaCantPiezas();
      _resetScreen();

      // Agregar Otra.
      if(clickFrom == 1) {
        solicitudSgtn.setAutoEnJuegoIndexPieza(this._cantPiezaSaved);
        setState(() {});
        this._ctrScroll.animateTo(0.0, duration: Duration(seconds: 1), curve: Curves.ease);
        return;
      }

      if(this._cantPiezaSaved > 1) {
        Navigator.of(this._context).pushReplacementNamed('lst_piezas_page');
      }else{
        Navigator.of(this._context).pushReplacementNamed('lst_modelos_select_page');
      }

    }

  }

  ///
  Future<Map<String, dynamic>> _getPiezaToScreen() async {

    if(this._idPiezaInScreen == -1) {
      if(solicitudSgtn.autoEnJuego['idPieza'] != null) {
        this._idPiezaInScreen = solicitudSgtn.autoEnJuego['idPieza'];
      }else{
        this._idPiezaInScreen = await solicitudSgtn.determinarIdDePieza();
      }
    }

    return {
      'id'      : this._idPiezaInScreen,
      'cant'    : this._ctrCant.text.trim(),
      'nombre'  : this._ctrPieza.text.trim(),
      'lado'    : this._ladoSeleccionado.trim(),
      'posicion': this._posSeleccionada.trim(),
      'detalles': (this._ctrDeta.text.length > 0) ? this._ctrDeta.text.trim() : '0',
      'fotos'   : (this._images.length == 0) ? new List() : await solicitudSgtn.setFotosPieza(this._images)
    };
  }

  ///
  SnackBar stackErrorFrm() {

    return SnackBar(
      backgroundColor: Colors.orange,
      content: Text(
        'ERROR EN EL FORMULARIO',
        textScaleFactor: 1,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black
        ),
      ),
    );
  }

  ///
  Future<void> _resetScreen() async {

    this._ctrCant.text       = '1';
    this._ctrPieza.text      = '';
    this._ctrDeta.text       = '';
    this._ladoSeleccionado   = 'DELANTER@';
    this._posSeleccionada    = 'SIN POSICIÓN';
    this._errorFrmBgCant     = null;
    this._errorFrmTxtCant    = Colors.red[200];
    this._errorFrmBgPieza    = null;
    this._errorFrmTxtPieza   = Colors.red[200];
    this._errorFrmBgDetalles = null;
    this._errorFrmTxtDetalles= Colors.red[200];
    this._images             = new List();
    this._hasData            = false;
    this._hasFotos           = false;
    this._idPiezaInScreen = -1;
  }

  ///
  Future<bool> _dialogSinFotos() async {

    double tamTxt = (MediaQuery.of(this._context).size.height <= 550) ? 22 : 25;
    return await showDialog(
      context: this._context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(20),
          title: Text(
            'RECOMENDACIÓN',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Una Imagen dice más que mil palabras.',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Por agilidad a tu cotización, es recomendable que envies al menos una fotografía de referencia.',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15
                ),
              ),
               const SizedBox(height: 20),
              Text(
                '¿Qué deseas hacer?',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: tamTxt,
                  fontWeight: FontWeight.w300,
                  color: Colors.green[600]
                ),
              )
            ],
          ),
          actions: <Widget>[
            _machoteBtnAccion(
              titulo: 'Agregar Fotografías',
              color: Color(0xff002f51),
              icono: Icons.add_a_photo,
              icoColor: Colors.white,
              indicador: false,
              accion: () async {
                Navigator.of(this._context).pop(false);
                await _loadAssets();
                
              }
            ),
            const SizedBox(height: 30),
            _machoteBtnAccion(
              titulo: 'Continuar sin Fotografías',
              color: Colors.grey,
              icono: Icons.shopping_cart,
              icoColor: Colors.white,
              indicador: false,
              accion: () async {
                Navigator.of(this._context).pop(true);
                setState(() {
                  this._hasData = true;
                });
              }
            ),
          ],
        );
      }
    );
  }

  ///
  Future<void> _showDialogDeRecovery() async {

    await showDialog(
      context: this._context,
      builder: (_) {

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          titlePadding: EdgeInsets.all(10),
          contentPadding: EdgeInsets.all(5),
          title: Text(
            'RECUPERACIÓN DE SOLICITUD',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Image(
                  image: AssetImage('assets/images/important-event.png'),
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Text(
                      'El sistema detectó una Solicitud Pendiente de Terminar',
                      textScaleFactor: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green
                      ),
                    ),
                    Divider(),
                    Text(
                      '¿QUÉ DESEAS HACER?',
                      textScaleFactor: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          actionsOverflowButtonSpacing: 20,
          actions: [
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2)
              ),
              color: Colors.red,
              textColor: Colors.white,
              child: Text(
                'Cancelar TODO',
                textScaleFactor: 1,
              ),
              onPressed: () async {
                await emRoto.deleteProcesosRotosByAltaDeRefaccs();
                Navigator.of(this._context).pushNamedAndRemoveUntil('index_page', (route) => false);
              },
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2)
              ),
              color: Color(0xff002f51),
              textColor: Colors.white,
              child: Text(
                (MediaQuery.of(this._context).size.height <= 550) ? ' CONTINUAR ' : 'CONTINUAR CON',
                textScaleFactor: 1,
              ),
              onPressed: (){
                Navigator.of(this._context).pop(true);
              },
            )
          ],
        );
      }
    );
  }


}