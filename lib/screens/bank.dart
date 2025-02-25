import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/widget/coinCounter.dart';

import '../method/boardMethod.dart';
import '../method/notification_controller.dart';
import '../method/userMethod.dart';
import '../widget/header.dart';
import '../widget/inputTextFormField.dart';
import '../widget/listViewWidget.dart';
import '../widget/myNotification.dart';

class Bank extends StatefulWidget {
  const Bank({super.key});

  @override
  State<Bank> createState() => _BankState();
}

class _BankState extends State<Bank> {
  final _authentication = FirebaseAuth.instance;
  Usermethod usermethod = Usermethod();
  ListViewWidget listViewWidget = ListViewWidget();
  String SelectedUser = "";
  int coin = 0;
  InputTextFormField inputTextFormField = InputTextFormField();
  MyNotification myNotification = MyNotification();
  CoinCounter cc = CoinCounter();
  NotificationController nc =NotificationController();

  @override
  Widget build(BuildContext context) {
    final user = _authentication.currentUser;
    return Scaffold(
      appBar: AppBar(),
      body: Center(

          child: Column(
            children: [
              Text("[내 코인]",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cc.getCounterText(user!.uid),
                  IconButton(onPressed: (){
                    setState(() {

                    });
                  }, icon: Icon(Icons.refresh, size: 15,))
                ],
              ),


          SizedBox(width: MediaQuery
              .of(context)
              .size
              .width * 0.8,
              child: Divider(color: Colors.black,)),

          Text("[송금하기]",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),

          FutureBuilder(
            future: Future.wait(
                [usermethod.getUserName()]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List userNames = snapshot.data[0];


                return Column(
                  children: [
                    const SizedBox(height: 20),
                    //수신인, 선물 선택
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("수신인 : "),
                          DropdownButton<String>(
                            value: SelectedUser.isNotEmpty
                                ? SelectedUser
                                : null,
                            items: userNames
                                .map((e) =>
                                DropdownMenuItem(
                                  value: e.toString(),
                                  child: Text(e.toString(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                SelectedUser = newValue!;
                              });
                            },
                            dropdownColor: Colors.white,
                            iconSize: 50,
                          ),
                          SizedBox(
                            width: 60,
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              maxLength: 3,
                              key: ValueKey(1),
                              onSaved: (value) {
                                coin = int.parse(value!);
                              },
                              onChanged: (value) {
                                coin = int.parse(value);
                              },
                              decoration: inputTextFormField.basicFormDeco(
                                  "coin"),
                            ),
                          ),
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () async {
                              int MyCoin = await usermethod.getCoin(user!.uid);
                              if (MyCoin >= coin) {
                                int result =
                                await usermethod.changeCoinByMaster(
                                    SelectedUser, coin, true);
                                if (result != 00) {
                                  usermethod.useCoin(user!.uid, coin);
                                  myNotification.SnackbarBasic(context,
                                      "송금 성공! (잔액: ${MyCoin - coin})");
                                  setState(() {});
                                  print(SelectedUser);
                                  nc.sendNotification("코인이 입금되었습니다",
                                      "${await usermethod.getUserNameByUid(user!.uid)}님께서 ${coin}코인을 입금하였습니다.",
                                      await usermethod.getUserUidByName(SelectedUser));
                                } else {
                                  myNotification.SnackbarBasic(
                                      context, "오류!");
                                }
                                setState(() {});
                                cc.count(user.uid);
                              }
                              else {
                                myNotification.SnackbarBasic(
                                    context, "잔액이 부족합니다!");
                              }
                              setState(() {

                              });
                            },
                            child: const Text(
                              "송금하기",
                              style: TextStyle(color: Colors.black),
                            )),
                      ],
                    ),
                  ],
                );
              }
              return const Text("로딩중");
            },
          ),

        ],)
      ),
    );
  }
}
