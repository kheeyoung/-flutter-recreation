class MyMapDTO{
  bool _isLock;
  String _pw;
  List<String> _topNode;

  MyMapDTO(this._isLock, this._pw, this._topNode);

  bool get isLock => _isLock;

  set isLock(bool value) {
    _isLock = value;
  }

  String get pw => _pw;

  List<String> get topNode => _topNode;

  set topNode(List<String> value) {
    _topNode = value;
  }

  set pw(String value) {
    _pw = value;
  }
}