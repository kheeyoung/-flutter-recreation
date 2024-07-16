import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class Itemmethod{
  //가챠 뽑기
  Future<List> getGacha(userUid) async{
    List gift=[];
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("gift").get().then((querySnapshot) {
        int totalGiftCount= querySnapshot.size;
        int randomNum=Random().nextInt(totalGiftCount);

        gift=[querySnapshot.docs[randomNum].data()!["name"],querySnapshot.docs[randomNum].data()!["owner"]];
      });
    }
    catch (e) {
      print(e);
    }
    return gift;
  }

  Future<void> addPickItem(userUid, giftName, giftOwner) async {
    try{
      final db = await FirebaseFirestore.instance;
      String formattedDate = DateFormat('yyMMddhhmmss').format(DateTime.now());
      final Myitem = <String, dynamic>{
        "isused": false,
        "name": giftName,
        "owner": giftOwner,
      };

      db.collection("item").doc(userUid).collection("item").doc(formattedDate).set(Myitem)
          .onError((e, _) => print("Error writing document: $e"));
    }
    catch(e){
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
}