import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/DTO/pet/petDTO.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:myapp/service/coinService.dart';
import 'package:myapp/service/notification_controller.dart';

import '../DTO/inquiryDTO.dart';

class PetService {
  MyNotification mn = MyNotification();
  CoinService cs = CoinService();
  NotificationController nc = NotificationController();

  //살아있는 팻 찾기
  Future<PetDTO> getLivePet(String uid, context) async {
    final db = FirebaseFirestore.instance;
    PetDTO result = PetDTO("", "", 0, 0, 0, 0, 0, "", 0);

    var docRef = db.collection("pet").doc(uid);
    var docId = "";
    try {
      //생존 펫 id 가져오기
      await docRef.get().then((DocumentSnapshot doc) {
          if (doc.exists) {
            final data = doc.data() as Map<String, dynamic>;
            docId = data['liveId'].toString();
          } else {
            return result;
          }
        },
        onError: (e) => print("Error getting document: $e"),
      );

      //생존 펫 데이터 가져오기
      docRef = db.collection("pet").doc(uid).collection('pet').doc(docId);
      await docRef.get().then((DocumentSnapshot doc) async {
        if (doc.exists) {
              final data = doc.data() as Map<String, dynamic>;
              if (int.parse(data["isDead"].toString()) == 0) {
                result.uid = data["uid"].toString();
                result.name = data["name"].toString();
                result.level = int.parse(data["level"].toString());
                result.subLevel = int.parse(data["subLevel"].toString());
                result.happy = int.parse(data["happy"].toString());
                result.hunger = int.parse(data["hunger"].toString());
                result.fatigue = int.parse(data["fatigue"].toString());
                result.species = data["species"].toString();
                result.isDead = int.parse(data["isDead"].toString());

                result = await checkPet(uid, result, context);
                if (result.isDead != 0) {
                  result = PetDTO("", "", 0, 0, 0, 0, 0, "", 0);
                  mn.SnackbarBasic(context, "펫이 사망하였습니다.");
                }

              }
        } else {
          return PetDTO("", "", 0, 0, 0, 0, 0, "", 0);
        }
      });
    }catch(e){
      print(e);
    }
    print(result.uid);
    return result;
  }

