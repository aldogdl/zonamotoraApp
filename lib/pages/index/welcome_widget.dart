import 'package:flutter/material.dart';

class WelcomeWidget {

  Size _screen;

  Widget getWelcomeWidget(BuildContext context) {

    this._screen = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: this._screen.width,
      height: this._screen.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Text(
                '¿Esta es tu primera vez?',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const Text(
              'TE DAMOS LA BIENVENIDA A ZONA MOTORA',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: this._screen.width,
              height: this._screen.height * 0.35,
              child: Image(
                image: AssetImage('assets/images/call_center.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              '¿SABIAS que, podemos buscarte la mejor opción en Refacciones totalmente GRATIS?',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Somos el buscador de refacciones Seminuevas y Genericas número uno.',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Contamos con más de 100 proveedores.',
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]
              ),
            ),

            const SizedBox(height: 20),
            _btnNoVerEstaVentana(context),

            const SizedBox(height: 10),
            const Text(
              '¿QUIERES SABER MÁS? ...',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
              ),
            ),

            const SizedBox(height: 20),
            getDivisor('Nuestro departamento Automotriz'),
            const SizedBox(height: 15),
            const Text(
              'Extrenar un auto seminuevo con ZonaMotora es muy fácil, nosotros te '+
              'Compramos, Vendemos y Cambiamos tu vehículo actual buscandote la mejor ' +
              'opción en el mercado.',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 17,
                height: 1.5
              ),
            ),
            const SizedBox(height: 6),
            _btnEntendido(context),

            const SizedBox(height: 20),
            getDivisor('Servicios para tu AUTO'),
            const SizedBox(height: 15),
            const Text(
              'Registramos a todo profesional del ramo automotiz que ofrezca servicios '+
              'de cualquier tipo para tu vehículo donde constantemente están publicando ofertas ' +
              'y promocionando servicios exclusivos para ti.',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 17,
                height: 1.5
              ),
            ),
            const SizedBox(height: 6),
            _btnEntendido(context),

            const SizedBox(height: 20),
            getDivisor('OTROS SERVICIOS'),
            const SizedBox(height: 15),
            const Text(
              'TU AUTO EN TU NUEVA APLICACIÓN',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 17,
                height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.orange
              ),
            ),
            const Text(
              'Registra tu auto en esta tu nueva aplicación, para que todo se filtre de acuerdo '+
              'a lo que realmente te intereza. Hacerlo es muy seguro ya que no solicitamos ' +
              'información que pueda comprometer tu privacidad y sin embargo adquieres muchas ventajas interesantes.',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 17,
                height: 1.5
              ),
            ),
            const SizedBox(height: 6),
            _btnEntendido(context),
            const SizedBox(height: 20),
            _btnNoVerEstaVentana(context)
          ],
        ),
      ),
    );
  }

  ///
  Widget getDivisor(String titulo) {

    return Column(
      children: [
        Divider(
          height: 2,
          color: Colors.red,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 7),
          child: Text(
            '$titulo',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Divider(
          height: 2,
          color: Colors.red,
        )
      ],
    );
  }

  ///
  Widget _btnNoVerEstaVentana(BuildContext context) {

    return SizedBox(
      width: this._screen.width,
      height: 50,
      child: RaisedButton(
        child: const Text(
          'NO VOLVER A MOSTRAR ESTE MENSAJE',
          textScaleFactor: 1,
        ),
        color: Color(0xff002f51),
        textColor: Colors.white,
        onPressed: (){
          Navigator.of(context).pop(false);
        },
      ),
    );
  }
  
  ///
  Widget _btnEntendido(BuildContext context) {

    return Align(
      alignment: Alignment.centerRight,
      child: FlatButton.icon(
        icon: Icon(Icons.check),
        label: Text(
          'ENTENDIDO',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18
          ),
        ),
        onPressed: (){
          Navigator.of(context).pop(true);
        },
      ),
    );
  }
}