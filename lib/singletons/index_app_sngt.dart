
class IndexAppSng {

  static IndexAppSng _indexSgn = IndexAppSng._();
  IndexAppSng._();
  factory IndexAppSng() {
    if(_indexSgn == null) { return IndexAppSng._(); }
    return _indexSgn;
  }

  dispose() {
    _indexSgn.dispose();
  }

  Map<String, dynamic> _indexApp = new Map();
  Map<String, dynamic> get indexApp => this._indexApp;
  void setIndexApp(Map<String, dynamic> indexApp){
    this._indexApp = indexApp;
  }
}