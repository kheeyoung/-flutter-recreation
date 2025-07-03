import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/DTO/myMap/myMapDTO.dart';
import 'package:myapp/model/gacha.dart';
import 'package:myapp/model/gift.dart';
import 'package:myapp/model/board.dart';
import 'package:myapp/model/master/masterPage.dart';
import 'package:myapp/model/miniGame/miniGame.dart';
import 'package:myapp/model/myMap/research.dart';

import 'package:myapp/model/myRoom/myroom.dart';
import 'package:myapp/model/widget/header.dart';
import 'package:myapp/model/widget/myNotification.dart';

import '../model/mymap/myMap.dart';
import '../service/ectMethod.dart';
import '../service/keyMethod.dart';
import '../service/myMapService.dart';


class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final _authentication =FirebaseAuth.instance;
  Header header =Header();
  MyNotification myNotification=MyNotification();
  Keymethod key= Keymethod();
  Ectmethod ect= Ectmethod();
  MyMapService mms= MyMapService();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar:header.basicHeader(context,"메뉴",_authentication),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //1행
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //가챠 버튼
                    Column(
                      children: [
                        IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(    //가챠창으로 이동
                                builder: (context){
                                  return Gacha();
                                }));
                          },
                          icon: Icon(Icons.card_giftcard,size: 80,),tooltip: "가챠",),
                        Text("GACHA")
                      ],
                    ),
                    SizedBox(width: 20,),
                    //선물 버튼
                    Column(
                      children: [
                        IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(    //가챠창으로 이동
                                builder: (context){
                                  return const Gift();
                                }));
                          },
                          icon: Icon(Icons.send,size: 80,),tooltip: "선물",),
                        Text("GIFT")
                      ],
                    ),
                    SizedBox(width: 20,),
                    //택배
                    Column(
                      children: [
                        IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(    //가챠창으로 이동
                                builder: (context){
                                  return const Board();
                                }));
                          },
                          icon: Icon(Icons.local_post_office_rounded,size: 80,),tooltip: "택배 보관함",),
                        Text("PARCEL")
                      ],
                    ),
                  ],
                ),
            
                const SizedBox(
                  height: 15.0,
                ),
                //2행
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //마이룸
                    Column(
                      children: [
                        IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(    //가챠창으로 이동
                                builder: (context){
                                  return const Myroom();
                                }));
                          },
                          icon: Icon(Icons.door_back_door,size: 80,),tooltip: "마이룸",),
                        Text("MY ROOM")
                      ],
                    ),
                    SizedBox(width: 20,),
                    //맵
                    Column(
                      children: [
                        IconButton(
                          onPressed: ()async{
                            MyMapDTO key = await mms.getMapSetting();
                            if(key.isLock){
                              myNotification.DialogToCheckIsOK(context,key.pw,Research(mmd: key));
                            }else{
                              Navigator.push(context, MaterialPageRoute(    //가챠창으로 이동
                                  builder: (context){
                                    return Research(mmd: key);
                                  }));
                            }
                          },
                          icon: Icon(Icons.map,size: 80,),tooltip: "맵",),
                        Text("MAP")
                      ],
                    ),
                    SizedBox(width: 20,),
                    //미니게임
                    Column(
                      children: [
                        IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(    //미니겜창으로 이동
                            builder: (context){
                              return Minigame();
                            }));
            
                          },
                          icon: Icon(Icons.games_outlined,size: 80,),tooltip: "mini Game",),
                        Text("Mini Game")
                      ],
                    ),
                  ],
                ),
            
                //3핼
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //설정
                      Column(
                        children: [
                          IconButton(
                            onPressed: (){
                              myNotification.DialogToCheck(context,0,Masterpage());
                            },
                            icon: Icon(Icons.add,size: 80,),tooltip: "",),
            
                        ],
                      ),
                    ]
                )
            
              ],
            ),
          ),
        )
    );
  }
}
