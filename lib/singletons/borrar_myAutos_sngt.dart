
class MyAutosSngt {

  static MyAutosSngt _myAutosSngt = MyAutosSngt._();
  MyAutosSngt._();
  factory MyAutosSngt() {

    if(_myAutosSngt == null) {
      _myAutosSngt = MyAutosSngt();
    }
    return _myAutosSngt;
  }

  /// --------------------------------------------------///

  dispose() {
    this.pageCall = null;
    this.modSelecc = null;
    this.anio = null;
    this.version = null;
    this.createdAt = null;
  }

  /* Para saber desde que pagina fue inicializado este singleton */
  String pageCall;
  ///
  int modSelecc;
  ///
  int anio;
  ///
  String version;
  ///
  DateTime createdAt;
}