import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/mis_autos_repository.dart';
import 'package:zonamotora/singletons/buscar_autos_sngt.dart';
import 'package:zonamotora/singletons/frm_mk_md_anios_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';

import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/frm_mk_md_anio_widget.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/template_page_helps.dart';
import 'package:zonamotora/shared_preference_const.dart' as spConst;
import 'package:zonamotora/widgets/card_mini_auto_widget.dart' as cardMiniAuto;


class MisAutosPage extends StatefulWidget {

  @override
  _MisAutosPageState createState() => _MisAutosPageState();
}

class _MisAutosPageState extends State<MisAutosPage> {

  final AppBarrMy appBarrMy       = AppBarrMy();
  MisAutosRepository emMisAtos    = MisAutosRepository();
  FrmMkMdAniosSngt frmSng         = FrmMkMdAniosSngt();
  BuscarAutosSngt buscarAutosSngt = BuscarAutosSngt();
  
  final MenuInferior menuInferior = MenuInferior();
  final AlertsVarios alertsVarios = AlertsVarios();
  TemplatePageHelps templatePageHelps = TemplatePageHelps();


  BuildContext _context;
  bool _isVistaHelp = false;
  bool _isInit = false;
  SwiperController _ctrlPages = SwiperController();
  SharedPreferences _sess;
  List<Map<String, dynamic>> _autos = new List();
  int _autosActuales = 0;
  int _autosPermitidos = 5;
  Widget _widgetStarts;
  Widget _lstAutos;

  @override
  void initState()
  {
    _queVerInicialmente();
    _getAutos();
    this._widgetStarts = Container(
      width: 100,
      height: 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          colors: [
            Colors.yellow,
            Colors.grey[100],
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        )
      ),
    );

    this._lstAutos = Center(
      child: Padding(
        padding: EdgeInsets.only(top: 30),
        child: CircularProgressIndicator(),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    this._context = context;
    context = null;
    if(!this._isInit){
      this._isInit = true;
      appBarrMy.setContext(this._context);
    }
    final Map<String, dynamic> popBack = ModalRoute.of(this._context).settings.arguments;
    if(popBack != null) {
      if(!popBack.containsKey('popBack')){
        popBack['popBack'] = false;
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.red[100],
        drawer: MenuMain(),
        body: WillPopScope(
          onWillPop: () => Future.value(popBack['popBack']),
          child: _body(),
        ),
        bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false),
        floatingActionButton: (!this._isVistaHelp)
          ? null
          : FloatingActionButton(
            mini: true,
            child: Icon(Icons.help),
            onPressed: (){
              this._isVistaHelp = !this._isVistaHelp ;
              setState(() {});
            },
          )
      ),
    );
  }

  ///
  Widget _body()
  {
    List<Widget> vistas = [
      _introInfo(),
      _filtroInfo(),
      _flexibleInfo()
    ];
    
    return (this._isVistaHelp)
    ?
    CustomScrollView(
      slivers: <Widget>[
        appBarrMy.getAppBarrSliver(titulo: 'Registro de Autos', bgContent: _bgContentAppBarr()),
        _content()
      ]
    )
    :
    Container(
      child: Swiper(
        loop: false,
        itemCount: vistas.length,
        autoplay: false,
        controller: this._ctrlPages,
        pagination: new SwiperPagination(),
        itemBuilder: (BuildContext context, int index) {
          return vistas[index];
        },
      ),
    );
  }

  ///
  Widget _bgContentAppBarr()
  {
    return Image(
      image: AssetImage('assets/images/auto_ico.png'),
    );
  }

