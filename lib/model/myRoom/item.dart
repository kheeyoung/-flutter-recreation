import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../service/boardMethod.dart';
import '../../service/itemMethod.dart';
import '../../service/userMethod.dart';
import '../widget/header.dart';
import '../widget/myNotification.dart';

class Item extends StatefulWidget {
  const Item({super.key});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  Usermethod usermethod = new Usermethod();
  final _authentication = FirebaseAuth.instance;
  MyNotification myNotification =MyNotification();
  Header header=Header();
  Boardmethod boardmethod=Boardmethod();
  Itemmethod im = Itemmethod();

  @override
  Widget build(BuildContext context) {
    final user = _authentication.currentUser;
    return Scaffold(
      appBar: header.screenHeader(context, '보유 아이템'),
      body: SingleChildScrollView(
          child: FutureBuilder(
              future:  Future.wait([usermethod.showMySpecialGift(user!.uid),usermethod.getMyItem(user!.uid)]),
              builder: (BuildContext context, AsyncSnapshot snapshot) {

                if (snapshot.hasData) {

                  //특별 선물 출력용
                  List dataimage =snapshot.data[0];
                  List<DataRow> datacelldataimage=[];

                  //소유 아이템 출력용
                  List Item=snapshot.data[1];
                  List<DataRow> datacellItem=[];

                  for(int i=0; i<dataimage.length; i++){
                    //선물 이름
                    String giftName= snapshot.data[0][i][0];
                    //선물 url
                    String giftUrl= snapshot.data[0][i][1];

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

                 Map<String,int> myItmeList=Map<String,int>();

                  for(int i=0; i<Item.length; i++){
                    if(myItmeList.containsKey(Item[i][0])){
                      myItmeList[Item[i][0]]=(myItmeList[Item[i][0]]!+1);
                    }
                    else{myItmeList[Item[i][0]]=1;}
                  }
                  for(String s in myItmeList.keys){
                    datacellItem.add(
                        DataRow(cells: [
                          DataCell(SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(s),
                          )),
                          DataCell(SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Text(myItmeList[s].toString()),
                          )),

                        ])
                    );
                  }

                  return Center(
                    child: Column(
                      children: [
                        Text("[보유 특별 선물]",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        SizedBox(
                          width :MediaQuery.of(context).size.width * 0.8,
                          child: DataTable(
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
                        ),
                        SizedBox(width : MediaQuery.of(context).size.width * 0.8,
                            child: Divider(color: Colors.black,)),

                        Text("[보유 아이템]",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),

                        SizedBox(
                          width : MediaQuery.of(context).size.width * 0.8,
                          child: DataTable(
                              columns: const [
                                DataColumn(label:Text('아이템')
                                ),
                                DataColumn(label:
                                Text('개수'),
                                )
                              ],
                              rows: datacellItem
                          ),
                        ),
                        OutlinedButton(
                            onPressed: ()async{
                              myNotification.SnackbarBasic(context, await im.pickImage(user.uid));

                        },
                            child: Text("내 특별 선물 등록하기")
                        )
                      ],
                    ),
                  );
                } else {
                  return const Text("로딩중");
                }
              }),
      )
    );
  }
}
