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
  bool changeImage = false;
  int _thubFachadaX = 533;
  int _thubFachadaY = 300;
  String restringirPosition = 'all';

  ///
  void dispose() {

    source = null;
    error = null;
    childImg = null;
    imagenAsset = null;
    isRecovery = false;
    proccRoto = {'nombre': '', 'metadata': '', 'contents': ''};
    restringirPosition = 'all';
  }

  ///
  Widget previewImage() {
    this.changeImage = true;
    return AssetThumb(asset: this.imagenAsset, width: this._thubFachadaX, height: this._thubFachadaY);
  }

  //
  Future<Map<String, dynamic>> getImageForSend() async {

    Map<String, dynamic> response = {'nombre':'', 'ext':'', 'img':''};
    if(imagenAsset != null){
      
      ByteData bytes = await imagenAsset.getThumbByteData(this._thubFachadaX, this._thubFachadaY);
      List<String> extParts = imagenAsset.name.split('.');

      response['nombre'] = extParts.first;
      response['ext'] = extParts.last;
      response['img'] = bytes.buffer.asUint8List();

      return response;
    }

    return response;
  }

  ///
  Future<void> hidratarImagenFromServer(String imagen) async {
    
    this.changeImage = false;
    childImg = CachedNetworkImage(
      imageUrl: imagen,
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

}