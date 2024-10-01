import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/DTO/myMap.dart';
import 'package:myapp/method/boardMethod.dart';
import 'package:myapp/method/keyMethod.dart';
import 'package:myapp/method/mapMethod.dart';
import 'package:myapp/method/userMethod.dart';
import 'package:myapp/widget/header.dart';
import 'package:myapp/widget/inputTextFormField.dart';
import 'package:myapp/widget/listViewWidget.dart';
import 'package:myapp/widget/myNotification.dart';

class Masterpage extends StatefulWidget {
  const Masterpage({super.key});

  @override
  State<Masterpage> createState() => _MasterpageState();
}

class _MasterpageState extends State<Masterpage> {
  Header header = Header();
  Usermethod usermethod = Usermethod();
  InputTextFormField inputTextFormField = InputTextFormField();
  String SelectedUser = "";
  int coin = 0;
  String newPassword="";
  String postUid="";
  MyNotification myNotification = MyNotification();
  ListViewWidget listViewWidget=ListViewWidget();
  Keymethod keymethod=Keymethod();
  Boardmethod boardmethod=Boardmethod();
  String SelectedKey="";

  String bodyNum="";
  String Room="";
  String item1="";
  String item2="";
  String item3="";
  String item4="";
  String item5="";
  String txt="";

  Mapmethod mapmethod= Mapmethod();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: header.screenHeader(context, "관리자 페이지"),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "코인 관리",
                  style: TextStyle(fontSize: 17),
                ),
                FutureBuilder(
                  future: Future.wait(
                      [usermethod.getUserName(), usermethod.getAllCoin()]),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List userNames = snapshot.data[0];
                      List userCoins = snapshot.data[1];

                      List<Widget> coinList = listViewWidget.showUserCoinAndLike(userCoins,context);

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
                                      .map((e) => DropdownMenuItem(
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
                                    decoration: inputTextFormField.basicFormDeco("coin"),
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
                                        await usermethod.changeCoinByMaster(SelectedUser, coin, true);
                                    if (result != 00) {
                                      myNotification.SnackbarBasic(context,
                                          "추가 성공! (보유 코인: " + result.toString() + ")");
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
                                          "차감 성공! (보유 코인: " + result.toString() + ")");
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
                        ],
                      );
                    }
                    return const Text("로딩중");
                  },
                ),

                //비번 변경
                const SizedBox(width: 350, child: Divider()),
                Text("패스워드 변경",style: TextStyle(fontSize: 17),),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Text("신규 비밀번호 : "),
                    SizedBox(
                      width: 160,
                      child: TextFormField(
                        maxLength: 10,
                        key: ValueKey(2),
                        onSaved: (value) {
                          newPassword = value!;
                          },
                        onChanged: (value) {
                          newPassword = value;
                          },
                        decoration: inputTextFormField.basicFormDeco("password"),
                      ),
                    ),
                    DropdownButton<String>(
                      value: SelectedKey.isNotEmpty ? SelectedKey : null,
                      items: ["masterkey","map1","map2","map3","map4","map5"]
                          .map((e) => DropdownMenuItem(
                        value: e.toString(),
                        child: Text(e.toString(),style: TextStyle(color: Colors.black),),
                      )).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          SelectedKey = newValue!;
                        });
                      },
                      dropdownColor: Colors.white,
                      iconSize: 50,
                    )
                  ],
                ),
                OutlinedButton(
                    onPressed: ()async{
                      int num=await keymethod.ChangePw(newPassword,SelectedKey);
                      String result=num==1 ? "변경 성공!": "오류!";
                      myNotification.SnackbarBasic(context, result);
                    },
                    child: Text("변경")
                ),
                SizedBox(height: 15,),

                //글 삭제
                const SizedBox(width: 350, child: Divider()),
                Text("글 삭제",style: TextStyle(fontSize: 17),),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("글 작성일(uid) : "),
                    SizedBox(
                      width: 160,
                      child: TextFormField(
                        maxLength: 12,
                        key: ValueKey(3),
                        onSaved: (value) {
                          postUid = value!;
                        },
                        onChanged: (value) {
                          postUid = value;
                        },
                        decoration: inputTextFormField.basicFormDeco("yymmddHHmmss"),
                      ),
                    ),
                  ],
                ),
                OutlinedButton(
                    onPressed: ()async{
                      int num=await boardmethod.deletePost(postUid);
                      String result=num==1 ? "삭제 성공!": "오류!";
                      myNotification.SnackbarBasic(context, result);
                    },
                    child: Text("삭제")
                ),
                SizedBox(height: 15,),


                //시체 위치 바꾸기
                const SizedBox(width: 350, child: Divider()),
                Text("시체 위치 변경",style: TextStyle(fontSize: 17),),
                SizedBox(height: 15,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Room : "),
                    SizedBox(
                      width: 160,
                      child: TextFormField(
                        maxLength: 12,
                        key: ValueKey(4),
                        onSaved: (value) {
                          Room = value!;
                        },
                        onChanged: (value) {
                          Room = value;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("item1 : "),
                    SizedBox(
                      width: 160,
                      child: TextFormField(
                        maxLength: 12,
                        key: ValueKey(5),
                        onSaved: (value) {
                          item1 = value!;
                        },
                        onChanged: (value) {
                          item1 = value;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("item2 : "),
                    SizedBox(
                      width: 160,
                      child: TextFormField(
                        maxLength: 12,
                        key: ValueKey(6),
                        onSaved: (value) {
                          item2 = value!;
                        },
                        onChanged: (value) {
                          item2 = value;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("item3 : "),
                    SizedBox(
                      width: 160,
                      child: TextFormField(
                        maxLength: 12,
                        key: ValueKey(7),
                        onSaved: (value) {
                          item3 = value!;
                        },
                        onChanged: (value) {
                          item3 = value;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("item4 : "),
                    SizedBox(
                      width: 160,
                      child: TextFormField(
                        maxLength: 12,
                        key: ValueKey(8),
                        onSaved: (value) {
                          item4 = value!;
                        },
                        onChanged: (value) {
                          item4 = value;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("item5 : "),
                    SizedBox(
                      width: 160,
                      child: TextFormField(
                        maxLength: 12,
                        key: ValueKey(9),
                        onSaved: (value) {
                          item5 = value!;
                        },
                        onChanged: (value) {
                          item5 = value;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("시체 번호 : "),
                    SizedBox(
                      width: 160,
                      child: TextFormField(
                        maxLength: 12,
                        key: ValueKey(10),
                        onSaved: (value) {
                          txt = value!;
                        },
                        onChanged: (value) {
                          txt = value;
                        },
                      ),
                    ),
                  ],
                ),
                OutlinedButton(
                    onPressed: ()async{
                      int num=await mapmethod.changebody(Room,item1,item2,item3,item4,item5,txt);
                      String result=num==1 ? "변경 성공!": "오류!";
                      myNotification.SnackbarBasic(context, result);

                      setState(() {
                        Room="";
                        item1="";
                        item2="";
                        item3="";
                        item4="";
                        item5="";
                        txt="";
                      });
                    },
                    child: Text("변경")
                ),
                SizedBox(height: 15,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
