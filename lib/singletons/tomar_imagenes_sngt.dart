import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class TomarImagenesSngt {

  static TomarImagenesSngt tomarImagenesSngt = TomarImagenesSngt._();
  TomarImagenesSngt._();
  factory TomarImagenesSngt() {
    return tomarImagenesSngt;
  }

  Map<String, dynamic> proccRoto = {
    'nombre': '', 'metadata': '', 'contents': ''
  };
  String source;
  String error;
  Widget childImg;
  Asset imagenAsset;
  PickedFile imagenFile;
  int _thubFachadaX = 533;
  int _thubFachadaY = 300;

  ///
  Widget previewImage() {

    if(this.source == 'camara'){
      return Image.file(File(this.imagenFile.path));
    }else{
      return AssetThumb(asset: this.imagenAsset, width: this._thubFachadaX, height: this._thubFachadaY);
    }
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

    if(imagenFile != null) {
       response['img'] = File(imagenFile.path).readAsBytesSync();
      return response;
    }

    return response;
  }

}