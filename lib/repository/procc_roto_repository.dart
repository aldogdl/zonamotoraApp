import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:zonamotora/bds/data_base.dart';
import 'package:zonamotora/singletons/solicitud_sngt.dart';

class ProccRotoRepository {

  String _nomDB = 'proccRoto';

  ///
  Map<String, dynamic> _procesos = {
    'altRef' : {
      'path'     : 'alta_piezas_page',
      'explica'  : 'Alta de Refacciones',
      'metadata' : {
        'indexAuto' : 0,
        'indexPieza': 0
      }
    },
    'altSoc' : {
      'path'     : '_',
      'explica'  : 'Alta de Socios',
      'metadata' : '_'
    }
  };

  ///
  List<String> _nombresProcesos = [
    'altRef', 'altSoc'
  ];

  /// @see SolicitudSngt::makeBackupInBd
  Future<bool> makeBackupByAltaDeRefacciones({
    @required Map<String, dynamic> metadata,
    @required List<Map<String, dynamic>> contents,
  }) async {

    String nombre = 'altRef';
    int i;
    Database db = await DBApp.db.abrir;

    if(db.isOpen) {
      List<dynamic> altRef = await db.query(this._nomDB, where: 'nombre = ?', whereArgs: [nombre]);
      if(altRef.length > 0){
        await db.delete(this._nomDB, where: 'nombre = ?', whereArgs: [nombre]);
      }

      Map<String, dynamic> data = {
        'nombre'  : nombre,
        'path'    : this._procesos[nombre]['path'],
        'metadata': json.encode(metadata),
        'contents': json.encode(contents)
      };
      i = await db.insert(this._nomDB, data);
    }

    return (i > 0) ? true : false;
  }

  ///
  Future<Map<String, dynamic>> checkProcesosRotos() async {

    Database db = await DBApp.db.abrir;
    Map<String, dynamic> metaData;

    for (var i = 0; i < this._nombresProcesos.length; i++) {

      List<dynamic> hasProcecc = await db.query(
        this._nomDB,
        where: 'nombre = ?',
        whereArgs: [this._nombresProcesos[i]]
      );

      if(hasProcecc.length > 0){
        switch (this._nombresProcesos[i]) {

          case 'altRef':
            SolicitudSngt solicitudSngt = SolicitudSngt();
            metaData = json.decode(hasProcecc.first['metadata']);
            solicitudSngt.setAutosByRecoverDB(new List<Map<String, dynamic>>.from(json.decode(hasProcecc.first['contents'])));
            solicitudSngt.setProcessRecovery(new Map<String, dynamic>.from(metaData));
            solicitudSngt.setIsRecovery(true);
            break;
          default:
        }

        return {'path': hasProcecc.first['path']};
      }
    }

    return new Map();
  }

  ///
  Future<bool> deleteProcesosRotosByAltaDeRefaccs() async {

    Database db = await DBApp.db.abrir;
    int i = await db.delete(this._nomDB, where: 'nombre = ?',
      whereArgs: [this._nombresProcesos[0]]
    );
    return (i > 0) ? true : false;
  }

}