class ProfileDTO{
  String _oneWord;
  String _name;
  String _originName;
  String _talent;
  String _bodyImage;
  String _awareness;
  String _age;
  String _birth;
  String _height;
  String _weight;
  String _relationship;
  String _belongings1;
  String _belongings2;
  String _belongings3;


  ProfileDTO(
      this._oneWord,
      this._name,
      this._originName,
      this._talent,
      this._bodyImage,
      this._awareness,
      this._age,
      this._birth,
      this._height,
      this._weight,
      this._relationship,
      this._belongings1,
      this._belongings2,
      this._belongings3);

  String get oneWord => _oneWord;

  set oneWord(String value) {
    _oneWord = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get originName => _originName;

  set originName(String value) {
    _originName = value;
  }

  String get talent => _talent;

  set talent(String value) {
    _talent = value;
  }

  String get bodyImage => _bodyImage;

  set bodyImage(String value) {
    _bodyImage = value;
  }

  String get awareness => _awareness;

  set awareness(String value) {
    _awareness = value;
  }

  String get age => _age;

  set age(String value) {
    _age = value;
  }

  String get birth => _birth;

  set birth(String value) {
    _birth = value;
  }

  String get height => _height;

  set height(String value) {
    _height = value;
  }

  String get weight => _weight;

  set weight(String value) {
    _weight = value;
  }

  String get relationship => _relationship;

  set relationship(String value) {
    _relationship = value;
  }

  String get belongings1 => _belongings1;

  set belongings1(String value) {
    _belongings1 = value;
  }

  String get belongings2 => _belongings2;

  set belongings2(String value) {
    _belongings2 = value;
  }

  String get belongings3 => _belongings3;

  set belongings3(String value) {
    _belongings3 = value;
  }
}