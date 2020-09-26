import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class TomarImagenesSngt {

  static TomarImagenesSngt tomarImagenesSngt = TomarImagenesSngt._();
  TomarImagenesSngt._();
  factory TomarImagenesSngt() {
    return tomarImagenesSngt;
  }

  bool isRecovery = false;
  Map<String, dynamic> proccRoto = {
    'nombre': '', 'metadata': '', 'contents': ''
  };
  String source;
  String error;
  Widget childImg;
  Asset imagenAsset;
  List<Map<String, dynamic>> imagesAsset = new List();
  bool changeImage = false;
  int _thubFachadaX = 533;
  int _thubFachadaY = 300;
  String restringirPosition = 'all';

  ///
  Future<void> dispose() async {

    source = null;
    error = null;
    childImg = null;
    imagenAsset = null;
    imagesAsset = new List();
    isRecovery = false;
    proccRoto = {'nombre': '', 'metadata': '', 'contents': ''};
    restringirPosition = 'all';
  }

  ///
  Widget previewImage() {
    this.changeImage = true;
      return AssetThumb(
      asset: this.imagenAsset,
      width: this._thubFachadaX,
      height: this._thubFachadaY,
    );
  }

  ///
  Widget convertImageToAsset(Asset imagen) {
    return AssetThumb(asset: imagen, width: this._thubFachadaX, height: this._thubFachadaY);
  }

  //
  Future<Map<String, dynamic>> getImageForSend({Asset otraImagen}) async {

    if(otraImagen != null){
      imagenAsset = otraImagen;
    }
    Map<String, dynamic> response = {'nombre':'', 'ext':'', 'img':''};
    if(imagenAsset != null){
      
      ByteData bytes = await imagenAsset.getThumbByteData(this._thubFachadaX, this._thubFachadaY);
      List<String> extParts = imagenAsset.name.split('.');

      response['nombre'] = extParts.first;
      response['ext'] = extParts.last;
      response['img'] = bytes.buffer.asUint8List();

      if(otraImagen != null){
        imagenAsset = null;
      }
      return response;
    }

    return response;
  }

  ///
  Future<void> hidratarImagenFromServer(String imagen) async {
    
    this.changeImage = false;
    childImg = CachedNetworkImage(
      imageUrl: imagen,
      errorWidget: (_, String err, __){
        return Center(
          child: Text(
            'Selecciona una Imágen Aquí',
            textAlign: TextAlign.center,
            textScaleFactor: 1,
          ),
        );
      },
      placeholder: (_, url) {
        return Center(
          child: SizedBox(
            height: 35, width: 35,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  ///
  Future<String> delImagenById(int id) async {

    int rota = imagesAsset.length;
    List<Map<String, dynamic>> newList = new List();
    int newId = 1;
    String deleteTo = 'local';
    for (var i = 0; i < rota; i++) {
      if(imagesAsset[i]['id'] != id) {
        imagesAsset[i]['id'] = newId;
        newList.add(imagesAsset[i]);
        newId = newId +1;
      }
    }
    imagesAsset = newList;
    newList = null;
    return deleteTo;
  }
}