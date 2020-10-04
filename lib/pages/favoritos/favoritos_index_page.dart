import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/app_varios_repository.dart';
import 'package:zonamotora/repository/favoritos_repository.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/plantilla_base.dart';
import 'package:zonamotora/widgets/publicacion_widget.dart';
import 'package:zonamotora/widgets/sin_piezas_widget.dart';

class FavoritosIndexPage extends StatefulWidget {
  @override
  _FavoritosIndexPageState createState() => _FavoritosIndexPageState();
}

class _FavoritosIndexPageState extends State<FavoritosIndexPage> {

  FavoritosRepository emFavs = FavoritosRepository();
  MenuInferior menuInferior = MenuInferior();
  AppVariosRepository emVarios = AppVariosRepository();
  AlertsVarios alertsVarios = AlertsVarios();

  List<Map<String, dynamic>> favoritos = new List();
  List<Map<String, dynamic>> categos = new List();
  String _username;
  bool _isInit = false;

  @override
  Widget build(BuildContext context) {

    if(!this._isInit) {
      this._isInit = true;
      this._username = Provider.of<DataShared>(context, listen: false).username;
    }

    return PlantillaBase(
      pagInf: 3,
      context: context,
      activarIconInf: true,
      isIndex: false,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: _body(context)
      )
    );
  }

  ///
  Widget _body(BuildContext context) {

    return FutureBuilder(
      future: _getAllsFavoritos(),
      builder: (_, AsyncSnapshot snapshot) {

        if(snapshot.connectionState == ConnectionState.done) {
          if(favoritos.isNotEmpty){
            return _createList(context);
          }else{
            return _sinFavoritos(context);
          }
        }
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: LinearProgressIndicator(),
        );

      },
    );
  }

  ///
  Widget _createList(BuildContext context) {

    List<Widget> lstFavsWidgets  = new List();

    lstFavsWidgets.add(
      Padding(
        padding: EdgeInsets.only(top: 0, right: 20, bottom: 10, left: 20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 40,
          child: RaisedButton.icon(
            color: Colors.red,
            textColor: Colors.white,
            icon: Icon(Icons.clear_all),
            label: Text(
              'Limpiar mis Favoritos',
              textScaleFactor: 1,
            ),
            onPressed: () async {
              String body = 'Se eliminarán todas las publicaciones que tiene en sus Favoritos.\n\n¿Estas segur@ de Continuar?';
              bool res = await alertsVarios.aceptarCancelar(context, titulo: 'LIMPIAR LISTA', body: body);
              if(res) {
                res = await emFavs.deleteAllFavs();
                if(res){
                  Provider.of<DataShared>(context, listen: false).setCantFavs(0);
                  setState(() {});
                }
              }
            },
          ),
        ),
      )
    );

    if(categos.isNotEmpty){
      categos.forEach((cat) {

        List<Map<String, dynamic>> favs = favoritos.where((element) => element['cat_id'] == cat['cat_id']).toList();

        if(favs.isNotEmpty){
          lstFavsWidgets.add( _getDivisor(titulo: cat['cat_catego'], cant: favs.length) );
          for (var i = 0; i < favs.length; i++) {  
            lstFavsWidgets.add(
              PublicacionWidget(
                contextSend: context,
                dataPublic: favs[i],
                typo: 'big',
                deleteFav: (){
                  favoritos.removeWhere((element) => element['pbl_id'] == favs[i]['pbl_id']);
                  setState(() { });
                },
                tamWid: 0
              )
            );
          }
        }
      });

      int alto = (this._username == 'Anónimo') ? 210 : 195;

      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - alto,
        child: ListView(
          shrinkWrap: true,
          children: lstFavsWidgets,
        ),
      );

    }else{
      return Text('Error al cargar los datos, intentalo nuevamente');
    }
  }

  ///
  Widget _sinFavoritos(BuildContext context) {

    String txt2 = 'Navega entre las publicaciones de Autopartes, Vehículos y Servicios para guardar en esta sección todas las que te van interesando.';
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SinPiezasWidget(txt1: 'AÚN SIN FAVORITOS', txt2: txt2)
    );
  }

  ///
  Widget _getDivisor({String titulo, int cant}) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$titulo',
                textScaleFactor: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black54
                ),
              ),
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.blue,
                child: Text(
                  '$cant',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              )
            ],
          ),
        ),
        Divider(
          height: 1,
          color: Colors.blueGrey,
        ),
      ],
    );
  }

  ///
  Future<bool> _getAllsFavoritos() async {

    favoritos = await emFavs.getAll();
    categos = await emVarios.getCategosToLocal();
    return false;
  }

}