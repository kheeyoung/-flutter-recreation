import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:myapp/model/widget/dropDownWidget.dart';
import 'package:myapp/service/coinService.dart';

import '../../DTO/inquiryDTO.dart';
import '../../DTO/personalAlarm.dart';
import '../../service/alarmMethod.dart';
import '../../service/notification_controller.dart';
import '../../service/userMethod.dart';
import '../widget/header.dart';
import '../widget/inputTextFormField.dart';
import '../widget/listViewWidget.dart';
import '../widget/myNotification.dart';


class Coinmanager extends StatefulWidget {
  const Coinmanager({super.key});

  @override
  State<Coinmanager> createState() => _CoinmanagerState();
}

class _CoinmanagerState extends State<Coinmanager> {
  Header header = Header();
  Usermethod um = Usermethod();
  String selectedUser = "";
  int coin = 0;
  String memo="";

  MyNotification mn = MyNotification();
  ListViewWidget lw = ListViewWidget();
  InputTextFormField itff = InputTextFormField();
  CoinService cs = CoinService();
  NotificationController nc = NotificationController();
  Dropdownwidget dw = Dropdownwidget();
  AlarmMethod am = AlarmMethod();



  @override
  Widget build(BuildContext context) {
    double fullWidth =MediaQuery.of(context).size.width;
    List<String> memoList= ["일상이벤트", "일상조사","시체발견조사", "챕터 참가", "직접 입력"];
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
                    future: Future.wait([um.getUser(), cs.getAllCoin(),lw.showUserCoinAndLike(fullWidth*0.8, context)]),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {

                        return Column(children: [
                          const SizedBox(height: 20),
                          //수신인, 선물 선택
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("수신인 : "),
                                DropdownButton<String>(
                                  value: selectedUser.isNotEmpty ? selectedUser : null,
                                  items: dw.makeItems(snapshot.data[0].keys.toList()),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedUser = newValue!;
                                    });
                                  },
                                  dropdownColor: Colors.white,
                                  iconSize: 40,
                                ),
                                SizedBox(width: 10,),
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
                                    decoration: itff
                                        .basicFormDeco("coin"),
                                  ),
                                ),
                              ]),
                          SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Memo : "),
                                DropdownButton<String>(
                                  value: memoList.contains(memo) ? memo : null,  // 유효한 값만 설정
                                  items: dw.makeItems(memoList),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      memo = newValue ?? ""; // 올바르게 값 변경
                                    });
                                  },
                                  dropdownColor: Colors.white,
                                  iconSize: 40,
                                )

                              ],
                            ),
                          ),
                          SizedBox(
                            width: fullWidth*0.6,
                            child: TextFormField(
                              enabled: memo== memoList[4],
                              maxLength: 10,
                              key: ValueKey(1),
                              onSaved: (value) {memo=value!;},
                              onChanged: (value) {memo=value!;},
                              decoration: itff.noMarginFormDeco(""),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    if(memo=="" || memo==memoList[4]){memo=" ";}
                                    String selectedUid = snapshot.data[0][selectedUser];
                                    int orgin = snapshot.data[1][selectedUid] ?? 0;

                                    await cs.changeCoin(orgin+coin, selectedUid);
                                    await cs.makeInquiry(selectedUid,Inquirydto(coin, memo, "System", ""));
                                    await nc.sendNotification("$coin 코인이 입금되었습니다.", memo, selectedUid);
                                    //await am.addAlarm(PersonalAlarm("$coin 코인이 입금되었습니다.", memo, DateFormat('yyMMddHHmmss').format(DateTime.now())), selectedUid);

                                    mn.SnackbarBasic(context, "입금 성공 (잔여 코인 : ${orgin+coin})");

                                    setState(() {});

                                  },
                                  child: Text("추가하기")
                              )
                            ],
                          ),
                          const SizedBox(width: 350, child: Divider()),
                          const SizedBox(height: 10,),

                          //코인+호감도
                          const Text("코인 / 호감도 보유 현황", style: TextStyle(fontSize: 17)),
                          Column(children: snapshot.data[2]),
                          const SizedBox(height: 10,),


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
