import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/widgets/plantilla_base.dart';

class InfoZmPage extends StatelessWidget {

  final Map<String, dynamic> _btns = {
    'tels' : {
      'btns': [
        {
          'titulo': 'Socio',
          'icono': FontAwesomeIcons.puzzlePiece,
          'campo': 'socios'
        },
        {
          'titulo': 'Lotero',
          'icono': FontAwesomeIcons.car,
          'campo': 'autos'
        },
        {
          'titulo': 'Servicios',
          'icono': FontAwesomeIcons.tools,
          'campo': 'servicios'
        },
        {
          'titulo': 'Cliente',
          'icono': FontAwesomeIcons.headphones,
          'campo': 'soporte'
        },
      ]
    },
    'webs' : {
      'btns': [
        {
          'titulo': 'Facebook',
          'icono': FontAwesomeIcons.facebook,
          'campo': 'facebook'
        },
        {
          'titulo': 'Instagram',
          'icono': FontAwesomeIcons.instagram,
          'campo': 'instagram'
        },
        {
          'titulo': 'YouTube',
          'icono': FontAwesomeIcons.youtube,
          'campo': 'youtube'
        },
        {
          'titulo': 'Linkedin',
          'icono': FontAwesomeIcons.linkedin,
          'campo': 'linkedin'
        },
      ]
    }
  };

  @override
  Widget build(BuildContext context) {

    return PlantillaBase(
      pagInf: 0,
      context: context,
      activarIconInf: false,
      isIndex: false,
      child: _body(context),
    );

  }

  Widget _body(BuildContext context) {

    String username = Provider.of<DataShared>(context, listen: false).username;
    int alto = (username == 'Anónimo') ? 190 : 130;
    List<Map<String, dynamic>> btnsTels = new List<Map<String, dynamic>>.from(this._btns['tels']['btns']);
    List<Map<String, dynamic>> btnsWebs = new List<Map<String, dynamic>>.from(this._btns['webs']['btns']);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - alto,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: const Text(
              '  Porque tu auto lo merece...',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.5
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100].withAlpha(200),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.blueGrey
              )
            ),
            child: const Text(
              'Contamos con 5 departamentos listos para servirte y atender todas '+
              'tus dudas e inquietudes. Contáctanos, y recibirás asistencia a la brevedad posible.',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 15,
                height: 1.5
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: const Text(
              '¿Deseas hacernos una llamada?',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: [
              Divider(
                color: Colors.grey[400]
              ),
              Row(
                children: [
                  Text(
                    'Utiliza las siguientes Lineas si eres: '
                  )
                ],
              ),
              Divider(
                color: Colors.grey[400]
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 85,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15)
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: btnsTels.map((btn){
                  return _btnCall(
                    context: context,
                    titulo: btn['titulo'],
                    icono: btn['icono'],
                    campo: btn['campo'],
                    accion: 'tel',
                  );
                }).toList()
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: const Text(
              'Siguenos en nuestras Redes Sociales',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 85,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15)
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: btnsWebs.map((btn){
                  return _btnCall(
                    context: context,
                    titulo: btn['titulo'],
                    icono: btn['icono'],
                    campo: btn['campo'],
                    accion: 'web',
                  );
                }).toList()
              ),
            ),
          ),
           const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: const Text(
              'Quienes Somos',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            'Somos un conjunto de herramientas tecnológicas y servicios automotrices diseñados '+
            'para satisfacer todas las necesidades y requerimientos de tu auto o negocio automotriz.',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 15,
              height: 1.5
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Nuestro objetivo principal es ser el buscador de refacciones genericas y seminuevas '+
            'número uno en México, trabajando para ti en base a la tecnología moderna para encontrar ' +
            'siempre la mejor opción de compra, con más de 100 socios comerciales para atenderte.',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 15,
              height: 1.5
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'www.zonamotora.com',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5
            ),
          ),
          Divider(
            color: Colors.grey[400]
          ),
          const Text(
            'GRACIAS POR TU CONFIANZA',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5
            ),
          ),
          const SizedBox(height: 70)
        ],
      ),
    );
  }

  ///
  Widget _btnCall({
    BuildContext context,
    String titulo,
    IconData icono,
    String campo,
    String accion
  }) {

    Map<String, dynamic> info = Provider.of<DataShared>(context, listen: false).infoZM;
    var data = info[campo];
    
    return InkWell(
      onTap: () async {

        String accUri;
        if(accion == 'tel'){
          accUri = 'tel:$data}';
        }
        if(accion == 'whats') {
          String message = 'Necesito...';
          accUri = "https://wa.me/$data?text=$message";
        }
        if(accion == 'web') {
          accUri = "$data";
        }

        if (await canLaunch(accUri)) {
          await launch(accUri);
        } else {
          throw 'No se ha podido lanzar $accUri';
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints(
          minWidth: 85,
          maxWidth: 100
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red[100],
              Colors.red[50],
              Colors.red[100],
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              offset: Offset(1,2),
              color: Colors.grey[400]
            )
          ],
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FaIcon(icono),
            const SizedBox(height: 5),
            Text(
              '$titulo',
              textScaleFactor: 1,
            )
          ],
        ),
      ),
    );
  }
}