class LotteryDTO{
  List<int> _num;
  String _uid;
  bool _get;
  String _id;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  List<int> get num => _num;

  set num(List<int> value) {
    _num = value;
  }

  LotteryDTO(this._num, this._uid, this._get, this._id);

  String get uid => _uid;

  bool get get => _get;

  set get(bool value) {
    _get = value;
  }

  set uid(String value) {
    _uid = value;
  }
}