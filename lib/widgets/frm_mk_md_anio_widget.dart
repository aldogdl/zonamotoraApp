import 'package:flutter/material.dart';
import 'package:zonamotora/singletons/buscar_autos_sngt.dart';
import 'package:zonamotora/singletons/frm_mk_md_anios_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/buscar_autos_by.dart';

class FrmMkMdAnioWidget extends StatefulWidget {

  final BuildContext context;
  FrmMkMdAnioWidget({Key key, this.context}) : super(key: key);

  @override
  _FrmMkMdAnioWidgetState createState() => _FrmMkMdAnioWidgetState();
}

class _FrmMkMdAnioWidgetState extends State<FrmMkMdAnioWidget> {

  AlertsVarios alertsVarios = AlertsVarios();
  BuscarAutosSngt buscarAutosSngt = BuscarAutosSngt();
  FrmMkMdAniosSngt frmSng = FrmMkMdAniosSngt();

  Size _screen;
  BuildContext _context;

  @override
  Widget build(BuildContext context) {

    if(widget.context != null){
      this._context = widget.context;
      frmSng.setContext(this._context);
    }else{
      this._context = context;
      context = null;
    }

    this._screen = MediaQuery.of(this._context).size;

    if(buscarAutosSngt.idMarca != null) {
      frmSng.txtMarca = buscarAutosSngt.nombreMarca;
      frmSng.colorMarca = Colors.blue;
    }else{
      frmSng.txtMarca = 'Click AQUÍ';
      frmSng.colorMarca = Colors.grey;
    }

    if(buscarAutosSngt.idModelo != null) {
      frmSng.txtModelo = buscarAutosSngt.nombreModelo;
      frmSng.colorModelo = Colors.blue;
    }else{
      frmSng.txtModelo = 'Click AQUÍ';
      frmSng.colorModelo = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.all(10),
      width: this._screen.width * 0.92,
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red[100],
          border: Border.all(
            color: Colors.grey[400]
          )
        ),
        child: _frm(),
      )
    );
  }

  ///
  Widget _frm() {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '   MARCA DEL AUTO:',
            textScaleFactor: 1,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(height: 5),
        _inputMarca(),
        const SizedBox(height: 20),
        Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(
                '   MODELO:',
                textScaleFactor: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'AÑO:',
                textScaleFactor: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: this._screen.width,
          height: 60,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: _inputModelo(),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: _inputAnio(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Versión o Características del Modelo:',
            textScaleFactor: 1,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(height: 5),
        _inputVersion(),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '   Detalles que diferencien el vehículo',
            textScaleFactor: 1,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14,
              color: Colors.red
            ),
          ),
        ),
      ],
    );
  }

  ///
  Widget _inputMarca() {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(1,1),
            color: Colors.grey
          )
        ]
      ),
      child: InkWell(
        onTap: () async { 
          await showDialog(
            context: this._context,
            builder: (BuildContext context) {
              return BuscarAutosBy(
                titulo: 'Busca la Marca:',
                subTitulo: 'Selecciona la marca del Auto',
                autosBy: 'marca',
              );
            }
          );
          setState(() { });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 4,
              child: SizedBox(
                width: this._screen.width * 0.7,
                child: Text(
                  '${ frmSng.txtMarca }',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: frmSng.colorMarca,
                    fontWeight: (frmSng.colorMarca == Colors.grey) ? FontWeight.normal : FontWeight.bold
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Icon(Icons.search, color: Colors.grey),
            ),
            const SizedBox(width: 5)
          ],
        ),
      )
    );
  }

  ///
  Widget _inputModelo() {

    return Container(
      width: this._screen.width * 0.48,
      height: 60,
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10)
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(1,1),
            color: Colors.grey
          )
        ]
      ),
      child: InkWell(
        onTap: () async {
          if(buscarAutosSngt.idMarca != null){
            await showDialog(
              context: this._context,
              builder: (BuildContext context) {
                return BuscarAutosBy(
                  titulo: 'Busca Modelo:',
                  subTitulo: 'Selecciona el Modelo del Auto',
                  autosBy: 'modelos',
                );
              }
            );
            if(buscarAutosSngt.idModelo != null) {
              FocusScope.of(this._context).requestFocus(frmSng.focusAnio);
            }
            setState(() { });
          }else{
            await alertsVarios.entendido(
              this._context,
              titulo: 'SIN MARCA',
              body: 'No se ha detectado que hallas seleccionado LA MARCA DEL AUTO para filtrar sus respectivos MODELOS.'
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>
          [
            Text(
              '${ frmSng.txtModelo }',
              textScaleFactor: 1,
              style: TextStyle(
                color: frmSng.colorModelo,
                fontWeight: (frmSng.colorMarca == Colors.grey) ? FontWeight.normal : FontWeight.bold
              )
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Icon(Icons.search, color: Colors.grey),
            ),
          ] ,
        ),
      )
    );
  }

  ///
  Widget _inputAnio() {

    return Container(
      width: this._screen.width * 0.30,
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10)
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(1,1),
            color: Colors.grey
          )
        ]
      ),
      child: TextField(
        controller: frmSng.ctrAnio,
        focusNode: frmSng.focusAnio,
        keyboardType: TextInputType.number,
        maxLength: 4,
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.next,
        style: TextStyle(
          fontSize: 21,
          color: Colors.blue,
          fontWeight: FontWeight.bold
        ),
        buildCounter: null,
        decoration: InputDecoration(
          hintText: '0000',
          counterText: '',
          hintStyle: TextStyle(
            color: Colors.grey[300]
          ),
        ),
        onEditingComplete: (){

          FocusScope.of(this._context).requestFocus(frmSng.focusVersion);
        },
      )
    );
  }

  ///
  Widget _inputVersion() {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(1,1),
            color: Colors.grey
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 4,
            child: SizedBox(
              width: this._screen.width * 0.7,
              child: TextField(
                controller: frmSng.ctrVersion,
                focusNode: frmSng.focusVersion,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                maxLines: 2,
                maxLength: 66,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Dato Opcional',
                  counterText: '',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 13
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.help, color: Colors.blue, size: 30),
            onPressed: () => _showHelpVersion(),
          ),
        ],
      )
    );
  }

  ///
  Future<void> _showHelpVersion() async {

    String body = 'En ocasiones, los Modelos cuentan con varias versiones que hacen que su diseño y funcionamiento cambien.';
    String body2 = 'Por ejemplo:\n\nSi el auto es 2 o 5 puertas, si es Automático, o si es tipo Sedan, Vagoneta, Hashback.\n\nEn la mayoria de las ocasiones, con el nombre específico de la versión basta para conocer las características necesarias.';
    String body3 = 'Agregar detalles adicionales, nos ayudan a otorgarte un mejor servicio.';

    await showDialog(
      context: this._context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          titleTextStyle: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 23
          ),
          title: Text(
            'AYUDA RÁPIDA',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 7),
          content: Container(
            width: this._screen.width,
            height: this._screen.height * 0.55,
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(7),
                  width: this._screen.width,
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(
                    body,
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                ),
                Divider(),
                Text(
                  body2,
                  textScaleFactor: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  body3,
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton.icon(
              color: Colors.blue,
              textColor: Colors.white,
              icon: Icon(Icons.check),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              label: Text(
                'OK',
                textScaleFactor: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () => Navigator.of(this._context).pop(true)
            )
          ],
        );
      }
    );
  }


}