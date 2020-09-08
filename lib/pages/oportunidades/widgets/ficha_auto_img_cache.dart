import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:zonamotora/globals.dart' as globals;

class FichaAutoImgCacheWidget extends StatelessWidget {

  final String foto;
  const FichaAutoImgCacheWidget({Key key, this.foto}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if (foto == null || foto == '0') {
      return _sinFoto();
    }

    return CachedNetworkImage(
      imageUrl: '${globals.uriImgSolicitudes}/$foto',
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      placeholder: (context, url) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
            color: Colors.red[400],
          ),
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) =>_sinFoto(),
    );
  }

  ///
  Widget _sinFoto() {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
        image: DecorationImage(
          image: AssetImage('assets/images/no-image.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn),
        )
      )
    );
  }

}
