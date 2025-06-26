class DocDto{
  String _title;
  String _content;

  DocDto(this._title, this._content);

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get content => _content;

  set content(String value) {
    _content = value;
  }
}