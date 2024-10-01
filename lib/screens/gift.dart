import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/method/giftMethod.dart';
import 'package:myapp/method/itemMethod.dart';
import 'package:myapp/method/userMethod.dart';
import 'package:myapp/widget/header.dart';
import 'package:myapp/widget/inputTextFormField.dart';
import 'package:myapp/widget/myNotification.dart';

class Gift extends StatefulWidget {
  const Gift({super.key});

  @override
  State<Gift> createState() => _GiftState();
}

class _GiftState extends State<Gift> {
  Map recipientsMap = {};
  Map GiftMap = {};

  String SelectedRecipient = "";
  String SelectedGift = "";

  String title = "";
  String contents = "";

  int re = 0;

  Usermethod usermethod = new Usermethod();
  Itemmethod itemmethod = new Itemmethod();
  Giftmethod giftmethod = new Giftmethod();
  InputTextFormField inputTextFormField = InputTextFormField();
  Header header = Header();
  MyNotification myNotification = MyNotification();

  final _authentication = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _authentication.currentUser;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: header.screenHeader(context, "Gift"),
        body: SingleChildScrollView(
          child: Center(
            child: FutureBuilder(
              future: Future.wait(
                  [usermethod.getUserName(), itemmethod.getMyItem(user!.uid)]),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  //Map로 받아 온 값 list에 넣기
                  List userNames = snapshot.data![0];
                  List myItem = snapshot.data![1].keys.toList();

                  return Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),

                      //제목
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("제목 : "),
                            SizedBox(
                              width: 262,
                              child: TextFormField(
                                maxLength: 100,
                                key: ValueKey(1),
                                onSaved: (value) {title = value!;},
                                onChanged: (value) {title = value;},
                                decoration: inputTextFormField
                                    .basicFormDeco("제목을 입력해주세요."),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //수신인
                      SizedBox(
                        width: 300,
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("수신인 : "),
                            SizedBox(
                              width: 249,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: SelectedRecipient.isNotEmpty
                                    ? SelectedRecipient
                                    : null,
                                items: userNames
                                    .map((e) => DropdownMenuItem(
                                  value: e.toString(),
                                  child: Text(
                                    e.toString(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ))
                                    .toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    SelectedRecipient = newValue!;
                                  });
                                },
                                dropdownColor: Colors.white,
                                iconSize: 50,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      //선물
                      SizedBox(
                        width: 300,
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("보낼 선물 : "),
                            SizedBox(
                              width: 232,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: SelectedGift.isNotEmpty ? SelectedGift : null,
                                items: myItem
                                    .map((e) => DropdownMenuItem(
                                  value: e.toString(),
                                  child: Text(
                                    e.toString(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ))
                                    .toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    SelectedGift = newValue!;
                                  });
                                },
                                dropdownColor: Colors.white,
                                iconSize: 50,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      //내용
                      SizedBox(
                        width: 300,
                        height: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("내용 : "),
                            SizedBox(
                              width: 262,
                              height: 200,
                              child: TextFormField(
                                maxLines: 10,
                                maxLength: 200,
                                key: ValueKey(2),
                                onSaved: (value) {
                                  contents = value!;
                                },
                                onChanged: (value) {
                                  contents = value;
                                },
                                decoration: inputTextFormField
                                    .basicFormDeco("내용을 입력해주세요."),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      //확인 버튼
                      OutlinedButton(
                          onPressed: () async {
                            if (title.isNotEmpty &&
                                contents.isNotEmpty &&
                                SelectedGift != "" &&
                                SelectedRecipient != "") {
                              //board DB에 글 등록
                              String recipientUid = await usermethod
                                  .getUserUidByName(SelectedRecipient);

                              await giftmethod.SendGift(
                                  SelectedGift,
                                  user.uid,
                                  recipientUid,
                                  title,
                                  contents,
                                  SelectedRecipient);

                              //아이템 사용 전환 (가장 오래 된 것 부터 사용)
                              int result = await giftmethod.useItem(
                                  SelectedGift, user.uid);

                              if (result != 0) {
                                //만약 없는 아이템을 사용한 경우
                                myNotification.SnackbarBasic(context,
                                    "오류! 새로고침 후 다시 시도해주세요. 오류가 계속 될 경우 총괄계 제보 바랍니다.");
                              } else {
                                //잘 보내진 경우
                                //호감도 체크
                                if (recipientUid ==
                                    snapshot.data![1][SelectedGift]) {
                                  giftmethod.addLikePoint(
                                      user.uid, recipientUid, SelectedGift);
                                }
                                myNotification.SnackbarBasic(
                                    context, "선물 발송 완료!!");
                              }

                              setState(() {
                                SelectedGift = "";
                              });
                            } else {
                              myNotification.SnackbarBasic(
                                  context, "제목, 수신인, 선물, 내용은 필수 항목 입니다.");
                            }
                          },
                          child: Text("선물 보내기"))
                    ],
                  );
                }
                return Text("로딩중");
              },
            ),
          ),
        ),
      ),
    );
  }
}
