class RoomItemDto{
  String _id;
  String _name;
  String _text;
  bool _erasable;
  List<String> _underPoint;

  RoomItemDto(
      this._id, this._name, this._text, this._erasable, this._underPoint);

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get name => _name;

  List<String> get underPoint => _underPoint;

  set underPoint(List<String> value) {
    _underPoint = value;
  }

  bool get erasable => _erasable;

  set erasable(bool value) {
    _erasable = value;
  }

  String get text => _text;

  set text(String value) {
    _text = value;
  }

  set name(String value) {
    _name = value;
  }
}