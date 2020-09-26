
class PerfilEntity {

  int    _id;
  String _razonSocial;
  String _nombreContacto;
  String _domicilio;
  String _latLng;
  List<String> _telsContac;
  int _colonia = 0;
  String _email;
  List<String> _roles;
  Map<String, dynamic> _redsocs = new Map();
  String _pagWeb;
  bool   _hasDelivery = false;
  bool   _pagoCard = false;
  String _fachada;

  int get id => this._id;
  void setIdPerfil(int id) => this._id = id;

  ///
  void setRole(String role){
    this._roles = new List();
    this._roles.add(role);
  }
  String get role => (this._roles == null) ? null : this._roles.first;

  /// 
  Map<String, dynamic> get redsocs => this._redsocs;
  ///
  void setRedSocs(String key, String valor){

    if(this._redsocs == null) {
      this._redsocs = new Map();
      this._redsocs[key] = [valor];
    }else{

      if(this._redsocs.containsKey(key)){
        List<dynamic> rs = this._redsocs[key];
        if(!rs.contains(valor)){
          rs.add(valor);
          this._redsocs[key] = rs;
        }
      }else{
        this._redsocs[key] = [valor];
      }
    }
  }
  ///
  bool removeLinkRS(String key, int indice) {

    if(this._redsocs.containsKey(key)){
      List<dynamic> rs = this._redsocs[key];
      rs.removeAt(indice);
      return true;
    }

    return false;
  }

  ///
  void setPaginaWeb(String pw) => this._pagWeb = pw;
  String get paginaWeb => this._pagWeb;

  ///
  void setEmail(String email) => this._email = email;
  String get email => this._email;

  ///
  void setHasDelivery(bool delivery) => this._hasDelivery = delivery;
  bool get hasDelivery => this._hasDelivery;

  ///
  void setPagoCard(bool pagoCard) => this._pagoCard = pagoCard;
  bool get pagoCard => this._pagoCard;

  ///
  void setColonia(int colonia) => this._colonia = colonia;
  int get colonia => this._colonia;

    ///
  void setLatLng(String latLng) => this._latLng = latLng;
  String get latLng => this._latLng;

  ///
  String get direccionForMap => '${this._domicilio}';

  ///
  Map<String, dynamic> toJson() {

    return {
      'id'            : this._id,
      'razonSocial'   : this._razonSocial,
      'nombreContacto': this._nombreContacto,
      'domicilio'     : this._domicilio,
      'colonia'       : this._colonia,
      'latLng'        : this._latLng,
      'telsContac'    : this._telsContac,
      'email'         : this._email,
      'roles'         : this._roles,
      'redsocs'       : this._redsocs,
      'pagWeb'        : this._pagWeb,
      'hasDelivery'   : this._hasDelivery,
      'pagoCard'      : this._pagoCard,
      'fachada'       : this._fachada
    };
  }

  ///
  void hidratarPerfilContact({
    int id,
    String razonSocial,
    String nombreContacto,
    String domicilio,
    List<String> telsContac
  }) {
   
    this._id = id;
    this._razonSocial = razonSocial;
    this._nombreContacto = nombreContacto;
    this._domicilio = domicilio;
    this._telsContac = telsContac;
  }

  ///
  Map<String, dynamic> toJsonPerfilContact() {

     return {
      'id'             : this._id,
      'nombreContacto' : this._nombreContacto,
      'razonSocial'    : this._razonSocial,
      'domicilio'      : this._domicilio,
      'telsContac'     : (this._telsContac != null) ? this._telsContac.join(', ') : ''
     };
  }

  ///
  void dispose() {

    this._id            = null;
    this._razonSocial   = null;
    this._nombreContacto= null;
    this._domicilio     = null;
    this._latLng        = null;
    this._telsContac    = null;
    this._colonia       = 0;
    this._email         = null;
    this._roles         = null;
    this._redsocs       = new Map();
    this._pagWeb        = null;
    this._hasDelivery   = false;
    this._pagoCard      = false;
    this._fachada       = null;
  }
}