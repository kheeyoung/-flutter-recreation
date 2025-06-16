import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/DTO/inquiryDTO.dart';
import 'package:myapp/model/miniGame/myApply.dart';
import 'package:myapp/model/widget/inputTextFormField.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:myapp/service/coinService.dart';
import 'package:myapp/service/lotteryService.dart';

class Lottery extends StatefulWidget {
  const Lottery({super.key});

  @override
  State<Lottery> createState() => _LotteryState();
}

class _LotteryState extends State<Lottery> {
  MyNotification mn = MyNotification();
  LotteryService ls = LotteryService();
  CoinService cs = CoinService();
  final user = FirebaseAuth.instance.currentUser;
  String today = DateTime.now().year.toString()+DateTime.now().month.toString()+DateTime.now().day.toString();
  DateTime tomorrow = DateTime.now().add(Duration(days: 1));

  List<int> myNum =[0,0,0];
  bool loading =false;

  @override
  Widget build(BuildContext context) {
    String nextDay = tomorrow.year.toString()+tomorrow.month.toString()+tomorrow.day.toString();
    return GestureDetector(
      onTap: (){FocusScope.of(context).unfocus();},
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  mn.DialogBasic(context, "Lottery\n1회 1코인 \n매일 자정에 결과가 공개됩니다.");
                },
                icon: Icon(Icons.question_mark))
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
              child: FutureBuilder(
                  future: ls.getNum(today),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
          
                    String num1 = "0";
                    String num2 = "0";
                    String num3 = "0";
          
                    try{
                      num1=snapshot.data[0].toString();
                      num2=snapshot.data[1].toString();
                      num3=snapshot.data[2].toString();
                    }catch(e){
                    }
                    return Column(
                      children: [
          
                        Text('Today\'s Lucky Number'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
          
                              ),
                              child: Center(child: Text(num1, style: TextStyle(fontSize: 40, color: Colors.white),)),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
          
                              ),
                              child: Center(child: Text(num2, style: TextStyle(fontSize: 40, color: Colors.white),)),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
          
                              ),
                              child: Center(child: Text(num3, style: TextStyle(fontSize: 40, color: Colors.white),)),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              margin: EdgeInsets.all(10),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  key: ValueKey(1),
                                  onSaved: (value) {myNum[0]=int.parse(value!);},
                                  onChanged: (value) {myNum[0]=int.parse(value!);}
          
                              ),
                            ),
                            Container(
                              width: 50,
                              margin: EdgeInsets.all(10),
                              child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  key: ValueKey(1),
                                  onSaved: (value) {myNum[1]=int.parse(value!);},
                                  onChanged: (value) {myNum[1]=int.parse(value!);}
          
                              ),
                            ),
                            Container(
                              width: 50,
                              margin: EdgeInsets.all(10),
                              child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  key: ValueKey(1),
                                  onSaved: (value) {myNum[2]=int.parse(value!);},
                                  onChanged: (value) {myNum[2]=int.parse(value!);}
          
                              ),
                            ),
                          ],
                        ),
                        OutlinedButton(onPressed: () async {
                          if(loading){return;}
                          if(myNum[0]==myNum[1] || myNum[1]==myNum[2] || myNum[0]==myNum[2]){
                            mn.SnackbarBasic(context, "중복된 숫자나 빈칸은 넣을 수 없습니다");
                            return;
                          }
                          int coin = await cs.getCoin(user!.uid);
                          if(coin<1){
                            mn.SnackbarBasic(context, "코인이 부족합니다!");
                            return;
                          }
                          loading=true;
                          await cs.changeCoin(coin-1, user!.uid);
                          await cs.makeInquiry(user!.uid, Inquirydto(-1, "Lottery 응모", "System", DateFormat('yyMMddHHmmss').format(DateTime.now())));
                          await ls.applyLottery(user!.uid, myNum, nextDay,context);
          
                          loading=false;
          
                        }, child: Text("응모")),
          
                        Myapply()
          
                      ],
                    );
                  })),
        ),
      ),
    );
  }
}
