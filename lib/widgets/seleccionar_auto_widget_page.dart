import 'package:flutter/material.dart';
import 'package:zonamotora/repository/autos_repository.dart';
import 'package:zonamotora/singletons/myAutos_sngt.dart';
import 'package:zonamotora/widgets/app_barr_my.dart';
import 'package:zonamotora/widgets/menu_inferior.dart';
import 'package:zonamotora/widgets/menu_main.dart';
import 'package:zonamotora/widgets/container_inputs.dart';


class SeleccionarAutoWidgetPage extends StatefulWidget {
  @override
  _SeleccionarAutoWidgetPageState createState() => _SeleccionarAutoWidgetPageState();
}

class _SeleccionarAutoWidgetPageState extends State<SeleccionarAutoWidgetPage> {

  AppBarrMy appBarrMy = AppBarrMy();
  MenuInferior menuInferior = MenuInferior();
  AutosRepository emAutos = AutosRepository();
  MyAutosSngt myAutosSngt = MyAutosSngt();
  Size _screen;
  ContainerInput containerInput = ContainerInput();
  List<Map<String, dynamic>> _lstAutos = new List();
  List<Map<String, dynamic>> _lstAutosFind = new List();
  TextEditingController _ctrlBusk = TextEditingController();
  BuildContext _context;

  @override
  void dispose() {
    this._ctrlBusk.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;
    this._screen = MediaQuery.of(this._context).size;
    Map<String, dynamic> params = ModalRoute.of(this._context).settings.arguments;
    myAutosSngt.pageCall = params['backToRoute'];
    params = null;

    return Scaffold(
      appBar: appBarrMy.getAppBarr(titulo: 'Registrar AUTO'),
      backgroundColor: Colors.red[100],
      drawer: MenuMain(),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: SingleChildScrollView(
          child: _body(),
        ),
      ),
      bottomNavigationBar: menuInferior.getMenuInferior(this._context, 0, homeActive: false)
    );
  }

  /* */
  Widget _body() {

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: FlatButton.icon(
            label: Text(
              'REGRESAR',
              textScaleFactor: 1,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 17
              ),
            ),
            icon: Icon(Icons.arrow_back, size: 30),
            onPressed: () {
              Navigator.of(this._context).pushNamedAndRemoveUntil(myAutosSngt.pageCall, (Route ruta) => false);
            },
          ),
        ),
        Divider(height: 2),
        _buscador(),
        const SizedBox(height: 10),
        FutureBuilder(
          future: _getAutos(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasData) {
              if(this._lstAutos.isNotEmpty) {
                return _createLstAutos();
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        )
      ],
    );
  }

  /* */
  Widget _buscador(){
    List<Widget> lstInputs = [
      _inputBusk()
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 100,
      color: Colors.red[200],
      child: containerInput.container(lstInputs, 'buscador'),
    );
  }

  /* */
  Widget _inputBusk() {

    return TextFormField(
      controller: this._ctrlBusk,
      autofocus: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.white,
        hintText: 'Ej. escort'
      ),
      onChanged: (String val) {
        this._lstAutosFind = new List();
        this._lstAutos.forEach((auto){
          if(auto['md_nombre'].toLowerCase().contains(val.toLowerCase())) {
            this._lstAutosFind.add(auto);
          }
        });
        setState(() { });
      },
    );
  }

  /* */
  Widget _createLstAutos() {

    return Container(
      height: this._screen.height * 0.55,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: this._lstAutosFind.length,
        shrinkWrap: true,
        itemBuilder: (context, int indice){
          return ListTile(
            dense: true,
            contentPadding: EdgeInsets.all(0),
            title: Text(
              '${this._lstAutosFind[indice]['md_nombre']}',
              textScaleFactor: 1.2,
            ),
            subtitle: Text(
              '${this._lstAutosFind[indice]['mk_nombre']}  ||  ID: ${this._lstAutosFind[indice]['md_id']}',
              textScaleFactor: 1,
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              myAutosSngt.modSelecc = this._lstAutosFind[indice]['md_id'];
              Navigator.of(this._context).pushNamed('seleccionar_anio_page');
            },
          );
        },
      ),
    );
  }
  
  /* */
  Future<bool> _getAutos() async {
    if(this._lstAutos.length == 0){
      this._lstAutos = await emAutos.getAllAutos();
      this._lstAutosFind = this._lstAutos;
    }
    return false;
  }


}