  //죽은 펫 찾기
  Future<List<PetDTO>> getDeadPet(String uid) async {
    final db = FirebaseFirestore.instance;
    List<PetDTO> result = [];
    await db.collection("pet").doc(uid).collection("pet").get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (int.parse(docSnapshot["isDead"].toString()) > 0) {
            result.add(PetDTO(
                docSnapshot["uid"].toString(),
                docSnapshot["name"].toString(),
                int.parse(docSnapshot["happy"].toString()),
                int.parse(docSnapshot["hunger"].toString()),
                int.parse(docSnapshot["fatigue"].toString()),
                int.parse(docSnapshot["level"].toString()),
                int.parse(docSnapshot["subLevel"].toString()),
                docSnapshot["species"].toString(),
                int.parse(docSnapshot["isDead"].toString())));
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return result;
  }

  Future<void> makePet(String name, String uid) async {
    await changeLivePet(uid, "");
    final db = FirebaseFirestore.instance;
    try {
      final docRef =
          db.collection("pet").doc(uid).collection("pet").doc(); // 문서 생성
      final data = <String, dynamic>{
        "uid": docRef.id,
        "name": name,
        "happy": 10,
        "hunger": 10,
        "fatigue": 10,
        "level": 1,
        "subLevel": 0,
        "species": "pet0.gif",
        "isDead": 0,
      };
      await docRef.set(data);
      await changeLivePet(uid, docRef.id);
    } catch (e) {}
  }

  //살아있는 펫 교체하기
  Future<void> changeLivePet(String userUid, String petId) async {
    try {
      final ref = FirebaseFirestore.instance.collection("pet").doc(userUid);
      ref.set({
        "liveId": petId,
      });
    } catch (e) {}
  }

  //id 팻 찾기
  Future<PetDTO> getPetById(String uid, String petId) async {
    PetDTO result = PetDTO("", "", 0, 0, 0, 0, 0, "", 0);

    var docRef = FirebaseFirestore.instance
        .collection("pet")
        .doc(uid)
        .collection("pet")
        .doc(petId);

    try {
      await docRef.get().then((docSnapshot) {
        result.uid = docSnapshot["uid"].toString();
        result.name = docSnapshot["name"].toString();
        result.level = int.parse(docSnapshot["level"].toString());
        result.subLevel = int.parse(docSnapshot["subLevel"].toString());
        result.happy = int.parse(docSnapshot["happy"].toString());
        result.hunger = int.parse(docSnapshot["hunger"].toString());
        result.fatigue = int.parse(docSnapshot["fatigue"].toString());
        result.species = docSnapshot["species"].toString();
        result.isDead = int.parse(docSnapshot["isDead"].toString());
      });
    } catch (e) {
      print("오류 : $e");
    }
    return result;
  }

  Future<String> getImage(String species, exp) async {

    try {
      final storageRef = FirebaseStorage.instance.ref();
      if(species=="pet0.gif"){
        String s = "0.gif";
        if(exp >=70) {
          s ="2.gif";
        } else if (exp>=40) {s="1.gif";}
        print(s);
        return await storageRef.child("/petImage/0/$s").getDownloadURL();
      }
      return await storageRef.child("/petImage/${species}").getDownloadURL();
    } catch (e) {
      return "";
    }
  }

  Future<void> feed(String userUid, PetDTO pet, context) async {
    try {
      final ref = FirebaseFirestore.instance
          .collection("pet")
          .doc(userUid)
          .collection("pet")
          .doc(pet.uid);
      ref.update({
        "happy": pet.happy + 10,
        "hunger": pet.hunger + 30,
        "fatigue": pet.fatigue + 10,
      });
    } catch (e) {
      mn.SnackbarBasic(context, "오류!");
    }
  }

  Future<void> play(String userUid, PetDTO pet, context) async {
    try {
      final ref = FirebaseFirestore.instance
          .collection("pet")
          .doc(userUid)
          .collection("pet")
          .doc(pet.uid);
      ref.update({
        "happy": pet.happy + 30,
        "hunger": pet.hunger + 10,
        "fatigue": pet.fatigue + 10,
      });
    } catch (e) {
      mn.SnackbarBasic(context, "오류!");
    }
  }

  Future<void> sleep(String userUid, PetDTO pet, context) async {
    try {
      final ref = FirebaseFirestore.instance
          .collection("pet")
          .doc(userUid)
          .collection("pet")
          .doc(pet.uid);
      ref.update({
        "happy": pet.happy + 10,
        "hunger": pet.hunger + 10,
        "fatigue": pet.fatigue + 30,
      });
    } catch (e) {
      mn.SnackbarBasic(context, "오류!");
    }
  }

  //경험치 주기
  Future<void> getExp(String userUid, PetDTO pet, int act, context) async {
    List<int> result = [pet.level, pet.subLevel + 10];
    //랩업
    if (result[1] >= 100) {
      result[1] = 0;
      result[0] += 1;
      //랩업 성공시 이미지 변경
      if (result[0] < 4) {
        await changeImage(userUid, pet, act);
      }
    }
    if (result[0] > 3) {
      result[0] = 3;
      int coin = await cs.getCoin(userUid);
      await cs.changeCoin(coin + 100, userUid);
      await cs.makeInquiry(userUid, Inquirydto(100, "펫의 보답", pet.name, ""));
      await nc.sendNotification("100 코인이 입금되었습니다.", "펫의 보답", userUid);
      mn.SnackbarBasic(context, "최고 레벨에 도달 하여 펫이 보답 하였습니다.");
    }

    try {
      final ref = FirebaseFirestore.instance
          .collection("pet")
          .doc(userUid)
          .collection("pet")
          .doc(pet.uid);
      ref.update({
        "level": result[0],
        "subLevel": result[1],
      });
    } catch (e) {}
  }

  //펫 이미지 변경
  /*
  놀이 0
  식사 1
  수면 2 > 놀이/식사.수면 트리 펫 종은 pet0012.gif
  */
  Future<void> changeImage(String userUid, PetDTO pet, int act) async {
    try {
      PetDTO p = await getPetById(userUid, pet.uid);

      int next = getDominantStatIndex(p.happy, p.hunger, p.fatigue);
      final withoutExtension = p.species.replaceAll('.gif', '');

      final ref = FirebaseFirestore.instance
          .collection("pet")
          .doc(userUid)
          .collection("pet")
          .doc(pet.uid);
      ref.update({
        "species": "$withoutExtension$next.gif",
      });
    } catch (e) {}
  }

  //랩업 분기
  int getDominantStatIndex(int happy, int hunger, int fatigue) {
    final stats = [happy, hunger, fatigue];

    final maxValue = stats.reduce((a, b) => a > b ? a : b);

    // maxValue와 같은 값의 인덱스를 모두 찾음
    final maxIndices = <int>[];
    for (int i = 0; i < stats.length; i++) {
      if (stats[i] == maxValue) {
        maxIndices.add(i);
      }
    }

    // 가장 큰 값이 하나면 그 인덱스를, 아니면 랜덤으로 하나 뽑기
    if (maxIndices.length == 1) {
      return maxIndices.first;
    } else {
      final random = Random();
      return maxIndices[random.nextInt(maxIndices.length)];
    }
  }

  //펫 상태 확인
  Future<PetDTO> checkPet(String uid, PetDTO pet, context) async {
    if (pet.happy <= 0) {
      killPet(uid, pet, 1);
      pet.isDead = 1;
      return pet;
    }
    if (pet.happy >= 100) {
      killPet(uid, pet, 2);
      pet.isDead = 2;
      return pet;
    }
    if (pet.hunger <= 0) {
      killPet(uid, pet, 3);
      pet.isDead = 3;
      return pet;
    }
    if (pet.hunger >= 100) {
      killPet(uid, pet, 4);
      pet.isDead = 4;
      return pet;
    }
    if (pet.fatigue <= 0) {
      killPet(uid, pet, 5);
      pet.isDead = 5;
      return pet;
    }
    if (pet.fatigue >= 100) {
      killPet(uid, pet, 6);
      pet.isDead = 6;
      return pet;
    }

    return pet;
  }

  Future<void> killPet(String uid, PetDTO pet, int reason) async {
    try {
      final ref = FirebaseFirestore.instance
          .collection("pet")
          .doc(uid)
          .collection("pet")
          .doc(pet.uid);
      ref.update({
        "isDead": reason,
      });
      await changeLivePet(uid, "");
    } catch (e) {}
  }

  String getDeadReason(PetDTO pet) {
    switch (pet.isDead) {
      case 1:
        return "${pet.name}(은/는) 반항기가 와서 가출해버렸다...";
      case 2:
        return "${pet.name}(은/는) 아마 궁전으로 갔다...";
      case 3:
        return "${pet.name}(은/는) 굶어 죽었다...";
      case 4:
        return "${pet.name}(은/는) 미식에 눈을 떠, 최고의 맛을 찾으러 떠났다...";
      case 5:
        return "${pet.name}(은/는) 과로사 해버렸다...";
      case 6:
        return "${pet.name}(은/는) 넘치는 혈기로 해적왕을 목표로 떠났다...";
    }
    return "";
  }
}
