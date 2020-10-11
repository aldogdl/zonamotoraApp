import 'package:flutter/material.dart';

class CompartiPagWebWidget extends StatelessWidget {

  final BuildContext contextFromCall;

  CompartiPagWebWidget({Key key, this.contextFromCall}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Padding(
        padding: EdgeInsets.only(right: 10),
        child: IconButton(
          icon: Icon(Icons.share, size: 35, color: Colors.red),
          onPressed: () async {
            await _showListDialog();
          },
        ),
      ),
    );
  }

  ///
  Future<void> _showListDialog() async {

    showDialog(
      context: this.contextFromCall,
      builder: (_) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(5),
          scrollable: true,
          content: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              _machoteTile(
                keySend: 'pw',
                titulo: 'Página Web',
                subTitulo: 'compartir el Link',
                icono: Icons.language_rounded
              ),
              _machoteTile(
                keySend: 'td',
                titulo: 'Tarjeta Digital',
                subTitulo: 'Link de Descarga',
                icono: Icons.contact_phone
              ),
            ],
          ),
        );
      }
    );
  }

  ///
  Widget _machoteTile({
    String keySend,
    String titulo,
    String subTitulo,
    IconData icono
  }) {

    return ListTile(
      title: Text(
        '$titulo',
        textScaleFactor: 1,
      ),
      subtitle: Text(
        '$subTitulo',
        textScaleFactor: 1,
      ),
      leading: Icon(icono),
      trailing: Icon(Icons.navigate_next_rounded),
      onTap: (){
        print(keySend);
      },
    );
  }
}