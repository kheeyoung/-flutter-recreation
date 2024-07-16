import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/method/userMethod.dart';
import 'package:myapp/screens/menu.dart';
import 'package:myapp/screens/usersetting.dart';
import 'package:myapp/widget/header.dart';
import 'package:myapp/widget/inputTextFormField.dart';
import 'package:myapp/widget/myNotification.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    String userEmail ="";
    String userPw = "";
    final _authentication = FirebaseAuth.instance;
    bool showSpinner = false; //로딩 화면 표시용
    Usermethod usermethod = Usermethod();
    MyNotification myNotification=MyNotification();

    Header header=Header();
    InputTextFormField inputTextFormField = InputTextFormField();

    return Scaffold(

      //appBar: header.Loginheader("Login"),
      body: ModalProgressHUD(
          //로딩용
          inAsyncCall: showSpinner,
          child: Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){FocusScope.of(context).unfocus();},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("LOGIN",
                      style: TextStyle(fontSize: 30),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                        controller: TextEditingController(text: ""),
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey(1),
                        onSaved: (value) {
                          userEmail = value!;
                        },
                        onChanged: (value) {
                          userEmail = value;
                        },
                        decoration:
                            inputTextFormField.basicFormDeco("E-mail을 입력해주세요.")),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: TextEditingController(text: ""),
                        obscureText: true,
                        //입력하는 값 안보이게 하기
                        key: ValueKey(2),
                        onSaved: (value) {
                          userPw = value!;
                        },
                        onChanged: (value) {
                          userPw = value;
                        },
                        decoration: inputTextFormField
                            .basicFormDeco("Password를 입력해주세요.")),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 150,
                      height: 40,
                      child: TextButton(
                          onPressed: () async {
                            setState(() {
                              showSpinner = true; //로딩 보이게 함
                            });
                            String result="";

                            //로그인 시도
                            if(userEmail.isNotEmpty && userPw.isNotEmpty){
                              try{
                                //이메일, 비번으로 로그인
                                await _authentication.signInWithEmailAndPassword(
                                    email: userEmail, password: userPw);
                                result= "로그인 성공!";
                              }
                              on FirebaseAuthException catch (e) {
                                result= "이메일과 패스워드를 확인해주세요.";
                              }
                            }
                            else{
                              result= "이메일과 패스워드를 모두 입력해주세요.";
                            }
                            //로그인 성공시 최초 로그인 여부 확인
                            if (result == "로그인 성공!") {
                              final user =
                                  _authentication.currentUser; //유저정보 가져오기
                              int FirstLogin =
                                  await usermethod.checkFirstLogIn(user!.uid);
                              var Screen;

                              //최초 로그인의 경우 유저 정보 세팅창으로 이동
                              if (FirstLogin != 1) {
                                Screen = UserSetting();
                              }
                              //최초가 아니면 메뉴창으로 이동
                              else {
                                Screen = Menu();
                              }

                              //화면 이동
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Screen;
                              }));
                            }

                            //확인 메시지 출력
                            myNotification.SnackbarBasic(context, result);


                            setState(() {
                              userEmail=userEmail;
                              userPw=userPw;
                              showSpinner = false; //로딩 안보이게 함
                            });
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.black54),
                          child: const Text("로그인",
                              style: TextStyle(color: Colors.white, fontSize: 15))),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
