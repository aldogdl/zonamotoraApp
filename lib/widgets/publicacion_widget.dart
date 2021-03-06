import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:zonamotora/globals.dart' as globals;
import 'package:zonamotora/repository/favoritos_repository.dart';
import 'package:zonamotora/repository/publicar_repository.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/dialog_ver_fotos.dart';
import 'package:zonamotora/widgets/favoritos_iconos_widget.dart';
import 'package:zonamotora/widgets/load_sheetbutom_widget.dart';

class PublicacionWidget extends StatelessWidget {

  final PublicarRepository emPublic = PublicarRepository();
  final FavoritosRepository emFavs = FavoritosRepository();
  final AlertsVarios alertsVarios = AlertsVarios();

  final BuildContext contextSend;
  final Map<String, dynamic> dataPublic;
  final double tamWid;
  final String typo;
  final Function deleteFav;
  final DateFormat _dateFormat = DateFormat('d-MM-yyyy');

  PublicacionWidget({Key key, this.contextSend, this.dataPublic, this.tamWid, this.typo = 'small', this.deleteFav}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context = null;
    return (dataPublic.isNotEmpty) ? _widgetConData() : _widgetSinData();
  }

  ///
  Widget _widgetConData() {

    return (this.typo == 'small')
    ? 
    Container(
      width: MediaQuery.of(this.contextSend).size.width * this.tamWid,
      child: _cardSmall(),
    )
    : _cardBig();
  }

