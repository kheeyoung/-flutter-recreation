class Post{
  String _title;
  String _contents;
  String _postUid;
  String _giftName;
  String _recipientUid;
  String _senderUid;
  String _senderName;
  String _recipientName;

  Post(this._title, this._contents, this._postUid, this._giftName,
      this._recipientUid, this._senderUid, this._recipientName, this._senderName);

  String getTitle () {return this._title;}

  void setTitle(String value) {
    _title = value;
  }

  String getContents () {return this. _contents;}

  void setContents(String value) {
    _contents = value;
  }

  String getPostUid () {return this._postUid;}

  void setPostUid(String value) {
    _postUid = value;
  }

  String getGiftName () {return this._giftName;}

  void setGiftName(String value) {
    _giftName = value;
  }

  String getRecipientUid () {return this. _recipientUid;}

  void setRecipientUid(String value) {
    _recipientUid = value;
  }

  String getSenderUid () {return this._senderUid;}

  void setSenderUid(String value) {
    _senderUid = value;
  }

  String getRecipientName () {return this._recipientName;}

  void setRecipientName(String value) {
    _recipientName = value;
  }

  String getSenderName () {return this._senderName;}

  void setSenderName(String value) {
    _senderName = value;
  }




}