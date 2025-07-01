import 'package:flutter/material.dart';
import 'package:myapp/DTO/wikiDTO/wikiDTO.dart';
import 'package:myapp/model/myRoom/doc/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/model/myRoom/doc/section.dart';
import '../../../service/wikiService.dart';
import '../../widget/header.dart';

class Characterpage extends StatefulWidget {
  final String uid;
  const Characterpage({super.key, required this.uid});

  @override
  State<Characterpage> createState() => _CharacterpageState();
}

class _CharacterpageState extends State<Characterpage> {
  Header header = Header();
  WikiService ws =WikiService();
  final _authentication = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    final user = _authentication.currentUser;
    var h = user!.uid==widget.uid ? header.DocEditHeader(context, "Doc"):header.NotHeader(context, "Doc", "문서 수정은 본인의 것만 가능 합니다.");
    return Scaffold(
        appBar: h,
        body: FutureBuilder(
            future: ws.getPersonalWiki(widget.uid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {

              if (snapshot.hasData) {

                WikiDto wd = snapshot.data;

                List<Widget> doc = [
                  Profile(wd: wd, public: "public",),
                  Section(public: "public", uid: wd.uid, color: wd.color),
                  SizedBox(height: 10,)];

                if(wd.private==true){
                  doc.add(SizedBox(height: 30,));
                  doc.add(
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 1), // 검정 테두리
                        ),

                        child: Column(
                          children: [
                            Container(
                              color: ws.colorFromHex("#F5A615"),
                              width: fullWidth * 0.8,
                              height: 10,
                            ),
                            Container(
                              width: fullWidth * 0.8,
                              padding: EdgeInsets.all(5),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(fontSize: 18, color: Colors.black),
                                      children: [
                                        TextSpan(text: "이 문서에 "),
                                        TextSpan(
                                          text: "스포일러",
                                          style: TextStyle(color: ws.colorFromHex("#487CA1")),
                                        ),
                                        TextSpan(text: "가 포함되어 있습니다."),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "이 문서가 설명하는 작품이나 인물 등에 대한 줄거리, 결말, 반전 요소 등을 직·간접적으로 포함하고 있습니다.",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )

                  );
                  doc.add(SizedBox(height: 40,));
                  doc.add(Profile(wd: wd, public: "private"),


                  );
                  doc.add(Section(public: "private", uid: wd.uid, color: wd.color));
                }

                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: doc
                    ),
                  ),
                );
              }
              return Text("Loading...");

            })
    );
  }
}
