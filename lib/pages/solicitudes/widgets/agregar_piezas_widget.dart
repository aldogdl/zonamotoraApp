import 'package:flutter/material.dart';
import 'package:zonamotora/pages/solicitudes/widgets/ver_eje_alta_pieza_widget.dart';
import 'package:zonamotora/singletons/solicitud_sngt.dart';

class AgregarPiezasWidget extends StatefulWidget {

  final GlobalKey<ScaffoldState> skfKey;
  final Future<bool> Function(String pieza, List<Map<String, dynamic>>, Set<int>, String, String) agregar;
  AgregarPiezasWidget(this.skfKey, this.agregar);

  @override
  _AgregarPiezasWidgetState createState() => _AgregarPiezasWidgetState();
}

class _AgregarPiezasWidgetState extends State<AgregarPiezasWidget> {

  SolicitudSngt solicitudSgtn = SolicitudSngt();

  Size _screen;
  bool _isInit = false;
  double _tamFlex = 10;
  BuildContext _context;
  bool _afinaData = true;
  List<Widget> _btnsLados;
  Widget _checkBoxSubLados;

  String _ladoSelect = 'Delantero';
  Set<int> _ladosSeleccionados = new Set();
  List<Map<String, dynamic>> _opLados = new List();
  IconData _iconoExpandible = Icons.keyboard_arrow_up;
  List<Map<String, dynamic>> _ladosGrales = new List();
  GlobalKey<FormState> _frmKey = GlobalKey<FormState>();
  ScrollController _ctrlScrollFrmPiezas = ScrollController();
  TextEditingController _ctrlPieza = TextEditingController();
  TextEditingController _ctrlPiezaUbic = TextEditingController();

