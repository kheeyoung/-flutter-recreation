import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/DTO/inquiryDTO.dart';
import 'package:myapp/DTO/petDTO.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:myapp/service/coinService.dart';

class PetService{

  CoinService cs = CoinService();
  MyNotification mn = MyNotification();

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
    } catch (e) {
      print("오류 : "+e.toString());
    }

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
    await cs.makeInquiry(userUid, Inquirydto(-10, "Pet 생성", name, ""));

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

  Future<void> feed(String uid, petDTO pd, coin,context) async{
    int exp = pd.exp+10;
    int level =pd.level;

    if(exp>=100){
      exp-=100;
      level++;
    }

    try{
      final db = FirebaseFirestore.instance;
      await cs.makeInquiry(uid, Inquirydto(-10, "먹이주기", pd.name, ""));
      sleep(const Duration(milliseconds: 5));
      await db.collection("pet").doc(uid).update({"exp": exp});

      if(level>4){ //최고레벨일 경우 펫의 보은
        Random _random = Random();
        int randomCoin =_random.nextInt(150);
        await cs.changeCoin(coin+randomCoin, uid);
        await cs.makeInquiry(uid, Inquirydto(randomCoin, "펫의 보은", pd.name, ""));
        mn.SnackbarBasic(context, "${pd.name}이/가 $randomCoin코인을 가지고 왔습니다.");
      }
      else{ //아닐 시 갱신만
        await db.collection("pet").doc(uid).update({"level": level});
      }
    }catch (e) {}



  }
}