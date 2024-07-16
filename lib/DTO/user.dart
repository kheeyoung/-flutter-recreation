class User {
  String _coin;
  String _email;
  String _name;
  String _uid;


  User(this._coin, this._email, this._name, this._uid);

  String getEmail(){ return this._email;}
  String getName(){ return this._name;}
  String getUid(){ return this._uid;}
  String getCoin(){ return this._coin;}

  void setEmail(String value) {
    _email = value;
  }



  void setName(String value) {
    _name = value;
  }



  void setUid(String value) {
    _uid = value;
  }



  void setCoin(String value) {
    _coin = value;
  }
}