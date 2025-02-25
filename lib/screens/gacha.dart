import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/method/itemMethod.dart';
import 'package:myapp/method/userMethod.dart';
import 'package:myapp/widget/header.dart';
import 'package:myapp/widget/myNotification.dart';
import 'package:provider/provider.dart';
import '../widget/coinCounter.dart';

class Gacha extends StatefulWidget {
  const Gacha({super.key});

  @override
  State<Gacha> createState() => _GachaState();
}

class _GachaState extends State<Gacha> {
  final _authentication = FirebaseAuth.instance;
  Usermethod usermethod = new Usermethod();
  Itemmethod itemmethod = new Itemmethod();
  Header header = Header();
  MyNotification myNotification = MyNotification();
  int num = 1;

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
                SizedBox(
                  height: 15,
                ),
                Consumer<CoinCounter>(
                  builder: (_, counter, __) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                              onPressed: () async {
                                try {
                                  //코인 차감하기
                                  int usecoin = await usermethod
                                      .useCoinToGacha(user!.uid, num*5);
                                  if (usecoin == 1) {//차감 성공 했을 경우

                                    //랜덤으로 선물 뽑기
                                    List gift =
                                        await itemmethod.getGacha(user!.uid, num);

                                    //선물을 뽑은 아이템에 추가
                                    await itemmethod.addPickItem(
                                        user!.uid, gift);


                                    //확인 창 띄우기
                                    myNotification.DialogGacha(
                                        context, gift);

                                    counter.count(user.uid);
                                  } else {
                                    myNotification.SnackbarBasic(
                                        context, "코인이 부족합니다!");
                                  }
                                } catch (e) {
                                  myNotification.SnackbarBasic(context,
                                      "오류! 새로고침 후 다시 시도해주세요. 오류가 계속 될 경우 총괄계 제보 바랍니다.");
                                }
                              },
                              child: Text(
                                '가챠 ${num.toString()}회',
                                style: TextStyle(color: Colors.black),
                              )),
                          IconButton(
                              onPressed: () {
                                if(num==100){num=1;}
                                else{num*=10;}
                                setState(() {});
                              },
                              icon: Icon(Icons.refresh))
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FutureBuilder<int>(
                          initialData: counter.Coin,
                          future: usermethod.getCoin(user!.uid),
                          builder: (context, snapshot) {
                            counter.setCoin(snapshot.data!.toInt());
                            return Text("보유 코인 : " + '${counter.Coin}');
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
