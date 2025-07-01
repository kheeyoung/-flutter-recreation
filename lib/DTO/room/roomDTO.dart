class RoomDto{
  String _uid;
  String _name;
  String _pw;
  int _pos;

  RoomDto(this._uid, this._name, this._pw, this._pos);

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get name => _name;

  int get pos => _pos;

  set pos(int value) {
    _pos = value;
  }

  String get pw => _pw;

  set pw(String value) {
    _pw = value;
  }

  set name(String value) {
    _name = value;
  }
}