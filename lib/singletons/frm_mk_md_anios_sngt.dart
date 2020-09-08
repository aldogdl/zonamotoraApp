import 'package:flutter/material.dart';
import 'package:zonamotora/singletons/buscar_autos_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';

class FrmMkMdAniosSngt {
  
  static FrmMkMdAniosSngt frmMkMdAniosSngt = FrmMkMdAniosSngt._();
  FrmMkMdAniosSngt._();
  factory FrmMkMdAniosSngt() {
    return frmMkMdAniosSngt;
  }

  AlertsVarios alertsVarios = AlertsVarios();
  BuscarAutosSngt buscarAutosSngt = BuscarAutosSngt();
  BuildContext _context;

  String txtMarca = 'Click AQUÍ';
  Color colorMarca = Colors.grey;
  String txtModelo= 'Click AQUÍ';
  Color colorModelo = Colors.grey;

  void setContext(BuildContext context) {
    this._context = context;
    context = null;
    this._ctrAnio.text = '';
  }

  void dispose() {
    this._ctrAnio?.dispose();
    this._ctrVersion?.dispose();
  }

  FocusNode focusAnio = FocusNode();
  TextEditingController _ctrAnio = TextEditingController();
  get ctrAnio => this._ctrAnio;
  void setCtrAnio(int anio) => this._ctrAnio.text = '$anio';

  FocusNode focusVersion = FocusNode();
  TextEditingController _ctrVersion = TextEditingController();
  get ctrVersion => this._ctrVersion;
  void setCtrVersion(String version) => this._ctrVersion.text = '$version';

  ///
  void resetScreen() {
    
    buscarAutosSngt.setIdMarca(null);
    buscarAutosSngt.setNombreMarca(null);
    buscarAutosSngt.setIdModelo(null);
    buscarAutosSngt.setNombreModelo(null);

    this.txtMarca    = 'Click AQUÍ';
    this.txtModelo   = 'Click AQUÍ';
    this.colorMarca  = Colors.grey;
    this.colorModelo = Colors.grey;
    this._ctrAnio.text= '';
    this._ctrVersion.text = '';
  }

  ///
  Future<bool> isValid() async {

    bool res = true;
    String errorBody;
    String errorTitle;

    if(buscarAutosSngt.idMarca == null) {
      errorTitle = '¡LA MARCA!';
      errorBody  = 'No haz seleccionado una MARCA';
      res = false;
    }

    if(res) {
      if(buscarAutosSngt.idModelo == null) {
        errorTitle = '¡EL MODELO!';
        errorBody  = 'Selecciona un modelos para ${ buscarAutosSngt.nombreMarca }';
        res = false;
      }
    }

    if(res) {
      if(this._ctrAnio.text.length == 0) {
        errorTitle = '¡EL AÑO!';
        errorBody  = 'Inidca el Año para ${ buscarAutosSngt.nombreModelo }';
        FocusScope.of(this._context).requestFocus(this.focusAnio);
        res = false;
      }
    }

    if(res) {
      if(this._ctrAnio.text.length > 1 && this._ctrAnio.text.length < 4) {
        errorTitle = '¡EL AÑO!';
        errorBody  = 'El año debe ser de 4 dígitos';
        FocusScope.of(this._context).requestFocus(this.focusAnio);
        res = false;
      }
    }

    if(!res){
      await alertsVarios.entendido(this._context, titulo: errorTitle, body: errorBody);
    }
    return res;
  }

}
