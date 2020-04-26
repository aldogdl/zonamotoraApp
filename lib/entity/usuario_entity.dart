
class UsuarioEntity {

  int    _uId;
  String _uUsname;
  String _uUspass;
  String _uRoles;
  String _uNombre;
  String _uTokenServer;
  String _uTokenDevices;
  String _movil;

  setId(int id) => this._uId = id;
  get id => this._uId;
  setUsername(String username) => this._uUsname = username;
  setPassword(String password) => this._uUspass = password;
  setNombre(String nombre) => this._uNombre = nombre;
  get nombre => this._uNombre;
  setRoles(String role) => this._uRoles = role;
  setTokenDevice(String token) => this._uTokenDevices = token;
  setTokenServer(String token) => this._uTokenServer = token;

  /* */
  void hidratarFromForm({
    int id,
    String username,
    String password,
    String roles,
    String nombre,
    String tokenServer,
    String tokenDevices,
    String movil
  }){
    this._uId           = id;
    this._uUsname       = username;
    this._uUspass       = password;
    this._uRoles        = roles;
    this._uNombre       = nombre;
    this._uTokenServer  = tokenServer;
    this._uTokenDevices = tokenDevices;
    this._movil         = movil;
  }

  /* */
  Map<String, dynamic> toJson() {
    return {
      'u_id'           : this._uId,
      'u_usname'       : this._uUsname,
      'u_uspass'       : this._uUspass,
      'u_roles'        : this._uRoles,
      'u_nombre'       : this._uNombre,
      'u_tokenServer'  : this._uTokenServer,
      'u_tokenDevices' : this._uTokenDevices,
      'movil'          : this._movil
    };
  }

  /*
   * @see RecoveryCuentaPage::_setCredentialsInDb
  */
  Map<String, dynamic> toDb() {
    return {
      'u_id'           : this._uId,
      'u_usname'       : this._uUsname,
      'u_uspass'       : this._uUspass,
      'u_roles'        : this._uRoles,
      'u_nombre'       : this._uNombre,
      'u_tokenServer'  : this._uTokenServer,
      'u_tokenDevices' : this._uTokenDevices
    };
  }

  /*
   * @see UserRepository::registrarNewUser
  */
  Map<String, dynamic> fromJsontoDb(Map<String, dynamic> data) {
    return {
      'u_id'           : data['u_id'],
      'u_usname'       : data['u_usname'],
      'u_uspass'       : data['u_uspass'],
      'u_roles'        : data['u_roles'],
      'u_nombre'       : data['u_nombre'],
      'u_tokenServer'  : data['u_tokenServer'],
      'u_tokenDevices' : data['u_tokenDevices']
    };
  }

  /* */
  Map<String, dynamic> getJsonForRecoveryData() {
    return {
      'u_usname'       : this._uUsname,
      'u_uspass'       : this._uUspass,
      'u_tokenServer'  : this._uTokenServer,
      'u_tokenDevices' : this._uTokenDevices,
    };
  }

}