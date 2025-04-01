import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final List colors = <Color>[
    Colors.red.withAlpha(50),
    Colors.green.withAlpha(30),
    Colors.blue.withAlpha(70),
    Colors.yellow.withAlpha(90),
    Colors.amber.withAlpha(50),
    Colors.indigo.withAlpha(70),
  ];

  int input =0;
  InputTextFormField itff = InputTextFormField();

  MyNotification mn = MyNotification();
  Usermethod um = Usermethod();
  int coin =0;
  final _authentication = FirebaseAuth.instance;
  CoinService cs = CoinService();
  static final _random = Random();


  @override
  Widget build(BuildContext context) {
    final user = _authentication.currentUser;
    RouletteGroup group = RouletteGroup.uniform(
      6,
      colorBuilder: (index) => colors[index],
      textBuilder: (index) {
        switch(index){
          case 0: return 'x0';
          case 1: return 'x1';
          case 2: return 'x0';
          case 3: return 'x1.5';
          case 4: return 'x0';
          case 5: return 'x2';
        }

        return '';
      },
    );
    final _controller = RouletteController(group: group, vsync: this);

    return Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.5,
            child: Roulette(
                controller: _controller
            ),
          ),
          const SizedBox(height: 20,),
          FutureBuilder(
              future: cs.getCoin(user!.uid),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(!snapshot.hasData){return Text("Loading...");}
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
                        onSaved: (value) {input = int.parse(value!);},
                        onChanged: (value) {input = int.parse(value!);},
                        decoration: itff.basicFormDeco("베팅할 금액을 입력해주세요."),
                      ),
                    ),
                    FilledButton(
                      onPressed: () async {
                        if(input<=0){
                          mn.DialogBasic(context, "베팅할 금액을 입력해주세요.");
                          return;
                        }
                        if (snapshot.data < input) {
                          mn.DialogBasic(context, "잔액이 부족합니다!");
                        }
                        else{
                          cs.changeCoin(snapshot.data-input, user!.uid);
                          //애니메
                          int result = _random.nextInt(6);
                          final completed = await _controller.rollTo(
                            result,
                            offset: _random.nextDouble(),
                          );
                          coin =await cs.getRoulette(snapshot.data-input, input, result, user!.uid, context);
                          setState(() {});
                        }

                      },
                      child: const Text('Go!!'),
                    )
                  ],
                );
              }
          ),




        ]
    );
  }
}
// TODO Implement this library.