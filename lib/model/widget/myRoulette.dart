import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/DTO/inquiryDTO.dart';
import 'package:myapp/service/userMethod.dart';
import 'package:roulette/roulette.dart';
import '../../service/coinService.dart';
import 'inputTextFormField.dart';
import 'myNotification.dart';

class MyRoulette extends StatefulWidget {
  const MyRoulette({super.key});

  @override
  State<MyRoulette> createState() => _MyRouletteState();
}

class _MyRouletteState extends State<MyRoulette> with TickerProviderStateMixin {
  List<Color> colors = <Color>[
    Colors.red.withAlpha(50),
    Colors.green.withAlpha(30),
    Colors.blue.withAlpha(70),
    Colors.yellow.withAlpha(90),
    Colors.amber.withAlpha(50),
    Colors.indigo.withAlpha(70),
  ];
  List<String> score=['x0','x1','x0','x1.5','x0','x2'];

  int input = 0;
  InputTextFormField itff = InputTextFormField();

  MyNotification mn = MyNotification();
  Usermethod um = Usermethod();
  int coin = 0;
  final _authentication = FirebaseAuth.instance;
  CoinService cs = CoinService();
  static final _random = Random();

  bool load = false;




  @override
  Widget build(BuildContext context) {
    final user = _authentication.currentUser;
    RouletteGroup group = RouletteGroup.uniform(
      6,
      colorBuilder: (index) => colors[index],
      textBuilder: (index) => score[index],
    );
    RouletteController controller = RouletteController(group: group, vsync: this);

    return Column(children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.width * 0.5,
        child: Roulette(controller: controller),
      ),
      const SizedBox(
        height: 20,
      ),
      FutureBuilder(
          future: cs.getCoin(user!.uid),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading...");
            }
            return Column(
              children: [
                Text("보유 코인 : ${snapshot.data}"),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                    maxLength: 3,
                    key: ValueKey(1),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onSaved: (value) {
                      input = int.parse(value!);
                    },
                    onChanged: (value) {
                      input = int.parse(value!);
                    },
                    decoration: itff.basicFormDeco("베팅할 금액을 입력해주세요."),
                  ),
                ),
                FilledButton(
                  onPressed: () async {
                    if (load) {
                      mn.SnackbarBasic(context, "게임이 진행중입니다.");
                      return;
                    }


                      load = true;


                    await Future.delayed(Duration(milliseconds: 100));

                    if (input <= 0) {
                      mn.DialogBasic(context, "베팅할 금액을 입력해주세요.");
                      setState(() {
                        load = false;
                      });
                      return;
                    }

                    if (snapshot.data < input) {
                      mn.DialogBasic(context, "잔액이 부족합니다!");
                      load = false;
                      return;
                    }

                    await cs.changeCoin(snapshot.data - input, user!.uid);
                    await cs.makeInquiry(user!.uid, Inquirydto(-input, "룰렛", "System", ""));

                    int result = _random.nextInt(6);
                    await controller.rollTo(result,
                        offset: _random.nextDouble());


                    coin = await cs.getRoulette(snapshot.data - input, input, result, user!.uid, context);



                    load = false;

                    setState(() {

                    });
                  },
                  child: Text('Go!!'),
                )
              ],
            );
          }),
    ]);
  }
}
// TODO Implement this library.
