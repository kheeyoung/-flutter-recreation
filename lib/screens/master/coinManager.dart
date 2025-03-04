import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/method/userMethod.dart';
import 'package:myapp/widget/header.dart';
import 'package:myapp/widget/inputTextFormField.dart';
import 'package:myapp/widget/listViewWidget.dart';
import 'package:myapp/widget/myNotification.dart';

class Coinmanager extends StatefulWidget {
  const Coinmanager({super.key});

  @override
  State<Coinmanager> createState() => _CoinmanagerState();
}

class _CoinmanagerState extends State<Coinmanager> {
  Header header = Header();
  Usermethod usermethod = Usermethod();
  InputTextFormField inputTextFormField = InputTextFormField();
  String SelectedUser = "";
  int coin = 0;

  MyNotification myNotification = MyNotification();
  ListViewWidget listViewWidget = ListViewWidget();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: header.screenHeader(context, "코인 관리"),
          body: SingleChildScrollView(
            child: Center(
              child: Column(children: [

                FutureBuilder(
                    future: Future.wait(
                        [usermethod.getUserName(), usermethod.getAllCoin()]),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        List userNames = snapshot.data[0];
                        List userCoins = snapshot.data[1];

                        List<Widget> coinList = listViewWidget
                            .showUserCoinAndLike(userCoins, context);

                        return Column(children: [
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
                                      .map((e) => DropdownMenuItem(
                                            value: e.toString(),
                                            child: Text(
                                              e.toString(),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ))
                                      .toList(),
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
                                    decoration: inputTextFormField
                                        .basicFormDeco("coin"),
                                  ),
                                ),
                              ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    int result =
                                        await usermethod.changeCoinByMaster(
                                            SelectedUser, coin, true);
                                    if (result != 00) {
                                      myNotification.SnackbarBasic(
                                          context,
                                          "추가 성공! (보유 코인: " +
                                              result.toString() +
                                              ")");
                                    } else {
                                      myNotification.SnackbarBasic(
                                          context, "오류!");
                                    }
                                    setState(() {});
                                  },
                                  child: const Text(
                                    "추가하기",
                                    style: TextStyle(color: Colors.black),
                                  )),
                              TextButton(
                                  onPressed: () async {
                                    int result =
                                        await usermethod.changeCoinByMaster(
                                            SelectedUser, coin, false);
                                    if (result != 00) {
                                      myNotification.SnackbarBasic(
                                          context,
                                          "차감 성공! (보유 코인: " +
                                              result.toString() +
                                              ")");
                                    } else {
                                      myNotification.SnackbarBasic(
                                          context, "오류!");
                                    }
                                    setState(() {});
                                  },
                                  child: const Text(
                                    "차감하기",
                                    style: TextStyle(color: Colors.black),
                                  ))
                            ],
                          ),
                          const SizedBox(width: 350, child: Divider()),
                          const SizedBox(height: 10,),

                          //코인+호감도
                          const Text("코인 / 호감도 보유 현황", style: TextStyle(fontSize: 17)),

                          const SizedBox(height: 10,),

                          SingleChildScrollView(
                            child: SizedBox(
                              height: 300,
                              child: ListView(
                                children: coinList,
                              ),
                            ),
                          ),
                        ]);
                      }
                      return Text("loading");
                    }),
              ]),
            ),
          ),
        ));
  }
}
