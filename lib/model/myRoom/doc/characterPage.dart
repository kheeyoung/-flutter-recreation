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
                  doc.add(Profile(wd: wd, public: "private"));
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
