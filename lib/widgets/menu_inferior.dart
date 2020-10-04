import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:zonamotora/data_shared.dart';


class MenuInferior {

  /* */
  Widget getMenuInferior(BuildContext context, int indexPage, {homeActive = true}) {
    
    Color azulZm = Color(0xff002f51);
    
    Color colorBg = Colors.grey[300];
    Color noActive = Colors.grey;
    double tamIcos = 20;
    Color isActive = azulZm;
    if(!homeActive){
      isActive = Colors.grey;
    }
    
    return BottomNavigationBar(
      currentIndex: indexPage,
      elevation: 0,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      iconSize: tamIcos,
      selectedLabelStyle: TextStyle(
        color: Colors.blueGrey
      ),
      unselectedLabelStyle: TextStyle(
        color: azulZm
      ),
      selectedItemColor: azulZm,
      unselectedItemColor: Colors.blueGrey,
      selectedFontSize: 10,
      unselectedFontSize: 11,
      type: BottomNavigationBarType.shifting,
      onTap: (int page) {
        switch (page) {
          case 0:
            Navigator.of(context).pushReplacementNamed('refac_index_page');
            break;
          case 1:
            Navigator.of(context).pushReplacementNamed('autos_index_page');
            break;
          case 2:
            Navigator.of(context).pushReplacementNamed('servs_index_page');
            break;
          case 3:
            Navigator.of(context).pushReplacementNamed('favoritos_index_page');
            break;
          default:
          Navigator.of(context).pushReplacementNamed('index_page');
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.puzzlePiece, size: tamIcos, color: noActive),
          activeIcon: FaIcon(FontAwesomeIcons.puzzlePiece, color: isActive),
          backgroundColor: colorBg,
          label: 'AutoPartes'
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.car, size: tamIcos, color: noActive),
          activeIcon: FaIcon(FontAwesomeIcons.car, color: isActive),
          backgroundColor: colorBg,
          label: 'Vehículos'
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.tools, size: tamIcos, color: noActive),
          activeIcon: FaIcon(FontAwesomeIcons.tools, color: isActive),
          backgroundColor: colorBg,
          label: 'Servicios',

        ),
        BottomNavigationBarItem(
          icon: Consumer<DataShared>(
            builder: (_, dataShared, __){

              if(dataShared.cantFavs > 0){
                return SizedBox(
                  width: 40,
                  height: 22,
                  child: Stack(
                    overflow: Overflow.visible,
                    children: [
                      Positioned(
                        top: -5, right: 0,
                        child: CircleAvatar(
                          radius: 7,
                          backgroundColor: Colors.red,
                          child: Text(
                            '${dataShared.cantFavs}',
                            textScaleFactor: 1,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                        )
                      ),
                      Positioned(
                        top: 0, left: 0,
                        child: FaIcon(FontAwesomeIcons.star, size: tamIcos, color: noActive),
                      )
                    ],
                  ),
                );
              }
              return FaIcon(FontAwesomeIcons.star, size: tamIcos, color: noActive);
            },
          ),
          activeIcon: FaIcon(FontAwesomeIcons.star, color: isActive),
          backgroundColor: colorBg,
          label: 'Favoritos'
        )
      ],
    );
  }

}