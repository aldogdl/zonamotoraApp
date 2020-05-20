import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zonamotora/globals.dart' as globals;

class SolicitudesWidget extends StatefulWidget {
  @override
  _SolicitudesWidgetState createState() => _SolicitudesWidgetState();
}

class _SolicitudesWidgetState extends State<SolicitudesWidget> {


  BuildContext _context;

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    List<int> prueba = [1,1,1,1,1,1,1,1];

    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: ListView.builder(
        itemCount: prueba.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: _machoteListTitle(),
            onTap: () => Navigator.of(this._context).pushNamed('crear_cotizacion_page'),
          );
        }
      )
    );
  }

  ///
  Widget _machoteListTitle() {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              height: 50,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30)
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: _imagenCache(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(this._context).size.width * 0.57,
                      child: Text(
                        'Salpicadero Derecho Inferior Poniente',
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      ),
                    ),
                    Text(
                      '12:25 a.m.',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.5,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Suburban Oregon 2000',
                      textScaleFactor: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800]
                      ),
                    ),
                    Text(
                      'Chevrolet',
                      textScaleFactor: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.green
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

    ///
  Widget _imagenCache() {

    return CachedNetworkImage(
      imageUrl: '${globals.uriImgSolicitudes}/2_420200_1.jpg',
      imageBuilder: (context, imageProvider) {

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20)
            ),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      placeholder: (context, url){
        return _placeHolderAvatar();
      },
      errorWidget: (context, url, error) {
        return _placeHolderAvatar();
      },
    );
  }

  ///
  Widget _placeHolderAvatar() {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20)
        ),
        image: DecorationImage(
          image: AssetImage('assets/images/no-image.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }


}