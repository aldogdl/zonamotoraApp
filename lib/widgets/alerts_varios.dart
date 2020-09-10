import 'package:flutter/material.dart';


class AlertsVarios {

  /* */
  Future<bool> cargando(BuildContext context, {titulo = 'Procesando su solicitud', body: 'original'}) {

    if(body == 'original') {
      body = 'El sistema esta realizando la tarea asignada, por favor, espera un momento';
    }
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            '$titulo',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(45)
                ),
                child: Center(
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(45)
                    ),
                    child: Icon(Icons.wifi_lock, color: Colors.white,),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              LinearProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                '$body',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.blue
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        );
      }
    );
  }

  /* */
  Future<bool> entendido(BuildContext context, {String titulo = 'Procesando su solicitud', String body: 'original', Function redirec}) {

    if(body == 'original') {
      body = 'El sistema esta realizando la tarea asignada, por favor, espera un momento';
    }
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            '$titulo',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(45)
                ),
                child: Center(
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(45)
                    ),
                    child: Icon(Icons.warning, color: Colors.orange),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '$body',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.blue
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.check_circle),
              label: Text(
                'ENTENDIO',
                textScaleFactor: 1,
              ),
              onPressed: () {
                if(redirec != null){
                  redirec();
                }else{
                  Navigator.of(context).pop(true);
                }
              },
            )
          ],
        );
      }
    );
  }

  /* */
  Future<bool> aceptarCancelar(
    BuildContext context,
    {
      String titulo = 'Procesando su solicitud',
      String body: 'original',
      Function redirec,
      bool forceClose = false
    }
  ) {

    if(body == 'original') {
      body = 'El sistema esta realizando la tarea asignada, ¿Estas Segur@?';
    }
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            '$titulo',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(45)
                ),
                child: Center(
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(45)
                    ),
                    child: Icon(Icons.warning, color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '$body',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.blue
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'CANCELAR',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.red
                ),
              ),
              onPressed: () {
                if(redirec != null){
                  (forceClose) ? Navigator.of(context).pop(false) : redirec();
                }else{
                  Navigator.of(context).pop(false);
                }
              },
            ),
            FlatButton(
              child: Text(
                'CONTINUAR',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.blue
                ),
              ),
              onPressed: () {
                if(redirec != null){
                  redirec();
                }else{
                  Navigator.of(context).pop(true);
                }
              },
            )
          ],
        );
      }
    );
  }

  ///
  Widget cargandoStyleWidget(BuildContext context, {titulo = 'Procesando su solicitud', body: 'original'}) {

    if(body == 'original') {
      body = 'El sistema esta realizando la tarea asignada, por favor, espera un momento';
    }
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1,
        vertical: MediaQuery.of(context).size.width * 0.1,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white
      ),
      child: Column(
        children: <Widget>[
          Text(
            '$titulo',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(45)
            ),
            child: Center(
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(45)
                ),
                child: Icon(Icons.wifi_lock, color: Colors.white,),
              ),
            ),
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(),
          const SizedBox(height: 20),
          Text(
            '$body',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.blue
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  /*
   * Un contenedor imprimiendo el error que venga del servidor tipo {'abort' , 'msg', 'body'}
  */
  Widget showErrorFromMapAbort(BuildContext context, Map<String, dynamic> error) {

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ), 
        child: Column(
          children: <Widget>[
            Text(
              '${error['msg']}',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 100, width: 100,
              child: Image(
                image: AssetImage('assets/images/server-error.png'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${error['body']}',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red
              ),
            )
          ],
        ),
      ),
    );
  }


}