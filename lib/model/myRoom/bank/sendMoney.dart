import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/DTO/inquiryDTO.dart';
import 'package:myapp/DTO/personalAlarm.dart';
import 'package:myapp/model/widget/header.dart';
import 'package:myapp/service/alarmMethod.dart';

import '../../../service/coinService.dart';
import '../../../service/notification_controller.dart';
import '../../../service/userMethod.dart';
import '../../widget/dropDownWidget.dart';
import '../../widget/inputTextFormField.dart';
import '../../widget/listViewWidget.dart';
import '../../widget/myNotification.dart';

class Sendmoney extends StatefulWidget {
  const Sendmoney({super.key});

  @override
  State<Sendmoney> createState() => _SendmoneyState();
}

class _SendmoneyState extends State<Sendmoney> {
  Usermethod um = Usermethod();
  ListViewWidget listViewWidget = ListViewWidget();
  InputTextFormField itff = InputTextFormField();
  MyNotification mn = MyNotification();
  CoinService cs = CoinService();
  NotificationController nc = NotificationController();
  Dropdownwidget dw = Dropdownwidget();
  AlarmMethod am = AlarmMethod();
  Header header = Header();

  final user = FirebaseAuth.instance.currentUser;
  String selectedUser = "";
  int coin = 0;
  String memo="유저 코인 입금";
  bool loading = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header.NotHeader(context, "Send Money",
            "송금시 수령자에게 알림이 갑니다. \n"
                "메모 미 입력시 기본 텍스트로 전송됩니다.\n"
                "오류가 발생할 수 있으니 연타는 삼가주세요."),
      body: ModalProgressHUD(
          inAsyncCall: loading,
          child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
            child: FutureBuilder(
              future: Future.wait([um.getUser(), cs.getCoin(user!.uid)]),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {

                  return Container(
                    margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Column(

                      children: [

                        //수신인, 선물 선택
                        Row(
                          children: [
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
                            Text("님께")
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,

                              child: TextFormField(
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: itff.noMarginFormDeco(""),
                                maxLength: 3,
                                key: ValueKey(1),
                                onSaved: (value) {
                                  coin = int.parse(value!);
                                },
                                onChanged: (value) {
                                  coin = int.parse(value);
                                },
                                style: TextStyle(fontSize: 50),
                              ),
                            ),
                            SizedBox(width: 20,),
                            Text("coin", style: TextStyle(fontSize: 15))
                          ],
                        ),
                        SizedBox(height: 20,),
                        Text("보낼까요?", style: TextStyle(color: Colors.black54),),
                        SizedBox(height: 20,),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black12,
                            child: Text("보유 코인 : ${snapshot.data[1]}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(border: Border.all(color: Colors.black12, width: 1)),
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                            children: [
                              SizedBox(
                                  width:MediaQuery.of(context).size.width*0.2,
                                  child: Text("Memo : ")
                              ),

                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.5 ,
                                child: TextFormField(
                                  initialValue: memo,
                                  style: const TextStyle(
                                      fontSize: 15,
                                    color: Colors.black54
                                  ),
                                    decoration: itff.noMarginFormDeco(""),
                                  maxLength: 10,
                                  key: ValueKey(2),
                                  onSaved: (value) {
                                    memo = value!;
                                  },
                                  onChanged: (value) {
                                    memo = value!;
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20,),
                        OutlinedButton(
                            onPressed: () async {
                              setState(() {
                                loading=true;
                              });
                              if(selectedUser=="" || coin==0){
                                mn.SnackbarBasic(context, "수신인과 입금 금액을 입력해주세요.");
                                setState(() {
                                  loading=false;
                                });
                                return;}

                              if(memo==""){memo=" ";}
                              String selectedUserUid = snapshot.data[0][selectedUser];
                              String myName= await um.getUserNameByUid(user!.uid);
                              if(await cs.sendCoinByUser(user!.uid, coin, selectedUserUid, context)){
                                await cs.makeInquiry(user!.uid,Inquirydto(-coin, memo, myName, ""));

                                sleep(const Duration(seconds: 1));
                                await cs.makeInquiry(selectedUserUid,Inquirydto(coin, memo, myName, ""));

                                await nc.sendNotification("$coin 코인이 입금되었습니다.", memo, selectedUserUid);
                              }

                              setState(() {loading=false;});
                            },
                            child: const Text("송금하기", style: TextStyle(color: Colors.black),

                            )
                        )
                      ],
                    ),
                  );
                }
                return const Text("로딩중");
              },
            )
        ),
      ))
    );
  }
}
