class Inquirydto{
  int _input;
  String _from;
  String _memo;
  String _date;

  Inquirydto(this._input, this._memo, this._from, this._date);

  String get memo => _memo;

  set memo(String value) {
    _memo = value;
  }

  int get input => _input;

  set input(int value) {
    _input = value;
  }

  String get from => _from;

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  set from(String value) {
    _from = value;
  }

}