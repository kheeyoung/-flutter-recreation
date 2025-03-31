class Weatherdto{
  double _temp;
  String _condition;
  int _conditionId;
  int _humidity;

  Weatherdto(this._temp, this._condition, this._conditionId, this._humidity);

  double get temp => _temp;

  set temp(double value) {
    _temp = value;
  }

  String get condition => _condition;

  int get humidity => _humidity;

  set humidity(int value) {
    _humidity = value;
  }

  int get conditionId => _conditionId;

  set conditionId(int value) {
    _conditionId = value;
  }

  set condition(String value) {
    _condition = value;
  }
}