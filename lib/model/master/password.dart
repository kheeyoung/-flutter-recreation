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
  String SelectedUser = "";
  String newPassword="";
  MyNotification myNotification = MyNotification();
  ListViewWidget listViewWidget=ListViewWidget();
  Keymethod keymethod=Keymethod();
  String SelectedKey="";




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
            child: Column(
              children: [
                const SizedBox(height: 20),

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



              ],
            ),
          ),
        ),
      ),
    );
  }
}
