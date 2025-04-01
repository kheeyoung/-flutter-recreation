import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Ectmethod{
  //notOk 이미지 가져오기
  Future<String> getImage()async{
    final storageRef = FirebaseStorage.instance.ref();
    String result="";
    try {
      result = await storageRef.child("ect/notOk.png").getDownloadURL();
    }
    catch(e){result="이미지 없음";}
    return result;
  }
}