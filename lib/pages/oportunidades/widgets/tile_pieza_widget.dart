import 'package:flutter/material.dart';
import 'package:zonamotora/globals.dart' as globals;

class TilePiezaWidget extends StatelessWidget {

  final Map<String, dynamic> pieza;
  final formatoNumber;
  const TilePiezaWidget({this.pieza, this.formatoNumber});

  @override
  Widget build(BuildContext context) {

    return ListTile(
      leading: (pieza['fotos'].length > 0)
      ?
      CircleAvatar(
        backgroundImage: NetworkImage('${globals.uriImageInvent}/${pieza['fotos'][0]}'),
      )
      :
      CircleAvatar(
        child: Icon(Icons.photo_camera),
      ),
      title: Text(
        '${pieza['titulo']}',
        textScaleFactor: 1,
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
      subtitle: Text(
        '${pieza['subTit']}',
        textScaleFactor: 1,
        style: TextStyle(

        ),
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '\$ ${formatoNumber.format(pieza['comis'])}',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 13
            ),
          ),
          Text(
            '\$ ${formatoNumber.format(pieza['costo'])}',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}