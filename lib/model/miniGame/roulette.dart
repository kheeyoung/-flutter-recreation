import 'package:flutter/material.dart';
import 'package:myapp/model/widget/header.dart';
import 'package:myapp/model/widget/myRoulette.dart';


class Roulette extends StatefulWidget {
  const Roulette({super.key});


  @override
  State<Roulette> createState() => _RouletteState();
}

class _RouletteState extends State<Roulette> {
  MyRoulette mr = MyRoulette();
  Header header = Header();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header.NotHeader(context, "Roulette",
          "최대 999코인까지 배팅이 가능합니다. \n"
              "각 항목의 확률은 1/6 입니다. \n"
              "오류가 발생할 수 있으니 연타는 삼가주세요."),
      body: Center(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("미니게임", style: TextStyle(fontSize: 20),),
                Text("-당신의 운을 시험해보세요-"),
                SizedBox(height: 20,),
                Icon(Icons.arrow_downward, size: 40, color: Colors.pink,),
                mr,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
