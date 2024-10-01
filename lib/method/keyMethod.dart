import 'package:cloud_firestore/cloud_firestore.dart';

class Keymethod{
  //키 확인
  Future<bool> checkMaster(String pw,keyType) async{
    final db = FirebaseFirestore.instance;
    bool result=false;
    String keyName="";
    switch (keyType){
      case 0://마스터 키 확인
        keyName="masterkey";
        break;
      case 1://1층 맵 키 확인
        keyName="map1";
        break;
      case 2://2층 맵 키 확인
        keyName="map2";
        break;
      case 3://3층 맵 키 확인
        keyName="map3";
        break;
      case 4://4층 맵 키 확인
        keyName="map4";
        break;
      case 5://5층 맵 키 확인
        keyName="map5";
        break;


    }

    await db.collection("key").doc(keyName).get().then((querySnapshot)  {
      if (querySnapshot["key"]==pw) {
        result=true;
      }
    },
      onError: (e) => print("Error completing: $e"),
    );
    return result;
  }

  //키 변경
  Future<int> ChangePw(pw,keyType) async {
    int result=0;

    try {
      final db = FirebaseFirestore.instance;
      await db.collection("key").doc(keyType).update({"key":pw});
      result=1;
    }
    catch (e) {
      result=2;
    }
    return result;
  }

  //바로 이용 가능 여부 확인
  Future<List> checkIsOk() async {
    final db = FirebaseFirestore.instance;
    List result=[];
    await db.collection("key").doc("isOk").get().then((querySnapshot) {
      result.add(querySnapshot.data()!["state"]);
      result.add(querySnapshot.data()!["key"]);

    },
      onError: (e) => print("Error completing: $e"),
    );
    //print(result);
    return result;
  }



}
