import 'package:flutter/material.dart';

import '../../service/mapService.dart';
import '../widget/header.dart';
import '../widget/inputTextFormField.dart';
import '../widget/myNotification.dart';


class Movebody extends StatefulWidget {
  const Movebody({super.key});

  @override
  State<Movebody> createState() => _MovebodyState();
}

class _MovebodyState extends State<Movebody> {
  Header header = Header();

  InputTextFormField inputTextFormField = InputTextFormField();

  MyNotification myNotification = MyNotification();


  String bodyNum="";
  String Room="";
  String item1="";
  String item2="";
  String item3="";
  String item4="";
  String item5="";
  String txt="";




  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: header.screenHeader(context, "시체 위치 변경"),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [

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
