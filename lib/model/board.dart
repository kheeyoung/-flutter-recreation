import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/model/widget/PostViewWidget.dart';
import 'package:myapp/model/widget/header.dart';

import '../service/boardMethod.dart';
import '../service/userMethod.dart';


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

  Icon postIconOn = Icon(Icons.local_post_office_sharp);
  Icon postIconOff = Icon(Icons.local_post_office_outlined);

  String haederTitle = "택배보관함";

  @override
  Widget build(BuildContext context) {
    final user = _authentication.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, //appBar 투명색
        title: Text(haederTitle),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                setState(() {
                  if(ViewState==false){
                    haederTitle="나의 택배보관함";
                    ViewState=true;
                  }
                  else{
                    haederTitle="택배보관함";
                    ViewState=false;
                  }
                });
              },
              icon: ViewState==true ? postIconOn : postIconOff,
            tooltip: "보기 변경",
          ),

        ],

      ),
      body: RefreshIndicator(
          backgroundColor: Colors.transparent,
          color: Colors.white,
          onRefresh: () async {
            setState(() {});
          },
          child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
              postViewWidget.PostView(ViewState,user!.uid),
              const SizedBox(height: 20,)

              ]
          )
      )




      );
  }
}