  ///
  Widget _cardSmall() {

    final precio = NumberFormat.currency(locale: 'en_US', symbol: '\$').format(dataPublic['pbl_precio']);

    return InkWell(
      onTap: (){
        _verFicha();
      },
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(
            color: Colors.grey[300]
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CachedNetworkImage(
                imageUrl: '${globals.uriImagePublica}/${dataPublic['u_id']}/${dataPublic['pbl_fotos']}',
                placeholder: (_, __) => Image(image: AssetImage('assets/images/no-image.png')),
                fit: BoxFit.cover,
                height: MediaQuery.of(this.contextSend).size.height * 0.195
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: Text(
                '$precio',
                textScaleFactor: 1,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.thumb_up, color: Colors.amber, size: 16),
                const SizedBox(width: 10),
                Text(
                  '${dataPublic['pbl_vistas']}',
                  textScaleFactor: 1,
                ),
                const SizedBox(width: 5),
              ],
            )
          ],
        ),
      ),
    );
  }

  ///
  Widget _cardBig() {

    double precioToDouble = double.tryParse(dataPublic['pbl_precio']);
    final precio = NumberFormat.currency(locale: 'en_US', symbol: '\$').format(precioToDouble);

    return InkWell(
      onTap: (){
        _verFicha();
        this.deleteFav();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: MediaQuery.of(this.contextSend).size.width * 0.8,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(
            color: Colors.grey[300]
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CachedNetworkImage(
                imageUrl: '${globals.uriImagePublica}/${dataPublic['u_id']}/${dataPublic['pbl_fotos']}',
                placeholder: (_,__) => Image(image: AssetImage('assets/images/no-image.png')),
                fit: BoxFit.cover,
                height: MediaQuery.of(this.contextSend).size.height * 0.3
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: Text(
                '${dataPublic['pbl_queVendes']}',
                textScaleFactor: 1,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: Text(
                '${dataPublic['pbl_descripcion']}',
                textScaleFactor: 1,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                child: Text(
                  '$precio',
                  textScaleFactor: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.grey
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await _sacarDeFavoritos(dataPublic['pbl_id']);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.close, color: Colors.red, size: 26),
                  const SizedBox(width: 10),
                  Text(
                    'Sacar de Favoritos',
                    textScaleFactor: 1,
                    style: TextStyle(
                      color: Colors.purple
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///
  Widget _widgetSinData() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Image(
            image: AssetImage('assets/images/no-image.png')
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Text(
            'Sin Publicaciones por el Momento',
            textScaleFactor: 1,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        )
      ],
    );
  }

  ///
  void _verFicha() {

    final modalFicha = showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      context: this.contextSend,
      builder: (_) {

        return Container(
          height: MediaQuery.of(this.contextSend).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white,
                Colors.white,
                Colors.white,
                Colors.white,
                Colors.blue[100]
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: FutureBuilder(
            future: _getDataPublicacion(dataPublic['pbl_id']),
            builder: (_, AsyncSnapshot<Map<String, dynamic>> snapshot) {

              if(snapshot.hasData) {
                if(snapshot.data.containsKey('pbl_id')){
                  return _showDatosButtomSheet(snapshot.data);
                }
              }

              return Column(
                children: [
                  _cabeceraFicha('${globals.uriImagePublica}/${dataPublic['u_id']}/${this.dataPublic['pbl_fotos']}'),
                  LoadSheetButtomWidget(
                    menssage: 'Espera un momento por favor',
                    queProcesando: 'Recuperando Datos',
                  )
                ],
              );
            },
          ),
        );
      }
    );

    modalFicha.then((value) => _cerrarficha());
  }

  ///
  Widget _showDatosButtomSheet(Map<String, dynamic> dataPublic) {

    final precio = NumberFormat.currency(locale: 'en_US', symbol: '\$').format(dataPublic['pbl_precio']);
    DateTime fecha = DateTime.parse(dataPublic['pbl_publicAt']['date']);
    double spaceIcos = 25.0;

    List<String> tels = new List();
    if(dataPublic['p_telsContac'] != null) {
      tels = new List<String>.from(dataPublic['p_telsContac']);
    }
    String whats = dataPublic['u_movil'];

    return ListView(
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      children: [
        InkWell(
          onTap: () {
            showDialog(
              context: this.contextSend,
              builder: (_) {
                return DialogVerFotosWidget(
                  contextSend: this.contextSend,
                  fotos: dataPublic['pbl_fotos'],
                  typeFoto: 'publicacion',
                  subForder: dataPublic['u_id'].toString(),
                );
              }
            );
          },
          child: _cabeceraFicha('${globals.uriImagePublica}/${dataPublic['u_id']}/${this.dataPublic['pbl_fotos']}'),
        ),
        
        Padding(
          padding: EdgeInsets.only(
            left: 15, right: 15,
            top: 20, bottom: 3
          ),
          child: Text(
            '${dataPublic['pbl_queVendes']}',
            textScaleFactor: 1,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 22
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              '$precio',
              textScaleFactor: 1,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 19
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.timer, size: 16, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                'Publicado el: ${_dateFormat.format(fecha)}',
                textScaleFactor: 1,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15
                ),
              )
            ],
          ),
        ),
        const Divider(
          color: Colors.grey,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 15, right: 15,
            top: 20, bottom: 3
          ),
          child: Text(
            'Detalles de la Unidad:',
            textScaleFactor: 1,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.directions, size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      '${(dataPublic['sa_nombre'] == null) ? 'Vehículos' : dataPublic['sa_nombre']}',
                      textScaleFactor: 1,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.category, size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      '${dataPublic['cat_catego']}',
                      textScaleFactor: 1,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15
                      ),
                    ),
                    const SizedBox(width:15),
                    Icon(Icons.all_inclusive, size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      'No. ${dataPublic['pbl_id']}',
                      textScaleFactor: 1,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 15, right: 15,
            top: 20, bottom: 3
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (tels.isNotEmpty)
              ?
              _machoteBtnAccion(
                icono: FontAwesomeIcons.phone,
                titulo: 'Llamar',
                onTap: () async {
                  String number = '${tels[0]}';
                  await FlutterPhoneDirectCaller.callNumber(number);
                }
              )
              :
              const SizedBox(width: 0),
              SizedBox(width: spaceIcos),
              _machoteBtnAccion(
                icono: FontAwesomeIcons.whatsapp,
                titulo: 'Whatsapp',
                onTap: () {
                  String phoneNumber = '+52$whats';
                  String message = 'Te vi en ZonaMotora y necesito ';
                  //whats = 'https://api.whatsapp.com?text=Hello there!';
                  whats = 'https://wa.me/$phoneNumber/?text=${Uri.parse(message)}';
                  _intentLanzar(uri: whats);
                }
              ),
              SizedBox(width: spaceIcos),
              SizedBox(width: spaceIcos),

              FavoritosIconosWidget(
                contextSend: this.contextSend,
                tipoIcon: 'big',
                publicacion: dataPublic,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 15, right: 15,
            top: 20, bottom: 3
          ),
          child: Text(
            '${dataPublic['pbl_descripcion']}',
            textScaleFactor: 1,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18
            ),
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
  
  ///
  Future<void> _intentLanzar({
    String uri
  }) async {

    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'No se pudo abrir $uri';
    }
  }

  ///
  void _cerrarficha() {}

  ///
  Widget _cabeceraFicha(String fotoMain) {

    return Container(
      width: MediaQuery.of(this.contextSend).size.width,
      height: MediaQuery.of(this.contextSend).size.height * 0.3,
      child: Stack(
        overflow: Overflow.visible,
        children: [
          CachedNetworkImage(
            imageUrl: fotoMain,
            placeholder: (_,__) => Image(image: AssetImage('assets/images/no-image.png')),
          ),
          Container(
            width: MediaQuery.of(this.contextSend).size.width,
            height: MediaQuery.of(this.contextSend).size.height * 0.3,
            decoration: BoxDecoration(
              color: Color(0xff002f51).withAlpha(100)
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: InkWell(
              onTap: () => Navigator.of(this.contextSend).pop(true),
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                  border: Border.all()
                ),
                child: Icon(Icons.arrow_downward, color: Colors.black),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white,
                border: Border.all()
              ),
              child: Text(
                'Ver Galería',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.black
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget _machoteBtnAccion({
    IconData icono,
    String titulo,
    Function onTap
  }) {

    return InkWell(
      onTap: () => onTap(),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: FaIcon(icono, color: Colors.black),
          ),
          Text(
            '$titulo',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.blueGrey
            ),
          )
        ],
      ),
    );
  }

  ///
  Future<Map<String, dynamic>> _getDataPublicacion(int idPublic) async {

    return await emPublic.getPublicacionById(dataPublic['cat_id'], idPublic);
  }

  ///
  Future<void> _sacarDeFavoritos(int idPublicacion) async {

    String body = '¿Estas segur@ de querer ELIMINAR esta publicación de tus FAVORITOS?';
    bool res = await alertsVarios.aceptarCancelar(this.contextSend, titulo: 'SACAR DE FAVORITOS', body: body);
    if(res) {
      res = await emFavs.deleteFav(idPublicacion);
      Provider.of<DataShared>(this.contextSend, listen: false).setCantFavs(
        await emFavs.getCantFav()
      );
    }
  }

}