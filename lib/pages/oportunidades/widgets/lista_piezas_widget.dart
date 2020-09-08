import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:zonamotora/pages/oportunidades/widgets/tile_pieza_widget.dart';

class ListaPiezasWidget extends StatefulWidget {

  final List<Map<String, dynamic>> items;

  ListaPiezasWidget({Key key, this.items}) : super(key: key);

  @override
  _ListaPiezasWidgetState createState() => _ListaPiezasWidgetState();
}

class _ListaPiezasWidgetState extends State<ListaPiezasWidget> {

  BuildContext _context;
  final f = new NumberFormat("###,###.0#", "en_US");

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;

    return Container(
      width: MediaQuery.of(this._context).size.width,
      height: MediaQuery.of(this._context).size.height * 0.538,
      child: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (_, i){
          return TilePiezaWidget(pieza: widget.items[i], formatoNumber: f);
        },
      ),
    );
  }
}