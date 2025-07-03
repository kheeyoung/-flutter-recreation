class MapPointDTO{
  String _uid;
  String _title;
  String _text;
  String _lock;
  int _order;
  String _image;
  List<String> _point;
  String _parent;

  MapPointDTO(this._uid, this._title, this._text, this._lock, this._order,
      this._image, this._point, this._parent);

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get title => _title;

  String get parent => _parent;

  set parent(String value) {
    _parent = value;
  }

  List<String> get point => _point;

  set point(List<String> value) {
    _point = value;
  }

  String get image => _image;

  set image(String value) {
    _image = value;
  }

  int get order => _order;

  set order(int value) {
    _order = value;
  }

  String get lock => _lock;

  set lock(String value) {
    _lock = value;
  }

  String get text => _text;

  set text(String value) {
    _text = value;
  }

  set title(String value) {
    _title = value;
  }
}