  @override
  void initState() {

    this._opLados.add({'titulo' : {'a':'IZQUIERDA', 'o':'IZQUIERDO'}, 'valor' : 2, 'hermano': 1});
    this._opLados.add({'titulo' : {'a':'DERECHA', 'o':'DERECHO'},     'valor' : 1, 'hermano': 2});
    this._opLados.add({'titulo' : {'a':'SUPERIOR', 'o':'SUPERIOR'},   'valor' : 3, 'hermano': 4});
    this._opLados.add({'titulo' : {'a':'INFERIOR', 'o':'INFERIOR'},   'valor' : 4, 'hermano': 3});

    this._ladosGrales.add({'icono': 'auto_ico_del', 'titulo': {'a':'Delantera', 'o':'Delantero'}});
    this._ladosGrales.add({'icono': 'auto_ico_lat', 'titulo': {'a':'Lateral', 'o':'Lateral'}});
    this._ladosGrales.add({'icono': 'auto_ico_tras','titulo': {'a':'Trasera', 'o':'Trasero'}});

    WidgetsBinding.instance.addPostFrameCallback(_hidratarParaEditar);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(!this._isInit) {
      this._isInit = true;
      this._context = context;
      this._screen = MediaQuery.of(context).size;
      context = null;
      _lstSubLados();
    }

    double alto = (this._screen.height <= 550) ?  0.645 : 0.723;
    double altoSpBtns = (this._screen.height <= 550) ?  15 : 15;

    return Container(
      height: this._screen.height * alto,
      padding: EdgeInsets.only(
        top: 20, left: 10, right: 10, bottom: 10
      ),
      width: this._screen.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red,
            Colors.black,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        )
      ),
      child: ListView(
        controller: this._ctrlScrollFrmPiezas,
        children: <Widget>[
          Form(
            key: this._frmKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 12),
                _inputPieza(),
                const SizedBox(height: 20),
                _lados(),
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(50),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )
                  ),
                  child: _btnVerAfinarDatos(),
                ),
                (this._afinaData)
                ?
                Container(
                  margin: EdgeInsets.only(left: 1, right: 1, top: 0, bottom: 10),
                  padding: EdgeInsets.only(left: 3, right: 3, bottom: 0, top: 0),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(50),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    )
                  ),
                  child: Column(
                    children: <Widget>[
                      this._checkBoxSubLados,
                      const SizedBox(height: 10),
                      _inputPosicion(),
                      const SizedBox(height: 20),
                    ],
                  ),
                )
                :
                SizedBox(height: altoSpBtns),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      VerEjemploAltaPiezaWidget(),
                      _btnSavePiezas()
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: this._tamFlex)
        ],
      )
    );
  }

  ///
  Widget _btnVerAfinarDatos() {

    return InkWell(
      child: Container(
        width: this._screen.width * 0.9,
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: (!this._afinaData)
                ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'LISTA DE POSICIONES',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Afina tu solicitud.     VER MÁS...',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.grey[400]
                      ),
                    )
                  ],
                )
                :
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Afina mejor tu solicitud.',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.grey[50],
                        letterSpacing: 1.3
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Campos no Obligatorios',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.grey[400]
                      ),
                    )
                  ],
                )
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withAlpha(50),
                ),
                child: Icon(this._iconoExpandible, color: Colors.white),
              ),
            )
          ],
        ),
      ),
      onTap: (){
        FocusScope.of(this._context).requestFocus(new FocusNode());
        setState(() {
          this._afinaData = !this._afinaData;
          this._iconoExpandible = (this._afinaData) ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down;
          this._tamFlex = (this._afinaData) ? 50 : 10;
        });
        widget.skfKey.currentState.setState(() {});
      },
    );
  }
  
  ///
  Widget _inputPieza() {

    return Container(
      padding: EdgeInsets.only(left: 7, top: 4, right: 4, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.red[100]
      ),
      child: TextFormField(
        controller: this._ctrlPieza,
        validator: (String txt) {
          if(txt.isEmpty){
            return 'Especifíca el nombre de la Piezas';
          }
          return null;
        },
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          icon: Icon(Icons.extension),
          labelText: '*Pieza Requerida:',
          errorStyle: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2
          )
        ),
        onEditingComplete: (){
          _crearBtnLados();
          setState((){});
          FocusScope.of(this._context).requestFocus(new FocusNode());
        },
      ),
    );
  }

  ///
  Widget _inputPosicion() {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7),
      child: Container(
        padding: EdgeInsets.only(left: 7, top: 4, right: 5, bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.red[100]
        ),
        child: TextFormField(
          controller: this._ctrlPiezaUbic,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(2),
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none,
            icon: Icon(Icons.airport_shuttle, size: 30),
            hasFloatingPlaceholder: true,
            isDense: true,
            labelText: 'Ubicación de instalación:',
            helperText: 'En que parte se coloca la pieza',
            hintText: 'Salpicadero, defensa, puerta'
          )
        ),
      ),
    );
  }

  ///
  Widget _lados() {
    _crearBtnLados();
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(
            '¿INDICA EL LADO DE UBICACIÓN DE LA PIEZA?',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              height: 1.2
            ),
          ),
        ),
        Divider(color: Colors.red[100]),
        Row(
          children: this._btnsLados
        ),
      ],
    );

  }

  ///
  void _crearBtnLados() {
  
    this._btnsLados = new List();
    String gen = solicitudSgtn.trasladeGeneroPieza(this._ctrlPieza.text);
    this._ladosGrales.forEach((lado) {
      this._btnsLados.add(
        Expanded(
          flex: 3,
          child: InkWell(
            child: _machoteBtnLados(icono: lado['icono'], titulo: lado['titulo'][gen]),
            onTap: (){
              FocusScope.of(this._context).requestFocus(new FocusNode());
              setState(() {
                this._ladoSelect = lado['titulo'][gen];
              });
            },
          )
        )
      );
    });
  }

  ///
  Widget _machoteBtnLados({@required String icono, @required String titulo}) {

    Color icoColor= Colors.grey[600];
    Color lgEnd   = Colors.grey;
    Color txtTit  = Colors.grey[400];

    if(this._ladoSelect == titulo) {
      icoColor = Color(0xff7C0000);
      lgEnd  = Colors.lightGreen;
      txtTit  = Colors.white;
    }else{

      if(this._ladoSelect.startsWith(titulo.substring(0, 1))){
        String gen = solicitudSgtn.trasladeGeneroPieza(titulo);
        Map<String, dynamic> tmpSelect = this._ladosGrales.firstWhere((tits){
          return (tits['titulo'][gen] == titulo);
        }, orElse: () => new Map());

        if(tmpSelect.isNotEmpty){
          String tmpGen = (gen == 'a') ? 'o' : 'a';
          if(tmpSelect['titulo'][tmpGen] == this._ladoSelect) {
            icoColor = Color(0xff7C0000);
            lgEnd  = Colors.amber;
            txtTit  = Colors.white;
            this._ladoSelect = titulo;
          }
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          '$titulo',
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: txtTit
          ),
        ),
        const SizedBox(height: 7),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                lgEnd
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                offset: Offset(2,2),
                color: Colors.black
              )
            ]
          ),
          child: Image(
            image: AssetImage('assets/images/$icono.png'),
            color: icoColor,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  ///
  void _lstSubLados() {

    this._checkBoxSubLados = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _switchBy([0,1]),
        _switchBy([2,3]),
      ]
    );

    setState(() {});
  }

  /// 
  Widget _switchBy(List<int> opciones) {

    List<Widget> lstOps = new List();

    String gen = solicitudSgtn.trasladeGeneroPieza(this._ladoSelect);
    String ladoGenero;

    opciones.forEach((opcion){

      ladoGenero = this._opLados[opcion]['titulo'][gen];
      IconData tipoIcoSubLados = (this._ladosSeleccionados.contains(this._opLados[opcion]['valor']))
      ? Icons.radio_button_checked
      : Icons.radio_button_unchecked;

      Widget swch = FlatButton.icon(
        onPressed: (){

          bool val = (this._ladosSeleccionados.contains(this._opLados[opcion]['valor'])) ? true : false;
          if(!val){
            this._ladosSeleccionados.remove(this._opLados[opcion]['hermano']);
            this._ladosSeleccionados.add(this._opLados[opcion]['valor']);
          }else{
            this._ladosSeleccionados.remove(this._opLados[opcion]['valor']);
          }

          _lstSubLados();
        },
        label: Text(
          ladoGenero,
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13
          ),
        ),
        icon: Icon(tipoIcoSubLados, color: Colors.grey[400]),
      );

      lstOps.add(swch);
    });

    return (ladoGenero.startsWith('IZQ') || ladoGenero.startsWith('SUP'))
    ? Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: lstOps,
    )
    :
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: lstOps,
    );
  }

  ///
  Widget _btnSavePiezas() {

    String sufix = (this._screen.width <= 350) ? '' : 'PIEZA';

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      icon: Icon(Icons.save, color: Colors.red),
      color: Colors.white,
      label: Text(
        (solicitudSgtn.idAutoForEdit != null) ? 'EDITAR $sufix' : 'GUARDAR $sufix',
        textScaleFactor: 1,
        style: TextStyle(
          color: Colors.orange,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () async {
        this._ctrlScrollFrmPiezas.animateTo(0, duration: Duration(seconds: 1), curve: Curves.ease);
        if(this._frmKey.currentState.validate()) {
          await _salvarPieza();
        }else{
          _alertErrorCapturaPieza('ERROR EN EL FORMULARIO');
        }
      },
    );
  }

  ///
  Future<void> _salvarPieza() async {

    /// Revisando lados.
    if(this._ladoSelect.isEmpty) {
      _alertErrorCapturaPieza('Selecciona un LADO de Ubicación');
      return;
    }

    bool isEdit = (solicitudSgtn.idAutoForEdit == null) ? false : true;
    bool res = await widget.agregar(
      this._ctrlPieza.text, 
      this._opLados,
      this._ladosSeleccionados,
      this._ladoSelect,
      this._ctrlPiezaUbic.text
    );

    if(!res){
      _alertErrorCapturaPieza('Inténtalo nuevamente por favor.\n\nOcurrio un error al guardar');
      return;
    }

    FocusScope.of(this._context).requestFocus(new FocusNode());
    _resetTablero();
    _alertErrorCapturaPieza(null, echo: true);

    if(isEdit) {
      Navigator.of(this._context).pushNamedAndRemoveUntil(
        'gestion_piezas_page',
        (Route rutas) => false,
        arguments: {'indexAuto': solicitudSgtn.autoEnJuego['indexAuto']}
      );
    }
  }

  ///
  void _resetTablero() {

    this._ladosSeleccionados = new Set();
    this._ctrlPieza.text = '';
    this._ctrlPiezaUbic.text = '';
    _lstSubLados();
  }

  ///
  void _alertErrorCapturaPieza(String txt, {echo = false}) {

    Color color = (echo) ? Colors.green : Colors.yellow;

    Widget contenido = (echo)
    ?
    Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'PIEZA GUARDADA CON ÉXITO!',
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w300
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Revisalas en la pestaña "PIEZAS"',
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2
          ),
        )
      ],
    )
    :
    Text(
      txt,
      textScaleFactor: 1,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        color: Colors.red,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2
      ),
    );

    widget.skfKey.currentState.showSnackBar(SnackBar(
      backgroundColor: color,
      content: contenido,
    ));
  }

  ///
  void _hidratarParaEditar(_) {

    if(solicitudSgtn.idAutoForEdit != null) {

      Map<String, dynamic> autoForEdit = solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'].firstWhere((auto){
        return (auto['id'] == solicitudSgtn.idAutoForEdit);
      }, orElse: () => new Map<String, dynamic>() );

      if(autoForEdit.isNotEmpty) {
        List<dynamic> ladosTraslate = solicitudSgtn.trasladeSubLadosFromStringToSet(
          autoForEdit['pieza'].trim(),
          this._opLados,
          autoForEdit['lado']
        );

        this._ctrlPieza.text = autoForEdit['pieza'].trim();
        this._ladoSelect = ladosTraslate[0];
        this._ladosSeleccionados = ladosTraslate[1];
        this._ctrlPiezaUbic.text = autoForEdit['posicion'];
        if(this._ladosSeleccionados.isEmpty){
          this._afinaData = false;
        }
        _lstSubLados();

        Future.delayed(Duration(milliseconds: 500), (){
          this._ctrlScrollFrmPiezas.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
        });
      }
    }
  }


}