import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intl/intl.dart';
import 'package:myapp/DTO/inquiryDTO.dart';
import 'package:myapp/DTO/lotteryDTO.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:myapp/service/coinService.dart';
import 'notification_controller.dart';

class LotteryService{
  final user = FirebaseAuth.instance.currentUser;
  CoinService cs =CoinService();
  MyNotification mn = MyNotification();

  Future<List<int>> getNum (String today) async {

    List<int> result = [];
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("lottery").doc(today).get().then((querySnapshot) {

        for(dynamic i in querySnapshot.data()!['num']){
          result.add(i);

        }

      });
    } catch (e) {
      print(e);
    }

    return result;
  }

  Future<void> applyLottery(String uid, List<int> myNum, nextDay, context) async {
    try{
      final db = FirebaseFirestore.instance;
      String formattedDate = DateFormat('yyMMddHHmmss').format(DateTime.now());
      final data = <String, dynamic>{
        "userUid" : uid,
        "num" : myNum,
        "get" : false,
        "id":formattedDate
      };
      await db.collection("lottery").doc(nextDay).collection(uid).doc(formattedDate).set(data);
      mn.SnackbarBasic(context, "응모 성공! 결과는 자정에 공개 됩니다.");


    }catch(e){
      mn.SnackbarBasic(context, "응모 실패. 다시 시도해주세요.");
    }
  }

  Future<List<LotteryDTO>>getMyApply(String pickDay, String uid) async {
    List<LotteryDTO> result = [];
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("lottery").doc(pickDay).collection(uid).get().then((querySnapshot) {
        for(dynamic i in querySnapshot.docs){
          List<int> nums=[];
          for(dynamic j in i["num"] ){
            nums.add(int.parse(j.toString()));
          }

          result.add(LotteryDTO(nums, i["userUid"], i["get"], i["id"]));

        }
      });
    } catch (e) {
      print(e);
    }

    return result;
  }

  int checkLottery(List<int> goal, List<int> num){
    int result=0;
    for(int i in goal){
      for(int j in num){
        result=i==j ? result+1: result;
      }
    }
    return result;
  }

  Future<void>getPrize(LotteryDTO ld, date, uid)async {
    final db = FirebaseFirestore.instance;
    try {
      await db.collection("lottery").doc(date).collection(uid).doc(ld.id).update({"get": true});
      int c = await cs.getCoin(user!.uid);
      int p =100;
      await cs.changeCoin(c+p, user!.uid);
      cs.makeInquiry(uid, Inquirydto(p, "Lottery 상금", "System", ""));
    } catch (e) {
    }
  }


  Future<bool> getByID(String id, String date, String uid)async{
    bool result=false;
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("lottery").doc(date).collection(uid).doc(id).get().then((querySnapshot) {
        result= querySnapshot.get("get");

      });
    } catch (e) {
      print(e);
    }
    return result;
  }


}