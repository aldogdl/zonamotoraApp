import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/app_varios_repository.dart';
import 'package:zonamotora/repository/autos_repository.dart';
import 'package:zonamotora/repository/publicar_repository.dart';
import 'package:zonamotora/singletons/buscar_autos_sngt.dart';
import 'package:zonamotora/singletons/config_gms_sngt.dart';
import 'package:zonamotora/singletons/frm_mk_md_anios_sngt.dart';
import 'package:zonamotora/singletons/tomar_imagenes_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/frm_mk_md_anio_widget.dart';
import 'package:zonamotora/widgets/load_sheetbutom_widget.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/tomar_imagenes_widget.dart';

class PublicarPage extends StatefulWidget {
  @override
  PublicarPageState createState() => PublicarPageState();
}

class PublicarPageState extends State<PublicarPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AutosRepository emAutos = AutosRepository();
  BuscarAutosSngt buscarAutosSngt = BuscarAutosSngt();
  ConfigGMSSngt configGMSSngt = ConfigGMSSngt();
  FrmMkMdAniosSngt frmSng = FrmMkMdAniosSngt();
  AlertsVarios alertsVarios = AlertsVarios();
  TomarImagenesSngt tomarImagenesSngt = TomarImagenesSngt();
  PublicarRepository emPublicar = PublicarRepository();
  FrmMkMdAniosSngt frmMkMdAniosSngt = FrmMkMdAniosSngt();
  AppVariosRepository emVarios = AppVariosRepository();

  String _titlePage = 'Publica tus Artículos';
  int _catSelecId = 0;
  int _sisSelecId = 0;

  String _txtCategoriaSeleccionada = 'SELECCIONA UNA...';
  String _txtSistemaSeleccionado = 'SELECCIONA UNO...';
  String _txtDespeqCategoSeleccionada = 'Las categorías organizan tu publicación de tal manera para que los posibles compradores puedan encontrarlas con mayor rapidez.';
  String _txtDespeqSistemaSeleccionado = 'Al colocar tu publicación dentro de un Sistema los consumidores pueden organizar tus publicaciónes con mejor detalle.';
  String _queProcesando = 'Procesando Imágenes';
  List<String> _fotosSalvadas = new List();
  List<Map<String, dynamic>> _sistemas = new List();
  Map<String, dynamic> _params = new Map();

  Size _screen;
  bool _isInit = true;
  bool _fotosSaved = false;
  bool _isShowLoad = false;
  bool _isShowPalClas = true;
  final int _maxFotos = 4;
  BuildContext _context;

  TextEditingController _queVendes = TextEditingController();
  TextEditingController _precio = TextEditingController();
  TextEditingController _descript = TextEditingController();
  TextEditingController _palClas = TextEditingController();
  FocusNode _focusQueVende = FocusNode();
  FocusNode _focusPrecio = FocusNode();
  FocusNode _focusDescript = FocusNode();
  FocusNode _focusPalClas = FocusNode();
  FocusNode _focusSistema = FocusNode();

  GlobalKey<ScaffoldState> _skfKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _frmKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_init);
    super.initState();
  }

  ///
  Future<void> _init(_) async {

    configGMSSngt.setContext(this._context);
    frmSng.setContext(this._context);
    Map<String, dynamic> proceRoto = {
      'nombre' : 'publicar',
      'metadata' : {'nada':'por momento'},
      'contents' : {'nada':'por momento'}
    };
    tomarImagenesSngt.proccRoto = proceRoto;
    DataShared proveedor = Provider.of<DataShared>(this._context, listen: false);
    proveedor.setLastPageVisit('publicar_page');
    _getSistemas();
  }

  @override
  void dispose() {
    this._queVendes?.dispose();
    this._precio?.dispose();
    this._descript?.dispose();
    this._scrollController?.dispose();
    this._palClas?.dispose();
    tomarImagenesSngt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(this._isInit){
      this._isInit = false;
      this._context = context;
      this._screen = MediaQuery.of(this._context).size;
    }
    context = null;
    this._params = ModalRoute.of(this._context).settings.arguments;

    return Scaffold(
      key: this._skfKey,
      appBar: appBarrMy.getAppBarr(titulo: this._titlePage),
      backgroundColor: Colors.white,
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: SingleChildScrollView(
          child: _body(),
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  ///
  Widget _body() {

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'QUIERO PUBLICAR...',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 19,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        FutureBuilder(
          future: _getCategos(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasData) {
              return _printFrm(snapshot.data);
            }
            return _containerInput(
              child: Text(
                'Cargando Categorías...'
              )
            );
          },
        ),
      ],
    );
  }

  ///
  Widget _printFrm(List<Map<String, dynamic>> categos) {

    TextStyle estilo = TextStyle(
      fontSize: 19,
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold
    );

    Map<String, dynamic> dataCatego = new Map();

    switch (this._params['publicar']) {
      case 1:
        // 'Autopartes'
        dataCatego = categos.firstWhere(
          (element) => element['cat_catego'] == 'Autopartes',
          orElse: () => new Map(),
        );
        break;
      case 2:
        // 'Vehículos'
        dataCatego = categos.firstWhere(
          (element) => element['cat_catego'] == 'Vehículos',
          orElse: () => new Map(),
        );
        break;
      case 3:
        // 'Servicios'
        dataCatego = categos.firstWhere(
          (element) => element['cat_catego'] == 'Servicios',
          orElse: () => new Map(),
        );
        break;
      default:
    }

    if(dataCatego.isEmpty){
      return SizedBox(height: 0);
    }

    this._txtCategoriaSeleccionada = dataCatego['cat_catego'].toUpperCase();
    this._txtDespeqCategoSeleccionada = dataCatego['cat_despeq'];
    this._catSelecId = dataCatego['cat_id'];
    this._titlePage = 'Publica tus ${this._txtCategoriaSeleccionada}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Categoría',
            textScaleFactor: 1,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blueGrey
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            '${this._txtCategoriaSeleccionada}',
            textScaleFactor: 1,
            textAlign: TextAlign.left,
            style: estilo,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '${this._txtDespeqCategoSeleccionada}',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.black
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: this._screen.width,
          height: this._screen.height * 0.20,
          color: Colors.grey.withAlpha(100),
          child: _seccionDeFotos()
        ),
        Form(
          key: this._frmKey,
          child: _frm(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical:10, horizontal: 20),
          child: Text(
            'Los artículos de ZonaMotora son públicos, por lo que cualquier persona ' +
            'dentro y fuera de ZonaMotora puede verlos.',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14
            ),
          ),
        )
      ],
    );
  }

  ///
  Widget _frm() {

    return Container(
      width: this._screen.width,
      color: Colors.white.withAlpha(100),
      child: (this._txtCategoriaSeleccionada.toLowerCase() == 'vehículos')
      ? _frmForAutos()
      : _frmForServsAndRefaccs(),
    );
  }

  ///
  Widget _seccionDeFotos() {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      width: this._screen.width,
      child: SingleChildScrollView(
        controller: this._scrollController,
        scrollDirection: Axis.horizontal,
        child: Consumer<DataShared>(
          builder: (_, dataShared, __){
            if(dataShared.refreshWidget > -1) {
              return _listDeImages();
            }else{
              return _widgetParaTomarLaFoto();
            }
          },
        ),
      ),
    );
  }

  ///
  Widget _listDeImages() {

    if(tomarImagenesSngt.imagesAsset.length == 0){
      this._scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
      return _widgetParaTomarLaFoto();
    }

    return Row(
      children: _crearListaDeImages()
    );
  }

  //
  List<Widget> _crearListaDeImages() {

    double anchoWidget = this._screen.width * 0.20;

    List<Widget> images = tomarImagenesSngt.imagesAsset.map((Map<String, dynamic> e) {

      return Container(
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Container(
              width: anchoWidget,
              height: this._screen.height * 0.13,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red
                )
              ),
              child: tomarImagenesSngt.convertImageToAsset(e['imagen']),
            ),
            Positioned(
              top: -7,
              left: 1,
              child: InkWell(
                onTap: () async {
                  await tomarImagenesSngt.delImagenById(e['id']);
                  int hasFotos = (tomarImagenesSngt.imagesAsset.length == 0) ? -1 : tomarImagenesSngt.imagesAsset.length;
                  Provider.of<DataShared>(this._context, listen: false).setRefreshWidget(hasFotos);
                  setState(() { });
                },
                child: Container(
                  height: 27,
                  width: 27,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.red,
                    )
                  ),
                  child: Center(
                    child: Icon(Icons.close, size: 17,),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();

    images.add(_widgetParaTomarLaFoto());
    this._scrollController.animateTo((tomarImagenesSngt.imagesAsset.length * anchoWidget), duration: Duration(milliseconds: 500), curve: Curves.ease);
    return images;
  }

  ///
  Widget _widgetParaTomarLaFoto() {

    if(tomarImagenesSngt.imagesAsset.length == this._maxFotos){
      return Container(height: 0);
    }

    return Container(
      width: 90,
      height: 90,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.red.withAlpha(150)
        )
      ),
      child: TomarImagenWidget(
        actionBarTitle: 'SELECCIONAR...',
        contextFrom: this._context,
        maxImages: (tomarImagenesSngt.imagesAsset.length == 0) ? this._maxFotos : (this._maxFotos-tomarImagenesSngt.imagesAsset.length),
        isMultiple: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.camera_enhance, size: 30, color: Colors.red.withAlpha(190)),
            Text(
              'Fotos',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red.withAlpha(100)
              ),
            )
          ],
        ),
      ),
    );
  }
  
  ///
  Widget _frmForAutos() {

    this._isShowPalClas = false;

    return Column(
      children: [
        _widgetInputQueVendes('¿Que Auto?', _verDialogParaAutos),
        _widgetInputDescript(null),
        _widgetInputPrecio(),
        const SizedBox(height: 20),
        _btnPublicar(accion: _saveData)
      ],
    );
  }

  ///
  Widget _frmForServsAndRefaccs() {

    this._isShowPalClas = true;
    return Column(
      children: [
        _widgetInputQueVendes('¿Qué Vendes?', null),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '${this._txtDespeqSistemaSeleccionado}',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14
            ),
          ),
        ),
        _widgetDropdownSistemas(),
        _widgetInputDescript(this._focusPalClas),
        _widgetInputPrecio(),
        _widgetInputPalClas(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Utiliza sinónimos como: cofre, capo  ||  facia, defensa, parachoques etc.',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 13
            ),
          ),
        ),
        const SizedBox(height: 20),
        _btnPublicar(accion: _saveData)
      ],
    );
  }

  ///
  Widget _containerInput({Widget child}) {

    return Container(
      width: this._screen.width,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: EdgeInsets.symmetric(horizontal: this._screen.width * 0.06, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.grey
            )
          ),
          child: child
    );
  }

  ///
  Widget _widgetInputQueVendes(String label, Function onTap) {

    IconData prefixIcon = (!this._isShowPalClas) ? Icons.directions_car : Icons.category;
    return _containerInput(
      child: _inputTypeText(
        controller: this._queVendes,
        focus: this._focusQueVende,
        focusNext: (this._isShowPalClas) ? this._focusSistema : this._focusDescript,
        action: TextInputAction.next,
        label: label,
        prefixIcon: prefixIcon,
        helpText: (label.contains('Auto')) ? 'Ej. Modelo, Año, Marca' : 'Indica el Título de tu Publicación',
        validate: _validarTitulo,
        onTap: onTap,
      )
    );
  }

  ///
  Widget _widgetDropdownSistemas() {

    return FutureBuilder(
      future: _getSistemas(),
      builder: (_, AsyncSnapshot snapshot) {
        if(this._sistemas.length > 0) {
          return _containerInput(
            child: _createDropdownSistemas()
          );
        }
        return _containerInput(
          child: Text('Cargando Sistemas')
        );
      },
    );
  }

  ///
  Widget _createDropdownSistemas() {

    TextStyle estilo = TextStyle(
      fontSize: 19,
      color: Colors.orange,
      fontWeight: FontWeight.bold
    );
    
    List<DropdownMenuItem> widgetSistemas = new List<DropdownMenuItem>();

    this._sistemas.forEach((sistema){
      
      widgetSistemas.add(
        DropdownMenuItem(
          child: Row(
            children: [
              Icon(Icons.bubble_chart, color: Colors.grey),
              const SizedBox(width: 10),
              Text(
                '${sistema['sa_nombre'].toUpperCase()}',
                textScaleFactor: 1,
                style: estilo,
              )
            ],
          ),
          value: sistema['sa_id'],
        )
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Sistemas Automotrices',
          textScaleFactor: 1,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14,
            color: Colors.blueGrey
          ),
        ),
        DropdownButton(
          focusNode: this._focusSistema,
          isDense: true,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down),
          iconEnabledColor: Colors.orange,
          iconSize: 30,
          underline: const SizedBox(width: 0),
          onChanged: (final valorSeleccionado){
            int index = this._sistemas.indexWhere((sist) => sist['sa_id'] == valorSeleccionado);
            this._txtSistemaSeleccionado = this._sistemas[index]['sa_nombre'].toUpperCase();
            this._txtDespeqSistemaSeleccionado = this._sistemas[index]['sa_despeq'];
            this._sisSelecId = this._sistemas[index]['sa_id'];
            FocusScope.of(this._context).requestFocus(this._focusDescript);
            setState(() {});
          },
          hint: Text(
            this._txtSistemaSeleccionado,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue
            ),
          ),
          items: widgetSistemas,
        )
      ],
    );
  }

  ///
  Widget _widgetInputDescript(FocusNode focusNext) {

    return _containerInput(
      child: _inputTypeText(
        controller: this._descript,
        focus: this._focusDescript,
        focusNext: focusNext,
        action: TextInputAction.newline,
        type: TextInputType.multiline,
        maxLines: 5,
        label: 'Descripción:',
        helpText: 'Incluye detalles; como daños, garantias, número de propietarios y nacionalidad etc.',
        validate: _validarDescript,
        onTap: null
      )
    );
  }
  
    ///
  Widget _widgetInputPrecio() {

    return _containerInput(
      child: _inputTypeText(
        controller: this._precio,
        focus: this._focusPrecio,
        focusNext: (this._isShowPalClas) ? this._focusPalClas : null,
        action: TextInputAction.next,
        type: TextInputType.number,
        label: 'Precio:',
        helpText: '',
        prefixIcon: Icons.monetization_on,
        onTap: null,
        validate: _validarPrecio
      )
    );
  }

  ///
  Widget _widgetInputPalClas() {

    return _containerInput(
      child: _inputTypeText(
        controller: this._palClas,
        focus: this._focusPalClas,
        action: TextInputAction.done,
        prefixIcon: Icons.search,
        label: 'Palabras Claves:',
        helpText: 'Separa con coma(,) las Palabras que relaciones tu artículo, para que sea más fácil de encontrar.',
        onTap: null,
        validate: _validarPalClas
      )
    );
  }

  ///
  Widget _inputTypeText({
    TextEditingController controller,
    FocusNode focus,
    FocusNode focusNext,
    TextInputAction action,
    TextInputType type,
    int maxLines = 1,
    String label,
    String helpText,
    IconData prefixIcon,
    Function validate,
    Function onTap,
  }) {

    return TextFormField(
      controller: controller,
      focusNode: focus,
      textInputAction: action,
      keyboardType: type,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: InputBorder.none,
        helperText: helpText,
        helperMaxLines: 2,
        suffixIcon: Icon(prefixIcon, color: Colors.black54),
        errorStyle: TextStyle(
          backgroundColor: Colors.red[100],
          color: Colors.black
        )
      ),
      onFieldSubmitted: (String valor){
        focusNext = (focusNext == null) ? new FocusNode() : focusNext;
        FocusScope.of(this._context).requestFocus(focusNext);
      },
      validator: (String valor) => validate(valor),
      onTap: () async => (onTap == null) ? null : await onTap(),
    );
  }

  ///
  Widget _btnPublicar({
    titulo: 'Publicar Anuncio',
    Function accion
  }) {

    return  SizedBox(
      width: this._screen.width * 0.85,
      height: 40,
      child: RaisedButton.icon(
        onPressed: () async => await accion(),
        color: Color(0xff002f51),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2)
        ),
        icon: Icon(Icons.save, color: Colors.white),
        label: Text(
          '$titulo'
        ),
      ),
    );
  }

  ///
  Future<void> _verDialogParaAutos() async {

    await showDialog(
      barrierDismissible: false,
      useSafeArea: true,
      context: this._context,
      builder: (BuildContext contextDialog) {

        return AlertDialog(
          scrollable: true,
          insetPadding: EdgeInsets.all(5),
          contentPadding: EdgeInsets.all(2),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 13),
                    child: Text(
                      'SELECCIONA TU AUTO',
                      textScaleFactor: 1,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  FlatButton.icon(
                    padding: EdgeInsets.all(0),
                    icon: Icon(Icons.close, size: 35, color: Colors.red),
                    onPressed: () => Navigator.of(this._context).pop(false),
                    label: Text(''),
                  )
                ],
              ),
              FrmMkMdAnioWidget(
                context: contextDialog,
              ),
              const SizedBox(height: 20),
              _btnPublicar(
                titulo: 'LISTO',
                accion: () async {
                  bool isValid = await frmMkMdAniosSngt.isValid();
                  if(isValid){
                    String auto = '${frmMkMdAniosSngt.txtModelo} año: ${frmMkMdAniosSngt.ctrAnio.text} de ${frmMkMdAniosSngt.txtMarca}';
                    this._descript.text = frmMkMdAniosSngt.ctrVersion.text;
                    this._queVendes.text = auto;
                    this._descript.text = frmMkMdAniosSngt.ctrVersion.text;
                    Navigator.of(this._context).pop(true);
                  }
                }
              ),
              const SizedBox(height: 10)
            ],
          ),
        );
      }
    );
  }

  ///
  Future<bool> _saveData() async {

    bool saveData = true;
    if(!this._frmKey.currentState.validate()){
      return _errorEnElFormulario();
    }
    if(!await _validarCategosAndSistemas()){ return false; }


    this._queProcesando = 'Procesando Imágenes';
    _showPageCargando();

    if(!this._fotosSaved){
      List<Map<String, dynamic>> fotosForSend = await _prepararFotos();

      if(fotosForSend.length > 0){
        saveData = await emPublicar.subirFotoByPublicacion(fotosForSend);
        if(!emPublicar.result['abort']){
          this._fotosSalvadas = new List<String>.from(emPublicar.result['body']);
          this._fotosSaved = true;
        }else{
          if(this._isShowLoad){ Navigator.of(this._context).pop(); }
          _resetFotosProcess();
          await alertsVarios.entendido(this._context, titulo: emPublicar.result['msg'], body: emPublicar.result['body']);
          return false;
        }
      }else{
        if(this._isShowLoad){ Navigator.of(this._context).pop(); }
        String body = 'Al menos coloca una fotografía para tu publicación, por favor';
        await alertsVarios.entendido(this._context, titulo: 'ALERTA FOTOGRÁFICA', body: body);
        return false;
      }
    }

    if(saveData && this._fotosSalvadas.length > 0){
      setState(() {
        this._queProcesando = 'Enviado la Data...';
      });
      bool res = await _enviarData();
      if(this._isShowLoad){ Navigator.of(this._context).pop(); }

      if(res){
        _resetControllers();
        Navigator.of(this._context).pushReplacementNamed('publicar_page');
        return false;
      }else{
        if(emPublicar.result['abort']){
          await alertsVarios.entendido(this._context, titulo: emPublicar.result['msg'], body: emPublicar.result['body']);
          return false;
        }
      }
    }

    return true;
  }

  ///
  void _showPageCargando() {

    setState(() {
      this._isShowLoad = true;
    });
    Future<void> sheet = showModalBottomSheet(
      context: this._context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (_) {

        return LoadSheetButtomWidget(
          menssage: 'Espera un momento, estamos procesando tu solicitud',
          queProcesando: this._queProcesando,
        );
      }
    );
    sheet.then((void value) => _cerrarSheetLoad());
  }

  ///
  void _cerrarSheetLoad() {
    this._isShowLoad = false;
  }

  ///
  Future<void> _resetFotosProcess() async {

    tomarImagenesSngt.imagesAsset.map((e) {
      e['status'] = 'new';
    });
  }

  ///
  void _resetControllers() {

    this._queVendes.text = '';
    this._descript.text = '';
    this._precio.text = '';
    this._palClas.text = '';
    this._sisSelecId = 0;
    this._txtSistemaSeleccionado = 'SELECCIONA UNO...';
    this._txtDespeqSistemaSeleccionado = 'Al colocar tu publicación dentro de un Sistema los consumidores pueden organizar tus publicaciónes con mejor detalle.';
    frmMkMdAniosSngt.setCtrAnio(0);
    frmMkMdAniosSngt.setCtrVersion('');
    frmMkMdAniosSngt.txtMarca = '';
    frmMkMdAniosSngt.txtModelo = '';
    tomarImagenesSngt.imagesAsset.clear();
    FocusScope.of(this._context).requestFocus(this._focusQueVende);
    setState(() { });
  }

  ///
  String _validarTitulo(String valor) {

    if(valor.length < 5) {
      return '   Se más específico en el Titulo   ';
    }
    return null;
  }

  ///
  String _validarPrecio(String valor) {

    if(valor.length < 2) {
      return '   Se más específico en el Precio   ';
    }
    return null;
  }

  ///
  String _validarDescript(String valor) {

    if(valor.length < 25) {
      return '   Se más específico en la Descripción   ';
    }
    return null;
  }

  ///
  String _validarPalClas(String txt) {

    List<String> newString = new List();
    Map<String, String> txtSinAcentos = {'á':'a','é':'e','í':'i','ó':'o','ú':'u'};

    List<String> palabras = txt.split(',');
    palabras.forEach((palabra){
      RegExp exp = RegExp(r'[áéíóú]');
      palabra = palabra.replaceAllMapped(exp, (m){
        return txtSinAcentos[m.group(0)];
      });
      if(palabra.length < 3) {
        return 'Se más específico con $palabra';
      }
      newString.add(palabra.trim().toLowerCase());
    });

    if(newString.length > 0){
      this._palClas.text = newString.join(',');
    }
    return null;
  }

  ///
  Future<bool> _validarCategosAndSistemas() async {

    bool showError = false;
    String titulo = '';
    String body = '';
    
    if(this._catSelecId == 0){
      titulo = 'CATEGORÍA';
      body = 'Es importante que selecciones la categoría de tu publicación, por favor';
      showError = true;
    }
    if(this._isShowPalClas){
      if(this._sisSelecId == 0) {
        titulo = 'SISTEMA DEL AUTO';
        body = 'Necesitas seleccionar un Sistema Automotriz al cual pertenece tu producto o servicio, por favor';
        showError = true;
      }
    }
    if(showError){
      await alertsVarios.entendido(this._context, titulo: titulo, body: body);
      FocusScope.of(this._context).requestFocus(this._focusSistema);
      return false;
    }
    return true;
  }

  ///
  Future<List<Map<String, dynamic>>> _prepararFotos() async {

    bool listo = false;
    List<Map<String, dynamic>> fotosForSend = new List();

    while (!listo) {
      int indexFoto = tomarImagenesSngt.imagesAsset.indexWhere((element) =>  element['status'] != 'process');
      if(indexFoto != -1){    
        Map<String, dynamic> ft = await tomarImagenesSngt.getImageForSend(otraImagen: tomarImagenesSngt.imagesAsset[indexFoto]['imagen']);
        if(ft.containsKey('img')){
          if(ft['img'].length > 20) {
            tomarImagenesSngt.imagesAsset[indexFoto]['status'] = 'process';
            ft['id'] = tomarImagenesSngt.imagesAsset[indexFoto]['id'];
            ft['nombreAlt'] = this._skfKey.hashCode;
            fotosForSend.add(ft);
          }
        }
      }else{
        listo = true;
      }
    }

    return fotosForSend;
  }

  ///
  Future<bool> _enviarData() async {

    Map<String, dynamic> data = {
      'fotos': this._fotosSalvadas,
      'catego': this._catSelecId,
      'queVendes' : this._queVendes.text,
      'sistema' : this._sisSelecId,
      'descripcion': this._descript.text,
      'precio': this._precio.text,
      'palclas': this._palClas.text
    };
    return await emPublicar.sendDataByPublicacion(data);
  }

  ///
  Future<List<Map<String, dynamic>>> _getCategos() async {

    return  await emVarios.getCategosToLocal();
  }

  ///
  Future<bool> _getSistemas() async {

    if(this._sistemas.isNotEmpty){ return true; }

    this._sistemas = await emVarios.getSistemas();
    return (this._sistemas.isEmpty) ? false : true;
  }

  ///
  bool _errorEnElFormulario() {

    SnackBar snackbar = SnackBar(
      content: Container(
        width: this._screen.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        color: Colors.red,
        child: Text(
          'ERROR EN EL FORMULARIO',
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.yellow,
            fontSize: 18
          ),
        ),
      ),
    );
    this._skfKey.currentState.showSnackBar(snackbar);
    return false;
  }

}