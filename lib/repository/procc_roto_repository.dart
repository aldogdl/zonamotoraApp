import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:zonamotora/bds/data_base.dart';
import 'package:zonamotora/https/asesores_http.dart';
import 'package:zonamotora/singletons/alta_user_sngt.dart';
import 'package:zonamotora/singletons/cotizacion_sngt.dart';
import 'package:zonamotora/singletons/solicitud_sngt.dart';
import 'package:zonamotora/singletons/tomar_imagenes_sngt.dart';

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
      'path'     : 'alta_save_resum_page',
      'explica'  : 'Alta de Socios',
      'metadata' : '_'
    },
    'ftosCot' : {
      'path'     : 'set_fotos_cotizacion',
      'explica'  : 'Seleccion de las fotos para la respuesta a una solicitud',
      'metadata' : {
        'solicitud': 0,
        'pedido': 0
      }
    },
    'altaLogoSocio' : {
      'path'     : 'alta_pagina_web_logo_page',
      'explica'  : 'Seleccion del logotipo para la pagina web del Socio',
      'metadata' : {
        'idUser': 0,
        'idPerfil': 0
      }
    }
  };

  ///
  List<String> _nombresProcesos = [
    'altRef', 'altSoc', 'ftosCot', 'altaLogoSocio'
  ];

  /// @see SolicitudSngt::makeBackupInBd
  Future<bool> makeBackupByAltaDeRefacciones({
    @required Map<String, dynamic> metadata,
    @required List<Map<String, dynamic>> contents,
  }) async {

    String nombre = 'altRef';
    int i = 0;
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

  /// Usado para respaldar el proceso de alta de fotografias para la respuesta
  /// a una cotización.
  Future<bool> makeBackupFotosByCotizacion({
    @required Map<String, dynamic> metadata,
    @required Map<String, dynamic> contents
  }) async {

    int i = 0;
    /// ftosCot -> el nombre de este backup
    String nombreProceso = this._nombresProcesos[2];

    Database db = await DBApp.db.abrir;
    if(db.isOpen){
      List<dynamic> hasData = await db.query(this._nomDB, where: 'nombre = ?', whereArgs: [nombreProceso]);
      if(hasData.isNotEmpty){
        await db.delete(this._nomDB, where: 'nombre = ?', whereArgs: [nombreProceso]);
      }
      Map<String, dynamic> data = {
        'nombre'  : nombreProceso,
        'path'    : this._procesos[nombreProceso]['path'],
        'metadata': json.encode(metadata),
        'contents': json.encode(contents)
      };
      i = await db.insert(this._nomDB, data);
    }

    return (i > 0) ? true : false;
  }

  /// Usado para respaldar el proceso de alta de fotografias para la respuesta
  /// a una cotización.
  Future<bool> makeBackupGral({
    @required String nameBackup,
    @required Map<String, dynamic> metadata,
    @required Map<String, dynamic> contents
  }) async {

    int i = 0;
    Database db = await DBApp.db.abrir;
    if(db.isOpen){
      List<dynamic> hasData = await db.query(this._nomDB, where: 'nombre = ?', whereArgs: [nameBackup]);
      if(hasData.isNotEmpty){
        await db.delete(this._nomDB, where: 'nombre = ?', whereArgs: [nameBackup]);
      }
      Map<String, dynamic> data = {
        'nombre'  : nameBackup,
        'path'    : this._procesos[nameBackup]['path'],
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
    Map<String, dynamic> response = new Map();

    for (var i = 0; i < this._nombresProcesos.length; i++) {

      List<dynamic> hasProcecc = await db.query(this._nomDB,  where: 'nombre = ?', whereArgs: [this._nombresProcesos[i]] );

      if(hasProcecc.length > 0){
        switch (this._nombresProcesos[i]) {
          case 'altRef':
            response = await _recoveryAltaRefacciones(hasProcecc.first);
            break;
          case 'ftosCot':
            response = await _recoveryCotizacion(hasProcecc.first);
            break;
          case 'altSoc':
            response = await _recoveryAltaSocioFachada(hasProcecc.first);
            break;
          case 'altaLogoSocio':
            response = (hasProcecc == null) ? new Map() : await _recoveryLogotipoSocio(hasProcecc.first);
            break;
          default:
        }
        hasProcecc = null;
        return response;
      }
    }

    return new Map();
  }

  ///
  Future<Map<String, dynamic>> _recoveryAltaRefacciones(Map<String, dynamic> hasProcecc) async {

    SolicitudSngt solicitudSngt = SolicitudSngt();
    final metaData = json.decode(hasProcecc['metadata']);
    solicitudSngt.setAutosByRecoverDB(new List<Map<String, dynamic>>.from(json.decode(hasProcecc['contents'])));
    solicitudSngt.setProcessRecovery(new Map<String, dynamic>.from(metaData));
    solicitudSngt.setIsRecovery(true);
    return {'path': hasProcecc['path']};

  }

  ///
  Future<Map<String, dynamic>> _recoveryCotizacion(Map<String, dynamic> hasProcecc) async {

    CotizacionSngt sngtCot = CotizacionSngt();
    Map<String, dynamic> data = json.decode(hasProcecc['contents']);

    sngtCot.idCotizacion = data['idCotizacion'];
    sngtCot.dataPiezaEnProceso = data['dataPiezaEnProceso'];
    sngtCot.piezaEnProceso = data['piezaEnProceso'];
    sngtCot.fotos = new List<Map<String, dynamic>>.from(data['fotos']);
    sngtCot.isRecovery = true;

    return {'path': hasProcecc['path'], 'ftosCot':true};
  }
  
  ///
  Future<Map<String, dynamic>> _recoveryAltaSocioFachada(Map<String, dynamic> hasProcecc) async {

    AltaUserSngt altaUserSngt = AltaUserSngt();
    TomarImagenesSngt tomarImagenesSngt = TomarImagenesSngt();

    Map<String, dynamic> metadata = new Map<String, dynamic>.from(json.decode(hasProcecc['metadata']));
    Map<String, dynamic> tokenAsesor = new Map<String, dynamic>.from(json.decode(hasProcecc['contents']));
    altaUserSngt.setUserId(metadata['idUser']);
    tomarImagenesSngt.source = 'camara';
    tomarImagenesSngt.isRecovery = true;
    return {'path': hasProcecc['path'], 'altSoc': true, 'tokenAsesor': tokenAsesor['tokenAsesor']};

  }

  ///
  Future<Map<String, dynamic>> _recoveryLogotipoSocio(Map<String, dynamic> hasProcecc) async {

    AsesoresHttp asesoresHttp = AsesoresHttp();
    AltaUserSngt altaUserSngt = AltaUserSngt();
    TomarImagenesSngt tomarImagenesSngt = TomarImagenesSngt();

    Map<String, dynamic> metadata = new Map<String, dynamic>.from(json.decode(hasProcecc['metadata']));
    Map<String, dynamic> tokenAsesor = new Map<String, dynamic>.from(json.decode(hasProcecc['contents']));
    Map<String, dynamic> pagweb = await asesoresHttp.recoveryDataPagWebById(metadata['user']);

    if(pagweb.isNotEmpty){
      altaUserSngt.hisratarPaginaWebFromServer(pagweb, metadata['user'], metadata['perfil']);
    }
    tomarImagenesSngt.source = metadata['source'];
    tomarImagenesSngt.isRecovery = true;
    return {'path': hasProcecc['path'], 'altaLogoSocio': true, 'tokenAsesor': tokenAsesor['tokenAsesor']};
  }

  ///
  Future<bool> deleteProcesosRotosByAltaDeRefaccs() async => await deleteProcesoRoto(nameBackup: 'altRef');

  ///
  Future<bool> deleteProcesosRotosByFotosCotizacion() async => await deleteProcesoRoto(nameBackup: 'ftosCot');

  ///
  Future<bool> deleteProcesoRoto({@required String nameBackup}) async {

    Database db = await DBApp.db.abrir;
    int i = await db.delete(this._nomDB, where: 'nombre = ?', whereArgs: [nameBackup]);
    return (i > 0) ? true : false;
  }

}