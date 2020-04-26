import 'package:flutter/material.dart';

import 'package:zonamotora/repository/autos_repository.dart';
import 'package:zonamotora/repository/mis_autos_repository.dart';
import 'package:zonamotora/repository/solicitud_repository.dart';
import 'package:zonamotora/singletons/myAutos_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/card_mini_auto_widget.dart' as cardMiniAuto;
import 'package:zonamotora/widgets/container_inputs.dart';

class SeleccionarAnioWidgetPage extends StatefulWidget {
  @override
  _SeleccionarAnioWidgetPageState createState() => _SeleccionarAnioWidgetPageState();
}

class _SeleccionarAnioWidgetPageState extends State<SeleccionarAnioWidgetPage> {

  AppBarrMy appBarrMy           = AppBarrMy();
  MenuInferior menuInferior     = MenuInferior();
  AutosRepository emAutos       = AutosRepository();
  MyAutosSngt myAutosSngt       = MyAutosSngt();
  ContainerInput containerInput = ContainerInput();
  AlertsVarios alertsVarios     = AlertsVarios();
  SolicitudRepository emSolicitud = SolicitudRepository();
  MisAutosRepository emMisAutos   = MisAutosRepository();

  Size _screen;
  BuildContext _context;
  GlobalKey<FormState> _frmKey = GlobalKey<FormState>();
  TextEditingController _ctrlAnio = TextEditingController();
  Widget _autoSeleccionado;

  @override
  void initState() {
    this._autoSeleccionado = Center(
      child: LinearProgressIndicator(),
    );
    _getAutoSeleccionado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;

    return Scaffold(
      appBar: appBarrMy.getAppBarr(titulo: 'AÑO DEL AUTOMÓVIL'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: SingleChildScrollView(
        child: _body(),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  /* */
  Widget _body() {

    return Column(
      children: <Widget>[
        Container(
          width: this._screen.width,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border(
              top: BorderSide(
                color: Colors.orange
              )
            )
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: 100,
            width: 100,
            child: Image(
              image: AssetImage('assets/images/anio_icon.png'),
            ),
          ),
        ),
        const SizedBox(height: 20),
        this._autoSeleccionado,
        const SizedBox(height: 20),
        Text(
          '¿Qué Año es el Auto?',
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w300,
            color: Colors.grey[600]
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: this._screen.width,
          height: 100,
          child: _createListInputs(),
        ),
        Container(
          padding: EdgeInsets.all(20),
          width: this._screen.width,
          height: 90,
          child: _btnListo(),
        )
      ],
    );
  }

  /* */
  Widget _createListInputs() {

    List<Widget> lstInputs = [
      _inputAnio()
    ];

    return Form(
      key: this._frmKey,
      child: containerInput.container(lstInputs, 'anio'),
    );
  }

  /* */
  Widget _inputAnio() {

    return TextFormField(
      controller: this._ctrlAnio,
      autofocus: true,
      maxLength: 4,
      validator: (String anio){
        List<dynamic> pedazos = anio.split(' ');
        if(pedazos.length > 1){
          anio = pedazos.join('');
        }
        if(anio.length < 4) {
          return 'El Año debe ser de 4 dígitos';
        }
        return null;
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.departure_board),
        hintText: 'Ej. 1975'
      ),
      keyboardType: TextInputType.number,
      onFieldSubmitted: (String val){
        myAutosSngt.anio = int.tryParse(val);
        _sendFrm();
      },
    );

  }

  /* */
  Widget _btnListo() {

    return RaisedButton.icon(
      elevation: 1,
      color: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      icon: Icon(Icons.thumb_up, color: Colors.orange,),
      label: Text(
        '¡ LISTO ! Terminar',
        textScaleFactor: 1,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w400
        ),
      ),
      onPressed: () => _sendFrm(),
    );
  }

  /* */
  Future<void> _getAutoSeleccionado() async {

    Map<String, dynamic> auto;
    auto = await emAutos.getAutoByIdModelo(myAutosSngt.modSelecc);
    if(auto.isNotEmpty) {
      this._autoSeleccionado = cardMiniAuto.printCard(markMod: '${auto['mk_nombre']} - ${auto['md_nombre']}', showAcc: false);
    }
  }

  /* */
  Future<void> _sendFrm() async {

    if(this._frmKey.currentState.validate()){
      alertsVarios.cargando(this._context, titulo: 'GUARDANDO', body: 'Se está almacenando la información de tu auto, por favor, espera un momento.');
      if(myAutosSngt.pageCall == 'mis_autos_page'){
        Map<String, dynamic> result = await emMisAutos.setNewMisAuto();
        if(!result['abort']){
          Navigator.of(this._context).pushNamedAndRemoveUntil('${myAutosSngt.pageCall}', (Route rutas) => false);
          myAutosSngt.dispose();
        }else{
          Navigator.of(this._context).pop();
          await alertsVarios.entendido(this._context, titulo: result['msg'], body: result['body']);
        }
      }
    }
  }

}