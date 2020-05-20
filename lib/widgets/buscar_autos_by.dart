import 'package:flutter/material.dart';
import 'package:zonamotora/repository/autos_repository.dart';
import 'package:zonamotora/singletons/buscar_autos_sngt.dart';

class BuscarAutosBy extends StatefulWidget {

  final String titulo;
  final String subTitulo;
  final String autosBy;
  BuscarAutosBy({Key key, this.titulo, this.subTitulo, this.autosBy}) : super(key: key);

  @override
  _BuscarAutosByState createState() => _BuscarAutosByState();
}

class _BuscarAutosByState extends State<BuscarAutosBy> {

  BuscarAutosSngt buscarAutosSngt = BuscarAutosSngt();
  AutosRepository autos = AutosRepository();
  List<Map<String, dynamic>> _autosAll = new List();
  List<Map<String, dynamic>> _autosFilter = new List();

  BuildContext _context;
  String _idKey = 'mk_id';
  String _nombreKey = 'mk_nombre';

  @override
  void initState() {

    if(widget.autosBy == 'modelos') {
      this._idKey = 'md_id';
      this._nombreKey = 'md_nombre';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;

    return Scaffold(
      backgroundColor: Colors.black.withAlpha(50),
      extendBody: true,
      body: Container(
        width: MediaQuery.of(this._context).size.width,
        height: MediaQuery.of(this._context).size.height,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red[100],
            border: Border.all(color: Colors.grey, width: 2),
          ),
          child: _body(),
        ),
      ),
    );
  }

  ///
  Widget _body() {

    double alto = (MediaQuery.of(this._context).size.height >= 550) ? 0.6 : 0.7; 
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(
            widget.titulo,
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 28,
              color: Colors.deepOrange
            ),
          ),
          Text(
            widget.subTitulo,
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: _inputBuskAuto(context),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * alto,
            child: FutureBuilder(
              future: _getAutos(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData) {
                  return snapshot.data;
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          )
        ],
      ),
    );
  }

  ///
  Widget _inputBuskAuto(BuildContext context) {

    return TextField(
      maxLines: 1,
      autofocus: true,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.only(left: 10, top: 0),
        suffixIcon: InkWell(
          onTap: (){
            Navigator.of(context).pop(false);
          },
          child: Container(
            height: 40,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.red,
              border: Border.all(
                color: Colors.red[600],
                width: 1
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  offset: Offset(1, 0)
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Icon(Icons.close, size: 24, color: Colors.white),
                const SizedBox(height: 1),
                Text(
                  'Cerrar',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            )
          ),
        ),
        border: InputBorder.none,
        hintText: 'Buscar AQUÍ...'
      ),
      onChanged: (String txt) => _hacerBuscquedaDeAutos(txt),
    );
  }

  ///
  Future<Widget> _getAutos() async {

    if(this._autosAll.length == 0) {
      this._autosAll = (widget.autosBy == 'modelos') ? await autos.getModelos(buscarAutosSngt.idMarca) : await autos.getMarcas();
      this._autosFilter = this._autosAll;
    }

    return ListView.builder(
      itemCount: this._autosFilter.length,
      itemBuilder: (_, int index) {
        return ListTile(
          leading: Icon(Icons.directions_car, color: Colors.black),
          dense: true,
          title: Text(
            '${ this._autosFilter[index][this._nombreKey] }',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2
            ),
          ),
          onTap: () {
            if(widget.autosBy == 'modelos'){
              buscarAutosSngt.setIdModelo(this._autosFilter[index][this._idKey]);
              buscarAutosSngt.setNombreModelo(this._autosFilter[index][this._nombreKey]);
            }else{
              if(this._autosFilter[index][this._idKey] != buscarAutosSngt.idMarca){
                buscarAutosSngt.setIdModelo(null);
                buscarAutosSngt.setNombreModelo(null);
              }
              buscarAutosSngt.setIdMarca(this._autosFilter[index][this._idKey]);
              buscarAutosSngt.setNombreMarca(this._autosFilter[index][this._nombreKey]);
            }
            Navigator.of(context).pop(false);
          },
        );
      },
    );
  }

  ///
  void _hacerBuscquedaDeAutos(String txt) {

    this._autosFilter = new List();
    this._autosAll.forEach((autos){
      if(autos[this._nombreKey].toString().toLowerCase().startsWith(txt.toLowerCase())) {
        this._autosFilter.add(autos);
      }
    });
    setState(() { });
  }

}