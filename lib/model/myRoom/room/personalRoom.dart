import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/DTO/room/roomDTO.dart';
import 'package:myapp/DTO/room/roomItemDTO.dart';
import 'package:myapp/model/myRoom/room/editRoom.dart';
import 'package:myapp/model/myRoom/room/editTop.dart';
import 'package:myapp/model/widget/header.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:myapp/service/roomService.dart';

class Personalroom extends StatefulWidget {
  final String uid;
  final RoomDto rd;

  const Personalroom({super.key, required this.uid, required this.rd});

  @override
  State<Personalroom> createState() => _PersonalroomState();
}

class _PersonalroomState extends State<Personalroom> {
  Header header = Header();
  RoomService rs = RoomService();
  final _authentication = FirebaseAuth.instance;
  MyNotification mn = MyNotification();
  List<String> pos = [];

  @override
  Widget build(BuildContext context) {
    final user = _authentication.currentUser;
    return FutureBuilder(
        future: Future.wait([
          rs.getPoint(widget.uid, pos.isNotEmpty ? pos.last : ""),
          rs.getPersonalRoom(widget.uid, pos.isNotEmpty ? pos.last : ""),
          rs.getImage(widget.uid)
        ]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Widget> point = [
              Image.network(snapshot.data[2])
            ];

            //자기 방이면 수정 가능
            if (user!.uid == widget.uid) {
              point.add( Row(

                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => pos.isNotEmpty ? Editroom(rid: snapshot.data[0], uid: widget.uid) : Edittop(uid: widget.uid, rid: snapshot.data[1]),
                            ));
                      },
                      style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.zero))),
                      icon: Icon(Icons.edit), // 테두리 두께
                    ),
                    IconButton(
                      onPressed: () {
                        mn.changeLock(user!.uid, context);
                      },
                      style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.zero))),
                      icon: Icon(Icons.settings_rounded), // 테두리 두께
                    ),
                  ],
                ),
              );
            }

            //설명
            point.add(Text(snapshot.data[0].name.isEmpty ? "[${widget.rd.name}의 개인실]" : "[${snapshot.data[0].name}]", style: TextStyle(fontSize: 15), ));
            point.add(SizedBox(height: 10,));
            point.add(Text(snapshot.data[0].name.isEmpty ? "${widget.rd.name}의 개인실" : snapshot.data[0].text ));
            point.add(SizedBox(height: 20,));

            //선택지 추가
            for (RoomItemDto rid in snapshot.data[1]) {
              point.add(OutlinedButton(
                onPressed: () {
                  pos.add(rid.id);
                  setState(() {});
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide.none,
                ),
                child: Text("> ${rid.name}"), // 테두리 두께
              ));
            }
            //뒤로가기
            if(pos.isNotEmpty){point.add(OutlinedButton(
              onPressed: () {
                pos.removeLast();
                setState(() {});
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide.none,
              ),
              child: Text("< 뒤로 가기"), // 테두리 두께
            ));}

            return Scaffold(
                appBar: header.NotHeader(
                    context, "${widget.rd.name}의 개인실", "방의 편집은 자신의 방만 가능합니다.\n초기 비밀번호는 0000입니다."),
                body: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: point,
                      ),
                    ),
                  ),
                ));
          }
          return Scaffold(
              appBar: header.NotHeader(
                  context, "${widget.rd.name}의 개인실", "방의 편집은 자신의 방만 가능합니다."),
              body: Text("Loading..."));
        });
  }
}
