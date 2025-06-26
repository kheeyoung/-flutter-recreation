class WikiDto{
  String _name;
  String _color;
  String _talent;
  String _uid;

  WikiDto(this._name, this._color, this._talent, this._uid, this._private);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  bool _private;

  String get color => _color;

  set color(String value) {
    _color = value;
  }

  String get talent => _talent;

  set talent(String value) {
    _talent = value;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  bool get private => _private;

  set private(bool value) {
    _private = value;
  }
}