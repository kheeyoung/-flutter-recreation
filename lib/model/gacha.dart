import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/model/widget/header.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:myapp/service/coinService.dart';
import '../service/itemMethod.dart';
import '../service/userMethod.dart';


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
  CoinService cs = CoinService();
  int num = 1;
  bool load = false;

  @override
  Widget build(BuildContext context) {
    final user = _authentication.currentUser;
    return Scaffold(
      appBar: header.NotHeader(context, "Gacha",
          "5코인으로 가챠 1회 뽑기가 가능합니다. \n"
              "둥근 화살표를 눌러 연속 가챠가 가능합니다. \n"
              "오류가 발생할 수 있으니 연타는 삼가주세요."),
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
            const SizedBox(height: 15),
            FutureBuilder(
                future: cs.getCoin(user!.uid),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Column(
                    children: [
                      Text("보유 코인 : ${snapshot.data}"),
                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                              onPressed: () async {
                                if(load){return;}
                                setState(() {
                                  load=true;
                                });
                                try {
                                  if(! await cs.changeCoin(snapshot.data-5*num, user!.uid)){
                                    myNotification.SnackbarBasic(context, "코인이 부족합니다!");
                                  }
                                  else{
                                    //랜덤으로 선물 뽑기
                                    List gift = await itemmethod.getGacha(user!.uid, num);

                                    //선물을 뽑은 아이템에 추가
                                    await itemmethod.addPickItem(user!.uid, gift);

                                    //확인 창 띄우기
                                    myNotification.DialogGacha(context, gift);
                                  }

                                } catch (e) {
                                  myNotification.SnackbarBasic(context,
                                      "오류! 새로고침 후 다시 시도해주세요. 오류가 계속 될 경우 총괄계 제보 바랍니다.");
                                }
                                setState(() {
                                  load=false;
                                });
                              },
                              child: Text(
                  load ? "Loading...":'가챠 ${num.toString()}회',
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
                      )
                  ]

                  );
                }
            ),

          ],
        )



      ),
    );
  }
}
