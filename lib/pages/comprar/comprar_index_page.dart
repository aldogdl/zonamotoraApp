import 'package:flutter/material.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';

class ComprarIndexPage extends StatefulWidget {
  @override
  _ComprarIndexPageState createState() => _ComprarIndexPageState();
}

class _ComprarIndexPageState extends State<ComprarIndexPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  BuildContext _context;

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;

    return Scaffold(
      appBar: appBarrMy.getAppBarr(),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: _body(),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  /* */
  Widget _body() {

    return Center(
      child: Text(
        '¿COMO DESEAS COMPRAR?'
      ),
    );
  }

}