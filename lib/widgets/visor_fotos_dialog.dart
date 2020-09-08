import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:zonamotora/globals.dart' as globals;

class VisorFotosDialogWidget extends StatelessWidget {

  final List<String> fotos;
  const VisorFotosDialogWidget({Key key, this.fotos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _dialogVerFotos(context);
  }
  
  ///
  Widget _dialogVerFotos(BuildContext context) {

    return AlertDialog(
      contentPadding: EdgeInsets.all(2),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          itemCount: fotos.length,
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0, height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes,
              ),
            ),
          ),
          builder: (BuildContext context, int index) {

            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage('${globals.uriImgSolicitudes}/${fotos[index]}'),
              initialScale: PhotoViewComputedScale.contained,
            );
          },
        )
      ),
    );
  }
}