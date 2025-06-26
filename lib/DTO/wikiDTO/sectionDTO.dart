class SectionDto{
  String _title;
  String _image;
  String _oneWord;
  String _content;
  String _id;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  SectionDto(this._title, this._image, this._oneWord, this._content, this._id);

  String get image => _image;

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  String get oneWord => _oneWord;

  set oneWord(String value) {
    _oneWord = value;
  }

  set image(String value) {
    _image = value;
  }
}