import 'package:flutter/material.dart';

class MenuInferior {

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
            Navigator.of(context).pushReplacementNamed('index_page');
            break;
          case 1:
            Navigator.of(context).pushReplacementNamed('autos_index_page');
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
          icon: Icon(Icons.directions_bus),
          title: Text(
            'Autos',
            textScaleFactor: 1,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          title: Text(
            'Servicios',
            textScaleFactor: 1,
          )
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.scatter_plot),
          title: Text(
            'Accesorios',
            textScaleFactor: 1,
          )
        ),
      ],
    );
  }

}