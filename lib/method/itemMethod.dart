import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class Itemmethod{
  //가챠 뽑기
  Future<List> getGacha(userUid, int num) async{
    List<List> gift=[];
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("gift").get().then((querySnapshot) {
        int totalGiftCount= querySnapshot.size;
        for(int i=0; i<num; i++){
          int randomNum=Random().nextInt(totalGiftCount);
          gift.add([querySnapshot.docs[randomNum].data()!["name"],querySnapshot.docs[randomNum].data()!["owner"]]);
        }

      });
    }
    catch (e) {
      print(e);
    }

    return gift;
  }
  Future<void> addPickItem(userUid, gift) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    CollectionReference collection = FirebaseFirestore.instance.collection('item').doc(userUid).collection("item");
    int i=0;
    for (List l in gift) {
      String docName = DateFormat('yyMMddhhmmssSSSSSS').format(DateTime.now())+i.toString();

      DocumentReference docRef = collection.doc(docName); // 커스텀 문서 이름 지정
      batch.set(docRef, {
        "isused": false,
        "name": l[0],
        "owner": l[1],
      });
      i++;
    }

    try {
      await batch.commit();

    } catch (e) {
      print("에러 발생: $e");
    }
  }



  //소유 아이템 받아오기
  Future<Map> getMyItem(userUid) async{
    final db = FirebaseFirestore.instance;

    Map userItem={};
    await db.collection("item").doc(userUid).collection("item").get().then(
          (querySnapshot) {

        for (int i=0; i<querySnapshot.size; i++) {

          if(querySnapshot.docs[i].data()["isused"] == false){
            userItem[querySnapshot.docs[i].data()["name"]]=querySnapshot.docs[i].data()["owner"];
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return userItem;
  }


  Future<String> pickImage(String userUid) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {

      final bool uploadResult = await _uploadImage(File(pickedFile.path), userUid);
      return uploadResult ? "등록 성공" : "등록 실패";
    }

    return "등록 실패";
  }

  Future<bool> _uploadImage(File file, userUid) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef.child('specialgift/$userUid.png');
      await imagesRef.putFile(file);

      return true;
    } catch (e) {
      return false;
    }
  }



}