  ///
  SliverList  _content()
  {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const SizedBox(height: 30),
          InkWell(
            onTap: () async {
              String username = Provider.of<DataShared>(this._context, listen: false).username;
              if(username == 'Anónimo') {
                String body = 'Necesitas Registrarte si eres nuevo o Hacer Login si ya tienes una cuenta activa con ZonaMotora';
                await alertsVarios.entendido(this._context, titulo: 'AUTENTIÍCATE', body: body);
                Navigator.of(this._context).pushNamedAndRemoveUntil('index_page', (Route rutas) => false);
                return;
              }

              if(this._autosActuales >= this._autosPermitidos) {
                String body = 'Recuerda que sólo puedes colocar ${this._autosPermitidos} autos, puedes eliminar alguno que ya no necesites';
                alertsVarios.entendido(this._context, titulo: 'LIMITE PERMITIDO', body: body);
              }else{

                showDialogAddAuto();
              }
            },
            child: _addNewAuto(),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Guardados Actualmente',
              textScaleFactor: 1,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 19
              ),
            ),
          ),
          this._lstAutos,
          const SizedBox(height: 40),
        ]
      ),
    );
  }

  ///
  Future<void> showDialogAddAuto() async {
    
    await showDialog(
      context: this._context,
      builder: (_) {
        return AlertDialog(
          scrollable: true,
          contentPadding: EdgeInsets.all(0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FrmMkMdAnioWidget(),
              RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                icon: Icon(Icons.add, color: Colors.white),
                color: Colors.black,
                textColor: Colors.blue[400],
                onPressed: (){
                  _createNewAuto();
                },
                label: Text(
                  'Agregar Auto',
                  textScaleFactor: 1,
                ),
              ),
              SizedBox(height: 10)
            ],
          ),
        );
      }
    );
  }
  ///
  Widget _addNewAuto()
  {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 75,
      width: MediaQuery.of(this._context).size.width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            offset: Offset(1, 2)
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Icon(Icons.directions, color: Colors.white, size: 40),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'AGREGAR NUEVO AUTO',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                Divider(color: Colors.grey),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '${this._autosActuales}/${this._autosPermitidos}',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.grey
                      ),
                    ),
                    this._widgetStarts
                  ]
                )
              ],
            )
          )
        ],
      ),
    );
  }

  ///
  Future<bool> _getAutos() async
  {
    if(this._autos.isEmpty) {
      this._autos = await emMisAtos.getMisAutos();
    }

    setState(() {
      this._widgetStarts = Row(children: _calcularEstrellas());
      this._lstAutos = Column(children: _hacerListaDeAutos());
    });
    return false;
  }

  ///
  Future<void> _eliminarAuto(int idAuto) async
  {
    String body = 'Se eliminará permanentemente éste vehículo registrado,\n\n¿Estas segur@ de CONTINUAR?';
    bool acc = await alertsVarios.aceptarCancelar(this._context, titulo: 'ELIMINANDO', body: body);
    if(acc) {
      alertsVarios.cargando(this._context);
      Map<String, dynamic> res = await emMisAtos.deleteAutoParticularInServer(idAuto);
      Navigator.of(this._context).pop();
      if(!res['abort']){
        this._autos.removeWhere((auto) => (auto['idReg'] == idAuto));
         setState(() {
          this._widgetStarts = Row(children: _calcularEstrellas());
          this._lstAutos = Column(children: _hacerListaDeAutos());
        });
      }else{
        alertsVarios.entendido(this._context, titulo: res['msg'], body: res['body']);
      }
    }
    return;
  }

  ///
  Future<void> _editarAuto(int idAuto) async {

    Map<String, dynamic> auto = await emMisAtos.getAutoFromBDByIdAuto(idAuto);
    frmSng.setContext(this._context);
    frmSng.setCtrAnio(auto['anio']);
    frmSng.setCtrVersion(auto['version']);
    frmSng.txtModelo = auto['mdNombre'];
    frmSng.txtMarca = auto['mkNombre'];

  }

  ///
  List<Widget> _hacerListaDeAutos()
  {
    List<Widget> lstAutosLocal = new List();
    if(this._autos.isEmpty) {
      this._lstAutos = Center(
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            'Sin Autos por el momento',
            textScaleFactor: 1,
          ),
        ),
      );
    }else{

      this._autos.forEach((auto){
        lstAutosLocal.add(
          cardMiniAuto.printCard(
            idAuto: auto['idReg'],
            markMod: '${auto['mkNombre']} - ${auto['mdNombre']}',
            anio: auto['anio'],
            fechReg: DateTime.parse(auto['createdAt']),
            showAcc: true,
            fncEliminar: _eliminarAuto,
            fncEditar: _editarAuto
          )
        );
      });
    }

    return lstAutosLocal;
  }

  ///
  List<Widget> _calcularEstrellas()
  {
    List<Widget> lst = new List();
    this._autosActuales = this._autos.length;
    int numStarBorder = this._autosPermitidos - this._autos.length;
    for (var i = 0; i < numStarBorder; i++) {
      lst.add(
        Icon(Icons.star_border, size: 16, color: Colors.yellow[700])
      );
    }
    for (var i = 0; i < this._autosActuales; i++) {
      lst.add(
        Icon(Icons.star, size: 16, color: Colors.yellow[700])
      );
    }
    return lst;
  }
  
  ///
  Future<void> _queVerInicialmente() async
  {
    this._sess = await SharedPreferences.getInstance();
    this._isVistaHelp = this._sess.getBool(spConst.sp_isViewAutos);
    if(this._isVistaHelp == null){
      this._sess.setBool(spConst.sp_isViewAutos, false);
      this._isVistaHelp = false;
    }
    setState(() {});
  }

  /* Paginas de HELPS */

  Widget _introInfo()
  {
    return templatePageHelps.getTemplate(
      context: this._context,
      icono: Icons.directions_bus,
      titulo: '¿QUÉ AUTOS TE INTERESAN?',
      subTitulo: 'Dile a tu App, qué autos te interesan.\nSólo indica Marca, Modelo y Año.',
      body: 'Recibe información de primera mano, acerca de Ofertas, '
        +'Servicios, Accesorios y Refacciones exclusivas para tu automóvil.',
      accionEntendido: _accionEntendidoHelpPages,
      accionSiguinete: (){
        this._ctrlPages.next();
      }
    );
  }

  ///
  Widget _filtroInfo()
  {
    return templatePageHelps.getTemplate(
      context: this._context,
      icono: Icons.search,
      titulo: 'FILTROS AUTOMÁTICOS',
      subTitulo: '¿Para qué ver información de autos que no tienes?',
      body: 'Tu aplicación filtrará por ti todo lo que realmente te interesa, '
        +'sin perder la posibilidad de ver todo lo que ZonaMotora tiene para ti.',
      accionEntendido: _accionEntendidoHelpPages,
      accionSiguinete: (){
        this._ctrlPages.next();
      }
    );
  }

  ///
  Widget _flexibleInfo()
  {
    return templatePageHelps.getTemplate(
      context: this._context,
      icono: Icons.edit,
      titulo: 'INFORMACIÓN FLEXIBLE',
      subTitulo: 'Agrega y Elimina cuando quieras',
      body: 'ZonaMotora te permite agregar hasta 5 vehículos donde '
        +'podrás eliminarlos y agregar nuevos cuando quieras.',
      isFin : true,
      accionEntendido: _accionEntendidoHelpPages,
      accionSiguinete: (){
        this._ctrlPages.next();
      }
    );
  }

  ///
  void _accionEntendidoHelpPages()
  {
    this._sess.setBool(spConst.sp_isViewAutos, true);
    this._isVistaHelp = true;
    setState(() {});
  }

  ///
  Future<void> _createNewAuto() async {

    Map<String, dynamic> autoSeleccionado = {
      'idReg'   : 0,
      'mkid'    : buscarAutosSngt.idMarca,
      'mdid'    : buscarAutosSngt.idModelo,
      'mkNombre': frmSng.txtMarca,
      'mdNombre': frmSng.txtModelo,
      'anio'    : frmSng.ctrAnio.text,
      'version' : frmSng.ctrVersion.text,
    };

    alertsVarios.cargando(this._context, titulo: 'GUARDANDO', body: 'Se está almacenando la información de tu auto, por favor, espera un momento.');
    Map<String, dynamic> result = await emMisAtos.setNewMisAuto(autoSeleccionado);

    if(!result['abort']) {
      frmSng.resetScreen();
      Navigator.of(this._context).pushNamedAndRemoveUntil('mis_autos_page', (Route rutas) => false);
    }else{
      Navigator.of(this._context).pop();
      await alertsVarios.entendido(this._context, titulo: result['msg'], body: result['body']);
    }

  }

}