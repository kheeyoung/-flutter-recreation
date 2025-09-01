import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myapp/DTO/lotteryDTO.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:myapp/service/coinService.dart';
import 'package:myapp/service/lotteryService.dart';

class Myapply extends StatefulWidget {
  const Myapply({super.key});

  @override
  State<Myapply> createState() => _MyapplyState();
}

class _MyapplyState extends State<Myapply> {
  LotteryService ls = LotteryService();
  DateTime pickDay = DateTime.now();
  MyNotification mn = MyNotification();
  final user = FirebaseAuth.instance.currentUser;
  CoinService cs= CoinService();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    String day = pickDay.year.toString() +
        pickDay.month.toString() +
        pickDay.day.toString();
    return SingleChildScrollView(
      child: FutureBuilder(
          future: Future.wait([ls.getMyApply(day, user!.uid), ls.getNum(day)]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<DataRow> data = [];
              List<int> num = snapshot.data[1];
      
              for (LotteryDTO i in snapshot.data[0]) {
                Widget w = Text("미당첨");
                int rank=ls.checkLottery(num, i.num);
                if(rank>2){ //전부 다 맞춰야 지급
                  w = Text("당첨");
                }
      
                data.add(DataRow(
                    onSelectChanged: (newValue) async{
                      if(rank<2){
                        mn.DialogBasic(context, "꽝");
                        return;
                      }
      
      
                      List<Widget> dialogWiget =[
                        Text("1등"),
                        IconButton(onPressed: () async {
                          print(await ls.getByID(i.id,day,user!.uid));
                          if(await ls.getByID(i.id,day,user!.uid)){
                            mn.DialogBasic(context, "이미 수령한 상금입니다.");
                            return;
                          }
                          await ls.getPrize(i, day, user!.uid);
                          mn.DialogBasic(context,"상금으로 100 코인을 획득하였습니다!");
                        }, icon: Icon(Icons.card_giftcard))
                      ];
      
                      mn.wigetListDialog(dialogWiget,context);
                    },
                    cells: [
                      DataCell(Container(
                          width: screenWidth * 0.6,
                          child: Text(i.num.toString()))),
                      DataCell(Container(
                          width: screenWidth * 0.2,
                          child: w))
                    ]));
              }
              return Container(
                width: screenWidth * 0.8,
                //height: screenHeight*0.5,
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    SizedBox(width: screenWidth*0.8,child: Divider(),),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text("응모 이력",style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(width: 20,),
                        OutlinedButton(
                            onPressed: () async {
                              DateTime selectedDate = (await showDatePicker(
                                context: context,
                                firstDate: DateTime(2025),
                                lastDate: DateTime.now().add(Duration(days: 1))
                              ))!;
                              if (selectedDate != null) {
                                setState(() {
                                  pickDay = selectedDate; // 선택한 날짜는 date 변수에 저장
                                });
                              }
                            },
                            child: Text("${pickDay.month}/${pickDay.day}"),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.all(5),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Text(num.length>0 ? "Lucky Num : ${num[0]}, ${num[1]}, ${num[2]}" : "")
                      ],
                    ),
                    SizedBox(height: 10,),
                    SizedBox(width: screenWidth*0.8,child: Divider(),),
                    SizedBox(height: 10,),
                    ListView(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          DataTable(
                            showCheckboxColumn: false,
                            horizontalMargin: 12.0,
                            columnSpacing: 10.0,
                            columns: const [
                              DataColumn(
                                  label: Text('응모 번호',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('결과',
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold)))
                            ],
                            rows: data,
                          )
                        ]),
                  ],
                ),
              );
            }
            return Text("NO Data");
          }),
    );
  }
}
