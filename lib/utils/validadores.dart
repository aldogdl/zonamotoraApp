class Validadores {

  /* Revisamos que no tenga espacios, ni acentos, ni signos extraños */
  String revisarCamposDeTexto(String txt) {

    RegExp patron = RegExp(r'\s+', multiLine: true);
    var res = patron.hasMatch(txt);
    if(res) { return '   No coloques espacios en blanco'; }

    Map<String, String> result = quitarAcentos(txt);
    if(result['error'] != '0'){
      return result['error'];
    }else{
      txt = result['newtext'];
    }
    patron = RegExp(r"^[0-9]*[a-z0-9]+$");
    List<RegExpMatch> r = patron.allMatches(txt).toList();
    if(r.length == 0) { return '   Quita los signos extraños'; }
    return null;
  }

  /// Revisamos que contenga contenido el txt
  String notNull(String txt, String campo) {
    return (txt.isEmpty) ? 'El $campo, es requerido.' : null;
  }

  /// Revisamos que contenga contenido el txt minimo los caracteres necesario
  /// 
  /// @see AltaPerfilContacPage::_inputRasonSocial
  String longitudMinima(String txt, int long) {
    txt = txt.trim();
    String p = '[a-zA-Z]{$long}';
    RegExp patron = RegExp(p);
    bool res = patron.hasMatch(txt);
    return (!res) ? 'Se requieren mínimo $long caracteres.' : null;
  }

  /// Revisamos un numero de tel
  /// 
  /// @see AltaPerfilContacPage::_intpuTelsContac
  String telefono(String txt, int long) {

    txt = txt.trim();
    bool res;
    String error;
    String p = '[0-9]{$long}';
    RegExp patron = RegExp(p);

    final tels = txt.split(',');
    if(tels.length > 0) {
      for (var i = 0; i < tels.length; i++) {
        tels[i] = tels[i].trim();
        res = patron.hasMatch(tels[i]);
        if(!res) {
          return (!res) ? 'Mínimo $long digitos para ${tels[i]}.' : null;
        }
      }
    }
    return error;
  }

  /// Revisamos un email
  /// 
  /// @see AltaPerfilContacPage::_intpuTelsContac
  Map<String, dynamic> email(String txt) {
    txt = txt.trim();
    txt = txt.toLowerCase();
    txt = txt.replaceAll(' ', '');
    RegExp patron = RegExp(r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");
    bool res = patron.hasMatch(txt);
    return (!res) ? {'error':'El Email no es valido.'} : {'valor':txt};
  }

  /// Revisamos un domicilio
  /// 
  /// @see AltaPerfilContacPage::_intpuDomicilio
  String domicilio(String txt) {

    String error;
    RegExp patron = RegExp(r'[a-zA-Z0-9]{3}\s*');
    bool res = patron.hasMatch(txt);
    error = (!res) ? 'Especifica mejor el domicilio.' : null;
    if(error == null) {
      patron = RegExp(r'[0-9]+');
      res = patron.hasMatch(txt);
      error = (!res) ? 'Indica el Número exterior.' : null;
    }
    return error;
  }

  /// Revisamos un nombre el cual lleva puro texto, este debe contener al menos un apellido
  /// 
  /// @see AltaPerfilContacPage::_inputNombreContacto
  String hasApellido(String txt) {
    String error;
    RegExp patron = RegExp(r'[0-9]', multiLine: true);
    bool res = patron.hasMatch(txt);
    error = (res) ? 'No Coloques números por favor' : null;
    if(error == null){
      patron = RegExp(r'[a-zA-Z]{3}\s+[a-zA-Z]{3}');
      List<RegExpMatch> resList = patron.allMatches(txt).toList();
      error = (resList.length == 0) ? 'Por lo menos indica un Apellido' : null;
    }
    return error;
  }

  /*
   * Eliminamos los acentos de las palabras
   * @see AltaSistemaPalClasPage::_inputPalClas
  */
  Map<String, String> quitarAcentos(String txt) {
    
    Map<String, String> result = {'error':'0', 'newtext':'0'};

    List<String> newString = new List();
    Map<String, String> txtSinAcentos = {'á':'a','é':'e','í':'i','ó':'o','ú':'u'};

    List<String> palabras = txt.split(',');
    palabras.forEach((palabra){
      RegExp exp = RegExp(r'[áéíóú]');
      palabra = palabra.replaceAllMapped(exp, (m){
        return txtSinAcentos[m.group(0)];
      });
      if(palabra.length < 3) {
        result['error'] = 'Se más específico con $palabra';
      }
      newString.add(palabra.trim().toLowerCase());
    });

    if(newString.length > 0){
      result['newtext'] = newString.join(',');
    }

    return result;
  }


}