class petDTO{
  String _name;
  int _level;
  int _exp;
  String _state;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  petDTO(this._name, this._level, this._exp, this._state);

  int get level => _level;

  String get state => _state;

  set state(String value) {
    _state = value;
  }

  int get exp => _exp;

  set exp(int value) {
    _exp = value;
  }

  set level(int value) {
    _level = value;
  }
}