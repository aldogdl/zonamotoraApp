import 'package:flutter/material.dart';

class LoadSheetButtomWidget extends StatelessWidget {

  final String menssage;
  final String queProcesando;

  LoadSheetButtomWidget({this.menssage, this.queProcesando});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width:MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: AssetImage('assets/images/ico_send_data.png'),
          ),
          Text(
            this.menssage,
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.grey
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: SizedBox(
              width:MediaQuery.of(context).size.width,
              height: 4,
              child: LinearProgressIndicator(),
            ),
          ),
          Text(
            this.queProcesando,
            textScaleFactor: 1,
          ),
        ],
      ),
    );
  }
}