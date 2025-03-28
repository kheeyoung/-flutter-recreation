import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../service/boardMethod.dart';
import '../../service/userMethod.dart';
import '../widget/header.dart';
import '../widget/myNotification.dart';



class Likepoint extends StatefulWidget {
  const Likepoint({super.key});

  @override
  State<Likepoint> createState() => _LikepointState();
}

class _LikepointState extends State<Likepoint> {
  Usermethod usermethod = new Usermethod();
  final _authentication = FirebaseAuth.instance;
  MyNotification mn =MyNotification();
  Header header=Header();
  Boardmethod boardmethod=Boardmethod();
  @override
  Widget build(BuildContext context) {
    final user = _authentication.currentUser;
    return Scaffold(
      appBar: header.screenHeader(context, "호감도 현황"),
      body: SingleChildScrollView(
        child: Center(
            child: Column(children: [
        
              FutureBuilder(
                  future: Future.wait([usermethod.getMyLikePoint(user!.uid)]),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      //호감도 출력용
                      List data = snapshot.data[0];
                      List<DataRow> datacelldata = [];
        
                      for (int i = 0; i < data.length; i++) {
                        print(data[i][1]);
                        //호감도
                        int likenum = data[i][2];
                        //상대 이름
                        String name = data[i][1];
                        //상대 uid
                        String uid = data[i][0];
        
                        datacelldata.add(DataRow(cells: [
                          DataCell(Text(name)),
                          DataCell(Text(likenum.toString())),
                          DataCell(IconButton(
                            onPressed: () async {
                              String resultText = "";
                              int result = await usermethod.getSpecialGift(
                                  user!.uid, likenum, uid, name);
                              if (result == 0) {
                                resultText = "선물 받기 성공!";
                              }
                              if (result == 1) {
                                resultText = "호감도가 부족합니다.";
                              }
                              if (result == 2) {
                                resultText = "이미 받은 선물입니다.";
                              }
                              if (result == 3) {
                                resultText = "특별 선물이 아직 등록되지 않았습니다.";
                              }
                              mn.SnackbarBasic(context, resultText);
                            },
                            icon: Icon(Icons.card_giftcard),
                          )),
                        ]));
                      }
                      return DataTable(
                            columns: const [
                              DataColumn(label:SizedBox(
                                width: 50,
                                child: Text('이름'),
                              )) ,
                              DataColumn(label:
                              SizedBox(
                                width: 50,
                                child: Text('호감도'),
                              )),
                              DataColumn(label:SizedBox(
                                width: 50,
                                child: Text(''),
                              ))
                            ],
                            rows: datacelldata
        
                      );
                    }
                    return Text("loading...");
                  }),
        
            ])),
      ),
    );
  }
}

