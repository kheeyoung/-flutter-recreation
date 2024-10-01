import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class Usermethod {
  //최초 로그인 여부 확인
  Future<int> checkFirstLogIn(userUid) async {
    final db = FirebaseFirestore.instance;
    int result = 0;

    final docRef = await db.collection("user").doc(userUid);
    await docRef.get().then(
      (DocumentSnapshot doc) {
        if (doc.data() != null) {result = 1;}
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return result;
  }

  //최초 로그인 유저 등록
  void RegistUser(userEmail, userUid, userName) {
    final db = FirebaseFirestore.instance;
    final userdata = <String, dynamic>{
      "email": userEmail,
      "coin": 0,
      "uid": userUid,
      "name": userName
    };
    db
        .collection("user")
        .doc(userUid)
        .set(userdata)
        .onError((e, _) => print("Error writing document: $e"));
  }

  //유저 코인 가져오기
  Future<int> getCoin(userUid) async {
    int coin = 0;
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("user").doc(userUid).get().then((querySnapshot) {
        coin = querySnapshot.data()!["coin"];
      });
    } catch (e) {
      print(e);
    }
    return coin;
  }

  //코인 사용
  Future<int> useCoinToGacha(userUid) async {
    int coin = 0;
    try {
      final db = FirebaseFirestore.instance;

      coin = await getCoin(userUid);
      if (coin >= 5) {
        //코인이 5 이상 있으면 차감 후 1 리턴
        final bucket = db.collection("user");
        await bucket.doc(userUid).update({"coin": coin - 5});
        return 1;
      }
    } catch (e) {
      print(e);
    }
    //코인이 없으면 0 리턴
    return 0;
  }

  //모든 유저의 uid 리턴
  Future<List> getUserUid() async {
    final db = FirebaseFirestore.instance;
    List userUid = [];
    await db.collection("user").get().then(
      (querySnapshot) {
        for (int i = 0; i < querySnapshot.size; i++) {
          userUid.add(querySnapshot.docs[i].data()["uid"]);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return userUid;
  }

  //모든 유저의 이름 리턴
  Future<List> getUserName() async {
    final db = FirebaseFirestore.instance;
    List userName = [];
    await db.collection("user").get().then(
          (querySnapshot) {
        for (int i = 0; i < querySnapshot.size; i++) {
          userName.add(querySnapshot.docs[i].data()["name"]);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return userName;
  }


  //Uid로 유저명 찾기
  Future<String> getUserNameByUid(UserUid) async {
    final db = FirebaseFirestore.instance;
    String userName = "";
    await db.collection("user").where("uid", isEqualTo: UserUid).get().then(
      (querySnapshot) {
        userName = querySnapshot.docs[0]["name"];

      },
      onError: (e) => print("Error completing: $e"),
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
            final imageUrl = await storageRef.child("specialgift/" + giftOwnerName + ".png").getDownloadURL();
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

  Future<int> changeCoinByMaster(String selectedUser, int coin, isplus )async {
    try {
      final db = FirebaseFirestore.instance;
      String userUid=await getUserUidByName(selectedUser);
      final bucket = db.collection("user");
      int orginCoin = await getCoin(userUid);
      int changecoin=0;
      if(isplus==true){changecoin=orginCoin+coin;}
      else if(isplus==false){changecoin=orginCoin-coin;}

      //코인이 마이너스가 안되게 하기
      if(changecoin<0){changecoin=0;}

      await bucket.doc(userUid).update({"coin": changecoin});

      return await getCoin(userUid);
    } catch (e) {
      print(e);
      return 00;
    }

  }

  Future<List> getAllCoin()async{
    final db = FirebaseFirestore.instance;
    List coinList=[];
    await db.collection("user").get().then((querySnapshot) async {
      for (int i = 0; i < querySnapshot.size; i++) {
        coinList.add(
            [querySnapshot.docs[i]["name"],
              querySnapshot.docs[i]["uid"],
              querySnapshot.docs[i]["coin"],

            ]
        );
      }
    },
        onError: (e) => print("Error completing: $e"),
      );

   return coinList;
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



}
