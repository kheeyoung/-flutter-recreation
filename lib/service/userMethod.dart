import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'notification_controller.dart';

class Usermethod {

  //최초 로그인 여부 확인
  Future<int> checkFirstLogIn(userUid) async {
    int result = 0;

    try {
      final db = FirebaseFirestore.instance;
      await db.collection("user").doc(userUid).get().then((querySnapshot) {
        if (querySnapshot.exists && querySnapshot.data()!["uid"].toString().length>1) {
          result = 1;
        }
      });
    } catch (e) {}
    return result;
  }

  //최초 로그인 유저 등록
  Future<void> RegistUser(userEmail, userUid, userName) async {
    final NotificationController _notificationController =  NotificationController();
    final db = FirebaseFirestore.instance;
    final userdata = <String, dynamic>{
      "email": userEmail,
      "uid": userUid,
      "name": userName,
      "messageToken": await _notificationController.getToken()
    };
    db
        .collection("user")
        .doc(userUid)
        .set(userdata)
        .onError((e, _) => print("Error writing document: $e"));
  }



  //모든 유저의 이름/uid 리턴
  Future<Map<String,String>> getUser() async {
    final db = FirebaseFirestore.instance;

    Map<String,String> userInfo={};
    await db.collection("user").get().then(
          (querySnapshot) {
        for (int i=0; i<querySnapshot.size; i++) {
          if(querySnapshot.docs[i].id=="dummy"){continue;}
          userInfo[querySnapshot.docs[i].data()["name"].toString()]=querySnapshot.docs[i].data()["uid"];
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return userInfo;
  }


  //Uid로 유저명 찾기
  Future<String> getUserNameByUid(userUid) async {
    final db = FirebaseFirestore.instance;
    String userName = "";
    await db.collection("user").where("uid", isEqualTo: userUid).get().then(
      (querySnapshot) {
        userName = querySnapshot.docs[0]["name"];
      }
    );
    return userName;
  }

  //유저명로 uid 찾기
  Future<String> getUserUidByName(UserName) async {
    final db = FirebaseFirestore.instance;
    String userUid = "";
    await db.collection("user").where("name", isEqualTo: UserName).get().then(
          (querySnapshot) {
            userUid = querySnapshot.docs[0]["uid"];
      },
      onError: (e) => print("Error completing: $e"),
    );
    return userUid;
  }


  //호감도 추출하기
  Future<List<List>> getMyLikePoint(userUid)async{
    final db = FirebaseFirestore.instance;
    List<List> LikePoints=[];
    await db.collection("likepoint").doc(userUid).get().then((querySnapshot) async {
      if(querySnapshot.exists){ //호감도 쌓은 이력이 있을 경우
        List user=querySnapshot.data()!.keys.toList();

        for(int i=0; i<user.length; i++){
          String name=await getUserNameByUid(user[i]);
          LikePoints.add([user[i],name,querySnapshot.data()![user[i]]]);
        }
      }
    },
      onError: (e) => print("Error completing: $e"),
    );

    return LikePoints;
  }


  Future<List<List>> showMySpecialGift(userUid)async {
    final db = FirebaseFirestore.instance;
    List<List> MySpecialGift=[];
    await db.collection("specialgift").doc(userUid).collection("specialgift").get()
          .then((querySnapshot)  {
        if (querySnapshot.docs.isNotEmpty) {

          for(int i=0; i<querySnapshot.size; i++){

            List SG = [querySnapshot.docs.toList()[i]["giftName"],querySnapshot.docs.toList()[i]["url"]];
            MySpecialGift.add(SG);
          }

        }
      },
        onError: (e) => print("Error completing: $e"),
      );

    return MySpecialGift;

  }

  Future<int> getSpecialGift(userUid,likeNum,giftOwnerUid,giftOwnerName)async{
    int result=0;

    if(likeNum>4){    //호감도 달성에 성공한 경우
      final db = FirebaseFirestore.instance;
      final storageRef = FirebaseStorage.instance.ref();
      //이미 받은 이력이 있나 확인
      await db.collection("specialgift").doc(userUid).collection("specialgift").doc(giftOwnerUid).get().then((querySnapshot)  async {
        if (querySnapshot.exists) {
          result+=2;
        }
        else{
          //없으면 새로 등록
          String formattedDate = DateFormat('yyMMddhhmmss').format(DateTime.now());
          try {
            String imageUrl = await storageRef.child("specialgift/" + giftOwnerUid + ".png").getDownloadURL();


            final data = <String, dynamic>{
              "giftName" : giftOwnerName+"의 특별 선물",  //가장 오래된 아이템부터 사용 하니 이름만 있어도 되게 함)
              "time" : formattedDate,
              "url": imageUrl
            };
            db.collection("specialgift").doc(userUid).collection("specialgift").doc(giftOwnerUid).set(data);
          }
          catch(e){
            //이미지 등록 안 되어 있을 경우 3 리턴
            result=3;
          }

        }
      });
    }
    else{
      result++;
    }
    return result;
  }


  Future<List> getMyItem(String uid) async{
    final db = FirebaseFirestore.instance;
    List itemList=[];
    await db.collection("item").doc(uid).collection("item").where("isused", isEqualTo: false).get().then((querySnapshot) async {
      for (int i = 0; i < querySnapshot.size; i++) {
        itemList.add([querySnapshot.docs[i]["name"], querySnapshot.docs[i].id]);
      }
    },
      onError: (e) => print("Error completing: $e"),
    );

    return itemList;
  }

  Future<void>UpdateUserMessageToken() async{
    final authentication = FirebaseAuth.instance;
    final user = authentication.currentUser;
    final db = FirebaseFirestore.instance;
    final NotificationController notificationController =  NotificationController();
    String messageToken = "";
    await db.collection("user").where("uid", isEqualTo: user!.uid).get().then(
          (querySnapshot) async {

            if(querySnapshot.size==0){return;}
            messageToken = querySnapshot.docs[0]["messageToken"];

            if(messageToken!= await notificationController.getToken()){
              final bucket = db.collection("user");
              await bucket.doc(user!.uid).update({"messageToken": await notificationController.getToken()});

            }

      },
      onError: (e) => print("Error completing: $e"),
    );
    

  }





}
