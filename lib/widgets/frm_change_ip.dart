import 'package:flutter/material.dart';
import 'package:zonamotora/utils/cambiando_la_ip_dev.dart';

class FrmChangeIpWidget extends StatefulWidget {
  @override
  _FrmChangeIpWidgetState createState() => _FrmChangeIpWidgetState();
}

class _FrmChangeIpWidgetState extends State<FrmChangeIpWidget> {

  TextEditingController _ctrlIp = TextEditingController();
  CambiandoLaIpDev gestionDeIpDev = CambiandoLaIpDev();

  @override
  void dispose() {
    this._ctrlIp?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _getIp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          return _getFrmIP();
        }
        return Center(
          child: SizedBox(
            height: 10,
            width: 10,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
  
  ///
  Widget _getFrmIP() {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100]
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: this._ctrlIp,
              keyboardType: TextInputType.number,
            ),
          ),
          RaisedButton(
            onPressed: (){
              gestionDeIpDev.setIp(this._ctrlIp.text);
              FocusScope.of(context).requestFocus(new FocusNode());
              Navigator.of(context).pop();
            },
            color: Colors.black,
            textColor: Colors.blue[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            child: Text(
              'GRABAR',
              textScaleFactor: 1,
            ),
          )
        ],
      ),
    );
  }

  ///
  Future<String> _getIp() async {

    String ip = await gestionDeIpDev.getIp();
    this._ctrlIp.text = ip;
    return ip;
  }
}