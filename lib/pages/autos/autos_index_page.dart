import 'package:flutter/material.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/banners_top.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';

class AutosIndexPage extends StatefulWidget {
  @override
  _AutosIndexPageState createState() => _AutosIndexPageState();
}

class _AutosIndexPageState extends State<AutosIndexPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  Size _screen;
  BuildContext _context;

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;

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

    return Stack(
      children: <Widget>[
        Container(
          width: this._screen.width,
          height: this._screen.height * 0.28,
          decoration: BoxDecoration(
            color: Color(0xff7C0000)
          ),
          child: SizedBox(height: 30),
        ),

         // Banners
        Positioned(
          top: 0,
          child:  BannersTop()
        ),
      ],
    );
  }

}