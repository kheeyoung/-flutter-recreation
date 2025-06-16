import 'package:flutter/material.dart';
import 'package:myapp/model/widget/myRoulette.dart';


class Roulette extends StatefulWidget {
  const Roulette({super.key});


  @override
  State<Roulette> createState() => _RouletteState();
}

class _RouletteState extends State<Roulette> {
  MyRoulette mr = MyRoulette();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
