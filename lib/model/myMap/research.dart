import 'package:flutter/material.dart';
import 'package:myapp/DTO/myMap/mapPointDTO.dart';
import 'package:myapp/DTO/myMap/myMapDTO.dart';
import 'package:myapp/model/widget/header.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:myapp/service/myMapService.dart';

class Research extends StatefulWidget {
  const Research({super.key, required this.mmd});

  final MyMapDTO mmd;

  @override
  State<Research> createState() => _ResearchState();
}

class _ResearchState extends State<Research> {
  MyMapService mms = MyMapService();
  String pos = "";
  Header header = Header();
  MyNotification mn = MyNotification();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header.NotHeader(
          context, "MAP", "조사 중 발견한 비밀번호로 잠긴 구역과 다른 사람의 개인실을 들어갈 수도 있습니다."),
      body: FutureBuilder(
          future: Future.wait([
            mms.getPoint(pos),
            mms.getUnderPoints(pos),
            mms.getMapImage(pos)
          ]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              MapPointDTO mpd = snapshot.data[0];

              pos = mpd.uid;

              List<Widget> underPoint = [];
              for (MapPointDTO point in snapshot.data[1]) {
                underPoint.add(OutlinedButton(
                  onPressed: () async {
                    if(point.lock.isNotEmpty){
                      bool r = await mn.DialogToCheckMap(context,point.lock);
                      if(r){
                        setState(() {
                          pos = point.uid;
                        });
                      }
                      return;
                    }else{
                      setState(() {
                        pos = point.uid;
                      });
                    }

                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide.none,
                  ),
                  child: Text("> ${point.title}"), // 테두리 두께
                ));
              }

              if (pos.isNotEmpty) {
                underPoint.add(OutlinedButton(
                  onPressed: () async {
                    setState(() {
                      pos = mpd.parent;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide.none,
                  ),
                  child: Text("< 뒤로가기"), // 테두리 두께
                ));
              }

              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      pos.isEmpty ? SizedBox(height: 2,) :Image.network(snapshot.data[2]),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          mpd.title,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          mpd.text,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: underPoint,
                      ),
                      SizedBox(height: 100,)
                    ],
                  ),
                ),
              );
            }

            return Text("Loading...");
          }),
    );
  }
}
