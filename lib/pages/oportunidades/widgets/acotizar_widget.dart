import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/globals.dart' as globals;
import 'package:zonamotora/widgets/sin_piezas_widget.dart';
import 'package:zonamotora/pages/oportunidades/widgets/titulo_tab_widget.dart';
import 'package:zonamotora/repository/solicitud_repository.dart';
import 'package:zonamotora/singletons/cotizacion_sngt.dart';


class ACotizarWidget extends StatefulWidget {
  @override
  _ACotizarWidgetState createState() => _ACotizarWidgetState();
}


class _ACotizarWidgetState extends State<ACotizarWidget> {

  CotizacionSngt sngtCot = CotizacionSngt();
  SolicitudRepository emSoli = SolicitudRepository();

  BuildContext _context;
  Size _screen;
  List<Map<String, dynamic>> _pedidos = new List();
  
  @override
  void dispose() {
    sngtCot.hasDataPedidos = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    this._screen = MediaQuery.of(this._context).size;
    context = null;

    return Column(
      children: <Widget>[
        TituloTabWidget(titulo: 'Lista de Oportunidades de VENTA'),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: this._screen.width,
            child: FutureBuilder(
              future: _getPedidoParaCotizar(),
              builder: (_, AsyncSnapshot snapshot) {
                
                if (snapshot.hasData) {
                  if(this._pedidos.length > 0) {
                    return _printPiezasParaCotizar();
                  }else{
                    return SinPiezasWidget(
                      txt1: 'Por el momento no hay Oportunidades de Venta para mostrar.',
                      txt2: 'Estamos en búsqueda constante de clientes, por favor, estate al pendiente.',
                    );
                  }
                }
                return Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  ///
  Future<bool> _getPedidoParaCotizar() async {

    bool has = false;
    //DataShared dataShared = Provider.of<DataShared>(this._context, listen: false);

    if(this._pedidos.length == 0 && !sngtCot.hasDataPedidos){
      sngtCot.hasDataPedidos = false;
      Map<String, dynamic> result = await emSoli.getPedidoParaCotizar();
      if (result.isNotEmpty) {
        if(!result.containsKey('memory')) {

          if(result.containsKey('repeate')) {
            has = await _getPedidoParaCotizar();
          }else{
            this._pedidos = new List<Map<String, dynamic>>.from(result['acotizar']);
            sngtCot.hasDataPedidos = true;
            has = true;
            Provider.of<DataShared>(this._context, listen: false).setOpVtasAcotizar(result['cantidades']['acotizar']);
            Provider.of<DataShared>(this._context, listen: false).setOpVtasApartadas(result['cantidades']['apartadas']);
            Provider.of<DataShared>(this._context, listen: false).setIpVtasInventario(result['cantidades']['inventario']);
          }

        }else{
          has = true;
        }
      }

    }else{
      has = true;
    }
    
    return has;
  }

  ///
  Widget _printPiezasParaCotizar() {

    return ListView.builder(
      itemCount: this._pedidos.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          child: _machoteListTitle(this._pedidos[index]),
          onTap: () {
            sngtCot.hasDataPedidos = true;
            sngtCot.hasDataPieza = false;
            Navigator.of(this._context).pushNamed('crear_cotizacion_page', arguments: {'pieza': this._pedidos[index]});
          },
        );
      }
    );
  }

  ///
  Widget _machoteListTitle(pieza) {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          (pieza['foto'] == '0')
              ? Expanded(
                  flex: 1,
                  child: Container(
                    height: 50,
                    width: 20,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: _placeHolderAvatar(),
                    ),
                  ),
                )
              : Expanded(
                  flex: 1,
                  child: Container(
                    height: 50,
                    width: 20,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: _imagenCache(pieza['foto']),
                    ),
                  ),
                ),
          const SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(this._context).size.width * 0.57,
                      child: Text(
                        pieza['pieza'],
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Text(
                      '12:25 a.m.',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.5,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      pieza['auto'],
                      textScaleFactor: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                    Text(
                      pieza['marca'],
                      textScaleFactor: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  ///
  Widget _imagenCache(String foto) {

    return CachedNetworkImage(
      imageUrl: '${globals.uriImgSolicitudes}/$foto',
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      placeholder: (context, url) {
        return _placeHolderAvatar();
      },
      errorWidget: (context, url, error) {
        return _placeHolderAvatar();
      },
    );
  }

  ///
  Widget _placeHolderAvatar() {
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
        image: DecorationImage(
          image: AssetImage('assets/images/no-image.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
