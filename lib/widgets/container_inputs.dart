import 'package:flutter/material.dart';


class ContainerInput {


  /*
   * retornamos un List.builder,
   * ::: se requiere estar dentro de un contenedor con alto determinado :::
  */
  Widget container(List<Widget> listInputs, String tipoFrm, {Color labelColor = Colors.black87, Color bgInput = Colors.white}) {

    return ListView.builder(
      itemCount: listInputs.length,
      itemBuilder: (BuildContext context, int inputIndex) {

        String label = _determinarLabel(tipoFrm, inputIndex);

        if(listInputs[inputIndex].toStringShort() == 'SizedBox') {
          return listInputs[inputIndex];
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            (inputIndex == 0)
            ? const SizedBox(height: 5)
            : (inputIndex < listInputs.length -1)
              ? const SizedBox(height: 20)
              : const SizedBox(height: 0),
            (label.isEmpty)
            ?
            SizedBox(height: 0)
            :
            Text(
              label,
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 17,
                color: labelColor
              ),
            ),
            const SizedBox(height: 10),
            // Contenedor del input
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (inputIndex < listInputs.length -1) ? bgInput : Colors.red[100]
              ),
              child: listInputs[inputIndex],
            )
          ],
        );
      },
    );
  }

  /*
   * Retornamos una Lista de widgets dentro de una COLUMNA
  */
  Widget listWidgets(List<Widget> listInputs, String tipoFrm, {Color labelColor = Colors.black87}) {

    List<Widget> lst = new List();

    for (var inputIndex = 0; inputIndex < listInputs.length; inputIndex++) {

      String label = _determinarLabel(tipoFrm, inputIndex);
      if(inputIndex < listInputs.length) {
        lst.add(const SizedBox(height: 20));
      }

      /// Adicionamos la etiqueta
      if(listInputs[inputIndex].toStringShort() != '_RaisedButtonWithIcon'){
        if(listInputs[inputIndex].toStringShort() != 'SizedBox'){
          lst.add(
            Text(
                label,
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 17,
                  color: labelColor
                ),
                textAlign: TextAlign.start,
              ),
          );
        }
      }

      lst.add(const SizedBox(height: 10));

       if(listInputs[inputIndex].toStringShort() != '_RaisedButtonWithIcon'){
        if(listInputs[inputIndex].toStringShort() != 'SizedBox'){
          lst.add(
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (inputIndex < 5) ? Colors.white : Colors.black,
                border: Border.all(
                  color: Colors.grey[400]
                )
              ),
              child: listInputs[inputIndex],
            )
          );
        }else{
          lst.add( listInputs[inputIndex] );
        }
      }else{
        lst.add(
          Center(
            child: listInputs[inputIndex],
          )
        );
        lst.add(const SizedBox(height: 20));
      }
      
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: lst
    );
  }


  /* */
  String _determinarLabel(String tipoFrm, int inputIndex) {

    switch (tipoFrm) {
      case 'login':
        return _getLoginLabels(inputIndex);
        break;
      case 'registro':
        return _getSolicitudDeRegistroLabels(inputIndex);
        break;
      case 'registro_ind':
        return _getRegistroIndividualLabels(inputIndex);
        break;
      case 'buscador':
        return _getBuscadorlLabels(inputIndex);
        break;
      case 'perfil_contact':
        return _getPerfilContactLabels(inputIndex);
        break;
      case 'perfil_redesSociales':
        return _getPerfilRedesSocialesLabels(inputIndex);
        break;
      case 'colonias':
        return _getColoniasLabels(inputIndex);
        break;
      case 'caracts':
        return _getCaracteristicasLabels(inputIndex);
        break;
      default:
        return '';
    }
  }

  /*
   * Utilizada en la pagina de registro de un COMERCIANTE donde envia solo un mensaje para ser visitado
   */
  String _getLoginLabels(int inputIndex) {

    String label;
    switch (inputIndex) {
      case 0:
        label = '  * Nombre de Usuario:';
        break;
      case 1:
        label = '  * Tu Contraseña:';
        break;
      default:
        label = '';
    }
    
    return label;
  }

  /*
   * Utilizada en la pagina de registro de un COMERCIANTE donde envia solo un mensaje para ser visitado
   */
  String _getSolicitudDeRegistroLabels(int inputIndex) {

    String label;
    switch (inputIndex) {
      case 1:
        label = '  * Teléfono de Contacto';
        break;
      case 2:
        label = '  * Tu nombre, por favor.';
        break;
      case 3:
        label = '  * Calle y Número.';
        break;
      case 4:
        label = '  ¿Tienes página web?, indícala aquí.';
        break;
      case 5:
        label = '';
        break;
      default:
        label = '  * Indicanos a que te dedicas.';
    }
    
    return label;
  }

  /* 
   * Utilizada en la pagina de registro de un PARTICULAR
  */
  String _getRegistroIndividualLabels(int inputIndex) {

    String label;
    switch (inputIndex) {
      case 0:
        label = '  * Tipo de Relación Comercial';
        break;
      case 1:
        label = '  * Nombre Completo del Contacto:';
        break;
      case 2:
        label = '  * No. de Celular principal:';
        break;
      case 3:
        label = '  * Inventa un Nombre de Usuario:';
        break;
      case 4:
        label = '  * Inventa una Contraseña:';
        break;
      default:
        label = '';
    }

    return label;
  }

  /* 
   * Utilizada en la pagina de registro de un PARTICULAR
  */
  String _getBuscadorlLabels(int inputIndex) {

    String label;
    switch (inputIndex) {
      case 0:
        label = '  Busca el AUTO por Modelo';
        break;
      default:
        label = '';
    }

    return label;
  }

  /* 
   * Utilizada en la pagina de registro de un PARTICULAR
  */
  String _getPerfilContactLabels(int inputIndex) {

    String label;
    switch (inputIndex) {
      case 1:
        label = '  *Nombre del Contacto:';
        break;
      case 2:
        label = '  *Nombre del Negocio:';
        break;
      case 3:
        label = '  *Ciudad perteneciente:';
        break;
      case 4:
        label = '  *Domicilio:';
        break;
      case 5:
        label = '  Teléfono Fijo del Local:';
        break;

      default:
        label = '';
    }

    return label;
  }

  /* 
   * Utilizada en la pagina de registro de un PARTICULAR
  */
  String _getCaracteristicasLabels(int inputIndex) {

    String label;
    switch (inputIndex) {
      case 0:
        label = '  *¿Qué Año es el Auto?';
        break;
      case 1:
        label = '  Indica la Versión del Vehículo';
        break;
      default:
        label = '';
    }

    return label;
  }

  /* 
   * Utilizada en la pagina de registro de un PARTICULAR
  */
  String _getPerfilRedesSocialesLabels(int inputIndex) {

    String label;
    switch (inputIndex) {
      case 0:
        label = '  Página Web: www.';
        break;
      case 1:
        label = '  Email';
        break;
      default:
        label = '';
    }

    return label;
  }

  /* 
   * Utilizada en la pagina de registro de un PARTICULAR
  */
  String _getColoniasLabels(int inputIndex) {

    String label;
    switch (inputIndex) {
      case 0:
        label = '  *Nombre';
        break;
      case 1:
        label = '  Alias';
        break;
      default:
        label = '';
    }

    return label;
  }

}