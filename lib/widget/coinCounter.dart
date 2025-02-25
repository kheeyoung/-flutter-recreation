import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/widget/myNotification.dart';
import 'package:provider/provider.dart';

import '../method/userMethod.dart';

class CoinCounter extends ChangeNotifier {
  Usermethod usermethod = new Usermethod();
  MyNotification mn = MyNotification();

  int _coin = 0;

  int get Coin => _coin;

  void setCoin(coin) {
    _coin = coin;
  }

  void count(userUid) async {
    //버튼 누를 때 갱신용
    _coin = await usermethod.getCoin(userUid);
    notifyListeners();
  }

  getCounterText(uid) {
    return ChangeNotifierProvider<CoinCounter>(
        create: (_) => CoinCounter(),
        child: Consumer<CoinCounter>(
            builder: (_, counter, __) => FutureBuilder<int>(
                initialData: counter.Coin,
                future: usermethod.getCoin(uid),
                builder: (context, snapshot) {
                  counter.setCoin(snapshot.data!.toInt());
                  return Text("보유 코인 : " + '${counter.Coin}');
                })));
  }

  Future<int> getRoulette(int input, int result, uid, context) async {
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
        usermethod.useCoin(uid, input-gain);

        mn.DialogBasic(context, "결과 : $text \n 사용 코인 : $input \n 획득 코인 :$gain \n 총합 : ${gain-input}");

    } else {
      mn.DialogBasic(context, "베팅할 금액을 입력해주세요.");
    }

    return await usermethod.getCoin(uid);
  }
}
