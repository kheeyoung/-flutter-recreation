import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/method/itemMethod.dart';
import 'package:myapp/method/userMethod.dart';
import 'package:myapp/widget/header.dart';
import 'package:myapp/widget/myNotification.dart';
import 'package:provider/provider.dart';

class CoinCounter extends ChangeNotifier {
  Usermethod usermethod = new Usermethod();
  int _coin=0;

  int get Coin => _coin;

  void setCoin(coin){
    _coin=coin;
  }

  void count(userUid) async {   //버튼 누를 때 갱신용
    _coin = await usermethod.getCoin(userUid);
    notifyListeners();
  }
}

class Gacha extends StatefulWidget {
  const Gacha({super.key});

  @override
  State<Gacha> createState() => _GachaState();
}

class _GachaState extends State<Gacha> {
  final _authentication = FirebaseAuth.instance;
  Usermethod usermethod = new Usermethod();
  Itemmethod itemmethod = new Itemmethod();
  Header header=Header();
  MyNotification myNotification=MyNotification();

  @override
  Widget build(BuildContext context) {
    final user = _authentication.currentUser;
    return ChangeNotifierProvider<CoinCounter>(
        create: (_) => CoinCounter(),
        child: Scaffold(
          appBar: header.screenHeader(context, "Gacha"),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.card_giftcard,
                  color: Colors.black54,
                  size: 200.0,
                ),
                const Text('가챠 1회 = 5코인'),
                SizedBox(height: 15,),
                Consumer<CoinCounter>(
                  builder: (_,counter,__)=>
                      Column(
                        children: [
                          OutlinedButton(
                              onPressed: () async {
                                try {
                                  //코인 차감하기
                                  int usecoin = await usermethod.useCoinToGacha( user!.uid);
                                  if (usecoin == 1) {//차감 성공 했을 경우

                                    //랜덤으로 선물 뽑기
                                    List gift =
                                    await itemmethod.getGacha(user!.uid);

                                    //선물을 뽑은 아이템에 추가
                                    await itemmethod.addPickItem(user!.uid, gift[0],gift[1]);

                                    //확인 창 띄우기
                                    myNotification.DialogBasic(context, "신난다~! "+gift[0]+"를 뽑았다!");

                                    counter.count(user.uid);

                                  }
                                  else {myNotification.SnackbarBasic(context,"코인이 부족합니다!");
                                  }
                                }
                                catch (e) {
                                  myNotification.SnackbarBasic(context,"오류! 새로고침 후 다시 시도해주세요. 오류가 계속 될 경우 총괄계 제보 바랍니다.");
                                }
                              },
                              child: const Text('가챠 돌리기', style: TextStyle(color: Colors.black),)
                          ),
                          SizedBox(height: 15,),
                          FutureBuilder<int>(
                            initialData: counter.Coin,
                              future: usermethod.getCoin(user!.uid),
                              builder: (context, snapshot) {
                                counter.setCoin(snapshot.data!.toInt());
                                return Text("보유 코인 : "+'${counter.Coin}');
                              }
                          )
                        ],
                      ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
