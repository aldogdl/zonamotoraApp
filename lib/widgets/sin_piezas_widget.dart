import 'package:flutter/material.dart';

class SinPiezasWidget extends StatelessWidget {

  final String txt1;
  final String txt2;
  const SinPiezasWidget({Key key, this.txt1, this.txt2}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Icon(Icons.tag_faces, color: Colors.red.withAlpha(50), size: 100),
            Text(
              '$txt1 \n\n' +
              '$txt2',
              textAlign: TextAlign.center,
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey[600]
              ),
            )
          ],
        ),
      ),
    );
  }
}