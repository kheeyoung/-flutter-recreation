import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/DTO/petDTO.dart';
import 'package:myapp/model/widget/inputTextFormField.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:myapp/service/coinService.dart';
import 'package:myapp/service/petService.dart';

import '../widget/header.dart';

class Mypet extends StatefulWidget {
  const Mypet({super.key});

  @override
  State<Mypet> createState() => _MypetState();
}

class _MypetState extends State<Mypet> {
  Header header=Header();
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
              
              return Scaffold(
                appBar: header.screenHeader(context, 'My Pet'),
                body: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                  ),
                ),
              );
            }
            else{
              Map<String,String> image = snapshot.data[1];

              Widget petImage=Image.network(image["${pd.level}.gif"]!);
              Widget feedBtn = IconButton(
                  onPressed: () async {
                    if(feeding){
                      mn.SnackbarBasic(context, "먹이를 주는 중입니다.");
                      return;
                    }
                    feeding=true;

                    int orgin = await cs.getCoin(user!.uid);

                    if(orgin<10){
                      mn.SnackbarBasic(context, "코인이 부족합니다.");
                      feeding=false;
                      return;
                    }
                    await cs.changeCoin(orgin-10, user!.uid);
                    sleep(const Duration(milliseconds: 5));
                    await ps.feed(user!.uid, pd, orgin-10,context);
                    mn.SnackbarBasic(context, "밥 주기 성공!");
                    sleep(const Duration(seconds: 1));
                    setState(() {

                    });

                    feeding=false;
                  },
                  icon: Icon(Icons.lunch_dining_rounded, size: 45,));
              return Scaffold(
                appBar: header.screenHeader(context, 'My Pet'),
                body: Center(
                  child: Column(
                    children: [
                      Text(pd.name),
                      SizedBox(height: 20,),
                      petImage,
                      SizedBox(height: 20,),
                      Text("level: ${pd.level}"),
                      Text("exp: ${pd.exp}/100"),
                      SizedBox(height: 20,),

                      feedBtn,
                      Text("밥 주기 (10코인)"),


                    ],
                  ),
                ),
              );
            }

          }
          return Scaffold(
            appBar: header.screenHeader(context, 'My Pet'),
            body: Text("Loading...")
          );

    });
  }
}
