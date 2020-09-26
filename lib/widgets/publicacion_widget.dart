import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:zonamotora/globals.dart' as globals;
import 'package:zonamotora/repository/publicar_repository.dart';
import 'package:zonamotora/widgets/dialog_ver_fotos.dart';
import 'package:zonamotora/widgets/load_sheetbutom_widget.dart';

class PublicacionWidget extends StatelessWidget {

  final PublicarRepository emPublic = PublicarRepository();

  final BuildContext contextSend;
  final Map<String, dynamic> dataPublic;
  final double tamWid;
  final DateFormat _dateFormat = DateFormat('d-MM-yyyy');

  PublicacionWidget({Key key, this.contextSend, this.dataPublic, this.tamWid}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(4),
      width: MediaQuery.of(context).size.width * this.tamWid,
      color: Colors.white,
      child: (dataPublic.isNotEmpty) ? _widgetConData() : _widgetSinData(),
    );
  }

  ///
  Widget _widgetConData() {

    final precio = NumberFormat.currency(locale: 'en_US', symbol: '\$').format(dataPublic['pbl_precio']);

    return InkWell(
      onTap: (){
        _verFicha();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: '${globals.uriImagePublica}/${dataPublic['u_id']}/${dataPublic['pbl_fotos']}',
              placeholder: (_,__) => Image(image: AssetImage('assets/images/no-image.png')),
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
          height: MediaQuery.of(this.contextSend).size.height * 0.95,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white,
                Colors.white,
                Colors.white,
                Colors.white,
                Colors.orange[100]
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

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            showDialog(
              context: this.contextSend,
              builder: (BuildContext context) {
                return DialogVerFotosWidget(
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            '$precio',
            textScaleFactor: 1,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              fontSize: 19
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
              _machoteBtnAccion(
                icono: Icons.phone,
                titulo: 'Llamar',
                onTap: (){}
              ),
              SizedBox(width: spaceIcos),
              _machoteBtnAccion(
                icono: Icons.message,
                titulo: 'Whatsapp',
                onTap: (){}
              ),
              SizedBox(width: spaceIcos),
              SizedBox(width: spaceIcos),
              _machoteBtnAccion(
                icono: Icons.star,
                titulo: 'A Favoritos',
                onTap: (){}
              ),
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
      ],
    );
  }
  
  ///
  void _cerrarficha() { }

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
              color: Colors.black.withAlpha(100)
            ),
          ),
          Container(
            height: MediaQuery.of(this.contextSend).size.height * 0.05,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)
              ),
              color: Colors.deepOrange 
            ),
          ),
          Positioned(
            top: 10,
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
                'Galería',
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
      onTap: () => onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Icon(icono, color: Colors.black),
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
}