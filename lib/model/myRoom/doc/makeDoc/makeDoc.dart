import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:myapp/model/myRoom/doc/makeDoc/basicInfo.dart';
import 'package:myapp/model/myRoom/doc/makeDoc/profileEdit.dart';
import 'package:myapp/model/myRoom/doc/makeDoc/sectionEdit.dart';


import '../../../../service/wikiService.dart';
import '../../../widget/header.dart';

class Makedoc extends StatefulWidget {
  const Makedoc({super.key});

  @override
  State<Makedoc> createState() => _MakedocState();
}

class _MakedocState extends State<Makedoc> {
  final user = FirebaseAuth.instance.currentUser;
  Header header = Header();
  WikiService ws = WikiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header.NotHeader(context, "Doc","이미지 등록시 시간이 걸릴 수 있습니다 \n좌우로 스와이프해서 문서 삭제가 가능합니다."),
        body: FutureBuilder(
            future: Future.wait([
              ws.getPersonalWiki(user!.uid),
              ws.getProfile(user!.uid, "public"),
              ws.getProfile(user!.uid, "private")
            ]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {

              if (snapshot.hasData) {
                return SingleChildScrollView(

                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Column(
                      children: [
                        ExpansionTile(
                            title: Text("기본 정보"),
                            initiallyExpanded: false,
                          children: [Basicinfo(user: user, wd: snapshot.data[0])],
                        ),
                        ExpansionTile(
                          title: Text("공개 프로필"),
                          initiallyExpanded: false,
                          children: [ProfileEdit (public: "public",)],
                        ),
                        ExpansionTile(
                          title: Text("공개 문서"),
                          initiallyExpanded: false,
                          children: [Sectionedit (uid : user!.uid, public: "public",)],
                        ),

                        ExpansionTile(
                          title: Text("비공개 프로필"),
                          initiallyExpanded: false,
                          children: [ProfileEdit (public: "private",)],
                        ),

                        ExpansionTile(
                          title: Text("비공개 문서"),
                          initiallyExpanded: false,
                          children: [Sectionedit (uid : user!.uid, public: "private",)],
                        ),

                      ],
                    ),
                  ),
                );
              }
              return Text("Loading...");
            })
    );
  }
}
