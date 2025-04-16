import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/DTO/petDTO.dart';
import 'package:myapp/model/widget/inputTextFormField.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:myapp/service/coinService.dart';
import 'package:myapp/service/petService.dart';

class Mypet extends StatefulWidget {
  const Mypet({super.key});

  @override
  State<Mypet> createState() => _MypetState();
}

class _MypetState extends State<Mypet> {
  PetService ps = PetService();
  final user = FirebaseAuth.instance.currentUser;
  MyNotification mn = MyNotification();
  InputTextFormField itff =InputTextFormField();
  CoinService cs = CoinService();
  String petName="";
  bool feeding =false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([ps.getMyPet(user!.uid), ps.getPetImage()]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            petDTO pd =snapshot.data[0];
            if(pd.name==""){
              
              return Column(
                children: [
                  Text("현재 보유한 팻이 없습니다."),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.5 ,
                    child: TextFormField(
                        initialValue: petName,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54
                        ),
                        decoration: itff.noMarginFormDeco("pet name"),
                        maxLength: 10,
                        key: ValueKey(2),
                        onSaved: (value) {
                          petName = value!;
                        },
                        onChanged: (value) {
                          petName = value!;
                        }
                    ),
                  ),
                  OutlinedButton(
                      onPressed: () async {
                        if(petName==""){
                          mn.SnackbarBasic(context, "팻 이름을 입력해주세요.");
                          return;
                        }

                        int orgin = await cs.getCoin(user!.uid);
                        if(orgin<10){
                          mn.SnackbarBasic(context, "코인이 부족합니다.");
                          return;
                        }
                        await cs.changeCoin(orgin-10, user!.uid);
                        ps.makePet(user!.uid,petName);
                        mn.SnackbarBasic(context, "생성 성공!");
                        setState(() { });

                      },
                      child: Text("팻 생성하기 (10 Coin)")),
                ],
              );
            }
            else{
              Map<String,String> image = snapshot.data[1];

              Widget petImage=Image.network(image["${pd.level}.jpg"]!);
              Widget feedBtn = pd.level>3 ? Text("${pd.name} 이/가 현재 최고 레벨 입니다.") : IconButton(
                  onPressed: () async {
                    if(feeding){
                      mn.SnackbarBasic(context, "먹이를 주는 중입니다.");
                      return;
                    }
                    feeding=true;
                    sleep(const Duration(seconds: 1));
                    int orgin = await cs.getCoin(user!.uid);
                    if(orgin<10){
                      mn.SnackbarBasic(context, "코인이 부족합니다.");
                      feeding=false;
                      return;
                    }
                    await cs.changeCoin(orgin-10, user!.uid);
                    await ps.feed(user!.uid, pd);
                    mn.SnackbarBasic(context, "밥 주기 성공!");
                    feeding=false;
                    setState(() {

                    });
                  },
                  icon: Icon(Icons.rice_bowl, size: 45,));
              return Column(
                children: [
                  Text(pd.name),
                  petImage,
                  Text("level: ${pd.level}"),
                  Text("exp: ${pd.exp}/100"),
                  SizedBox(height: 20,),

                  feedBtn,
                  Text("밥 주기 (10코인)"),


                ],
              );
            }

          }
          return Text("Loading...");

    });
  }
}
