import 'package:flutter/material.dart';
import 'package:zonamotora/repository/autos_repository.dart';
import 'package:zonamotora/singletons/solicitud_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';

class LstModelosPage extends StatefulWidget {
  @override
  _LstModelosPageState createState() => _LstModelosPageState();
}

class _LstModelosPageState extends State<LstModelosPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AutosRepository emAutos = AutosRepository();
  SolicitudSngt solicitudSgtn = SolicitudSngt();
  AlertsVarios alertsVarios = AlertsVarios();

  Size _screen;
  BuildContext _context;
  String _modsSelec = '0';
  String _modsfind  = '0';
  bool _init = false;
  Set<int> _autosSeleccionados = new Set();
  List<Map<String, dynamic>> _lstAutos = new List();
  List<Map<String, dynamic>> _lstAutosAlls = new List();
  Widget _widgetLstAutos;

  @override
  void initState() {
    if(solicitudSgtn.autos.isNotEmpty){
      solicitudSgtn.autos.forEach((auto){
        this._autosSeleccionados.add(auto['md_id']);
      });
      this._modsSelec = this._autosSeleccionados.length.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    if(!this._init){
      this._init = true;
      this._screen = MediaQuery.of(this._context).size;
      _cargando();
    }

    return Scaffold(
      appBar: appBarrMy.getAppBarr(titulo: 'Organiza tu Solicitud'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: SingleChildScrollView(
          child: _body(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async => _irAListaDeModelos(),
        backgroundColor: Colors.grey[100],
        elevation: 10,
        child: CircleAvatar(
          backgroundColor: Colors.black,
          child: Icon(Icons.arrow_forward, color: Colors.white, size: 30),
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  void _cargando() async {

    if(this._lstAutos.length == 0){

      this._widgetLstAutos = Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            children: <Widget>[
              CircularProgressIndicator(),
              const SizedBox(height: 10),
              Text(
                'Construyendo',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.grey
                ),
              )
            ],
          ),
        ),
      );
    }
    await _getAutos();
    _crearListaDeAutos();
  }

  ///
  Widget _body() {

    double alto = (this._screen.height <= 550) ? 0.25 : 0.23;
    double altoLst = (this._screen.height <= 550) ? 0.43 : 0.73;

    return Column(
      children: <Widget>[
        SizedBox(
          width: this._screen.width,
          height: this._screen.height * alto,
          child: _cabeceraAndBuscador(),
        ),
        const SizedBox(height: 7),
        Text(
          '${this._modsfind} modelos, ${this._modsSelec} seleccionados',
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        SizedBox(
          width: this._screen.width,
          height: this._screen.height * altoLst,
          child: this._widgetLstAutos,
        )
      ],
    );

  }

  ///
  void _crearListaDeAutos() {

    this._widgetLstAutos = ListView.builder(
      itemCount: this._lstAutos.length,
      itemBuilder: (BuildContext context, int index){
        return _titleCheck(index);
      },
    );
    setState(() {});
  }

  ///
  Widget _cabeceraAndBuscador() {

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'SELECCIONA EL MODELO',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w300
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Podrás incluir uno o varios a tu Cotización',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16
                ),
              )
            ],
          ),
        ),

        // Buscador
        Positioned(
          top: this._screen.height * 0.13,
          width: this._screen.width,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: this._screen.width * 0.05),
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  offset: Offset(1,1),
                  color: Colors.black
                )
              ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: this._screen.height * 0.15,
                    child: Image(
                      image: AssetImage('assets/images/auto_ico.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: SizedBox(
                    width: this._screen.width * 0.7,
                    child: TextField(
                      maxLines: 1,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.only(left: 0, top: 0),
                        suffixIcon: Icon(Icons.search, size: 30,),
                        border: InputBorder.none,
                        hintText: 'Busca el modelo aquí'
                      ),
                      onChanged: (String txt) => _hacerBuscquedaDeModelos(txt),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  ///
  Future<void> _getAutos() async {

    if(this._lstAutosAlls.length == 0) {
      this._lstAutosAlls = await emAutos.getAllAutos();
      this._lstAutos = this._lstAutosAlls;
      this._modsfind = this._lstAutosAlls.length.toString();
    }else{
      this._lstAutos = this._lstAutosAlls;
    }
  }

  ///
  Widget _titleCheck(int index) {

    return CheckboxListTile(
      title: Text(
        this._lstAutos[index]['md_nombre'],
        textScaleFactor: 1,
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
      subtitle: Text(
        this._lstAutos[index]['mk_nombre'],
        textScaleFactor: 1,
        style: TextStyle(
          color: Colors.blue[800]
        ),
      ),
      value: (this._autosSeleccionados.contains(this._lstAutos[index]['md_id'])) ? true : false,
      onChanged: (bool val) {
        if(val){
          this._autosSeleccionados.add(this._lstAutos[index]['md_id']);
        }else{
          this._autosSeleccionados.remove(this._lstAutos[index]['md_id']);
        }
        this._modsSelec = this._autosSeleccionados.length.toString();
        setState(() {
          _crearListaDeAutos();
        });
      },
    );
  }

  ///
  void _hacerBuscquedaDeModelos(String mod) {

    this._lstAutos = new List();
    List<Map<String, dynamic>> nuevaLista = new List();

    this._lstAutosAlls.forEach((auto){
      if(auto['md_nombre'].toLowerCase().contains(mod.toLowerCase())){
        nuevaLista.add(auto);
      }
    });

    this._lstAutos = nuevaLista;
    nuevaLista = null;
    _crearListaDeAutos();
  }

  ///
  void _irAListaDeModelos() async {

    this._autosSeleccionados.forEach((idsMod){
      Map<String, dynamic> carro = this._lstAutosAlls.firstWhere((auto){
        return (auto['md_id'] == idsMod);
      }, orElse: () => new Map());

      if(carro.isNotEmpty){
        solicitudSgtn.setAutoSeleccionado(carro);
      }
    });
    
    if(solicitudSgtn.autos.isEmpty) {
      String body = 'Es necesario para realizar una SOLICITUD DE PIEZAS.\nQue selecciones al menos un MODELO de AUTO. por favor.';
      await alertsVarios.entendido(this._context, titulo: 'SELECCIÓN DE AUTOS', body: body);
    }else{
      Navigator.of(this._context).pushNamedAndRemoveUntil('lst_modelos_select_page', (Route rutas) => false);
    }
  }

}