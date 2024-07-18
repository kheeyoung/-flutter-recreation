import 'package:flutter/material.dart';
import 'package:myapp/method/mapMethod.dart';
import 'package:myapp/widget/header.dart';
import 'package:myapp/DTO/myMap.dart';

class Detailedmap extends StatefulWidget {
  const Detailedmap({super.key, required this.floor});

  final int floor;

  @override
  State<Detailedmap> createState() => _DetailedmapState();
}

class _DetailedmapState extends State<Detailedmap> {
  Header header = Header();
  Mapmethod mapmethod = Mapmethod();
  String room = "";
  int level = 0;
  String item1 = "";
  String item2 = "";
  String item3 = "";
  String item4 = "";
  String item5 = "";

  bool isOpen=true;

  @override
  Widget build(BuildContext context) {
    int F = widget.floor;
    return Scaffold(
      appBar: header.screenHeader(context, F.toString() + "층"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: Future.wait([mapmethod.getMap("map" + F.toString()), mapmethod.isOpend("map" + F.toString()), mapmethod.getMapImage(F)]),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    //열렸나 확인
                    isOpen=snapshot.data[1];
                    List<String> items = [item1, item2, item3, item4, item5];
                    List mapList = snapshot.data[0];

                    //설명 텍스트 출력
                    String txt = mapmethod.getMapTxt(level, room, items, mapList);

                    //맵 선택지 가져오기
                    List<String> mapdata = mapmethod.showMap(level, room, items, mapList);





                    //맵 이미지용
                    String mapimage=snapshot.data[2];
                    Widget mapImageView;
                    if(mapimage==""){//이미지가 없는 경우
                      mapImageView=Text("등록된 이미지가 없습니다.");
                    }
                    else{
                      mapImageView=Image.network(mapimage);
                    }



                    //위젯에 담아 리스트로 만들기
                    List<Widget> mapWidget = [];

                    for (int i = 0; i < mapdata.length; i++) {

                      mapWidget.add(TextButton(
                          onPressed: () {
                            setState(() {
                              switch (level) {
                                case 0:
                                  room = mapdata[i];
                                  break;
                                case 1:
                                  item1 = mapdata[i];
                                  break;
                                case 2:
                                  item2 = mapdata[i];
                                  break;
                                case 3:
                                  item3 = mapdata[i];
                                  break;
                                case 4:
                                  item4 = mapdata[i];
                                  break;
                                case 5:
                                  item5 = mapdata[i];
                                  break;
                              }
                              level++;
                              txt = "";
                            });
                          },
                          child: Text(
                            ">" + mapdata[i],
                            style: TextStyle(color: Colors.black),
                          )));
                    }
                    if (level != 0) {
                      mapWidget.add(TextButton(
                          onPressed: () {
                            setState(() {
                              level--;
                              txt = "";
                              switch (level) {
                                case 0:
                                  room = "";
                                  break;
                                case 1:
                                  item1 = "";
                                  break;
                                case 2:
                                  item2 = "";
                                  break;
                                case 3:
                                  item3 = "";
                                  break;
                                case 4:
                                  item4 = "";
                                  break;
                                case 5:
                                  item5 = "";
                                  break;
                              }
                            });
                          },
                          child: const Text(">돌아가기",
                              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold))));
                    }


                    if(isOpen==false){return Center(child: const Text("문이 열리지 않는다."));}
                    else{return Container(
                      padding: const EdgeInsets.all(20),
                      //width: 350,
                      child: Column(
                        children: [
                          const SizedBox(height: 15,),
                          mapImageView,
                          const SizedBox(height: 15,),
                          Text(txt),

                          const SizedBox(height: 10,),
                          ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: mapWidget,
                          ),
                        ],
                      ),
                    );}

                  }
                  else {
                    return Center(child: Text("로딩중"));
                  }
                }),
          ],
        ),
      ),
    );
  }
}
