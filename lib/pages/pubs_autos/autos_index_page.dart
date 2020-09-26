import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/secciones_page_base.dart';

class AutosIndexPage extends StatefulWidget {
  @override
  _AutosIndexPageState createState() => _AutosIndexPageState();
}

class _AutosIndexPageState extends State<AutosIndexPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  BuildContext _context;
  bool _isInit = false;
  String lastUri;

  
  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    if(!this._isInit){
      this._isInit = true;
      lastUri = Provider.of<DataShared>(this._context, listen: false).lastPageVisit;
      Provider.of<DataShared>(this._context, listen: false).setLastPageVisit('autos_index_page');
    }

    return Scaffold(
      appBar: appBarrMy.getAppBarr(titulo: 'Estas en VEHÍCULOS...'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () {
          if(lastUri != null) {
            Navigator.of(this._context).pushReplacementNamed(lastUri);
          }
          return Future.value(false);
        },
        child: Column(
          children: [
            SeccionesPageBase(currentSeccion: 2, showResultados: true)
          ],
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

}