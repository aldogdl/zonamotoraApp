import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/singletons/index_app_sngt.dart';
import 'package:zonamotora/widgets/banners_top.dart';
import 'package:zonamotora/widgets/plantilla_base.dart';
import 'package:zonamotora/widgets/publicacion_widget.dart';
import 'package:zonamotora/globals.dart' as globals;

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  IndexAppSng indexAppSng = IndexAppSng();
  
  bool _isInit = true;

  @override
  Widget build(BuildContext context) {

    if(this._isInit){
      this._isInit = false;
    }

    return PlantillaBase(
      context: context,
      pagInf: 0,
      activarIconInf: false,
      isIndex: true,
      child: _body(context),
    );
  }

  ///
  Widget _body(BuildContext context) {

    String username = Provider.of<DataShared>(context, listen: false).username;
    int alto = (username == 'Anónimo') ? 190 : 130;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height -alto,
      child: ListView(
        addAutomaticKeepAlives: false,
        shrinkWrap: true,
        addRepaintBoundaries: false,
        padding: EdgeInsets.all(0),
        scrollDirection: Axis.vertical,
        children: [
          (username != 'Anónimo')
          ?
          _btnsSlogan(context)
          :
          const SizedBox(height: 0),
          BannersTop(),
          _lastPageWeb(),
          _getDivisor(titulo: 'Últimos Vehículos'),
          _createListPublicacionesHorizontal(context, indexAppSng.indexApp['autos']),
          const SizedBox(height: 35),
          _getDivisor(titulo: 'Servicios para tu Auto'),
          const SizedBox(height: 15),
          _createListPublicacionesHorizontal(context, indexAppSng.indexApp['servs']),
          const SizedBox(height: 35),
          _getDivisor(titulo: 'Accesorios Piezas y más...'),
          const SizedBox(height: 15),
          _createListPublicacionesHorizontal(context, indexAppSng.indexApp['refacs']),
                    const SizedBox(height: 35),
          _getDivisor(titulo: 'Piezas Recomendadas.'),
           const SizedBox(height: 15),
          _bigRecomendacion(context),
          _createListPiezasHorizontal(context, indexAppSng.indexApp['recom']),
          const SizedBox(height: 35),
          BannersTop(),
          const SizedBox(height: 35),
        ],
      ),
    );
  }

  ///
  Widget _btnsSlogan(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 7),
      color: Colors.red[100],
      child: Text(
        'PORQUE TU AUTO LO MERECE',
        textScaleFactor: 1,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.red[600],
          letterSpacing: 1
        ),
      ),
    );
  }

  ///
  Widget _getDivisor({String titulo}) {

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.withAlpha(100),
            Colors.white,
          ],
          end: Alignment.topLeft,
          begin: Alignment.bottomRight
        ),
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: Colors.blueGrey
          )
        )
      ),
      child: Padding(
        padding: EdgeInsets.only(
          right: 10,
        ),
          child: Text(
          '$titulo',
          textScaleFactor: 1,
          textAlign: TextAlign.end,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xff002f51)
          ),
        ),
      ),
    );
  }

  ///
  Widget _lastPageWeb() {

    IconData icono;
    String negocio;
    String tel;
    if(indexAppSng.indexApp.isEmpty){
      icono = Icons.tag_faces;
      negocio = 'Aprovecha los últimos servicios';
      tel = 'Todo para que tu auto esté mejor';
    }else{
      icono = (indexAppSng.indexApp['lastServ']['perfil']['roles'][0] == 'ROLE_AUTOS') ? Icons.directions_car : Icons.build;
      negocio = indexAppSng.indexApp['lastServ']['perfil']['razonSocial'];
      if(indexAppSng.indexApp['lastServ']['perfil']['telsContac'].isNotEmpty){
        tel = indexAppSng.indexApp['lastServ']['perfil']['telsContac'][0].toString();
      }else{
        tel = '0';
      }
      if(tel == '0'){
        tel = 'www.zonamotora.com/${indexAppSng.indexApp['lastServ']['slug']}';
      }else{
        tel = 'Contáctanos: $tel';
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.orange
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 40,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Colors.orange[900],
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.yellow,
                    Colors.yellow[200]
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  transform: GradientRotation(0.8)
                )
              ),
              child: Center(
                child: Icon(icono),
              ),
            ),
          ),
           const SizedBox(width: 10),
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$negocio',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$tel',
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  ///
  Widget _createListPublicacionesHorizontal(BuildContext context, List<dynamic> data) {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.33,
      padding: EdgeInsets.only(top: 0, bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (_, index) {

          return Padding(
            padding: EdgeInsets.only(left: 10),
            child: PublicacionWidget(
              contextSend: context,
              dataPublic: data[index],
              tamWid: 0.45,
            ),
          );
        },
      ),
    );
  }

  ///
  Widget _createListPiezasHorizontal(BuildContext context, List<dynamic> data) {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.35,
      padding: EdgeInsets.only(top: 0, bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (_, index) {

          final precio = NumberFormat.currency(locale: 'en_US', symbol: '\$').format(data[index]['costoZM']);

          return Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.43,
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: '${globals.uriImageInvent}/${data[index]['i_fotos']}',
                      placeholder: (_,__) => Image(image: AssetImage('assets/images/no-image.png')),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${data[index]['titulo']}',
                  textScaleFactor: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${data[index]['modelo']}',
                      textScaleFactor: 1,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${data[index]['anio']}',
                      textScaleFactor: 1,
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$precio',
                    textScaleFactor: 1,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 18
                    ),
                  ),
                )
              ],
            ),
          );
        }
      ),
    );

  }

  ///
  Widget _bigRecomendacion(BuildContext context) {

    Map<String, dynamic> recomFirst = new Map<String, dynamic>.from(indexAppSng.indexApp['recom'][0]);

    final precio = NumberFormat.currency(locale: 'en_US', symbol: '\$').format(recomFirst['costoZM']);

    return Container(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: '${globals.uriImageInvent}/${recomFirst['i_fotos']}',
                placeholder: (_,__) => Image(image: AssetImage('assets/images/no-image.png')),
                fit: BoxFit.cover,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Text(
              '${recomFirst['titulo']}',
              textScaleFactor: 1,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.directions_car, color: Colors.blueGrey, size: 26),
                const SizedBox(width: 10),
                Text(
                  '${recomFirst['marca']}',
                  textScaleFactor: 1,
                ),
                const SizedBox(width: 5),
                Text(
                  '${recomFirst['modelo']}',
                  textScaleFactor: 1,
                ),
                const SizedBox(width: 5),
                Text(
                  '${recomFirst['anio']}',
                  textScaleFactor: 1,
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text(
                '$precio',
                textScaleFactor: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 21
                ),
              ),
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }

}
