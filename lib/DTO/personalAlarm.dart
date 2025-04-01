class PersonalAlarm{
  String _title;
  String _contents;


  PersonalAlarm(this._title, this._contents,  this._date);

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String _date;

  String get contents => _contents;

  set contents(String value) {
    _contents = value;
  }



  String get date => _date;

  set date(String value) {
    _date = value;
  }
}