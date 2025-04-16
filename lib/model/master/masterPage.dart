import 'package:flutter/material.dart';
import 'package:myapp/model/master/alarmManager.dart';
import 'package:myapp/model/master/coinManager.dart';
import 'package:myapp/model/master/deletePost.dart';
import 'package:myapp/model/master/moveBody.dart';
import 'package:myapp/model/master/password.dart';
import 'package:myapp/model/widget/header.dart';



class Masterpage extends StatefulWidget {
  const Masterpage({super.key});

  @override
  State<Masterpage> createState() => _MasterpageState();
}

class _MasterpageState extends State<Masterpage> {
  Header header = Header();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header.screenHeader(context, "관리자 페이지"),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //1행
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //코인 관리 버튼
                  Column(
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context){
                                return const Coinmanager();
                              }));
                        },
                        icon: Icon(Icons.monetization_on_sharp,size: 80,),tooltip: "Coin",),
                      Text("Coin")
                    ],
                  ),
                  SizedBox(width: 20,),
                  //선물 버튼
                  Column(
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context){
                                return Password();
                              }));
                        },
                        icon: Icon(Icons.password,size: 80,),tooltip: "PW",),
                      Text("PW")
                    ],
                  ),
                  SizedBox(width: 20,),
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
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context){
                                return const Deletepost();
                              }));
                        },
                        icon: Icon(Icons.post_add,size: 80,),tooltip: "Post",),
                      Text("Post")
                    ],
                  ),
                  SizedBox(width: 20,),
                  //맵
                  Column(
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context){
                                return const Alarmmanager();
                              }));
                        },
                        icon: Icon(Icons.alarm,size: 80,),tooltip: "Alarm",),
                      Text("Alarm")
                    ],
                  ),
                  SizedBox(width: 20,),


                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}
