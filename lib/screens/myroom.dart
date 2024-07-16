import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/method/boardMethod.dart';
import 'package:myapp/method/userMethod.dart';
import 'package:myapp/widget/header.dart';
import 'package:myapp/widget/myNotification.dart';

class Myroom extends StatefulWidget {
  const Myroom({super.key});

  @override
  State<Myroom> createState() => _MyroomState();
}

class _MyroomState extends State<Myroom> {
  Usermethod usermethod = new Usermethod();
  final _authentication = FirebaseAuth.instance;
  MyNotification myNotification =MyNotification();
  Header header=Header();
  Boardmethod boardmethod=Boardmethod();

  @override
  Widget build(BuildContext context) {
    final user = _authentication.currentUser;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: header.screenHeader(context, "MY ROOM"),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Divider(color: Colors.black),
                  Text("[호감도 현황]",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  FutureBuilder(
                      future:  Future.wait([usermethod.getMyLikePoint(user!.uid),usermethod.showMySpecialGift(user.uid),usermethod.getMyItem(user!.uid)]),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          //호감도 출력용
                          List data =snapshot.data[0];
                          List<DataRow> datacelldata=[];

                          //특별 선물 출력용
                          List dataimage =snapshot.data[1];
                          List<DataRow> datacelldataimage=[];

                          //소유 아이템 출력용
                          List Item=snapshot.data[2];
                          List<DataRow> datacellItem=[];


                          for(int i=0; i<data.length; i++){
                            //호감도
                            int likenum=data[i][2];
                            //상대 이름
                            String name= data[i][1];
                            //상대 uid
                            String uid= data[i][0];



                            datacelldata.add(
                                DataRow(cells: [
                                  DataCell(Text(name)),
                                  DataCell(Text(likenum.toString())),
                                  DataCell(IconButton(

                                    onPressed:() async {
                                      String resultText="";
                                      int result=await usermethod.getSpecialGift(user.uid,likenum,uid,name);
                                      print(result);
                                      if(result==0){resultText="선물 받기 성공!";}
                                      if(result==1){resultText="호감도가 부족합니다.";}
                                      if(result==2){resultText="이미 받은 선물입니다.";}
                                      myNotification.SnackbarBasic(context, resultText);
                                      setState(() {});
                                      },
                                    icon: Icon(Icons.card_giftcard),

                                  )),
                                ])
                            );
                          }


                          for(int i=0; i<dataimage.length; i++){
                            //선물 이름
                            String giftName= snapshot.data[1][i][0];
                            //선물 url
                            String giftUrl= snapshot.data[1][i][1];

                            datacelldataimage.add(
                                DataRow(cells: [
                                  DataCell(SizedBox(
                                    width: 100,
                                    child: Text(giftName),
                                  )),
                                  DataCell(SizedBox(

                                    child: GestureDetector(
                                      onTap:(){return myNotification.DialogwithImage(context,giftUrl);},
                                      child: Container(
                                        padding: EdgeInsets.all(5.0),

                                        child: Image.network(giftUrl,
                                            width: 200,
                                            height:200,
                                            fit: BoxFit.cover,
                                        ),
                                      ),
                                    )

                                  )),
                                ])
                            );
                          }

                          for(int i=0; i<Item.length; i++){
                            //선물 이름
                            String ItemName= Item[i][0];
                            //선물 뽑은 날짜
                            List date=boardmethod.convertDate(Item[i][1]);
                            String ItemDate= date[1]+"/"+date[2]+" "+date[3]+":"+date[4];

                            datacellItem.add(
                                DataRow(cells: [
                                  DataCell(SizedBox(
                                    width: 100,
                                    child: Text(ItemName),
                                  )),
                                  DataCell(SizedBox(
                                    width: 100,
                                    child: Text(ItemDate),
                                  )),

                                ])
                            );
                          }


                          return Column(
                            children: [
                              DataTable(
                                  columns: const [
                                    DataColumn(label: Text("이름")),
                                    DataColumn(label: Text("호감도")),
                                    DataColumn(label: Text("")),
                                  ],
                                  rows: datacelldata
                              ),
                              Divider(color: Colors.black),


                              Text("[보유 특별 선물]",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),

                              DataTable(
                                  columns: const [
                                    DataColumn(label:SizedBox(
                                      width: 100,
                                        child: Text('선물명'),
                                    )) ,
                                    DataColumn(label:
                                    SizedBox(
                                      width: 200,
                                      child: Text('이미지'),
                                    ))
                                  ],
                                  rows: datacelldataimage
                              ),
                              Divider(color: Colors.black),

                              Text("[보유 아이템]",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),

                              DataTable(
                                  columns: const [
                                    DataColumn(label:Text('아이템'),
                                    ),
                                    DataColumn(label:
                                     Text('획득일'),
                                    )
                                  ],
                                  rows: datacellItem
                              ),
                              Divider(color: Colors.black),


                            ],
                          );
                        } else {
                          return const Text("로딩중");
                        }
                      })
                ],
              ),
            ),
          ),
        ));
  }


}
