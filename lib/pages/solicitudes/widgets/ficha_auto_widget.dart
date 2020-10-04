import 'package:flutter/material.dart';
import 'package:zonamotora/singletons/buscar_autos_sngt.dart';
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
  BuscarAutosSngt buscarAutosSngt = BuscarAutosSngt();

  BuildContext _context;
  bool _hasAnio = false;
  bool _hasVersion = false;
  int _indexAuto;

  @override
  void initState() {
    this._indexAuto = widget.indexAuto;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    if(solicitudSgtn.autos[this._indexAuto]['version'] != '0'){
      this._hasVersion = true;
    }
    if(solicitudSgtn.autos[this._indexAuto]['anio'] != '0'){
      this._hasAnio = true;
    }

    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey[400]
          )
        ),
        child: Container(
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _autoAndAnioAndStarts(),
              const SizedBox(height: 7),
              _txtVersion(),
              const SizedBox(height: 5),
              Divider(),
              _accionesAndPiezas(),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _autoAndAnioAndStarts() {

    bool showInputAnio = false;
    if(solicitudSgtn.autos[this._indexAuto].containsKey('piezas')){
      if(solicitudSgtn.autos[this._indexAuto]['piezas'].length > 0){
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
                  solicitudSgtn.autos[this._indexAuto]['md_nombre'],
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold  
                  ),
                ),
                Text(
                  solicitudSgtn.autos[this._indexAuto]['mk_nombre'],
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
              arguments: {'indexAuto': this._indexAuto}
            )
          ),
        ),
        Column(
          children: <Widget>[
            Text(
              '${ solicitudSgtn.autos[this._indexAuto]['anio']}',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 23,
                color: Colors.blueGrey
              ),
            ),
            _estrellas()
          ],
        )
      ],
    );
  }
  
  ///
  Widget _txtVersion() {

    String version = 'Sin versión';
    if(this._hasVersion){
      version = solicitudSgtn.autos[this._indexAuto]['version'];
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        '$version',
        textScaleFactor: 1,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 15,
          letterSpacing: 0.6,
          color: Colors.blueGrey
        ),
      )
    );
  }

  ///
  Widget _accionesAndPiezas() {

    int cantPiezas = 0;
    if(solicitudSgtn.autos[this._indexAuto].containsKey('piezas')){
      cantPiezas = solicitudSgtn.autos[this._indexAuto]['piezas'].length;
    }
    String plural = (cantPiezas == 0) ? 's' : (cantPiezas > 1) ? 's' : '';
    String sufixPiezas = (solicitudSgtn.onlyRead) ? 'Contiene' : 'Actualmente';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: (solicitudSgtn.onlyRead) ? _dataCotizacion() : _btnDeleteAndEdit(),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget> [
              _btnPiezas(),
              Text(
                '$sufixPiezas $cantPiezas Pieza$plural',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13
                ),
              )
            ]
          )
        )
      ],
    );
  }

  ///
  Widget _dataCotizacion() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Enviada:',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 13,
            fontWeight: FontWeight.bold
          ),
        ),
        Row(
          children: <Widget>[
            Text(
              'AYER',
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              '2:00 p.m.',
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(5)
          ),
          child: Text(
            ' EN COLA ',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  ///
  Widget _btnDeleteAndEdit() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            InkWell(
              child: CircleAvatar(
                radius: 19,
                child: Icon(Icons.delete),
              ),
              onTap: () async => widget.borrarAuto(this._indexAuto),
            ),
            InkWell(
              child: CircleAvatar(
                radius: 19,
                backgroundColor: Colors.blue,
                child: Icon(Icons.edit, color: Colors.white),
              ),
              onTap: () async => _editarAuto(),
            ),
          ],
        ),
        const SizedBox(height: 7),
        const Text(
          'Automóvil',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13
          ),
        )  
      ],
    );
  }

  ///
  Widget _btnPiezas() {

    int cantPiezas = 0;
    if(solicitudSgtn.autos[this._indexAuto].containsKey('piezas')){
      cantPiezas = solicitudSgtn.autos[this._indexAuto]['piezas'].length;
    }

    return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      color: (cantPiezas > 0) ? Colors.orange : Colors.red,
      child: Text(
        (cantPiezas > 0)
        ? (solicitudSgtn.onlyRead) ? 'Piezas Cotizadas' : 'Ver sus Piezas'
        : 'Agregar Piezas',
        textScaleFactor: 1,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
      ),
      onPressed: () {

        solicitudSgtn.setAutoEnJuegoIndexAuto(this._indexAuto);
        if(solicitudSgtn.autos[this._indexAuto].containsKey('piezas')){
          if(solicitudSgtn.autos[this._indexAuto]['piezas'].length > 0) {
            Navigator.of(this._context).pushNamed('lst_piezas_page');
            return;
          }
        }

        Navigator.of(this._context).pushNamed('alta_piezas_page');
      }
    );
  }

  ///
  Widget _estrellas() {

    int cantPiezas = 0;
    if(solicitudSgtn.autos[this._indexAuto].containsKey('piezas')){
      cantPiezas = solicitudSgtn.autos[this._indexAuto]['piezas'].length;
    }
    double tma = 17;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[

        (cantPiezas == 0)
        ? Icon(Icons.star_border, size: tma, color: Colors.amber)
        : Icon(Icons.star, size: tma, color: Colors.amber),

        (this._hasAnio)
        ? Icon(Icons.star, size: tma, color: Colors.amber)
        : Icon(Icons.star_border, size: tma, color: Colors.amber),

        (this._hasVersion)
        ? Icon(Icons.star, size: tma, color: Colors.amber)
        : Icon(Icons.star_border, size: tma, color: Colors.amber),

      ],
    );
  }

  ///
  void _editarAuto() {

    buscarAutosSngt.setIdMarca(solicitudSgtn.autos[this._indexAuto]['mk_id']);
    buscarAutosSngt.setIdModelo(solicitudSgtn.autos[this._indexAuto]['md_id']);
    buscarAutosSngt.setNombreMarca(solicitudSgtn.autos[this._indexAuto]['mk_nombre']);
    buscarAutosSngt.setNombreModelo(solicitudSgtn.autos[this._indexAuto]['md_nombre']);
    
    solicitudSgtn.indexAutoIsEditing = this._indexAuto;
    solicitudSgtn.editAutoPage = 'lst_modelos_select_page';

    Navigator.of(this._context).pushNamedAndRemoveUntil('add_autos_page', (Route rutas) => false);
  }

}