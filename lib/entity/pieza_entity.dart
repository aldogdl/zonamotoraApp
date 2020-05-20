import 'package:multi_image_picker/multi_image_picker.dart';

class PiezaEntity {

  FotoAsset fotoAsset = FotoAsset();

  int    id;
  int    cant;
  String pieza;
  String lado;
  String detalles;
  FotoAsset foto = FotoAsset();

  PiezaEntity({this.id, this.cant, this.pieza, this.lado, this.detalles});

  ///
  Map<String, dynamic> toJson() {

    Map<String, dynamic> foto = new Map<String, dynamic>();
    foto = (this.foto == null || this.foto.nombre == null) ? foto : this.foto.toJson();
    return {
      'id'      : id,
      'cant'    : cant,
      'pieza'   : pieza,
      'lado'    : lado,
      'detalles': detalles,
      'foto'    : foto
    };
  }
}

class FotoAsset {
  String nombre;
  String identifier;
  int width;
  int height;

  FotoAsset({
    nombre,
    identifier,
    width,
    height
  });

  ///
  setFotoByAsset(Asset foto, width, height) {
    this.nombre = foto.name;
    this.identifier = foto.identifier;
    this.width = width;
    this.height = height;
  }

  ///
  setFotoByJson(Map<String, dynamic> foto) {
    this.nombre    = foto['nombre'];
    this.identifier= foto['identifier'];
    this.width     = foto['width'];
    this.height    = foto['height'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'nombre'    : this.nombre,
      'identifier': this.identifier,
      'width'     : this.width,
      'height'    : this.height
    };
  }

  ///
  Asset toAsset(Map<String, dynamic> foto) {
    return new Asset(foto['identifier'], foto['nombre'], foto['width'], foto['height']);
  }
}