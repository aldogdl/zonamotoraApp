import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:zonamotora/singletons/solicitud_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';

class FichaRefaccionesWidget extends StatefulWidget {

  final int indexPieza;
  final Map<String, dynamic> pieza;
  final Future<void> Function(int) accionEliminar;
  final Future<void> Function(int) accionEditar;
  final Future<bool> Function(int) makeBackUp;

  FichaRefaccionesWidget(
    this.indexPieza,
    this.pieza,
    this.accionEliminar,
    this.accionEditar,
    this.makeBackUp
  );

  @override
  _FichaRefaccionesWidgetState createState() => _FichaRefaccionesWidgetState();
}

class _FichaRefaccionesWidgetState extends State<FichaRefaccionesWidget> {

  SolicitudSngt solicitudSgtn = SolicitudSngt();
  AlertsVarios alertsVarios = AlertsVarios();
  
  BuildContext _context;
  Widget _widgetImage;
  Size _screen;

  @override
  void initState() {
    solicitudSgtn.idAutoForEdit = null;
    this._widgetImage = Image(image: AssetImage('assets/images/no-image.png'), fit: BoxFit.contain);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    this._screen  = MediaQuery.of(context).size;
    context = null;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: this._screen.width * 0.05, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(1, 2),
            color: Colors.black38
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _fotoContainer(),
          _laPieza(),
          Divider(height: 2, color: Colors.green),
          _pieFicha(),
        ],
      ),
    );
  }

  ///
  Widget _fotoContainer() {

    this._widgetImage = Image(image: AssetImage('assets/images/no-image.png'), fit: BoxFit.contain);
    
    if(solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'][widget.indexPieza].containsKey('foto')){
      if(solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'][widget.indexPieza]['foto'] != null) {
        if(solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'][widget.indexPieza]['foto'].containsKey('nombre')){
          if(solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'][widget.indexPieza]['foto']['nombre'] != null){  
            Asset assetImage = solicitudSgtn.fotoFromJsonToAsset(widget.indexPieza);
            this._widgetImage = Container(
              width: MediaQuery.of(this._context).size.width,
              height: MediaQuery.of(this._context).size.height * 0.4,
              child: AssetThumb(asset: assetImage, width: solicitudSgtn.thubFachadaX, height: solicitudSgtn.thubFachadaY),
            );
          }
        }
      }
    }

    return Container(
      width: this._screen.width,
      height: this._screen.height * 0.2,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10)
              ),
              child: Container(
                width: this._screen.width,
                height: this._screen.height * 0.2,
                color: Colors.grey[100],
                child: this._widgetImage
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Text(
              '# ${solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'][widget.indexPieza]['id']}',
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                shadows: [
                  BoxShadow(
                    blurRadius: 2,
                    offset: Offset(1, 2),
                    color: Colors.black54
                  )
                ]
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 5,
            child: RaisedButton(
              color: Colors.red[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              child: Text(
                'Tomar Foto',
                textScaleFactor: 1,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onPressed: () async {
                bool res = await widget.makeBackUp(widget.indexPieza);
                if(!res){
                  // Alertar de error al realizar el backup
                  print('Ocurrio error al guardar Backup');
                }
                if(res) {
                  _loadAssets();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  
  ///
  Future<void> _loadAssets() async {

    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: MaterialOptions(
          actionBarTitle: "Pieza Solicitada",
          allViewTitle:   "Todas las Fotos",
          selectionLimitReachedText: 'Haz llegado al limite',
          textOnNothingSelected: 'No se ha seleccionado nada',
          lightStatusBar: false,
          useDetailsView: false,
          actionBarColor: "#7C0000",
          statusBarColor: "#7C0000",
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      //this._error = e.toString();
      print(e.toString());
    }

    if (!mounted) return;

    if(resultList != null){

      setState(() {
        if(resultList.first.isLandscape){
          solicitudSgtn.setFotoPieza(resultList.first, solicitudSgtn.autoEnJuego['indexAuto'], widget.indexPieza);
          this._widgetImage = Container(
            width: MediaQuery.of(this._context).size.width,
            height: MediaQuery.of(this._context).size.height * 0.4,
            child: AssetThumb(asset: resultList.first, width: solicitudSgtn.thubFachadaX, height: solicitudSgtn.thubFachadaY),
          );

        }else{
          String body = 'El sistema acepta sólo imágenes HORIZONTALES.';
          resultList = null;
          alertsVarios.entendido(this._context, titulo: 'RECOMENDACIÓN', body:body);
        }
      });
    }
  }

  ///
  Widget _laPieza() {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.extension, color: Colors.grey[500]),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${ widget.pieza['pieza'].toUpperCase() }',
                textScaleFactor: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(
                '${ widget.pieza['lado'] }',
                textScaleFactor: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.green[600]
                ),
              ),
              Text(
                '${ widget.pieza['posicion'] }',
                textScaleFactor: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.grey
                ),
              )
            ],
          ),
          
        ],
      )
    );
  }

  ///
  Widget _pieFicha() {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _cantidades(),
          _btnsAccion()
        ],
      ),
    );
  }

  ///
  Widget _cantidades() {

    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                height: 35,
                width: 35,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)
                  ),
                  padding: EdgeInsets.all(0),
                  child: Icon(Icons.keyboard_arrow_down),
                  onPressed: (){
                    setState((){
                      if(solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'][widget.indexPieza]['cant'] <= 1){
                        solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'][widget.indexPieza]['cant'] = 1;
                      }else{
                        solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'][widget.indexPieza]['cant']--;
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 35,
                width: 35,
                margin: EdgeInsets.only(right: 3),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Center(
                  child: Text(
                    '${solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'][widget.indexPieza]['cant']}',
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[50]
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 35,
                width: 35,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)
                  ),
                  padding: EdgeInsets.all(0),
                  child: Icon(Icons.keyboard_arrow_up),
                  onPressed: (){
                    setState((){
                      solicitudSgtn.autos[solicitudSgtn.autoEnJuego['indexAuto']]['piezas'][widget.indexPieza]['cant']++;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          SizedBox(
            width: 130,
            child: Center(
              child: Text(
                'Cantidades',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ///
  Widget _btnsAccion() {

    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _btnEliminar(),
              const SizedBox(width: 20),
              _btnEditar(),
            ],
          ),
          const SizedBox(height: 7),
          SizedBox(
            width: 100,
            child: Center(
              child: Text(
                'Gestión',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  letterSpacing: 1.2
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ///
  Widget _btnEliminar() {

    return InkWell(
      child: CircleAvatar(
        child: Icon(Icons.delete),
      ),
      onTap: () async => widget.accionEliminar(widget.indexPieza),
    );
  }

  ///
  Widget _btnEditar() {

    return InkWell(
      child: CircleAvatar(
        backgroundColor: Colors.orange,
        child: Icon(Icons.edit, color: Colors.white),
      ),
      onTap: () => widget.accionEditar(widget.pieza['id']),
    );
  }

}