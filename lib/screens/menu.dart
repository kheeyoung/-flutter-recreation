import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/gacha.dart';
import 'package:myapp/screens/gift.dart';
import 'package:myapp/screens/board.dart';
import 'package:myapp/screens/masterPage.dart';
import 'package:myapp/screens/myMap.dart';
import 'package:myapp/screens/myroom.dart';
import 'package:myapp/widget/header.dart';
import 'package:myapp/widget/myNotification.dart';


class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final _authentication =FirebaseAuth.instance;
  Header header =Header();
  MyNotification myNotification=MyNotification();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar:header.basicHeader(context,"메뉴",_authentication),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //1열
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
                              return const Gacha();
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
            //2열
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
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(    //가챠창으로 이동
                            builder: (context){
                              return const MyMap();
                            }));
                      },
                      icon: Icon(Icons.map,size: 80,),tooltip: "맵",),
                    Text("MAP")
                  ],
                ),
                SizedBox(width: 20,),
                //택배
                Column(
                  children: [
                    IconButton(
                      onPressed: (){
                        myNotification.DialogToCheck(context,0,Masterpage());
                      },
                      icon: Icon(Icons.add,size: 80,),tooltip: "",),
                    Text("OO's ROOM")
                  ],
                ),
              ],
            ),

          ],
        ),
      )
    );
  }
}


