
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
    pageCall = null;
    modSelecc = null;
    anio = null;
    createdAt = null;
  }

  /* Para saber desde que pagina fue inicializado este singleton */
  String pageCall;
  /* */
  int modSelecc;
  /* */
  int anio;
  /* */
  DateTime createdAt;
}