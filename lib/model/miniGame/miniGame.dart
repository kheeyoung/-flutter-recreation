import 'package:flutter/material.dart';
import 'package:myapp/model/miniGame/lottery.dart';
import 'package:myapp/model/miniGame/roulette.dart';
import 'package:myapp/model/widget/myRoulette.dart';

import 'myPet.dart';


class Minigame extends StatefulWidget {
  const Minigame({super.key});


  @override
  State<Minigame> createState() => _MinigameState();
}

class _MinigameState extends State<Minigame> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            //pet
            Row(
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(    //팻 창으로 이동
                            builder: (context){
                              return const Mypet();
                            }));
                      },
                      icon: Icon(Icons.pets,size: 60,),tooltip: "Pet",),
                    Text("Pet")
                  ],
                ),

                Column(
                  children: [
                    IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(    //roulette 창으로 이동
                            builder: (context){
                              return const Roulette();
                            }));
                      },
                      icon: Icon(Icons.incomplete_circle,size: 60,),tooltip: "Roulette",),
                    Text("Roulette")
                  ],
                ),

                Column(
                  children: [
                    IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(    //lottery 창으로 이동
                            builder: (context){
                              return const Lottery();
                            }));
                      },
                      icon: Icon(Icons.local_attraction_outlined,size: 60,),tooltip: "Lottery",),
                    Text("Lottery")
                  ],
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
