import 'package:cloud_firestore/cloud_firestore.dart';

class Keymethod{


  Future<bool> checkMaster(String pw) async{
    final db = FirebaseFirestore.instance;
    bool result=false;
    await db.collection("key").doc("masterkey").get().then((querySnapshot)  {
      if (querySnapshot["key"]==pw) {
        result=true;
      }
    },
      onError: (e) => print("Error completing: $e"),
    );
    return result;
  }

  Future<int> ChangePw(pw) async {
    int result=0;
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("key").doc("masterkey").update({"key":pw});
      result=1;
    }
    catch (e) {
      result=2;
    }
    return result;
  }

}
