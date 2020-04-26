import 'package:flutter/material.dart';
import 'package:zonamotora/singletons/solicitud_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';

class FichaDelAutoWidget extends StatefulWidget {

  final int indexAuto;
  final Future<void> Function(int) borrarAuto;
  FichaDelAutoWidget(this.indexAuto, this.borrarAuto);

  @override
  _FichaDelAutoWidgetState createState() => _FichaDelAutoWidgetState();
}

class _FichaDelAutoWidgetState extends State<FichaDelAutoWidget> {

  SolicitudSngt solicitudSgtn = SolicitudSngt();
  AlertsVarios alertsVarios   = AlertsVarios();

  BuildContext _context;
  TextEditingController _ctrAnio = TextEditingController();
  TextEditingController _ctrVersion = TextEditingController();
  FocusNode _focusAnio = FocusNode();
  bool _hasAnio = false;
  bool _hasVersion = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_hidratarCampos);
    super.initState();
  }

  @override
  void dispose() {
    this._ctrAnio.dispose();
    this._ctrVersion.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;

    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: Offset(1,2),
              color: Colors.red
            )
          ]
        ),
        child: Container(
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: <Widget>[
              _autoAndAnio(),
              const SizedBox(height: 7),
              _inputVersion(),
              const SizedBox(height: 5),
              _piezasAndDelete(),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void _hidratarCampos(_) {

    if(solicitudSgtn.autos[widget.indexAuto].containsKey('anio')){
      this._ctrAnio.text = solicitudSgtn.autos[widget.indexAuto]['anio'];
      if(this._ctrAnio.text.length > 3){
        this._hasAnio = true;
      }
    }
    if(solicitudSgtn.autos[widget.indexAuto].containsKey('version')){
      this._ctrVersion.text = solicitudSgtn.autos[widget.indexAuto]['version'];
      this._hasVersion = true;
    }
    setState(() {});
  }

  ///
  Widget _autoAndAnio() {

    bool showInputAnio = false;
    if(solicitudSgtn.autos[widget.indexAuto].containsKey('piezas')){
      if(solicitudSgtn.autos[widget.indexAuto]['piezas'].length > 0){
        showInputAnio = true;
      }
    }

    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(
            child: Image(
              image: AssetImage('assets/images/auto.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          flex: (showInputAnio) ? 4 : 6,
          child: InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  solicitudSgtn.autos[widget.indexAuto]['md_nombre'],
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold  
                  ),
                ),
                Text(
                  solicitudSgtn.autos[widget.indexAuto]['mk_nombre'],
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.grey
                  ),
                )
              ],
            ),
            onTap: () => Navigator.of(this._context).pushNamedAndRemoveUntil(
              'gestion_piezas_page', (Route rutas) => false,
              arguments: {'indexAuto': widget.indexAuto}
            )
          ),
        ),
        (showInputAnio)
        ?
        Expanded(
          flex: 2,
          child: _inputAnio(),
        )
        :
        const SizedBox(width: 0),
      ],
    );
  }
  
  ///
  Widget _inputAnio() {

    return TextField(
      controller: this._ctrAnio,
      focusNode: this._focusAnio,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      maxLength: 4,
      decoration: InputDecoration(
        filled: true,
        counter: const SizedBox(height: 0, width: 0),
        fillColor: Colors.white,
        hintText: 'AÑO?',
        hintStyle: TextStyle(
          color: Colors.grey[400],
        )
      ),
      onChanged: (String anio){
        this._hasAnio = (anio.length > 3) ? true : false;
        solicitudSgtn.setAnio(widget.indexAuto, anio);
        setState(() {});
      },
      onSubmitted: (String val){
        this._hasAnio = (val.length > 3) ? true : false;
      },
    );
  }

  ///
  Widget _inputVersion() {

    bool showInputAnio = false;
    if(solicitudSgtn.autos[widget.indexAuto].containsKey('piezas')){
      if(solicitudSgtn.autos[widget.indexAuto]['piezas'].length > 0){
        showInputAnio = true;
      }
    }
    if(!showInputAnio) {
      return const SizedBox(height: 0);
    }

    return Column(
      children: <Widget>[
        TextField(
          controller: this._ctrVersion,
          onChanged: (String version){
            this._hasVersion = (version.length > 0) ? true : false;
            solicitudSgtn.setVersion(widget.indexAuto, version);
            setState(() {});
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Ej. deportivo, z2x, hatchback etc...',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 15
            )
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Coloca la versión o características del auto',
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black38
          ),
        ),
      ],
    );
  }

  ///
  Widget _piezasAndDelete() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          child: CircleAvatar(
            child: Icon(Icons.delete),
          ),
          onTap: () async => widget.borrarAuto(widget.indexAuto),
        ),
        _estrellasFichaDeAuto(),
        _btnSusPiezas()
      ],
    );
  }
  
  ///
  Widget _estrellasFichaDeAuto() {

    int cantPiezas = 0;
    if(solicitudSgtn.autos[widget.indexAuto].containsKey('piezas')){
      cantPiezas = solicitudSgtn.autos[widget.indexAuto]['piezas'].length;
    }

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            (this._hasAnio)
            ?
            Icon(Icons.star, size: 20, color: Colors.amber)
            :
            Icon(Icons.star_border, size: 20, color: Colors.amber),
            (this._hasVersion)
            ?
            Icon(Icons.star, size: 20, color: Colors.amber)
            :
            Icon(Icons.star_border, size: 20, color: Colors.amber),
            (cantPiezas == 0)
            ?
            Icon(Icons.star_border, size: 20, color: Colors.amber)
            :
            Icon(Icons.star, size: 20, color: Colors.amber),
          ],
        ),
        Text(
          '$cantPiezas Piezas',
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 14
          ),
        )
      ],
    );
  }

  ///
  Widget _btnSusPiezas() {

    return FlatButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      color: Colors.blue,
      padding: EdgeInsets.symmetric(horizontal: 7),
      label: Text(
        'Sus Piezas',
        textScaleFactor: 1,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
      ),
      icon: Icon(Icons.add_circle, color: Colors.blue[100]),
      onPressed: () {

        solicitudSgtn.setAutoEnJuegoIndexAuto(widget.indexAuto);
        solicitudSgtn.addMapParaAddPiezas();
        if(solicitudSgtn.autos[widget.indexAuto].containsKey('piezas')){
          if(solicitudSgtn.autos[widget.indexAuto]['piezas'].length > 0) {
            solicitudSgtn.paginaVista = 1;
          }
        }
        Navigator.of(this._context).pushNamedAndRemoveUntil(
          'gestion_piezas_page', (Route rutas) => false,
          arguments: {'indexAuto': widget.indexAuto}
        );
      }
    );
  }
}