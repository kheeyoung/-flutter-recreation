import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/material.dart';
import 'package:myapp/DTO/pet/petDTO.dart';
import 'package:myapp/model/miniGame/pet/showPet.dart';
import 'package:myapp/model/widget/header.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:myapp/service/coinService.dart';
import 'package:myapp/service/petService.dart';

import '../../widget/wikiAccordion.dart';
class Deadpet extends StatefulWidget {
  const Deadpet({super.key});

  @override
  State<Deadpet> createState() => _DeadpetState();
}

class _DeadpetState extends State<Deadpet> {
  PetService ps = PetService();
  final user = FirebaseAuth.instance.currentUser;
  MyNotification mn = MyNotification();
  Header header = Header();
  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width*0.25;
    return FutureBuilder(
        future: ps.getDeadPet(user!.uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            List<Widget> w =[SizedBox(height: 20,),Text("이전 펫 이력"), SizedBox(height: 20,)];
            List<Widget> contents=[];
            for(PetDTO data in snapshot.data){
              if(data.species.isNotEmpty){

                contents.add(GestureDetector(
                  onTap: (){
                    String reason = ps.getDeadReason(data);
                    mn.DialogBasic(context, "${data.name}\n$reason");
                    },
                  child:
                      Container(
                        width: imageSize,
                        height: imageSize,
                        child: Showpet(image: data.species, exp: data.subLevel),
                      ),
                ));
                if(contents.length>2){
                  w.add(Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                        contents[0],
                        SizedBox(width: 10),
                      contents[1],
                      SizedBox(width: 10),
                      contents[2],

                    ],
                  ));

                  w.add(SizedBox(height: 10,));
                  contents=[];
                }
              }
            }
            // 🔽 남은 위젯이 있다면 마지막 줄로 추가
            if (contents.isNotEmpty) {
              w.add(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < contents.length; i++) ...[
                    contents[i],
                    if (i != contents.length - 1) SizedBox(width: 10),
                  ],
                ],
              ));
            }




            return Scaffold(
              appBar: header.NotHeader(context, "Pet", "이전에 키운 펫들의 마지막 사진을 볼 수 있습니다."),
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                      children: w
                  ),
                ),
              )
            );
          }
          return SizedBox();
        });
  }
}
