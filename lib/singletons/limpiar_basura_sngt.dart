import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/singletons/tomar_imagenes_sngt.dart';

class LimpiarBasuraSngt {

  static LimpiarBasuraSngt _limpiarBasuraSngt = LimpiarBasuraSngt._();
  LimpiarBasuraSngt._();
  factory LimpiarBasuraSngt() {
    return _limpiarBasuraSngt;
  }

  TomarImagenesSngt tomarImagenesSngt = TomarImagenesSngt();

  BuildContext _context;

  void setContext(BuildContext context, String page) async {
    this._context = context;
    context = null;
    await _limpiarBasura(page);
  }

  ///
  Future<void> _limpiarBasura(String page) async {
    if(page == 'publicar_page'){
      await tomarImagenesSngt.dispose();
      Provider.of<DataShared>(this._context, listen: false).setRefreshWidgetNotifFalse(-1);
    }
  }

}