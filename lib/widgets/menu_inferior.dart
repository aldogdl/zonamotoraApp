import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/singletons/solicitud_sngt.dart';

class MenuInferior {

  SolicitudSngt solicitudSgtn = SolicitudSngt();

  /* */
  Widget getMenuInferior(BuildContext context, int indexPage, {homeActive = true}) {

    return BottomNavigationBar(
      currentIndex: indexPage,
      unselectedItemColor: Colors.red,
      selectedItemColor: Colors.green,
      elevation: 0,
      onTap: (int page) {
        switch (page) {
          case 0:
            if(solicitudSgtn.onlyRead){
              solicitudSgtn.limpiarSingleton();
            }
            Navigator.of(context).pushReplacementNamed('index_page');
            break;
          case 1:
            Navigator.of(context).pushReplacementNamed('autos_index_page');
            break;
          case 4:
            Provider.of<DataShared>(context, listen: false).setCotizacPageView(2);
            Navigator.of(context).pushReplacementNamed('index_cotizacion_page');
            break;
          default:
          Navigator.of(context).pushReplacementNamed('index_page');
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          activeIcon: (homeActive) ? Icon(Icons.home) : Icon(Icons.home, color: Colors.red),
          title: (homeActive)
          ? Text(
            'Inicio',
            textScaleFactor: 1,
          )
          :
          SizedBox(height: 0),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.extension),
          title: Text(
            'Refacciones',
            textScaleFactor: 1,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.build),
          title: Text(
            'Servicios',
            textScaleFactor: 1,
          )
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car),
          title: Text(
            'Autos',
            textScaleFactor: 1,
          )
        ),
        BottomNavigationBarItem(
          icon: Stack(
            overflow: Overflow.visible,
            children: [
              Icon(Icons.shopping_cart, color: Colors.amber[700]),
              Positioned(
                right: -10,
                top: -5,
                child: CircleAvatar(
                  radius: 8,
                  child: Consumer<DataShared>(
                    builder: (_, dataShared, __){
                      return Text(
                        '${dataShared.cantInCarrito}',
                        textScaleFactor: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10
                        ),
                      );
                    },
                  )
                ),
              )
            ],
          ),
          title: Text(
            'Carrito',
            textScaleFactor: 1,
          )
        ),
      ],
    );
  }

}