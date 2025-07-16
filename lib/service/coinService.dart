import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intl/intl.dart';
import 'package:myapp/DTO/inquiryDTO.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'notification_controller.dart';



class CoinService{
  final user = FirebaseAuth.instance.currentUser;
  int _coin = 0;
  MyNotification mn = MyNotification();
  NotificationController nc = NotificationController();

  //-----------------------------------------------
  //코인 서비스는 싱글톤으로 관리
  static final CoinService _instance = CoinService._internal();

  factory CoinService(){
    return _instance;
  }

  CoinService._internal() { // 클래스가 최초 생성될 때, 1회 발생
    _initialize();
  }

  Future<void> _initialize() async { // 초기화
    _coin= await getCoin(user!.uid);
  }

  //-----------------------------------------------

  //getter & setter
  int get Coin => _coin;

  void setCoin(coin) {
    _coin = coin;
  }

  //-----------------------------------------------

  //기타 코인 관련 함수

  //계좌 개설
  Future<void> makeAccount(String uid)async{
    final db = FirebaseFirestore.instance;

    final data = <String, dynamic>{
      "coin" : 0,
    };
    await db.collection("bank").doc(uid).set(data).onError((e, _)
    => print("Error writing document: $e"));
  }

  //코인을 특정 값으로 바꾼다
  Future<bool> changeCoin(int coin, String uid)async{
    if (coin<0){return false;}
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("bank").doc(uid).update({"coin": coin});


      return true;
    } catch (e) {
      return false;
    }
  }

  //특정 유저 코인 가져오기
  Future<int> getCoin(userUid) async {
    int coin = 0;
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("bank").doc(userUid).get().then((querySnapshot) {
        coin = querySnapshot.data()!["coin"];
        return coin;
      });
    } catch (e) {}
    return coin;
  }

  //특정 유저 거래 내역 가져오기
  Future<List<Inquirydto>> getinquiry(userUid) async {
    List<Inquirydto> result =[];
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("bank").doc(userUid).collection("inquiry").get().then((querySnapshot) {
        if(querySnapshot.size>0){
          for(var snapshot in querySnapshot.docs){
            result.add(Inquirydto(snapshot["input"], snapshot["memo"], snapshot["from"], snapshot.id));
          }
        }
      });
    } catch (e) {}
    return result;
  }

  //유저 간 입금
  Future<bool> sendCoinByUser(String myUid, int input, String selectedUserUid, context)async{
    int myCoin = await getCoin(myUid);

    if (myCoin >= input) {
      await changeCoin(myCoin-input, myUid);
      int orgin = await getCoin(selectedUserUid);
      await changeCoin(orgin+input, selectedUserUid);
      mn.SnackbarBasic(context, "입금 성공 (잔여 코인 : ${myCoin-input})");
      return true;
    } else {
      mn.SnackbarBasic(context, "잔액이 부족합니다! (보유 코인 : $myCoin)");
      return false;
    }
  }

  //입출금 이력 작성
  Future<void> makeInquiry(String userUid, Inquirydto id )async{
    final db = FirebaseFirestore.instance;
    String formattedDate = DateFormat('yyMMddHHmmss').format(DateTime.now());
    final data = <String, dynamic>{
      "from" : id.from,
      "input" : id.input,
      "memo": id.memo
    };
    await db.collection("bank").doc(userUid).collection("inquiry").doc(formattedDate).set(data).onError((e, _)
    => print("Error writing document: $e"));

  }



  Future<Map<String,int>> getAllCoin() async{
    final db = FirebaseFirestore.instance;

    Map<String,int> userInfo={};
    await db.collection("bank").get().then(
          (querySnapshot) {
        for (int i=0; i<querySnapshot.size; i++) {
          if(querySnapshot.docs[i].id=="dummy"){continue;}
          userInfo[querySnapshot.docs[i].id.toString()]=querySnapshot.docs[i].data()["coin"];
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return userInfo;
  }





  Future<int> getRoulette(int orgin, int input, int result, uid, context) async {
    if (input > 0) {
        String text = "";
        int gain = 0;
        switch (result) {
          case 0:
            text = "x0";
            break;
          case 1:
            text = "x1";
            gain = input;
            break;
          case 2:
            text = "x0";
            break;
          case 3:
            text = "x1.5";
            gain = (input * 1.5).round();
            break;
          case 4:
            text = "x0";
            break;
          case 5:
            text = "x2";
            gain = input * 2.toInt();
            break;
        }
        changeCoin(orgin+gain, uid);

        if(gain>0){
          makeInquiry(user!.uid, Inquirydto(gain, "룰렛", "System", ""));
        }

        mn.DialogBasic(context, "결과 : $text \n 사용 코인 : $input \n 획득 코인 :$gain \n 총합 : ${gain-input}");

    } else {
      mn.DialogBasic(context, "베팅할 금액을 입력해주세요.");
    }

    return await getCoin(uid);
  }


}
