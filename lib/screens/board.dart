import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/method/boardMethod.dart';
import 'package:myapp/method/userMethod.dart';
import 'package:myapp/widget/PostViewWidget.dart';

import 'package:myapp/widget/header.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  String? title;
  String? contents;
  String? postUid;
  String? giftName;
  String? recipientUid;
  String? senderUid;
  bool ViewState=false;    // false= 전체 글 보기 true=내게 온 글 보기
  Boardmethod boardmethod = new Boardmethod();
  Usermethod usermethod =new Usermethod();
  final _authentication = FirebaseAuth.instance;
  Header header=Header();
  PostViewWidget postViewWidget=PostViewWidget();

  @override
  Widget build(BuildContext context) {
    final user = _authentication.currentUser;
    return Scaffold(
      appBar: header.screenHeader(context, "택배 보관함"),
      body: SingleChildScrollView(

        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
              children: [

                Container(

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                          ),
                          onPressed: (){
                            setState(() {
                              ViewState=false;
                            });
                          },
                          child: const Text("전체 우편함",style: TextStyle(color: Colors.black),)
                      ),
                      const SizedBox(width: 20,),
                      OutlinedButton(
                          onPressed: (){
                            setState(() {
                              ViewState=true;
                            });
                          },
                          child: Text("내 우편함",style: TextStyle(color: Colors.black),)
                      ),
                    ],
                  ),
                ),
                postViewWidget.PostView(ViewState,user!.uid),
                const SizedBox(height: 20,)
              ],
            ),
        ),
      ),
      );
  }
}






