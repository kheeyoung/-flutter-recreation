import 'package:flutter/material.dart';
import '../../service/keyMethod.dart';
import '../../service/userMethod.dart';
import '../widget/header.dart';
import '../widget/inputTextFormField.dart';
import '../widget/listViewWidget.dart';
import '../widget/myNotification.dart';

class Password extends StatefulWidget {
  const Password({super.key});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  Header header = Header();
  Usermethod usermethod = Usermethod();
  InputTextFormField inputTextFormField = InputTextFormField();

  String selectedMap = "";
  String newMapPw = "";
  String newMatserPw = "";

  MyNotification myNotification = MyNotification();
  ListViewWidget listViewWidget = ListViewWidget();
  Keymethod keymethod = Keymethod();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: header.screenHeader(context, "PW 관리"),
            body: SingleChildScrollView(
                child: Center(
                    child: Column(children: [
                      const SizedBox(height: 20),
                      Text("Master PassWord"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 160,
                            child: TextFormField(
                              maxLength: 10,
                              key: ValueKey(2),
                              onSaved: (value) {
                                newMatserPw = value!;
                                },
                              onChanged: (value) {
                                newMatserPw = value;
                                },
                              decoration: inputTextFormField.basicFormDeco("password"),
                            ),
                          ),
                          OutlinedButton(
                              onPressed: () async {
                                int num = await keymethod.ChangePw(newMatserPw, "masterkey");
                                String result = num == 1 ? "변경 성공!" : "오류!";
                                myNotification.SnackbarBasic(context, result);
                                },
                              child: Text("변경")
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ]
                    )
                )
            )
        )
    );
  }
}
