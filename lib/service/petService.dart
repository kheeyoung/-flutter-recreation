import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/DTO/petDTO.dart';

class PetService{
  Future<petDTO> getMyPet(userUid)async{
    petDTO pd = petDTO("", 0 , 0, "");
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("pet").doc(userUid).get().then((querySnapshot) {
        pd.name=querySnapshot.data()!["name"].toString();
        pd.level=querySnapshot.data()!["level"];
        pd.exp=querySnapshot.data()!["exp"];
        pd.state=querySnapshot.data()!["state"].toString();

      });
    } catch (e) {}

    return pd;
  }

  Future<void> makePet(String userUid, name)async {
    final db = FirebaseFirestore.instance;
    final data = <String, dynamic>{
      "name" : name,
      "level" : 1,
      "exp": 0,
      "state": ""
    };
    await db.collection("pet").doc(userUid).set(data).onError((e, _)
    => print("Error writing document: $e"));

  }

  //pet 이미지 가져오기
  Future<Map<String,String>> getPetImage()async{
    Map<String,String> imageUrls={};
    final storageRef = FirebaseStorage.instance.ref().child("petImage");
    try {
      // 'mapImage' 폴더 안의 모든 파일 목록 가져오기
      final ListResult result = await storageRef.listAll();

      // 각 파일에 대해 download URL 가져오기
      for (var item in result.items) {
        final url = await item.getDownloadURL();
        imageUrls[item.name] = url;

      }

    } catch (e) {
      print("🔥 Storage에서 이미지 가져오기 실패: $e");
    }

    return imageUrls;
  }

  Future<void> feed(String uid, petDTO pd) async{
    int exp = pd.exp+10;
    int level =pd.level;

    if(exp>=100){
      exp-=100;
      level++;
    }
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("pet").doc(uid).update({"exp": exp});
      await db.collection("pet").doc(uid).update({"level": level});

    } catch (e) {

    }
  }
}