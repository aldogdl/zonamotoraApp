import 'package:flutter/material.dart';

class MenuDialogAltaWidget {

  Future<Widget> showDialogMenu(BuildContext context, List<Map<String, dynamic>> menu) async {

    bool isSmall = (MediaQuery.of(context).size.height <= 550) ? true : false;

    return await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          title: (isSmall)
          ? Text(
              '¿DÓNDE QUIERES IR?',
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.blue
              ),
            )
          : Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red,
                            Colors.black
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      ),
                      child: Image(
                        image: AssetImage('assets/images/donde_ir.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Text(
                      '¿DÓNDE QUIERES IR?',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  )
                ],
              ),
            ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget> [
              Container(
                height: MediaQuery.of(context).size.height * ((isSmall) ? 0.55 : 0.47),
                child: ListView.builder(
                  itemCount: menu.length,
                  itemBuilder: (_, int index) {
                    return ListTile(
                      contentPadding: EdgeInsets.all(0),
                      trailing: Icon(Icons.arrow_forward_ios, size: 15),
                      dense: true,
                      title: Text(
                        '${menu[index]['titulo']}',
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: (){
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '${menu[index]['ruta']}',
                          (Route rutas) => false
                        );
                      },
                    );
                  },
                ),
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                trailing: Icon(Icons.arrow_forward_ios, size: 15),
                dense: true,
                title: Text(
                  'RESUMEN',
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                onTap: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    'alta_save_resum_page',
                    (Route rutas) => false
                  );
                },
              )
            ],
          ),
        );
      }
    );
  }


}