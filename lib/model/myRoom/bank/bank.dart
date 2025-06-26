
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/model/myRoom/bank/sendMoney.dart';
import 'package:myapp/model/widget/header.dart';

import '../../../service/coinService.dart';
import '../../widget/listViewWidget.dart';

class Bank extends StatefulWidget {
  const Bank({super.key});

  @override
  State<Bank> createState() => _BankState();
}

class _BankState extends State<Bank> {
  CoinService cs = CoinService();
  final user = FirebaseAuth.instance.currentUser;
  ListViewWidget lw =ListViewWidget();
  Header header = Header();
  bool sort = false;
  @override
  Widget build(BuildContext context) {
    double fullWidth =MediaQuery.of(context).size.width;
    double fullHight =MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: header.NotHeader(context, "Bank",
          "스크롤로 새로고침이 가능합니다."),
      body: RefreshIndicator(
        backgroundColor: Colors.transparent,
        color: Colors.white,
        onRefresh: () async {
          setState(() {    });
        },
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(), // 항상 스크롤 가능하게 설정
          padding: EdgeInsets.fromLTRB(30,10,30,10),
          children: [
            Row(
              children: [
                Icon(Icons.monetization_on_sharp, size: 50),
                SizedBox(width: 10),
                Text("내 코인", style: TextStyle(fontSize: 20)),
              ],
            ),
            SizedBox(width: fullWidth,
                child: const Divider(color: Colors.black,)),

            FutureBuilder(
              future: Future.wait([cs.getCoin(user!.uid), cs.getinquiry(user!.uid)]),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(snapshot.data[0].toString(), style: TextStyle(fontSize: 50)),
                          Text(" Coin"),
                        ],
                      ),
                      SizedBox(width: fullWidth,
                          child: const Divider(color: Colors.black,)),
                      SizedBox(
                        width : fullWidth,
                        child: OutlinedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context){
                                  return Sendmoney();
                                }));
                          },
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.black54,
                          ),
                            child: Text("송금하기", style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      SizedBox(height: 30,),
                      Container(
                        color: Colors.black12,
                        width: fullWidth,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text("  입출금 내역"),
                            IconButton(onPressed:(){
                              setState(() {
                                sort = sort ? false: true;
                              });
                            }, icon: Icon(Icons.keyboard_arrow_down_sharp))

                          ],
                        ),
                      ),

                      lw.showBank(snapshot.data[1], context, sort)
                    ],
                  );
                }
                return Text("loading...");
              },
            ),
            LayoutBuilder( // 추가적인 빈 공간 (스크롤 가능하도록)
              builder: (context, constraints) {
                double filledHeight = constraints.maxHeight; // 현재 채워진 높이
                return SizedBox(height: fullHight- filledHeight >0 ? filledHeight- filledHeight : 10);
              },
            ),
          ],
        ),
      ),
    );
  }
}
