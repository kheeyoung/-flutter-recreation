class PetDTO{
  String _uid;
  String _name;
  int _happy; // 0 : 불행하여 가출 100: 궁전으로 가버림
  int _hunger; //0 : 굶어 죽다  100 : 식탐에 눈을 뜬 펫
  int _fatigue; // 0: 과로사 100: 해적왕이 되러 가출
  int _level;
  int _subLevel;
  String _species;
  int _isDead;

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  PetDTO(this._uid, this._name, this._happy, this._hunger, this._fatigue,
      this._level, this._subLevel, this._species, this._isDead);

  String get name => _name;

  int get isDead => _isDead;

  set isDead(int value) {
    _isDead = value;
  }

  String get species => _species;

  set species(String value) {
    _species = value;
  }

  int get subLevel => _subLevel;

  set subLevel(int value) {
    _subLevel = value;
  }

  int get level => _level;

  set level(int value) {
    _level = value;
  }

  int get fatigue => _fatigue;

  set fatigue(int value) {
    _fatigue = value;
  }

  int get hunger => _hunger;

  set hunger(int value) {
    _hunger = value;
  }

  int get happy => _happy;

  set happy(int value) {
    _happy = value;
  }

  set name(String value) {
    _name = value;
  }
}