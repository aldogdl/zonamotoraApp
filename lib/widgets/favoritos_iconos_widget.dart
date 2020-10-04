import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/favoritos_repository.dart';

class FavoritosIconosWidget extends StatefulWidget {

  final Map<String, dynamic> publicacion;
  final String tipoIcon;
  final BuildContext contextSend;

  FavoritosIconosWidget({this.contextSend, this.publicacion, this.tipoIcon});

  @override
  _FavoritosIconosWidgetState createState() => _FavoritosIconosWidgetState();
}

class _FavoritosIconosWidgetState extends State<FavoritosIconosWidget> {

  FavoritosRepository emFavs = FavoritosRepository();

  @override
  Widget build(BuildContext context) {

    context = null;

    return FutureBuilder(
      future: _isInFav(),
      builder: (_, AsyncSnapshot snapshot) {

        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.data){
            return (widget.tipoIcon == 'big') ? _icoBigStartInActive() : _icoSmallStartInActive();
          }else{
            return (widget.tipoIcon == 'big') ? _icoBigStartActive() : _icoSmallStartActive();
          }
        }

        return _machoteBigFav(
          titulo: 'A Favoritos',
          bg: Colors.grey[400],
          iconoColor: Colors.grey
        );
      },
    );
  }

  ///
  Widget _icoBigStartActive() {

    return InkWell(
      onTap: () async{
        await _putInFav();
        setState(() { });
      },
      child: _machoteBigFav(
        titulo: 'A Favoritos',
        bg: Colors.grey[300],
        iconoColor: Colors.black
      ),
    );
  }

  ///
  Widget _icoBigStartInActive() {

    return  _machoteBigFav(
      titulo: 'En Favoritos',
      bg: Color(0xff002f51),
      iconoColor: Colors.yellow
    );
  }

  ///
  Widget _machoteBigFav({
    String titulo,
    Color bg,
    Color iconoColor
  }) {

    return Column(
      children: [
        CircleAvatar(
          backgroundColor: bg,
          child: Icon(Icons.star, color: iconoColor),
        ),
        Text(
          '$titulo',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.blueGrey
          ),
        )
      ],
    );
  }

  ///
  Widget _icoSmallStartActive() {

    return InkWell(
      onTap: () async {
        await _putInFav();
        setState(() { });
      },
      child:  _machoteSmallFav(
        bg: Color(0xff002f51),
        iconoColor: Colors.yellow
      ),
    );
  }

  ///
  Widget _icoSmallStartInActive() {

    return  _machoteSmallFav(
      bg: Color(0xff002f51),
      iconoColor: Colors.yellow
    );
  }

    ///
  Widget _machoteSmallFav({
    Color bg,
    Color iconoColor
  }) {

    return Column(
      children: [
        CircleAvatar(
          backgroundColor: bg,
          child: Icon(Icons.star, color: iconoColor),
        ),
      ],
    );
  }

  ///
  Future<bool> _isInFav() async {

    return emFavs.isInFavs(widget.publicacion['pbl_id']);
  }

  ///
  Future<bool> _putInFav() async {

    bool saved = await emFavs.setInFav(widget.publicacion);
    if(saved){
      Provider.of<DataShared>(widget.contextSend, listen: false).setCantFavs(
        await emFavs.getCantFav()
      );
    }
    return saved;
  }
}