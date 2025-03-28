import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:myapp/service/userMethod.dart';
import '../DTO/post.dart';
import '../model/widget/myNotification.dart';


class Giftmethod{

  Usermethod usermethod =new Usermethod();
  MyNotification myNotification=MyNotification();

  //가챠 아이템 (선물) 추가
  Future<void> RegistGift(UserUid,num,GiftName, Owner)async {
    final db = FirebaseFirestore.instance;
    final userdata = <String, dynamic>{
      "name": GiftName,
      "owner": Owner
    };
    await db.collection("gift")
        .doc(UserUid+num)
        .set(userdata)
        .onError((e, _) => print("Error writing document: $e"));
  }


  Future<bool> sendGift(Post p) async{
    if (p.getTitle().isEmpty &&
        p.getContents().isEmpty &&
        p.getGiftName() != "" &&
        p.getRecipientName() != "") {return false;}

    final db = FirebaseFirestore.instance;
    String formattedDate = DateFormat('yyMMddHHmmss').format(DateTime.now());

    String senderName= await usermethod.getUserNameByUid(p.getSenderUid());

    final userdata = <String, dynamic>{
      "giftName" : p.getGiftName(),  //가장 오래된 아이템부터 사용 하니 이름만 있어도 되게 함)
      "senderUid" : p.getSenderUid(),
      "recipientUid": p.getRecipientUid(),
      "recipientName":p.getRecipientName(),
      "senderName":senderName,
      "postUid" : formattedDate,
      "title" : p.getTitle(),
      "contents" : p.getContents()
    };

    try {
      await db.collection("board").doc(formattedDate).set(userdata);
    }
    catch(e){return false;}

    return true;
  }

  //아이템 사용
  Future <int> useItem(itemName, UserUid) async{
    int result=0;
    int size=0;
    try {
      final db = FirebaseFirestore.instance;

      await db.collection("item").doc(UserUid).collection("item").get().then((querySnapshot) async {

        for (int i=0; i<querySnapshot.size; i++) {
          if(querySnapshot.docs[i].data()["name"]==itemName && querySnapshot.docs[i].data()["isused"]==false){
            String uid =querySnapshot.docs[i].id; //찾은 사용 아이템
            await db.collection("item").doc(UserUid).collection("item").doc(uid).update({"isused":true});
            break;
          }
          else{size++;}
        }
        if(size>=querySnapshot.size){result++;}
      },
        onError: (e) => print("Error completing: $e"),
      );
    }
    catch (e) {
      print(e);
    }
    return result;
  }

  void addLikePoint(String uid, String recipientUid, String giftName) async{
    final db = FirebaseFirestore.instance;
    int num=0;

    final docRef = db.collection("likepoint").doc(uid);
    await docRef.get().then((DocumentSnapshot doc) {
      try{
        num=doc[recipientUid];
        db.collection("likepoint").doc(uid).update({recipientUid: num+1});
        }
        catch(e){
          db.collection("likepoint").doc(uid).set({recipientUid: 1}, SetOptions(merge: true));
        }

      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  //동일한 이름의 선물이 있는지 찾기
  Future<bool> findSameNameItem(itemName)async{
    final db = FirebaseFirestore.instance;
    bool result=true;

    await db.collection("gift").where("name", isEqualTo: itemName).get().then((querySnapshot) {
        if(querySnapshot.size==0){result=false;}
      },
      onError: (e) => print("Error completing: $e"),
    );
    return result;
  }

  Future<int> checkItemButtonMethod(itemName,context)async{
    int result=0;
    if(itemName==""){
      myNotification.SnackbarBasic(context, "선물명을 입력해주세요.");
    }
    else if(await findSameNameItem(itemName)==true){
      myNotification.SnackbarBasic(context, "같은 이름의 선물이 있습니다! 다른 이름을 입력해주세요.");
    }
    else{
      myNotification.SnackbarBasic(context, "사용 가능한 선물명입니다.");
      result++;
    }
    return result;
  }
}