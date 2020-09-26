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
      selectedItemColor: Colors.orange,
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
            Navigator.of(context).pushReplacementNamed('notificaciones_page');
            break;
          case 2:
            Navigator.of(context).pushReplacementNamed('favs_servs_index_page');
            break;
          case 3:
            Navigator.of(context).pushReplacementNamed('favs_autos_index_page');
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
          icon: Stack(
            overflow: Overflow.visible,
            children: [
              Icon(Icons.star, color: Colors.blueGrey, size: 27),
              Positioned(
                right: -10,
                top: -5,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red[200],
                  child: Consumer<DataShared>(
                    builder: (_, dataShared, __){
                      return Text(
                        '${dataShared.cantFavRefacs}',
                        textScaleFactor: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.white
                        ),
                      );
                    },
                  )
                ),
              )
            ],
          ),
          title: Text(
            'Favoritos',
            textScaleFactor: 1,
          ),
        ),
        BottomNavigationBarItem(
          icon: Consumer<DataShared>(
            builder: (BuildContext _context, dataShared, _){
              int cantidad = 0;
              Color bg = Colors.red[200];
              Color bgIcon = Colors.blueGrey;

              if(dataShared.showNotif){
                cantidad = dataShared.cantNotif;
                bg = Colors.red;
                bgIcon = Colors.orange;
              }

              return Stack(
                overflow: Overflow.visible,
                children: [
                  Icon(Icons.notifications_active, color: bgIcon, size: 27),
                  Positioned(
                    right: -10,
                    top: -5,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: bg,
                      child: Text(
                        '$cantidad',
                        textScaleFactor: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.white
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
          title: Text(
            'Avisos',
            textScaleFactor: 1,
          )
        ),
        // BottomNavigationBarItem(
        //   icon: Stack(
        //     overflow: Overflow.visible,
        //     children: [
        //       Icon(Icons.directions_car, color: Colors.blueGrey),
        //       Positioned(
        //         right: -10,
        //         top: -5,
        //         child: CircleAvatar(
        //           radius: 8,
        //           backgroundColor: Colors.red[200],
        //           child: Consumer<DataShared>(
        //             builder: (_, dataShared, __){
        //               return Text(
        //                 '${dataShared.cantFavAutos}',
        //                 textScaleFactor: 1,
        //                 style: TextStyle(
        //                   fontWeight: FontWeight.bold,
        //                   fontSize: 10,
        //                   color: Colors.white
        //                 ),
        //               );
        //             },
        //           )
        //         ),
        //       )
        //     ],
        //   ),
        //   title: Text(
        //     'Autos',
        //     textScaleFactor: 1,
        //   )
        // ),
        BottomNavigationBarItem(
          icon: Stack(
            overflow: Overflow.visible,
            children: [
              Icon(Icons.shopping_cart, color: Colors.blueGrey, size: 27),
              Positioned(
                right: -10,
                top: -5,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red[200],
                  child: Consumer<DataShared>(
                    builder: (_, dataShared, __){
                      return Text(
                        '${dataShared.cantInCarrito}',
                        textScaleFactor: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.white
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