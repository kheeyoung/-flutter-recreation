import 'package:flutter/material.dart';
import 'package:myapp/method/boardMethod.dart';
import 'package:myapp/widget/header.dart';
import 'package:myapp/widget/inputTextFormField.dart';
import 'package:myapp/widget/myNotification.dart';

class Deletepost extends StatefulWidget {
  const Deletepost({super.key});

  @override
  State<Deletepost> createState() => _DeletepostState();
}

class _DeletepostState extends State<Deletepost> {
  Header header = Header();
  InputTextFormField inputTextFormField = InputTextFormField();
  String postUid="";
  MyNotification myNotification = MyNotification();
  Boardmethod boardmethod=Boardmethod();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: header.screenHeader(context, "글 삭제"),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),

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


              ],
            ),
          ),
        ),
      ),
    );
  }
}
