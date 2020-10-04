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
      backgroundColor: Color(0xff002f51),
      extendBody: true,
      body: Container(
        width: MediaQuery.of(this._context).size.width,
        height: MediaQuery.of(this._context).size.height,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.only(
          top: 10, left: 20, right: 8, bottom: 10
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2)
        ),
        child: _body(),
      ),
    );
  }

  ///
  Widget _body() {

    double alto = (MediaQuery.of(this._context).size.height >= 550) ? 0.6 : 0.7;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _cabecera(),
          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.symmetric(vertical: 5),
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: Colors.grey[400]
              )
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
  Widget _cabecera() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.titulo,
                textScaleFactor: 1,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 28,
                  color: Colors.deepOrange
                ),
              ),
              Text(
                widget.subTitulo,
                textScaleFactor: 1,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.grey
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: (){
                Navigator.of(context).pop(false);
              },
              child: Icon(Icons.close, size: 40, color: Colors.blue),
            ),
          ),
        )
      ]
    );
  }
  
  ///
  Widget _inputBuskAuto(BuildContext context) {

    String titulo = (widget.autosBy == 'marca') ? 'Teclea la marca AQUÍ...' : 'Teclea el modelo AQUÍ...';

    return TextField(
      maxLines: 1,
      autofocus: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.only(left: 10, top: 0),
        border: InputBorder.none,
        hintText: '$titulo'
      ),
      onChanged: (String txt) => _hacerBusquedaDeAutos(txt),
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
          leading: Icon(Icons.directions_car, color: Colors.grey),
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
  void _hacerBusquedaDeAutos(String txt) {

    this._autosFilter = new List();
    this._autosAll.forEach((autos){
      if(autos[this._nombreKey].toString().toLowerCase().startsWith(txt.toLowerCase())) {
        this._autosFilter.add(autos);
      }
    });
    setState(() { });
  }

}