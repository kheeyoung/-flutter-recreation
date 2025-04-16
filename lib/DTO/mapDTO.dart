class MapDTO{
  String _image;
  String _lock;
  String _node;
  String _txt;
  List<String> _leafNode;

  String get image => _image;

  set image(String value) {
    _image = value;
  }

  MapDTO(this._image, this._lock, this._node, this._txt, this._leafNode);

  String get lock => _lock;

  List<String> get leafNode => _leafNode;

  set leafNode(List<String> value) {
    _leafNode = value;
  }

  String get txt => _txt;

  set txt(String value) {
    _txt = value;
  }

  String get node => _node;

  set node(String value) {
    _node = value;
  }

  set lock(String value) {
    _lock = value;
  }
}