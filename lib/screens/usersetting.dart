import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/method/giftMethod.dart';
import 'package:myapp/method/userMethod.dart';
import 'package:myapp/screens/menu.dart';
import 'package:myapp/widget/header.dart';
import 'package:myapp/widget/inputTextFormField.dart';
import 'package:myapp/widget/myNotification.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({super.key});

  @override
  State<UserSetting> createState() => _UsersettingState();
}

class _UsersettingState extends State<UserSetting> {
  //필요 변수 선언
  String? userName;
  String? firstGift;
  String? secondGift;
  String? thirdGift;
  User? loggedUser;
  bool showSpinner = false;
  final _authentication = FirebaseAuth.instance;
  Usermethod usermethod = new Usermethod();
  Giftmethod giftmethod = new Giftmethod();
  Header header = Header();
  InputTextFormField inputTextFormField = InputTextFormField();
  MyNotification myNotification=MyNotification();

  int checkItem1=0;
  int checkItem2=0;
  int checkItem3=0;


  @override
  Widget build(BuildContext context) {
    final user = _authentication.currentUser;
    return Scaffold(
        appBar: header.basicHeader(context, "유저 정보 최초 등록", _authentication),
        body: ModalProgressHUD(
          //로딩용
          inAsyncCall: showSpinner,

          child: SingleChildScrollView(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 15,),
                  const Text(
                    "캐릭터 정보 등록",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("이름 : "),
                      Container(
                        width: 200,
                
                        child: TextFormField(
                          key: ValueKey(1),
                          maxLength: 12,
                          onSaved: (value) {
                            userName = value!;
                          },
                          onChanged: (value) {
                            userName = value;
                          },
                          decoration:
                              inputTextFormField.basicFormDeco("Character name"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(width: 350, child: Divider()),
                  const SizedBox(height: 20,),
                  const Text(
                    "호감도 물품 등록",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("호감도 물품1 : "),
                      Container(
                        width: 200,
                        child: TextFormField(
                          key: ValueKey(2),
                          maxLength: 10,
                          onSaved: (value) {
                            firstGift = value!;
                          },
                          onChanged: (value) {
                            firstGift = value;
                          },
                          decoration:
                              inputTextFormField.basicFormDeco("Gift name 1"),
                        ),
                      ),
                      SizedBox(width: 5,),
                      OutlinedButton(
                          onPressed:()async {
                            checkItem1=await giftmethod.checkItemButtonMethod(firstGift,context);
                          },
                          child: Text("중복 확인",style: TextStyle(color: Colors.black),))
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("호감도 물품2 : "),
                      Container(
                        width: 200,
                        child: TextFormField(
                          key: ValueKey(3),
                          maxLength: 10,
                          onSaved: (value) {
                            secondGift = value!;
                          },
                          onChanged: (value) {
                            secondGift = value;
                          },
                          decoration:
                              inputTextFormField.basicFormDeco("Gift name 2"),
                        ),
                      ),
                      SizedBox(width: 5,),
                      OutlinedButton(
                          onPressed:()async {
                            checkItem2=await giftmethod.checkItemButtonMethod(secondGift,context);
                          },
                          child: Text("중복 확인",style: TextStyle(color: Colors.black),))
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("호감도 물품3 : "),
                      Container(
                        width: 200,
                        child: TextFormField(
                          key: ValueKey(4),
                          maxLength: 10,
                          onSaved: (value) {
                            thirdGift = value!;
                          },
                          onChanged: (value) {
                            thirdGift = value;
                          },
                          decoration:
                              inputTextFormField.basicFormDeco("Gift name 3"),
                        ),
                      ),
                      SizedBox(width: 5,),
                      OutlinedButton(
                          onPressed:()async {
                            checkItem3=await giftmethod.checkItemButtonMethod(thirdGift,context);
                          },
                          child: Text("중복 확인",style: TextStyle(color: Colors.black),))
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.black54),
                      onPressed: () async {
                      if(checkItem1==1&&checkItem2==1&&checkItem3==1
                      &&firstGift!=secondGift&&firstGift!=thirdGift&&secondGift!=thirdGift
                      ){
                        if (userName != null &&
                            firstGift != null &&
                            secondGift != null &&
                            thirdGift != null) {
                          //값이 다 있다면
                          setState(() {
                            showSpinner = true; //로딩 보이게 함
                          });
                          String message = ""; //확인 문구
                          try {
                            //이미 등록 된 적 있나 확인
                            final user = _authentication.currentUser; //유저정보 가져오기
                            int result = await usermethod.checkFirstLogIn(user!.uid);

                            if (result == 1) {
                              //최초 로그인이 아닌 경우
                              message = "이미 등록 된 유저 입니다.";
                            } else {
                              //정보를 등록
                              usermethod.RegistUser(user!.email, user!.uid, userName); //유저정보
                              giftmethod.RegistGift(user!.uid, "1", firstGift, user!.uid); //선물 등록
                              giftmethod.RegistGift(user!.uid, "2", secondGift, user!.uid);
                              giftmethod.RegistGift(user!.uid, "3", thirdGift, user!.uid);
                              if (mounted) {
                                message = "등록 성공!";
                              }
                            }
                            //화면 이동
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return Menu();
                                }));
                          }
                          catch (e) {
                            if (mounted) {
                              message = "오류 발생!";
                            }
                          }
                          //안내 문구 출력
                          myNotification.SnackbarBasic(context, "등록 성공!");
                          setState(() {
                            showSpinner = false; //로딩 안 보이게 함
                          });
                        }
                      }
                      else{
                        myNotification.SnackbarBasic(context, "선물 중복 확인을 해주세요.");
                      }

                      },
                      child: Text("등록하기", style: TextStyle(color: Colors.white),))
                ],
              ),
            ),
          ),
        )
    );
  }
}
